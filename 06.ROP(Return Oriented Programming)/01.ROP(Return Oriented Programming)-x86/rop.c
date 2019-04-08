#include <stdio.h>
#include <unistd.h>
  
void vuln(){
    char buf[50];
    read(0, buf, 256);
}
 
void main(){
    write(1,"Hello ROP\n",10);
    vuln();
}
