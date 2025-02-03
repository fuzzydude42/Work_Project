#!/usr/bin/bash
#bash creates varibales <scriptname> <$1> <$2> <$3> <...>
#make sure gawk (GNU Awk) is installed "sudo apt install gawk"
#link script into /bin to be able to run it anywhere, and changes the name, dropping the suffix
#sudo ln -s /home/[user]/script/backup.sh /bin/backup

#find tmpfs folders with "df -h"

file=$1
folder=${file%%.*}  #removes everything after first period from file name
folder=$2"_"$folder"_backup"
if [ -z "$file" ] #if variable is null exit
then
  printf "\nNo file selected \nUsage  backup.sh <filename> <machineName> \n\n"
  exit 1
fi
ranNum=$(($RANDOM % 999999 + 100000))
#formaly used /tmp.. but its not tmpfs under wsl
working=/run/user/1002/
mkdir "$working"$ranNum
cp $file "$working"$ranNum/
pushd "$working"$ranNum/
cat $file | tr -d '\r%<>' > tr1  #removes \r(return), %, <, >, from file
sed 's/^OO/O/' tr1 > allprog #if line starts OO replace with O
awk NF allprog >> 2allprog #remove blank lines
awk '/^O/' 2allprog > ATableOfContents.txt  #create a table of contents with first line of each prog
awk '/^$/ {next} BEGIN {FIELDWIDTHS="5"} /^O/ {fn=$1 ".NC";print "%">fn}{print>fn}' 2allprog #create program files from>for i in *.NC ; do echo "%" >> $i ; done
popd
mkdir $folder$ranNum
cp "$working"$ranNum/*.NC ./$folder$ranNum/
cp "$working"$ranNum/ATableOfContents.txt ./$folder$ranNum/
rm -r "$working"$ranNum
