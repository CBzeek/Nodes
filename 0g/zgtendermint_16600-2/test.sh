#!/bin/bash
if [ -n "$1" ] && [ $1 = "test" ]
then
    echo $1
else
    echo 'No arguments'
fi
