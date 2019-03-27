section .data                               ; 데이터 세그먼트
    msg db      "hello, world!",0x0a, 0x0d  ; 문자열과 새 줄 문자, 개행 문자 바이트
 
section .text                               ; 텍스트 세그먼트
    global _start                           ; ELF 링킹을 위한 초기 엔트리 포인트
 
_start:
    ; SYSCALL: write(1,msg,14)
    mov     rax, 1      ; 쓰기 시스템 콜의 번호 '1' 를 rax 에 저장합니다.
    mov     rdi, 1      ; 표준 출력를 나타내는 번호 '1'을 rdi에 저장합니다.
    mov     rsi, msg    ; 문자열 주소를 rsi에 저장니다.
    mov     rdx, 14     ; 문자열의 길이 '14'를 rdx에 저장합니다.
    syscall             ; 시스템 콜을 합니다.
 
    ; SYSCALL: exit(0)
    mov    rax, 60      ; exit 시스템 콜의 번호 '60'을 eax 에 저장합니다.
    mov    rdi, 0       ; 정상 종료를 의미하는 '0'을 ebx에 저장 합니다.
    syscall             ; 시스템 콜을 합니다.
