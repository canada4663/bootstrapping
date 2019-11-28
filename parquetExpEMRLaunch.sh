aws emr create-cluster --auto-scaling-role EMR_AutoScaling_DefaultRole --termination-protected \
	--applications Name=Hadoop Name=Hive Name=Spark Name=Tez \
	--tags 'name=SparkParkquetSandbox' 'env=dev' 'type=work' \
	--ec2-attributes '{"KeyName":"sandbox-key",
			   "AdditionalSlaveSecurityGroups":["sg-2cc6a145"],
			   "InstanceProfile":"EMR_EC2_DefaultRole",
			   "ServiceAccessSecurityGroup":"sg-8de5bbe4",
			   "SubnetId":"subnet-88a829e1",
			   "EmrManagedSlaveSecurityGroup":"sg-68e3bd01",
			   "EmrManagedMasterSecurityGroup":"sg-a1e3bdc8",
			   "AdditionalMasterSecurityGroups":["sg-2cc6a145"]}'\
	--service-role EMR_DefaultRole \
	--enable-debugging --release-label emr-5.2.0 \
	--log-uri 's3n://serverclosetwork-ohio-box/logs/SparkParquetSandbox/' 
	--name 'SparkParquetSandbox' 
	--instance-groups '[{"InstanceCount":2,
			     "EbsConfiguration":
			     	{"EbsBlockDeviceConfigs":
				   [{"VolumeSpecification":
				   	{"SizeInGB":840,"VolumeType":"gp2"},
				    "VolumesPerInstance":1}
				   ],
				 "EbsOptimized":false
			        },
			      "InstanceGroupType":"CORE",
			      "InstanceType":"r3.4xlarge",
			      "Name":"Core - 2"
		             },
			     {"InstanceCount":1,
			      "EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":100,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"MASTER","InstanceType":"m4.xlarge","Name":"Master - 1"}]' \ 
	--scale-down-behavior TERMINATE_AT_INSTANCE_HOUR --region us-east-2
