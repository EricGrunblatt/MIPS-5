# Eric Grunblatt
# egrunblatt
# 112613770

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

init_list:
	sw $0, 0($a0)					# set head to 0
	sw $0, 4($a0)					# set size to 0
   	jr $ra						# return to main address

append_card:
	addi $sp, $sp, -8				# allocate 8 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	move $s0, $a0					# $s0 = card list
	move $s1, $a1					# $s1 = card num
	
	li $a0, 8					# $a0 = 8 byte buffer
	li $v0, 9					# get ready to allocate heap space
	syscall						# $v0 = new address
	
	lbu $t0, 0($s0)					# $t0 = card list size
	beq $t0, $0, append_card_size_0			# $t0 = $0, append_card_size_0
	
	sw $s1, 0($v0)					# store card num as first word
	sw $0, 4($v0)					# store null terminator as second word
	
	lw $t0, 4($s0)					# $t0 = head of list
	beq $t0, $0, end_append_card_loop		# $t0 = $0, end loop
	append_card_loop:
		lw $t1, 4($t0)				# $t0 = next node
		beq $t1, $0, end_append_card_loop	# $t0 = $0, end loop
		move $t0, $t1				# $t0 = $t1
		j append_card_loop			# jump to top of loop
	end_append_card_loop:
	sw $v0, 4($t0)					# store new address at the previous tail
	sw $s1, 0($v0)					# stores card num
	sw $0, 4($v0)					# points to null terminator
	lw $t2, 0($s0)					# $t2 = size of card list
	addi $t2, $t2, 1				# add 1 to size
	move $v0, $t2					# $v0 = size
	sw $t2, 0($s0)					# store new size
	j append_card_load				# jump to append_card_load
	
	append_card_size_0:
		li $t1, 1				# $t1 = 1
		sw $t1, 0($s0)				# new size = 1
		sw $v0, 4($s0)				# head of list = new address
		
		sw $s1, 0($v0)				# stores card num
		sw $0, 4($v0)				# points to null terminator
		li $v0, 1				# $v0 = 1
		j append_card_load			# jump to append_card_load
	
	append_card_load:
	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	addi $sp, $sp, 8				# deallocate 8 bytes of space
   	jr $ra						# return to main address

create_deck:
	addi $sp, $sp, -20				# allocate 20 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $ra, 16($sp)					# store $ra
	
	li $a0, 8					# $a0 = 8 byte buffer
	li $v0, 9					# get ready to allocate heap space
	syscall						# $v0 = new address
	
	move $s0, $v0					# $s0 = new address
	move $a0, $s0					# $a0 = new address
	jal init_list					# jump and link init_list
	
	li $s2, 0					# $s2 = 0, counter for outer loop
	create_deck_loop:
		li $t0, 7				# $t0 = 7, outerloop end
		bgt $s2, $t0, end_create_deck_loop	# $s2 > 7, end loop 
		li $s1, 0x00645330			# $s1 = 0Sd
		li $s3, 0				# $s3 = 0
		create_deck_num_loop:
			li $t0, 9				# $t0 = 9, innerloop end
			bgt $s3, $t0, end_create_deck_num_loop	# $s3 > 9, end loop
			move $a0, $s0				# $a0 = card list address
			move $a1, $s1				# $s1 = card num
			jal append_card				# jump and append_card
			addi $s1, $s1, 1			# add 1 to (num)Sd
			addi $s3, $s3, 1			# add 1 to inner counter
			j create_deck_num_loop			# jump to top of inner loop
		end_create_deck_num_loop:
		addi $s2, $s2, 1				# add 1 to outer counter
		j create_deck_loop				# jump to top of outer loop
	end_create_deck_loop:
	
	
	create_deck_load:
	move $v0, $s0					# $v0 = card list address
	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $ra, 16($sp)					# load $ra
	addi $sp, $sp, 20				# deallocate 20 bytes of space
   	jr $ra						# return to main address

