########################################################################
# COMP1521 22T3 -- Assignment 1 -- Battlesmips!
#
# A simplified implementation of the classic board game battleship!
# This program was written by Aditha Jayasuriya (z5363611)
# on 24/10/2022
#
# Version 1.0 (2022/10/04): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
################################################################################

#![tabsize(8)]

# Constant definitions.
# DO NOT CHANGE THESE DEFINITIONS

# True and False constants
TRUE			= 1
FALSE			= 0
INVALID			= -1

# Board dimensions
BOARD_SIZE		= 7

# Bomb cell types
EMPTY			= '-'
HIT			= 'X'
MISS			= 'O'

# Ship cell types
CARRIER_SYMBOL		= 'C'
BATTLESHIP_SYMBOL	= 'B'
DESTROYER_SYMBOL	= 'D'
SUBMARINE_SYMBOL	= 'S'
PATROL_BOAT_SYMBOL	= 'P'

# Ship lengths
CARRIER_LEN		= 5
BATTLESHIP_LEN		= 4
DESTROYER_LEN		= 3
SUBMARINE_LEN		= 3
PATROL_BOAT_LEN		= 2

# Players
BLUE			= 'B'
RED			= 'R'

# Direction inputs
UP			= 'U'
DOWN			= 'D'
LEFT			= 'L'
RIGHT			= 'R'

# Winners
WINNER_NONE		= 0
WINNER_RED		= 1
WINNER_BLUE		= 2

################################################################################
# DATA SEGMENT
# DO NOT CHANGE THESE DEFINITIONS
.data

# char blue_board[BOARD_SIZE][BOARD_SIZE];
blue_board:			.space  BOARD_SIZE * BOARD_SIZE

# char red_board[BOARD_SIZE][BOARD_SIZE];
red_board:			.space  BOARD_SIZE * BOARD_SIZE

# char blue_view[BOARD_SIZE][BOARD_SIZE];
blue_view:			.space  BOARD_SIZE * BOARD_SIZE

# char red_view[BOARD_SIZE][BOARD_SIZE];
red_view:			.space  BOARD_SIZE * BOARD_SIZE

# char whose_turn = BLUE;
whose_turn:			.byte   BLUE

# point_t target;
.align 2
target:						# struct point target {
				.space  4	# 	int row;
				.space  4	# 	int col;
						# }

# point_t start;
.align 2
start:						# struct point start {
				.space  4	# 	int row;
				.space  4	# 	int col;
						# }

# point_t end;
.align 2
end:						# struct point end {
				.space  4	# 	int row;
				.space  4	# 	int col;
						# }

# Strings
red_player_name_str:		.asciiz "RED"
blue_player_name_str:		.asciiz "BLUE"
place_ships_str:		.asciiz ", place your ships!\n"
your_final_board_str:		.asciiz ", Your final board looks like:\n\n"
red_wins_str:			.asciiz "RED wins!\n"
blue_wins_str:			.asciiz "BLUE wins!\n"
red_turn_str:			.asciiz "It is RED's turn!\n"
blue_turn_str:			.asciiz "It is BLUE's turn!\n"
your_curr_board_str:		.asciiz "Your current board:\n"
ship_input_info_1_str:		.asciiz "Placing ship type "
ship_input_info_2_str:		.asciiz ", with length "
ship_input_info_3_str:		.asciiz ".\n"
enter_start_row_str:		.asciiz "Enter starting row: "
enter_start_col_str:		.asciiz "Enter starting column: "
enter_direction_str:		.asciiz "Enter direction (U, D, L, R): "
invalid_direction_str:		.asciiz "Invalid direction. Try again.\n"
invalid_length_str:		.asciiz "Ship doesn't fit in this direction. Try again.\n"
invalid_overlaps_str:		.asciiz "Ship overlaps with another ship. Try again.\n"
invalid_coords_already_hit_str:	.asciiz "You've already hit this target. Try again.\n"
invalid_coords_out_bounds_str:	.asciiz "Coordinates out of bounds. Try again.\n"
enter_row_target_str:		.asciiz "Please enter the row for your target: "
enter_col_target_str:		.asciiz "Please enter the column for your target: "
hit_successful_str: 		.asciiz "Successful hit!\n"
you_missed_str:			.asciiz "Miss!\n"


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################


################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  - [X] main
#  - [X] initialise_boards
#  - [X] initialise_board
#  - [X] setup_boards
#  - [X] setup_board
#  - [X] place_ship
#  - [X] is_coord_out_of_bounds
#  - [X] is_overlapping
#  - [X] place_ship_on_board
#  - [X] play_game
#  - [X] play_turn
#  - [X] perform_hit
#  - [X] check_player_win
#  - [X] check_winner
#  - [X] print_board			(provided for you)
#  - [X] swap_turn			(provided for you)
#  - [X] get_end_row			(provided for you)
#  - [X] get_end_col			(provided for you)
################################################################################

################################################################################
# .TEXT <main>
.text
main:
	# Args:     void
	#
	# Returns:
	#   - $v0: 0
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - [void]
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

main__prologue:
	begin			# begin a new stack frame
	push	$ra		# | $ra

main__body:
	jal 	initialise_boards
	jal 	setup_boards
	jal 	play_game

main__epilogue:
	pop	$ra		# | $ra
	end			# ends the current stack frame

	li	$v0, 0
	jr	$ra		# return 0;


################################################################################
# .TEXT <initialise_boards>
.text
initialise_boards:
	# Args:     void
	#
	# Returns:  void
	# Frame:    [$ra]
	# Uses:     [$a0, $ra]
	# Clobbers: [$a0]
	#
	# Locals:
	#   - [void]
	#
	# Structure:
	#   initialise_boards
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

initialise_boards__prologue:
	begin 
	push 	$ra 
initialise_boards__body:
	la 	$a0, blue_board				# calling function initialise_board 
	jal 	initialise_board			# with blue_board being passed as an argument

	la 	$a0, blue_view				# calling function initialise_board 
	jal 	initialise_board			# with blue_view being passed as an argument

	la 	$a0, red_board				# calling function initialise_board 
	jal 	initialise_board			# with red_board being passed as an argument

	la 	$a0, red_view				# calling function initialise_board 
	jal 	initialise_board			# with red_view being passed as an argument

