section .data
    format db "%d", 0                   ; Format for scanf to read integers
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
    error_msg db "Error: Division by zero!", 10, 0

section .bss
    choice resd 1          ; Store user's menu choice (integer)
    num1 resd 1            ; Reserve space for first number
    num2 resd 1            ; Reserve space for second number
    result resd 1          ; Reserve space for result

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
    lea rcx, [rel format]
    call scanf

    ; Load the user's choice into eax for comparison
    mov eax, [rel choice]

    ; Check user's choice and branch accordingly
    cmp eax, 1
    je add_operation
    cmp eax, 2
    je sub_operation
    cmp eax, 3
    je mul_operation
    cmp eax, 4
    je div_operation
    cmp eax, 5
    je exit_program

    ; Invalid choice, go back to menu
    jmp menu_loop

add_operation:
    call get_input1
    call get_input2
    mov eax, [rel num1]         ; Load num1 into eax
    add eax, [rel num2]         ; Add num2 to eax
    mov [rel result], eax       ; Store the result
    jmp print_result

sub_operation:
    call get_input1
    call get_input2
    mov eax, [rel num1]         ; Load num1 into eax
    sub eax, [rel num2]         ; Subtract num2 from eax
    mov [rel result], eax       ; Store the result
    jmp print_result

mul_operation:
    call get_input1
    call get_input2
    mov eax, [rel num1]         ; Load num1 into eax
    imul eax, [rel num2]        ; Multiply eax by num2
    mov [rel result], eax       ; Store the result
    jmp print_result

div_operation:
    call get_input1
    call get_input2
    mov eax, [rel num2]         ; Load num2 (divisor) into eax
    test eax, eax               ; Check if the divisor is 0
    jz handle_div_zero          ; Jump to error handling if divisor is 0
    mov eax, [rel num1]         ; Load num1 (dividend) into eax
    xor edx, edx                ; Clear edx before division
    div dword [rel num2]        ; Divide edx:eax by num2 (divisor)
    mov [rel result], eax       ; Store the quotient in result
    jmp print_result

handle_div_zero:
    lea rcx, [rel error_msg]
    call printf
    jmp menu_loop

print_result:
    ; Print the result
    lea rcx, [rel result_msg]
    mov rdx, [rel result]
    call printf
    jmp menu_loop

get_input1:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input first number
    lea rcx, [rel prompt1]    ; Load address of prompt1 into rcx
    call printf

    lea rdx, [rel num1]       ; Load address of num1 into rdx
    lea rcx, [rel format]     ; Load address of format into rcx
    call scanf                ; Call scanf with format in rcx, address in rdx

    add rsp, 40               ; Restore stack alignment
    ret

get_input2:
    sub rsp, 40               ; Align stack before scanf call

    ; Prompt and input second number
    lea rcx, [rel prompt2]    ; Load address of prompt2 into rcx
    call printf

    lea rdx, [rel num2]       ; Load address of num2 into rdx
    lea rcx, [rel format]     ; Load address of format into rcx
    call scanf                ; Call scanf with format in rcx, address in rdx

    add rsp, 40               ; Restore stack alignment
    ret

exit_program:
    ; Clean up and exit
    add rsp, 40
    xor ecx, ecx
    call ExitProcess
