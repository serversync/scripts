#!/bin/bash

echo -e "\e[32m"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║       _                 _                                  ║"
echo "║ _   _| |__  _   _ _ __ | |_ _   _                           ║"
echo "║| | | | '_ \| | | | '_ \| __| | | |                          ║"
echo "║| |_| | |_) | |_| | | | | |_| |_| |                          ║"
echo "║ \__,_|_.__/ \__,_|_| |_|\__|\__,_|                          ║"
echo "║                                                            ║"
echo "║          Otimização do Sistema Linux                       ║"
echo "║                                                            ║"
echo "║  [*] Iniciando otimizações do servidor...                  ║"
echo "║  [*] Sistema: Ubuntu $(lsb_release -rs)                    ║"
echo "║  [*] Data: $(date)                                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "\e[0m"
sleep 3

# Atualizando o sistema
echo -e "\e[32m[*] Atualizando o sistema...\e[0m"
apt update && apt upgrade -y

# Otimizando a inicialização
echo -e "\e[32m[*] Otimizando inicialização do sistema...\e[0m"

# Configurando o GRUB para inicialização mais rápida
cat > /etc/default/grub << EOL
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash elevator=deadline"
GRUB_CMDLINE_LINUX=""
EOL

# Atualizando o GRUB
update-grub

# Configurando serviços para inicialização paralela
cat > /etc/systemd/system.conf << EOL
[Manager]
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s
DefaultRestartSec=100ms
DefaultStartLimitIntervalSec=0
DefaultStartLimitBurst=0
EOL

# Configurando limites do sistema para melhor performance
echo -e "\e[32m[*] Configurando limites do sistema...\e[0m"
cat > /etc/sysctl.conf << EOL
# Otimizações de memória para uso intensivo
vm.swappiness = 5
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 80
vm.dirty_background_ratio = 5
vm.min_free_kbytes = 65536
vm.overcommit_memory = 1
vm.overcommit_ratio = 80

# Otimizações de CPU
kernel.sched_autogroup_enabled = 0
kernel.sched_migration_cost_ns = 5000000
kernel.sched_rt_runtime_us = 950000
kernel.sched_rt_period_us = 1000000

# Otimizações de rede para alta carga
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_max_tw_buckets = 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# Otimizações de I/O
fs.file-max = 2097152
fs.aio-max-nr = 1048576
fs.inotify.max_user_watches = 524288
EOL

# Aplicando as configurações do sysctl
sysctl -p

# Configurando limites do usuário para alta carga
echo -e "\e[32m[*] Configurando limites do usuário...\e[0m"
cat > /etc/security/limits.conf << EOL
* soft nofile 1048576
* hard nofile 1048576
* soft nproc 1048576
* hard nproc 1048576
* soft memlock unlimited
* hard memlock unlimited
EOL

# Otimizando o sistema de arquivos
echo -e "\e[32m[*] Otimizando sistema de arquivos...\e[0m"
cat > /etc/fstab << EOL
$(cat /etc/fstab | sed 's/defaults/defaults,noatime,nodiratime,barrier=0/g')
EOL

# Instalando ferramentas úteis de monitoramento
echo -e "\e[32m[*] Instalando ferramentas de monitoramento...\e[0m"
apt install -y htop iotop net-tools sysstat

# Configurando o timezone
echo -e "\e[32m[*] Configurando timezone para America/Sao_Paulo...\e[0m"
timedatectl set-timezone America/Sao_Paulo

# Configurando o scheduler do I/O para melhor performance
echo -e "\e[32m[*] Configurando scheduler de I/O...\e[0m"
echo "none /sys/block/sda/queue/scheduler" > /etc/udev/rules.d/60-scheduler.rules
echo "deadline" > /sys/block/sda/queue/scheduler

# Otimizando serviços do systemd
echo -e "\e[32m[*] Otimizando serviços do systemd...\e[0m"
systemctl disable bluetooth
systemctl disable cups
systemctl disable cups-browsed
systemctl disable avahi-daemon
systemctl disable snapd
systemctl disable snapd.socket
systemctl disable snapd.seeded
systemctl disable snapd.autoimport
systemctl disable snapd.core-fixup
systemctl disable snapd.failure
systemctl disable snapd.recovery
systemctl disable snapd.system-shutdown

# Limpando o sistema
echo -e "\e[32m[*] Limpando o sistema...\e[0m"
apt autoremove -y
apt clean
journalctl --vacuum-time=1d

# Recarregando o systemd
systemctl daemon-reload

echo -e "\e[32m"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║          Otimização Concluída!                            ║"
echo "║                                                            ║"
echo "║  [*] Sistema otimizado para alta carga                    ║"
echo "║  [*] CPU otimizada para multitarefas                      ║"
echo "║  [*] Memória otimizada para uso intensivo                 ║"
echo "║  [*] Rede otimizada para alta performance                 ║"
echo "║  [*] I/O otimizado para melhor throughput                 ║"
echo "║  [*] Inicialização otimizada                              ║"
echo "║                                                            ║"
echo "║  IMPORTANTE: Reinicie o sistema para aplicar              ║"
echo "║  todas as alterações                                      ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "\e[0m"