initialise_boards__epilogue:
	pop 	$ra 
	end
	jr	$ra		# return;


################################################################################
# .TEXT <initialise_board>
.text
initialise_board:
	# Args:
        #   - $a0: char[BOARD_SIZE][BOARD_SIZE] board
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$s0, $t0, $t1, $t2, $t7, $t8]
	# Clobbers: [$t0, $t1, $t2, $t7, $t8]
	#
	# Locals:
	#   - $t0 - row 
	#   - $t1 - col 
	#   - $t2 - no. of bytes [row][col] is from start of &board
	#   - $t7 - EMPTY ( '-' ) 
	#   - $t8 - &board[row][col]
	#
	#
	# Structure:
	#   initialise_board
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

initialise_board__prologue:
	begin 
	push 	$ra 
	push 	$s0

initialise_board__body:
	move 	$s0, $a0				# moving variable 'board' to $s0 
	li 	$t7, EMPTY				# storing value EMPTY in $t7 
	li 	$t0, 0					# int row = 0 

loopIB0_start: 
	bge 	$t0, BOARD_SIZE, loopIB0_end		# if (row > BOARD_SIZE) goto loopIB0_end	
	li 	$t1, 0					# int col = 0

loopIB1_start:
	bge 	$t1, BOARD_SIZE, loopIB1_end		# if (col > BOARD_SIZE) goto loopIB1_end
	
	mul 	$t2, $t0, BOARD_SIZE			# $t2 = row * N_COLS 
	add 	$t2, $t2, $t1 				# $t2 = row * N_COLS + col
	add 	$t8, $s0, $t2				# $t8 = &board + row * N_COLS + col

	sb 	$t7, ($t8)				# &board[row][col] = empty 
	
loopIB1_increment:
	addi 	$t1, $t1, 1				# col++
	j loopIB1_start					# goto loopIB1_start

loopIB1_end:

loopIB0_increment:
	addi	$t0, $t0, 1				#row++
	j 	loopIB0_start				#goto loopIB0_start

loopIB0_end:

initialise_board__epilogue:
	pop 	$s0					
	pop 	$ra
	end
	jr	$ra					# return;


################################################################################
# .TEXT <setup_boards>
.text
setup_boards:
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $a0, $a1]
	# Clobbers: [$a0, $a1]
	#
	# Locals:
	#   - [void]
	#
	# Structure:
	#   setup_boards
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

setup_boards__prologue:
	begin 
	push 	$ra
setup_boards__body:
	la 	$a0, blue_board				# setup_board(blue_board, "BLUE");
	la 	$a1, blue_player_name_str		#
	jal 	setup_board				#

	la 	$a0, red_board				# setup_board(red_board,  "RED");
	la 	$a1, red_player_name_str 		#
	jal setup_board					#

setup_boards__epilogue:
	pop 	$ra 
	end
	jr	$ra					# return;


################################################################################
# .TEXT <setup_board>
.text
setup_board:
	# Args:
	#   - $a0: char[BOARD_SIZE][BOARD_SIZE] board
	#   - $a1: char *player
	#
	# Returns:  void
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$ra, $a0, $a1, $t0, $t1]
	# Clobbers: [$a0, $a1, $t0, $t1]
	#
	# Locals:
	#   - $s0: char[BOARD_SIZE][BOARD_SIZE] board
	#   - $s1: char *player
	#
	# Structure:
	#   setup_board
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

setup_board__prologue:
	begin 
	push 	$ra
	push 	$s0
	push 	$s1

setup_board__body:

setup_board_print_string1:
	move 	$s0, $a0 		# moving variable board to $s0
	move 	$s1, $a1		# moving player to $s1
	
	move 	$a0, $a1		# printf("%s, place your ships!\n", player);
	li 	$v0, 4 			#
	syscall				#

	la 	$a0, place_ships_str	#
	li 	$v0, 4			#
	syscall				#

setup_board_placing_ships:
	move 	$a0, $s0		# moving variable board to $a0
	la 	$a1, CARRIER_LEN        # place_ship(board, CARRIER_LEN, CARRIER_SYMBOL);
	la 	$a2, CARRIER_SYMBOL     #
	jal 	place_ship		#

	move 	$a0, $s0		# moving variable board to $a0
	la 	$a1, BATTLESHIP_LEN     # place_ship(board, BATTLESHIP_LEN, BATTLESHIP_SYMBOL);
	la 	$a2, BATTLESHIP_SYMBOL  #
	jal 	place_ship		#

	move 	$a0, $s0		# moving variable board to $a0
	la 	$a1, DESTROYER_LEN      # place_ship(board, DESTROYER_LEN, DESTROYER_SYMBOL);
	la 	$a2, DESTROYER_SYMBOL	#
	jal 	place_ship		#

	move 	$a0, $s0		# moving variable board to $a0
	la 	$a1, SUBMARINE_LEN	# place_ship(board, SUBMARINE_LEN, SUBMARINE_SYMBOL);
	la 	$a2, SUBMARINE_SYMBOL	#
	jal 	place_ship		#

	move 	$a0, $s0		# moving variable board to $a0
	la 	$a1, PATROL_BOAT_LEN	# place_ship(board, PATROL_BOAT_LEN, PATROL_BOAT_SYMBOL);
	la 	$a2, PATROL_BOAT_SYMBOL	#
	jal 	place_ship		#
	
	move 	$a0, $s1 		# printf("%s, Your final board looks like:\n\n", player);
	li 	$v0, 4			#
	syscall 			#

setup_board_print_string2:
	la 	$a0, your_final_board_str 	# printf("%s, Your final board looks like:\n\n", player);
	li 	$v0, 4				#
	syscall					#

	move 	$a0, $s0
	jal 	print_board			# print_board(board);


setup_board__epilogue:
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end
	jr	$ra		# return;


