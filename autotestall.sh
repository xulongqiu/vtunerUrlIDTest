#########################################################################
# File Name: listfile.sh
# Author: eric.xu
# mail: eric.xu@libratone.com.cn
# Created Time: 2017年01月05日 星期四 18时37分49秒
#########################################################################
#!/bin/bash

ffplay_shell=/home/eric/vtuner/test/autocheckvtunerlist-x86-ffplay.sh
mplayer_shell=/home/eric/vtuner/test/autocheckvtunerlist-x86-mplayer.sh

function do_work()
{
    search_path=$1
    case $search_path in
    "txt")
        echo "------------------------------------------------------------"
        echo "[step 1]: play the list with ffplay"
        echo "------------------------------------------------------------"
        for file in `ls *.txt`; do
            #echo $file 
            $ffplay_shell $file &
        done
        ;;
    "fail")
        echo "------------------------------------------------------------"
        echo "[step 3]: play the failed list by mplayer"
        echo "------------------------------------------------------------"
        for file in `ls *.fail`; do
            #echo $file 
            $mplayer_shell $file &
        done
        ;;
    "succ")
        echo "------------------------------------------------------------"
        echo "[step 5]: play the ffplayfail_mplayersucc list by ffplay"
        echo "------------------------------------------------------------"
        for file in `ls *.succ`; do
            #echo $file 
            $ffplay_shell $file
        done
        ;;
    "succagain")
        echo "------------------------------------------------------------"
        echo "[step 7]: play the ffplayfail_mplayersucc list by ffplay"
        echo "------------------------------------------------------------"
        for file in `ls *.succagain`; do
            #echo $file 
            $ffplay_shell $file
        done
        ;;
    "ffplay_result")
        echo "------------------------------------------------------------"
        echo "[step 2]: generate the failed list wiht ffplay result"
        echo "------------------------------------------------------------"
        for file in `ls ffplay/*.result`; do
            #echo $file 
            deldatefile=${file#*_} 
            outfile=${deldatefile%-*}.ffplay.fail
            grep "\[fail\]" $file |awk -F '=' '{print $3}' > $outfile
        done
        ;;
    "mplayer_result")
        echo "------------------------------------------------------------"
        echo "[step 4]: generate the succ list wiht mplayer result"
        echo "------------------------------------------------------------"
        grep "\[succ\]" mplayer/*.result | awk -F '=' '{print $3}' > vtuner_list_ffplayfail_mplayersucc.succ 
        ;;
    "succagain_result")
        echo "------------------------------------------------------------"
        echo "[step 6]: generate the succagain list wiht ffplay result"
        echo "------------------------------------------------------------"
        for file in `ls ffplay/*_mplayersucc-ffplay.result`; do
            #echo $file
            grep "\[fail\]" $file | awk -F '=' '{print $3}' > vtuner_list_ffplayfail_mplayersucc.succagain
        done
        ;;
    *)
        echo "not support case:$search_path"
    ;;
    esac
}

function wait_finish(){
    while [ 1 ]; do
        finish=`grep "total=" $1/*.result |wc -l`
        if [ $finish -eq 10 ]; then
            #echo "play list finish wiht $1"
            break;
        fi
        sleep 300
    done
}
#main

do_work "txt"
wait_finish "ffplay"
do_work "ffplay_result"
do_work "fail"
wait_finish "mplayer"
do_work "mplayer_result"
do_work "succ"
while [ 1 ]; do
    do_work "succagain_result"
    for file in `ls ffplay/*_mplayersucc-ffplay.result`; do
        line=`grep "\[succ\]" $file | wc -l`
    done
    echo "still succ addr cnt = $line"
    if [ $line -eq 0 ]; then
       break
    fi
    line=`cat vtuner_list_ffplayfail_mplayersucc.succagain | wc -l`
    echo ffplay failed addr cnt=$line 
    do_work "succagain"
done

echo "all the test finish, please check ffplay/*vtuner_list_ffplayfail_mplayersucc.result to get the result"





