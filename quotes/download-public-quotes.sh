#!/bin/bash

# Usage:
#  $ "./download-public-quotes.sh" -u="YOUR_USER_NAME" -l="2048" -o="public-quotes.json" -c="ipp_key=YOUR_IPP_KEY; ipp_uid=YOUR_IPP_UID;"

for i in "$@"
do
case $i in
  -u=*|--user=*)
    user="${i#*=}"
    shift # past argument=value
    ;;
  -l=*|--limit=*)
    limit="${i#*=}"
    shift # past argument=value
    ;;
  -c=*|--cookie=*)
    cookie_value="${i#*=}"
    shift # past argument=value
    ;;
  -o=*|--output=*)
    output_file="${i#*=}"
    shift # past argument=value
    ;;
  --default)
    user=""
    limit=2048
    output_file="public-quotes.json"
    shift # past argument with no value
    ;;
  *)
    echo "Unknown option!"
    ;;
esac
done

url="https://bookmate.com/p/api/v5/users/$user/quotes?page=1&per_page=$limit"

echo "Open page and Get cookie:"
echo "$url"

Accept="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
Accept_Encoding="gzip, deflate, br"
Accept_Language="en,en-US;q=0.9,ru;q=0.8,az;q=0.7"
Cache_Control="max-age=0"
Connection="keep-alive"
Cookie="$cookie_value"
DNT="1"
Host="bookmate.com"
Upgrade_Insecure_Requests="1"
User_Agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/69.0.3497.81 Chrome/69.0.3497.81 Safari/537.36"

[ -e "$output_file" ] && rm "$output_file"

wget --quiet \
     --header="Accept: $Accept" \
     --header="Accept-Encoding: $Accept_Encoding" \
     --header="Accept-Language: $Accept_Language" \
     --header="Cache-Control: $Cache_Control" \
     --header="Connection: $Connection" \
     --header="Cookie: $Cookie" \
     --header="DNT: $DNT" \
     --header="Host: $Host" \
     --header="Upgrade-Insecure-Requests: $Upgrade_Insecure_Requests" \
     --user-agent="$User_Agent" \
     -O "$output_file" "$url"

gunzip < "$output_file" | jq . | sponge "$output_file"
