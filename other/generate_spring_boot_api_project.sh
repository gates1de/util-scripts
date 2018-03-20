################################################
# Usage
# ./generate_spring_boot_api_project.sh \
#    --group-id com.sample \
#    --artifact-id app \
#    --name spring-boot-api \
#    --java 9
################################################

function usage() {
    cat << EOS >&2
Usage: ${THIS_SHELL} [-h,--help] [--group-id VALUE]  [--artifact-id VALUE]  [--name VALUE] [--java VALUE]
A sample script of parsing on bash.

Options:
    --artifact-id  Application artifact id. (e.g. 'sample.api.app')
    --group-id     Group(Company) id.
    --name         App name.
    --java         Java version.
    -h, --help     Show usage.
EOS
  exit 1
}

GROUP_ID=""
ARTIFACT_ID=""
APP_NAME=""
JAVA_VERSION=0

for opt in "$@"; do
    case "${opt}" in
    #case $OPT in
        '-h' | '--help' )
            usage
            ;;
        '--group-id' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "${THIS_SHELL}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
                exit 1
            fi

            GROUP_ID="$2"
            shift 2
            ;;
        '--artifact-id' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "${THIS_SHELL}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
                exit 1
            fi

            ARTIFACT_ID="$2"
            shift 2
            ;;
        '--name' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "${THIS_SHELL}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
                exit 1
            fi

            APP_NAME="$2"
            shift 2
            ;;
        '--java' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "${THIS_SHELL}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
                exit 1
            fi

            JAVA_VERSION=$2
            shift 2
            ;;
    esac
done


if [ ! -n "$GROUP_ID" ]; then
    echo "Required --group-id"
    exit 1
fi

if [ ! -n "$ARTIFACT_ID" ]; then
    echo "Required --artifact-id"
    exit 1
fi

if [ ! -n "$APP_NAME" ]; then
    echo "Required --name"
    exit 1
fi

if [[ $JAVA_VERSION =~ [0-6] ]]; then
    echo "Required --java option."
    exit 1
fi


curl https://start.spring.io/starter.zip \
    -d dependencies=web \
    -d groupId=$GROUP_ID \
    -d artifactId=${ARTIFACT_ID} \
    -d packageName=${GROUP_ID}.${ARTIFACT_ID} \
    -d type=gradle-project \
    -d language=java \
    -d javaVersion=$JAVA_VERSION \
    -d name=$APP_NAME \
    -d baseDir=$APP_NAME \
    -o ${APP_NAME}.zip
