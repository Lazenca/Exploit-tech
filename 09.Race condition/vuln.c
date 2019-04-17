#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
 
void main()
{
    int fd;
    char *file = "./file";
    char buffer[]="Success!! Race Condition : lazenca.0x0\n";

    if (!access(file, W_OK)) {
		printf("Able to open file %s.\n",file);
		fd = open(file, O_WRONLY);
		write(fd, buffer, sizeof(buffer));
		close(fd); 
    }else{
		//printf("Unable to open file %s.\n",file);
    }
}
