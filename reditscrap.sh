#!/bin/bash




rvid()
{



	#filters
	filter1="url_overridden_by_dest"
	filter2="https:\/\/v\.redd\.it\/\w{13}"

	#getting json data & making list of videos
	curl -s -H "User-agent: 'your bot 0.1'" https://www.reddit.com/r/$subRedit/top.json\?limit\=$limit > vids.json
	vids=$(jq '.' < "vids.json"| grep $filter1 | grep -Eoh "$filter2" | sort -u)
	rm vids.json

	#Exit if not video
	[ -z "$vids" ] && echo "Redyt" "sadly, there are no Videos for subreddit $subreddit, please try again later!" && return 0

	a=1
	for i in $vids;
	do
        echo $a $i ;
        a=$((a+1));
	done

	echo && echo press enter
	read i

	echo Downloading Videos ...
	youtube-dl $vids -o vid/ | awk 'NR==1' | awk '{ print $1 " " $2 " " $3 }'

}

rimg()
{

	

	#getting json data & Create a list of images
	curl -H "User-agent: 'your bot 0.1'" "https://www.reddit.com/r/$subRedit/hot.json?limit=$limit" > tmp.json 2> /dev/null 3> /dev/null
	imgs=$(jq '.' < "tmp.json" | grep url_overridden_by_dest | grep -Eo "http(s|)://.*(jpg|png)\b" | sort -u)

	rm tmp.json

	# If there are no images, exit
	[ -z "$imgs" ] && echo "Redyt" "sadly, there are no images for subreddit $subreddit, please try again later!" && return 0

	a=1
	for i in $imgs;
	do
		echo $a $i ;
		a=$((a+1));
	done

	

	echo && echo press enter
	read i

	# Download images to $cachedir
	for img in $imgs; do
		if [ ! -e "imgs/${img##*/}" ]; then
			wget -P "imgs" $img
		fi
	done

}


#variables
subRedit="$1"
limit=$2

#making folder for videos and images
[ -z imgs/ ] && echo Making Directory && mkdir imgs
[ -z vids/ ] && echo Making Directory && mkdir vids

help="usage: bash $0 subRedit limit(default=10)"

[ -z "$subRedit" ] && echo "no SubReddit chosen" && echo $help && exit 1

[ -z "$limit" ] && echo taking limit as 20 && limit=10
	# sleep(3)

rimg $subRedit $limit
rvid $subRedit $limit

echo done!
