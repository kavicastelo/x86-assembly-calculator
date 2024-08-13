section .data
    int_format db "%d", 0                   ; Format for scanf to read integers
    float_format db "%lf", 0                ; Format for scanf to read double (use %lf for scanf)
    menu_msg db "Choose an operation:", 10, 0
    option1 db "1. Addition", 10, 0
    option2 db "2. Subtraction", 10, 0
    option3 db "3. Multiplication", 10, 0
    option4 db "4. Division", 10, 0
    option5 db "5. Exit", 10, 0
    prompt db "Enter your choice: ", 0
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    result_msg db "Result: %d", 10, 0
    float_result_msg db "Result: %f", 10, 0   ; Use %f for printf to print floats
    error_msg db "Error: Division by zero!", 10, 0
    type_prompt db "Enter 1 for Integer, 2 for Float: ", 0

section .bss
    choice resd 1          ; Store user's menu choice (integer)
    num1 resd 1            ; Reserve space for first number
    num2 resd 1            ; Reserve space for second number
    result resd 1          ; Reserve space for result
    num_type resd 1        ; Store the number type choice
    float_num1 resq 1      ; Reserve space for first floating-point number (double)
    float_num2 resq 1      ; Reserve space for second floating-point number (double)
    float_result resq 1    ; Reserve space for floating-point result (double)

section .text
    extern printf, scanf, ExitProcess
    global main

main:
    sub rsp, 40              ; Reserve space for shadow and alignment

menu_loop:
    ; Print the menu
    lea rcx, [rel menu_msg]
    call printf
    lea rcx, [rel option1]
    call printf
    lea rcx, [rel option2]
    call printf
    lea rcx, [rel option3]
    call printf
    lea rcx, [rel option4]
    call printf
    lea rcx, [rel option5]
    call printf

    ; Get the user's choice
    lea rcx, [rel prompt]
    call printf
    lea rdx, [rel choice]
    lea rcx, [rel int_format]
    call scanf

    ; Load the user's choice into eax for comparison
    mov eax, [rel choice]

    ; Check user's choice and branch accordingly
    cmp eax, 1
    je choose_num_type_add
    cmp eax, 2
    je choose_num_type_sub
    cmp eax, 3
    je choose_num_type_mul
    cmp eax, 4
    je choose_num_type_div
    cmp eax, 5
    je exit_program

    ; Invalid choice, go back to menu
    jmp menu_loop

choose_num_type_add:
    ; Ask for number type (1 for Integer, 2 for Float)
    lea rcx, [rel type_prompt]
    call printf
    lea rcx, [rel int_format]
    lea rdx, [rel num_type]
    call scanf

    mov eax, [rel num_type]
    cmp eax, 1
    je int_add_operation
    cmp eax, 2
    je float_add_operation

    ; Invalid choice, go back to menu
    jmp menu_loop

choose_num_type_sub:
    ; Ask for number type (1 for Integer, 2 for Float)
    lea rcx, [rel type_prompt]
    call printf
    lea rcx, [rel int_format]
    lea rdx, [rel num_type]
    call scanf

    mov eax, [rel num_type]
    cmp eax, 1
    je int_sub_operation
    cmp eax, 2
    je float_sub_operation

    ; Invalid choice, go back to menu
    jmp menu_loop

choose_num_type_mul:
    ; Ask for number type (1 for Integer, 2 for Float)
    lea rcx, [rel type_prompt]
    call printf
    lea rcx, [rel int_format]
    lea rdx, [rel num_type]
    call scanf

    mov eax, [rel num_type]
    cmp eax, 1
    je int_mul_operation
    cmp eax, 2
    je float_mul_operation

    ; Invalid choice, go back to menu
    jmp menu_loop

choose_num_type_div:
    ; Ask for number type (1 for Integer, 2 for Float)
    lea rcx, [rel type_prompt]
    call printf
    lea rcx, [rel int_format]
    lea rdx, [rel num_type]
    call scanf

    mov eax, [rel num_type]
    cmp eax, 1
    je int_div_operation
    cmp eax, 2
    je float_div_operation

    ; Invalid choice, go back to menu
    jmp menu_loop

