.data
	Nhap: 			.asciiz "Hay nhap mot dong lenh hop ngu: "
	TiepTuc: 		.asciiz "Ban co muon tiep tuc chuong trinh?\n(1.Yes/0.No):"
	Loi1: 			.asciiz "Lenh hop ngu khong hop le. Loi cu phap!\n"
	Loi2: 			.asciiz "Khong tim duoc khuon dang lenh nay!\n"
	Hoanthanh: 		.asciiz "\nHoan thanh! Lenh vua nhap vao phu hop voi cu phap!\n"
	Thongbao1: 		.asciiz "Opcode: "
	Thongbao2: 		.asciiz "Toan hang: "
	Thongbao3: 		.asciiz " hop le.\n"
	Chuky: 			.asciiz "So chu ky cua lenh la: "
	Yeucau: 		.space 100
	Opcode: 		.space 10
	Token: 			.space 20
	Number: 		.space 15
	Ident: 			.space 30
	# Quy luat cua thu vien la: Opcode co do dai = 5 byte
	# Moi lenh co 3 toan hang va chi co 4 loai la:
	# Khong co = 0
	# Thanh ghi = 1
	# Hang so nguyen = 2
	# Dinh danh = 3
	# Cau truc yeu cau: Opcode Toanhang1,Toanhang2,Toanhang3
	Thuvien1: 		.asciiz "ori**1121;or***1111;xor**1111;lui**1201;jr***1001;jal**3002;addi*1121;add**1111;sub**1111;and**1111;beq**1132;bne**1132;j****3002;nop**0001;"
	Thuvien2: 		.asciiz "qwertyuiopasdfghjklmnbvcxzQWERTYUIOPASDFGHJKLZXCVBNM_"
	Thuvien3: 		.asciiz "$zero $at   $v0   $v1   $a0   $a1   $a2   $a3   $t0   $t1   $t2   $t3   $t4   $t5   $t6   $t7   $s0   $s1   $s2   $s3   $s4   $s5   $s6   $s7   $t8   $t9   $k0   $k1   $gp   $sp   $fp   $ra   $0    $1    $2    $3    $4    $5    $7    $8    $9    $10   $11   $12   $13   $14   $15   $16   $17   $18   $19   $20   $21   $22   $23   $24   $25   $26   $27   $28   $29   $30   $31   "

.text
#<--Doc du lieu-->
ReadData: 				# Doc lenh nhap vao tu ban phim
	li 	$v0, 4			# $v0 = 4, in chuoi
	la 	$a0, Nhap		# Tai dia chi chuoi vao $a0
	syscall				# Thuc hien
	li 	$v0, 8			# $v0 = 8, nhap chuoi
	la 	$a0, Yeucau		# Chua dia chi cua lenh nhap vao
	li 	$a1, 100		# Do dai 100
	syscall				# Thuc hien
	
Main:
	li 	$t2, 0 			# t2 = i = 0
ReadOpcode: 				# Doc Opcode nhap vao
	la 	$a1, Opcode 		# Luu cac ki tu doc duoc vao Opcode
	add 	$t3, $a0, $t2 		# Dich bit
	add 	$t4, $a1, $t2		# Dich bit
	lb 	$t1, 0($t3) 		# Lay du lieu ra t1 de doc
	sb 	$t1, 0($t4)		# Luu du lieu t1 vao dia chi dau tien cua t4
	beq 	$t1, 32, Done 		# Gap ki tu ' ' -> luu ki tu nay vao Opcode de xu ly
	beq 	$t1, 0, Done 		# Ket thuc chuoi yeu cau
	addi 	$t2, $t2, 1		# i = i + 1
	j 	ReadOpcode		# Nhay den ReadOpcode
#<--Ket thuc doc du lieu-->

#<--Xu ly opcode-->
Done:					# Hoan thanh xu ly
	li 	$t7, -10		# t7 = -10 de khi thuc hien XulyOpcode thi t7 += 10 de t7 = 0
	la 	$a2, Thuvien1		# Tai dia chi chuoi vao $a2
