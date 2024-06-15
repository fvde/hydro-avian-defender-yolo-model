#!/bin/bash

# sh local_predict.sh 1280 1280

## How to install on Pi
# - pip install --break-system-packages ultralytics
# sudo apt-get install libca

## How to Get Results
## scp -r pi@192.168.178.48:/home/pi/results/ .  

## Cron Tab Config
## * * * * * sh /home/pi/local_predict.sh 1024 1024 >> /home/pi/prediction.log 2>&1

PATH=/home/pi/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

width=${1}
height=${2}
confidence=0.5
classes=14 # Birds # 41 = Cup # 0 = Person # 44 = Spoon
file_name="latest.jpg"
label_file_name="latest.txt"
# target_dir=/home/pi/results/$(date +%F-%H:%M)/
target_dir=/home/pi/results/latest/

rm -rf /home/pi/runs
libcamera-still --width $width --height $height -n -o $file_name
yolo detect predict model=yolov8n.pt source=$file_name save=True imgsz=$width conf=$confidence save_txt=True classes=$classes

if [ -f /home/pi/runs/detect/predict/labels/$label_file_name ]; then
    echo 'We have detected something!'
    mkdir -p $target_dir
    # File
    cp /home/pi/runs/detect/predict/$file_name $target_dir
    # Labels
    cp /home/pi/runs/detect/predict/labels/$label_file_name $target_dir
else
    echo 'Nothing detected this time...'
fi

