//gcc -fno-stack-protector -o rop rop.c -ldl
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h> 

void vuln(){
    char buf[50];
    read(0, buf, 512);
}

void main(){
    write(1,"Hello ROP\n",10);
    vuln();
}
