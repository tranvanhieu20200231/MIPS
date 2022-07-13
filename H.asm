.data
Khoang_trang:	.asciiz " "	# Khoangtrang
Xuong_dong:	.asciiz	"\n"	# Xuong dong
Dau2cham:	.asciiz ": "	# : va khoang trang
Diem:	.word	0:1000		# Mang luu tru diem do dai 1000
Size:	.word	5		# So luong thuc te cac phan tu trong mang

Thongbao1:	.asciiz	"Nhap so sinh vien: "
Thongbao2:	.asciiz	"Hay nhap diem tung sinh vien"
Thongbao3:	.asciiz	"Nhap diem sinh vien #"
Thongbao4:	.asciiz "Sap xep diem theo thu tu tang dan: "

.text
.globl	main
main:
In_Thongbao1:
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Thongbao1		# Tai dia chi Thongbao1 vao $a0
	syscall				# Thuc hien
NhapDiem:
	li	$v0, 5			# $v0 = 5, nhap so nguyen
	syscall				# Thuc hien
	la	$t0, Size		# Tai dia chi mang Size vao $t0
	sw	$v0, 0($t0)		# Luu gia tri $v0 vao Size
In_Thongbao2:
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Thongbao2		# Tai dia chi Thongbao2 vao $a0
	syscall				# Thuc hien
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Xuong_dong		# Tai dia chi Xuong_dong vao $a0
	syscall				# Thuc hien
KTao_vong_lap:
	la	$t0, Diem		# Tai dia chi mang Diem vao $t0
	lw	$t1, Size		# Tai Size vao $t1
	li	$t2, 0			# Chay vong lap, i = 0
Vong_lap:
	bge	$t2, $t1, Kt_vong_lap	# Khi $t2 >= $t1, Kt_vong_lap
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Thongbao3 		# Tai dia chi Thongbao3 vao $a0
	syscall				# Thuc hien
	li	$v0, 1			# $v0 = 1, in so nguyen
	addi	$a0, $t2, 1		# $a0 = i + 1
	syscall				# Thuc hien
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Dau2cham		# Tai dia chi Dau2cham vao $a0
	syscall				# Thuc hien
	li	$v0, 5			# $v0 = 5, nhap so nguyen
	syscall				# Thuc hien
Diem_0_den_10:
	addi	$s0, $zero, 10		# $s0 = 10
	sge	$s1, $v0, $zero		# Khi $v0 >= 0, dung $s1 = 1, sai $s1 = 0
	sle	$s2, $v0, $s0		# Khi $v0 <= 10, dung $s2 = 1, sai $s2 = 0
	and	$s3, $s1, $s2		# Khi $s1 = $s2 = 1, dung $s3 = 1, sai $s3 = 0
	ble	$s3, $zero, Vong_lap	# Khi $s3 <= 0, Vong_lap
Cbi_Vlapmoi:
	sw	$v0, 0($t0)		# Luu gia tri tra ve vao mang Diem
	addi	$t0, $t0, 4		# A[n] = A[n+1]
	addi	$t2, $t2, 1		# i = i + 1
	j	Vong_lap		# Bat dau lai vong lap
Kt_vong_lap:
	jal	In			# Nhay den lenh In
KTao_SX:
	la	$t0, Diem		# Tai dia chi mang Diem vao $t0
	lw	$t1, Size		# Tai Size vao $t1
	li	$t2, 1			# Chay vong lap, i = 1
SX_lap1:
	la	$t0, Diem		# Tai dia chi mang Diem vao $t0
	bge	$t2, $t1, SX_lap1_KT	# Khi $t2 >= $t1, SX_lap1_KT
	move	$t3, $t2		# Sao chep $t2 vao $t3
SX_lap2:
	la	$t0, Diem		# Tai dia chi mang Diem vao $t0
	mul	$t5, $t3, 4		# Nhan $t3 voi 4 va luu vao $t5
	add	$t0, $t0, $t5		# Cong dia chi mang voi $t5
	ble	$t3, $zero, SX_lap2_KT	# Khi $t3 <= 0, SX_lap2_KT
	lw	$t7, 0($t0)		# Tai A[n] vao St7
	lw	$t6, -4($t0)		# Tai A[n-1] vao St6
	bge	$t7, $t6, SX_lap2_KT	# Khi A[n] >= A[n-1], SX_lap2_KT
	lw	$t4, 0($t0)		# Tai A[n] vao St4
	sw	$t6, 0($t0)		# Luu gia tri $t6 vao A[n]
	sw	$t4, -4($t0)		# Luu gia tri $t4 vao A[n-1]
	subi	$t3, $t3, 1		# Giam $t3 di 1
	j	SX_lap2			# Nhay den SX_lap2
SX_lap2_KT:
	addi	$t2, $t2, 1		# i = i + 1
	j	SX_lap1			# Nhay den SX_lap1
SX_lap1_KT:
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Thongbao4		# Tai dia chi Thongbao4 vao $a0
	syscall				# Thuc hien
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Xuong_dong		# Tai dia chi Xuong_dong vao $a0
	syscall				# Thuc hien
	jal	In			# Nhay den lenh In
Thoat:
	li	$v0, 10			# $v0 = 10, thoat
	syscall				# Thuc hien
In:
KTao_VLap_In:
	la	$t0, Diem		# Tai dia chi mang Diem vao $t0
	lw	$t1, Size		# Tai Size vao $t1
	li	$t2, 0			# i = 0
VLap_In:
	bge	$t2, $t1, KT_In		# Khi $t2 >= $t1, KT_In
	li	$v0, 1			# $v0 = 1, in so nguyen
	lw	$a0, 0($t0)		# Tai A[n] vao Sa0
	syscall				# Thuc hien
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Khoang_trang	# Tai dia chi Khoang_trang vao $a0
	syscall				# Thuc hien
	addi	$t0, $t0, 4		# A[n] = A[n+1]
	addi	$t2, $t2, 1		# i = i + 1
	j	VLap_In			# Nhay den VLap_In
KT_In:
	li	$v0, 4			# $v0 = 4, in chuoi
	la	$a0, Xuong_dong		# Tai dia chi Xuong_dong vao $a0
	syscall				# Thuc hien
	jr	$ra			# Nhay cung du lieu trong $ra
