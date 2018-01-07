# Required ffmpeg

FILE_NAME=$1

WORK_DIR=$(pwd)

FILE_PATH=$WORK_DIR/$FILE_NAME

ffmpeg -i $FILE_PATH.mov -vf fps=20,scale=iw/2:ih/2,palettegen=stats_mode=diff -y $FILE_PATH.png && ffmpeg -i $FILE_PATH.mov -i $FILE_PATH.png -lavfi fps=20,scale=iw/2:ih/2,paletteuse -y $FILE_PATH.gif
