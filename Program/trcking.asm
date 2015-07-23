
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;trcking.c,25 :: 		interrupt()
;trcking.c,27 :: 		rr = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _rr+0
	CLRF       _rr+1
;trcking.c,28 :: 		switch(rr)
	GOTO       L_interrupt0
;trcking.c,30 :: 		case '$':
L_interrupt2:
;trcking.c,32 :: 		v=1;
	MOVLW      1
	MOVWF      _v+0
;trcking.c,33 :: 		i=0;
	CLRF       _i+0
	CLRF       _i+1
;trcking.c,34 :: 		break;
	GOTO       L_interrupt1
;trcking.c,37 :: 		case 'G':
L_interrupt3:
;trcking.c,39 :: 		if(v<6)
	MOVLW      6
	SUBWF      _v+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt4
;trcking.c,41 :: 		v++;
	INCF       _v+0, 1
;trcking.c,42 :: 		break;
	GOTO       L_interrupt1
;trcking.c,43 :: 		}
L_interrupt4:
;trcking.c,45 :: 		case 'P':
L_interrupt5:
;trcking.c,47 :: 		if(v==2)
	MOVF       _v+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;trcking.c,48 :: 		v=3;
	MOVLW      3
	MOVWF      _v+0
L_interrupt6:
;trcking.c,49 :: 		break;
	GOTO       L_interrupt1
;trcking.c,52 :: 		case 'A':
L_interrupt7:
;trcking.c,54 :: 		if(v==5)
	MOVF       _v+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;trcking.c,55 :: 		v=6;
	MOVLW      6
	MOVWF      _v+0
L_interrupt8:
;trcking.c,56 :: 		break;
	GOTO       L_interrupt1
;trcking.c,58 :: 		}
L_interrupt0:
	MOVLW      0
	XORWF      _rr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt40
	MOVLW      36
	XORWF      _rr+0, 0
L__interrupt40:
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt2
	MOVLW      0
	XORWF      _rr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt41
	MOVLW      71
	XORWF      _rr+0, 0
L__interrupt41:
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
	MOVLW      0
	XORWF      _rr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt42
	MOVLW      80
	XORWF      _rr+0, 0
L__interrupt42:
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt5
	MOVLW      0
	XORWF      _rr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt43
	MOVLW      65
	XORWF      _rr+0, 0
