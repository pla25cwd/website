#!/bin/bash

CHAR_PLAYER="#"
CHAR_ITEM="@"


declare RESOLUTION_X=$(( $(tput cols)/2 ))
declare RESOLUTION_Y=$(tput lines)

declare -i ITEM_X=15
declare -i ITEM_Y=15
declare -a ITEM_E_X
declare -a ITEM_E_Y
declare -a PREVIOUS_X=("5" "5" "5" "5")
declare -a PREVIOUS_Y=("1" "2" "3" "4")
declare -i PLAYER_LENGTH=1
declare -i HEAD_X=5
declare -i HEAD_Y=5
declare -i VEC_X=0
declare -i VEC_Y=1
declare INPUT
declare TEMP_X
declare TEMP_Y

declare FT_START
declare FT_TARGET=20000
declare FT_END

clear
stty -echo
tput civis

trap 'stty echo;tput cvvis;kill "$$"' SIGINT

echo -en "\033[$ITEM_Y;$(($ITEM_X*2))H"
echo -n "$CHAR_ITEM"

while true;do
	FT_START="$(echo $EPOCHREALTIME | tail -c 15 | tr -d .)"
	case "$INPUT" in
		"w" ) if [[ "$VEC_X,$VEC_Y" != "0,1" ]];then VEC_X=0 ; VEC_Y=-1;fi;;
		"a" ) if [[ "$VEC_X,$VEC_Y" != "1,0" ]];then VEC_X=-1 ; VEC_Y=0;fi;;
		"s" ) if [[ "$VEC_X,$VEC_Y" != "0,-1" ]];then VEC_X=0 ; VEC_Y=1;fi;;
		"d" ) if [[ "$VEC_X,$VEC_Y" != "-1,0" ]];then VEC_X=1 ; VEC_Y=0;fi;;
	esac
	HEAD_X+="$VEC_X"
	HEAD_Y+="$VEC_Y"
	if [[ "$HEAD_X" -gt "$RESOLUTION_X" ]];then HEAD_X=1;elif [[ "$HEAD_X" -lt "1" ]];then HEAD_X=$RESOLUTION_X;fi
	if [[ "$HEAD_Y" -gt "$RESOLUTION_Y" ]];then HEAD_Y=1;elif [[ "$HEAD_Y" -lt "1" ]];then HEAD_Y=$RESOLUTION_Y;fi

	if [[ "$HEAD_X,$HEAD_Y" == "$ITEM_X,$ITEM_Y" ]];then
		PLAYER_LENGTH+=1
		ITEM_E_X="$(echo -n "${PREVIOUS_X[$PLAYER_LENGTH]}" | tr " " ",")"
		ITEM_E_Y="$(echo -n "${PREVIOUS_Y[$PLAYER_LENGTH]}" | tr " " ",")"
		ITEM_X="$(shuf -n 1 <(seq $RESOLUTION_X | grep -Fxv -e{$ITEM_E_X}))"
		ITEM_Y="$(shuf -n 1 <(seq $RESOLUTION_Y | grep -Fxv -e{$ITEM_E_Y}))"

		echo -en "\033[$ITEM_Y;$(($ITEM_X*2))H"
		echo -n "$CHAR_ITEM"

		PREVIOUS_X=("${PREVIOUS_X[@]: -1,-$PLAYER_LENGTH}")
		PREVIOUS_Y=("${PREVIOUS_Y[@]: -1,-$PLAYER_LENGTH}")

	fi

	for i in $(seq 1 $PLAYER_LENGTH);do
		if [[ "${PREVIOUS_X[-$i]}" == "$HEAD_X" && "${PREVIOUS_Y[-$i]}" == "$HEAD_Y" ]];then
			TEMP_PREVIOUS_X=("${PREVIOUS_X[@]: -2,-(($PLAYER_LENGTH+2))}")
			TEMP_PREVIOUS_Y=("${PREVIOUS_Y[@]: -2,-(($PLAYER_LENGTH+2))}")
			sleep 1
			for c in $(seq 1 $PLAYER_LENGTH);do
				TEMP_X="${TEMP_PREVIOUS_X[$c]}"
				TEMP_Y="${TEMP_PREVIOUS_Y[$c]}"
				sleep 0.2
				echo -en "\033[$TEMP_Y;$(($TEMP_X*2))H"
				echo -n " "
			done
			PLAYER_LENGTH=1
			sleep 1
			break
		fi
	done

	TEMP_X="${PREVIOUS_X[-$PLAYER_LENGTH]}"
	TEMP_Y="$(echo ${PREVIOUS_Y[-$PLAYER_LENGTH]} | cut -d ',' -f 2)"
	echo -en "\033[$TEMP_Y;$((TEMP_X*2))H"
	echo -n " "

	echo -en "\033[$HEAD_Y;$((HEAD_X*2))H"
	echo -n "$CHAR_PLAYER"

	PREVIOUS_X+=("$HEAD_X")
	PREVIOUS_Y+=("$HEAD_Y")

	FT_END="$(echo $EPOCHREALTIME | tail -c 15 | tr -d .)"
	INPUT=""
	while ((( 10#$FT_END - 10#$FT_START) < 10#$FT_TARGET));do
		FT_END="$(echo $EPOCHREALTIME | tail -c 15 | tr -d .)"
		read -t 0.02 -n 1 REPLY
		if [[ $REPLY == *@(w|a|s|d)* ]]; then INPUT=$REPLY; fi
	done
done
