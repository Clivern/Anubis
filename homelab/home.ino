// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

#include <DHT.h>

int soundPin = A0;
int soundVal = 0;
int soundSum = 0;
int soundMeasures = 128;
int soundLevel = 0;

#define DHTPIN 2
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

int chk;
float hum;
float temp;

void setup() {
    Serial.begin(9600);
    dht.begin();
}

void loop() {
  soundSum = 0;
  soundVal = 0;

  for (int i = 0; i < soundMeasures; i++)  {
    soundVal = analogRead (soundPin);
    soundSum = soundSum + soundVal;
  }

  soundLevel = soundSum / soundMeasures;

  String soundMessage = "{\"type\":\"gauge\",\"name\":\"uno_sound_reading\",\"help\":\"The sound reading.\",\"method\":\"set\",\"value\":" + String(soundLevel) + ",\"labels\":{\"country\":\"nl\"}}";
  Serial.write(soundMessage.c_str());
  Serial.write("\n");
  Serial.write("{\"type\":\"gauge\",\"name\":\"uno_up\",\"help\":\"The arduino status.\",\"method\":\"set\",\"value\":1,\"labels\":{\"country\":\"nl\"}}");

  hum = dht.readHumidity();
  temp= dht.readTemperature();

  Serial.write("\n");
  String tempMessage = "{\"type\":\"gauge\",\"name\":\"uno_temp_reading\",\"help\":\"The temp reading celsius.\",\"method\":\"set\",\"value\":" + String(temp) + ",\"labels\":{\"country\":\"nl\"}}";
  Serial.write(tempMessage.c_str());

  Serial.write("\n");
  String humMessage = "{\"type\":\"gauge\",\"name\":\"uno_hum_reading\",\"help\":\"The hum reading %.\",\"method\":\"set\",\"value\":" + String(hum) + ",\"labels\":{\"country\":\"nl\"}}";
  Serial.write(humMessage.c_str());
  Serial.write("\n");

  delay(3000);
}
