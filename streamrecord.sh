#!/bin/bash
StreamURL=$1
ProgramName=$2
ProgramDuration=$3
SaveDirectory=$4
Today=`date +%Y-%m-%d`
mkdir -p ${SaveDirectory} 
cd ${SaveDirectory}
FileName=${ProgramName}_${Today}.mp3 
FileNameLatest=${ProgramName}_Latest.mp3


#-- Shortname var
GDriveRoot=GDriveUT:/drive/multimedia/podcast
ACDRoot=ACD:/multimedia/podcast
RCLONE_EXE=/usr/local/bin/rclone

# record
mplayer $StreamURL -dumpstream -dumpfile $FileName > /dev/null 2>&1 &
Pid=$!
sleep ${ProgramDuration}m
kill ${Pid}

/usr/local/bin/podcast_id3tag $FileName 

ProgramDir=$(basename $SaveDirectory)
$RCLONE_EXE -q copy ${SaveDirectory} $GDriveRoot/${ProgramDir} && \
  $RCLONE_EXE -q copy ${SaveDirectory} $ACDRoot/${ProgramDir} && \
  rm -rf $SaveDirectory

#if [[ $FileName == "MorningEdition"* ]]; then 
#  cp -f $FileName ../Latest/${FileNameLatest}
#fi    
#
#if [[ $FileName == "DianeRehm"* ]]; then 
#  cp -f $FileName ../Latest/${FileNameLatest}
#fi    

#sshpass -p XXXXXXX ssh plexvm \
#'export LD_LIBRARY_PATH=/usr/lib/plexmediaserver;/usr/lib/plexmediaserver/plexscanner --section 15 --scan'
