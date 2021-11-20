//Saeed & Media
// 2021 - All rights resereved.

#include <ESP8266WiFi.h>

const byte LED_PIN = LED_BUILTIN;

const String WIFI_SSID = "The Cyan One"; 
const String PASSWORD = "October2020";

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

bool isConnectedToWiFi() 
{
  return WiFi.status() == WL_CONNECTED;
}

void connectingToWiFi()
{
  String message = "Connecting to " + WIFI_SSID + "! Please Wait.";
  Serial.println(message);
  int counter = 0;
  while (!isConnectedToWiFi())
  {
    delay(1000);
    Serial.println("!");
    counter++;
  }
  message = "Connected after " + String(counter) + " seconds.";
  Serial.print(message);
}

void performPattern(char* pattern) 
{
  int length = sizeof(pattern)/sizeof(pattern[0]);   
  for (int i = 0; i < pattern; i++) 
  {
     delay(100);
     if (pattern[i] == 's') {
        digitalWrite(LED_PIN, LOW);
        delay(100);
        digitalWrite(LED_PIN, HIGH);
     }
     else if (pattern[i] == 'l') 
     {
        digitalWrite(LED_PIN, LOW);
        delay(1000);
        digitalWrite(LED_PIN, HIGH);
     }
  }
}

void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, PASSWORD);
  connectingToWiFi();
  setPinModes();
}

void loop() { }
