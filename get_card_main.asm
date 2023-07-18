.data
index: .word 0
.align 2
card_list:
.word 0  # list's size
.word 0  # address of list's head (null)

.text
.globl main
main:
la $a0, card_list
lw $a1, index
jal get_card

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk5.asm"