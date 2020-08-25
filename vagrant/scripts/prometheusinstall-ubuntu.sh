sudo -i
cd ~
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.18.1/prometheus-2.18.1.linux-amd64.tar.gz
useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus && chown prometheus:prometheus /etc/prometheus
mkdir /var/lib/prometheus && chown prometheus:prometheus /var/lib/prometheus

mkdir prometheus-files && tar -xvf prometheus-2.18.1.linux-amd64.tar.gz -C prometheus-files --strip-components 1

cp prometheus-files/prometheus /usr/local/bin/ && chown prometheus:prometheus /usr/local/bin/prometheus
cp prometheus-files/promtool /usr/local/bin/ && chown prometheus:prometheus /usr/local/bin/promtool

cp -r prometheus-files/consoles /etc/prometheus && chown -R prometheus:prometheus /etc/prometheus/consoles
cp -r prometheus-files/console_libraries /etc/prometheus && sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

cp /vagrant/prometheus.yml /etc/prometheus/prometheus.yml
chown prometheus:prometheus /etc/prometheus/prometheus.yml

cp /vagrant/prometheus.service /etc/systemd/system/prometheus.service

systemctl daemon-reload
systemctl start prometheus