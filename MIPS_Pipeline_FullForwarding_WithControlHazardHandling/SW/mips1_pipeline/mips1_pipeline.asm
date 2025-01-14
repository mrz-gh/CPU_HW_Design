.data
array:  .word 10, 20, 30, 40, 50  # An array of integers
length: .word 5                   # Length of the array
sum:    .word 0                   # Variable to store the sum of the array
result: .word 0                   # Variable to store the final result

.text
.globl main
main:
    # Initialize registers
    li   $t0, 0           # $t0 will hold the sum (sum = 0)

    li   $t1, 0           # $t1 will be the index (i = 0)


    # Load the length of the array
    lw   $t2, length      # $t2 = length of the array


    # Load the base address of the array
    la   $t3, array       # $t3 = base address of the array


array_sum_loop:
    # Check if the index is less than the length of the array
    slt  $t4, $t1, $t2    # $t4 = 1 if $t1 < $t2, else $t4 = 0

    beq  $t4, $zero, end_sum # if $t4 == 0 (index >= length), exit loop


    # Load the current array element
    sll  $t5, $t1, 2      # $t5 = i * 4 (word offset)

    add  $t6, $t3, $t5    # $t6 = base address + offset

    lw   $t7, 0($t6)      # $t7 = array[i]


    # Add the current element to the sum
    add  $t0, $t0, $t7    # sum += array[i]


    # Increment the index
    addi $t1, $t1, 1      # i += 1


    # Repeat the loop
    j    array_sum_loop


end_sum:
    # Store the sum in memory
    sw   $t0, sum         # Save the sum to the memory location 'sum'


    # Load the constant 0xF0F0F0F0 using lui and ori
    lui  $t8, 0xF0F0      # Load the upper 16 bits

    ori  $t8, $t8, 0xF0F0 # Load the lower 16 bits


    # Perform a logical operation: bitwise AND with the constant
    and  $t9, $t0, $t8    # $t9 = sum & 0xF0F0F0F0


    # Shift the result to the right
    srl  $t9, $t9, 4      # Logical right shift $t9 by 4 bits


    # Store the final result in memory
    sw   $t9, result      # Save the final result to the memory location 'result'


infinite_loop:
    # Infinite loop
    j    infinite_loop    # Jump to itself to create an infinite loop

