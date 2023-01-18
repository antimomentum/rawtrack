interface=$1
ipset create TEST1 hash:ip,port timeout 60
ipset create RAWTRACK hash:ip,port timeout 60
iptables -t raw -A PREROUTING -i $interface -m set --match-set TEST1 src,dst -j ACCEPT
iptables -t raw -A PREROUTING -i $interface -j DROP
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src,src -j ACCEPT
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src -j SET --del-set TEST1 src,dst
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src -j DROP
iptables -t mangle -A PREROUTING -i $interface -j SET --exist --add-set RAWTRACK src,src
iptables -t mangle -A POSTROUTING -o $interface -j SET --exist --add-set TEST1 dst,src