XuLyOpcode: 				# Xu ly Opcode da nhap
	li 	$t1, 0 			# t1 = i = 0
	li 	$t2, 0 			# t2 = j = 0
	addi 	$t7, $t7, 10 		# Buoc nhay = 10 de den vi tri Opcode trong Thuvien1
	add 	$t1, $t1, $t7 		# Cong buoc nhay
	
	Compare:			# So sanh
	add 	$t3, $a2, $t1 		# t3 tro thanh con tro cua Thuvien1
	lb 	$s0, 0($t3)		# Lay gia tri ra s0
	beq 	$s0, 0, NotFound 	# Khong tim thay Opcode trong Thuvien1
	beq 	$s0, 42, Check 		# Gap ki tu '*' -> check xem Opcode co giong nhau tiep khong
	add 	$t4, $a1, $t2		# Dich bit
	lb 	$s1, 0($t4)		# Lay gia tri ra s1
	bne 	$s0, $s1, XuLyOpcode 	# So sanh 2 ki tu, dung thi so sanh tiep, sai thi nhay den phan tu chua khuon danh lenh tiep theo
	addi 	$t1, $t1, 1 		# i = i + 1
	addi 	$t2, $t2, 1 		# j = j + 1
	j 	Compare			# Nhay den Compare
	
	Check:				# Kiem tra Opcode
	add 	$t4, $a1, $t2		# Dich bit
	lb 	$s1, 0($t4)		# Lay gia tri ra s1
	bne 	$s1, 32, Check2 	# Neu ki tu tiep theo khong phai ' ' => lenh khong hop le, chi co doan hop le
	CheckContinue:			# Tiep tuc kiem tra Opcode
	add 	$t9, $t9, $t2 		# t9 = luu vi tri de xu ly token trong yeu cau
	li 	$v0, 4			# $v0 = 4, in chuoi
	la 	$a0, Thongbao1 		# Tai dia chi chuoi vao $a0
	syscall				# Thuc hien
	li 	$v0, 4			# $v0 = 4, in chuoi
	la 	$a0, Opcode		# Tai dia chi chuoi vao $a0
	syscall				# Thuc hien
	li 	$v0, 4			# $v0 = 4, in chuoi
	la 	$a0, Thongbao3		# Tai dia chi chuoi vao $a0
	syscall				# Thuc hien
	j 	ReadToanHang1		# Nhay den ReadToanHang1
	
	Check2: 			# neu ki tu tiep theo khong phai '\n' => lenh khong hop le, chi co doan dau hop le
	bne 	$s1, 10, NotFound	# Kiem tra khuon dang lenh
	j 	CheckContinue		# Nhay den CheckContinue
	
#<--Ket thuc xu ly opcode -->

#<--Xu li toan hang-->
ReadToanHang1:
	# Xac dinh kieu toan hang trong thu vien
	# t7 dang chua vi tri khuon dang lenh trong thu vien
	li 	$t1, 0			# Reset t1
	addi 	$t7, $t7, 5 		# Chuyen den vi tri ToanHang1 trong Thuvien1
	add 	$t1, $a2, $t7 		# a2 chua dia chi Thuvien1
	lb 	$s0, 0($t1)		# Lay gia tri ra s0
	addi 	$s0, $s0, -48 		# Chuyen tu char -> int
	li 	$t8, 1 			# Thanh ghi = 1
	beq 	$s0, $t8, CheckTokenReg	# Kiem tra
	li 	$t8, 2 			# Hang so nguyen = 2
	beq 	$s0, $t8, CheckHSN	# Kiem tra
	li 	$t8, 3 			# Dinh danh = 3
	beq 	$s0, $t8, CheckIdent	# Kiem tra
	li 	$t8, 0 			# Khong co toan hang = 0
	beq 	$s0, $t8, CheckNT	# Kiem tra
	j 	End			# Hoan thanh
	
