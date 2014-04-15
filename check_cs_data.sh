db=postgres
user=postgres
table=crashlog
days=4
pg_param="$db -U $user"

echo "begin check..."
error="$(psql $pg_param -t -A -c 'select count(1) from (select x.clientversion,cs_count(x.uin),cs_count(x.uin) = cs_count(x.logtime) and  cs_count(x.uin) = cs_count(x.class1) and cs_count(x.uin) = cs_count(x.class2) and cs_count(x.uin) = cs_count(x.class3)  and  cs_count(x.uin) = cs_count(x.revision) and cs_count(x.uin) = cs_count(x.phoneid) as eq from wx_version,crashlog_get(clientversion) as x where x is not null) t  where not eq;')"

if [[ $error -eq 0 ]];then
	echo "$(date) data is clean"
else
	echo "$(date) $error data error found!"
fi
