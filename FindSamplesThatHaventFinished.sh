#!/bin/bash
### This is a work in progress
### It finds files with a pattern and copies them to a directory
### Then it compares these files with the "master" list of samples
### It will then find the files that haven't been completed and
### Print a detailed list of these samples
find sub_results* -name "*NJ*.tsv" -exec cp "{}" ./tsvFiles/ \;
ls *.tsv | grep -oE "NJ-BioR-[[:digit:]]+" | uniq > finished.txt
ls ../AllFastqFiles/*R1*.fastq | grep -oE "NJ-BioR-[[:digit:]]+" | uniq > allFiles.txt
diff allFiles.txt finished.txt | grep -oE "NJ-BioR-[[:digit:]]{3}" | uniq > notYetCompleted.txt
function myIterate {
while read p; do
  ls -lh ../AllFastqFiles/"$p"* >> notYetCompletedLong.txt
done <notYetCompleted.txt
}
myIterate
grep -vE "*Ampli*" notYetCompletedLong.txt
rm notYetCompletedLong.txt
