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
function echo_40(){
    echo -e "\033[40;37m $1 \033[0m"
}
function echo_41(){
    echo -e "\033[41;37m $1 \033[0m"
}
function echo_42(){
    echo -e "\033[42;37m $1 \033[0m"
}
function echo_43(){
    echo -e "\033[43;37m $1 \033[0m"
}
function echo_44(){
    echo -e "\033[44;37m $1 \033[0m"
}
function echo_45(){
    echo -e "\033[45;37m $1 \033[0m"
}
function echo_46(){
    echo -e "\033[46;37m $1 \033[0m"
}

main(){
echo -e "\033[30m 30 黑色字\033[0m"
echo -e "\033[31m 31 紅色字\033[0m"
echo -e "\033[32m 32 綠色字\033[0m"
echo -e "\033[33m 33 黃色字\033[0m"
echo -e "\033[34m 34 藍色字\033[0m"
echo -e "\033[35m 35 紫色字\033[0m"
echo -e "\033[36m 36 天藍字\033[0m"
echo -e "\033[37m 37 白色字\033[0m"

echo -e "\033[40;37m 40;37 黑底白字\033[0m"
echo -e "\033[41;37m 41 紅底白字\033[0m"
echo -e "\033[42;37m 42 綠底白字\033[0m"
echo -e "\033[43;37m 43 黃底白字\033[0m"
echo -e "\033[44;37m 44 藍底白字\033[0m"
echo -e "\033[45;37m 45 紫底白字\033[0m"
echo -e "\033[46;37m 46 天藍底白字\033[0m"
echo -e "\033[47;30m 47 白底黑字\033[0m"
}
if [ "${1}" != "--source-only" ]; then
    main "${@}"
fi