deal_starting_cards:
	addi $sp, $sp, -28				# allocate 28 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $s5, 20($sp)					# store $s5
	sw $ra, 24($sp)					# store $ra
	move $s0, $a0					# $s0 = board
	move $s1, $a1					# $s1 = deck
	
	# Deal first three rows of cards face down
	lw $s2, 4($s1)					# $s2 = first card address
	li $s4, 0					# $s4 = 0, outer loop counter
	deal_starting_cards_column:
		li $t0, 3					# $t0 = 3, outer loop boundary
		beq $s4, $t0, end_deal_starting_cards_column	# $s4 = 3, end outer loop
		lw $s3, 0($s0)					# $s3 = pointer to first column
		li $s5, 0					# $s5 = 0, inner loop counter
		deal_starting_cards_row:
			li $t0, 9					# t0 = 9, inner loop boundary
			beq $s5, $t0, end_deal_starting_cards_row	# $s5 = 9, end inner loop
			addi $s5, $s5, 1				# add 1 to inner counter
			lw $t1, 0($s2)					# $t1 = card number
			move $a0, $s3					# $a0 = current pointer
			move $a1, $t1					# $a1 = current number from card
			jal append_card					# jump and link append_card
			lw $s2, 4($s2)					# $s2 = next card address	
			li $t2, 4					# $t2 = 4
			mul $t2, $t2, $s5				# $t2 = 4 * index
			move $t3, $s0					# $t3 = board
			add $t3, $t3, $t2				# add $t2 to board
			lw $s3, 0($t3)					# $s3 = pointer to current column
			j deal_starting_cards_row			# jump to top of inner loop	
		end_deal_starting_cards_row:
		addi $s4, $s4, 1					# add 1 to outer counter
		j deal_starting_cards_column				# jump to top of outer loop
	end_deal_starting_cards_column:
	
	# Deal 8 cards face down in fourth row then 1 card face up
	lw $s3, 0($s0)						# $s3 = pointer to first column
	li $s5, 0						# $s5 = 0, inner loop counter
	deal_starting_cards_row_4:
		li $t0, 8					# t0 = 9, inner loop boundary
		beq $s5, $t0, end_deal_starting_cards_row_4	# $s5 = 9, end inner loop
		addi $s5, $s5, 1				# add 1 to inner counter
		lw $t1, 0($s2)					# $t1 = card number
		move $a0, $s3					# $a0 = current pointer
		move $a1, $t1					# $a1 = current number from card
		jal append_card					# jump and link append_card
		lw $s2, 4($s2)					# $s2 = next card address	
		li $t2, 4					# $t2 = 4
		mul $t2, $t2, $s5				# $t2 = 4 * index
		move $t3, $s0					# $t3 = board
		add $t3, $t3, $t2				# add $t2 to board
		lw $s3, 0($t3)					# $s3 = pointer to current column
		j deal_starting_cards_row_4			# jump to top of inner loop	
	end_deal_starting_cards_row_4:
	li $t2, 32						# $t2 = 32
	move $t3, $s0						# $t3 = board
	add $t3, $t3, $t2					# add 32 to board
	lw $t4, 0($s2)						# $t4 = number of current card
	li $t5, 0x00110000					# $t5 = 0x00110000
	add $t4, $t4, $t5					# change 'd' to 'u'
	move $a0, $s3						# $a0 = current pointer
	move $a1, $t4						# $a1 = current card
	jal append_card						# jump and link append_card
	lw $s2, 4($s2)						# $s2 = next card address
	
	# Deal 8 cards face up in fifth row
	lw $s3, 0($s0)						# $s3 = pointer to first column
	li $s5, 0						# $s5 = 0, inner loop counter
	deal_starting_cards_row_5:
		li $t0, 8					# t0 = 8, inner loop boundary
		beq $s5, $t0, end_deal_starting_cards_row_5	# $s5 = 8, end inner loop
		addi $s5, $s5, 1				# add 1 to inner counter
		lw $t1, 0($s2)					# $t1 = card number
		li $t4, 0x00110000				# $t5 = 0x00110000
		add $t1, $t1, $t4				# change 'd' to 'u'
		move $a0, $s3					# $a0 = current pointer
		move $a1, $t1					# $a1 = current number from card
		jal append_card					# jump and link append_card
		lw $s2, 4($s2)					# $s2 = next card address	
		li $t2, 4					# $t2 = 4
		mul $t2, $t2, $s5				# $t2 = 4 * index
		move $t3, $s0					# $t3 = board
		add $t3, $t3, $t2				# add $t2 to board
		lw $s3, 0($t3)					# $s3 = pointer to current column
		j deal_starting_cards_row_5			# jump to top of inner loop	
	end_deal_starting_cards_row_5:
	sb $s2, 4($s1)						# store new head address for deck
	
	deal_starting_cards_load:
   	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# store $s2
	lw $s5, 20($sp)					# store $s3
	lw $ra, 24($sp)					# load $ra
	addi $sp, $sp, 28				# deallocate 28 bytes of space
   	jr $ra						# return to main address
   	
get_card:
	addi $sp, $sp, -8				# allocate 8 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	move $s0, $a0					# $s0 = card list
	move $s1, $a1					# $s1 = index
	
	lw $t0, 0($s0)					# $t0 = size
	bge $s1, $t0, get_card_neg_1			# $s1 >= size, get_card_neg_1
	blt $s1, $0, get_card_neg_1			# $s1 < 0, get_card_neg_1
	
	lw $t0, 4($s0)					# $t0 = first card
	li $t1, 0					# $t1 = 0, counter
	get_card_loop:
		beq $t1, $s1, end_get_card_loop		# $t1 = index, end loop
		lw $t0, 4($t0)				# $t0 = next card
		addi $t1, $t1, 1			# add 1 to counter
		j get_card_loop				# jump to top of loop
	end_get_card_loop:
	lw $t2, 0($t0)					# $t2 = card number
	move $v1, $t2					# $v1 = card number
	srl $t3, $t2, 16				# shift right 16
	li $t4, 'u'					# $t4 = 'u'
	beq $t3, $t4, get_card_u			# $t3 = 'u', get_card_u
	
	get_card_d:
		li $v0, 1				# $v0 = 1
		j get_card_load				# jump to get_card_load
	
	get_card_u:
		li $v0, 2				# $v0 = 2
		j get_card_load				# jump to get_card_load
	
	get_card_neg_1:
		li $v0, -1				# $v0 = -1
		li $v1, -1				# $v1 = -1
	
	get_card_load:
	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	addi $sp, $sp, 8				# allocate 8 bytes of space				
    	jr $ra						# return to main address

