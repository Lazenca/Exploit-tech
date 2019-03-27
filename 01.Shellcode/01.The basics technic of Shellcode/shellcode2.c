#include<stdio.h>
#include<string.h>

unsigned char shellcode [] = "\xeb\x15\x59\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x31\xd2\xb2\x0f\xcd\x80\xb0\x01\x31\xdb\xcd\x80\xe8\xe6\xff\xff\xffHello, world!\n\r";
unsigned char code[] = "";

void main()
{
	int len = strlen(shellcode);
	printf("Shellcode len : %d\n",len);
	strcpy(code,shellcode);
	(*(void(*)()) code)();
}
