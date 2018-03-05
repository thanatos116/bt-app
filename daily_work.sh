#!/bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

timelog=$(date +"%Y%m%d_%H%M%S")
#record file_size
du -h --max-depth=1 /home/vichuang/codebase/ > /home/vichuang/codebase/file_size.txt 
#du -h /home/vichuang/fastScript/* > /home/vichuang/fastScript/file_size.txt 
echo $timelog >> file_size.txt


