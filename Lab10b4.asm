.eqv KEY_CODE 0xFFFF0004       # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000      # =1 if has a new keycode ?
                               # Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C   # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008  # =1 if the display has already to do
                               # Auto clear after sw
.data
exitstr: .asciiz "exit"                             
.text
     li 	$k0, KEY_CODE
     li 	$k1, KEY_READY
     li 	$s0, DISPLAY_CODE
     li 	$s1, DISPLAY_READY

     li 	$t5, 0                     	# i = 0
     la 	$t4, exitstr
WaitForKey: 
     lw 	$t1, 0($k1)                	# $t1 = [$k1] = KEY_READY
     beq 	$t1, $zero, WaitForKey    	# if $t1 == 0 keep waiting
ReadKey: 
     lw 	$t0, 0($k0)                	# $t0 = [$k0] = KEY_CODE    
WaitForDis: 
     lw 	$t2, 0($s1)                	# $t2 = [$s1] = DISPLAY_READY
     beq 	$t2, $zero, WaitForDis    	# if $t2 == 0 keep waiting
ShowKey: 
     sw 	$t0, 0($s0)                	# show key
checkexit:
     add 	$t6, $t4, $t5             	# exitstr + i
     lb 	$t7, 0($t6)
     bne 	$t0, $t7, notequal        	# kiểm tra giá trị nhập vào có bằng kí tự 
                                   		# tại đang xét không
     addi 	$t5, $t5, 1              	# i ++
     bge 	$t5, 4, Exit               		# nếu người dùng nhập "exit" thì dừng chương trình
     j 		WaitForKey
     
notequal:
     add 	$t5, $zero, $zero          	# i = 0
     j 		WaitForKey
Exit:
     li 	$v0, 10
     syscall
     
