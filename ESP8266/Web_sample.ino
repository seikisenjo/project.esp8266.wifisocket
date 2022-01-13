#include <ESP8266WiFi.h>
 
const char* host = "http://seikisenjo.netne.net";
const char* url = "http://seikisenjo.netne.net/status.html";
String status;

void setup() {
  
  Serial.begin(115200);
  pinMode(2, OUTPUT);
  digitalWrite(2, LOW);
  // WPS works in STA (Station mode) only.
  WiFi.mode(WIFI_STA);
  delay(2000);
  // Called to check if SSID and password has already been stored by previous WPS call.
  // The SSID and password are stored in flash memory and will survive a full power cycle.
  // Calling ("",""), i.e. with blank string parameters, appears to use these stored values.
  WiFi.begin("","");
  // Long delay required especially soon after power on.
  delay(4000);
  // Check if WiFi is already connected and if not, begin the WPS process. 
  if (WiFi.status() != WL_CONNECTED) { 
      WiFi.beginWPSConfig();
      // Another long delay required.
      delay(3000);
      if (WiFi.status() == WL_CONNECTED) {
        Serial.println(WiFi.localIP());
        Serial.println(WiFi.SSID());
        Serial.println(WiFi.macAddress());
      }
      else {
      }
  }
  else {
  }
}
 
void loop() {
  delay(2000);
  
  // Use WiFiClient class to create TCP connections
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    return;
  }
  
  // We now create a URI for the request  
  // This will send the request to the server
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n");
  delay(1500);
  
  // Read all the lines of the reply from server and print them to Serial
  while(client.available()){
    String line = client.readStringUntil('\r');
    status = line;
  }

  if (status.indexOf("387d7a59dbaaef002e0f9ac69ecd4443b9c5cef2") >= 5) {
      digitalWrite(2, HIGH);
  }
  else if (status.indexOf("ad50489054ddaae044be8b3054bf4d67480648d6") >= 5) { 
      digitalWrite(2, LOW);
  }
  else {
      digitalWrite(2, LOW);
  }
  
  delay(2500);  
}



