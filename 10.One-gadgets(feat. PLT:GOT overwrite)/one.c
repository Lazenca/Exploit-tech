//gcc -fno-stack-protector -o one one.c -ldl
#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <string.h>
  
char asdf[1024];
 
int main()
{
    long long index = 0;
 
    void (*printf_addr)() = dlsym(RTLD_NEXT, "printf");
    printf("Printf() address : %p\n",printf_addr);
    
    memset(&index,0,56); 
    read(0, &index, 1024);
    read(0, asdf+index, 16);
    read(0, &index, 1024);
}
