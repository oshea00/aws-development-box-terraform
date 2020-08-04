# EC2 instance for developers

This terraform spins up an EC2 instance with docker

## Usage
Make sure your public and private keys are in the default path or fix the default path in order to be able to login.

The default username of the instance is ubuntu, so you should ssh like this:

`ssh -i ~/.ssh/id_rsa ubuntu@[INSTANCE_IP] `

