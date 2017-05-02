#########################################################################
# File Name: split_channel.sh
# Author: eric.xu
# mail: eric.xu@libratone.com.cn
# Created Time: 2017年02月17日 星期五 11时14分38秒
#########################################################################

#description: 将输入文件分成多个文件，每个文件包含一万个urlID.

#!/bin/bash

if [ -f $1 ] && [ $# -eq 1 ]; then
    echo $1
else
    echo "Usage:$0 inputfile"
    exit 1
fi

nowLine=1

echo $nowLine

while [ 1 ]; do
    filename=vtuner_list_$((nowLine + 10000 - 1)).txt
    tail -n +$nowLine $1 |head -n 10000 > $filename
    if [ `cat $filename | wc -l` -ne 10000 ]; then
        break
    fi
    ((nowLine += 10000))
done
