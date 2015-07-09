#!/bin/bash

##
# find.sh
# find for the specified keyword from all of the fiels in the directory.
#
# @author kuroneko
# @copyright 2015 kuroneko. All rights reserved.
##

search=

usage(){
    echo ""
    echo "Usage: bash $0 <find file or directory> <search keyword>"
    echo ""
    echo "       If specify a file name, find for the specified keyword from within the file."
    echo ""
    echo "       If specify a directory name, find for the specified keyword from all of the files in the directory."
    echo "       In that case, find the specified directory recursively."
    echo ""
}

kgrep(){
    _result=`cat "$1" | grep -a -n "${search}" 2> /dev/null`
    if [ -n "${_result}" ]
    then
        echo "`pwd`/$1"
        echo "${_result[@]}"
        echo ""
    fi
}

kfind(){
    if [ -n "$1" ]
    then
        cd "$1"
    fi

    if [ -n "$(ls -A)" ]
    then
        for _file in * .*
        do
            if [ "${_file}" = '.' -o "${_file}" = '..' ]
            then
                continue
            fi

            if [ -d "${_file}" ]
            then
                kfind "${_file}" "${search}"
            elif [ -f "${_file}" ]
            then
                kgrep ${_file}
            fi
        done
    fi

    cd ../
}

if [ -z "$1" -o -z "$2" ]
then
    usage
else
    search="$2"
    if [ -d "$1" ]
    then
        kfind "$1"
    elif [ -f "$1" ]
    then
        kgrep "$1"
    fi
fi

