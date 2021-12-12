#define sensor 2

void setup()
{
  Serial.begin(9600);
  pinMode(sensor, INPUT);
  digitalWrite(sensor,LOW);
}

void loop() 
{
  if(digitalRead(sensor))Serial.println("Movement detected.");
  else Serial.println("Did not detect movement.");
  delay(100);
}
