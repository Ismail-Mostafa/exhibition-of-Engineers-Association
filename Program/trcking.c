char rec[80];                                 // nemory to save the location
int i=0;                                       // the element pointer of array
int x=0,rr;                                      // flag of interrupt
char GP=0;
                                // counter of coma
char we[25]={'A','T','+','C','M','G','S','=','"','0','1','0','0','7','0','1','7','5','9','5','"',13,0};

unsigned short int v=0;

  // LCD
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D4 at RB0_bit;

// Pin direction
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;
interrupt()
{
rr = UART1_Read();
switch(rr)
{
case '$':
   {
    v=1;
    i=0;
    break;
    }

  case 'G':
   {
   if(v<6)
   {
    v++;
    break;
   }
   }
case 'P':
   {
    if(v==2)
    v=3;
    break;
   }

case 'A':
    {
    if(v==5)
    v=6;
    break;
    }
}
if (v==6){
 i++;
rec[i] = rr;
}

 }

void main() {
char txt[7];
char r;
Lcd_Init();
INTCON=0b11000000;
PIE1=0b00100100;
T1CON=0b00000111;
TMR1H=0;
TMR1L=0;
 portd.f0=0;
UART1_Init(9600); 
lcd_cmd(_LCD_CURSOR_OFF);              // Initialize UART module at 9600 bps
Delay_ms(300);
TRISD=0b00000010;
PORTD=0b11111100;
portd.f4=0;                         //gps
portd.f2=0;                         //gsm
//portd.f0=0;
TRISC=0;
portc.f4=1;
delay_ms(2000);
TRISC=255;
delay_ms(2000);
for(;;){
    lcd_chr(1,1,rec[14]);
    for (r=15;r<23;r++){
    lcd_chr_cp(rec[r]);
    }

    lcd_chr(2,1,rec[26]);
    for (r=27;r<36;r++){
    lcd_chr_cp(rec[r]);
    }
    x= TMR1H<<8|TMR1L;
    IntToStr(x, txt);
    lcd_out(2,1,txt);
     if(portc.f5==0){
     portd.f0=1;
     }
if(portd.f1==0){
    while(portd.f1==0){}
    delay_ms(2000);
    UART1_WRITE_TEXT("AT+CMGF=1");
    UART1_WRITE(13);
    delay_ms(300);
    UART1_WRITE_TEXT(we);
    delay_ms(300);
    UART1_WRITE_TEXT("Latu:");
    for (r=14;r<23;r++){
    UART1_WRITE(rec[r]);
    }
    UART1_WRITE(13);
    UART1_WRITE_TEXT("Long:");
    delay_ms(300);
    for (r=26;r<36;r++){
    UART1_WRITE(rec[r]);
    }
    UART1_WRITE(13);
    delay_ms(300);
    UART1_WRITE(26);
    delay_ms(1000);
    }
   }
}