################################################################################
# .TEXT <place_ship>
.text
place_ship:
	# Args:
	#   - $a0: char[BOARD_SIZE][BOARD_SIZE] board
	#   - $a1: int  ship_len
	#   - $a2: char ship_type
	#
	# Returns:  void
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]
	# Uses:     [$ra, $a0, $s0, $s1, $s2, $s3, $t0, $t1, $t2, $t3, $t4]
	# Clobbers: [$a0, $t0, $t1, $t2, $t3, $t4]
	#
	# Locals:
	#   - $s0: char[BOARD_SIZE][BOARD_SIZE] board
	#   - $s1: int ship_len
 	#   - $s2: char ship_type
	#   - $s3: direction_char
	#   - $t0...$t4: temp variables


	# Structure:
	#   place_ship
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

place_ship__prologue:
	begin
	push 	$ra
	push 	$s0
	push 	$s1
	push 	$s2
	push 	$s3

place_ship__body:
	move 	$s0, $a0				# moving arguments to analagous $s registers
	move 	$s1, $a1				#
	move 	$s2, $a2				#

loopPS_start:
	bgt 	$0, $0, loopPS_end			#  for (;;)

place_ship_print_string1:
	la 	$a0, your_curr_board_str 		# printf("Your current board:\n");
	li 	$v0, 4					#
	syscall						#

	move 	$a0, $s0 				# print_board(board);
	jal 	print_board

	la 	$a0, ship_input_info_1_str		#  printf("Placing ship type %c, with length %d.\n", ship_type, ship_len);
	li 	$v0, 4					#
	syscall						#

	move 	$a0, $s2				#
	li 	$v0, 11					#
	syscall						#

	la 	$a0, ship_input_info_2_str		#
	li 	$v0, 4					#
	syscall						#

	move 	$a0, $s1				#
	li 	$v0, 1					#
	syscall						#

	la 	$a0, ship_input_info_3_str		#
	li 	$v0, 4					#
	syscall						#

place_ship_start_pos_input:
	la 	$a0, enter_start_row_str		# printf("Enter starting row: ");
	li 	$v0, 4					#
	syscall 					#

	li 	$v0, 5					# scanf("%d", &start.row);	
	syscall 					#
	la 	$t0, start				# $t0 is now &start.row
	sw 	$v0, ($t0)				#

	la 	$a0, enter_start_col_str		# printf("Enter starting column: ");
	li 	$v0, 4					#
	syscall 					#

	li 	$v0, 5					# scanf("%d", &start.col);
	syscall 					#
	addi 	$t0, $t0, 4				# $t0 is now &start.col
	sw 	$v0, ($t0)				#


place_ship_check_bounds:
	la 	$a0, start				# 
	jal 	is_coord_out_of_bounds			# is_coord_out_of_bounds(&start)

	beq 	$v0, FALSE, place_ship_valid_start	# if (is_coord_out_of_bounds(&start)) {
	la	$a0, invalid_coords_out_bounds_str	# printf("Coordinates out of bounds. Try again.\n");
	li 	$v0, 4					#
	syscall 					#

	j loopPS_start					# continue;

place_ship_valid_start:
	la 	$a0, enter_direction_str		# printf("Enter direction (U, D, L, R): ");
	li 	$v0, 4					#
	syscall						#

	li 	$v0, 12					# scanf(" %c", &direction_char);				
	syscall						#
	move 	$s3, $v0  				# $s3 contains direction_char 

	la 	$t0, start
	lw 	$a0, ($t0)				# get_end_row(start.row, direction_char, ship_len);
	move 	$a1, $s3 				#
	move 	$a2, $s1				#

	jal 	get_end_row 				#

	la 	$t0, end 				# end.row = return value of get_end_row(...)
	sw 	$v0, ($t0)				#

	beq 	$v0, INVALID, place_ship_invalid_direction	# if (end.row == INVALID) goto place_ship_invalid_direction

	la 	$t0, start 				#  end.col = get_end_col(start.col, direction_char, ship_len);
	addi 	$t0, $t0, 4				# 
	lw 	$a0, ($t0)				#

	move 	$a1, $s3				#
	move 	$a2, $s1 				#

	jal 	get_end_col 				#
	la 	$t0, end				# end.col = return value of get_end_col(...)
	addi 	$t0, $t0, 4				#
	sw 	$v0, ($t0)				#

	beq 	$v0, INVALID, place_ship_invalid_direction	# if (end.col == INVALID) goto place_ship_invalid_direction
	j 	place_ship_check_length

place_ship_invalid_direction:
	la 	$a0, invalid_direction_str		# printf("Invalid direction. Try again.\n");
	li 	$v0, 4					#
	syscall						#

	j 	loopPS_start				# continue; 

place_ship_check_length:
	la 	$a0, start 				# if (is_coord_out_of_bounds(&end))
	jal 	is_coord_out_of_bounds			#
	beq 	$v0, TRUE, place_ship_doesnt_fit	# if returns true, goto place_ship_doesnt_fit
	j 	place_ship_does_fit			# if returns false, goto place_ship_does_fit

place_ship_doesnt_fit: 
	la 	$a0, invalid_length_str			# printf("Ship doesn't fit in this direction. Try again.\n");
	li 	$v0, 4					#
	syscall						#

	j 	loopPS_start				# continue;

place_ship_does_fit:
	la 	$t0, start				# $t0 = &start
	la 	$t1, end 				# $t0 = &end

	lw 	$t2, ($t0) 				# $t2 = start.row
	lw 	$t3, ($t1) 				# $t3 = end.row

	bgt 	$t2, $t3, place_ship_facing_up 		# if (start.row > end.row) goto place_ship_facing_up
	j 	place_ship_check_facing_left		# else goto place_ship_check_facing_left

place_ship_facing_up: 
	move 	$t4, $t2				# int temp = start.row
	sw 	$t3, ($t0)				# start.row = end.row
	sw 	$t4, ($t1) 				# end.row = temp

