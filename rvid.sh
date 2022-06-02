#!/bin/bash 

rm -rf vid 3> /dev/null
mkdir vid 3> /dev/null

subRedit="$1"

limit=$2


filter1="url_overridden_by_dest"
filter2="https:\/\/v\.redd\.it\/\w{13}"

DATA=$(curl -s -H "User-agent: 'your bot 0.1'" https://www.reddit.com/r/$subRedit/top.json\?limit\=$limit | jq '.' | grep $filter1 | grep -Eoh "$filter2")

[ -z "$DATA" ] && echo "Redyt" "sadly, there are no Videos for subreddit $subreddit, please try again later!" && exit 1


a=1
for i in $DATA;
do
        echo $a $i ;
        a=$((a+1));
done

echo
echo press enter
read i

echo Downloading Videos ...

youtube-dl $DATA -o vid/


echo done!
