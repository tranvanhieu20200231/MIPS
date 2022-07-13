.data
string: .space 50
Message1: .asciiz "Nhap xau: "
Message2: .asciiz "Do dai la: "
.text
main:
get_string:
 	 li	$v0, 54
 	 la	$a0, Message1
 	 la	$a1, string
 	 la	$a2, 50
 	 syscall 
get_length:
	 la 	$a0, string
	 xor	$v0, $zero, $zero
	 xor 	$t0, $zero, $zero
check_char: 
	 add 	$t1, $a0, $t0
	 lb 	$t2, 0($t1)
 	 beq 	$t2, $zero, end_of_str
 	 addi 	$t0, $t0, 1
 	 j 	check_char
end_of_str: 
end_of_get_length:
print_length:
	 li	$v0, 4
	 la	$a0, Message2
	 syscall
	 li	$v0, 1
	 la	$a0, ($t0)
	 syscall