# rawtrack
Using ipset to replace the Linux kernel conntrack

# Usage:

Specify the interface you wish to apply rawtrack to as an argument. For example:

    ./ESTABLISH.SH eth0

You can usually find your list of interfaces with the ip command:

    ip a



# Details:

ESTABLISHED.sh creates rules that would be like using conntrack's ESTABLISHED state match. The closest equivelant would be:

    iptables -t mangle -A PREROUTING -i $interface -m state --state ESTABLISHED -j ACCEPT
    iptables -t mangle -A PREROUTING -i $interface -j DROP


Anything else you need to ACCEPT should go above this rule:

    iptables -t raw -A PREROUTING -i $interface -j DROP
