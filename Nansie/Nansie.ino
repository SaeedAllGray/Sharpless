//Saeed & Media
// 2021 - All rights resereved.

#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

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
  for (int i = 0; i < 5; i++) 
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
void OTAOnStart() 
{
  ArduinoOTA.onStart([]() {
    String type;
    if (ArduinoOTA.getCommand() == U_FLASH)
    {
      type = "sketch";
    } else 
    {
      type = "filesystem";
    }
     Serial.println("Start Updating " + type);
  });
}

void OTAOnEnd()
{
  ArduinoOTA.onEnd([]() {
    Serial.println("\nEnd");
  });
}
void OTAOnProgress()
{
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
  });
}
void OTAOnError()
{
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) {
      Serial.println("Auth Failed");
    } else if (error == OTA_BEGIN_ERROR) {
      Serial.println("Begin Failed");
    } else if (error == OTA_CONNECT_ERROR) {
      Serial.println("Connect Failed");
    } else if (error == OTA_RECEIVE_ERROR) {
      Serial.println("Receive Failed");
    } else if (error == OTA_END_ERROR) {
      Serial.println("End Failed");
    }
  });
}

void configureOTA()
{
  // Port defaults to 8266
  ArduinoOTA.setPort(8266);

  ArduinoOTA.setHostname("Nansie_ESP8266");
  MD5(sharpless) = 4431293f510370624fa504d839f00d1f;
  ArduinoOTA.setPasswordHash("4431293f510370624fa504d839f00d1f");

  OTAOnStart();
  OTAOnEnd();
  OTAOnProgress();
  OTAOnError();
  
  ArduinoOTA.begin();
  
}
void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, PASSWORD);
  connectingToWiFi();
  setPinModes();
  performPattern("sssls"); 
  configureOTA();
}

void loop() { 
   ArduinoOTA.handle();
}
