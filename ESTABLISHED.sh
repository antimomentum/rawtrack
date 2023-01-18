interface=$1
ipset create TEST1 hash:ip,port timeout 60
ipset create RAWTRACK hash:ip,port timeout 60
iptables -t mangle -N NEW

# This just gets potentially legit packets fast-tracked through the firewall. They are further scruitinized in later in mangle:
iptables -t raw -A PREROUTING -i $interface -m set --match-set TEST1 src,dst -j ACCEPT

# IPs and our destination ports we did not request are auto dropped, if you server needs ports or ips always whitelisted do it above the following rule:
iptables -t raw -A PREROUTING -i $interface -j DROP

# ACCEPT the initial source ip and source port and destination port combo for the packet, raw already checked our destination port:
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src,src -j ACCEPT

# NEW connections we did not request from the same IP we did initially request are caught here:
iptables -t mangle -A PREROUTING -i $interface -m set --match-set RAWTRACK src -j NEW

# The very first connection we initially requested, along with the first source port of the IP reply, is added to the RAWTRACK:
iptables -t mangle -A PREROUTING -i $interface -j SET --exist --add-set RAWTRACK src,src


# Remove the accepted IP if it tries to open more connections from other ports, you may not want this:
iptables -t mangle -A NEW -j SET --del-set TEST1 src,dst

# Drop attempts from the IP to open connections from other ports:
iptables -t mangle -A NEW -j DROP

# The ip we request, and our destionation port the request came from, are first added to TEST1 before anything:
iptables -t mangle -A POSTROUTING -o $interface -j SET --exist --add-set TEST1 dst,src


# No final incoming mangle DROP is needed since the only packets reaching mangle PREROUTING are already only from IPs in TEST1, added by our own requests.
# In other words the raw PREROUTING DROP already took care of it.
# Tested host only and with Docker's default network mode.
