#!/bin/sh
# define
USER="user_name"
PASS="password"
DB="db_name"
KILL="KILL "
COLON=";"
#QUERY="select id,INFO from information_schema.processlist where time>10 and Command='Query';"
QUERY="select id from information_schema.processlist where time > 600 and Command='Query';"
OUTPUTQUERY="select INFO from information_schema.processlist where time > 600 and Command='Query';"
# exec
outputrun=$(mysql -u${USER} -p${PASS} ${DB} -e "${OUTPUTQUERY}")
run=$(mysql -u${USER} -p${PASS} ${DB} -e "${QUERY}")
# 実行結果を配列に入れる
echo -e ${outputrun}>slow_query_process.txt

result=(`echo -e ${run} | tr -s '\n'`)
# 先頭のカラム名は実行しない
for ((i = 1; i < ${#result[@]}; i++))
do
    mysql -u${USER} -p${PASS} ${DB} -e "${KILL}${result[i]}${COLON}"
done

# $resultが存在したらmail送信
if [ -n "$result" ]; then
    sh mail.sh
fi
