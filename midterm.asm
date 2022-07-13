.data 
Ten: 		.space 1000		# Mang ten do lon 1000
diem:  		.word  0:100   		# Mang luu tru diem do dai 100
input1:  	.asciiz  "Nhap n: "
input2:  	.asciiz  "Nhap ten(toi da 31 ki tu): "
input3: 	.asciiz  "Nhap diem (1-->10): "
inputmo:  	.asciiz  "[ "
inputdong:  	.asciiz  " ]\n"
inputthongbao: 	.asciiz  "Ket qua sau sap xep(xd: ten): \n"
inputhaicham: 	.asciiz  "d: "
inputloi: 	.asciiz  "Diem ban nhap phai lon hon 0 va nho hon 10\n"
tmp: 		.space  32

.text
main:
#khoi tao
	la 	$s1, Ten 		#s1 luu dia chi mang ten
	la 	$s3, diem 		#s3 luu dia chi mang diem
	la 	$s7, tmp 		#s7 luu dia chi cua tmp
	addi 	$t0, $0, 0 		#t0 la index
	j 	nhapthongtin

ketthucnhap:
	addi 	$s4, $t3, -4 		#luu gia tri cua diem[n-1]
	addi 	$s5, $t2, -32 		#luu gia tri cua ten[n-1]
	j 	sort
after_sort: 
	#xuat thong tin
	add 	$t2, $0, $s1
	add 	$t0, $0, $0
	add 	$t3, $s3, $0 
	la    	$a0, inputthongbao
	addi  	$v0, $zero, 4
	syscall
	j 	Xuatmang
Xongxuatmang:
	li 	$v0, 10 		#exit
	syscall
	
#======nhap so luong phan tu mang================
nhapthongtin:

	la  	$a0, input1
	addi  	$v0, $zero, 4
	syscall
	addi  	$v0, $zero, 5
	syscall
	addi  	$s2, $v0, 0 		#s2 = n


	add 	$t2, $zero, $s1 	#t2 la dia chi ten[n]
	add 	$t3, $zero, $s3 	#t3 la dia chi diem[n]


#s1 la dia chi mang, s2 la so phan tu n, t0 la index
Loop:
#thoat vong lap
	slt 	$t5, $t0, $s2
	bne 	$t5, 1, ketthucnhap

#nhap du lieu
	la    	$a0, inputmo
	addi  	$v0, $zero, 4
	syscall

	addi  	$a0, $t0, 0
	addi  	$v0, $zero, 1
	syscall

	la    	$a0, inputdong
	addi  	$v0, $zero, 4
	syscall

#nhap ten
	la  	$a0, input2
	addi  	$v0, $zero, 4
	syscall
	li 	$v0, 8 
	add 	$a0, $zero, $t2 
	li 	$a1, 32 
	syscall

#nhap diem
	j 	nhapdiem
kiemtradiem:
	la  	$a0, inputloi
	addi  	$v0, $zero, 4
	syscall
nhapdiem:
	la  	$a0, input3
	addi  	$v0, $zero, 4
	syscall
	addi  	$v0, $zero, 5
	syscall
	sgt 	$t4, $v0, 10
	bne 	$t4, 0, kiemtradiem
	sw 	$v0, 0($t3)

	addi 	$t0, $t0, 1
	sll 	$t1, $t0, 5
	add 	$t2, $s1, $t1  
	addi 	$t3, $t3, 4

	j 	Loop
#=========================================================

#=====Xuat thong tin=======================================
Xuatmang: 
	slt 	$t5, $t0, $s2
	bne 	$t5, 1, Xongxuatmang 

	lw 	$a0, 0($t3)
	addi  	$v0, $zero, 1
	syscall

	la    	$a0, inputhaicham
	addi  	$v0, $zero, 4
	syscall

	la  	$a0, 0($t2)
	addi  	$v0, $zero, 4
	syscall

	addi 	$t3, $t3, 4
	addi 	$t0, $t0, 1
	sll 	$t1, $t0, 5
	add 	$t2, $s1, $t1  
	j 	Xuatmang


#=====strcpy======================================
#a0: dia chi dich, $a1: dia chi nguon
strcpy:
	add 	$t3,$zero,$zero 	# $t3 = i = 0
L1:
	add 	$t4,$t3,$a0 		# $t4 = $t3 + $s1 = i + ten[0]
# = address of ten[i]
	lb 	$t5,0($t4) 		# $t5 = value at $t4 = y[i]
	add 	$t6,$t3,$a1 		# $t6 = $t3 + $a1 = i + tmp[0]
# = address of tmp[i]
	sb 	$t5,0($t6) 		# tmp[i]= $t5 = ten[i]
	beq 	$t5,$zero,end_of_strcpy	# if ten[i] == 0, exit
	nop
	addi 	$t3,$t3,1 		# $s0 = $s0 + 1 <-> i = i + 1
	j 	L1 			# next character
	nop
end_of_strcpy:
	jr 	$ra
#=====================================================

#========sap xep======================================

sort: 
	beq 	$s3,$s4,done 		#single element list is sorted
	j 	max 			#call the max procedure
after_max: 
	lw 	$t0,0($s4) 		#load last element into $t0
	sw 	$t0,0($v0) 		#copy last element to max location
	sw 	$v1,0($s4) 		#copy max value to last element
	addi 	$s4,$s4,-4 		#decrement pointer to last element

	addi 	$a0, $s5, 0
	addi 	$a1, $s7, 0
	jal 	strcpy 			#luu gia tri ten cuoi cung vao tmp
	addi 	$a0, $t7, 0
	addi 	$a1, $s5, 0
	jal 	strcpy 			#luu gia tri tmp vao max pointer
	addi 	$a0, $s7, 0
	addi 	$a1, $t7, 0
	jal 	strcpy 			#luu gia tri tmp vao max pointer
	addi 	$s5, $s5, -32


	j 	sort 			#repeat sort for smaller list
done: 
	j 	after_sort
#---------------------------------------------------------------------
#Procedure max
#function: fax the value and address of max element in the list
#$a0 pointer to first element
#$a1 pointer to last element
#---------------------------------------------------------------------
max:
	addi 	$v0,$s3,0 		#init max pointer to first element
	lw 	$v1,0($v0) 		#init max value to first value
	addi 	$t0,$s3,0 		#init next pointer to first

	addi 	$t7, $s1, 0 		#init max pointer of ten element
	addi 	$t8, $s1, 0		#init next pointer of ten

loop:
	beq 	$t0,$s4,ret 		#if next=last, return
	addi 	$t0,$t0,4 		#advance to next element
	addi 	$t8, $t8, 32 		#chay con tro ten theo con tro mang
	lw 	$t1,0($t0) 		#load next element into $t1
	slt 	$t2,$t1,$v1 		#(next)<(max) ?
	bne 	$t2,$zero,loop 		#if (next)<(max), repeat
	addi 	$v0,$t0,0 		#next element is new max element
	addi 	$t7, $t8, 0
	addi 	$v1,$t1,0 		#next value is new max value
	j 	loop 			#change completed; now repeat
ret:
	j 	after_max