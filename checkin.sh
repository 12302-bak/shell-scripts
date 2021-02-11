#!/bin/bash

checkin()
{
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
	  -d "email=$4&passwd=$5&code=$6" \
	  --compressed \
	  -m 180 -s -w "\t%{http_code}" -c /tmp/cookie.txt `

	printf "$(date '+%Y-%m-%d %H:%M:%S')\t $1\t$login\n" >> /tmp/checkin.log
	http_code=`echo $login | awk '{print $2}'`

	if [ -f "/tmp/cookie.txt" -a "$http_code" -eq "200"  ]
	then 
		min=10 &&  max=20
		rdm=`expr $(date +%N) %  $[$max - $min  + 1] + $min`
		printf "$rdm\t" >> /tmp/checkin.log && sleep $rdm
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
		printf "$(date '+%Y-%m-%d %H:%M:%S')\t$checkin\n" >> /tmp/checkin.log
	fi
}
brush_flow()
{
	# launch troja_n service
	/home/eli/software/stairspeedtest/tools/clients/trojan -c /home/eli/practise/config.json >/dev/null 2>&1 &
	echo 'sleeping 5 sec'  >> /tmp/checkin.log
	sleep 5
	# start brush flow
	curl  -k -s -x socks5://127.0.0.1:65433 -w "time_connect:(%{time_connect})/s||time_total:(%{time_total})/s||speed_download:(%{speed_download})Bytes/s||size_download:(%{size_download})Bytes\n" \
	http://mvn.wtfu.site/nexus/content/groups/public/com/anft/framework/sea/parent/sea-common/1.0-SNAPSHOT/sea-common-1.0-20210114.134012-1.jar -o /tmp/sea-common-SNAPSHOTS.jar >> /tmp/checkin.log 
	
	# stop service
	_pid=`ps -ef | grep -v grep |  grep "trojan" | awk '{print $2}'`
	kill -9 $_pid
	wait $_pid 2>/dev/null

	# print log
	printf "$(date '+%Y-%m-%d %H:%M:%S')\tbrush flow complete pid = $_pid\n" >> /tmp/checkin.log
	
}

printf "\n\n$(date '+%Y-%m-%d'),签到情况\n" >> /tmp/checkin.log
rm -f /tmp/cookie.txt
checkin fqhy 	  	https://clients.in-cloud.gq/auth/login 		https://clients.in-cloud.gq/user/checkin 	xxxxxx panel11111
#account has expired
#checkin shandian  	https://freemycloud.me/auth/login   		https://freemycloud.me/user/checkin       	xxxxxx freemycloud11111 '&remember_me=on'
checkin jdycloud  	https://jdycloud.xyz/auth/login    			https://jdycloud.xyz/user/checkin   		xxxxxx jdy11111
checkin jdycloud  	https://jdycloud.xyz/auth/login    			https://jdycloud.xyz/user/checkin   		xxxxxx xhs11111
brush_flow
