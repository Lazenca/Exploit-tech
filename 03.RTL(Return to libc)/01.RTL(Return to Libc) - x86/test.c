//gcc -m32 -o test test.c
#include <stdlib.h>
#include <stdio.h>
 
void vuln(int a,int b,int c,int d){
        printf("%d, %d, %d, %d",a,b,c,d);
}
 
void main(){
        vuln(1,2,3,4);
}
