# VALIDATED ON Linux (ubuntu 22.04) #

sudo apt-get update  && \
sudo apt-get install -y wget apt-transport-https software-properties-common && \
wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.2.5/powershell-lts_7.2.5-1.deb_amd64.deb  && \
sudo dpkg -i powershell-lts_7.2.5-1.deb_amd64.deb  && \
rm ./powershell-lts_7.2.5-1.deb_amd64.deb  && \
sudo apt install -y aspnetcore-runtime-6.0=6.0.8-1 dotnet-apphost-pack-6.0=6.0.8-1 dotnet-host=6.0.8-1 dotnet-hostfxr-6.0=6.0.8-1 dotnet-runtime-6.0=6.0.8-1 dotnet-sdk-6.0=6.0.400-1 dotnet-targeting-pack-6.0=6.0.8-1 --allow-downgrades && \

wget https://github.com/google/go-jsonnet/releases/download/v0.17.0/jsonnet-go_0.17.0_linux_amd64.deb  && \
sudo dpkg -i jsonnet-go_0.17.0_linux_amd64.deb && \
sudo rm jsonnet-go_0.17.0_linux_amd64.deb && \
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
sudo apt-get update && sudo apt-get install terraform && \
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.35.14/terragrunt_linux_amd64 && \
sudo mv terragrunt_linux_amd64 terragrunt && \
sudo chmod u+x terragrunt && \
sudo mv terragrunt /usr/local/bin/terragrunt && \
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && \

#Boxes, Figlet and LolCat
sudo apt-get install figlet lolcat boxes 

#DBT (Optional)
sudo apt install python3-pip -y
sudo apt install python3.10-venv -y


#Github Runner Software
mkdir actions-runner && cd actions-runner# Download the latest runner package && \
curl -o actions-runner-linux-x64-2.296.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.296.0/actions-runner-linux-x64-2.296.0.tar.gz && \
tar xzf ./actions-runner-linux-x64-2.296.0.tar.gz 
read -p "Please enter github runner token: " GHTOKEN 
read -p "Please enter github repo url eg. https://github.com/microsoft/azure-data-services-go-fast-codebase  " GHURL 
./config.sh --url $GHURL --token $GHTOKEN
rm actions-runner-linux-x64-2.296.0.tar.gz 
sudo ./svc.sh install 
sudo ./svc.sh start