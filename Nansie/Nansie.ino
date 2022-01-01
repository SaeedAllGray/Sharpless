//Saeed & Media
// 2021 - All rights resereved.

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <EEPROM.h>
#include <ArduinoOTA.h>
#include <FS.h>

const byte LED_PIN = LED_BUILTIN;

const String WIFI_SSID = "The Cyan One"; 
const String PASSWORD = "October2020";
const byte OFF = 0, ON = 1;
const byte LED_POINTER = 0, VIBRATION_POINTER  = 1;

const String latestUpdateMessage = "Nansie Sharpless Version 0.1.0";


ESP8266WebServer server(80);

ADC_MODE(ADC_VCC);

void setPinModes() {
  pinMode(LED_PIN, OUTPUT);
}
void createFile() {
  SPIFFSConfig cfg;
  cfg.setAutoFormat(false);
  SPIFFS.setConfig(cfg);
  SPIFFS.begin();
  if ( SPIFFS.exists("/data.txt") )
    Serial.println("\nexist");
}

void addToFile(String text) {
  File file = SPIFFS.open("/data.txt", "a+");
  file.print(text);
  file.close();
//  SPIFFS.end();
}

int getIndexOfEvent(String eventName) {
  File file = SPIFFS.open("/data.txt", "r+");
  String data = file.readString();
  file.close();
  return data.indexOf(eventName);
}

void saveToFile(String data) {
  File file = SPIFFS.open("/data.txt", "w+");
  file.print(data);
  Serial.println(data);
  file.close();
}

String readFromFile() {
  File file = SPIFFS.open("/data.txt", "r");
  String data = file.readString();
  file.close();
  return data;
}

String getPattern(String eventName) {
  String data = readFromFile();
  int patternStartIndex = data.indexOf(eventName) + eventName.length() + 1;
  Serial.println(data.substring(patternStartIndex, patternStartIndex+5));
  return data.substring(patternStartIndex, patternStartIndex+5);
}

void updateDatabase(String eventName,String pattern) {
  String data = readFromFile();
  int patternStartIndex = data.indexOf(eventName);
  patternStartIndex += patternStartIndex != -1? eventName.length() + 1 : 0;
  if(patternStartIndex == -1) {
    data += eventName + ":" + pattern + "#";
  } 
  else {
    for(int i = patternStartIndex; i < patternStartIndex+5; i++) {
      data[i] = pattern[i - patternStartIndex];
    }
  }
  saveToFile(data);
}


bool batteryNeedsReplacing() {
  float voltage = ESP.getVcc();
  return voltage < 3.7;
}

bool isConnectedToWiFi() {
  return WiFi.status() == WL_CONNECTED;
}

void connectingToWiFi() {
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

void performPattern(String pattern) {   
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
void handleNotFound() {
  server.send(404, "text/plain", "Bad Request!");
}

void mdns() {
  if (MDNS.begin("nansie-sharpless")) {
    Serial.println("MDNS responder started");
  }
}
void manageAPI() {
  server.on("/", []() {
    server.send(200, "text/plain", "Server is up.");
  });

  server.on("/setpattern", []() {//192.168.0.0?setpattern?event=door&pattern=sllls
    server.send(200, "text/plain", "Succeed.");
    updateDatabase(server.arg(0),server.arg(1)); 
  });
  
  server.on("/performpattern", []() {//192.168.0.0?performpattern?event=door
    String pattern = getPattern(server.arg(0));
    performPattern(pattern);
    server.send(200, "text/plain", "Performing " + pattern);
  });
  server.on("/testpattern", []() {//192.168.0.0?performpattern?event=door
    String pattern = server.arg(0);
    performPattern(pattern);
    server.send(200, "text/plain", "Performing " + pattern);
  });
  

   server.on("/getdata", []() {
    String data = readFromFile();
    server.send(200, "text/plain", data);
  });

  server.on("/setting", []() {
    if(server.arg(0) == "1")
      EEPROM.write(LED_POINTER, 1);
    else
      EEPROM.write(LED_POINTER, 0);
    if (server.arg(1) == "1")
      EEPROM.write(VIBRATION_POINTER, 1);
    else
     EEPROM.write(VIBRATION_POINTER, 0);
    EEPROM.commit();
    server.send(200, "text/plain", "Succeed");
  });
    
  server.on("/removehistory", []() {
    SPIFFS.remove("/data.txt");
    server.send(200, "text/plain", "Succeed");
  });

  server.on("/battery", []() {
    Serial.println(ESP.getVcc());
    String voltage = String(ESP.getVcc());
    server.send(200, "text/plain", voltage);
  });
  server.on("/update", []() {
    server.send(200, "text/plain", latestUpdateMessage);
  });

  server.onNotFound(handleNotFound);
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
    server.send(200, "Progress");
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
  });
}
void OTAOnError()
{
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) {
      server.send(404, "text/plain", "Auth Failed");
      Serial.println("Auth Failed");
    } else if (error == OTA_BEGIN_ERROR) {
      server.send(404, "text/plain", "Begin Failed");
      Serial.println("Begin Failed");
    } else if (error == OTA_CONNECT_ERROR) {
      server.send(404, "text/plain", "Connect Failed");
      Serial.println("Connect Failed");
    } else if (error == OTA_RECEIVE_ERROR) {
      server.send(404, "Receive Failed");
      Serial.println("Receive Failed");
    } else if (error == OTA_END_ERROR) {
      server.send(404, "End Failed");
      Serial.println("End Failed");
    }
  });
}

void configureOTA()
{
  // Port defaults to 8266
  ArduinoOTA.setPort(8266);

  ArduinoOTA.setHostname("Nansie_ESP8266");
//  MD5(sharpless) = 4431293f510370624fa504d839f00d1f;
//  ArduinoOTA.setPasswordHash("4431293f510370624fa504d839f00d1f");

  OTAOnStart();
  OTAOnEnd();
  OTAOnProgress();
  OTAOnError();
  
  ArduinoOTA.begin();
  
}
void setup() {
  EEPROM.begin(2);
  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, PASSWORD);
  connectingToWiFi();
  createFile();
  setPinModes(); 
  mdns();
  manageAPI();
  configureOTA();
  server.begin();
  
}

void loop() { 
  ArduinoOTA.handle();
  server.handleClient();
  MDNS.update();
}
