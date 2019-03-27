#include<stdio.h>
#include<string.h>
 
unsigned char shellcode [] = "\xe8\x0f\x00\x00\x00Hello, world!\n\rY\xb8\x04\x00\x00\x00\xbb\x01\x00\x00\x00\xba\x0f\x00\x00\x00\xcd\x80\xb8\x01\x00\x00\x00\xbb\x00\x00\x00\x00\xcd\x80";
unsigned char code[];
 
void main(){
    int len = strlen(shellcode);
    printf("Shellcode len : %d\n",len);
    strcpy(code,shellcode);
    (*(void(*)()) code)();
}
