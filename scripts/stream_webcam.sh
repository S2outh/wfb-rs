gst-launch-1.0 -v v4l2src device=/dev/video0 ! \
  image/jpeg, width=1280, height=720, framerate=30/1 ! \
  jpegdec ! \
  videoconvert ! \
  x265enc bitrate=2048 tune=zerolatency speed-preset=ultrafast ! \
  h265parse ! \
  rtph265pay config-interval=1 pt=96 ! \
  udpsink host=127.0.0.1 port=5600
