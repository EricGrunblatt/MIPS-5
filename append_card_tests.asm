# Append an item to an empty list
.data
card_num: .word 6570802
.align 2
card_list:
.word 0  # list's size
.word 0  # address of list's head (null)


# Append an item to a short list
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


