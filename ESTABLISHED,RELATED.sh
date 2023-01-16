ipset create RAWTRACK hash:ip  timeout 60
iptables -t raw -A PREROUTING -i eth0 -m set --match-set RAWTRACK src -j ACCEPT
iptables -t raw -A PREROUTING -i eth0 -j DROP
iptables -t raw -A OUTPUT -o eth0 -j SET --exist --add-set RAWTRACK dst