#<--Check Token Register-->
CheckTokenReg:				# Kiem tra token da nhap
	la 	$a0, Yeucau		# Tai dia chi chuoi vao $a0
	la 	$a1, Token 		# Tai dia chi chuoi vao $a0
	li 	$t1, 0			# t1 = i = 0
	li 	$t2, -1			# t2 = j = -1
	addi 	$t1, $t9, 0		# Luu vi tri tiep theo can vao t1
	ReadToken:				# Doc token
		addi 	$t1, $t1, 1 		# i = i + 1
		addi 	$t2, $t2, 1 		# j = j + 1
		add 	$t3, $a0, $t1		# Dich bit
		add 	$t4, $a1, $t2		# Dich bit
		lb 	$s0, 0($t3)		# Lay gia tri ra s0
		add 	$t9, $zero, $t1 	# Vi tri toan hang tiep theo trong so sanh
		beq 	$s0, 44, ReadTokenDone 	# Gap dau ','
		beq 	$s0, 0, ReadTokenDone 	# Gap ki tu ket thuc
		sb 	$s0, 0($t4)		# Luu gia tri s0 vao dia chi dau tien cua t4
		j 	ReadToken		# Nhay den ReadToken
	
	ReadTokenDone:				# Doc token xong
		sb 	$s0, 0($t4) 		# Luu them ',' vao de so sanh
		li 	$t1, -1 		# i = -1
		li 	$t2, -1 		# j = -1
		li 	$t4, 0			# Reset t4
		li 	$t5, 0			# Reset t5
		add 	$t2, $t2, $k1		# Cong them buoc nhay
		la 	$a1, Token		# Tai dia chi chuoi vao $a1
		la 	$a2, Thuvien3		# Tai dia chi chuoi vao $a2
		j 	CompareToken		# Nhay den CompareToken

CompareToken:				# So sanh token
	addi 	$t1, $t1, 1		# i = i + 1
	addi 	$t2, $t2, 1		# j = j + 1
	add 	$t4, $a1, $t1		# Dich bit
	lb 	$s0, 0($t4)		# Lay gia tri ra s0
	beq 	$s0, 0, End		# Kiem tra
	add 	$t5, $a2, $t2		# Dich bit
	lb 	$s1, 0($t5)		# Lay gia tri ra s1
	beq 	$s1, 0, NotFound	# Gap ki tu ket thuc
	beq 	$s1, 32, CheckLegToken	# Gap ki tu ' '
	bne 	$s0, $s1, Jump		# Kiem tra
	j 	CompareToken		# Nhay den CompareToken
	
	CheckLegToken:			# Kiem tra do dai token
		beq 	$s0, 44, Compare1	# Gap dau ','
		beq 	$s0, 10, Compare1	# Kiem tra
		j 	Compare2		# Nhay den Compare2
	Jump:					# Nhay
		addi 	$k1, $k1, 6		# Step = Step + 6
		j 	ReadTokenDone		# Nhay den Compare2
	Compare1:				# So sanh
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Thongbao2 		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Token		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Thongbao3		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		addi 	$v1, $v1, 1 		# Dem so toan hang da doc
		li 	$k1, 0 			# Reset step
		beq 	$v1, 1, ReadToanHang2	# Neu da da doc toan hang 1 thi den toan hang 2
		beq 	$v1, 2, ReadToanHang3	# Neu da da doc toan hang 2 thi den toan hang 3
		beq 	$v1, 3, ReadChuKy	# Neu da da doc toan hang 3 thi kiem tra so chu ky
		j 	End			# Hoan thanh
	Compare2:				# Kiem tra
		j 	NotFound		# Khong tim thay
#<--Ket thuc Check Token Register-->

#<--Kiem tra toan hang la hang so nguyen-->
CheckHSN: 				# Kiem tra co phai hang so nguyen hay khong
	la 	$a0, Yeucau		# Tai dia chi chuoi vao $a0
	la 	$a1, Number 		# Tai dia chi chuoi vao $a0
	li 	$t1, 0			# t1 = i = 0
	li 	$t2, -1			# t2 = j = -1
	addi 	$t1, $t9, 0		# Luu vi tri tiep theo vao t1
	ReadNumber:			# Doc hang so nguyen
		addi 	$t1, $t1, 1 		# i = i + 1
		addi	$t2, $t2, 1 		# j = j + 1
		add 	$t3, $a0, $t1		# Dich bit
		add 	$t4, $a1, $t2		# Dich bit
		lb 	$s0, 0($t3)		# Lay gia tri ra s0
		add 	$t9, $zero, $t1 	# Vi tri toan hang tiep theo trong yeu cau
		beq 	$s0, 44, ReadNumberDone	# Gap dau ','
		beq 	$s0, 0, ReadNumberDone 	# Gap ki tu ket thuc
		sb 	$s0, 0($t4)		# Luu gia tri s0 vao dia chi dau tien cua t4
		j 	ReadNumber		# Nhay den ReadNumber
	ReadNumberDone:				# Hoan thanh doc hang so nguyen
		sb 	$s0, 0($t4) 		# Luu them ',' vao de so sanh
		li 	$t1, -1 		# i = -1
		li 	$t4, 0			# Reset t4
		la 	$a1, Number		# Tai dia chi chuoi vao $a0
		j 	CompareNumber		# Nhay den CompareNumber
