#!/bin/bash

rm -rf imgs 3> /dev/null
mkdir imgs 3> /dev/null

subRedit="$1"

limit=$2


#getting json data
curl -H "User-agent: 'your bot 0.1'" "https://www.reddit.com/r/$subRedit/hot.json?limit=$limit" > tmp.json

# Create a list of images
imgs=$(jq '.' < "tmp.json" | grep url_overridden_by_dest | grep -Eo "http(s|)://.*(jpg|png)\b" | sort -u)

rm tmp.json

a=1
for i in $imgs;
do
	echo $a $i ;
	a=$((a+1));
done

# If there are no images, exit
[ -z "$imgs" ] && echo "Redyt" "sadly, there are no images for subreddit $subreddit, please try again later!" && exit 1

read i

dir="imgs"
# Download images to $cachedir
for img in $imgs; do
	if [ ! -e "$dir/${img##*/}" ]; then
		wget -P "$dir" $img
	fi
done

echo done
