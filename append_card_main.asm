.data
card_num: .word 6570802
.align 2
card_list:
.word 5  # list's size
.word node537691 # address of list's head
node299116:
.word 7689011
.word 0
node411020:
.word 6572086
.word node171407
node537691:
.word 6574898
.word node253109
node171407:
.word 7684917
.word node299116
node253109:
.word 7685168
.word node411020

.text
.globl main
main:
la $a0, card_list
lw $a1, card_num
jal append_card

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk5.asm"
