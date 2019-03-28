#include <unistd.h>
 
int main() {
        char *argv[2] = {"/bin/sh", NULL};
        execve(argv[0], argv, NULL);
}
