.data

Timketquaraw:	.space  600
Timketqua:	.space	1000

Cophanbiet:	.word	1
Khongphanbiet:	.word	0
Dodaitoida:	.word	128

Chuoidautien:	.asciiz	"Chuoi dau tien"
Chuoithuhai:	.asciiz	"Chuoi thu hai"
Chedotimkiem:	.asciiz	"Tim kiem phan biet chu hoa chu thuong?"

Chuoimot:	.space 129
Chuoihai:	.space 129

Daucach:	.ascii ","
Thongbao1:	.asciiz	"Khong tim thay chuoi !"	
Thongbao2:	.asciiz	"Vi tri chuoi can tim: "

.text
	
#################### chuc nang chinh ####################
main:
	li	$v0, 54				# Nhap chuoi
	la	$a0, Chuoidautien		# In ra Chuoi dau tien
	la	$a1, Chuoimot			# Nhap chuoi dau tien luu vao Chuoimot
	lw	$a2, Dodaitoida			# Do dai toi da
	syscall
	
	li	$v0, 54				# Nhap chuoi
	la	$a0, Chuoithuhai		# In ra Chuoi thu hai
	la	$a1, Chuoihai			# Nhap chuoi thu hai luu vao Chuoihai
	lw	$a2, Dodaitoida			# Do dai toi da
	syscall
	
	li	$v0, 50				# Nhap chuoi
	la	$a0, Chedotimkiem		# In ra Tim kiem phan biet chu hoa chu thuong?
	syscall
	
	beq	$a0, 0, timkiemcophanbiet	# Nguoi dung chon CO, dat thong so che do cua chuc nang tim kiem thanh Cophanbiet
	j	timkiemkhongphanbiet		# Neu KHONG, dat thong so che do cua chuc nang tim kiem thanh Khongphanbiet
	
timkiemcophanbiet:
	lw	$a2, Cophanbiet			# Dat $a2 thanh noi dung cua tu bo nho tai dia chi cua Cophanbiet
	j	hamtimkiem			# Goi ham tim kiem
	
timkiemkhongphanbiet:
	lw	$a2, Khongphanbiet		# Dat $a2 thanh noi dung cua tu bo nho tai dia chi cua Khongphanbiet
	j 	hamtimkiem			# Goi ham tim kiem

hamtimkiem:
	la	$a0, Chuoimot			# Tai dia chi chuoi vao $a0
	la	$a1, Chuoihai			# Tai dia chi chuoi vao $a1
	la	$a3, Timketquaraw		# Tai dia chi chuoi vao $a3
	jal	timkiem				# Nhay toi timkiem
	beq	$v0, 0, thongbao1		# Thongbao1	

	la	$a0, Timketquaraw		# Tai dia chi chuoi vao $a0
	addi	$a1, $v0, 0 			# Create a string that join all the result
	la	$a2, Timketqua			# Tai dia chi chuoi vao $a2
	lb	$a3, Daucach			# Lay gia tri ra $a3
	jal	thamgia				# Nhay toi thamgia
	
	la	$a0, Thongbao2			# Tai dia chi chuoi vao $a0
	la	$a1, Timketqua			# Call message dialog, print the joined result
	li	$v0, 59				# $v0 = 59
	syscall 
	j	exit				# Nhay toi exit
	
thongbao1:
	la	$a0, Thongbao1			# Tai dia chi chuoi vao $a0
	li	$a1, 1				# Khong tim thay chuoi !
	li	$v0, 55				# $v0 = 55
	syscall 
	j	exit				# Nhay toi exit
	
exit:
	li	$v0, 10				# Thoat
	syscall
	

#################### chuc nang tim kiem ####################
#
# 	Nguyen mau: Tim kiem($a0, $a1, $a2, a3)
# 	$a0: chuoi dau tien
# 	$a1: chuoi thu hai
# 	$a2: mode ( 1 neu phan biet chu hoa chu thuong, nguoi lai khong phan biet chu hoa chu thuong)
# 	$a3: mang int, luu tru tat ca cac vi tri $a1 xuat hien trong $a0
#	
#	Tim chuoi $a1 trong chuoi $a0

timkiem:
	subi	$sp, $sp, 4
	sw	$ra, 4($sp)			# Luu dia chi tra hang
	addi	$s0, $a0, 0			# $s0 = $a0
	addi	$s1, $a1, 0			# $s1 = $a1
	addi	$s3, $a3, 0			# $s3 = $a3 = mang ket qua
	li	$s4, 0				# $s4 = len($s3)
	
	addi	$a0, $s0, 0			# $a0 = $s0
	jal	strlen				# $s2 = strlen($a0)
	addi	$s2, $v0, 0			# $s0 = $v0
	
	addi	$a0, $s1, 0			# $a0 = $s1
	jal	strlen				# $s2 = strlen($a0) - strlen($a1)
	sub	$s2, $s2, $v0			#
	
	li	$s5, 0				# $s5 = vi tri hien tai trong $s0

