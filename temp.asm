section .data
    int_format db "%d", 0                  ; Format for scanf to read integers
    float_format db "%lf", 0               ; Format for scanf to read double (use %lf for scanf)
    type_prompt db "Enter 1 for Integer, 2 for Float: ", 0
    operation_prompt db "Choose an operation:", 10, 0
    int_result_msg db "Result: %d", 10, 0
    float_result_msg db "Result: %f", 10, 0   ; Use %f for printf to print floats
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0

section .bss
    choice resd 1          ; Store user's menu choice (integer)
    num_type resd 1        ; Store the number type choice
    int_num1 resd 1        ; Reserve space for first integer
    int_num2 resd 1        ; Reserve space for second integer
    int_result resd 1      ; Reserve space for integer result
    float_num1 resq 1      ; Reserve space for first floating-point number (double)
    float_num2 resq 1      ; Reserve space for second floating-point number (double)
    float_result resq 1    ; Reserve space for floating-point result (double)

section .text
    extern printf, scanf, ExitProcess
    global main

main:
    sub rsp, 40              ; Reserve space for shadow and alignment

    ; Ask for number type (1 for Integer, 2 for Float)
    lea rcx, [rel type_prompt]
    call printf
    lea rcx, [rel int_format]
    lea rdx, [rel num_type]
    call scanf

    ; Check user's choice for number type
    mov eax, [rel num_type]
    cmp eax, 1
    je integer_operations
    cmp eax, 2
    je float_operations

    ; Invalid choice, exit
    jmp exit_program

integer_operations:
    call get_int_input1
    call get_int_input2

    mov eax, [rel int_num1]
    add eax, [rel int_num2]
    mov [rel int_result], eax
    lea rcx, [rel int_result_msg]
    mov rdx, [rel int_result]
    call printf
    jmp exit_program

float_operations:
    call get_float_input1
    call get_float_input2

    ; Perform floating-point addition
    movsd xmm0, qword [rel float_num1]   ; Load first float into xmm0
    addsd xmm0, qword [rel float_num2]   ; Add second float to xmm0
    movsd qword [rel float_result], xmm0 ; Store result back to memory

    ; Print the floating-point result
    lea rcx, [rel float_result_msg]
    mov rdx, qword [rel float_result]    ; Move float result to rdx for printf
    call printf

    jmp exit_program

get_int_input1:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input first number
    lea rcx, [rel prompt1]    ; Load address of prompt1 into rcx
    call printf

    lea rdx, [rel int_num1]       ; Load address of num1 into rdx
    lea rcx, [rel int_format]     ; Load address of format into rcx
    call scanf                ; Call scanf with format in rcx, address in rdx

    add rsp, 40               ; Restore stack alignment

    ret

get_int_input2:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input second number
    lea rcx, [rel prompt2]    ; Load address of prompt2 into rcx
    call printf

    lea rdx, [rel int_num2]       ; Load address of num2 into rdx
    lea rcx, [rel int_format]     ; Load address of format into rcx
    call scanf                ; Call scanf with format in rcx, address in rdx

    add rsp, 40               ; Restore stack alignment

    ret

get_float_input1:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input first floating-point number
    lea rcx, [rel prompt1]
    call printf
    lea rdx, [rel float_num1]
    lea rcx, [rel float_format]
    call scanf

    add rsp, 40               ; Restore stack alignment

    ret

get_float_input2:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input second floating-point number
    lea rcx, [rel prompt2]
    call printf
    lea rdx, [rel float_num2]
    lea rcx, [rel float_format]
    call scanf

    add rsp, 40               ; Restore stack alignment

    ret

exit_program:
    add rsp, 40
    xor ecx, ecx
    call ExitProcess
