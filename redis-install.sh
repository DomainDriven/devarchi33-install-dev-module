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
VERSION="3.0.7"
FILE="redis-$VERSION.tar.gz"

#현재 위치에 설치파일 유무 체크
function func_check_redis
{
  if [ -s $BASE_DIR/$FILE ]; then
	echo "true"
  else
	echo "false"
  fi
}

#파일 체크하여 다운로드
function func_download_redis
{
  check_exist_redis=$(func_check_redis)
  if [[ "$check_exist_redis" == "true"  ]]; then
	echo "Already downloaded $FILE..."
  else
	echo "$FILE not detected! downloading $FILE"
	wget http://download.redis.io/releases/$FILE
  fi
}

func_download_redis

#Redis 압축해제
function func_install_redis
{
  sudo tar -xvf $FILE -C /usr/local
  sudo ln -s /usr/local/redis-$VERSION /usr/local/redis
  sudo yum -y install gcc
  cd /usr/local/redis-$VERSION && sudo make
}

#redis 설치 유무 체크하여 진행
function func_check_redis_install
{
  if [ -d "/usr/local/redis-$VERSION"  ]; then
	echo "Already installed redis."
  else
	echo "Installing redis..."
	func_install_redis
  fi
}

func_check_redis_install
