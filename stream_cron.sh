#!/usr/bin/env bash

#Telecamere
RTSP_URL="rtsp://192.168.1.93/stream0"
RTSP_URL2="rtsp://user:psw@192.168.0.102:554"

#Streaming su YouTube
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
YOUTUBE_KEY="0u7z-3w3v-2ks0-7khr-ef5m"

#Streaming su Facebook
FACEBOOK_URL="rtmps://live-api-s.facebook.com:443/rtmp"
FACEBOOK_KEY="3988476224497178?s_bl=1&s_psm=1&s_sc=3988476294497171&s_sw=0&s_vt=api-s&a=AbyLRoHihZ-YDANs"

#Varie
SERVICE="ffmpeg"


COMMAND="ffmpeg -f alsa -ac 1 -i hw:1,0 -f lavfi -i anullsrc -rtsp_transport tcp -i ${RTSP_URL} -map 0:a -map 2:v -tune zerolatency -vcodec libx264 -t 12:00:00 -pix_fmt + -c:v copy -c:a aac -strict experimental -b:v 5M -f flv ${YOUTUBE_URL}/${YOUTUBE_KEY} -nostdin -nostats"

COMMAND2="ffmpeg -f alsa -ac 1 -i hw:1,0 -f lavfi -i anullsrc -rtsp_transport tcp -i ${RTSP_URL} -map 0:a -map 2:v -tune zerolatency -vcodec libx264 -t 12:00:00 -pix_fmt + -c:v copy -c:a aac -strict experimental -b:v 5M -f flv ${FACEBOOK_URL}/${FACEBOOK_KEY} -nostdin -nostats"


if /usr/bin/pgrep $SERVICE > /dev/null
then
        echo "${SERVICE} is already running."
else
        echo "${SERVICE} is NOT running! Starting now..."

	${SERVICE} \
		-f alsa -ac 1 -i hw:1,0 \
		-f lavfi -i anullsrc \
		-rtsp_transport tcp -i ${RTSP_URL} \
		-map 0:a -map 2:v \
		-tune zerolatency \
		-vcodec libx264 \
		-t 01:10:00 \
		-pix_fmt + \
		-c:v copy \
		-c:a aac \
		-strict experimental \
		-filter:a "volume=0.1" \
		-b:v 5M \
		-f flv ${YOUTUBE_URL}/${YOUTUBE_KEY} \
		-nostdin -nostats
        #$COMMAND &
        #$COMMAND2 &
fi

