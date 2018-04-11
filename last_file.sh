#!/bin/bash                                                                                                                      
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

IFS=$'\n'                    # Using only newline as delimiter (ignore tabs and spaces)
output=(`adb shell ls -l /sdcard/`)             # Save output as array (each position is one line)
lines=${#output[@]}          # Calculate the number of lines
echo ${output[$((lines-1))]} # Print the last line from output
