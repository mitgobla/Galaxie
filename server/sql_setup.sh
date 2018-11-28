#!/bin/bash
# Galaxie MySQL Server Side Setup

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Create needed directories
echo "Starting Galaxie SQL Server Setup"
mkdir /tmp/galaxie/

# Check for updates
echo "Checking for Updates"
apt-get update && apt-get upgrade

# Install Persistent IpTables Package
echo "Installing Iptables Persistent Package"
apt-get install iptables-persistent

# Install Python (May not be needed)
#echo "Installing Python"
#apt-get install python3-dev python3-pip

# Install MySQL Server & Client
echo "Installing MySQL"
apt-get install mysql-server && apt-get install mysql-client

# Setup MySQL Database
echo "Setting up MySQL Database"
update-rc.d mysql defaults
wget -P /tmp/galaxie/ -O galaxie_database.sql https://raw.githubusercontent.com/mitgobla/Galaxie/master/server/database/galaxie_database.sql
echo "Please enter MySQL username:"
read SQLuser
mysql -u $SQLuser -p < /tmp/galaxie/galaxie_database.sql

# Setup IpTables
echo "Setting up IpTables"
echo "Please enter API server IP address:"
read APIipaddr
# Only allow connections to the database port from the API server.
iptables -A INPUT -p tcp -s $APIipaddr --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -I INPUT -p tcp -s 0.0.0.0/0 --dport 3306 -j DROP
netfilter-persistent save

echo "Cleaning up..."
rm -r /tmp/galaxie/
