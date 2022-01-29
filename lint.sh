SCRIPT_DIR=$(cd $(dirname $0); pwd)
source ${SCRIPT_DIR}/params.cfg

# OASが分割されている場合 dredd は利用できないので
# OASが分割されている場合mergeする。

docker run -it --rm -v $SCRIPT_DIR/..:/app \
properdom/swagger-merger swagger-merger \
-i app/$FILE \
-o app/$DREDD_DIR/tmp/merged.yml

# リント

docker run -it --rm -v $SCRIPT_DIR/..:/openapi \
--add-host=host.docker.internal:host-gateway \
apiaryio/dredd sh -c \
"dredd openapi/$DREDD_DIR/tmp/merged.yml $API_URL \
-d --names --no-color | \
grep -e 'warn\:'"
