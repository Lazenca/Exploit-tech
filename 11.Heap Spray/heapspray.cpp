//g++ -o heapspray heapspray.cpp -ldl
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <cstring>
#include <dlfcn.h>

class UAF {
    char memo[160];

public:
    UAF(char *memo) { 
		strncpy(this->memo,memo,strlen(this->memo));
    }

    virtual void target() { 
		write(1, this->memo, strlen(this->memo));
    }
};

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
    char memo[160] = {};

    void *printf_addr = dlsym(RTLD_NEXT, "printf");
    printf("Printf() address : %p\n",printf_addr);

    printf("Heap spray!\n");
    while(1){
        char status[2];
        heapSpray();
        printf("Will you keep typing?(No:0):\n");
        read(0,&status,2);

        if(atoi(status) == 0)
            break;
    }

    printf("Create vtable\n");
    read(0, memo, sizeof(memo));

    UAF *uaf = new UAF(memo);
    delete uaf;

    printf("UAF!\n");
    heapSpray();

    uaf->target();

    return 0;
}
