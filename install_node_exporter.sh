#Adiciona usuário 
useradd -M -r -s /bin/false node_exporter

#Download Node Exporter e Descompactando pacote Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz && tar xvzf node_exporter-1.6.1.linux-amd64.tar.gz

#Copia arquivo para o diretório
mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/

#Removendo node_exporter
rm -rf node_exporter-1.6.1.linux-amd64*

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

#Copia arquivo de servico Node Exporter
cp /node_exporter.service /etc/systemd/system/


#Habilita o serviço do Node Exporter
systemctl enable --now node_exporter.service

#Realiza o reload do systemd
systemctl daemon-reload

#Realiza o restartt do Node Exporter
systemctl restart node_exporter

#Gerando log
systemctl status node_exporter | grep 'running' >> /tmp/servico-nodeexporter.log
curl localhost:9100/metrics >> /tmp/metricas_nodeexporter.log
