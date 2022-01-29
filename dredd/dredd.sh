SCRIPT_DIR=$(cd $(dirname $0); pwd)
source ${SCRIPT_DIR}/params.cfg

HOOKFILES="${SCRIPT_DIR}/hooks/*.js"

# OASが分割されている場合 dredd は利用できないので
# OASが分割されている場合mergeする。

docker run -it --rm -v $SCRIPT_DIR:/app \
properdom/swagger-merger swagger-merger \
-i app/$FILE \
-o app/dredd/merged.yml

# APIがOAS通りのレスポンスを返しているか確認する。
# 出力が長いので、詳細は ./dredd/dredd_result.txt に出力する。

docker run -it --rm -v $SCRIPT_DIR:/openapi \
--add-host=host.docker.internal:host-gateway \
apiaryio/dredd sh -c \
"dredd openapi/dredd/merged.yml $API_URL \
-d --hookfiles=$HOOKFILES --no-color | \
tee openapi/dredd/dredd_result.txt | \
grep -e 'pass\:' -e 'fail\:' -e 'complete\:'"
