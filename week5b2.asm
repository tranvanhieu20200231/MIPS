.data
X: .asciiz "The sum of "
Y: .asciiz " and "
Z: .asciiz " is "
.text
	addi 	$s0, $s0, 4
	addi 	$s1, $s1, 5
	add  	$a1, $s0, $s1
	li	$v0, 4
	la	$a0, X
	syscall
	li	$v0, 1
	la	$a0, ($s0)
	syscall
	li	$v0, 4
	la	$a0, Y
	syscall
	li	$v0, 1
	la	$a0, ($s1)
	syscall
	li	$v0, 4
	la	$a0, Z
	syscall
	li	$v0, 1
	la	$a0, ($a1)
	syscall