CompareNumber:				# So sanh hang so nguyen
	addi 	$t1, $t1, 1		# i = i + 1
	add 	$t4, $a1, $t1		# Dich bit
	lb 	$s0, 0($t4)		# Lay gia tri ra s0
	beq 	$s0, 0, End		# Gap ki tu ket thuc
	beq 	$s0, 45, CompareNumber 	# Bo dau '-'
	beq 	$s0, 10, CompareNum1	# Neu gap '/n' hoac ',' thi ket thuc so sanh
	beq 	$s0, 44, CompareNum1	# Gap dau ','
	li 	$t2, 48			# t2 = 48
	li 	$t3, 57			# t3 = 57
	slt 	$t5, $s0, $t2		# So sanh va luu ket qua vao t5
	bne 	$t5, $zero, CompareNum2	# Kiem tra
	slt 	$t5, $t3, $s0		# So sanh va luu ket qua vao t5
	bne 	$t5, $zero, CompareNum2	# Kiem tra
	j 	CompareNumber		# Nhay den CompareNumber

	CompareNum1:
		la 	$a0, Thongbao2		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Number		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Thongbao3		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		addi 	$v1, $v1, 1 		# Dem so toan hang da doc
		li 	$k1, 0 			# Reset buoc nhay
		beq 	$v1, 1, ReadToanHang2	# Neu da da doc toan hang 1 thi den toan hang 2
		beq 	$v1, 2, ReadToanHang3	# Neu da da doc toan hang 2 thi den toan hang 3
		beq 	$v1, 3, ReadChuKy	# Neu da da doc toan hang 3 thi kiem tra so chu ky
		j 	End			# Hoan thanh
	CompareNum2:				# Kiem tra
		j 	NotFound		# Khong tim thay
#<--Ket thuc kiem tra toan hang la hang so nguyen-->

#<--Kiem tra dinh dang-->
CheckIdent:				# Kiem tra dinh dang
	la 	$a0, Yeucau		# Tai dia chi chuoi vao $a0
	la 	$a1, Ident 		# Tai dia chi chuoi vao $a0
	li 	$t1, 0			# t1 = i = 0
	li 	$t2, -1			# t2 = j = -1
	addi 	$t1, $t9, 0		# Luu vi tri tiep theo vao t1
	ReadIndent:			# Doc dinh dang
		addi 	$t1, $t1, 1 		# i = i + 1
		addi 	$t2, $t2, 1 		# j = j + 1
		add 	$t3, $a0, $t1		# Dich bit
		add 	$t4, $a1, $t2		# Dich bit
		lb 	$s0, 0($t3)		# Lay gia tri ra s0
		add 	$t9, $zero, $t1 	# Vi tri toan hang tiep theo trong yeu cau
		beq 	$s0, 44, ReadIdentDone 	# Gap dau ','
		beq 	$s0, 0, ReadIdentDone 	# Gap ki tu ket thuc
		sb 	$s0, 0($t4)		# Luu gia tri s0 vao dia chi dau tien cua t4
		j 	ReadIndent		# Nhay den ReadIndent
	ReadIdentDone:				# Doc dinh dang xong
		sb 	$s0, 0($t4) 		# Luu them ',' vao de so sanh
		Loopj:				# Vong lap j
		li 	$t1, -1 		# i = -1
		li 	$t2, -1 		# j = -1
		li 	$t4, 0			# Reset t4
		li 	$t5, 0			# Reset t5
		add 	$t1, $t1, $k1		# Cong them buoc nhay
		la 	$a1, Ident		# Tai dia chi chuoi vao $a0
		la 	$a2, Thuvien2		# Tai dia chi chuoi vao $a0
		j 	CompareIdent		# Nhay den CompareIdent
