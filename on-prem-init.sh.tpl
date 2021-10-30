#!/bin/bash
sudo su
yum install -y openswan
cat <<EOF > /etc/ipsec.d/connections.conf
  conn VpnConn1
   authby=secret
   auto=start
   left=%defaultroute
   leftid=cgw ip
   right=vgw ip
   type=tunnel
   ikelifetime=8h
   keylife=1h
   phase2alg=aes128-sha1;modp1024
   ike=aes128-sha1;modp1024
   keyingtries=%forever
   keyexchange=ike
   leftsubnet=172.16.10.0/16
   rightsubnet=172.14.10.0/16
   dpddelay=10
   dpdtimeout=30
   dpdaction=restart_by_peer
EOF

