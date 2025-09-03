import paramiko

def ssh_connection():
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    ssh.connect(hostname='cng.gmu.edu', port=22, username='zli36', password='zli1234')

    stdin, stdout, stderr = ssh.exec_command('hostname')
    print(stdout.read())

    ssh.close()

if __name__ == '__main__':
    ssh_connection()
