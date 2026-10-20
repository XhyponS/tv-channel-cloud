# 1. Install system tools, FFmpeg, and MediaMTX dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Download and install the core MediaMTX streaming server
RUN curl -L https://github.com -o mediamtx.tar.gz && \
    tar -xzf mediamtx.tar.gz && \
    rm mediamtx.tar.gz

# 3. Bring in your playlist configuration instructions
COPY playlist.txt /playlist.txt

# 4. Expose the video player stream port
EXPOSE 8554

# 5. Tell the server to boot up and run your subtitled 2-movie loop
CMD ["/bin/sh", "-c", "MTX_PATHS_ALL_SOURCE='runOnDemand: ffmpeg -re -f concat -safe 0 -stream_loop -1 -i /playlist.txt -vf \"subtitles=/playlist.txt\" -c:v libx264 -preset ultrafast -c:a copy -f rtsp rtsp://localhost:8554/all' ./mediamtx"]
