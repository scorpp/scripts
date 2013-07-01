#!/bin/bash
#
# Kind of a replacement (or an addon) to usual Alt+Tab functionality 
# inspired by OpenBSD's cwm and shows a popupping up dmenu with list of 
# currently open windows allowing you to quickly switch between them by
# typing window title.
#
# Dependencies: bash, dmenu, wmctrl
#

current_vd=$(wmctrl -d | sed 's/\( \)\+/ /g' | cut -d' ' -f1,2 |
	grep -F '*' | cut -d' ' -f1)
echo "Current virtual desktop is ${current_vd}"
# TODO allow filtering by virtual desktop

oIFS="${IFS}"
IFS=$'\n'

wmlist=`wmctrl -l | sed 's/\( \)\+/ /g'`
wids=(`echo "${wmlist}" | cut -d' ' -f1`)
titles=(`echo "{$wmlist}" | cut -d' ' -f4-`)

IFS="${oIFS}"


ditem=$(printf "%s\n" "${titles[@]}" | awk '{print NR " " $0}' |  
	dmenu -i -l 5 -p "Title >" | cut -d' ' -f1)
if [ "${ditem}x" != "x" ]; then
        widx=$(expr ${ditem}  - 1)
        echo "Selected: ${wids[$widx]} ${titles[$widx]}"
        wmctrl -ia ${wids[$widx]}
fi
# user may have pressed ESC and nothing should be done
