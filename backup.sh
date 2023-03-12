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
TIMEFORMAT="Backup took %Rs"
time {
ranNum=$(($RANDOM % 999999 + 100000))
mkdir /tmp/$ranNum
cp $file /tmp/$ranNum/
pushd /tmp/$ranNum/
cat $file | tr -d '\r%<>' > tr1  #removes \r(return), %, <, >, from file
sed 's/^OO/O/' tr1 > allprog #if line starts OO replace with O
awk NF allprog >> 2allprog #remove blank lines
awk '/^$/ {next} BEGIN {FIELDWIDTHS="5"} /^O/ {fn=$1 ".NC";print "%">fn}{print>fn}' 2allprog #create program files from source
for i in *.NC ; do echo "%" >> $i ; done
popd
mkdir $folder$ranNum
cp /tmp/$ranNum/*.NC ./$folder$ranNum/
}
