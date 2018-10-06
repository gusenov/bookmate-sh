#!/bin/bash

# Usage:
#  $ "./make-books-private.sh" --cookie="YOUR_IPP_KEY; ipp_uid=YOUR_IPP_UID; bms=YOUR_BMS"

for i in "$@"; do
case $i in
  -c=*|--cookie=*)
    cookie_value="${i#*=}"
    shift # past argument=value
    ;;
  --default)
    bms="YOUR_COOKIE_BMS"
    shift # past argument with no value
    ;;
  *)
    echo "Unknown option!"
    exit
    ;;
esac
done

#set -x # echo on

Accept="application/json"
Accept_Encoding="gzip, deflate, br"
Accept_Language="en,en-US;q=0.9,ru;q=0.8,az;q=0.7"
Connection="keep-alive"
Content_Type="application/json"
Cookie="$cookie_value"
DNT="1"
Host="bookmate.com"
Origin="https://bookmate.com"
#User_Agent="Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Mobile Safari/537.36"
User_Agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/69.0.3497.81 Chrome/69.0.3497.81 Safari/537.36"

input_file="public-books.json"

limit=$(jq '.library_cards | length' "$input_file")
for ((i = 0; i < $limit; i++)); do
    library_card_uuid=$(jq --raw-output '.library_cards['$i'].uuid' "$input_file")
    book_uuid=$(jq --raw-output '.library_cards['$i'].book.uuid' "$input_file")

    Referer="https://bookmate.com/books/$book_uuid"
    response=$(curl -s -X PUT "https://bookmate.com/p/api/v5/profile/library_cards/$library_card_uuid" -d '{"lc":{"uuid":"'$library_card_uuid'","public":false}}' \
        --header "Accept: $Accept" \
        --header "Accept-Encoding: $Accept_Encoding" \
        --compressed \
        --header "Accept-Language: $Accept_Language" \
        --header "Connection: $Connection" \
        --header "Content-Type: $Content_Type" \
        --header "Cookie: $Cookie" \
        --header "DNT: $DNT" \
        --header "Host: $Host" \
        --header "Origin: $Origin" \
        --header "Referer: $Referer" \
        --header "User-Agent: $User_Agent")
    #echo $response

    echo -n "$((1 + i)) of $limit; "
done
