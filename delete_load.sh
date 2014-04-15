db=postgres
user=postgres
table=crashlog
#delete data of $days ago 
days=3

#insert last $hour data
hour=1
pg_param="-a $db -U $user"

#only n hour ago
start_date=$(date -d "$hour hour ago" +'%F %H:%M:%S')
end_date=$(date -d "0 hour ago" +'%F %H:%M:%S')

#delete the data first,in case of re run cause double data
echo "$(date) will delete $table [$start_date,$end_date) data..."
psql $pg_param -c "select ${table}_delete(clientversion,\$\$${start_date}\$\$,null) from wx_version"

#load
echo "$(date) will load $table [$start_date,$end_date) data..."
psql $pg_param -c "select ${table}_load(filter := 'logtime >= \$start\$${start_date}\$start\$ and logtime < \$end\$${end_date}\$end\$');"
echo "$(date) load $table [$start_date,$end_date) data end"
