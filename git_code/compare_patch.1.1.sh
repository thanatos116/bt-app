#!/bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

. /home/vichuang/fastScript/wordColor.sh --source-only

#the file for settings
folder_list="folder_list.txt"
final_result_file="final_result.txt"
OriPatchId_compare="OriPatchId.txt"
DestPatchId_compare="DestPatchId.txt"
# none : same patchID : same commitID : same title : not exist
final_status="none"

oriFolder="`cat $folder_list | egrep "patchFolder:" | sed 's/patchFolder://g'`"
destFolder="`cat $folder_list | egrep "destFolder:" | sed 's/destFolder://g'`"
patch_path="`cat $folder_list | egrep "patch_path:" | sed 's/patch_path://g'`"
#deepCommit:5 -> -5
oriDeepCommit="`cat $folder_list | egrep "oriDeepCommit:" | sed 's/oriDeepCommit:/-/g'`"
destDeepCommit="`cat $folder_list | egrep "destDeepCommit:" | sed 's/destDeepCommit:/-/g'`"

#save folder name
timestamp=$(date +"%Y%m%d_%H%M%S")
mkdir -m 777 "${patch_path}${timestamp}"
#timestamp ex:20151123_195700
#absolute path for final output
final_result_path="/home/vichuang/fastScript/git_code/final/$timestamp"
final_result_file_path="${final_result_path}/$final_result_file"

patch_path="/home/vichuang/fastScript/git_code/final/"
same_title_patch="${final_result_path}/same_title/"
if [ ! -d "${same_title_patch}" ]; then
    mkdir -m 777 ${same_title_patch}
fi
not_exist_patch="${final_result_path}/not_exist/"
if [ ! -d "${not_exist_patch}" ]; then
    mkdir -m 777 ${not_exist_patch}
fi

#echo -e "$compareNumber"
# print total $deepCommimt to $OriPatchId_compare with type "commit patchID title"
cd $oriFolder

[ -f "${final_result_path}/$OriPatchId_compare" ] && rm "${final_result_path}/$OriPatchId_compare"

#for c in $(git rev-list --no-merges HEAD $oriDeepCommit);
for c in $(git log --no-merges --pretty=format:"%H" HEAD $oriDeepCommit);
do
    oriCommitID="`git log --pretty=format:'%h' $c -1`"
    oriTitle="`git log --pretty=format:'%s' $c -1`"
    oriPatchID=$(
    git show --patch-with-raw "$c" |
    git patch-id |
    cut -d" " -f1
    )
    echo "$oriCommitID \$ $oriPatchID \$ $oriTitle" >> "${final_result_path}/$OriPatchId_compare"
done

# print total $deepCommimt to $DestPatchId_compare with type "commit patchID title"
cd $destFolder

[ -f "${final_result_path}/$DestPatchId_compare" ] && rm "${final_result_path}/$DestPatchId_compare"

#for c in $(git rev-list --no-merges HEAD $destDeepCommit);
for c in $(git log --no-merges --pretty=format:"%H" HEAD $destDeepCommit);
do
    destCommitID="`git log --pretty=format:'%h' $c -1`"
    destTitle="`git log --pretty=format:'%s' $c -1`"
    destPatchID=$(
    git show --patch-with-raw "$c" |
    git patch-id |
    cut -d" " -f1
    )
    echo "$destCommitID \$ $destPatchID \$ $destTitle" >> "${final_result_path}/$DestPatchId_compare"
done

[ -f "$final_result_file_path" ] && rm "$final_result_file_path"
# Read OriPatchId and check whether exist in destPatchId
exec < ${final_result_path}/$OriPatchId_compare
count=0
while read line
do
    count=$((count+1))

# $1->commitID $3->patchID $5->title
    oriCommitId=$(echo -e $line | awk -F"$" '{print $1}')
    PatchId=$(echo -e $line | awk -F"$" '{print $2}')
    title=$(echo -e $line | awk -F"$" '{print $3}')
    echo "Patch:$count $oriCommitId $title"
    PatchIdExist=`egrep "$PatchId" "${final_result_path}/$DestPatchId_compare"`
    if [ -n "$PatchIdExist" ]; then
        echo_36 "========PatchID find=========="
        echo "$line \$ same patchID" >> "$final_result_file_path"
    else
        #patchID not exit, compare title
        titleExist=`grep -F "$title" "${final_result_path}/$DestPatchId_compare"`
        if [ -n "$titleExist" ]; then
            echo_32 "========PatchID not find, but find same title patch=========="
            echo "$line \$ same title" >> "$final_result_file_path"
            cd $oriFolder
            git format-patch $oriCommitId -1 -o ${same_title_patch} --start-number $count -v1 &> /dev/null
            cd $destFolder
            destCommitId=`echo -e $titleExist | awk -F"$" '{print $1}'`
            git format-patch $destCommitId -1 -o ${same_title_patch} --start-number $count -v2 &> /dev/null
        else
            echo_31 "========Patch not exist=========="
            echo "$line \$ not exist" >> "$final_result_file_path"
            cd $oriFolder
            git format-patch $oriCommitId -1 -o ${not_exist_patch} --start-number $count &> /dev/null
        fi
    fi

done

echo_46 "final result in $final_result_file_path"
cp -r /home/vichuang/fastScript/git_code/final/$timestamp /home/vichuang/logFile/git_compare_patch/
echo_46 "cp to logFile/git_compare_patch/"

exit




