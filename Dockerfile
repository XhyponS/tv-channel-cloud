FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y ffmpeg curl ca-certificates
RUN rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com -o mediamtx.tar.gz
RUN tar -xzf mediamtx.tar.gz
RUN rm mediamtx.tar.gz

COPY playlist.txt /playlist.txt

EXPOSE 8554

ENV MTX_PATHS_ALL_SOURCE="runOnDemand: ffmpeg -re -f concat -safe 0 -stream_loop -1 -i /playlist.txt -vf 'subtitles=/playlist.txt' -c:v libx264 -preset ultrafast -c:a copy -f rtsp rtsp://localhost:8554/all"

CMD ["./mediamtx"]