check_move:
	addi $sp, $sp, -28				# allocate 28 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $s5, 20($sp)					# store $s5
	sw $ra, 24($sp)					# store $ra
	move $s0, $a0					# $s0 = board
	move $s1, $a1					# $s1 = deck
	move $s2 $a2					# $s2 = move
	
	###### Check byte 3 first for deal move ######
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 24				# $t0 = 3rd byte
	li $t1, 1					# $t1 = 1
	beq $t0, $t1, check_for_deal_move		# $t0 = 1, check_for_deal_move
	bnez $t0, check_move_neg_1			# $t0 != 0, check_move_neg_1
	
	###### Check bytes 2 then 0 for validity (recipient and donor columns) ######
	# Byte 2 (Recipient column)
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 16				# $t0 = move shifted right 2 bytes
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t0, $t0, $t1				# $t0 and 0x000000FF
	li $t2, 8					# $t2 = 8
	bgt $t0, $t2, check_move_neg_3			# $t0 > 8, check_move_neg_3
	bltz $t0, check_move_neg_3			# $t0 < 0, check_move_neg_3
	
	# Byte 0 (Donor column)
	move $t0, $s2					# $t0 = move
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t0, $t0, $t1				# $t0 and 0x000000FF
	li $t2, 8					# $t2 = 8
	bgt $t0, $t2, check_move_neg_3			# $t0 > 8, check_move_neg_3
	bltz $t0, check_move_neg_3			# $t0 < 0, check_move_neg_3
	
	###### Check byte 1 for validity (Donor row) ######
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 8					# $t0 = move shifted right 1 byte
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t0, $t0, $t1				# $t0 and 0x000000FF
	
	move $t2, $s2					# $t2 = move
	andi $t2, $t2, 0x000000FF			# $t0 and 0x000000FF
	li $t3, 4					# $t3 = 4
	mul $t3, $t3, $t2				# $t3 = 4 * column index
	move $t4, $s0					# $t4 = board
	add $t4, $t4, $t3				# add $t3 to board
	lw $t5, 0($t4)					# $t5 = address
	lw $t5, 0($t5)					# $t5 = size
	bge $t0, $t5, check_move_neg_4			# $t0 >= num rows , check_move_neg_4
	bltz $t0, check_move_neg_4			# $t0 < 0, check_move_neg_4
	
	###### Check if bytes 2 and 0 are the same ######
	# Byte 2 (Recipient column)
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 16				# $t0 = move shifted right 2 bytes
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t0, $t0, $t1				# $t0 and 0x000000FF
	
	# Byte 0 (Donor Column)
	move $t2, $s2					# $t2 = move
	and $t2, $t2, $t1				# $t2 and 0x000000FF
	
	# Check if both are equal
	beq $t0, $t2, check_move_neg_5			# $t0 = $t2, check_move_neg_5
	
	###### Check if the card at the donor row/column is face down ######
	# Get the card list for the column
	move $t0, $s2					# $t0 = move
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	li $t3, 4					# $t2 = 4
	mul $t3, $t3, $t2				# $t3 = 4 * column index
	move $t4, $s0					# $t4 = board
	add $t4, $t4, $t3				# add 4 * column index to board
	lw $t5, 0($t4)					# $t5 = address of card list
	
	# Get the row index
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 8					# shift right 1 byte
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	
	# Set up for get_card
	move $a0, $t5					# $a0 = card list
	move $a1, $t2					# $a1 = row
	jal get_card					# jump and link get_card
	
	# Get 'd' or 'u' from received card
	move $t0, $v1					# $t0 = resulting card
	srl $t0, $t0, 16				# shift right 2 bytes
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	li $t3, 'd'					# $t3 = 'd'
	beq $t2, $t3, check_move_neg_6			# $t2 = 'd', check_move_neg_6
	
	###### Check if multiple cards being moved is in descending order ######
	# Get the size of the donor column
	move $t0, $s2					# $t0 = move
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	li $t3, 4					# $t2 = 4
	mul $t3, $t3, $t2				# $t3 = 4 * column index
	move $t4, $s0					# $t4 = board
	add $t4, $t4, $t3				# add 4 * column index to board
	lw $t5, 0($t4)					# $t5 = address of card list
	lw $t6, 0($t5)					# $t6 = size of array list
	
	# Get the donor row index
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 8					# shift right 1 byte
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	
	# Check each card in the loop to see if it is in descending order
	move $s3, $t5					# $s3 = card list address
	lw $s3, 4($s3)					# $s3 = head address
	li $t0, 0					# $t0 = 0, counter			
	get_to_row_loop:
		beq $t0, $t2, end_get_to_row_loop	# counter = index, end loop
		lw $s3, 4($s3)				# $s3 = next address
		addi $t0, $t0, 1			# add 1 to counter
		j get_to_row_loop			# jump to top of loop
	end_get_to_row_loop:
	
	lw $s4, 0($s3)					# $s4 = current card
	lw $s3, 4($s3)					# $s3 = next address
	descending_order_loop:
		beq $s3, $0, end_descending_order_loop	# $s3 = $0, end loop
		lw $s5, 0($s3)				# $s5 = new card
		addi $s4, $s4, -1			# subtract 1 from previous card
		bne $s5, $s4, check_move_neg_7		# new card != previous card - 1, check_move_neg_7
		move $s4, $s5				# $s4 = new card
		lw $s3, 4($s3)				# $s3 = next address
		j descending_order_loop			# jump to top of loop
	end_descending_order_loop:
	
	###### Recipient column is empty and donor card is one less than top card in recipient column ######
	# Get the size of the column
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 16				# shift right 2 bytes
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	li $t3, 4					# $t2 = 4
	mul $t3, $t3, $t2				# $t3 = 4 * column index
	move $t4, $s0					# $t4 = board
	add $t4, $t4, $t3				# add 4 * column index to board
	lw $t5, 0($t4)					# $t5 = address of card list
	lw $t6, 0($t5)					# $t6 = size of array list
	beqz $t6, check_move_return_2			# $t6 = 0, check_move_return_2
	
	# Get recipient column tail card
	addi $t6, $t6, -1				# subtract 1 from size to get tail index
	move $a0, $t5					# $a0 = address of card list
	move $a1, $t6					# $a1 = index
	jal get_card					# jump and link get_card
	move $s3, $v1					# $s3 = recipient column tail card
	
	# Get the address of the donor column
	move $t0, $s2					# $t0 = move
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	li $t3, 4					# $t2 = 4
	mul $t3, $t3, $t2				# $t3 = 4 * column index
	move $t4, $s0					# $t4 = board
	add $t4, $t4, $t3				# add 4 * column index to board
	lw $t5, 0($t4)					# $t5 = address of card list
	
	# Get the donor row index
	move $t0, $s2					# $t0 = move
	srl $t0, $t0, 8					# shift right 1 byte
	and $t2, $t0, $t1				# $t0 and 0x000000FF
	
	# Get donor column bottommost card
	move $a0, $t5					# $a0 = address of card list
	move $a1, $t2					# $a1 = index
	jal get_card					# jump and link get_card
	move $s4, $v1					# $s3 = recipient column tail card
	
	addi $s3, $s3, -1				# subtract 1 from top recipient column card
	bne $s3, $s4, check_move_neg_8			# $s3 != $s4, check_move_neg_8 
	j check_move_return_3				# jump to check_move_return_3
	
	####### Check if deal is valid ######
	check_for_deal_move:
		move $t0, $s2				# $t0 = move
		li $t1, 0x00FFFFFF			# $t1 = 0x00FFFFFF
		and $t0, $t0, $t1			# $t0 and 0x00FFFFFF
		beq $t0, $0, is_deal			# $t0 = 0, is_deal
		j check_move_neg_1			# jump to check_move_neg_1
	
	####### Move is Deal, check if board is valid ######
	is_deal:	
		li $t0, 0				# $t0 = counter
		is_deal_loop:
			li $t1, 9			# $t1 = 9, counter boundary
			beq $t0, $t1, end_is_deal_loop	# $t0 = 9, end loop
			move $t2, $s0			# $t2 = board
			li $t3, 4			# $t3 = 4
			mul $t4, $t0, $t3		# $t4 = index * 4
			add $t2, $t2, $t4		# $t2 = $t2 + (index*4)
			lw $t5, 0($t2)			# $t5 = address of current pointer
			lw $t5, 0($t5)			# $t5 = size of current pointer
			beq $t5, $0, check_move_neg_2	# $t5 = 0, check_move_neg_2
			addi $t0, $t0, 1		# add 1 to counter
			j is_deal_loop			# jump to top of loop
		end_is_deal_loop:
		
		is_deck_empty:
			lw $t0, 0($s1)			# $t0 = size of deck
			beq $t0, $0, check_move_neg_2	# $t0 = 0, check_move_neg_2
		
		j check_move_return_1			# jump to check_move_return_1
	
	####### Deal is invalid or 3rd byte is not 0 ######
	check_move_neg_1:
		li $v0, -1				# $v0 = -1
		j check_move_load			# jump to check_move_load
	
	###### Deal is valid, but deck is empty or a column is ######	
	check_move_neg_2:
		li $v0, -2				# $v0 = -2
		j check_move_load			# jump to check_move_load
	
	###### Donor/Recipient column is invalid ######
	check_move_neg_3:
		li $v0, -3				# $v0 = -3
		j check_move_load			# jump to check_move_load
		
	###### Donor row is invalid ######
	check_move_neg_4:
		li $v0, -4				# $v0 = -4
		j check_move_load			# jump to check_move_load
		
	###### Donor/Recipient columns are the same ######
	check_move_neg_5:
		li $v0, -5				# $v0 = -5
		j check_move_load			# jump to check_move_load
		
	###### Card at the donor row/column is face down ######
	check_move_neg_6:
		li $v0, -6				# $v0 = -6
		j check_move_load			# jump to check_move_load
		
	###### Cards being moved are not in descending order ######
	check_move_neg_7:
		li $v0, -7				# $v0 = -7
		j check_move_load			# jump to check_move_load
	
	###### Recipient column is not empty and donor card is not one less than top card ######
	check_move_neg_8:
		li $v0, -8				# $v0 = -8
		j check_move_load			# jump to check_move_load
	
	###### Deal is valid ######
	check_move_return_1:
		li $v0, 1				# $v0 = 1
		j check_move_load			# jump to check_move_load
	
	###### Valid move and recipient column is empty ######
	check_move_return_2:
		li $v0, 2				# $v0 = 2
		j check_move_load			# jump to check_move_load
	
	###### Valid move and recipient column is not empty ######
	check_move_return_3:
		li $v0, 3				# $v0 = 3
		j check_move_load			# jump to check_move_load
	
	check_move_load:
	li $v1, 0					# $v1 = 0
	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# load $s4
	lw $s5, 20($sp)					# load $s5
	lw $ra, 24($sp)					# load $ra
	addi $sp, $sp, 28				# allocate 28 bytes of space
    	jr $ra						# return to main address

