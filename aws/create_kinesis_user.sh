export AWS_DEFAULT_REGION='ap-northeast-1'

IAM_GROUP_NAME='aws'
IAM_POLICY_NAME="AmazonKinesisFullAccess"
PROJECT_NAME='dev2g-hackathon-201801'
WORK_LOCATION_NAME=$(pwd)
IAM_PASSWORD_NEW='password1!'
CF_DESC="${IAM_GROUP_NAME} for handson."
FILE_CF_TEMPLATE="cf-${IAM_GROUP_NAME}-handson.template"

# プロファイル確認
aws configure list

cat << ETX
  IAM_PASSWORD_NEW: ${IAM_PASSWORD_NEW}
  IAM_GROUP_NAME:   ${IAM_GROUP_NAME}
  CF_DESC:          ${CF_DESC}
  FILE_CF_TEMPLATE: ${FILE_CF_TEMPLATE}
ETX


cat << EOF > ${FILE_CF_TEMPLATE}
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "${CF_DESC}",
  "Resources": {
    "user": {
      "Type": "AWS::IAM::User",
      "Properties": {
        "LoginProfile": {
          "Password": "${IAM_PASSWORD_NEW}"
        }
      }
    },
    "belongGroups": {
      "Type": "AWS::IAM::UserToGroupAddition",
      "Properties": {
        "GroupName": "${IAM_GROUP_NAME}",
        "Users": [
          {
            "Ref": "user"
          }
        ]
      }
    }
  },
  "Outputs" : {
    "UserName" : {
      "Value" : { "Ref" : "user" },
      "Description" : "UserName of new user"
    }
  }
}
EOF

# できれば jsonlint をインストールしてjsonのチェックをすること
jsonlint -q ${FILE_CF_TEMPLATE}


# jsonフォーマットが大丈夫なら処理継続
if [ $? -eq 0 ]; then
  echo 'Json format ok. Next, create CloudFormation stack.'
else
  echo "'${IAM_GROUP_NAME}' does not exist. Next, check IAM policy."
  exit 1
fi

# CloudFormation のバリデーションチェック
aws cloudformation validate-template --template-body file://${FILE_CF_TEMPLATE}

# スタック名の決定
CF_STACK_NAME="${IAM_GROUP_NAME}-${PRJ_NAME}-${LOC_NAME}" && echo ${CF_STACK_NAME}

cat << ETX
  CF_STACK_NAME:    ${CF_STACK_NAME}
  FILE_CF_TEMPLATE: ${FILE_CF_TEMPLATE}
ETX

# スタックの作成
aws cloudformation create-stack --stack-name "${CF_STACK_NAME}" --template-body file://${FILE_CF_TEMPLATE} --capabilities 'CAPABILITY_IAM'

CF_STACK_STATUS=`aws cloudformation list-stacks | jq -r --arg stackname ${CF_STACK_NAME} '.StackSummaries[] | select(.StackName == $stackname) | .StackStatus'` && echo ${CF_STACK_STATUS}


if [ $CF_STACK_STATUS = "CREATE_COMPLETE" ] then
  echo 'Create stack successfully. Next, create IAM user.'
else
  echo 'Create stack failed. Because:'
  aws cloudformation describe-stack-events --stack-name ${CF_STACK_NAME}
  # 既に存在している可能性があるので処理は継続
fi

# TODO: こっからエラーハンドリングしていない

# 作成されたスタックの確認
aws cloudformation get-template --stack-name ${CF_STACK_NAME}

# スタック名からユーザ名取得
CF_STACK_OUTPUT_KEY='UserName'
STR_QUERY="Stacks[].Outputs[?OutputKey==\`${CF_STACK_OUTPUT_KEY}\`].OutputValue" && echo ${STR_QUERY}
CF_STACK_OUTPUT_VALUE=`aws cloudformation describe-stacks --stack-name ${CF_STACK_NAME} --query ${STR_QUERY} --output text`  && echo ${CF_STACK_OUTPUT_VALUE}
IAM_USER_NAME=${CF_STACK_OUTPUT_VALUE}

# 作成されたIAMユーザの名前を取得
aws iam get-user --user-name ${IAM_USER_NAME}

# IAMユーザが所属しているグループの確認
IAM_GROUP_NAME=`aws iam list-groups-for-user \
        --user-name ${IAM_USER_NAME} \
        --query 'Groups[].GroupName' \
        --output text` \
        && echo ${IAM_GROUP_NAME}


# アクセスキーの作成
aws iam create-access-key --user-name ${IAM_USER_NAME} > ${IAM_USER_NAME}.json && cat ${IAM_USER_NAME}.json

SOURCE_DIR='~/.aws/source'
mkdir -p $SOURCE_DIR

cat ${IAM_USER_NAME}.json |\
        jq '.AccessKey | {AccessKeyId, SecretAccessKey}' |\
        sed '/[{}]/d' | sed 's/[\" ,]//g' | sed 's/:/=/' |\
        sed 's/AccessKeyId/aws_access_key_id/' |\
        sed 's/SecretAccessKey/aws_secret_access_key/' \
        > ${SOURCE_DIR}/${IAM_USER_NAME}.rc \
        && cat ${SOURCE_DIR}/${IAM_USER_NAME}.rc

REGION_AWS_CONFIG="${AWS_DEFAULT_REGION}"


FILE_USER_CONFIG="${SOURCE_DIR}/${IAM_USER_NAME}.config"

echo "[profile ${IAM_USER_NAME}]" > ${FILE_USER_CONFIG} \
        && echo "region=${REGION_AWS_CONFIG}" >> ${FILE_USER_CONFIG} \
        && echo "" >> ${FILE_USER_CONFIG} \
        && cat ${FILE_USER_CONFIG}

CREDENTIAL_FILE='~/.aws/credentials'
CREDENTIAL_FILE_BAK="${CREDENTIAL_FILE}.bak"
cp ${CREDENTIAL_FILE} ${CREDNETIAL_FILE_BAK}

if [ -e ${CREDENTIAL_FILE} ]; then mv ${CREDENTIAL_FILE} ${CREDENTIAL_FILE_BAK}; fi
for i in `ls ${HOME}/.aws/source/*.rc`; do \
        name=`echo $i | sed 's/^.*\///' | sed 's/\.rc$//'` \
        && echo "[$name]" >> ${CREDENTIAL_FILE} \
        && cat $i >> ${CREDENTIAL_FILE} \
        && echo "" >> ${CREDENTIAL_FILE} ;done \
        && cat ${CREDENTIAL_FILE}

CONFIG_FILE='~/.aws/config.bak'
CONFIG_FILE_BAK='~/.aws/config.bak'
cp ${CONFIG_FILE} ${CONFIG_FILE_BAK}
cat ${HOME}/.aws/source/*.config > ${HOME}/.aws/config && cat ${HOME}/.aws/config
