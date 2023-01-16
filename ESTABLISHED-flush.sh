interface=$1
iptables -t raw -D PREROUTING -i $interface -m set --match-set RAWTRACK src,src -j ACCEPT
iptables -t raw -D PREROUTING -i $interface -j DROP
iptables -t raw -D OUTPUT -o $interface -j SET --exist --add-set RAWTRACK dst,dst
ipset destroy RAWTRACK
