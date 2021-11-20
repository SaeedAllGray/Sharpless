//Saeed & Media
// 2021 - All rights resereved.

#include <EEPROM.h>

const byte LED_PIN = LED_BUILTIN;

ADC_MODE(ADC_VCC);

void setPinModes() 
{
  pinMode(LED_PIN, OUTPUT);
}

bool batteryNeedsReplacing() 
{
  float voltage = ESP.getVcc();
  return voltage < 3.7;
}

void setup() {
  Serial.begin(9600);
  setPinModes();
}

void loop() {}
