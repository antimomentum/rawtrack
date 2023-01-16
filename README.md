# rawtrack
Using ipset to replace the Linux kernel conntrack

# Usage:

Specify the interface you wish to apply rawtrack to as an argument. For example:

    ./ESTABLISHED.sh eth0

You can usually find your list of interfaces with the ip command:

    ip a



# Details:

ESTABLISHED.sh creates rules that would be like using conntrack's ESTABLISHED state match. The closest equivalent would be:

    iptables -t mangle -A PREROUTING -i $interface -m state --state ESTABLISHED -j ACCEPT
    iptables -t mangle -A PREROUTING -i $interface -j DROP


Anything else you need to ACCEPT should go above this rule:

    iptables -t raw -A PREROUTING -i $interface -j DROP



 ipset type        | iptables match-set | Packet fields
 ------------------+--------------------+---------------------------------
 hash:net,port,net | src,dst,dst        | src IP address, dst port, dst IP address
 hash:net,port,net | dst,src,src        | dst IP address, src port, src IP address
 hash:ip,port,ip   | src,dst,dst        | src IP address, dst port, dst IP address
 hash:ip,port,ip   | dst,src,src        | dst IP address, src port, src ip address
 hash:mac          | src                | src mac address
 hash:mac          | dst                | dst mac address
 hash:ip,mac       | src,src            | src IP address, src mac address
 hash:ip,mac       | dst,dst            | dst IP address, dst mac address
 hash:ip,mac       | dst,src            | dst IP address, src mac address
