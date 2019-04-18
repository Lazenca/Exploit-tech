//g++ -o poc poc.cpp -ldl
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cstring>
 
void heapSpray(){
    int size;
    char *data;
 
    printf("Input size:\n");
    read(0, &size, 4);
    if (size > 0) {
        printf("Input contents:\n");
        data = new char[size];
        read(0, data, size);
    }
}
 
int main(){
    printf("Heap spray!\n");
    while(1){
        char status[2];
        heapSpray();
        printf("Will you keep typing?(No:0):\n");
        read(0,&status,2);
 
        if(atoi(status) == 0){
	    printf("Exit!\n");
            break;
	}
    } 
    return 0;
}