vonglaptk:
	bgt	$s5, $s2, timkiem_return	#
	add	$a0, $s0, $s5			# Dich bit
	addi	$a1, $s1, 0			# $a1 = $s1
	jal	batdau				# 
	beq	$v0, 0, vonglaptkmoi		# Vonglaptkmoi
	
	mul	$t1, $s4, 4 			# Tim thay mot ket qua phu hop o day 
	add	$t0, $s3, $t1			# Them phan bu hien tai vao
	sw	$s5, ($t0)			# Mang so nguyen $s3
	addi	$s4, $s4, 1			# Tang $ s4 va se tra lai sau
	
vonglaptkmoi:
	addi	$s5, $s5, 1			# $s5 tang 1
	j	vonglaptk			# Bat dau vong lap moi
	
timkiem_return:
	addi	$v0, $s4, 0			# $v0 = $s4
	lw	$ra, 4($sp)			# Khoi phuc dia chi tra hang
	addi	$sp, $sp, 4			# Va ngan xep
	jr	$ra
	
	
#################### chuc nang so sanh ####################
#
# 	nguyen mau: so sanh($a0, $a1, $a2)
# 	$a0: ky tu
# 	$a1: ky tu
# 	$a2: mode ( 1 neu phan biet chu hoa chu thuong, nguoc lai khong phan biet chu hoa chu thuong)
#
#	return 1 neu a0 = a1, nguoc lai tra ve 0
#
sosanh:
	beq	$a2, 1, sosanh_return		# sosanh_return
	beq	$a0, $a1, sosanh_return		# sosanh_return
	bge	$a0, 0x61, sosanh_a		# >= re nhanh sosanh_a
	bge	$a0, 0x41, sosanh_A		# >= re nhanh sosanh_A
	
sosanh_a:
	bgt	$a0, 0x7A, sosanh_return	# > re nhanh sosanh_return
	subi	$a0, $a0, 32			# Neu khong, $a0 van la chu thuong
	j	sosanh_return			# Nhay toi sosanh_return
	
sosanh_A:
	bgt	$a0, 0x5A, sosanh_return	# > re nhanh sosanh_return
	addi	$a0, $a0, 32			# Neu khong, $a0 van la chu hoa
	j	sosanh_return			# Nhay toi sosanh_return
	
sosanh_return:						
	seq	$v0, $a0, $a1 	 		# So sanh a0 va a1 sau khi sua doi
	jr	$ra				# Dat $pc thanh $ra


#################### chu nang strlen  ####################
#
# 	nguyen mau: strlen($a0)
# 	$a0: chuoi
#
#	return: chieu dai cua $a0
#
strlen:
	li	$v0, 0
strlen_loop:
	add	$t0, $a0, $v0			# Dich bit
	lb	$t1, ($t0)			# Lay du lieu ra t1 de doc
	beq	$t1, 0, strlen_return		# strlen_return
	beq	$t1, 0x0A, strlen_return	# strlen_return
	addi	$v0, $v0, 1			# $v0 = $v0 + 1
	j 	strlen_loop			# Nhay toi strlen_loop
strlen_return:
	jr	$ra
	
	
#################### chuc nang bat dau ####################
#
# 	nguyen mau: bat dau($a0, $a1, $a2)
# 	$a0: chuoi
#	$a1: chuoi
#	$a2: mode ( 1 neu phan biet chu hoa chu thuong, nguoc lai khong phan biet chu hoa chu thuong)
#
#	return: 1 neu $a0 duoc bat dau bang $a1
#

batdau:
	subi	$sp, $sp, 12			#
	sw	$ra, 12($sp)			# Luu dia chi tra hang
	sw	$s0, 8($sp)			# Luu dia chi $s0
	sw	$s1, 4($sp)			# Luu dia chi $s1
	addi	$s0, $a0, 0			# $s0 = $a0 
	addi	$s1, $a1, 0			# $s1 = $a1 
	
vonglapbatdau:
	lb	$a0, ($s0)			# Lay gia tri ra $a0
	lb	$a1, ($s1)			# Lay gia tri ra $a1
	beq	$a1, 0, batdau_return		# batdau_return
	beq	$a1, 0x0a, batdau_return	# batdau_return
	jal 	sosanh				# Nhay toi sosanh
	beq	$v0, 0, batdau_return		# batdau_return
	addi	$s0, $s0, 1			# $s0 = $s0 + 1
	addi	$s1, $s1, 1			# $s1 = $s1 + 1
	j	vonglapbatdau			# Nhay toi vonglapbatdau
	
