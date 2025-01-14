.data
array:  .word 10, 20, 30, 40, 50  # An array of integers
result: .word 0                   # Variable to store the final result
.text
.globl main
main:
    # Arithmetic operations
    li   $t0, 10         # Load immediate value into $t0

    li   $t1, 20         # Load immediate value into $t1

    add  $t2, $t0, $t1   # $t2 = $t0 + $t1

    addu $t3, $t0, $t1   # $t3 = $t0 + $t1 (unsigned)

    sub  $t4, $t1, $t0   # $t4 = $t1 - $t0

    subu $t5, $t1, $t0   # $t5 = $t1 - $t0 (unsigned)


    # Comparison operations
    slt  $t6, $t0, $t1   # $t6 = 1 if $t0 < $t1, else 0

    sltu $t7, $t0, $t1   # $t7 = 1 if $t0 < $t1 (unsigned), else 0


    # Logical operations
    and  $t8, $t0, $t1   # $t8 = $t0 & $t1

    or   $t9, $t0, $t1   # $t9 = $t0 | $t1

    xor  $t0, $t0, $t1   # $t0 = $t0 ^ $t1

    nor  $t1, $t0, $t1   # $t1 = ~($t0 | $t1)

    # Shift operations
    sll  $t2, $t2, 2     # $t2 = $t2 << 2

    srl  $t3, $t3, 1     # $t3 = $t3 >> 1 (logical)

    sllv $t4, $t2, $t1   # $t4 = $t2 << $t1 (variable shift)


    # Arithmetic operations with immediates
    addi $t5, $t5, 10    # $t5 = $t5 + 10

    addiu $t6, $t6, 5    # $t6 = $t6 + 5 (unsigned)

    slti $t7, $t0, 30    # $t7 = 1 if $t0 < 30, else 0

    sltiu $t8, $t0, 40   # $t8 = 1 if $t0 < 40 (unsigned), else 0


    # Logical operations with immediates
    andi $t9, $t1, 0xFF  # $t9 = $t1 & 0xFF

    ori  $t0, $t0, 0xF0  # $t0 = $t0 | 0xF0

    xori $t1, $t1, 0x0F  # $t1 = $t1 ^ 0x0F


    # Load upper immediate
    lui  $t2, 0x1234     # Load upper immediate 0x1234 into $t2


    # Load and store operations
    lw   $t3, array      # Load word from memory

    sw   $t3, result     # Store word to memory


    # Branch operations
    beq  $t0, $t1, label1 # Branch if $t0 == $t1
 
    bne  $t0, $t1, label2 # Branch if $t0 != $t1


label1:
    # Jump and link
    jal  func             # Jump to function and link

label2:
    # Unconditional jump
    j    infinite_loop    # Jump to infinite loop


func:
    # Jump return
    jr   $ra              # Return from function


infinite_loop:
    # Infinite loop
    j    infinite_loop    # Loop forever