CompareIdent:				# So sanh dinh dang
	addi 	$t1, $t1, 1		# i = i + 1
	add 	$t4, $a1, $t1		# Dich bit
	lb 	$s0, 0($t4)		# Lay gia tri ra s0
	beq 	$s0, 0, End		# Gap ki tu ket thuc
	beq 	$s0, 10, CompareIdent1	# Neu gap '/n' hoac ',' thi ket thuc so sanh
	beq 	$s0, 44, CompareIdent1	# Gap dau ','
	Loop:				
	addi 	$t2, $t2, 1		# j = j + 1
	add 	$t5, $a2, $t2		# Dich bit
	lb 	$s1, 0($t5)		# Lay gia tri ra s1
	beq 	$s1, 0, CompareIdent2	# Gap ki tu ket thuc
	beq 	$s0, $s1, JumpIdent 	# So sanh ki tu tiep theo trong dinh dang
	j 	Loop 			# Tiep tuc so sanh ki tu tiep theo trong Thuvien2
	
	JumpIdent:
		addi 	$k1, $k1, 1		# Step = step + 1
		j 	Loopj			# Nhay den Loopj
		
	CompareIdent1:
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Thongbao2 		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Ident		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		li 	$v0, 4			# $v0 = 4, in chuoi
		la 	$a0, Thongbao3		# Tai dia chi chuoi vao $a0
		syscall				# Thuc hien
		addi 	$v1, $v1, 1 		# dem so toan hang da doc.
		li 	$k1, 0 			# reset buoc nhay
		beq 	$v1, 1, ReadToanHang2	# Neu da da doc toan hang 1 thi den toan hang 2
		beq 	$v1, 2, ReadToanHang3	# Neu da da doc toan hang 2 thi den toan hang 3
		beq 	$v1, 3, ReadChuKy	# Neu da da doc toan hang 3 thi kiem tra so chu ky
		j 	End			# Hoan thanh
	CompareIdent2:				# Kiem tra
		j 	NotFound		# Khong tim thay
#<--Ket thuc kiem tra dinh dang-->

#<--Kiem tra khong co toan hang-->
CheckNT:				# Kiem tra khong co toan hang
	la 	$a0, Yeucau		# Tai dia chi chuoi vao $a0
	li 	$t1, 0			# Reset t1
	li 	$t2, 0			# Reset t2
	addi 	$t1, $t9, 0		# Luu vi tri tiep theo vao t1
	add 	$t2, $a0, $t1		# Dich bit
	lb 	$s0, 0($t2)		# Lay gia tri ra s0
	addi 	$v1, $v1, 1 		# Dem so toan hang da doc.
	li 	$k1, 0 			# Reset buoc nhay
	beq 	$v1, 1, ReadToanHang2	# Neu da da doc toan hang 1 thi den toan hang 2
	beq 	$v1, 2, ReadToanHang3	# Neu da da doc toan hang 2 thi den toan hang 3
	beq 	$v1, 3, ReadChuKy	# Neu da da doc toan hang 3 thi kiem tra so chu ky
#<!--Ket thuc kiem tra khong co toan hang-->

#<--Check Token Register 2-->
ReadToanHang2:
	# xac dinh kieu toan hang trong thu vien
	# t7 dang chua vi tri khuon dang lenh trong thu vien
	li 	$t1, 0			# Reset t0
	la 	$a2, Thuvien1		# Tai dia chi chuoi vao $a2
	addi 	$t7, $t7, 1 		# Chuyen den vi tri toan hang 2 trong Thuvien1
	add 	$t1, $a2, $t7 		# a2 chua dia chi Thuvien1
	lb 	$s0, 0($t1)		# Lay gia tri ra s0
	addi 	$s0,$s0,-48 		# Chuyen tu char -> int
	li 	$t8, 1 			# Thanh ghi = 1
	beq 	$s0, $t8, CheckTokenReg	# Kiem tra
	li 	$t8, 2 			# Hang so nguyen = 2
	beq 	$s0, $t8, CheckHSN	# Kiem tra
	li 	$t8, 3 			# Dinh danh = 3
	beq 	$s0, $t8, CheckIdent	# Kiem tra
	li 	$t8, 0 			# Khong co toan hang = 0
	beq 	$s0, $t8, CheckNT	# Kiem tra
	j 	End			# Hoan thanh
#<--Ket thuc Check Token Register 2-->

