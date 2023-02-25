# endermite
[![Test Branch Workflow](https://github.com/einnamehalt/endermite/actions/workflows/test.yml/badge.svg?branch=test)](https://github.com/einnamehalt/endermite/actions/workflows/test.yml)

Use `remote-<architecture>.ign` on target device. Choose the right target archtitecture.

Ensure you have the needed private key otherwise make a new build using another public key.

Find the latest builds here: [Releases](https://github.com/einnamehalt/endermite/releases/latest)


## Deployment

### AWS

Using AWS CloudShell.

#### Preparation
Get Public IP of CloudShell Instance.
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
[Fedora CoreOS Downloads](https://getfedora.org/coreos/download?tab=cloud_launchable&stream=stable&arch=x86_64)

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

or in one line:

```bash
NAME='fcos_test' && IMAGE='ami-00f8e408bb2e9b06e' && DISK='10' && REGION='eu-central-1' && TYPE='t2.micro' && SUBNET='subnet-xxx' && SECURITY_GROUPS='sg-xxx' && USERDATA='/home/cloudshell-user/remote-x86_64.ign'
```

#### Create EC2 Instance

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

#### Access Instance

Find Public IP Address/DNS Name: `aws ec2 describe-instances`

`ssh -i <path to private key> core@<PUBLIC IP>`

## Building yourself

### Pull repo
`git clone https://github.com/einnamehalt/endermite.git`
`cd enedermite`

### Set up Butane

`podman pull quay.io/coreos/butane:release`

```bash
alias butane='podman run --rm --interactive       \
              --security-opt label=disable        \
              --volume ${PWD}:/pwd --workdir /pwd \
              quay.io/coreos/butane:release'
```
Use docker if prefered.

### Generate Ignition File

`butane --strict -d ./ ./main.bu > ./ignition/main-aarch64.ign`
