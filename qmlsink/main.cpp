#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickItem>
#include <QRunnable>
#include <gst/gst.h>

class SetPlaying : public QRunnable
{
public:
  SetPlaying(GstElement *);
  ~SetPlaying();

  void run();

private:
  GstElement *pipeline_;
};

SetPlaying::SetPlaying(GstElement *pipeline)
{
  this->pipeline_ = pipeline ? static_cast<GstElement *>(gst_object_ref(pipeline)) : NULL;
}

SetPlaying::~SetPlaying()
{
  if (this->pipeline_)
    gst_object_unref(this->pipeline_);
}

void SetPlaying::run()
{
  if (this->pipeline_)
    gst_element_set_state(this->pipeline_, GST_STATE_PLAYING);
}

int main(int argc, char *argv[])
{
  int ret;

  gst_init(&argc, &argv);

  {
    QGuiApplication app(argc, argv);

    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);

    GstElement *pipeline = gst_parse_launch(R"(
        udpsrc port=5000 caps="application/x-rtp, media=video, encoding-name=H264, payload=96" !
        rtph264depay !
        h264parse !
        openh264dec !
        videoconvert !
        glupload !
        qml6glsink name=sink
    )",
                                            nullptr);
    g_assert(pipeline);
    GstElement *sink = gst_bin_get_by_name(GST_BIN(pipeline), "sink");
    g_assert(sink);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QQuickItem *videoItem;
    QQuickWindow *rootObject;

    /* find and set the videoItem on the sink */
    rootObject = static_cast<QQuickWindow *>(engine.rootObjects().first());
    videoItem = rootObject->findChild<QQuickItem *>("videoItem");
    g_assert(videoItem);
    g_object_set(sink, "widget", videoItem, NULL);

    rootObject->scheduleRenderJob(new SetPlaying(pipeline),
                                  QQuickWindow::BeforeSynchronizingStage);

    ret = app.exec();

    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(pipeline);
  }

  gst_deinit();

  return ret;
}
