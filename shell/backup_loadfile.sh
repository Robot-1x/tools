NAME=api-1.0.jar
PATH=/root/algo/

echo ----------File modify time: $NAME --------------
modify_time=`stat -c %Y  $PATH$NAME`
d1=`date '+%Y%m%d%H%M' -d @$modify_time`
echo $d1 $modify_time

echo ----------Process ID: $NAME --------------
ID=`ps -ef | grep "$NAME" | grep -v "$0" | grep -v "grep" | awk '{print $2}'`
echo ----------Find pid:$ID----------------------

if [ -z $ID ]; then
    echo '--------No java proces running------------------'
    cp $PATH$NAME $PATH${d1}"_"${NAME}
    nohup java -jar $PATH$NAME  > ${PATH}log.log &
    if [ $? -ne 0 ]; then
        LOG_WARN "Failed to get the performance baseline of $PHYSICAL_MODEL for $INSTANCE_FAMILIES."
        exit 2
    fi
    exit 0
else
    start_time=`stat -c %Y /proc/$ID`
    echo $ID  $start_time
    echo $modify_time

    if [ $start_time -lt $modify_time ]; then
        cp $PATH$NAME $PATH${d1}"_"${NAME}
        kill -9 $ID
        nohup java -jar $PATH$NAME  > ${PATH}log.log &
        if [ $? -ne 0 ]; then
            LOG_WARN "Failed to get the performance baseline of $PHYSICAL_MODEL for $INSTANCE_FAMILIES."
            exit 2
        fi
        exit 0
    fi
fi
