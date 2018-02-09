USER=$1
DB=$2
TABLE=$3
TARGET_DIR=$4

mysqldump -u $USER -p $DB $TABLE --tab=$TARGET_DIR --fields-terminated-by=',' --fields-optionally-enclosed-by='"' -t --skip-triggers
