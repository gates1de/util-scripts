APP_IDENTIFIER=$1

WORK_DIR=$(pwd)

openssl pkcs12 -in ${WORK_DIR}/${APP_IDENTIFIER}.p12 -nocerts -out ${WORK_DIR}/${APP_IDENTIFIER}_key.pem && openssl rsa -in ${WORK_DIR}/${APP_IDENTIFIER}_key.pem -out ${WORK_DIR}/${APP_IDENTIFIER}_key.pem && openssl pkcs12 -in ${WORK_DIR}/${APP_IDENTIFIER}.p12 -clcerts -nokeys -out ${WORK_DIR}/${APP_IDENTIFIER}_cert.pem 
