# Default pass length equal 8
PASS_LENGTH=8

for OPT in "$@"
do
  case $OPT in
    '-n' )
      PASS_LENGTH=$2
      ;;
  esac
done

# Password length validation
if [ $PASS_LENGTH -lt 6 ]; then
  echo "Password length requires 6."
  exit 1
fi

cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w $PASS_LENGTH | head -n 1
