#!/bin/sh


export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/vmware/bin:/opt/vmware/bin:/root/bin:$PATH

echo "Port ${ssh_port}" >> /etc/ssh/sshd_config
/etc/init.d/sshd restart

if [ ${node_array_index} -eq 0 ]
then
echo "I am node ${node_array_index} - running through configuration"
	sleep 60
	if [ "${console_password}" = "" ]
	then
		password="couchbase123"
	else
		password="${console_password}"
	fi

	# bucket_name
	# bucket_type
	# replica_count
	# couchbase_port

	cli="/opt/couchbase/bin/couchbase-cli"
	memory_bytes=`cat /proc/meminfo |grep -i memtotal |awk '{print $2;}'`
	memory_mb=`echo "scale=4; ${memory_bytes}/1024" | bc`
	memory_allocation=`echo "scale=4; ${memory_mb}*.79" | bc|cut -d . -f1`
	local_ip="`ifconfig|grep -A 1 eth0|grep inet|cut -d ':' -f2|cut -d ' ' -f1`"
	echo "Memory bytes: ${memory_bytes}"
	echo "Memory MB: ${memory_mb}"
	echo "Memory Allocation: ${memory_allocation}"
	echo "Local IP: ${local_ip}"

	echo "Setting cluster ramsize to: ${memory_allocation}"
	${cli} cluster-init -u Administrator -p ${password} -c localhost:8091 --cluster-init-username=Administrator --cluster-init-password=${password} --cluster-init-port=8091 --cluster-init-ramsize=${memory_allocation}

	echo "Creating bucket: ${bucket}"
	${cli} bucket-create -u Administrator -p ${password} -c localhost:8091 --bucket=${bucket_name} --bucket-type=${bucket_type} --bucket-ramsize=${memory_allocation} --bucket-replica=${replica_count}


	echo "Adding nodes to cluster..."
	for ip in ${cluster_ips[@]}
	do
		if [ "$ip" != "${local_ip}" ]
		then
			echo "Adding ${ip} to cluster list"
			${cli} server-add -u Administrator -p ${password} -c localhost:8091  --server-add=${ip}:8091
		else
			echo "Skpping add of ${ip} to cluster"
		fi
	done

	echo "Server list:"
	${cli} server-list -u Administrator -p ${password} -c localhost:8091

	echo "Rebalancing cluster..."	
	${cli} rebalance  -u Administrator -p ${password} -c localhost:8091

	echo "Changing cluster to listen on port ${couchbase_port}..."
	${cli} cluster-init -u Administrator -p ${password} -c localhost:8091 --cluster-init-port=${couchbase_port}

else
	echo "Skipping configure since I am node: ${node_array_index}"
fi 
