#!/bin/bash
sudo su
yum install -y openswan
cat <<EOF > /etc/ipsec.d/connections.conf
conn VpnConn1
 authby=secret
 auto=start
 left=%defaultroute
 leftid=${customer_gateway_ip_address}
 right=${vpn_tunnel_ip_address}
 type=tunnel
 ikelifetime=8h
 keylife=1h
 phase2alg=aes128-sha1;modp1024
 ike=aes128-sha1;modp1024
 keyingtries=%forever
 keyexchange=ike
 leftsubnet=${on_prem_subnet}
 rightsubnet=${cloud_subnet}
 dpddelay=10
 dpdtimeout=30
 dpdaction=restart_by_peer
EOF
cat <<EOF > /etc/ipsec.d/connections.secrets
${customer_gateway_ip_address} ${vpn_tunnel_ip_address}: PSK "PRE_SHARED_KEY"
EOF
cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.accept_source_route = 0
EOF
cat <<EOF > ~/execute_ipsec.sh 
systemctl restart network
systemctl start ipsec
systemctl status ipsec
EOF
chmod u+x ~/execute_ipsec.sh


