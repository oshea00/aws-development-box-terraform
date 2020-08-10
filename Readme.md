# EC2 instance for developers

### Why is this needed?
Although the WSL environment works for AWS development, there are some issues:
* The WSL environment is slow.
* There are problems installing the right bits needed on the WSL Ubuntu - especially node.
* No backups in case something becomes corrupted.

### What's Here
This terraform spins up a developer EC2 Ubuntu 18.04 instance with the following tools pre-installed.
* Uses EC2 Instance role - no need for AWS credential secrets in ENV variables.
* AWS Command Line
* zip / unzip - used by some packages in npm
* Node 12.x - includes npm
* Python 2/3 (default Ubuntu 18.04)
* Serverless.com tools
* Dotnet 3.1 SDK
* Docker w/ default user 'ubuntu' added to docker group.

## Usage

### Prerequisites
1. Make sure your public and private RSA keys generated and are in the default path or fix the default path in order to be able to login. This is normally (in both Windows10/Linux) ~/.ssh/id_rsa.*
2. You will need your WSL (Windows Subsystem for Linux) setup in advance fpr AWS account and Terraform.
3. Instructions to setup WSL and Terraform are [here](https://parametric.atlassian.net/wiki/spaces/CN/pages/882507986/Using+Terraform)

### Running
1. Clone this project to your local repository directory.
2. Run `terraform init` and `terraform apply`
3. You will be prompted for a developer username (enter one with no spaces)
4. Reply 'yes' when prompted to apply plan. When done, the "Instance IP Address" should be displayed at the end of the job output.
5. The default username of the instance is ubuntu, so you should ssh like this:
```ssh ubuntu@[INSTANCE_IP] ```

### Using
You may setup VSCode remote development, allowing you to easily code and debug remotely:
1. Ctrl-Shift-P - choose `Remote-SSH: Add new SSH host`
2. Enter your ssh command. Example: `ssh -i C:\Users\you\.ssh\id_rsa ubuntu@[INSTANCE_IP]`
3. Choose where to save config (usually c:\Users\you\.ssh\config)
4. Ctrl-Shift-P - choose `Remote-SSH: Connect to Host`
5. Once connected you can choose to open folders, start a terminal session, etc - it's VCCode.

### Changing
The ECS instance role and policies are setup unique to your developer username (as entered during setup). You may change these in the `main.tf` as-needed - warning: this will completely re-build your instance. The current policy gives your EC2 instance all the permission you have in your developer account.

Adding additional tool installs in the `main.tf` remote-exec is easy to do - just follow the example. Create your own branch and run. If it's useful to others, then send a merge request.

The security groups referenced in the `main.tf` are useful defaults, but you may want to use a custom one of your own if you are testing applications on certain ports.

To completly remove your instance `terraform destroy`



