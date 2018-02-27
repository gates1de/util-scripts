# Required ghostscript

################################################
# Usage
# ./resize_pdf.sh -w 128 -h 128 path/to/hoge.pdf
################################################


# Get file path(last argument is file path)

FILE_PATH=${@: -1}
FILE_NAME=`basename ${FILE_PATH}`


# Set default size(get file size)

SIZE_ARRAY=(`identify -format "%[fx:w]x%[fx:h]" $FILE_PATH | tr 'x' '\n'`)
WIDTH=${SIZE_ARRAY[0]}
HEIGHT=${SIZE_ARRAY[1]}

while getopts w:h: OPT
do
    case $OPT in
        "w" ) WIDTH="$OPTARG" ;;
        "h" ) HEIGHT="$OPTARG" ;;
    esac
done


# Resize
gs -o "${WIDTH}x${HEIGHT}_${FILE_NAME}" -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=$WIDTH -dDEVICEHEIGHTPOINTS=$HEIGHT -dPDFFitPage $FILE_PATH