L__interrupt43:
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
L_interrupt1:
;trcking.c,59 :: 		if (v==6){
	MOVF       _v+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt9
;trcking.c,60 :: 		i++;
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;trcking.c,61 :: 		rec[i] = rr;
	MOVF       _i+0, 0
	ADDLW      _rec+0
	MOVWF      FSR
	MOVF       _rr+0, 0
	MOVWF      INDF+0
;trcking.c,62 :: 		}
L_interrupt9:
;trcking.c,64 :: 		}
L_end_interrupt:
L__interrupt39:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;trcking.c,66 :: 		void main() {
;trcking.c,69 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;trcking.c,70 :: 		INTCON=0b11000000;
	MOVLW      192
	MOVWF      INTCON+0
;trcking.c,71 :: 		PIE1=0b00100100;
	MOVLW      36
	MOVWF      PIE1+0
;trcking.c,72 :: 		T1CON=0b00000111;
	MOVLW      7
	MOVWF      T1CON+0
;trcking.c,73 :: 		TMR1H=0;
	CLRF       TMR1H+0
;trcking.c,74 :: 		TMR1L=0;
	CLRF       TMR1L+0
;trcking.c,75 :: 		portd.f0=0;
	BCF        PORTD+0, 0
;trcking.c,76 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;trcking.c,77 :: 		lcd_cmd(_LCD_CURSOR_OFF);              // Initialize UART module at 9600 bps
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;trcking.c,78 :: 		Delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
;trcking.c,79 :: 		TRISD=0b00000010;
	MOVLW      2
	MOVWF      TRISD+0
;trcking.c,80 :: 		PORTD=0b11111100;
	MOVLW      252
	MOVWF      PORTD+0
;trcking.c,81 :: 		portd.f4=0;                         //gps
	BCF        PORTD+0, 4
;trcking.c,82 :: 		portd.f2=0;                         //gsm
	BCF        PORTD+0, 2
;trcking.c,84 :: 		TRISC=0;
	CLRF       TRISC+0
;trcking.c,85 :: 		portc.f4=1;
	BSF        PORTC+0, 4
;trcking.c,86 :: 		delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
	NOP
;trcking.c,87 :: 		TRISC=255;
	MOVLW      255
	MOVWF      TRISC+0
;trcking.c,88 :: 		delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
	NOP
;trcking.c,89 :: 		for(;;){
L_main13:
;trcking.c,90 :: 		lcd_chr(1,1,rec[14]);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _rec+14, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;trcking.c,91 :: 		for (r=15;r<23;r++){
	MOVLW      15
	MOVWF      main_r_L0+0
L_main16:
	MOVLW      23
	SUBWF      main_r_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;trcking.c,92 :: 		lcd_chr_cp(rec[r]);
	MOVF       main_r_L0+0, 0
	ADDLW      _rec+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;trcking.c,91 :: 		for (r=15;r<23;r++){
	INCF       main_r_L0+0, 1
;trcking.c,93 :: 		}
	GOTO       L_main16
L_main17:
;trcking.c,95 :: 		lcd_chr(2,1,rec[26]);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _rec+26, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;trcking.c,96 :: 		for (r=27;r<36;r++){
	MOVLW      27
	MOVWF      main_r_L0+0
L_main19:
	MOVLW      36
	SUBWF      main_r_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main20
;trcking.c,97 :: 		lcd_chr_cp(rec[r]);
	MOVF       main_r_L0+0, 0
	ADDLW      _rec+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;trcking.c,96 :: 		for (r=27;r<36;r++){
	INCF       main_r_L0+0, 1
;trcking.c,98 :: 		}
	GOTO       L_main19
L_main20:
;trcking.c,99 :: 		x= TMR1H<<8|TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _x+0
	MOVF       R0+1, 0
	MOVWF      _x+1
;trcking.c,100 :: 		IntToStr(x, txt);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;trcking.c,101 :: 		lcd_out(2,1,txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;trcking.c,102 :: 		if(portc.f5==0){
	BTFSC      PORTC+0, 5
	GOTO       L_main22
;trcking.c,103 :: 		portd.f0=1;
	BSF        PORTD+0, 0
;trcking.c,104 :: 		}
L_main22:
;trcking.c,105 :: 		if(portd.f1==0){
	BTFSC      PORTD+0, 1
	GOTO       L_main23
;trcking.c,106 :: 		while(portd.f1==0){}
L_main24:
	BTFSC      PORTD+0, 1
	GOTO       L_main25
	GOTO       L_main24
L_main25:
;trcking.c,107 :: 		delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main26:
	DECFSZ     R13+0, 1
	GOTO       L_main26
	DECFSZ     R12+0, 1
	GOTO       L_main26
	DECFSZ     R11+0, 1
	GOTO       L_main26
	NOP
	NOP
;trcking.c,108 :: 		UART1_WRITE_TEXT("AT+CMGF=1");
	MOVLW      ?lstr1_trcking+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;trcking.c,109 :: 		UART1_WRITE(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;trcking.c,110 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
;trcking.c,111 :: 		UART1_WRITE_TEXT(we);
	MOVLW      _we+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;trcking.c,112 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
;trcking.c,113 :: 		UART1_WRITE_TEXT("Latu:");
	MOVLW      ?lstr2_trcking+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;trcking.c,114 :: 		for (r=14;r<23;r++){
	MOVLW      14
	MOVWF      main_r_L0+0
L_main29:
	MOVLW      23
	SUBWF      main_r_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main30
;trcking.c,115 :: 		UART1_WRITE(rec[r]);
	MOVF       main_r_L0+0, 0
	ADDLW      _rec+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;trcking.c,114 :: 		for (r=14;r<23;r++){
	INCF       main_r_L0+0, 1
;trcking.c,116 :: 		}
	GOTO       L_main29
L_main30:
;trcking.c,117 :: 		UART1_WRITE(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;trcking.c,118 :: 		UART1_WRITE_TEXT("Long:");
	MOVLW      ?lstr3_trcking+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;trcking.c,119 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
	DECFSZ     R12+0, 1
	GOTO       L_main32
	DECFSZ     R11+0, 1
	GOTO       L_main32
;trcking.c,120 :: 		for (r=26;r<36;r++){
	MOVLW      26
	MOVWF      main_r_L0+0
L_main33:
	MOVLW      36
	SUBWF      main_r_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main34
;trcking.c,121 :: 		UART1_WRITE(rec[r]);
	MOVF       main_r_L0+0, 0
	ADDLW      _rec+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;trcking.c,120 :: 		for (r=26;r<36;r++){
	INCF       main_r_L0+0, 1
;trcking.c,122 :: 		}
	GOTO       L_main33
L_main34:
;trcking.c,123 :: 		UART1_WRITE(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;trcking.c,124 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
;trcking.c,125 :: 		UART1_WRITE(26);
	MOVLW      26
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;trcking.c,126 :: 		delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
	DECFSZ     R11+0, 1
	GOTO       L_main37
	NOP
	NOP
;trcking.c,127 :: 		}
L_main23:
;trcking.c,128 :: 		}
	GOTO       L_main13
;trcking.c,129 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
