#!/bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

#where to do command
#commandFolder="/home/vichuang/codebase/google_m-mr1-rel_gep_aosp/system/bt"
folder_list="folder_list.txt"
timestamp=$(date +"%Y%m%d_%H%M%S")
echo -e $timestamp
#patch folder
commandFolder="`cat $folder_list | egrep "patchFolder:" |sed 's/patchFolder://g'`"
#number of commit to compare in patch folder
commitNumber="`cat $folder_list | egrep "deepCommit:" |sed 's/deepCommit://g'`"
#output data and patch to patch_path
patch_path="`cat $folder_list | egrep "patch_path:" |sed 's/patch_path://g'`"
#patch_path="/home/vichuang/fastScript/git_code/final/"
mkdir -m 777 "${patch_path}${timestamp}"
outputFolder="${patch_path}${timestamp}"
echo $commandFolder
echo $commitNumber
echo $outputFolder
echo $patch_path
#rm test.txt if exist and then recreate it
destFile="$outputFolder/tmp.txt"
echo $destFile
if [ -f $destFile ]; then
    rm $destFile
fi
touch $destFile

cd $commandFolder

#git log to tmp.txt
tmp="`git log -$commitNumber --no-merges --pretty=format:"%H \$ %s"`"
echo "$tmp" >> $destFile
sed -i "s/latestFolder:.*/latestFolder:${timestamp}/g" "/home/vichuang/fastScript/git_code/$folder_list"

