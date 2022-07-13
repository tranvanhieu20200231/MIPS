.data 
	A: .word 4, 5, 6, 8, 6, 2, -1, 59, -5, 100 
	Aend: .word
.text 
main:
	la 	$a0, A
	la 	$a1, Aend
	j 	sort
end:
	li 	$v0, 10
	syscall

sort:
	beq 	$a0, $a1, end_sort
	move 	$t0, $a0
			
loop:	lw 	$s0, 0($a0)
	addi 	$t0, $t0, 4
	lw 	$s1, 0($t0)
	beq 	$t0, $a1, end_loop
	slt 	$t1, $s1, $s0
	bne 	$t1, $zero, swap
			
countinue:
	j 	loop
			
end_loop:	addi $a0, $a0, 4
			j sort

end_sort: 	j 	end

swap:	sw 	$s0, 0($t0)
		sw 	$s1, 0($a0)
		j 	countinue
		nop