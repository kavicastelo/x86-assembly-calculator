# Nasm x86 Assembly Calculator

### Overview

This project is an advanced calculator written in x64 assembly for Windows. It supports both integer and floating-point
operations, including addition, subtraction, multiplication, division, exponentiation, modulus, and trigonometric
functions. The calculator allows the user to choose between integer and floating-point calculations.

### Features
- Integer Operations:
    - Addition
    - Subtraction
    - Multiplication
    - Division
    - Modulus
    - Exponentiation

- Floating-Point Operations:
    - Addition
    - Subtraction
    - Multiplication
    - Division
    - Modulus
    - Exponentiation
    - Sine
    - Cosine
    - Tangent
    - Square Root

### Requirements

- **NASM** - The Netwide Assembler for assembling the code.
- **MinGW-w64** - For linking the object files to create an executable.

### Usage

1. Clone the repository:
    ```shell
    git clone https://github.com/kavicastelo/assembly_calculator.git
    cd assembly_calculator
    ```

2. Assemble the Code:
    Use NASM to assemble the code into an object file:
    ```shell
    nasm -f win64 CAL.asm -o CAL.obj
    ```
   
3. Link the Object File:
    Use MinGW-w64 to link the object file to create an executable:
    ```shell
    gcc -o CAL.exe CAL.obj
    ```

4. Run the executable:
    After successfully building the executable, run it:
    ```shell
    ./CAL.exe
    ```
   
5. Using the Calculator:
   - The calculator displays a menu to choose the desired operation.
   - You will be prompted to select between integer and floating-point calculations.
   - Enter the required numbers as prompted.
   - The result will be displayed, and the menu will be shown again for further operations.

### Limitations
   - The calculator does not support memory storage for recalling previous results.
   - Input validation is minimal; incorrect inputs may cause unexpected behavior.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
