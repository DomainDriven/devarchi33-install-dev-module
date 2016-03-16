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
VERSION="3.2.4"
FILE="mongodb-linux-x86_64-amazon-$VERSION.tgz"

#현재 위치에 설치파일 유무 체크
function func_check_mongodb
{
  if [ -s $BASE_DIR/$FILE ]; then
	echo "true"
  else
	echo "false"
  fi
}

#파일 체크하여 다운로드
function func_download_mongodb
{
  check_exist_mongodb=$(func_check_mongodb)
  if [[ "$check_exist_mongodb" == "true"  ]]; then
	echo "Already downloaded $FILE..."
  else
	echo "$FILE not detected! downloading $FILE"
	wget https://fastdl.mongodb.org/linux/$FILE
  fi
}

func_download_mongodb

#mongodb 압축해제
function func_install_mongodb
{
  sudo tar -xvf $FILE -C /usr/local
  sudo ln -s /usr/local/mongodb-linux-x86_64-amazon-$VERSION /usr/local/mongodb
}

#mongodb 설치 유무 체크하여 진행
function func_check_mongodb_install
{
  if [ -d "/usr/local/mongodb-linux-x86_64-amazon-$VERSION"  ]; then
	echo "Already installed mongodb."
  else
	echo "Installing mongodb..."
	func_install_mongodb
  fi
}

func_check_mongodb_install