place_ship_check_facing_left:
	la 	$t0, start				# 
	addi 	$t0, $t0, 4 				# $t0 = &start.col

	la 	$t1, end 				#
	addi 	$t1, $t1, 4 				# $t1 = &end.col

	lw 	$t2, ($t0) 				# $t2 = start.col
	lw 	$t3, ($t1) 				# $t3 = end.col

	bgt 	$t2, $t3, place_ship_facing_left	# if (start.col > end.col) goto place_ship_facing_left
	j 	place_ship_check_overlapping		# else goto place_ship_check_overlapping

place_ship_facing_left:
	move 	$t4, $t2 				# int temp = start.col
	sw 	$t3, ($t0)				# start.col = end.col
	sw 	$t4, ($t1)				# end.col = temp

place_ship_check_overlapping:
	move 	$a0, $s0				# moving variable 'board' back to $a0
	jal 	is_overlapping				# is_overlapping(board) 
	beq 	$v0, TRUE, place_ship_overlapping	# if returns true, goto place_ship_overlapping 
	j 	loopPS_end				# else break 

place_ship_overlapping: 
	la 	$a0, invalid_overlaps_str		#  printf("Ship overlaps with another ship. Try again.\n");
	li 	$v0, 4 					# 
	syscall						# 

loopPS_increment:
	j 	loopPS_start

loopPS_end:
	move 	$a0, $s0 				# 
	move 	$a1, $s2				# 
	jal 	place_ship_on_board			# place_ship_on_board(board, ship_type);
place_ship__epilogue:
	pop 	$s3
	pop 	$s2
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end
	jr	$ra		# return;


################################################################################
# .TEXT <is_coord_out_of_bounds>
.text
is_coord_out_of_bounds:
	# Args:
	#   - $a0: point_t *coord
	#
	# Returns:
	#   - $v0: bool
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $t0, $t1, $t2, $t3, $a0]
	# Clobbers: [$t0, $t1, $t2, $t3, $a0]
	#
	# Locals:
	#   - $t0: &coord.row
	#   - $t1: coord.row
	#   - $t2: &coord.col
	#   - $t3: coord.col	
	# Structure:
	#   is_coord_out_of_bounds
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

is_coord_out_of_bounds__prologue:
	begin 
	push 	$ra

is_coord_out_of_bounds__body:
	move 	$t0, $a0 						# $t0 = &coord.row 

	lw 	$t1, ($t0) 						# $t1 = coord.row

	blt 	$t1, $0, is_coord_out_of_bounds_yes			# if (coord.row < 0) goto is_coord_out_of_bounds_yes
	bge 	$t1, BOARD_SIZE, is_coord_out_of_bounds_yes		# if (coord.row > BOARD_SIZE) goto is_coord_out_of_bounds_yes

	add 	$t2, $t0, 4						# $t2 = &coord.col
	lw 	$t3, ($t2) 						# $t3 = coord.col

	blt 	$t3, $0, is_coord_out_of_bounds_yes			# if (coord.col < 0) goto is_coord_out_of_bounds_yes
	bge 	$t3, BOARD_SIZE, is_coord_out_of_bounds_yes		# if (coord.col > BOARD_SIZE) goto is_coord_out_of_bounds_yes
	j 	is_coord_out_of_bounds_no				# else coordinate is valid; goto is_coord_out_of_bounds_no

is_coord_out_of_bounds_yes:
	li 	$v0, TRUE						# return TRUE
	j 	is_coord_out_of_bounds__epilogue			#

is_coord_out_of_bounds_no: 
	li 	$v0, FALSE						# return FALSE

is_coord_out_of_bounds__epilogue:
	pop 	$ra
	end
	jr	$ra							# return;


################################################################################
# .TEXT <is_overlapping>
.text
is_overlapping:
	# Args:
	#   - $a0: char[BOARD_SIZE][BOARD_SIZE] board
	#
	# Returns:
	#   - $v0: bool
	#
	# Frame:    [$ra]
	# Uses:     [$t0, $t1, $t3, $t4, $t5, $t6, $s0, $s1, $s2, $s3, $ra]
	# Clobbers: [$a0, $t0, $t1, $t3, $t4, $t5, $t6]
	#
	# Locals:
	#   - $t0, $t1, $t3, $t4, $t5, $t6
	#
	# Structure:
	#   is_overlapping
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

is_overlapping__prologue:
	begin 
	push 	$ra 
	push 	$s0
	push 	$s1
	push 	$s2 
	push 	$s3 
is_overlapping__body:
	move 	$t8, $a0						# $t8 = board
	
	la 	$t0, start						# $t0 = &start.row			
	addi 	$t1, $t0, 4						# $t1 = &start.col

	lw 	$t2, ($t0) 						# $t2 = start.row
	lw 	$t3, ($t1) 						# $t3 = start.col

	la 	$s0, end 						# $s0 = &end.row
	addi 	$s1, $s0, 4 						# $s1 = &end.col

	lw 	$s2, ($s0) 						# $s2 = end.row
	lw 	$s3, ($s1) 						# $s3 = end.col


	beq 	$t2, $s3, is_overlapping_horizontal			# if (start.row == end.row) goto is_overlapping_horizontal
	j 	is_overlapping_vertical

is_overlapping_horizontal:
	move 	$t4, $t3						# $t4 = col = start.col

IO_loop0_start: 
	bgt 	$t4, $s3, is_overlapping_no_overlap			# if (col > end.col) goto is_overlapping_no_overlap
	
	mul 	$t5, $t2, BOARD_SIZE					# calculating the number of bytes from the start of &board [start.row][col] is 
	add 	$t5, $t5, $t4						#

	add	$t5, $t5, $t8						# determining &board[start.row][col]

	lb 	$t6, ($t5)						# $t6 = board[start.row][col]
	beq 	$t6, EMPTY, IO_loop0_increment				# if (board[start.row][col] == EMPTY) goto end of loop
	
	li 	$v0, TRUE						# otherwise, return TRUE;
	j 	is_overlapping__epilogue				# 

IO_loop0_increment:
	addi 	$t4, $t4, 1						# col++
	j 	IO_loop0_start						# }

