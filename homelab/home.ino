// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

int soundPin = A0;
int soundVal = 0;
int soundSum = 0;
int soundMeasures = 128;
int soundLevel = 0;

void setup() {
    Serial.begin(9600);
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
  delay(3000);
}
