//gcc 4.8.4 Version
//gcc -m32 -fno-stack-protector -o fpo fpo_alignment.c -ldl
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <stdlib.h>
  
void vuln(){
    char buf[50];
    printf("buf[50] address : %p\n",buf);
    void (*printf_addr)() = dlsym(RTLD_NEXT, "printf");
    printf("Printf() address : %p\n",printf_addr);
    read(0, buf, 63);
}
  
void main(int argc, char *argv[]){
    if(argc<2){
        printf("argv error\n");
        exit(0);
    }
    vuln();
}
