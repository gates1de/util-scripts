# TODO: IAM_GROUP_NAME は引数で取得すること
IAM_GROUP_NAME='admin'
IAM_POLICY_NAME='AmazonKinesisFullAccess'

# プロファイル確認
aws configure list

# IAMグループの取得
aws iam get-group --group-name ${IAM_GROUP_NAME}


# IAMグループがあれば処理終了
if [ $? -eq 0 ]; then
  echo "Already exists '${IAM_GROUP_NAME}'."
  exit 1
else
  echo "'${IAM_GROUP_NAME}' does not exist. Next, check IAM policy."
fi


# 存在するポリシーの確認
aws iam list-policies --scope AWS --max-items 1000 --query 'Policies[].PolicyName'

# ARN の取得
IAM_POLICY_ARN=`aws iam list-policies --max-items 1000 |  jq -r --arg name ${IAM_POLICY_NAME} '.Policies[] | select( .PolicyName == $name ) | .Arn'` && echo ${IAM_POLICY_ARN}
# ポリシーバージョンの取得
IAM_POLICY_VERSION=`aws iam list-policies --max-items 1000 |  jq -r --arg name ${IAM_POLICY_NAME} '.Policies[] | select( .PolicyName == $name ) | .DefaultVersionId'` && echo ${IAM_POLICY_VERSION}

# IAMポリシーの確認
aws iam get-policy-version --policy-arn ${IAM_POLICY_ARN} --version-id ${IAM_POLICY_VERSION}


if [ $? -eq 1 ]; then
  echo 'Failed check IAM policy.'
  exit 1
else
  echo 'Next, create ↓ this IAM group.'
  echo $IAM_GROUP_NAME
fi


# TODO: こっからエラーハンドリングしてない

# IAMグループの作成
aws iam create-group --group-name ${IAM_GROUP_NAME}

# IAMグループの作成確認
aws iam get-group --group-name ${IAM_GROUP_NAME}

# IAMグループポリシーの確認
aws iam list-attached-group-policies --group-name ${IAM_GROUP_NAME}

# IAMグループポリシーのアタッチ
aws iam attach-group-policy --group-name ${IAM_GROUP_NAME} --policy-arn ${IAM_POLICY_ARN}

# IAMグループポリシーのアタッチ確認
aws iam list-attached-group-policies --group-name ${IAM_GROUP_NAME}
