# Prototype (Home Automation - Wi-Fi controlled Power Socket)

# Power socket controlled by relay which in turn switched on by embedded ESP8266 module

# Control socket using 2 methods
  - WebUI on the domain (visit URL on any web browser)
  - User apps installed on phone (APK files, programmed in LUA using Corona SDK)
  
# 3 function avaiable
  - Instant ON / OFF socket 
  - Scheduled time (Switch ON and OFF the socket on time specified by user)
  - Timer (Switch ON the socket and OFF it after timer expires)
  
# System Overview

  User device (Android or any device with Web browsing ability)
                          ↓
                    PHP Web server
                          ↓
                 Updated status in HTML
                          ↓
  ESP8266 periodic polling on status of HTML and switch ON/OFF based on variables received