IO_loop0_end:

is_overlapping_vertical:
	move 	$t4, $t2						# $t4 = row = start.row

IO_loop1_start:
	bgt 	$t4, $s2, is_overlapping_no_overlap			# if (row > end.row) goto is_overlapping_no_overlap	

	mul 	$t5, $t4, BOARD_SIZE					# calculating the number of bytes the index [start.row][col] is analagous to 
	add	$t5, $t5, $t3						#
	
	add	$t5, $t5, $t8						#adding the number of bytes to &board

	lb 	$t6, ($t5) 						# $t6 = board[row][start.col] 
	beq 	$t6, EMPTY, IO_loop1_increment				# if (board[row][start.col] != EMPTY) goto IO_loop1_increment
	li 	$v0, TRUE 						# otherwise, return TRUE
	j 	is_overlapping__epilogue				#


IO_loop1_increment:
	addi 	$t4, $t4, 1						# row++;
	j 	IO_loop1_start						# }

IO_loop1_end:

is_overlapping_no_overlap:
	li 	$v0, FALSE 						# return FALSE

is_overlapping__epilogue:
	pop 	$s3
	pop 	$s2
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end
	jr	$ra							# return;


################################################################################
# .TEXT <place_ship_on_board>
.text
place_ship_on_board:
	# Args:
	#   - $a0: char[BOARD_SIZE][BOARD_SIZE] board
	#   - $a1: char ship_type
	#
	# Returns:  void
	#
	# Frame:    [$ra, $a1, $s0, $s1, $s2, $s3, $s4, $s5]
	# Uses:     [$ra, $a0, $a1, $s0, $s1, $s2, $s3, $s4, $s5, $t0, $t1, $t2, $t3, $t4]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4]
	#
	# Locals:
	#   - $t0...$t4: temp variables
	#
	# Structure:
	#   place_ship_on_board
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

place_ship_on_board__prologue:
	begin
	push 	$ra
	push 	$s0
	push 	$s1
	push 	$s2
	push 	$s3
	push 	$s4
	push 	$s5

place_ship_on_board__body:
	move 	$s5, $a1						# $s5 = ship_type
	la 	$t0, start						# $t0 = &start
	la 	$t1, end						# $t1 = &end
	
	lw 	$s0, ($t0)						# $s0 = start
	lw 	$s1, ($t1)						# $s1 = end

	addi 	$t2, $t0, 4     					# $t2 = &start.col 
	addi 	$t3, $t1, 4						# $t3 = &end.col
	
	lw 	$s2, ($t2)						# $s2 = start.col
	lw 	$s3, ($t3)						# $s3 = end.col
	
	beq 	$s0, $s1, place_ship_on_board_horizontal		# if (start.row == end.row) goto place_ship_on_board_horizontal
	j 	place_ship_on_board_vertical				# else goto place_ship_on_board_vertical

place_ship_on_board_horizontal:
	move 	$t4, $s2						# $t4 = col = start.col

PSOB_loop0_start:
	bgt 	$t4, $s3, place_ship_on_board__epilogue			# if (col > end.col) goto epilogue

	mul 	$s4, $s0, BOARD_SIZE					# $s4 = start.row * BOARD_SIZE
	add	$s4, $s4, $t4						# $s4 = start.row + col
	add 	$s4, $s4, $a0						# $s4 = &board[start.row][col]

	sb 	$s5, ($s4) 						# board[start.row][col] = ship_type

	addi 	$t4, $t4, 1						# col++
	j 	PSOB_loop0_start					# }

PSOB_loop0_end:
	j 	place_ship_on_board__epilogue

place_ship_on_board_vertical:
	move 	$t4, $s0						# $t4 = row = start.row


PSOB_loop1_start:
	bgt 	$t4, $s1, PSOB_loop1_end				# if (row > end.row) goto PSOB_loop1_end

	mul 	$s4, $t4, BOARD_SIZE					# $s4 = row * BOARD_SIZE
	add 	$s4, $s4, $s2 						# $s4 = row + start.col
	add 	$s4, $s4, $a0 						# $s4 = &board[row][start.col]

	sb 	$s5, ($s4) 						# board[row][col] = ship_type

	addi 	$t4, $t4, 1						# row++
	j 	PSOB_loop1_start					# }

PSOB_loop1_end:

place_ship_on_board__epilogue:
	pop 	$s5
	pop 	$s4
	pop 	$s3
	pop 	$s2
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end
	jr	$ra		# return;


################################################################################
# .TEXT <play_game>
.text
play_game:
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra, $s0]
	# Uses:     [$ra, $a0, $s0]
	# Clobbers: [$a0]
	#
	# Locals:
	#   - [void]
	#
	# Structure:
	#   play_game
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

play_game__prologue:
	begin
	push 	$ra
	push 	$s0
play_game__body:
	li 	$s0, WINNER_NONE					# $s0 = WINNER_NONE
loopPG_start:
	bne 	$s0, WINNER_NONE, loopPG_end				# if ($s0 != WINNER_NONE) goto loopPG_end

	jal 	play_turn						# play_turn()
	jal 	check_winner 						# check_winner()

	move 	$s0, $v0						# $s0 = return value of check_winner

	j 	loopPG_start						# }

loopPG_end:
	beq	$s0, WINNER_RED, play_game_red_winner			# if $s0 = WINNER_RED goto play_game_red_winner
	j 	play_game_blue_winner					# else goto play_game_blue_winner

play_game_red_winner: 
	la 	$a0, red_wins_str					# printf("RED wins!\n");
	li 	$v0, 4							# 
	syscall								# 
	
	j 	play_game__epilogue					#

play_game_blue_winner: 
	la 	$a0, blue_wins_str					# printf("BLUE wins!\n");
	li 	$v0, 4							#
	syscall								#

play_game__epilogue:
	pop 	$s0
	pop 	$ra
	end
	jr	$ra							# return;


