Using AWS CloudShell

Create `test_rsa` and `test_rsa.pub`. Replace in `test.bu`. Build `test.ign`
Edit `remote.bu` to reference your remote `test.ign` file.

Switch to AWS CloudShell:
Get Public IP
`curl ipinfo.io` 

Create a SecurityGroup like this:

```json
{
    "Description": "ssh",
    "GroupName": "fcos_test",
    "IpPermissions": [
        {
            "FromPort": 22,
            "IpProtocol": "tcp",
            "IpRanges": [
                {
                    "CidrIp": "<CloudShell PUBLIC IP>/32"
                }
            ],
            "Ipv6Ranges": [],
            "PrefixListIds": [],
            "ToPort": 22,
            "UserIdGroupPairs": []
        }
    ],
    "IpPermissionsEgress": [
        {
            "IpProtocol": "-1",
            "IpRanges": [
                {
                    "CidrIp": "0.0.0.0/0"
                }
            ],
            "Ipv6Ranges": [],
            "PrefixListIds": [],
            "UserIdGroupPairs": []
        }
    ],
    "Tags": [
        {
            "Key": "Name",
            "Value": "fcos_test"
        }
    ]
    ...
}
```

Get AMI ID for selected region:
https://getfedora.org/coreos/download?tab=cloud_launchable&stream=stable&arch=x86_64

```bash
NAME='fcos_test'
IMAGE='ami-xxx'                             # the AMI ID found on the download page
DISK='10'                                   # the size of the hard disk in GB
REGION='eu-central-1'                       # the target region
TYPE='t2.micro'                             # the instance type (t2.micro - free tier)
SUBNET='subnet-xxx'                         # the subnet: `aws ec2 describe-subnets`
SECURITY_GROUPS='sg-xx'                     # the security group `aws ec2 describe-security-groups`
USERDATA='/home/cloudshell-user/remote.ign' # path to remote.ign (key is test.rsa.pub)
```

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

Find Public IP Address/DNS Name: `aws ec2 describe-instances`

`ssh -i /home/cloudshell-user/test_rsa test@<PUBLIC IP>`
