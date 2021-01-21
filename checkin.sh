#!/bin/bash

fqhy_checkin()
{
	login=`curl 'https://clients.in-cloud.gq/auth/login' \
	  -H 'authority: clients.in-cloud.gq' \
	  -H 'pragma: no-cache' \
	  -H 'cache-control: no-cache' \
	  -H 'accept: application/json, text/javascript, */*; q=0.01' \
	  -H 'x-requested-with: XMLHttpRequest' \
	  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36' \
	  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
	  -H 'origin: https://clients.in-cloud.gq' \
	  -H 'sec-fetch-site: same-origin' \
	  -H 'sec-fetch-mode: cors' \
	  -H 'sec-fetch-dest: empty' \
	  -H 'referer: https://clients.in-cloud.gq/auth/login' \
	  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8' \
	  -d 'email=xxxxx&passwd=xxxxx&code=' \
	  --compressed \
	  -m 30 -s -w "\t%{http_code}" -c /tmp/cookie.txt `

	printf "$(date '+%Y-%m-%d %H:%M:%S')\t$login\n" >> /tmp/checkin.log
	http_code=`echo $login | awk '{print $2}'`

	if [ -f "/tmp/cookie.txt" -a "$http_code" -eq "200"  ]
	then 
		min=10
		max=20
		rdm=`expr $(date +%N) %  $[$max - $min  + 1] + $min`
		printf "$rdm\t" >> /tmp/checkin.log && sleep $rdm
		checkin=`curl 'https://clients.in-cloud.gq/user/checkin' \
		  -X 'POST' \
		  -H 'authority: clients.in-cloud.gq' \
		  -H 'content-length: 0' \
		  -H 'pragma: no-cache' \
		  -H 'cache-control: no-cache' \
		  -H 'accept: application/json, text/javascript, */*; q=0.01' \
		  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36' \
		  -H 'x-requested-with: XMLHttpRequest' \
		  -H 'origin: https://clients.in-cloud.gq' \
		  -H 'sec-fetch-site: same-origin' \
		  -H 'sec-fetch-mode: cors' \
		  -H 'sec-fetch-dest: empty' \
		  -H 'referer: https://clients.in-cloud.gq/user' \
		  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8' \
		  --compressed \
		  -m 30 -s -w "\t%{http_code}" -b /tmp/cookie.txt`
		printf "$(date '+%Y-%m-%d %H:%M:%S')\t$checkin\n" >> /tmp/checkin.log
	fi
}
shandian_checkin()
{
	login=`curl 'https://freemycloud.me/auth/login' \
	  -H 'authority: freemycloud.me' \
	  -H 'pragma: no-cache' \
	  -H 'cache-control: no-cache' \
	  -H 'accept: application/json, text/javascript, */*; q=0.01' \
	  -H 'x-requested-with: XMLHttpRequest' \
	  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36' \
	  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
	  -H 'origin: https://freemycloud.me' \
	  -H 'sec-fetch-site: same-origin' \
	  -H 'sec-fetch-mode: cors' \
	  -H 'sec-fetch-dest: empty' \
	  -H 'referer: https://freemycloud.me/auth/login' \
	  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8' \
	  -d 'email=xxxxxxx&passwd=xxxxxxxxx&code=&remember_me=on' \
	  --compressed  \
	  -m 30 -s -w "\t%{http_code}" -c /tmp/cookie.txt `

	printf "$(date '+%Y-%m-%d %H:%M:%S')\t$login\n" >> /tmp/checkin.log
	http_code=`echo $login | awk '{print $2}'`

	if [ -f "/tmp/cookie.txt" -a "$http_code" -eq "200"  ]
	then 
		min=10
		max=20
		rdm=`expr $(date +%N) %  $[$max - $min  + 1] + $min`
		printf "$rdm\t" >> /tmp/checkin.log && sleep $rdm
		checkin=`curl 'https://freemycloud.me/user/checkin' \
		  -X 'POST' \
		  -H 'authority: freemycloud.me' \
		  -H 'content-length: 0' \
		  -H 'pragma: no-cache' \
		  -H 'cache-control: no-cache' \
		  -H 'accept: application/json, text/javascript, */*; q=0.01' \
		  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36' \
		  -H 'x-requested-with: XMLHttpRequest' \
		  -H 'origin: https://freemycloud.me' \
		  -H 'sec-fetch-site: same-origin' \
		  -H 'sec-fetch-mode: cors' \
		  -H 'sec-fetch-dest: empty' \
		  -H 'referer: https://freemycloud.me/user' \
		  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8' \
		  --compressed \
		  -m 30 -s -w "\t%{http_code}" -b /tmp/cookie.txt`
		printf "$(date '+%Y-%m-%d %H:%M:%S')\t$checkin\n" >> /tmp/checkin.log
	fi
}

printf "\n\n$(date '+%Y-%m-%d'),签到情况\n" >> /tmp/checkin.log
rm -f /tmp/cookie.txt
fqhy_checkin
shandian_checkin
