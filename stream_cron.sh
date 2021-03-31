#!/usr/bin/env bash
##	Script per lanciare la diretta su youtube o facebook
#
#	UTILIZZO:
#	./stream_cron.sh [OPZIONI]
#	OPZIONI:
#		-d|--durata hh:mm:ss		Specifica la durata dello stream, deve essere compresa tra 00:00:01 e 24:00:00
#		-yk|--youtube-key <key>		Specifica la chiave da utlizzare con youtube
#		-fk|--facebook-key <key>	Specifica la chiave da utilizzare con facebook
#	CODICI DI USCITA:
#		0 ==> OK
#		1 ==> Opzione specificata non valida oppure errore di ffmpeg
#		2 ==> Formato della durata non corretto

#Telecamere
RTSP_URL="rtsp://192.168.1.93/stream0"
RTSP_URL2="rtsp://user:psw@192.168.0.102:554"

#Streaming su YouTube
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
#YOUTUBE_KEY="0u7z-3w3v-2ks0-7khr-ef5m"

#Streaming su Facebook
FACEBOOK_URL="rtmps://live-api-s.facebook.com:443/rtmp"
#FACEBOOK_KEY="3988476224497178?s_bl=1&s_psm=1&s_sc=3988476294497171&s_sw=0&s_vt=api-s&a=AbyLRoHihZ-YDANs"

#Lettura delle opzioni
USAGE="Utilizzo:\n\t$0 -d|--durata hh:mm:ss -yk|--youtube-key abc-def -fk|--facebook-key ghi-klm\n\n\t-d|--duration hh:mm:ss\t\tspecifica la durata dello stream nel formato hh:mm:ss\n\t-yk|--youtube-key <key>\t\tspecifica la chiave di youtube da utilizzare\n\t-fk|--facebook-key <key>\tspecifica la chiave di facebook da utilizzare.\n" 
	
while [[ $# -gt 0 ]] #Iterazione sui comandi passati in input
do
  option="$1"
  case $option in
    -d|--durata)
    	#controllo tramite regex che l'input sia un tempo valido (00:00:01 <=durata<= 23:59:59 || durata = 24:00:00)
    	if [[ $2 =~ ^(([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][1-9])|24:00:00$ ]]
    	  then
    	   DURATION="$2"
    	  else
    	   echo "Incorrect time format, got: ${2}, expected: 00:00:01<=duration<=24:00:00"
    	   exit 2
    	fi
    	shift 2
    	;;
    -yk|--youtube-key)
        YOUTUBE_KEY="$2"
        shift 2
        ;;
    -fk|--facebook-key)
    	FACEBOOK_KEY="$2"
    	shift 2
    	;;
    *) #default case
	echo "Opzione '$1' non riconosciuta"
    	printf "%b" "$USAGE"
    	exit 1
    	shift
    	;;
  esac
done

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
		-vtag 7 \
		-tune zerolatency \
		-vcodec libx264 \
		-t ${DURATION} \
		-pix_fmt + \
		-c:v copy \
		-c:a aac \
		-strict experimental \
		-b:v 5M \
		-f tee "[f=flv]${YOUTUBE_URL}/${YOUTUBE_KEY}|[f=flv]${FACEBOOK_URL}/${FACEBOOK_KEY}" \		
		-nostdin -nostats
        #$COMMAND &
        #$COMMAND2 &
fi

