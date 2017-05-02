#########################################################################
# File Name: timer.sh
# Author: eric.xu
# mail: eric.xu@libratone.com.cn
# Created Time: 2017年02月21日 星期二 20时27分32秒
#########################################################################
#!/bin/bash
#Delaytime=0

AlarmHandler()
{
    echo "Get SIGALAM"
    KillSubProcs
}

KillSubProcs()
{
    #kill cbm
    echo "it's time out,kill cbm here"
    if [ $? -eq 0 ];then
        echo "Sub-processes killed."
    fi
}
 
SetTimer()
{
    Delaytime=$1
    echo $Delaytime
    if [ $Delaytime  -ne 0 ];then
        sleep $Delaytime  && kill -s 14 &
        TIMERPROC=$!
    fi
}
UnsetTimer()
{
    echo "Start to unset timer"
    kill $TIMERPROC
}
 
trap AlarmHandler 14
SetTimer 30

sleep 5
UnsetTimer
sleep 40
UnsetTimer
echo "ALL Done."
exit 0
