#!/bin/bash

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
    --default)
    user=""
    limit=2048
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done

wget -O "public-quotes.json" "https://bookmate.com/p/api/v5/users/$user/quotes?page=1&per_page=$limit"