---
title: How to Connect Arduino With a Raspberry PI over a Serial Port
date: 2021-11-02 00:00:00
featured_image: https://images.unsplash.com/photo-1617563844166-7da58918e10b?q=90&fm=jpg&w=1000&fit=max
excerpt: In this post, You will understand how to collect values from an Arduino with a connected Raspberry PI over a serial port. This can be useful if you want collect sensor values over a period of time and store them on a timeseries database or trigger an alert either from the Raspberry PI (email notification or telegram alert) or from the Arduino (like fire alerting systems). Let's dive in!
---

![](https://images.unsplash.com/photo-1617563844166-7da58918e10b?q=90&fm=jpg&w=1000&fit=max)

In this post, You will understand how to collect values from an Arduino with a connected Raspberry PI over a serial port. This can be useful if you want collect sensor values over a period of time and store them on a timeseries database or trigger an alert either from the Raspberry PI (email notification or telegram alert) or from the Arduino (like fire alerting systems). Let's dive in!

We will use Arduino UNO, Raspberry PI 4 with any Debian based OS (Linux Mint, Ubuntu etc), 1 Led 5 PCS.

- Download the Arduino application on the Raspberry PI or your laptop. You can download from here [https://www.arduino.cc/en/software](https://www.arduino.cc/en/software)
- Connect the Led with Slot 13 and GND Slot.
- Connect the Arduino with Raspberry PI 4 or your laptop in order to upload the following program. It is a simple program that will blink the led but also it will send a value over a serial port with `Serial.write`

```clang
#define LED 13

void setup() {
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
}

void loop() {
  digitalWrite(LED, HIGH);
  delay(1000);
  digitalWrite(LED, LOW);
  delay(1000);
  Serial.write("hello\n");
}
```

- From the Raspberry PI or your laptop, Create a simple python script to read the value that arduino sends over the serial port. We are going to use [PySerial](https://pypi.org/project/pyserial/)

```bash
$ python -m venv venv
$ pip install pyserial
```

```python
# prog.py
import serial
import time

ser = serial.Serial('/dev/cu.usbmodem14101', 9800, timeout=1)
time.sleep(2)

for i in range(200):
    line = ser.readline()
    if line:
        string = line.decode()
        print(string)

ser.close()
```

```bash
$ python prog.py
```

- You should see `hello` on the terminal. That's the one way communication. Next we will do the two way communication.
- Let's upload another program into the Ardunio to read the incoming values from the serial port, switch the led and finally send a value to the serial port.

```clang
#define LED 13

void setup() {
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
}

void loop() {
  if (Serial.available() &gt; 0) {
    if (Serial.readString() == "ON") {
      digitalWrite(LED, HIGH);
      Serial.write("ON");
      delay(1000);
    } else {
      digitalWrite(LED, LOW);
      Serial.write("OFF");
      delay(1000);
    }
  }
}
```

- From the Raspberry PI or your laptop, Create a simple python script to read the value that Arduino sends over the serial port and send a command back.

```python
$ python -m venv venv
$ pip install pyserial
```

```python
# prog.py
import serial
import time

ser = serial.Serial('/dev/cu.usbmodem14101', 9800, timeout=1)
time.sleep(2)

ser.write(b"ON")
for i in range(200):
    line = ser.readline()
    if line:
        incoming = line.decode().strip()
        print("{}\n".format(incoming))
        if incoming == "ON":
            ser.write(b"OFF")
        else:
            ser.write(b"ON")
    time.sleep(1)

ser.close()
```

```python
$ python prog.py
```

If you're interested in this topic, [there is a project](https://github.com/Clivern/arduino_exporter) i created to expose incoming metrics from Arduino to prometheus. You can run this exporter on a device (PC or Raspberry PI) connected to an Arduino. The exporter will listen to messages sent over the serial port and update the metrics exposed to prometheus.

I used this project to visualize and trigger alerts for a lot of sensors values like sound, temperature and water level ... etc
