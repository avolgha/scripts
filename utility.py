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

if __name__ == '__main__':
    for ip in ['0.0.0.0', 'google.com', 'aaa.tvv']:
        if check_if_is_ip(ip):
            print(f'{ip} is valid')
        else:
            print(f'{ip} is invalid')
    print(socket.gethostbyname('0.0.0.0'))
    print(socket.gethostbyname('google.com'))
        