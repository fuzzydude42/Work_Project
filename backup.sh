#!/usr/bin/bash
#bash creates varibales <scriptname> <$1> <$2> <$3> <...>
file=$1
folder=${file%%.*}  #removes everything after first period from file name
folder=$2"_"$folder"_backup"
if [ -z "$file" ] #if variable is null exit
then
  printf "\nNo file selected \nUsage  backup.sh <filename> <machineName> \n\n"
  exit 1
fi
now="_$(date +%m-%d-%Y_%H-%M-%S)" #adjust for local date/time format
working=/run/user/1002/
mkdir "$working"$now
cp $file "$working"$now/
pushd "$working"$now/
cat $file | tr -d '\r%<>' > tr1  #removes \r(return), %, <, >, from file
sed 's/^OO/O/' tr1 > allprog #if line starts OO replace with O
awk NF allprog >> 2allprog #remove blank lines
awk '/^O/' 2allprog > ATableOfContents.txt  #create a table of contents with first line of each prog
awk '/^$/ {next} BEGIN {FIELDWIDTHS="5"} /^O/ {fn=$1 ".NC";print "%">fn}{print>fn}' 2allprog #create program files from sour>for i in *.NC ; do echo "%" >> $i ; done
popd
mkdir $folder$now
cp "$working"$now/*.NC ./$folder$now/
cp "$working"$now/ATableOfContents.txt ./$folder$now/
rm -r "$working"$now
sleep 2
