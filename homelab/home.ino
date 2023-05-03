// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

void setup() {
    Serial.begin(9600);
}

void loop() {
  Serial.write("{\"type\":\"gauge\",\"name\":\"uno_up\",\"help\":\"The arduino status.\",\"method\":\"set\",\"value\":1,\"labels\":{\"country\":\"nl\"}}");
  delay(3000);
}