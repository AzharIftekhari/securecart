# Step 1: SSH into App EC2 via Bastion Host

Upload PEM file to the Bastion Host

If the PEM file is not already present on the Bastion, use scp to copy it:
scp -i ~/Downloads/scrt.pem ~/Downloads/scrt.pem ec2-user@<Bastion_Public_IP>:/home/ec2-user/
Replace ~/Downloads/scrt.pem with the actual path to your PEM file

Connect to the Bastion Host from your local machine:
ssh -i ~/Downloads/scrt.pem ec2-user@<Bastion_Public_IP>

Once inside the Bastion:
chmod 400 scrt.pem
ssh -i scrt.pem ec2-user@<Private_IP_of_app_instance>
Replace <Private_IP_of_app_instance> with the actual private IP of the EC2 instance (securecart-app)
You can find it in the EC2 dashboard → Instances → Private IP column
Once connected, you’re now inside your private EC2 and ready to install the Node.js app.

# Step 2: Install Node.js App on Private EC2
Install Node.js (using NVM)
Once inside the terminal session:
# Download and run the NVM (Node Version Manager) installation script
curl -o- <https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh> | bash

# Load NVM into your shell session
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

# Install Node.js version 18
nvm install 18

# Use Node.js version 18 for the current shell
nvm use 18

Create the App Folder and Files
# Create a project folder and navigate into it
mkdir securecart && cd securecart

# Create a public directory for static files
mkdir public

Create a Simple HTML Page
cat <<EOF > public/index.html
<!DOCTYPE html>
<html><head><title>Cloud Security Project</title></head>
<body><h1>SecureCart - Production</h1><p>Served from private EC2</p></body>
</html>
EOF

Create the Node.js Server
cat <<EOF > server.js
const http = require('http');
const fs = require('fs');
const path = require('path');
const server = http.createServer((req, res) => {
  const filePath = path.join(__dirname, 'public', req.url === '/' ? 'index.html' : req.url);
  fs.readFile(filePath, (err, content) => {
    if (err) { res.writeHead(404); res.end('Not Found'); }
    else { res.writeHead(200); res.end(content); }
  });
});
server.listen(80, '0.0.0.0');
EOF

Start the Server
First, get the full path to the Node binary: which node

You’ll get a path like:
/home/ec2-user/.nvm/versions/node/v18.x.x/bin/node

Now, use that full path to run the server in the background:
sudo /home/ec2-user/.nvm/versions/node/v18.x.x/bin/node server.js &

Test the App via ALB
Go to EC2 Dashboard → Load Balancers

Copy the DNS name of your ALB (e.g., securecart-alb-123456789.us-east-1.elb.amazonaws.com)

Paste it into your browser

This setup shows how real-world architectures use public ALBs to expose apps, while keeping backend resources like EC2 and RDS isolated for security.