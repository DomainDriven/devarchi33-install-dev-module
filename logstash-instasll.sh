#!/bin/bash

# 현재 폴더위치 구하기.
this="${BASH_SOURCE-$0}"
while [ -h "$this" ]; do
  ls=`ls -ld "$this"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    this="$link"
  else
    this=`dirname "$this"`/"$link"
  fi
done

## convert relative path to absolute path
bin=`dirname "$this"`
script=`basename "$this"`
bin=`cd "$bin">/dev/null; pwd`
this="$bin/$script"

BASE_DIR=`dirname $this`
VERSION="2.2.0"
FILE="logstash-all-plugins-$VERSION.zip"

#현재 위치에 설치파일 유무 체크
function func_check_logstash
{
  if [ -s $BASE_DIR/$FILE ]; then
	echo "true"
  else
	echo "false"
  fi
}

#파일 체크하여 다운로드
function func_download_logstash
{
  check_exist_logstash=$(func_check_logstash)
  if [[ "$check_exist_logstash" == "true"  ]]; then
	echo "Already downloaded $FILE..."
  else
	echo "$FILE not detected! downloading $FILE"
	wget https://download.elastic.co/logstash/logstash/$FILE
  fi
}

func_download_logstash

#logstash 압축해제
function func_install_logstash
{
  unzip $FILE && sudo mv logstash-$VERSION /usr/local
  sudo ln -s /usr/local/logstash-$VERSION /usr/local/logstash
}

#logstash 설치 유무 체크하여 진행
function func_check_logstash_install
{
  if [ -d "/usr/local/logstash-$VERSION"  ]; then
	echo "Already installed logstash."
  else
	echo "Installing logstash..."
	func_install_logstash
  fi
}

func_check_logstash_install
