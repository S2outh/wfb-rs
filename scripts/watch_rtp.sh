gst-launch-1.0 -v udpsrc port=5600 \
    caps="application/x-rtp, media=(string)video, encoding-name=(string)H265" ! \
    rtpjitterbuffer latency=500 ! \
    rtph265depay ! \
    decodebin ! \
    videoconvert ! \
    autovideosink
