//gcc -fno-stack-protector -o fpo fpo.c -ldl
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <stdlib.h>
 
void vuln(){
    char buf[32];
    printf("buf[32] address : %p\n",buf);
    void (*printf_addr)() = dlsym(RTLD_NEXT, "printf");
    printf("Printf() address : %p\n",printf_addr);
    read(0, buf, 49);
}
 
void main(int argc, char *argv[]){
    if(argc<2){
        printf("argv error\n");
        exit(0);
    }
    vuln();
}
