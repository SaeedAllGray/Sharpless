//Saeed & Media
// 2021 - All rights resereved.

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>
#include <FS.h>

const byte LED_PIN = LED_BUILTIN;

const String WIFI_SSID = "The Cyan One"; 
const String PASSWORD = "October2020";
const byte OFF = 0, ON = 1;
const byte LED_POINTER = 0, VIBRATION_POINTER  = 1;


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

  server.onNotFound(handleNotFound);
}
void setup() {
  EEPROM.begin(2);
  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, PASSWORD);
  connectingToWiFi();
  createFile();
  setPinModes(); 
  manageAPI();
  server.begin();
}

void loop() { 
  server.handleClient();
}