clear_full_straight:
	addi $sp, $sp, -28				# allocate 28 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $s5, 20($sp)					# store $s5
	sw $ra, 24($sp)					# store $ra
	move $s0, $a0					# $s0 = board
	move $s1, $a1					# $s1 = col num
	
	###### Check is column number is valid ######
	li $t0, 8					# $t0 = 8
	bgt $s1, $t0, clear_straight_neg_1		# $s1 > 8, clear_straight_neg_1
	bltz $s1, clear_straight_neg_1			# $s1 < 0, clear_straight_neg_1
	
	###### Check if size of board[col_num] < 10 ######
	li $t0, 4					# $t0 = 4
	mul $t0, $t0, $s1				# $t0 = 4 * column index
	move $t1, $s0					# $t1 = board
	add $t1, $t1, $t0				# add 4 * column index to board
	lw $t2, 0($t1)					# $t2 = address of card list
	move $s2, $t2					# $s2 = address of card list
	lw $t3, 0($t2)					# $t3 = size of card list
	li $t4, 10					# $t4 = 10
	blt $t3, $t4, clear_straight_neg_2		# size of column < 10, clear_straight_neg_2
	
	###### Check if no full straight can be cleared ######
	addi $t3, $t3, -1				# subtract 1 from size to get tail index
	move $a0, $t2					# $a0 = address of card list
	move $a1, $t3					# $a1 = tail index
	jal get_card					# jump and link get_card
	andi $t0, $v1, 15				# $t0 = $v1 and 0x0000000F
	bne $t0, $0, clear_straight_neg_3		# $t0 != 0, clear_straight_neg_3
	
	move $s5, $s2					# $s5 = address of card list
	lw $s2, 4($s2)					# $s2 = head address
	lw $s3, 0($s2)					# $s3 = head card
	move $t0, $s3					# $t0 = head card
	li $t1, 0x00755339				# $t1 = 9
	find_9_loop:
		beq $t0, $t1, end_find_9_loop		# $t0 = 9, end loop
		lw $s2, 4($s2)				# $s2 = next address
		beq $s2, $0, clear_straight_neg_3	# $s2 = 0, clear_straight_neg_3
		lw $s3, 0($s2)				# $s3 = next card
		move $t0, $s3				# $t0 = $s3
		li $t1, 0x00755339			# $t1 = 9
		j find_9_loop				# jump to top of loop
	end_find_9_loop:
	srl $t0, $s3, 16				# shift right 2 bytes
	li $t1, 0x000000FF				# $t1 = 0x000000FF
	and $t0, $t0, $t1				# $t0 and 0x000000FF
	li $t1, 'u'					# $t1 = 'u'
	bne $t0, $t1, clear_straight_neg_3		# $t0 != 'u', clear_straight_neg_3
	
	lw $s3, 0($s2)					# $s3 = current card
	lw $s2, 4($s2)					# $s2 = next address
	andi $t0, $s3, 15				# $s3 and 0x0000000F
	check_descending_loop:
		beq $t0, $0, end_check_descending_loop	# $t0 = $0, end loop
		lw $s4, 0($s2)				# $s4 = next card
		addi $s3, $s3, -1			# subtract 1 from previous card
		bne $s3, $s4, clear_straight_neg_3	# $s3 != $s4, clear_straight_neg_3
		lw $s2, 4($s2)				# $s2 = next address
		andi $t0, $s3, 15			# $t0 and 0x0000000F
		j check_descending_loop			# jump to top of loop
	end_check_descending_loop:
	bnez $s2, clear_straight_neg_3			# $s2 != 0, clear_straight_neg_3
	
	###### Full straight is cleared, check which output is correct ######
	lw $t0, 0($s5)					# $t0 = size of array
	li $t1, 10					# $t1 = 10
	sub $t0, $t0, $t1				# $t0 = $t0 - 10
	beqz $t0, clear_straight_return_2		# $t0 = 0, clear_straight_return_2
	j clear_straight_return_1			# jump to clear_straight_return_1
	
	
	###### Column number is invalid ######
	clear_straight_neg_1:
		li $v0, -1				# $v0 = -1
		j clear_straight_load			# jump to clear_straight_load
		
	###### Board[col_num] contains fewer than ten cards ######
	clear_straight_neg_2:
		li $v0, -2				# $v0 = -2
		j clear_straight_load			# jump to clear_straight_load
		
	###### No straight can be removed ######
	clear_straight_neg_3:
		li $v0, -3				# $v0 = -3
		j clear_straight_load			# jump to clear_straight_load
		
	###### Straight is removed, list is not empty ######
	clear_straight_return_1:
		lw $t0, 0($s5)				# $t0 = size of list
		addi $t0, $t0, -10			# subtract 10 from size
		sw $t0, 0($s5)				# store new size
		addi $t0, $t0, -1			# $t0 = index of new tail
		
		li $t1, 0					# $t1 = 0, counter
		lw $s5, 4($s5)					# $s5 = new address
		find_new_tail_loop:
			beq $t1, $t0, end_find_new_tail_loop	# $t1 = index, end loop
			lw $s5, 4($s5)				# $s5 = new address
			addi $t1, $t1, 1			# add 1 to counter
			j find_new_tail_loop			# jump to top of loop
		end_find_new_tail_loop:
		sw $0, 4($s5)					# next address = $0
		
		lw $t0, 0($s5)					# $t0 = card
		srl $t1, $t0, 16				# shift right 2 bytes
		li $t2, 0x000000FF				# $t2 = 0x000000FF
		and $t1, $t1, $t2				# $t1 and 0x000000FF
		li $t2, 'u'					# $t2 = 'u'
		beq $t1, $t2, clear_return_1_end		# $t1 = 'u', clear_return_1_end	
		li $t1, 0x00110000				# $t1 = 0x00110000			
		add $t0, $t0, $t1				# change 'd' to 'u'	
		sw $t0, 0($s5)					# store changed card	
		
		clear_return_1_end:
		li $v0, 1				# $v0 = 1
		j clear_straight_load			# jump to clear_straight_load
		
	###### Straight is removed, list is empty ######
	clear_straight_return_2:
		sw $0, 0($s5)				# size is set to 0
		sw $0, 4($s5)				# head is set to 0
		li $v0, 2				# $v0 = 2
		j clear_straight_load			# jump to clear_straight_load
	
	clear_straight_load:
	li $v1, 0					# $v1 = 0
    	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# load $s4
	lw $s5, 20($sp)					# load $s5
	lw $ra, 24($sp)					# load $ra
	addi $sp, $sp, 28				# allocate 28 bytes of space
    	jr $ra						# return to main address

