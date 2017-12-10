#!/bin/bash

# RancherOS
alias base64="docker run -ti --rm -v $(pwd):/root ubuntu /usr/bin/base64"


#cron job for every 10 minutes, disable ICMP "Destination Net Unreachable" so clients don't know the WAN is going to go down,
#then restart WAN connection (in this case wwan in OpenWRT), then enable ICMP Destination Net Unreachable for actual network down situation.
#It works, but fucks with any network monitoring you may want to do.
*/10 * * * * iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP && ifdown wwan && ifup wwan && iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j ACCEPT

#Lookup your external IP from CLI.
nslookup myip.opendns.com. resolver1.opendns.com

#Lockdown SSH  https://ubuntuforums.org/archive/index.php/t-1462345.html
# https://unix.stackexchange.com/questions/302512/add-public-key-to-remote-servers-authorized-keys-and-execute-some-commands
cat ~/.ssh/id_rsa.pub | ssh hive@192.168.1.197 "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
sed -i 's/^.*Port .*/Port 5525/' /etc/ssh/sshd_config
sed -i 's/^.*PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/^.*PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl reload sshd
service ssh restart
/etc/init.d/ssh restart
apt-get install -y ufw

#allow FSCK to auto-fix all errors whenever it runs on boot
sed -i "s/^FSCKFIX=no$/FSCKFIX=yes/" /etc/default/rcS

#upgrade to latest LTS ubuntu
apt-get update
apt-get upgrade -y
apt-get update #IMPORTANT for next command to work
do-release-upgrade

#install docker and gluster on Debian As ROOT
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
groupadd docker
gpasswd -a hive docker
apt-get install -y python-software-properties
wget -O - http://download.gluster.org/pub/gluster/glusterfs/LATEST/rsa.pub | apt-key add -
wget -O - http://download.gluster.org/pub/gluster/glusterfs/3.12/rsa.pub | apt-key add -
DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+')
echo deb https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/${DEBID}/apt ${DEBVER} main > /etc/apt/sources.list.d/gluster.list
apt-get update
apt-get install -y glusterfs-server


#enable IP Forwarding for UPNP
sed -i "s/^#net.ipv4.ip_forward=1$/net.ipv4.ip_forward=1/" /etc/sysctl.conf
sysctl -p /etc/sysctl.conf 
