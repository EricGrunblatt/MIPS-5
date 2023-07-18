# Attempt to get a card from an empty list
.data
index: .word 0
.align 2
card_list:
.word 0  # list's size
.word 0  # address of list's head (null)


# Illegal index
.data
index: .word 5
.align 2
card_list:
.word 5  # list's size
.word node924757 # address of list's head
node66998:
.word 7689011
.word 0
node961940:
.word 6572086
.word node481511
node481511:
.word 7684917
.word node66998
node924757:
.word 6574898
.word node495556
node495556:
.word 7685168
.word node961940


# Get a card at index 0
.data
index: .word 0
.align 2
card_list:
.word 5  # list's size
.word node384567 # address of list's head
node68483:
.word 7685168
.word node25
node352830:
.word 7689011
.word 0
node25:
.word 6572086
.word node661935
node661935:
.word 7684917
.word node352830
node384567:
.word 6574898
.word node68483


# Get a card in the middle of a list
.data
index: .word 3
.align 2
card_list:
.word 8  # list's size
.word node434155 # address of list's head
node880296:
.word 7689011
.word node831465
node831465:
.word 6574898
.word node970496
node434155:
.word 6574898
.word node519944
node365336:
.word 7684917
.word node880296
node378857:
.word 6572083
.word 0
node970496:
.word 7684912
.word node378857
node519944:
.word 7685168
.word node329863
node329863:
.word 6572086
.word node365336


# Get the last card in the list
.data
index: .word 7
.align 2
card_list:
.word 8  # list's size
.word node85405 # address of list's head
node930524:
.word 6574898
.word node968934
node265857:
.word 7689011
.word node930524
node45000:
.word 6572086
.word node38905
node870030:
.word 6572083
.word 0
node579585:
.word 7685168
.word node45000
node85405:
.word 6574898
.word node579585
node38905:
.word 7684917
.word node265857
node968934:
.word 7684912
.word node870030


