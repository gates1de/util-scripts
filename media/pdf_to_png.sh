FILE_NAME=$1

WORK_DIR=$(pwd)

FILE_PATH=$WORK_DIR/$FILE_NAME

sips -s format png $FILE_PATH.pdf --out $FILE_PATH.png
