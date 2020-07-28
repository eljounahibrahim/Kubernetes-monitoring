ALERTMANAGER_VERSION="0.20.0"
wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
tar xvzf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
cd alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/

# Utilisateur 
useradd --no-create-home --shell /bin/false alertmanager 

# Repertoire
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template
mkdir -p /var/lib/alertmanager/data

# configs file
touch /etc/alertmanager/alertmanager.yml

# ownership
chown -R alertmanager:alertmanager /etc/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager

# fichiers binaires
cp alertmanager /usr/local/bin/
cp amtool /usr/local/bin/
chown alertmanager:alertmanager /usr/local/bin/alertmanager
chown alertmanager:alertmanager /usr/local/bin/amtool

# systemd
echo '[Unit]
Description=Prometheus Alertmanager Service
Wants=network-online.target
After=network.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager/data
Restart=always

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/alertmanager.service

systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager

# redamarage prometheus
systemctl start prometheus


echo "(1/2)Setup complete.
Ajouter le lignes suivantes et remplacer les étoiles par les valeurs correctes sur /etc/alertmanager/alertmanager.yml:

route:
  group_by: ['alertname']      
  receiver: team_label
receivers:
  - name: 'team_label'
    email_configs:
    - to: 'target@xxx.com'
      from: admin@gmail.com
      smarthost: smtp.gmail.com:587
      auth_username: "admin@gmail.com"
      auth_identity: "admin@gmail.com"
      auth_password: "admin_pass"

 "

  echo "(2/2)Setup complete.
ajouter les lignes suivantes dans /etc/prometheus/prometheus.yml:

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093"

