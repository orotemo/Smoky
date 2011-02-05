//example use of LCD4Bit_mod library

#include <LCD4Bit_mod.h> 
#include <avr/pgmspace.h>

//create object to control an LCD.  
//number of lines in display=1
LCD4Bit_mod lcd = LCD4Bit_mod(2); 

//Key message
PROGMEM prog_char msg_0[] = "Right Key OK ";
PROGMEM prog_char msg_1[] = "Up Key OK    ";
PROGMEM prog_char msg_2[] = "Down Key OK  ";
PROGMEM prog_char msg_3[] = "Left Key OK  ";
PROGMEM prog_char msg_4[] = "Select Key OK";

PROGMEM const char *msgs[] = {msg_0, msg_1, msg_2, msg_3, msg_4};
char msg_buffer[32];
int  adc_key_val[5] ={
  30, 150, 360, 535, 760 };
int NUM_KEYS = 5;
int adc_key_in;
int key=-1;
int oldkey=-1;

void setup() { 
  pinMode(13, OUTPUT);  //we'll use the debug LED to output a heartbeat

  lcd.init();
  //optionally, now set up our application-specific display settings, overriding whatever the lcd did in lcd.init()
  //lcd.commandWrite(0x0F);//cursor on, display on, blink on.  (nasty!)
  lcd.clear();
  lcd.printIn("KEYPAD testing... pressing");

}

void loop() {

  adc_key_in = analogRead(0);    // read the value from the sensor  
  digitalWrite(13, HIGH);  
  key = get_key(adc_key_in);		        // convert into key press

  if (key != oldkey)				    // if keypress is detected
  {
    delay(50);		// wait for debounce time
    adc_key_in = analogRead(0);    // read the value from the sensor  
    key = get_key(adc_key_in);		        // convert into key press
    if (key != oldkey)				
    {			
      oldkey = key;
      if (key >=0){
        lcd.cursorTo(2, 0);  //line=2, x=0
        lcd.printIn(read_msg(key));
      }
    }
  }

  //delay(1000);
  digitalWrite(13, LOW);





}

// Convert ADC value to key number
int get_key(unsigned int input)
{
  int k;

  for (k = 0; k < NUM_KEYS; k++)
  {
    if (input < adc_key_val[k])
    {

      return k;
    }
  }

  if (k >= NUM_KEYS)
    k = -1;     // No valid key pressed

  return k;
}

char* read_msg(int at)
{
    strcpy_P(msg_buffer, (char*)pgm_read_word(&(msgs[at])));
    return msg_buffer;
}

