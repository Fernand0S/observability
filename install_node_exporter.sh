#Adiciona usuário 
useradd -M -r -s /bin/false node_exporter

#Acessando diretório
cd /tmp

#Download Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

#Descompactando pacote Node Exporter
tar xzf node_exporter-0.18.1.linux-amd64.tar.gz

#Copia arquivo para o diretório
cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/

#Copia arquivo de servico Node Exporter
cp /scripts/node_exporter.service /etc/systemd/system/

#Alterar as permissões do diretório Node Exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

#Modifica informação node_exporter

echo="
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --collector.cpu --web.max-requests=10 --web.disable-exporter-metrics --collector.diskstats --collector.meminfo --collector.netstat --collector.qdisc --collector.cpufreq --collector.processes --collector.tcpstat
[Install]
WantedBy=multi-user.target"


#Habilita o serviço do Node Exporter
systemctl enable --now node_exporter.service

#Realiza o reload do systemd
systemctl daemon-reload

#Realiza o restartt do Node Exporter
systemctl restart node_exporter

#Gerando log
systemctl status node_exporter | grep 'running' >> /tmp/servico-nodeexporter.log
curl localhost:9100/metrics >> /tmp/metricas_nodeexporter.log
