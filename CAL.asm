section .data
    format db "%d", 0  ; Correct format for reading an integer

    ; Messages and constants
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    result_msg db "Result: %d", 10, 0

section .bss
    num1 resd 1       ; Reserve space for first number
    num2 resd 1       ; Reserve space for second number
    result resd 1     ; Reserve space for result

section .text
    extern printf, scanf, ExitProcess
    global main

main:
    ; Clear the stack and setup for function calls
    sub rsp, 40

    ; Prompt and input first number
    lea rcx, [rel prompt1]
    call printf
    lea rdx, [rel num1]
    lea rcx, [rel format]
    call scanf

    ; Prompt and input second number
    lea rcx, [rel prompt2]
    call printf
    lea rdx, [rel num2]
    lea rcx, [rel format]
    call scanf

    ; Perform addition (can replace with subtraction, multiplication, or division)
    mov eax, [rel num1]
    add eax, [rel num2]
    mov [rel result], eax

    ; Print the result
    lea rcx, [rel result_msg]
    mov rdx, [rel result]
    call printf

    ; Clean up and exit
    add rsp, 40
    xor ecx, ecx
    call ExitProcess
