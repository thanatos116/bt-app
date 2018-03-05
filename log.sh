#!/bin/bash 
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

#import wordColor
. /home/vichuang/fastScript/wordColor.sh --source-only
#folder settings
folderName=""
savePath="/home/vichuang/logFile/issue_log/log.sh/"
htclogPath="/data/htclog"
htclogPath2="/storage/emulated/0/htclog/"
snoopPath="/sdcard/btsnoop_hci.log"
marlinSnoopPath="data/misc/bluetooth/logs/btsnoop_hci.log"
utsnoopPath="/sdcard/htclog/"
qxdmPath="/storage/emulated/0/qxdmlog"
mins_log="0"

timelog=$(date +"%Y%m%d_%H%M%S")

#default settings
htclog="y"
btsnoop="y"
qxdm="n"

filetype="device.*\\.txt"

#try to get device name  ex: [ro.product.device]: [htc_a16dwg]   -----> htc_a16dwg
device_name="`adb shell getprop | egrep "\[ro\.product\.device\]" | sed 's/\[ro.product.device\].*\[//g' | sed 's/\]//g' | tr -d "\n\r"`"
device_seriNo="`adb shell getprop | egrep "\[ro\.serialno\]" | sed 's/\[ro\.serialno\].*\[//g' | sed 's/\]//g' | tr -d "\n\r"`"


while [ "$#" != "0" ]
do 
    index=0
    case $1 in
        "-h")
            echo -e "Get htc log only ! "
            btsnoop="n"
            ;;
        "-q")
            echo -e "Get QxDM log "
            qxdm="y"
            ;;
        "-s")
            echo -e "Get snoop log only"
            btsnoop="y"
            htclog="n"
            ;;
        "-o")
            read -p "htclog y/n ?" htclog
            read -p "btsnoop y/n ?" btsnoop
            read -p "qxdm y/n ?" qxdm
            ;;
        "-f")
            read -p "Folder Name : " folderName
            folderName="${folderName}/"
            ;;
        "-sh")
            folderName="a32e_wlFW_overnight/"
            ;;
        "-fname")
            if [ "$2" != "" ]; then
                shift
                folderName="$1/"
            else
                echo_31 "Error input"
                exit
            fi

            ;;
        "-n")
            if [[ $2 =~ ^[0-9]+$ ]]; then
                mins_log="$2"
                shift
            else
                mins_log="5"
            fi
            echo_36 "Get logs in  $mins_log mins !"
            now=$(date +"%s")
            logtime=$((now - 60*mins_log))
            ;;
        "-all")
            filetype=".txt"
            ;;

        *)
            echo_41 "Error input"
            exit
            ;;
    esac

shift
done
#mkdir folder if needed
if [ -n "$folderName" ]; then
    folderName=${device_name}_$folderName
    if [ ! -f "${savePath}${folderName}" ]; then
        mkdir ${savePath}${folderName}
        if [ $htclog == "y" -o $htclog == "Y" ]; then
            mkdir ${savePath}${folderName}htclog
        fi
        if [ $btsnoop == "y" -o $btsnoop == "Y" ]; then
            mkdir ${savePath}${folderName}btsnoop
        fi
        if [ $qxdm == "y" -o $qxdm == "Y" ]; then
            mkdir ${savePath}${folderName}qxdmlog
        fi
    fi
fi
#start pull log

#adb remount
#########################################################################################################
#                                 htclog                                                                #
#########################################################################################################
if [ $htclog == "y" -o $htclog == "Y" ]; then

    #choose htclog folder!
    if [ -z "`adb shell ls "$htclogPath"`" ]; then
        echo "/data/htclog/ is empty, try $htclogPath2"
        if [ -n "`adb shell ls "$htclogPath"`" ]; then
            htclogPath="$htclogPath2"
        else
            echo "$htclogPath2 is empty too."
            htclog="empty"
        fi
    fi
    #start to get htclog

    #check logtime to pull recent logs
    if [ "$mins_log" != "0" ]; then
        for file in `adb shell ls "$htclogPath" | grep ${filetype}`
        do
            file=`echo -e $file | tr -d "\r\n"`;

            if [ "`adb shell stat -c %Y "$htclogPath/$file" | tr -d "\r\n"`" -lt "$logtime" ]; then
                continue
            fi

            echo -e "$htclogPath/$file"

            adb pull "$htclogPath/$file" "${savePath}${folderName}htclog/$file"
        done
        echo -e "\033[31m ==========pull Htclog complete!============================== \033[0m"
    #get all logs
    elif [ $htclog == "empty" ]; then
        echo_33 "No htclog !"
    else

        for file in `adb shell ls "$htclogPath" | grep ${filetype}`
        do
            file=`echo -e $file | tr -d "\r\n"`;

            echo -e "$htclogPath/$file"
            adb pull "$htclogPath/$file" "${savePath}${folderName}htclog/$file"
        done
        echo -e "\033[31m ==========pull Htclog complete!============================== \033[0m"
    fi
fi

#########################################################################################################
#                                 BtSnoop                                                               #
#########################################################################################################

if [ $btsnoop == "y" -o $btsnoop == "Y" ]; then
  # check btsnoop in $snoopPath
  if [ -n "`adb shell ls $snoopPath`" ]; then
    adb pull "$snoopPath" "${savePath}${folderName}btsnoop/${device_name}_${device_seriNo}_btsnoop_hci_${timelog}.cfa"
    echo -e "\033[31m ==========pull ${device_name}_${device_seriNo}_btsnoop_hci_${timelog}.cfa complete!===================== \033[0m"
  # check btsnoop in $marlinSnoopPath
  elif [ -n "`adb shell ls $marlinSnoopPath `" ]; then
    adb pull "$marlinSnoopPath" "${savePath}${folderName}btsnoop/${device_name}_${device_seriNo}_btsnoop_hci_${timelog}.cfa"
    echo -e "\033[31m =====pull $marlinSnoopPath ${device_name}_${device_seriNo}_btsnoop_hci_${timelog}.cfa complete!====== \033[0m"
  elif [ -n "`adb shell ls $utsnoopPath `" ]; then
      for snoopFile in `adb shell ls "$utsnoopPath"`
      do
          snoopFile=`echo -e $snoopFile | tr -d "\r\n"`
          adb pull "$utsnoopPath/$snoopFile" "${savePath}${folderName}btsnoop/${device_name}_${device_seriNo}_utsnoop_${snoopFile}.cfa"
      done
  else
      echo_33 "No Snoop init !"

  fi
fi

#########################################################################################################
#                                 QxDM                                                                  #
#########################################################################################################
if [ $qxdm == "y" -o $qxdm == "Y" ]; then
    adb pull "$qxdmPath" "${savePath}${folderName}qxdmlog"
    echo -e "\033[31m ==========pull qxdm complete!==============================\033[0m" 
fi

if [ "$folderName" != "" ]; then
    chmod -R 777 ${savePath}${folderName}
    echo -e "chmod 777 done !"
fi

echo_33 "Log save in ${savePath}${folderName}"

