#!/bin/bash

sudo yum install unzip -y

NOMAD_VERSION=0.8.3
CONSUL_VERSION=1.1.0

echo "Fetching Nomad..."
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip

echo "Fetching Consul..."
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip

echo "Installing Nomad..."
unzip nomad.zip
sudo install nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce

sudo systemctl enable docker.service
sudo systemctl restart docker.service

sudo usermod -aG docker vagrant

echo "Installing Consul..."
unzip /tmp/consul.zip
sudo install consul /usr/bin/consul

(
cat <<-EOF
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/bin/consul agent -dev
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF
) | sudo tee /usr/lib/systemd/system/consul.service

(
cat <<-EOF
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
After=network-online.target consul.service
Wants=network-online.target consul.service

[Service]
KillMode=process
KillSignal=SIGINT
ExecStart=/usr/bin/nomad agent -dev
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
) | sudo tee /usr/lib/systemd/system/nomad.service


sudo systemctl enable consul.service
sudo systemctl start consul.service

sudo systemctl enable nomad.service
sudo systemctl start nomad.service

for bin in cfssl cfssl-certinfo cfssljson
do
        echo "Installing $bin..."
        curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
        sudo install /tmp/${bin} /usr/local/bin/${bin}
done

echo "Installing autocomplete..."
nomad -autocomplete-install

echo "Start prometheus container through nomad"
nomad run /opt/nomad/prometheus.hcl
