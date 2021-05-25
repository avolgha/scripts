import requests
import argparse
import socket

def check_if_is_ip(ip: str) -> bool:
    try:
        socket.inet_aton(ip)
        return True
    except socket.error:
        try:
            socket.inet_aton(socket.gethostbyname(ip))
            return True
        except:
            return False

def get_host_name(ip: str) -> str:
    return socket.gethostbyname(ip)

parser = argparse.ArgumentParser(description='Controle with there are some sub directories that aren\'t listed')
parser.add_argument('ip', help='IP Address you want to check')
parser.add_argument('wordlist', help='Worldlist you want to use for validation')

args = parser.parse_args()

try:
    address = get_host_name(args.ip)
    if not check_if_is_ip(address):
        print('Address is not valid')
        exit(1)
except:
    print('Address is not valid')
    exit(1)

try:
    with open(args.wordlist) as wordlist_file:
        worldlist = ''.join(wordlist_file.readlines()).split('\n')
except:
    print('Couldn\'t read wordlist')
    exit(1)

valid = 0
valid_names = []
for word in worldlist:
    if word == '':
        continue
    try:
        r = requests.get(f'http://{address}/{word}')
        if r.status_code == 200:
            valid += 1
            valid_names.append(word)
            print(f'\033[0;32mValid directory "{word}"\033[0;0m')
        else:
            print(f'\033[0;31mFailed to fetch directory "{word}". Status code: {r.status_code}\033[0;0m')
    except Exception:
        print(f'\033[0;31mFailed to fetch directory "{word}". Exception error\033[0;0m')

if valid == 1:
    print(f'\033[0;34mFound {valid} directory\033[0;0m')
else:
    print(f'\033[0;34mFound {valid} directories\033[0;0m')
raw = ','.join(valid_names)
print(f'\033[0;34mRaw: \033[0;0m[{raw}]')