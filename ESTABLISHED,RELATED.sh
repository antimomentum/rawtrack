interface=$1
ipset create RAWTRACK hash:ip timeout 60
iptables -t raw -A PREROUTING -i $interface -m set --match-set RAWTRACK src -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -j DROP
iptables -t mangle -A POSTROUTING -o $interface -j SET --exist --add-set RAWTRACK dst
