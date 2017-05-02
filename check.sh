#########################################################################
# File Name: check.sh
# Author: eric.xu
# mail: eric.xu@libratone.com.cn
# Created Time: 2017年02月21日 星期二 21时30分13秒
#########################################################################
#!/bin/bash

while [ 1 ]
do
    for line in `ps -aux | grep ffplay| awk '{ if($10 > "0:01")print $2}'`;do kill $line; done
    for line in `ps -aux | grep mplayer| awk '{ if($10 > "0:01")print $2}'`;do kill $line; done
    sleep 120
done

