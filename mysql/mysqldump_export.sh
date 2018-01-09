USER=$1
DB=$2
TABLE=$3

mysqldump -u $USER -p $DB $TABLE --tab=~/Downloads --fields-terminated-by=',' --fields-optionally-enclosed-by='"' -t --skip-triggers
