#!/bin/bash     
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export UI_RANDOM_NAME=$(aws s3api list-buckets --region $AWS_DEFAULT_REGION --output text --query 'Buckets[?contains(Name, `pilot-secondary-uibucket`) == `true`]'.Name)
export HOSTNAME="http://$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"
sudo aws s3 cp s3://ee-assets-prod-us-east-1/modules/630039b9022d4b46bb6cbad2e3899733/v1/UniShopUI/ /home/ec2-user/UniShopUI/ --no-sign-request --recursive                                                       
echo '{"host":"'"$HOSTNAME"'","region":"'"$AWS_DEFAULT_REGION"'"}' | sudo tee /home/ec2-user/UniShopUI/config.json                    
sudo aws s3 cp /home/ec2-user/UniShopUI/ s3://$UI_RANDOM_NAME/ --recursive --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers         
sudo aws s3 cp s3://ee-assets-prod-us-east-1/modules/630039b9022d4b46bb6cbad2e3899733/v1/UniShopAppV1-0.0.1-SNAPSHOT.jar /home/ec2-user/ --no-sign-request     
export DATABASE=$(aws rds describe-db-clusters --region $AWS_DEFAULT_REGION --db-cluster-identifier dr-immersionday-secondary-pilot --query 'DBClusters[*].[Endpoint]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo systemctl restart unishop
