while sleep 1; 
do curl -s -o /dev/null -w "%{url_effective}, %{response_code}, %{time_total}\n" $1 ;
done
