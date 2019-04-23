//clang -fno-stack-protector -Wl,-z,relro,-z,now -o rop rop.c
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
  
void vuln(){
    char buf[50];
    read(0, buf, 512);
}
  
int main(){
    write(1,"Hello ROP\n",10);
    vuln();
    return 0;
}
