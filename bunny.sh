#!/bin/bash

lin=`tput lines`
col=`tput cols`
pos1X=0
pos1Y=0
cc="\e[1;31m"
null="\e[0m"
count=0
tempX=0
tempY=0


trap "{ tput cnorm; echo \"YOU CANNOT KILL A BUNNY !\"; exit 0; }" SIGINT SIGTERM 

# ERASE LAST BUNNY
fun_erase_bunny()
{
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    tput dch 5
    tput ich 5
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    tput dch 5
    tput ich 5
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    tput dch 5
    tput ich 5
}

# UP
fun_up_bunny()
{
    tput sc
    fun_erase_bunny
    POSY[$cur]=$((${POSY[$cur]}-1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    echo -n "(\ /)"
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    echo -en "(${COLOR[$cur]}O${null}.${COLOR[$cur]}o${null})"
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    echo -n "(> <)"
    tput rc
}

# DOWN
fun_down_bunny()
{
    tput sc
    fun_erase_bunny
    POSY[$cur]=$((${POSY[$cur]}+1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    echo -n "(\ /)"
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    echo -en "(${COLOR[$cur]}O${null}.${COLOR[$cur]}o${null})"
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    echo -n "(> <)"
    tput rc
}

# LEFT
fun_left_bunny()
{
    tput sc
    fun_erase_bunny
    POSX[$cur]=$((${POSX[$cur]}-1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    echo -n "(\ /)"
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    echo -en "(${COLOR[$cur]}O${null}.${COLOR[$cur]}o${null})"
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    echo -n "(> <)"
    tput rc
}

# RIGHT
fun_right_bunny()
{
    tput sc
    fun_erase_bunny
    POSX[$cur]=$((${POSX[$cur]}+1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    echo -n "(\ /)"
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    echo -en "(${COLOR[$cur]}O${null}.${COLOR[$cur]}o${null})"
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    echo -n "(> <)"
    tput rc
}

# 256 RANDOM COLOR
fun_random_256()
{
    rand=-1
    while [ $rand -lt 0 ]
    do
        rand=$RANDOM
        let "rand %= 255"
    done
    echo $rand
}

# NEW DESTINATION
fun_get_new_destination()
{
    NEXTX[$1]=$(($RANDOM%$(($col-6))))
    NEXTY[$1]=$(($RANDOM%$((lin-4))))
}

cur=0;
max=1;

POSX[0]=0
POSY[0]=2
fun_get_new_destination 0
RANDX[0]=$(($RANDOM%$(($col-6))))
RANDY[0]=$(($RANDOM%$((lin-4))))
COLOR[0]="\e[38;5;"$(fun_random_256)"m"

while true;
do
    sleep 0.05

    if [ $count -ge 100 ] && [ $max -lt 6 ]
    then
        POSX[$max]=60
        POSY[$max]=2
        fun_get_new_destination $max
        RANDX[$max]=$(($RANDOM%$(($col-6))))
        RANDY[$max]=$(($RANDOM%$((lin-4))))
        COLOR[$max]="\e[38;5;"$(fun_random_256)"m"
        max=$(($max+1))
        count=0
    else
        count=$(($count+1))
    fi

    while [ $cur -lt $max ];
    do
        COLOR[$cur]="\e[38;5;"$(fun_random_256)"m"

        tput civis
        if [ ${POSY[$cur]} -lt ${NEXTY[$cur]} ]; then fun_down_bunny
        elif [ ${POSX[$cur]} -gt ${NEXTX[$cur]} ]; then fun_left_bunny
        elif [ ${POSY[$cur]} -gt ${NEXTY[$cur]} ]; then fun_up_bunny
        elif [ ${POSX[$cur]} -lt ${NEXTX[$cur]} ]; then fun_right_bunny
        else fun_get_new_destination $cur
        fi
        tput cnorm

        cur=$(($cur+1))
    done
    cur=$((${cur}%${max}))
done
