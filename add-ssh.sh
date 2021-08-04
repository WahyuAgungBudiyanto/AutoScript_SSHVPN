#!/bin/bash
# Script by : 
clear
read -p "Username : " username
# Check If Username Exist, Else Proceed
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
clear
echo -e "Username Already Exist"          
read -p "Password : " password
read -p "Active (days): " expired
clear

address=$(wget -qO- icanhazip.com);
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpntcp="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpnudp="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"

sleep 0.5
echo Creating username : $username
sleep 0.5
echo Setting Password : $password
sleep 0.5
clear

useradd -e `date -d "$expired days" +"%Y-%m-%d"` -s /bin/false -M $username
usermod -s /bin/false $username
usermod -e  $Expiration $username
egrep "^$username" /etc/passwd >/dev/null
echo -e "$password\n$password\n"|passwd $username &> /dev/null
clear

echo -e ""
echo -e "Thank You For Using Our Services"
echo -e "SSH & OpenVPN Account Info"
echo -e "Username       : $username"
echo -e "Password       : $password"
echo -e "==============================="
echo -e "Host           : $address"
echo -e "OpenSSH        : $opensshport"
echo -e "Dropbear       : $dropbearport"
echo -e "SSL/TLS        : $stunnel4port"
echo -e "Port Squid     : $squidport"
echo -e "OpenVPN        : TCP $ovpntcp http://$address:81/client-tcp-$ovpn.ovpn"
echo -e "OpenVPN        : UDP $ovpnudp http://$address:81/client-udp-$ovpn2.ovpn"
echo -e "OpenVPN        : TLS http://$address:81/client-tcp-tls.ovpn"
echo -e "badvpn         : 7200 - 7400"
echo -e "==============================="
echo -e "Expired On     : $Expiration_Display"
