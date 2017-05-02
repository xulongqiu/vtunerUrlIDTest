#########################################################################
# File Name: autocheckvtunerlist-x86-ffplay.sh
# Author: eric.xu
# mail: eric.xu@libratone.com.cn
# Created Time: 2017年01月06日 星期五 14时05分01秒
#########################################################################
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage $0 listfile"
fi

if [ -f $1 ]; then
    echo $1
else
    echo "$1 isn't exsit!"
    exit 1
fi

if [ -d ffplay ]; then 
    echo logdirectory:ffplay
else
    mkdir ffplay
fi

date=`date +"%Y%m%d%H%M%S"`
prefix="http://company.vtuner.com/setupapp/company/asp/func/dynamOD.asp?ex45v=&id="
result=ffplay/${date}_${1%.*}-ffplay.result
logfile=ffplay/${date}_${1%.*}-ffplay.log

echo $result:$logfile

url=''
totalnum=0
failnum=0
succnum=0
isSucc="0"
ctrl_c=0


function print_result()
{
    echo "-----------------------------------------------------------------------------------------------" >> $result

    echo "" >> $result
    echo "" >> $result
    echo "check vtuner list addr end: total=$totalnum, cucc=$succnum, fail=$failnum" >> $result
    exit 0
}

function print_start()
{
    echo "check vtuner list addr starting..." > $result
    echo "" >> $result
    echo "" >> $result
    echo "-----------------------------------------------------------------------------------------------" >> $result    
}

function ctrl_c_f()
{
    echo "click ^C, will return after finishing this addr checking"
    ctrl_c=1
}

trap ctrl_c_f 2

print_start

echo "[  START TEST VTUNER ADDR LIST WITH MPLAYER  ]" > $logfile


for line in $(cat $1)
do
    url=$prefix$line
    num=$(printf "%05d" $totalnum)

    for j in {1..2}; do
        echo -e "\n\n[$num][try:$j]URL:$url\n\n" >> $logfile
        /work_source/android_av/ffmpeg-2.1/ffmpeg/ffplay -v debug -nodisp $url -exitsucc >> $logfile 2>&1
        ret=$?
        if [ $ret -eq 1 ]; then
            break;
        fi
    done

    if [ $ret -eq 0 ]; then
        echo "[$num] [fail] $url" >> $result
        echo "[$num] [fail] $url"
        echo "[$num] [vtuner.fail] $url" >> $logfile
        ((failnum += 1))
    else
        echo "[$num] [succ] $url" >> $result
        echo "[$num] [succ] $url"
        echo "[$num] [vtuner.succ] $url" >> $logfile
        ((succnum += 1))
    fi
    ((totalnum += 1)) 
   
    if [ $ctrl_c -eq 1 ]; then
        break
    fi

done

print_result