deal_move:
	addi $sp, $sp, -24				# allocate 24 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $ra, 20($sp)					# store $ra
	move $s0, $a0					# $s0 = board
	move $s1, $a1					# $s1 = deck
	
	lw $s2, 4($s1)					# $s2 = address of first card in the deck
	li $s3, 0					# $s3 = 0, counter of loop
	move $s4, $s0					# $s4 = board
	deal_move_loop:
		li $t0, 9				# $t0 = 9
		beq $s3, $t0, end_deal_move_loop	# $s3 = 9, end loop
		lw $t1, 0($s2)				# $t1 = card number
		li $t2, 0x00110000			# $t2 = 0x00110000
		add $t1, $t1, $t2			# adds 0x00110000 to card number
		
		lw $t3, 0($s4)				# $t3 = card list address
		move $a0, $t3				# $a0 = card list
		move $a1, $t1				# $a1 = card number
		jal append_card				# jump and link append_card
		
		lw $s2, 4($s2)				# $s2 = next address
		addi $s3, $s3, 1			# add 1 to counter
		addi $s4, $s4, 4			# add 4 to board
		j deal_move_loop			# jump to top of loop
	end_deal_move_loop: 
	sw $s2, 4($s1)					# store new head for deck
	lw $t0, 0($s1)					# $t0 = deck size
	addi $t0, $t0, -9				# subtract 9 from size
	sw $t0, 0($s1)					# store new size
	
	deal_move_load:
    	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# load $s4
	lw $ra, 20($sp)					# load $ra
	addi $sp, $sp, 24				# allocate 24 bytes of space
    	jr $ra						# return to main address

