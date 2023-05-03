// Copyright 2023 Clivern. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

void setup() {
}

void loop() {
  String uno_up = R"({"type": "gauge", "name": "uno_up", "help": "the arduino status.", "method": "set", "value": 1, "labels": {"country": "nl"}})";
  Serial.write(uno_up.c_str());
  delay(3000);
}