################################################################################
# .TEXT <play_turn>
.text
play_turn:
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $a0, $a1, $t0, $t1, $t2, $t3]
	# Clobbers: [$a0, $a1, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0...$t3: temp variables
	#
	# Structure:
	#   play_turn
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

play_turn__prologue:
	begin 
	push 	$ra
	push 	$s0

play_turn__body:
	la 	$t0, whose_turn						# $t0 = &whose_turn
	lb 	$t1, ($t0) 						# $t1 = whose_turn

	beq 	$t1, BLUE, play_turn_blue				# if $t1 = BLUE, goto play_turn_blue
	j 	play_turn_red						# else goto play_turn_red

play_turn_blue:
	la 	$a0, blue_turn_str					# printf("It is BLUE's turn!\n");
	li 	$v0, 4							#
	syscall								# 

	la 	$a0, blue_view 						# print_board(blue_view);
	jal 	print_board						# 
	j 	play_turn_targeting					# 

play_turn_red:
	la 	$a0, red_turn_str					# printf("It is RED's turn!\n");
	li 	$v0, 4							# 	
	syscall								#

	la 	$a0, red_view 						# print_board(red_view);
	jal 	print_board 						# 

play_turn_targeting: 
	la 	$a0, enter_row_target_str				# printf("Please enter the row for your target: ");		
	li 	$v0, 4
	syscall

	li 	$v0, 5							# scanf("%d", &target.row);
	syscall 							# 
	la 	$t2, target						# 
	sw 	$v0, ($t2)						# 

	la 	$a0, enter_col_target_str				# printf("Please enter the column for your target: ");
	li 	$v0, 4							#
	syscall								# 

	li 	$v0, 5							# scanf("%d", &target.col);
	syscall								# 
	addi 	$t3, $t2, 4						# 
	sw	$v0, ($t3)						# 

	la 	$a0, target						# is_coord_out_of_bounds(&target)
	jal 	is_coord_out_of_bounds					# 
	beq 	$v0, FALSE, play_turn_valid_target			# if return value is FALSE, goto play_turn_valid_target
	
	la 	$a0, invalid_coords_out_bounds_str			# otherwise, printf("Coordinates out of bounds. Try again.\n");
	li 	$v0, 4							#
	syscall								# 

	j 	play_turn__epilogue

play_turn_valid_target:
	la 	$t0, whose_turn						# if (whose_turn == BLUE) goto BLUE_HIT
	lb 	$t1, ($t0)						# 
	beq 	$t1, BLUE, play_turn_blue_shoot				# 
	j 	play_turn_red_shoot					# else, goto play_turn_red_shoot

play_turn_blue_shoot: 
	la 	$a0, red_board						# perform_hit(red_board, blue_view)
	la 	$a1, blue_view						#
	jal 	perform_hit						#
	move 	$s0, $v0						# hit_status = return value of perform_hit(...)
	j 	play_turn_check_valid_hit

play_turn_red_shoot:
	la 	$a0, blue_board						# perform_hit(blue_board, red_view);
	la 	$a1, red_view						#
	jal 	perform_hit						#
	move 	$s0, $v0						# hit_status = return value of perform_hit(...)

play_turn_check_valid_hit:
	beq 	$s0, INVALID, play_turn_invalid_hit			# if $s0 = INVALID, goto play_turn_invalid_hit
	beq 	$s0, HIT, play_turn_hit					# if $s0 = HIT, goto play_turn_hit
	j 	play_turn_miss						# otherwise, goto play_turn_miss

play_turn_invalid_hit:
	la 	$a0, invalid_coords_already_hit_str			# printf("You've already hit this target. Try again.\n");
	li 	$v0, 4							#
	syscall								#
	
	j play_turn__epilogue						# return;

play_turn_hit:
	la 	$a0, hit_successful_str					# printf("Successful hit!\n");			
	li 	$v0, 4							#
	syscall								#

	j play_turn__epilogue						# return;

play_turn_miss:
	la 	$a0, you_missed_str					# printf("Miss!\n");
	li 	$v0, 4							#
	syscall								#
	jal 	swap_turn						# swap_turn()

play_turn__epilogue:
	pop 	$s0
	pop 	$ra
	end
	jr	$ra						# return 0;


################################################################################
# .TEXT <perform_hit>
.text
perform_hit:
	# Args:
	#   - $a0: char their_board[BOARD_SIZE][BOARD_SIZE]
	#   - $a1: char our_view[BOARD_SIZE][BOARD_SIZE]
	#
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$ra, $a0, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5]
	#
	# Locals:
	#   - $t0...$t6: temp variables
	#
	# Structure:
	#   perform_hit
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

perform_hit__prologue:
	begin 
	push	$ra
	push 	$s0
	push 	$s1

perform_hit__body:
	la 	$t0, target						# $t0 = &target.row
	addi 	$t1, $t0, 4						# $t1 = &target.col

	lw 	$t2, ($t0)  						# $t2 = target.row
	lw 	$t3, ($t1) 						# $t3 = target.col
	
	mul 	$t4, $t2, BOARD_SIZE					# $t4 = target.row * BOARD_SIZE
	add	$t4, $t4, $t3						# $t4 = target.row * BOARD_SIZE + target.col 

	add 	$s0, $t4, $a1						# $s0 = &our_view[target.row][target.col]

perform_hit_check_empty:
	lb 	$t5, ($s0) 						# $t5 = our_view[target.row][target.col]
	beq 	$t5, EMPTY, perform_hit_check_hit			# if $t5 = EMPTY, goto perform_hit_check_hit
	li 	$v0, INVALID						# otherwise, return INVALID;
	j 	perform_hit__epilogue					#

perform_hit_check_hit: 
	add 	$s1, $t4, $a0 						# $s1 =	&their_board[target.row][target.col]
	lb 	$t5, ($s1) 						# $t5 = their_board[target.row][target.col]

	beq 	$t5, EMPTY, perform_hit_missed				# if $t5 = EMPTY, goto perform_hit_missed
	li 	$v0, HIT						# our_view[target.row][target.col] = HIT;
	sb 	$v0, ($s0)						#
	j 	perform_hit__epilogue					# return HIT;

