# Required ffmpeg

FILE_NAME=$1

WORK_DIR=$(pwd)

FILE_PATH=$WORK_DIR/$FILE_NAME

FPS=20

DIVIDE_SCALE=3

SPEED_MAGNIFICATION=1.5


ffmpeg -i $FILE_PATH.mov \
  -vf fps=$FPS,scale=iw/$DIVIDE_SCALE:ih/$DIVIDE_SCALE,palettegen=stats_mode=diff \
  -y $FILE_PATH.png \
  && ffmpeg -i $FILE_PATH.mov \
    -i $FILE_PATH.png \
    -lavfi fps=$FPS,scale=iw/$DIVIDE_SCALE:ih/$DIVIDE_SCALE,paletteuse,setpts=PTS/$SPEED_MAGNIFICATION \
    -y $FILE_PATH.gif