int_add_operation:
    call int_get_input1
    call int_get_input2
    mov eax, [rel num1]         ; Load num1 into eax
    add eax, [rel num2]         ; Add num2 to eax
    mov [rel result], eax       ; Store the result
    jmp int_print_result

int_sub_operation:
    call int_get_input1
    call int_get_input2
    mov eax, [rel num1]         ; Load num1 into eax
    sub eax, [rel num2]         ; Subtract num2 from eax
    mov [rel result], eax       ; Store the result
    jmp int_print_result

int_mul_operation:
    call int_get_input1
    call int_get_input2
    mov eax, [rel num1]         ; Load num1 into eax
    imul eax, [rel num2]        ; Multiply eax by num2
    mov [rel result], eax       ; Store the result
    jmp int_print_result

int_div_operation:
    call int_get_input1
    call int_get_input2
    mov eax, [rel num2]         ; Load num2 (divisor) into eax
    test eax, eax               ; Check if the divisor is 0
    jz int_handle_div_zero      ; Jump to error handling if divisor is 0
    mov eax, [rel num1]         ; Load num1 (dividend) into eax
    xor edx, edx                ; Clear edx before division
    div dword [rel num2]        ; Divide edx:eax by num2 (divisor)
    mov [rel result], eax       ; Store the quotient in result
    jmp int_print_result

int_handle_div_zero:
    lea rcx, [rel error_msg]
    call printf
    jmp menu_loop

int_print_result:
    ; Print the result
    lea rcx, [rel result_msg]
    mov rdx, [rel result]
    call printf
    jmp menu_loop

float_add_operation:
    call get_float_input1
    call get_float_input2

    ; Perform floating-point addition
    movsd xmm0, qword [rel float_num1]   ; Load first float into xmm0
    addsd xmm0, qword [rel float_num2]   ; Add second float to xmm0
    movsd qword [rel float_result], xmm0 ; Store result back to memory
    jmp float_print_result

float_sub_operation:
    call get_float_input1
    call get_float_input2

    ; Perform floating-point subtraction
    movsd xmm0, qword [rel float_num1]   ; Load first float into xmm0
    subsd xmm0, qword [rel float_num2]   ; Subtract second float from xmm0
    movsd qword [rel float_result], xmm0 ; Store result back to memory
    jmp float_print_result

float_mul_operation:
    call get_float_input1
    call get_float_input2

    ; Perform floating-point multiplication
    movsd xmm0, qword [rel float_num1]   ; Load first float into xmm0
    mulsd xmm0, qword [rel float_num2]   ; Multiply xmm0 by second float
    movsd qword [rel float_result], xmm0 ; Store result back to memory
    jmp float_print_result

float_div_operation:
    call get_float_input1
    call get_float_input2

    ; Perform floating-point division
    movsd xmm0, qword [rel float_num1]   ; Load first float into xmm0
    movsd xmm1, qword [rel float_num2]   ; Load second float into xmm1
    comisd xmm1, xmm0                    ; Compare the second float to zero
    jp float_handle_div_zero             ; Jump to error handling if divisor is 0
    divsd xmm0, xmm1                     ; Divide xmm0 by xmm1
    movsd qword [rel float_result], xmm0 ; Store result back to memory
    jmp float_print_result

float_handle_div_zero:
    lea rcx, [rel error_msg]
    call printf
    jmp menu_loop

float_print_result:
    ; Print the result
    lea rcx, [rel float_result_msg]
    mov rdx, qword [rel float_result]
    call printf
    jmp menu_loop

int_get_input1:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input first number
    lea rcx, [rel prompt1]    ; Load address of prompt1 into rcx
    call printf

    lea rdx, [rel num1]       ; Load address of num1 into rdx
    lea rcx, [rel int_format] ; Load address of format into rcx
    call scanf                ; Call scanf with format in rcx, address in rdx

    add rsp, 40               ; Restore stack alignment
    ret

int_get_input2:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input second number
    lea rcx, [rel prompt2]    ; Load address of prompt2 into rcx
    call printf

    lea rdx, [rel num2]       ; Load address of num2 into rdx
    lea rcx, [rel int_format] ; Load address of format into rcx
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
    ; Clean up and exit
    add rsp, 40
    xor ecx, ecx
    call ExitProcess
