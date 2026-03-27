{
  description = "Dev shell for viewing RTP streams with GStreamer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        gst = pkgs.gst_all_1;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            gst.gstreamer         # core + gst-launch
            gst.gst-plugins-base
            gst.gst-plugins-good  # RTP, UDP
            gst.gst-plugins-bad   # extra codecs/rtp depay
            gst.gst-plugins-ugly  # more codecs
            gst.gst-libav         # ffmpeg codecs
            gst.gst-plugins-rs
            ffmpeg
            srt-live-server
            gst.gst-rtsp-server
            python3
            python3Packages.pygobject3 
            v4l-utils
          ];
        };
      });
}

