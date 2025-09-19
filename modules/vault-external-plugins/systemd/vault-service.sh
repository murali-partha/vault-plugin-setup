#!/usr/bin/env bash

cat << EOF > /usr/lib/systemd/system/vault.service

[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
ConditionDirectoryNotEmpty=/etc/vault.d
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
User=ubuntu
Group=ubuntu
ProtectSystem=full
ProtectHome=read-only
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK CAP_NET_BIND_SERVICE
NoNewPrivileges=yes
ExecStart=/usr/bin/vault server -config=/etc/vault.d/
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStartSec=300
TimeoutStopSec=30
StartLimitInterval=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity
CPUAccounting=true
MemoryAccounting=true

[Install]
WantedBy=multi-user.target

EOF