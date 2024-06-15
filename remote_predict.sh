#!/bin/bash

# sh predict.sh 192.168.178.48 1280 1280

host=${1}
width=${2}
height=${3}
brightness=0.1
confidence=0.5
classes=14 # Birds
file_name="latest.jpg"
label_file_name="latest.txt"
target_dir=results/$(date +%F-%H:%M)/

# Currently not used
# libcamera-still --brightness $brightness 

## TODO for inference
# - classes

ssh pi@$host << EOF
  rm -rf /home/pi/runs
  libcamera-still --width $width --height $height -n -o $file_name
  yolo detect predict model=yolov8n.pt source=$file_name save=True imgsz=$width conf=$confidence save_txt=True classes=$classes
EOF

if ssh pi@$host [[ -f /home/pi/runs/detect/predict/labels/$label_file_name ]]; then
    echo 'We have detected something!'
    mkdir -p $target_dir
    # File
    scp pi@$host:/home/pi/runs/detect/predict/$file_name $target_dir
    # Labels
    scp pi@$host:/home/pi/runs/detect/predict/labels/$label_file_name $target_dir
else
    echo 'Nothing detected this time...'
fi

