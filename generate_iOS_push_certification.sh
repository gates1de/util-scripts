APP_IDENTIFIER=$1

WORK_DIR=$(pwd)

openssl pkcs12 -in ${WORK_DIR}/${APP_IDENTIFIER}.p12 -nokeys -out ${WORK_DIR}/${APP_IDENTIFIER}_cert.pem -nodes && openssl pkcs12 -in ${WORK_DIR}/${APP_IDENTIFIER}.p12 -nocerts -out ${WORK_DIR}/${APP_IDENTIFIER}_key.pem -nodes && openssl rsa -in ${WORK_DIR}/${APP_IDENTIFIER}_key.pem -out ${WORK_DIR}/${APP_IDENTIFIER}_key.pem
