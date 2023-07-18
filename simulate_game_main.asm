# Simulate game04.txt - results in a loss
.data
filename: .asciiz "game04.txt"
### Deck ###
# Garbage values
deck: .word 19159058 60556872
### Board ###
# Garbage values
.data
.align 2
board:
.word card_list541949 card_list144045 card_list109868 card_list386926 card_list597883 card_list284952 card_list255055 card_list337702 card_list45115 
# column #7
.align 2
card_list337702:
.word 213147  # list's size
.word 929558 # address of list's head
# column #2
.align 2
card_list109868:
.word 360261  # list's size
.word 524417 # address of list's head
# column #0
.align 2
card_list541949:
.word 340637  # list's size
.word 913724 # address of list's head
# column #5
.align 2
card_list284952:
.word 356601  # list's size
.word 97368 # address of list's head
# column #1
.align 2
card_list144045:
.word 539723  # list's size
.word 583615 # address of list's head
# column #4
.align 2
card_list597883:
.word 235830  # list's size
.word 936833 # address of list's head
# column #6
.align 2
card_list255055:
.word 974983  # list's size
.word 530896 # address of list's head
# column #3
.align 2
card_list386926:
.word 571954  # list's size
.word 761609 # address of list's head
# column #8
.align 2
card_list45115:
.word 277400  # list's size
.word 417512 # address of list's head
# Garbage values
moves: .ascii "f3rXNtgppaRqx6x4hpG6taZeSVTrfXQSHPYHzpx2v6D3NnJBFceYXd1gg5EzmH1SHTVa6JUQn9wU5ji9S24KkN3LPSt2qe783Cb3fr2GeqAQUZQDvhiDQiYN6I7MNtIVJ5u4FOP37K8skmXoYPDuefE43pCzpSytuIW6IT8rQ4JLJUbUHgCRiiE4Bi9QDU9h34riZpfgN91L7sviu7RBsfp63KVd4HzxBX0Ocq32osDQInDenn3RkG3Rtiulsfzw0pA8U0CWkasGNa2ToCBk0sttX9XdU5p4Coa2cxs1j4B51VQ14KemWD1kb0Jjhjl9YJ2J6I1Had4fpD8EQ089X1HGwlSA3Fgb2SMqn5OyMOvVGKbIllm5sYlFbz2iuNFY5IDUs1jZhXoZLESu4e4nxQUbntF99QAcW2WT05M0W89EDon2yhKJMywgPmmcoHX1P2ZXH7VmlqAsWQVRlLgatJqBQfauQzA04PK2wKt9DX9Fyj9VXl8f6BRfxn5UdS21a6AlMP77g"





.text
.globl main
main:
la $a0, filename
la $a1, board
la $a2, deck
la $a3, moves
jal simulate_game

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk5.asm"