batdau_return:
	lw	$s0, 8($sp)			# Khoi phuc $s0
	lw	$s1, 4($sp)			# Khoi phuc $s1
	lw	$ra, 12($sp)			# Khoi phuc dia chi tra hang
	addi	$sp, $sp, 12			# $sp = $sp + 12
	jr	$ra


#################### atoi  ####################
#
# 	nguyen mau: atoi($a0, $a1)
# 	$a0: int	
#	$a1: khoang trong de luu tru ket qua
#
#	return: do dai cua $a1
#
atoi:
	li	$v0, 1				# $v0 = 1
	li	$t0, 1				# $t0 = 1 
	addi	$t1, $a0, 0			# Sao chep $a0 thanh $t1 va $t2
	addi	$t2, $a0, 0			# Su dung $t1 de tinh do dai cua so va $t2 de luu tru tung so vao mang $a1
	li	$t5, 10				# $t5 = 10
atoi_loop1:
	div 	$t1, $t1, 10			# Lay do dai cua so
	beq	$t1, 0, atoi_loop2_prepare	# atoi_loop2_prepare
	addi	$v0, $v0, 1			# $v0 = $v0
	j	atoi_loop1			# Nhay toi atoi_loop1
	
atoi_loop2_prepare:
	add	$t3, $a1, $v0			
	sb	$0, ($t3)			# Luu du lieu 0 vao dia chi dau tien cua t3
atoi_loop2:
	div	$t2, $t5			# Voi moi lan chia $t2
	mfhi	$t4				# Lay phan con lai, chuyen no thanh ascii
	addi	$t4, $t4, 0x30			
	mflo	$t2				# Lay thuong so
	subi	$t3, $t3, 1			
	sb	$t4, ($t3)			
	beq	$t2, 0, atoi_return		# Tiep tuc vong lap neu so hien tai lon hon 0
	j	atoi_loop2			# Nhay toi atoi_loop2
atoi_return:
	jr	$ra
	

#################### chuc nang tham gia ####################
#
# 	nguyen mau: tham gia($a0, $a1, $a2, $a3)
# 	$a0: mang so nguyen
#	$a1: chieu dai ($a0) 
#	$a2: khoang trang, se luu tru ket qua tham gia
#	$a3: char, dau phan cach
#
#	return: do dai $a1 sau khi tham gia
#
thamgia:
	subi	$sp, $sp, 28			# Rat nhieu thu de tim kiem
	sw	$ra, 28($sp)			# Ta tiet kiem $ra va cac thanh ghi $s
	sw	$s0, 24($sp)			# Vi sau nay, ta se goi mot ham com (atoi)
	sw	$s1, 20($sp)				
	sw	$s2, 16($sp)				
	sw	$s3, 12($sp)				
	sw	$s4, 8($sp)				
	sw	$s5, 4($sp)				
	addi	$s0, $a0, 0			# $s0 = $a0
	addi	$s1, $a1, 0			# $s1 = $a1		
	addi	$s2, $a2, 0			# $s2 = $a2	
	addi	$s3, $a3, 0			# $s3 = $a3	
	li	$s4, 0				# $s4 = do dai cua chuoi ket qua
	li	$s5, 0				# $s5 = phan bu hien tai cua so trong mang $a2
	
vonglapthamgia:
	bge	$s5, $s1, thamgia_return	# >= re nhanh thamgia_return
	lw	$a0, ($s0)				
	addi	$a1, $s2, 0			# $a1 = $s2	
	jal	atoi				# Nhay toi atoi	
	add	$s4, $v0, $s4			# Bien doi so thanh chuoi, sau do them vao $s2
	add	$s2, $s2, $v0				
	sb	$s3, ($s2)			# Them ki tu phan cach
	add	$s2, $s2, 1			# Tang do dai
	add	$s4, $s4, 1				
							
	addi	$s0, $s0, 4				
	addi	$s5, $s5, 1			# Tang muc bu hien tai
	j	vonglapthamgia			# Tiep tuc vong lap

thamgia_return:
	sb	$0, -1($s2)			# Them ky tu NULL vao cuoi chuoi da noi
	lw	$ra, 28($sp)			# Khoi phuc tat ca dang ki da luu
	lw	$s0, 24($sp)				
	lw	$s1, 20($sp)				
	lw	$s2, 16($sp)				
	lw	$s3, 12($sp)				
	lw	$s4, 8($sp)				
	lw	$s5, 4($sp)				
	add	$sp, $sp, 28			# Khoi phuc ngan xep
	addi	$v0, $s4, 0			# return $s4
	jr	$ra
