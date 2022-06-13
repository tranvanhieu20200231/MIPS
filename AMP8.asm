.data 
Ten: 		.space  1000		# Mang ten do lon 1000
Diem:  		.word   0:100   	# Mang luu tru diem do dai 100
Dodai: 		.space  32		# Gioi han 31 ki tu
Thongbao1:  	.asciiz  "Nhap so sinh vien: "
Thongbao2:  	.asciiz  "Nhap ten sinh vien (toi da 31 ki tu): "
Thongbao3: 	.asciiz  "Nhap diem sinh vien (1-->10): "
Thongbao4:  	.asciiz  "Nhap thong tin sinh vien thu [ "
Thongbao5:  	.asciiz  " ]\n"
Thongbao6: 	.asciiz  "Ket qua thu duoc: \n"
Thongbao7: 	.asciiz  "diem: "
Thongbao8: 	.asciiz  "Diem (0 -> 10)\n"

.text
main:
#Khoi tao
	la 	$s1, Ten 		# Tai dia chi mang Ten vao $s1
	la 	$s3, Diem 		# Tai dia chi mang Diem vao $s3
	la 	$s7, Dodai 		# Tai dia chi mang Dodai vao $s7
	li  	$t0, 0 			# i = 0
	j 	NhapTT			# Nhay den NhapTT

KT_Nhap:
	addi 	$s4, $t3, -4 		# Luu dia chi cua Diem[n-1]
	addi 	$s5, $t2, -32 		# Luu dia chi cua Ten[n-1]
	j 	SX			# Nhay den SX
KT_SX:
	#In thong tin
	add 	$t2, $zero, $s1		# Tai gia tri cua $s1 vao $t2
	li 	$t0, 0			# i = 0
	add 	$t3, $s3, $zero 	# Tai gia tri cua $s3 vao $t3
	la    	$a0, Thongbao6		# Tai dia chi Thongbao6 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien
	j 	In			# Nhay den In
KT_In:
	li 	$v0, 10 		# $v0 = 10, thoat chuong trinh
	syscall				# Thuc hien
#=======================================================
#Chuong trinh con NhapTT
#Nhap so luong, ten va diem sinh vien
#=======================================================
NhapTT:
	#Nhap so sinh vien
	la  	$a0, Thongbao1		# Tai dia chi Thongbao1 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien
	li  	$v0, 5			# $v0 = 5, nhap so nguyen
	syscall				# Thuc hien
	addi  	$s2, $v0, 0 		# Luu so sinh vien vao $s2
	add 	$t2, $zero, $s1 	# $t2 luu dia chi Ten[n]
	add 	$t3, $zero, $s3 	# $t3 luu dia chi Diem[n]

Lap_Nhap:
	#Thoat vong lap
	slt 	$t5, $t0, $s2		# $t0 < $s2, dung $t5 = 1, sai $t5 = 0
	bne 	$t5, 1, KT_Nhap		# Khi $t5 = 0, KT_Nhap

	#Nhap du lieu
	la    	$a0, Thongbao4		# Tai dia chi Thongbao4 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien

	addi  	$a0, $t0, 1		# Luu i + 1 vao $a0
	li  	$v0, 1			# $v0 = 1, in so nguyen
	syscall				# Thuc hien	

	la    	$a0, Thongbao5		# Tai dia chi Thongbao5 vao $a0	
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien

	#Nhap ten sinh vien
	la  	$a0, Thongbao2		# Tai dia chi Thongbao2 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien
	li 	$v0, 8 			# $v0 = 8, nhap chuoi
	add 	$a0, $zero, $t2 	# Luu dia chi mang Ten vao $a0
	li 	$a1, 32 		# Do dai 31 ki tu
	syscall				# Thuc hien

	#Nhap diem sinh vien
	j 	Nhapdiem		# Nhay den nhapdiem
KTr_Diem:
	la  	$a0, Thongbao8		# Tai dia chi Thongbao8 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien
Nhapdiem:
	la  	$a0, Thongbao3		# Tai dia chi Thongbao3 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien
	li  	$v0, 5			# $v0 = 5, nhap so nguyen
	syscall				# Thuc hien
	sgt 	$t4, $v0, 10		# $v0 > 10, dung $t4 = 1, sai $t4 = 0
	bne 	$t4, 0, KTr_Diem	# $t4 = 1, KTr_Diem
	sw 	$v0, 0($t3)		# Luu gia tri $v0 vao Diem[n]

	addi 	$t0, $t0, 1		# i = i + 1
	sll 	$t1, $t0, 5		# Dich trai $t0 5 bit va luu vao $t1
	add 	$t2, $s1, $t1  		# Ten[n] = Ten[n+1]
	addi 	$t3, $t3, 4		# Diem[n] = Diem[n+1]

	j 	Lap_Nhap		# Nhay den Lap_Nhap
