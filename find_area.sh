#find time in below time range.
find -type f -newermt "2011-12-22 00:00:00" \! -newermt "2011-12-24 13:23:00"
# find time start from 3 years until now
find -type f -newermt $(date +%Y-%m-%d --date="-3 year")   
# find depth 1 and before 379 days 
find ./ -maxdepth 1 -mtime +379 -exec ls -l {} \;
# rm files in depth level 1  before 180 days
find ./ -maxdepth 1 -mtime +180 -exec rm -rf '{}' \;