#<--Check Token Register 3-->
ReadToanHang3:
	# Xac dinh kieu toan hang trong thu vien
	# t7 dang chua vi tri khuon dang lenh trong thu vien
	li 	$t1, 0			# Reset t0
	la 	$a2, Thuvien1		# Tai dia chi chuoi vao $a2
	addi 	$t7, $t7, 1 		# Chuyen den vi tri toan hang 3 trong Thuvien1
	add 	$t1, $a2, $t7 		# a2 chua dia chi library
	lb 	$s0, 0($t1)		# Lay gia tri ra s0
	addi 	$s0, $s0, -48 		# Chuyen tu char -> int
	li 	$t8, 1 			# Thanh ghi = 1
	beq 	$s0, $t8, CheckTokenReg	# Kiem tra
	li 	$t8, 2 			# Hang so nguyen = 2
	beq 	$s0, $t8, CheckHSN	# Kiem tra
	li 	$t8, 3 			# Dinh danh = 3
	beq 	$s0, $t8, CheckIdent	# Kiem tra
	li 	$t8, 0 			# Khong co toan hang = 0
	beq 	$s0, $t8, CheckNT	# Kiem tra
	j 	End			# Hoan thanh
#<--Ket thuc check Token Register 3-->
#<--Kiem tra chu ki cua lenh-->
ReadChuKy:
	# Xac dinh kieu toan hang trong thu vien
	# t7 dang chua vi tri khuon dang lenh trong thu vien
	li 	$t1, 0			
	la 	$a2, Thuvien1		# Tai dia chi chuoi vao $a0
	addi 	$t7, $t7, 1 		# Chuyen den vi tri toan hang 4 trong Thuvien1
	add 	$t1, $a2, $t7 		# a2 chua dia chi library
	lb 	$s0, 0($t1)		# Lay gia tri ra s0
	addi 	$s0, $s0, -48 		# Chuyen tu char -> int
	li 	$v0, 4			# $v0 = 4, in chuoi
	la 	$a0, Chuky		# Tai dia chi chuoi vao $a0
	syscall				# Thuc hien
	li 	$v0, 1			# $v0 = 1, in so nguyen
	li 	$a0, 0			# $a0 = 0
	add 	$a0, $s0, $zero		# Tai dia chi $s0 vao $a0
	syscall				# Thuc hien
	j 	End			# Hoan thanh chuong trinh
#<--Ket thuc kiem tra chu ki cua lenh-->

#<--Ket thuc xu li toan hang-->

#<--Tinh nang cua chuong trinh-->
Continue: 				# Lap lai chuong trinh.
	li 	$v0, 4			# $v0 = 4, in chuoi
	la 	$a0, TiepTuc		# Tai dia chi chuoi vao $a0
	syscall				# Thuc hien
	li 	$v0, 5			# $v0 = 5, nhap so nguyen
	syscall				# Thuc hien
	add 	$t0, $v0, $zero		# Dua gia tri nhap vao t0
	bne 	$t0, $zero, ResetAll	# Kiem tra Yes hay No
	j 	TheEnd			# Ket thuc chuong trinh
ResetAll: 				# Dua tat ca thanh ghi ve gia tri ban dau
	li $v0, 0
	li $v1, 0
	li $a0, 0
	li $a1, 0
	li $a2, 0			
	li $a3, 0			
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	li $k0, 0
	li $k1, 0
	j  ReadData		# Bat dau chuong trinh moi
NotFound:			# Khong dung dinh dang
	li $v0, 4		# $v0 = 4, in chuoi
	la $a0, Loi2		# Tai dia chi chuoi vao $a0
	syscall			# Thuc hien
	j  TheEnd		# Ket thuc chuong trinh
Error:				# Khong tim duoc khuon dang phu hop
	li $v0, 4		# $v0 = 4, in chuoi
	la $a0, Loi1		# Tai dia chi chuoi vao $a0
	syscall			# Thuc hien
	j  TheEnd		# Ket thuc chuong trinh
End:				# Hoan thanh chuong trinhf
	li $v0, 4		# $v0 = 4, in chuoi
	la $a0, Hoanthanh	# Tai dia chi chuoi vao $a0	
	syscall			# Thuc hien
	j  Continue		# Tiep tuc chuong trinh
TheEnd:				# Ket thuc chuong trinh
#<--Ket thuc tinh nang cua chuong trinh-->