move_card:
	addi $sp, $sp, -24				# allocate 24 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $ra, 20($sp)					# store $ra
	move $s0, $a0					# $s0 = board
	move $s1, $a1					# $s1 = deck
	move $s2, $a2					# $s2 = move
	
	jal check_move					# jump and link check_move
	bltz $v0, move_card_neg_1			# $v0 < 0, move_card_neg_1
	li $t0, 1					# $t0 = 1
	beq $v0, $t0, move_card_deal			# $v0 = 1, move_card_deal
	j move_card_to_column				# jump to move_card_to_column

	move_card_deal:
		move $a0, $s0				# $a0 = board
		move $a1, $s1				# $a1 = deck
		jal deal_move				# jump and link deal_move
		
		li $s3, 0					# $s3 = 0, counter
		move_card_deal_loop:
			li $t0, 9				# $t0 = 9
			beq $s3, $t0, end_move_card_deal_loop	# $s3 = 9, end loop
			move $a0, $s0				# $a0 = board
			move $a1, $s3				# $a1 = col num
			jal clear_full_straight			# jump and link clear_full_straight
			addi $s3, $s3, 1			# add 1 to counter
			j move_card_deal_loop			# jump to top of loop
		end_move_card_deal_loop:
		j move_card_return_1				# jump to move_card_return_1
		
	move_card_to_column:
		# Get the donor row
		move $t0, $s2					# $t0 = move
		srl $t0, $t0, 8					# shift right 1 byte
		li $t1, 0x000000FF				# $t1 = 0x000000FF
		and $t0, $t0, $t1				# $t0 and 0x000000FF
		
		# Get the donor column size and address				
		move $t2, $s2					# $t2 = move
		and $t2, $t2, $t1				# $t2 and 0x000000FF
		move $t3, $s0					# $t3 = board
		li $t4, 4					# $t4 = 4
		mul $t4, $t2, $t4				# $t4 = index * 4
		add $t3, $t3, $t4				# add $t3 to board
		lw $t3, 0($t3)					# $t3 = board
		lw $t5, 0($t3)					# $t5 = size
		sub $t6, $t5, $t0				# $t6 = size - index
		move $s4, $t6					# $s4 = number of cards being transferred
		sub $t7, $t5, $t6				# $t7 = new size
		sw $t7, 0($t3)					# store new size
		move $s3, $t3					# $s3 = card list
		beq $t7, $0, donor_size_0			# $t7 = 0, donor_size_0
		
		lw $s3, 4($s3)					# $s3 = head address				
		li $t8, 1					# $t8 = 0, counter for loop
		move_card_loop:
			beq $t8, $t0, end_move_card_loop	# $t8 = index, end loop
			lw $s3, 4($s3)				# $s3 = next address
			addi $t8, $t8, 1			# add 1 to counter
			j move_card_loop			# jump to top of loop
		end_move_card_loop:
		move $t3, $s3					# $t3 = current address address
		lw $s3, 4($s3)					# $s3 = next address
		sw $0, 4($t3)					# store $0 at current address
		j check_new_tail				# jump to check_new_tail
		
		donor_size_0:
			lw $t9, 4($s3)				# $t9 = head address
			sw $0, 4($s3)				# store null terminator at head
			move $s3, $t9				# $s3 = head address
			j transfer_card				# jump to transfer_card
		
		# Check if new tail is face up or face down
		check_new_tail:
		lw $t0, 0($t3)					# $t0 = card at current address
		move $t1, $t0					# $t1 = card
		srl $t1, $t1, 16				# shift right 2 bytes
		li $t2, 0x000000FF				# $t2 = 0x000000FF
		and $t1, $t1, $t2				# $t1 and 0x000000FF
		li $t2, 'u'					# $t2 = 'u'
		beq $t1, $t2, transfer_card			# $t1 = 'u', transfer_card
		li $t2, 0x00110000				# $t2 = 0x00110000
		add $t0, $t0, $t2				# add $t2 to current card
		sw $t0, 0($t3)					# store card at current address
		
		transfer_card:
		# Get recipient column
		move $t0, $s2					# $t0 = move
		srl $t0, $t0, 16				# shift right 2 bytes
		li $t1, 0x000000FF				# $t1 = 0x000000FF
		and $t0, $t0, $t1				# $t0 and 0x000000FF
		move $t9, $t0					# $t9 = recipient column
		li $t2, 4					# $t2 = 4
		mul $t0, $t0, $t2				# $t0 = index * 4
		move $t3, $s0					# $t3 = board
		add $t3, $t3, $t0				# add $t0 to board
		lw $t3, 0($t3)					# $t3 = card list
		lw $t4, 0($t3)					# $t4 = size
		beq $t4, $0, empty_column			# size = 0, empty_column
		add $t4, $t4, $s4				# add number of cards transferred to size
		sw $t4, 0($t3)					# store new size
		
		lw $t3, 4($t3)					# $t3 = next address
		move $t5, $t3					# $t5 = next address
		transfer_card_loop:
			beq $t5, $0, end_transfer_card_loop	# $t3 = $0, end loop 
			move $t3, $t5				# $t3 = current address
			lw $t5, 4($t3)				# $t5 = next address
			j transfer_card_loop			# jump to top of loop
		end_transfer_card_loop:
		sw $s3, 4($t3)					# store cards at new address
		j move_card_return_1				# jump to move_card_return_1
		
		empty_column:
			sw $s4, 0($t3)				# store new size in column
			sw $s3, 4($t3)				# store new card(s) starting at the head
		
	move_card_return_1:
		move $a0, $s0				# $a0 = board
		move $a1, $t9				# $a1 = column number
		jal clear_full_straight			# jump and link clear_full_straight
		
		li $v0, 1				# $v0 = 1
		j move_card_load			# jump to move_card_load
	
	move_card_neg_1:
		li $v0, -1				# $v0 = -1
	
	move_card_load:
    	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# load $s4
	lw $ra, 20($sp)					# load $ra
	addi $sp, $sp, 24				# allocate 24 bytes of space
    	jr $ra						# return to main address