perform_hit_missed:
	li 	$v0, MISS						# return MISS;
	sb	$v0, ($s0)						# our_view[target.row][target.col] = MISS;

perform_hit__epilogue:
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end
	jr	$ra							# return;


################################################################################
# .TEXT <check_winner>
.text
check_winner:
	# Args:	    void
	#
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $a0, $a1]
	# Clobbers: [$a0, $a1]
	#
	# Locals:
	#   - [void]
	#
	# Structure:
	#   check_winner
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

check_winner__prologue:
	begin 
	push 	$ra
check_winner__body:

	la 	$a0, red_board						# check_player_win(red_board, blue_view)	
	la 	$a1, blue_view						#
	jal 	check_player_win					#

	beq 	$v0, TRUE, check_winner_blue_wins			# if return value is TRUE, goto check_winner_blue_wins

	la 	$a0, blue_board						# check_player_win(blue_board, red_view)
	la 	$a1, red_view 						#
	jal 	check_player_win					#
	
	beq 	$v0, TRUE, check_winner_red_wins			# if return value is TRUE, goto check_winner_red_wins
	j 	check_winner_no_winner					# otherwise, goto check_winner_no_winner

check_winner_blue_wins:
	li 	$v0, WINNER_BLUE					# return WINNER_BLUE
	j 	check_winner__epilogue					#

check_winner_red_wins:
	li 	$v0, WINNER_RED						# return WINNER_RED
	j 	check_winner__epilogue					#

check_winner_no_winner:
	li 	$v0, WINNER_NONE					# return WINNER_NONE
check_winner__epilogue:
	pop 	$ra
	end
	jr	$ra							# return;


################################################################################
# .TEXT <check_player_win>
.text
check_player_win:
	# Args:
	#   - $a0: char[BOARD_SIZE][BOARD_SIZE] their_board
	#   - $a1: char[BOARD_SIZE][BOARD_SIZE] our_view
	#
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $t0, $t1, $t2, $t3, $s0, $s1, $s2, s3]
	# Clobbers: [$t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0...$t3: temp variables 
	#
	# Structure:
	#   check_player_win
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

check_player_win__prologue:
	begin
	push 	$ra 
	push 	$s0
	push 	$s1
	push 	$s2
	push 	$s3
check_player_win__body:
	li 	$t0, 0							# int row = 0
CPW_loop0_start:
	bge 	$t0, BOARD_SIZE, CPW_loop0_end				# if (row >= BOARD_SIZE), goto CPW_loop0_end

	li 	$t1, 0							# int col = 0 
CPW_loop1_start:
	bge 	$t1, BOARD_SIZE, CPW_loop1_end				# if (col >= BOARD_SIZE), goto CPW_loop1_end

	mul 	$t2, $t0, BOARD_SIZE					# determining the number of bytes board[row][col] is from &board
	add 	$t2, $t2, $t1 						# 

	move 	$s0, $a0						# adding no. of bytes to &board
	add 	$s0, $s0, $t2						# $s0 = &board[row][col]
	lb 	$s1, ($s0)						# $s1 = board[row][col]

	beq 	$s1, EMPTY, CPW_loop1_increment				# if $s1 = EMPTY, goto CPW_loop1_increment

	move 	$s2, $a1						# adding required no. of bytes to &our_view
	add 	$s2, $s2, $t2 						# $s2 = &our_view[row][col]
	lb 	$s3, ($s2)						# $s3 = our_view[row][col]

	bne 	$s3, EMPTY, CPW_loop1_increment				# if $s3 = EMPTY, goto CPW_loop1_increment
	li 	$v0, FALSE						# otherwise, return FALSE
	j 	check_player_win__epilogue				#

CPW_loop1_increment:
	addi 	$t1, $t1, 1						# col++
	j 	CPW_loop1_start						# }
CPW_loop1_end:

CPW_loop0_increment:
	addi 	$t0, $t0, 1						# row++
	j 	CPW_loop0_start						# }
CPW_loop0_end:
	li 	$v0, TRUE						# return TRUE;
check_player_win__epilogue:
	pop 	$s3
	pop 	$s2
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end
	jr	$ra							# return;


################################################################################
################################################################################
###                 PROVIDED FUNCTIONS — DO NOT CHANGE THESE                 ###
################################################################################
################################################################################


################################################################################
# .TEXT <print_board>
# YOU DO NOT NEED TO CHANGE THE PRINT_BOARD FUNCTION
.text
print_board:
	# Args:
	#   - $a0: char[BOARD_SIZE][BOARD_SIZE] board
	#
	# Returns:  void
	#
	# Frame:    [$ra, $s0]
	# Uses:     [$a0, $v0, $t0, $t1, $t2, $t3, $t4, $s0]
	# Clobbers: [$a0, $v0, $t0, $t1, $t2, $t3, $t4]
	#
	# Locals:
	#   - $s0: saved $a0
	#   - $t0: col, row
	#   - $t1: col
	#   - $t2: [row][col]
	#   - $t3: &board[row][col]
	#   - $t4: board[row][col]
	#
	# Structure:
	#   print_board
	#   -> [prologue]
	#   -> body
	#      -> for_header_init
	#      -> for_header_cond
	#      -> for_header_body
	#      -> for_header_step
	#      -> for_header_post
	#      -> for_row_init
	#      -> for_row_cond
	#      -> for_row_body
	#         -> for_col_init
	#         -> for_col_cond
	#         -> for_col_body
	#         -> for_col_step
	#         -> for_col_post
	#      -> for_row_step
	#      -> for_row_post
	#   -> [epilogue]

print_board__prologue:
	begin							# begin a new stack frame
	push	$ra						# | $ra
	push	$s0						# | $s0

print_board__body:
	move 	$s0, $a0

	li	$v0, 11						# syscall 11: print_char
	la	$a0, ' '					#
	syscall							# printf("%c", ' ');
	syscall							# printf("%c", ' ');

print_board__for_header_init:
	li	$t0, 0						# int col = 0;

