//gcc -m32 -g -o sig32 sig.c
#include <stdio.h>
#include <signal.h>
 
struct sigcontext sigcontext;
 
void handle_signal(int signum){
    printf("Signal number: %d\n", signum);
}
 
int main(){
    signal(SIGINT, (void *)handle_signal);
    while(1) {}
    return 0;
}
