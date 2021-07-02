#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Error: this script has to be run as root"
  exit
fi

if [ -f "nmap.log" ]; then
  rm nmap.log
fi

if [ -f "nmap-full.log" ]; then
  rm nmap-full.log
fi

if [ $# -eq 0 ]; then
    echo "Error: please specify an url"
    exit
fi

echo "Starting basic nmap scan..."

nmap -sC -sV "$1" -o nmap.log 2>&1 >/dev/null

echo "Starting full nmap scan..."

nmap -p- "$1" -o nmap-full.log 2>&1 >/dev/null

case "$2" in
        -d) echo "Starting gobuster scan..."
            if [ -f "gobuster.log" ]; then
              rm gobuster.log
            fi
            curl https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt | grep -v "#" | gobuster dir -u "$1" -o gobuster.log -w - 2>&1 >/dev/null 
            ;;
esac
