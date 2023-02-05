```bash
aws ec2 run-instances \
    --region $REGION \
    --image-id $IMAGE \
    --instance-type $TYPE \
    --subnet-id $SUBNET \
    --security-group-ids $SECURITY_GROUPS \
    --user-data "file://${USERDATA}" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]" \
    --block-device-mappings "VirtualName=/dev/xvda,DeviceName=/dev/xvda,Ebs={VolumeSize=${DISK}}"
```

```bash
NAME='fcos_test' && IMAGE='ami-00f8e408bb2e9b06e' && DISK='10' && REGION='eu-central-1' && TYPE='t2.micro' && SUBNET='subnet-052f690eced6bbe37' && SECURITY_GROUPS='sg-0e98cec768c81142e' && USERDATA='/home/cloudshell-user/octoprint.ign'
```