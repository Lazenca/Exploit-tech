//gcc -m32 -fno-stack-protector -o ff ff.c -ldl
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>

void vuln(){
    char buf[50];
    printf("buf[50] address : %p\n",buf);
    void (*printf_addr)() = dlsym(RTLD_NEXT, "printf");
    printf("Printf() address : %p\n",printf_addr);
    read(0, buf, 70);
}
 
void main(){
    vuln();
}