print_board__for_header_cond:
	bge	$t0, BOARD_SIZE, print_board__for_header_post	# if (col >= BOARD_SIZE) goto print_board__for_header_post;

print_board__for_header_body:
	li	$v0, 1						# syscall 1: print_int
	move	$a0, $t0					#
	syscall							# printf("%d", col);

	li	$v0, 11						# syscall 11: print_char
	li	$a0, ' '					#
	syscall							# printf("%c", ' ');

print_board__for_header_step:
	addiu	$t0, 1						# col++;
	b	print_board__for_header_cond

print_board__for_header_post:
	li	$v0, 11						# syscall 11: print_char
	la	$a0, '\n'					#
	syscall							# printf("%c", '\n');

print_board__for_row_init:
	li	$t0, 0						# int row = 0;

print_board__for_row_cond:
	bge	$t0, BOARD_SIZE, print_board__for_row_post	# if (row >= BOARD_SIZE) goto print_board__for_row_post;

print_board__for_row_body:
	li	$v0, 1						# syscall 1: print_int
	move	$a0, $t0					#
	syscall							# printf("%d", row);

	li	$v0, 11						# syscall 11: print_char
	li	$a0, ' '					#
	syscall							# printf("%c", ' ');

print_board__for_col_init:
	li	$t1, 0						# int col = 0;

print_board__for_col_cond:
	bge	$t1, BOARD_SIZE, print_board__for_col_post	# if (col >= BOARD_SIZE) goto print_board__for_col_post;

print_board__for_col_body:
	mul	$t2, $t0, BOARD_SIZE				# &board[row][col] = (row * BOARD_SIZE
	add	$t2, $t2, $t1					#		      + col)
	mul	$t2, $t2, 1					# 		      * sizeof(char)
	add 	$t3, $s0, $t2					# 		      + &board[0][0]
	lb	$t4, ($t3)					# board[row][col]

	li	$v0, 11						# syscall 11: print_char
	move	$a0, $t4					#
	syscall							# printf("%c", board[row][col]);

	li	$v0, 11						# syscall 11: print_char
	li	$a0, ' '					#
	syscall							# printf("%c", ' ');

print_board__for_col_step:
	addi	$t1, $t1, 1					# col++;
	b	print_board__for_col_cond			# goto print_board__for_col_cond;

print_board__for_col_post:
	li	$v0, 11						# syscall 11: print_char
	li	$a0, '\n'					#
	syscall							# printf("%c", '\n');

print_board__for_row_step:
	addi	$t0, $t0, 1					# row++;
	b	print_board__for_row_cond			# goto print_board__for_row_cond;

print_board__for_row_post:
print_board__epilogue:
	pop	$s0						# | $s0
	pop	$ra						# | $ra
	end							# ends the current stack frame

	jr	$ra						# return;


################################################################################
# .TEXT <swap_turn>
.text
swap_turn:
	# Args:	    void
	#
	# Returns:  void
	#
	# Frame:    []
	# Uses:     [$t0]
	# Clobbers: [$t0]
	#
	# Locals:
	#
	# Structure:
	#   swap_turn
	#   -> body
	#      -> red
	#      -> blue
	#   -> [epilogue]

swap_turn__body:
	lb	$t0, whose_turn
	bne	$t0, BLUE, swap_turn__blue			# if (whose_turn != BLUE) goto swap_turn__blue;

swap_turn__red:
	li	$t0, RED					# whose_turn = RED;
	sb	$t0, whose_turn					# 
	
	j	swap_turn__epilogue				# return;

swap_turn__blue:
	li	$t0, BLUE					# whose_turn = BLUE;
	sb	$t0, whose_turn					# 

swap_turn__epilogue:
	jr	$ra						# return;

################################################################################
# .TEXT <get_end_row>
.text
get_end_row:
	# Args:
	#   - $a0: int  start_row
	#   - $a1: char direction
	#   - $a2: int  ship_len
	#
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	#
	# Structure:
	#   get_end_row
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

get_end_row__prologue:
	begin							# begin a new stack frame
	push	$ra						# | $ra

get_end_row__body:
	move	$v0, $a0					
	beq	$a1, 'L', get_end_row__epilogue			# if (direction == 'L') return start_row;
	beq	$a1, 'R', get_end_row__epilogue			# if (direction == 'R') return start_row;

	sub	$t0, $a2, 1
	sub	$v0, $a0, $t0
	beq	$a1, 'U', get_end_row__epilogue			# if (direction == 'U') return start_row - (ship_len - 1);

	sub	$t0, $a2, 1
	add	$v0, $a0, $t0
	beq	$a1, 'D', get_end_row__epilogue			# if (direction == 'D') return start_row + (ship_len - 1);

	li	$v0, INVALID					# return INVALID;

get_end_row__epilogue:
	pop	$ra						# | $ra
	end							# ends the current stack frame

	jr	$ra						# return;


################################################################################
# .TEXT <get_end_col>
.text
get_end_col:
	# Args:
	#   - $a0: int  start_col
	#   - $a1: char direction
	#   - $a2: int  ship_len
	#
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	#
	# Structure:
	#   get_end_col
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

get_end_col__prologue:
	begin							# begin a new stack frame
	push	$ra						# | $ra

get_end_col__body:
	move	$v0, $a0					
	beq	$a1, 'U', get_end_col__epilogue			# if (direction == 'U') return start_col;
	beq	$a1, 'D', get_end_col__epilogue			# if (direction == 'D') return start_col;

	sub	$t0, $a2, 1
	sub	$v0, $a0, $t0
	beq	$a1, 'L', get_end_col__epilogue			# if (direction == 'L') return start_col - (ship_len - 1);

	sub	$t0, $a2, 1
	add	$v0, $a0, $t0
	beq	$a1, 'R', get_end_col__epilogue			# if (direction == 'R') return start_col + (ship_len - 1);

	li	$v0, INVALID					# return INVALID;

get_end_col__epilogue:
	pop	$ra						# | $ra
	end							# ends the current stack frame

	jr	$ra						# return;
