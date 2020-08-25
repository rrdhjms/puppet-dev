sudo apt install nfs-server -y
sudo systemctl start nfs-server
sudo systemctl enable nfs-server
sudo mkdir -p /srv/nfs/jenkins
sudo chmod -R 777 /srv/nfs/jenkins
sudo echo '/srv/nfs/jenkins    *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)' >> /etc/exports
sudo exportfs -rav
sudo systemctl restart nfs-server