load_game:
	addi $sp, $sp, -36				# allocate 32 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $s5, 20($sp)					# store $s5
	sw $s6, 24($sp)					# store $s6
	sw $s7, 28($sp)					# store $s7
	sw $ra, 32($sp)					# store $ra
	move $s0, $a0					# $s0 = filename
	move $s1, $a1					# $s1 = board
	move $s2, $a2					# $s2 = deck
	move $s3, $a3					# $s3 = moves
	
	# Read to a file
	li $v0, 13					# gets ready to open file
	li $a1, 0					# flags = 0
	move $a0, $s0					# $a0 = filename
	syscall						# open file	
	move $s4, $v0					# $s2 = descriptor
		
	li $t0, -1					# $t0 = -1
	beq $s4, $t0, load_neg_1			# descriptor = -1, set $v1 to -1
	
	# Get the cards for the deck
	move $a0, $s2					# $a0 = deck
	jal init_list					# jump and link init_list
	li $s5, 0					# $s5 = 0, counter
	get_deck_loop:
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
			
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t0, '\n'				# $t0 = '\n'
		beq $a0, $t0, end_get_deck_loop		# $a0 = '\n', end_get_deck_loop
		
		move $t2, $a0				# $s4 = number read from file
		li $t0, 0x00005300			# $t0 = 'S' in byte 1
		add $t2, $t2, $t0			# add 'S' in byte 1 to $s4
		
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
			
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t0, '\n'				# $t0 = '\n'
		beq $a0, $t0, end_get_deck_loop		# $a0 = '\n', end_get_deck_loop
		
		li $t0, 0x00010000			# $t0 = 0x00010000
		mul $t1, $t0, $a0			# $t1 = $a0 * 0x00010000
		add $t2, $t2, $t1			# $t2 = card
		
		move $a0, $s2				# $a0 = deck
		move $a1, $t2				# $a1 = card
		jal append_card				# jump and link append_card
		
		j get_deck_loop				# jump to top of loop
	end_get_deck_loop:
	add $sp, $sp, $s5				# deallocate space
	
	# Get the moves and put them in the list
	li $s5, 0					# $s5 = 0, counter
	move $s6, $s3					# $s6 = moves
	li $s7, 0					# $s7 = 0, counter for number of moves
	add_moves_loop:
		# First byte
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
			
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t1, '\n'				# $t1 = '\n'
		beq $a0, $t1, end_add_moves_loop	# $a0 = '\n', end_add_moves_loop
		addi $a0, $a0, -48			# subtract 48 from $a0
		add $t0, $0, $a0			# add to $t0
		
		# Second byte
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
			
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t1, '\n'				# $t1 = '\n'
		beq $a0, $t1, end_add_moves_loop	# $a0 = '\n', end_add_moves_loop
		addi $a0, $a0, -48			# subtract 48 from $a0
		li $t1, 0x00000100			# $t1 = 0x00010000
		mul $t1, $a0, $t1			# $t1 = number * 0x00010000
		add $t0, $t0, $t1			# add to $t0
		
		# Third byte
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
			
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t1, '\n'				# $t1 = '\n'
		beq $a0, $t1, end_add_moves_loop	# $a0 = '\n', end_add_moves_loop
		addi $a0, $a0, -48			# subtract 48 from $a0
		li $t1, 0x00010000			# $t1 = 0x00010000
		mul $t1, $a0, $t1			# $t1 = number * 0x00010000
		add $t0, $t0, $t1			# add to $t0
		
		# Fourth byte
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
			
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t1, '\n'				# $t1 = '\n'
		beq $a0, $t1, end_add_moves_loop	# $a0 = '\n', end_add_moves_loop
		
		addi $a0, $a0, -48			# subtract 48 from $a0
		li $t1, 0x01000000			# $t1 = 0x01000000
		mul $t1, $a0, $t1			# $t0 = number * 0x01000000
		add $t0, $t0, $t1			# add $t1 to $t0			
		
		sw $t0, 0($s6)				# store move in moves list
		addi $s6, $s6, 4			# add 4 to get to next position
		addi $s7, $s7, 1			# add 1 to counter for moves
		
		# Space
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s5, $s5, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
		lb $a0, 0($sp)				# $a0 = current byte on stack
		li $t1, '\n'				# $t1 = '\n'
		beq $a0, $t1, end_add_moves_loop	# $a0 = '\n', end_add_moves_loop
		
		j add_moves_loop			# jump to top of loop
	end_add_moves_loop:			
	add $sp, $sp, $s5				# deallocate space
	sw $0, 0($s6)					# store null terminator
	
	# Initialize the board and put cards in approprate columns
	move $s6, $s1					# $s6 = board
	li $s5, 0					# $s5 = 0, counter
	init_board_loop:
		li $t0, 9				# $t0 = 9
		beq $s5, $t0, end_init_board_loop	# $s5 = 9, end loop
		lw $t1, 0($s6)				# $t1 = card list address
		move $a0, $t1				# $a0 = card list address
		jal init_list				# jump and link init_list
		addi $s6, $s6, 4			# add 4 to $s6
		addi $s5, $s5, 1			# add 1 to counter
		j init_board_loop			# jump to top of loop
	end_init_board_loop:
	
	li $s0, 0						# $s0 = 0 counter for stack
	add_cards_loop:
		li $s5, 0					# $s5 = 0, counter
		move $s6, $s1					# $s6 = board
		insert_cards_loop:
			card_first_byte:
			li $t0, 9				# $t0 = 9
			beq $s5, $t0, end_insert_cards_loop	# $s5 = 9, end loop
			
			addi $sp, $sp, -4			# allocate 1 byte of space
			addi $s0, $s0, 4			# add 1 to counter
			li $v0, 14				# get ready to read from file
			move $a1, $sp				# $a1 = stack
			li $a2, 1				# $a2 = 1 for buffer
			move $a0, $s4				# $a0 = descriptor
			syscall 				# read from file
			
			lb $a0, 0($sp)				# $a0 = current byte on stack
			li $t1, '\n'				# $t1 = '\n'
			beq $a0, $t1, add_cards_jump		# $a0 = '\n', end_add_moves_loop
			li $t0, 32				# $t0 = 32 (space)
			beq $a0, $t0, card_second_byte		# $a0 = space, card_second_byte
			blez $v0, end_add_cards_loop		# $v0 <= 0, end full loop	
			
			move $t2, $a0				# $s4 = number read from file
			li $t0, 0x00005300			# $t0 = 'S' in byte 1
			add $t2, $t2, $t0			# add 'S' in byte 1 to $s4
			
			card_second_byte:
			addi $sp, $sp, -4			# allocate 1 byte of space
			addi $s0, $s0, 4			# add 1 to counter
			li $v0, 14				# get ready to read from file
			move $a1, $sp				# $a1 = stack
			li $a2, 1				# $a2 = 1 for buffer
			move $a0, $s4				# $a0 = descriptor
			syscall 				# read from file
				
			lb $a0, 0($sp)				# $a0 = current byte on stack
			li $t1, '\n'				# $t1 = '\n'
			beq $a0, $t1, add_cards_jump		# $a0 = '\n', end_add_moves_loop
			li $t0, 32				# $t0 = 32 (space)
			beq $a0, $t0, insert_card_setup		# $a0 = space, insert_card_setup
			blez $v0, end_add_cards_loop		# $v0 <= 0, end full loop
			
			li $t0, 0x00010000			# $t0 = 0x00010000
			mul $t1, $t0, $a0			# $t1 = $a0 * 0x00010000
			add $t2, $t2, $t1			# $t2 = card
		
			lw $t3, 0($s6)				# $t1 = card list address
			
			move $a0, $t3				# $a0 = card list
			move $a1, $t2				# $a1 = card
			jal append_card				# jump and link append_card
			
			insert_card_setup:
				addi $s6, $s6, 4			# add 4 to $s6
				addi $s5, $s5, 1			# add 1 to counter
				j insert_cards_loop			# jump to top of inner loop	
		end_insert_cards_loop:
		# new line
		addi $sp, $sp, -4			# allocate 1 byte of space
		addi $s0, $s0, 4			# add 1 to counter
		li $v0, 14				# get ready to read from file
		move $a1, $sp				# $a1 = stack
		li $a2, 1				# $a2 = 1 for buffer
		move $a0, $s4				# $a0 = descriptor
		syscall 				# read from file
		lb $a0, 0($sp)				# $a0 = current byte on stack
		
		add_cards_jump:
		j add_cards_loop			# jump to top of outer loop
	end_add_cards_loop:
	add $sp, $sp, $s0				# deallocate space on stack
	
	li $s5, 0					# $s5 = 0, counter
	move $s6, $s0					# $s6 = board
	
	li $v0, 1					# $v0 = 1
	move $v1, $s7					# $v1 = number of moves
	j load_game_load				# jump to load_game_load
	
	load_neg_1:
		li $v0, -1				# $v0 = -1
		li $v1, -1				# $v1 = -1
	
	load_game_load:
    	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# load $s4
	lw $s5, 20($sp)					# load $s5
	lw $s6, 24($sp)					# load $s6
	lw $s7, 28($sp)					# load $s7
	lw $ra, 32($sp)					# load $ra
	addi $sp, $sp, 36				# allocate 36 bytes of space
    	jr $ra						# return to main address

