#!/bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

function echo_30(){
    echo -e "\033[30m $1 \033[0m"
}
function echo_31(){
    echo -e "\033[31m $1 \033[0m"
}
function echo_32(){
    echo -e "\033[32m $1 \033[0m"
}
function echo_33(){
    echo -e "\033[33m $1 \033[0m"
}
function echo_34(){
    echo -e "\033[34m $1 \033[0m"
}
function echo_35(){
    echo -e "\033[35m $1 \033[0m"
}
function echo_36(){
    echo -e "\033[36m $1 \033[0m"
}

finalPath="/home/vichuang/logFile/autoTee"
timeStamp=$(date +"%Y%m%d_%H%M%S")

adb logcat -v threadtime | tee ${finalPath}/$timeStamp.txt | egrep -i "$1" --color=auto
#cp ${finalPath}/$timeStamp.txt ${finalPath}/lastest.txt

