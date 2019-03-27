BITS 32			; nasm에게 32비트 코드임을 알린다

jmp short last	; 맨 끝으로 점프한다.
helloworld:
	; ssize_t write(int fd, const void *buf, size_t count);
	pop ecx 	; 리턴 주소를 팝해서 exc에 저장합니다.
	xor eax,eax	; eax 레지스터의 값을 0으로 초기화합니다.
	mov al, 4	; 시스템 콜 번호를 씁니다.
	xor ebx,ebx	; ebx 레지스터의 값을 0으로 초기화합니다.
	mov bl, 1	; STDOUT 파일 서술자
	xor edx,edx	; edx 레지스터의 값을 0으로 초기화합니다.
	mov dl, 15	; 문자열 길지
	int 0x80	; 시스템 콜: write(1,string, 14)

	; void _exit(int status);
	mov al,1	;exit 시스템 콜 번호
	xor ebx,ebx	;Status = 0
	int 0x80	;시스템 콜: exit(0)
 
last:
	call helloworld	; 널 바이트를 해결하기 위해 위로 돌아간다.
	db "Hello, world!", 0x0a, 0x0d	; 새 줄 바이트와 개행 문자 바이트
