// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

int soundPin = A0;
int soundVal = 0;

void setup() {
    Serial.begin(9600);
}

void loop() {
  soundVal = analogRead(soundPin);
  String soundMessage = "{\"type\":\"gauge\",\"name\":\"uno_sound_reading\",\"help\":\"The sound reading.\",\"method\":\"set\",\"value\":" + String(soundVal) + ",\"labels\":{\"country\":\"nl\"}}";
  Serial.write(soundMessage.c_str());
  Serial.write("\n");
  Serial.write("{\"type\":\"gauge\",\"name\":\"uno_up\",\"help\":\"The arduino status.\",\"method\":\"set\",\"value\":1,\"labels\":{\"country\":\"nl\"}}");
  delay(3000);
}