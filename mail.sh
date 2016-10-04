#!/bin/sh

sendMail() {
    from="$1"
    to="$2"
    subject="$3"
    contents="$4"
    file_path="$5" 
    echo ${contents} |mutt -s "$subject"  -f "$from" -a "$file_path" -- "$to"
    return $?
}

from="from_mail_address"
to="to_mail_address"
subject="SlowQueryProcessKill"
contents="スロークエリーで600sを超えてもCommandがQueryのプロセスをKILLしました"
sendMail "$from" "$to" "$subject" "$contents" "/home/slow_query_process.txt"
if [ $? -eq 1 ]; then
    echo "send mail failure"
    exit 1
fi
echo "send mail success"