simulate_game:
	addi $sp, $sp, -36				# allocate 36 bytes of space
	sw $s0, 0($sp)					# store $s0
	sw $s1, 4($sp)					# store $s1
	sw $s2, 8($sp)					# store $s2
	sw $s3, 12($sp)					# store $s3
	sw $s4, 16($sp)					# store $s4
	sw $s5, 20($sp)					# store $s5
	sw $s6, 24($sp)					# store $s6
	sw $s7, 28($sp)					# store $s7
	sw $ra, 32($sp)					# store $ra
	move $s0, $a0					# $s0 = filename
	move $s1, $a1					# $s1 = board
	move $s2, $a2					# $s2 = deck
	move $s3, $a3					# $s3 = moves
	
	jal load_game					# jump and link load_game
	li $t0, -1					# $t0 = -1
	beq $v0, $t0, simulate_game_neg_1		# $v0 = -1, simulate_game_neg_1
	move $s6, $v1					# $s6 = number of moves total
	
	li $s4, 0					# $s4 = 0, number of EXECUTED moves
	move $s5, $s3					# $s5 = moves
	li $s7, 0					# $s7 = 0, counter
	simulate_game_loop:
		  beq $s7, $s6, end_simulate_game_loop	# $s7 = total moves, end loop
		  lw $t0, 0($s5)			# $t0 = current move
		  move $a0, $s1				# $a0 = board
		  move $a1, $s2				# $a1 = deck
		  move $a2, $t0				# $a2 = current move
		  jal move_card				# jump and link move_card
		  bltz $v0, simulate_game_loop_setup	# $v0 <= 0, simulate_game_loop_setup
		  addi $s4, $s4, 1			# add 1 to executed move counter
		  
		  move $t1, $s1				# $t1 = board
		  li $t2, 0				# $t2 = 0, counter
		  check_board_loop:
		  	li $t3, 9				# $t3 = 9
		  	beq $t2, $t3, end_check_board_loop	# $t2 = 9, end loop
		  	lw $t4, 0($t1)				# $t4 = address
		  	lw $t4, 0($t4)				# $t4 = size
		  	bne $t4, $0, simulate_game_loop_setup	# $t4 != 0, simulate_game_loop_setup
		  	addi $t1, $t1, 4			# add 4 to board
		  	addi $t2, $t2, 1			# add 1 to counter
		  	j check_board_loop			# jump to top of loop
		  end_check_board_loop:
		  
		  lw $t0, 0($s2)				# $t0 = deck size
		  beq $t0, $0, simulate_game_return_1		# $t0 = 0, simulate_game_return_1
		  
		  simulate_game_loop_setup:
		  	addi $s7, $s7, 1		# add 1 to counter
		  	addi $s5, $s5, 4		# add 4 to moves
		  	j simulate_game_loop		# jump to top of loop
	end_simulate_game_loop:
	
	move $v0, $s4					# $v0 = number of moves
	li $v1, -2					# $v1 = -2
	j simulate_game_load				# jump to simulate_game_load
	
	simulate_game_return_1:
		move $v0, $s4				# $v0 = number of moves
		li $v1, 1				# $v1 = 1
		j simulate_game_load			# jump to simulate_game_load
	
	simulate_game_neg_1:
		li $v0, -1				# $v0 = -1
		li $v1, -1				# $v1 = -1
	
	simulate_game_load:
    	lw $s0, 0($sp)					# load $s0
	lw $s1, 4($sp)					# load $s1
	lw $s2, 8($sp)					# load $s2
	lw $s3, 12($sp)					# load $s3
	lw $s4, 16($sp)					# load $s4
	lw $s5, 20($sp)					# load $s5
	lw $s6, 24($sp)					# load $s6
	lw $s7, 28($sp)					# load $s7
	lw $ra, 32($sp)					# load $ra
	addi $sp, $sp, 36				# allocate 36 bytes of space
    	jr $ra						# return to main address

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