#=========================================================
#Chuong trinh con In
#In cac phan tu ra man hinh chinh
#=========================================================
In: 
	slt 	$t5, $t0, $s2		# $t0 < $s2, dung $t5 = 1, sai $t5 = 0
	bne 	$t5, 1, KT_In 	 	# Khi $t5 = 0, KT_In

	lw 	$a0, 0($t3)		# Tai Diem[n] vao Sa0
	li  	$v0, 1			# $v0 = 1, in so nguyen
	syscall				# Thuc hien

	la    	$a0, Thongbao7		# Tai dia chi Thongbao7 vao $a0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien

	la  	$a0, 0($t2)		# Tai Ten[n] vao Sa0
	li  	$v0, 4			# $v0 = 4, in chuoi
	syscall				# Thuc hien

	addi 	$t3, $t3, 4		# Diem[n] = Diem[n+1]
	addi 	$t0, $t0, 1		# i = i + 1
	sll 	$t1, $t0, 5		# Dich trai $t0 5 bit va luu vao $t1
	add 	$t2, $s1, $t1 		# Ten[n] = Ten[n+1]
	j 	In			# Nhay den In


#=================================================
#Chuong trinh con strcpy
#Luu ten sinh vien vao mang Ten
#$a0: dia chi dich 
#$a1: dia chi nguon
#=================================================
strcpy:
	li  	$t3, 0 			# $t3 = i = 0
L1:
	add 	$t4, $t3, $a0 		# $t4 = $t3 + $s1 = i + Ten[0]
	#Dia chi Ten[i]
	lb 	$t5, 0($t4) 		# Luu gia tri $t4 = y[i] vao $t5
	add 	$t6, $t3, $a1 		# $t6 = $t3 + $a1 = i + Dodai[0]
	#Dia chi Dodai[i]
	sb 	$t5, 0($t6) 		# Dodai[i] = $t5 = Ten[i]
	beq 	$t5, $zero, KT_strcpy	# Neu Ten[i] == 0, KT_strcpy
	nop				# Khong lam gi ca
	addi 	$t3, $t3, 1 		# i = i + 1
	j 	L1 			# Nhay den L1
	nop				# Khong lam gi ca
KT_strcpy:
	jr 	$ra			# Nhay cung du lieu trong $ra
#=====================================================
#Chuong trinh con sap xep
#Sap xep cac phan tu trong mang
#=====================================================
SX: 
	beq 	$s3, $s4, Xong 		# $s3 = $s4, Xong
	j 	Max 			# Nhay den max
KT_Max: 
	lw 	$t0, 0($s4) 		# Tai Diem[n-1] vao St0
	sw 	$t0, 0($v0) 		# Luu gia tri $t0 vao 0($v0)
	sw 	$v1, 0($s4) 		# Luu gia tri $v1 vao Diem[n-1]
	addi 	$s4, $s4, -4 		# Diem[n-1] = Diem[n-2]
	addi 	$a0, $s5, 0		# Luu dia chi Ten[n-1] vao $a0
	addi 	$a1, $s7, 0		# Luu dia chi Dodai[n] vao $a1
	jal 	strcpy 			# Luu gia tri Ten cuoi cung vao Dodai
	addi 	$a0, $t7, 0		# Luu dia chi hien tai cua Ten vao $a0
	addi 	$a1, $s5, 0		# Luu dia chi Ten[n-1] vao $a0
	jal 	strcpy 			# Luu gia tri Dodai vao con tro lon nhat
	addi 	$a0, $s7, 0		# Luu dia chi Dodai[n] vao $a1
	addi 	$a1, $t7, 0		# Luu dia chi hien tai cua Ten vao $a0
	jal 	strcpy 			# Luu gia tri Dodai vao con tro lon nhat
	addi 	$s5, $s5, -32		# Ten[n] = Ten[n-1]

	j 	SX 			# Nhay den SX
Xong: 
	j 	KT_SX			# Nhay den KT_SX
#---------------------------------------------------------------------
#Chuong trinh con Max
#Dung de sap xep ten theo diem thi
#$a0 con tro den phan tu dau tien
#$a1 con tro den phan tu cuoi cung
#---------------------------------------------------------------------
Max:
	addi 	$v0, $s3, 0 		# Con tro chi den phan tu dau tien
	lw 	$v1, 0($v0) 		# Con tro chi den gia tri dau tien
	addi 	$t0, $s3, 0 		# Con tro tiep theo
	addi 	$t7, $s1, 0 		# Con tro den phan tu cua Ten
	addi 	$t8, $s1, 0		# Con tro den phan tu tiep theo cua Ten

Lap_Max:
	beq 	$t0, $s4, return 	# Neu con tro tiep theo la cuoi cung, return
	addi 	$t0, $t0, 4 		# Tro den phan tu tiep theo
	addi 	$t8, $t8, 32 		# Chay con tro Ten theo con tro Diem
	lw 	$t1, 0($t0) 		# Tai phan tu tiep theo vao $t1
	slt 	$t2, $t1, $v1 		# $t1 < $v1, dung $t2 = 1, sai $t2 = 0
	bne 	$t2, $zero, Lap_Max 	# Neu $t2 = 1, Lap_Max
	addi 	$v0, $t0, 0 		# Phan tu tiep theo la phan tu toi da moi
	addi 	$t7, $t8, 0		# Dia chi hien tai = dia chi tiep theo
	addi 	$v1, $t1, 0 		# Gia tri tiep theo la gia tri toi da moi
	j 	Lap_Max 		# Nhay den Lap_Max
return:
	j 	KT_Max			# Nhay den KT_Max
