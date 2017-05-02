#########################################################################
# File Name: split_list.sh
# Author: eric.xu
# mail: eric.xu@libratone.com.cn
# Created Time: 2017年01月06日 星期五 14时05分01秒
#########################################################################

#discription: 将每个文件十等分，将等分后的urlID存放到不同的文件.

#!/bin/bash

if [ -f $1 ] && [ $# -eq 1 ]; then
    echo $1
else
    echo "Usage:$0 inputfile"
    exit 1
fi

#vtuner_list_20000.txt
file=${1##*_}
num=${file%.*}
destdir=test/addr_$num
if [ ! -d "$destdir" ]; then
    mkdir -p $destdir
fi

total_line=`cat $1 | wc -l`
echo "total_line=$total_line"

((average_line=total_line/10))
echo "average_line=$average_line"

((rest=total_line%10))

echo "rest=$rest"

start=1
end=$average_line
for i in {1..10}; do

    filename=${1%.*}_$start-$end.txt
    tail -n +$start $1 | head -n $average_line > $destdir/$filename

    ((start+=average_line))
    ((end+=average_line))
    if [ $i -eq 9 ]; then
        ((end+=rest))
    fi
done

