#!/bin/bash

# define global variable to operate log output
output=""
if [ -n "$1" -a "$1" =  "console" ]; then
	output="console"
fi

checkin()
{
	# check the really reqeust via [ echo "curl "$2" ......"]
	login=`curl "$2" \
	  -H 'pragma: no-cache' \
	  -H 'cache-control: no-cache' \
	  -H 'accept: application/json, text/javascript, */*; q=0.01' \
	  -H 'x-requested-with: XMLHttpRequest' \
	  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36' \
	  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
	  -H 'sec-fetch-site: same-origin' \
	  -H 'sec-fetch-mode: cors' \
	  -H 'sec-fetch-dest: empty' \
	  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8' \
	  --compressed \
	  -d "email=$4&passwd=$5&code=$6" \
	  -m 180 -s -w "\t%{http_code}" -c /tmp/cookie.txt `
	  # -m 180 "$7" -s -w "\t%{http_code}" -c /tmp/cookie.txt `
	  # "$7" -v `


	[ "$output" = "console" ] \
		 && printf "$(date '+%Y-%m-%d %H:%M:%S')\t $1\t$login\n" \
		 || printf "$(date '+%Y-%m-%d %H:%M:%S')\t $1\t$login\n" >> /tmp/checkin.log

	http_code=`echo $login | awk '{print $2}'`

	if [ -f "/tmp/cookie.txt" -a "$http_code" -eq "200"  ]
	then 
		min=10 &&  max=20
		rdm=`expr $(date +%N) %  $[$max - $min  + 1] + $min`
		[ "$output" = "console" ] \
			&& { printf "$rdm\t" && sleep $rdm; true; } \
			|| { printf "$rdm\t" >> /tmp/checkin.log && sleep $rdm; }
		checkin=`curl "$3" \
		  -X 'POST' \
		  -H 'content-length: 0' \
		  -H 'pragma: no-cache' \
		  -H 'cache-control: no-cache' \
		  -H 'accept: application/json, text/javascript, */*; q=0.01' \
		  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36' \
		  -H 'x-requested-with: XMLHttpRequest' \
		  -H 'sec-fetch-site: same-origin' \
		  -H 'sec-fetch-mode: cors' \
		  -H 'sec-fetch-dest: empty' \
		  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8' \
		  --compressed \
		  -m 180 -s -w "\t%{http_code}" -b /tmp/cookie.txt`
		[ "$output" = "console" ] \
			&& printf "$(date '+%Y-%m-%d %H:%M:%S')\t$checkin\n" \
			|| printf "$(date '+%Y-%m-%d %H:%M:%S')\t$checkin\n" >> /tmp/checkin.log
	fi
}

start_trojan()
{
	# launch trojan service
	/home/eli/software/stairspeedtest/tools/clients/trojan -c /home/eli/practise/config_trojan.json >/dev/null 2>&1 &
	[ "$output" = "console" ] \
		&& echo 'trojan_service has stared and sleeping 2 sec...' \
		|| echo 'trojan_service has stared and sleeping 2 sec...' >> /tmp/checkin.log
	sleep 2
}
stop_trojan()
{
	# stop trojan service
	_pid=`ps -ef | grep -v grep |  grep "config_trojan.json" | awk '{print $2}'`
	kill -9 $_pid
	wait $_pid 2>/dev/null
	[ "$output" = "console" ] \
		&& echo 'trojan_service has stoped' \
		|| echo 'trojan_service has stoped' >> /tmp/checkin.log
}

start_v2ray()
{
	# launch v2ray service
	/home/eli/software/stairspeedtest/tools/clients/v2ray -config  /home/eli/practise/config_vmess.json >/dev/null 2>&1 &
	[ "$output" = "console" ] \
		&& echo 'v2ray_service has stared and sleeping 2 sec...' \
		|| echo 'v2ray_service has stared and sleeping 2 sec...' >> /tmp/checkin.log
	sleep 2
}

stop_v2ray()
{
	# stop v2ray service
	_pid=`ps -ef | grep -v grep |  grep "config_vmess.json" | awk '{print $2}'`
	kill -9 $_pid
	wait $_pid 2>/dev/null
	[ "$output" = "console" ] \
		&& echo 'v2ray_service has stoped' \
		|| echo 'v2ray_service has stoped' >> /tmp/checkin.log
}

brush_flow()
{
	# start brush flow
	[ "$output" = "console" ] \
		&& { curl -k -s  -m 15 -x socks5://127.0.0.1:65433 -w "time_connect:(%{time_connect})/s||time_total:(%{time_total})/s||speed_download:(%{speed_download})Bytes/s||size_download:(%{size_download})Bytes\n" http://mvn.wtfu.site/nexus/content/groups/public/com/anft/framework/sea/parent/sea-common/1.0-SNAPSHOT/sea-common-1.0-20210114.134012-1.jar -o /tmp/sea-common-SNAPSHOTS.jar ; true; }  \
		||  { curl -k -s -x socks5://127.0.0.1:65433 -w "time_connect:(%{time_connect})/s||time_total:(%{time_total})/s||speed_download:(%{speed_download})Bytes/s||size_download:(%{size_download})Bytes\n" http://mvn.wtfu.site/nexus/content/groups/public/com/anft/framework/sea/parent/sea-common/1.0-SNAPSHOT/sea-common-1.0-20210114.134012-1.jar -o /tmp/sea-common-SNAPSHOTS.jar  >> /tmp/checkin.log;  } 

	# print log
	_pid=`ps -ef | grep -v grep |  grep "$1" | awk '{print $2}'`
	[ "$output" = "console" ] \
		&& printf "$(date '+%Y-%m-%d %H:%M:%S')\tbrush flow complete pid = $_pid\n"  \
		|| printf "$(date '+%Y-%m-%d %H:%M:%S')\tbrush flow complete pid = $_pid\n"  >> /tmp/checkin.log
	
}


[ "$output" =  'console' ] \
	&&  printf "\n\n$(date '+%Y-%m-%d'),签到情况\n"  \
	||  printf "\n\n$(date '+%Y-%m-%d'),签到情况\n"  >> /tmp/checkin.log 
rm -f /tmp/cookie.txt
checkin fqhy 	  	https://clients.in-cloud.gq/auth/login 		https://clients.in-cloud.gq/user/checkin 	aaagg1111@126.com panel1111
checkin jdycloud  	https://jdycloud.xyz/auth/login    			https://jdycloud.xyz/user/checkin   		aaagg1111@126.com jdy1111
checkin jdycloud  	https://jdycloud.xyz/auth/login    			https://jdycloud.xyz/user/checkin   		11111@qq.com       aaa1111
start_trojan
# current： 韩国 F53 直连 Amazon Trojan
#start_v2ray
brush_flow config_trojan.json
#brush_flow config_vmess.json
#stop_v2ray
# curl -k -x socks5://127.0.0.1:65433 -v https://www.google.com
#checkin huojianyun	https://www.huojianyun.net/auth/login		https://www.huojianyun.net/user/checkin		aaagg1111@126.com huojianyun1111 '' ' -x socks5://127.0.0.1:65433 '
stop_trojan

#account has expired
#checkin shandian  	https://freemycloud.me/auth/login   		https://freemycloud.me/user/checkin       	aaagg1111@126.com freemycloud1111 '&remember_me=on'
