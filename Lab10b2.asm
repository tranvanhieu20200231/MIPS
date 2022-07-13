# unit width in pixels 16
# unit height in pixels 16
# display width in pixels 512
# display height in pixels 512

.eqv MONITOR_SCREEN 0x10010000 #Dia chi bat dau cua bo nho man hinh
.eqv WHITE 0x00FFFFFF
.eqv RED 0x00FF0000

.text
     li $k0, MONITOR_SCREEN    #Nap dia chi bat dau cua man hinh
     
     # i
     li $t0, WHITE
     sw $t0, 648($k0)
     sw $t0, 652($k0)
     sw $t0, 656($k0)
     sw $t0, 780($k0)
     sw $t0, 908($k0)
     sw $t0, 1036($k0)
     sw $t0, 1164($k0)
     sw $t0, 1288($k0)
     sw $t0, 1292($k0)
     sw $t0, 1296($k0)
     nop
     
     # heart
     li $t0, RED
     sw $t0, 1072($k0)
     sw $t0, 940($k0)
     sw $t0, 808($k0)
     sw $t0, 804($k0)
     sw $t0, 928($k0)
     sw $t0, 1052($k0)
     sw $t0, 1180($k0)
     sw $t0, 1312($k0)
     sw $t0, 1444($k0)
     sw $t0, 1576($k0)
     sw $t0, 1708($k0)
     sw $t0, 1840($k0)
     
     sw $t0, 948($k0)
     sw $t0, 824($k0)
     sw $t0, 828($k0)
     sw $t0, 960($k0)
     sw $t0, 1092($k0)
     sw $t0, 1220($k0)
     sw $t0, 1344($k0)
     sw $t0, 1468($k0)
     sw $t0, 1592($k0)
     sw $t0, 1716($k0)
     
     li $t0, WHITE
     sw $t0, 1060($k0)

    # B
    li $t0, WHITE
    sw $t0, 1360($k0)
    sw $t0, 1232($k0)
    sw $t0, 1104($k0)
    sw $t0, 976($k0)
    sw $t0, 848($k0)
    sw $t0, 720($k0)
    sw $t0, 724($k0)
    sw $t0, 856($k0)
    sw $t0, 980($k0)
    sw $t0, 1112($k0)
    sw $t0, 1240($k0)
    sw $t0, 1364($k0)
    
    # K
    sw $t0, 1380($k0)
    sw $t0, 1252($k0)
    sw $t0, 1124($k0)
    sw $t0, 996($k0)
    sw $t0, 868($k0)
    sw $t0, 740($k0)
    
    sw $t0, 752($k0)
    sw $t0, 876($k0)
    sw $t0, 1000($k0)
    sw $t0, 1132($k0)
    sw $t0, 1264($k0)
    sw $t0, 1396($k0)