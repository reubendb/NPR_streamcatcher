#!/bin/bash
StreamKeyword=$1
ProgramName=$2
ProgramDuration=$3
SaveDirectory=$4/$2
Today=`date +%Y-%m-%d`
mkdir -p ${SaveDirectory} 
cd ${SaveDirectory}
FileName=${ProgramName}_${Today}.mp3 
FileNameLatest=${ProgramName}_Latest.mp3

case $StreamKeyword in
'WUOT'  ) StreamURL="http://playerservices.streamtheworld.com/api/livestream-redirect/WUOTFM.mp3" ;;
'WUOT2' ) StreamURL="http://playerservices.streamtheworld.com/api/livestream-redirect/WUOTHD2.mp3" ;;
*       ) StreamURL="http://playerservices.streamtheworld.com/api/livestream-redirect/WUOTFM.mp3" ;;
esac

# record
mplayer $StreamURL -dumpstream -dumpfile $FileName > /dev/null 2>&1 &
Pid=$!
sleep ${ProgramDuration}m
kill ${Pid}

#-- 
ExecDir=$(dirname $0)
${ExecDir}/podcast_id3tag $FileName 

#-- If save remotely
##-- Shortname var
#GDriveRoot=GDriveUT:/drive/multimedia/podcast
#ACDRoot=ACD:/multimedia/podcast
#RCLONE_EXE=/usr/local/bin/rclone
#
#ProgramDir=$(basename $SaveDirectory)
#$RCLONE_EXE -q copy ${SaveDirectory} $GDriveRoot/${ProgramDir} && \
#  $RCLONE_EXE -q copy ${SaveDirectory} $ACDRoot/${ProgramDir} && \
#  rm -rf $SaveDirectory

#if [[ $FileName == "MorningEdition"* ]]; then 
#  cp -f $FileName ../Latest/${FileNameLatest}
#fi    
#
#if [[ $FileName == "DianeRehm"* ]]; then 
#  cp -f $FileName ../Latest/${FileNameLatest}
#fi    

#sshpass -p XXXXXXX ssh plexvm \
#'export LD_LIBRARY_PATH=/usr/lib/plexmediaserver;/usr/lib/plexmediaserver/plexscanner --section 15 --scan'
