//gcc -o test test.c
#include <stdlib.h>
#include <stdio.h>
  
void vuln(int a,int b,int c,int d){
        printf("%d, %d, %d, %d",a,b,c,d);
}
  
void main(int argc, char* argv[]){
        vuln(1,2,3,4);
}
