
#include <ArduinoBLE.h>
#include<Servo.h>
Servo left_wheel;
Servo right_wheel;

BLEService ledService("19B10000-E8F2-537E-4F6C-D104768A1214"); // BLE Service

// BLE Mode_Switch Characteristic - custom 128-bit UUID, read and writable by central
BLEByteCharacteristic Mode_SwitchCharacteristic("2A16", BLEWrite);
BLEByteCharacteristic Send_CommandCharacteristic("2A17", BLEWrite);
BLEByteCharacteristic Front_DistanceCharacteristic("3A01", BLERead | BLENotify);
BLEByteCharacteristic Left_DistanceCharacteristic("3A02", BLERead | BLENotify);
BLEByteCharacteristic Right_DistanceCharacteristic("3A03", BLERead | BLENotify);


const int ledPin = LED_BUILTIN; // pin to use for the LED


// USensor part

#define numInterrupts 3

// Speed of sound in meters/sec
float soundSpeed = 343.0;

// used to calculate and store distanceToObjects to objects, in cm, for each sensor
float distanceToObject[numInterrupts];

//
// Pin definitions
//
// Trigger pin, common to all 3 US
const int triggerPin = 4;
// Echo pins
const int leftEchoPin = 2;
const int forwardEchoPin = 10;
const int rightEchoPin = 11;

// Delay times between making measurements, and printing to Serial Monitor
//
// ms to wait between calculations of distances, so as not to constantly calculate things!
int msWaitBetCalculations = 10;
// ms to wait between each output to Serial Monitor, so as not to have tons of data!
int msWaitBetSerialMonitorOutputs = 200;

//
// Volatiles are used in Interrupt routines (more on that later)
//
// Store the travel times of the pulses
volatile unsigned long pulseTravelTime[numInterrupts];
// Variable to keep track of when each Echo pin changes to HIGH
volatile unsigned long timeEchostateOfPinChangedToHigh[numInterrupts];

// Variable to keep track of last time distances calculations were performed
unsigned long lastTimeCalculatedDistances;
// Variable to keep track of last time displayed data to Serial Monitor, so as not to display too much!
unsigned long lastTimeDisplayedToSerialMonitor;


int FrontThreshold = 13;
int LeftThreshold = 18;
int RightThreshold = 18;

boolean frontwall;
boolean leftwall;
boolean rightwall;
int diff;

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // initial servor output pin
  left_wheel.attach(6);
  right_wheel.attach(5);
  
  // set LED pin to output mode
  pinMode(ledPin, OUTPUT);

  // begin initialization
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");

    while (1);
  }

  // set advertised local name and service UUID:
  BLE.setLocalName("Nano33IoT");
  BLE.setAdvertisedService(ledService);

  // add the characteristic to the service
  ledService.addCharacteristic(Mode_SwitchCharacteristic);
  ledService.addCharacteristic(Send_CommandCharacteristic);
  ledService.addCharacteristic(Front_DistanceCharacteristic);
  ledService.addCharacteristic(Left_DistanceCharacteristic);
  ledService.addCharacteristic(Right_DistanceCharacteristic);
  
  // add service
  BLE.addService(ledService);

  // set the initial value for the characeristic:
  Mode_SwitchCharacteristic.writeValue(0);
  Send_CommandCharacteristic.writeValue(0);
  Front_DistanceCharacteristic.writeValue(0);
  Left_DistanceCharacteristic.writeValue(0);
  Right_DistanceCharacteristic.writeValue(0);

  // start advertising
  BLE.advertise();

  Serial.println("BLE Peripheral");

  //USensor Part
  // Trigger pin is an OUTPUT
  pinMode(triggerPin, OUTPUT);

  // Define input for US # 1, which is Echo pin from left US
  pinMode(leftEchoPin, INPUT);
  // Define input for US # 2, which is Echo pin from front US
  pinMode(forwardEchoPin, INPUT);
  // Define input for US # 3, which is Echo pin from right US
  pinMode(rightEchoPin, INPUT);

  // Define interrupt routines to call for each echo pin
  attachInterrupt(digitalPinToInterrupt(leftEchoPin), ISR_Sensor1_onPin2_Interrupt0, CHANGE );   // ISR for INT0
  attachInterrupt(digitalPinToInterrupt(forwardEchoPin), ISR_Sensor2_onPin10_Interrupt1, CHANGE );   // ISR for INT1
  attachInterrupt(digitalPinToInterrupt(rightEchoPin), ISR_Sensor3_onPin11_Interrupt2, CHANGE );   // ISR for INT2

  // Keep track of last time calculated distances (gotta start somewhere!)
  lastTimeCalculatedDistances = millis();
  // Keep track of last time displayed data to Serial Monitor (gotta start somewhere!)
  lastTimeDisplayedToSerialMonitor = millis();
}


void forward() {
  left_wheel.write(115);
  right_wheel.write(60);
}

void backward() {
  left_wheel.write(70);
  right_wheel.write(110);
}

void stopmove() {
  left_wheel.write(90);
  right_wheel.write(90);
}

void turn_left() {
  right_wheel.write(80);
  left_wheel.write(80);
}

void turn_right() {
  left_wheel.write(100);
  right_wheel.write(100);
}

void turnLeft(int t){
    left_wheel.write(80);
    right_wheel.write(80);
    delay(t*100);
    left_wheel.write(90);
    right_wheel.write(90);
    delay(100);
    return;
}

void turnRight(int t){
    left_wheel.write(100);
    right_wheel.write(100);
    delay(t*100);
    left_wheel.write(90);
    right_wheel.write(90);
    delay(100);
    return;
}

void turnAround(int t){
    left_wheel.write(70);
    right_wheel.write(70);
    delay(t*100);
    left_wheel.write(90);
    right_wheel.write(90);
    delay(100);
    return;
}

void walls() {
  if (distanceToObject[0] < LeftThreshold) {
    leftwall = true ;
  }
  else {
    leftwall = false ;
  }


  if (distanceToObject[2] < RightThreshold) {
    rightwall = true ;
  }
  else {
    rightwall = false ;


  } if (distanceToObject[1] < FrontThreshold) {
    frontwall = true ;
  }
  else {
    frontwall = false ;
  }

  diff = distanceToObject[0] - distanceToObject[2];
}


void calculateDistances()
{
  // Disable interrupts while calculating so as not to mess things up
  detachInterrupt(digitalPinToInterrupt(leftEchoPin));
  detachInterrupt(digitalPinToInterrupt(forwardEchoPin));
  detachInterrupt(digitalPinToInterrupt(rightEchoPin));
  //noInterrupts();
  for (int k = 0; k < numInterrupts; k++)
  {
    distanceToObject[k] = (pulseTravelTime[k] / 2.0) * (float)soundSpeed / 10000.0; // Calculate distances
    //Serial.print(pulseTravelTime[k]);
    //Serial.print(":::");
  }
  //Serial.println();
  // Enable interrupts again, we're all done with calculations
  attachInterrupt(digitalPinToInterrupt(leftEchoPin), ISR_Sensor1_onPin2_Interrupt0, CHANGE ); 
  attachInterrupt(digitalPinToInterrupt(forwardEchoPin), ISR_Sensor2_onPin10_Interrupt1, CHANGE );   
  attachInterrupt(digitalPinToInterrupt(rightEchoPin), ISR_Sensor3_onPin11_Interrupt2, CHANGE );   
  //interrupts();
  
  // Trigger Sensors (no need to have the initial LOW because this function already takes up time
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(20); // 10 us is enough!
  digitalWrite(triggerPin, LOW);    // End of pulse
}


void updateDistance() {
  // Calculate distances from sensors if enough time has passed, i.e., at least msWaitBetCalculations
  if (millis() - lastTimeCalculatedDistances >= msWaitBetCalculations)
  {
    calculateDistances(); // Call function to take calculate distances
    // Keep track of last time took measurement, which is now
    lastTimeCalculatedDistances = millis();
  }

  // Display data to Serial Monitor only if enough time has passed, i.e., at least msWaitBetSerialMonitorOutputs
  if (millis() - lastTimeDisplayedToSerialMonitor >= msWaitBetSerialMonitorOutputs)
  {
    
    for (int k = 0; k < numInterrupts; k++) {
      Serial.print(distanceToObject[k]);
      Serial.print(" ::: ");
    }
    Serial.println();
    
    Front_DistanceCharacteristic.writeValue(distanceToObject[1]);
    Left_DistanceCharacteristic.writeValue(distanceToObject[0]);
    Right_DistanceCharacteristic.writeValue(distanceToObject[2]);
    // Keep track of last time displayed data to Serial Monitor, which is now!
    lastTimeDisplayedToSerialMonitor = millis();
  }
}

//
// Interrupt routines, one for each sensor echo pin
//

// possible problem here
void ISR_Sensor1_onPin2_Interrupt0()
{

  int pinD2 = REG_PORT_IN1 & PORT_PB10;
  bool valueOfBit10 = bitRead(pinD2, 10);
  /**
  Serial.print("State of pin D2 in entire register: ");
  Serial.println(pinD2);
  Serial.print("State of pin only: ");
  Serial.println(valueOfBit10);
  Serial.println("");
  */
  //bool readEchoPin = digitalRead(leftEchoPin); //  leftEchoPin = 2;
  mainInterruptFunction(valueOfBit10, 0);
}
 
void ISR_Sensor2_onPin10_Interrupt1()
{
  int pinD10 = REG_PORT_IN0 & PORT_PA21;
  bool valueOfBit21 = bitRead(pinD10, 21);
  /**
  Serial.print("State of pin D10 in entire register: ");
  Serial.println(pinD10);
  Serial.print("State of pin only: ");
  Serial.println(valueOfBit21);
  Serial.println("");
  */
  //bool readEchoPin = digitalRead(forwardEchoPin); // forwardEchoPin = 10;
  mainInterruptFunction(valueOfBit21, 1);
}

void ISR_Sensor3_onPin11_Interrupt2()
{
  int pinD11 = REG_PORT_IN0 & PORT_PA16;
  bool valueOfBit16 = bitRead(pinD11, 16);
  /**
  Serial.print("State of pin D11 in entire register: ");
  Serial.println(pinD11);
  Serial.print("State of pin only: ");
  Serial.println(valueOfBit16);
  Serial.println("");
  */
  //bool readEchoPin = digitalRead(rightEchoPin); //rightEchoPin = 11;
  mainInterruptFunction(valueOfBit16, 2);
}


//
// Main Interrupt function
//
void mainInterruptFunction(bool stateOfPin, int IRQ_Number)
{
  unsigned long currentTime = micros(); 
  //Serial.print(stateOfPin);
  //Serial.print("::");
  //Serial.println(IRQ_Number);
  if (stateOfPin)
  {
    // If the pin measured had its state change to HIGH, then save that time (us)!
    timeEchostateOfPinChangedToHigh[IRQ_Number] = currentTime;
  }
  else
  {
    // If the pin measured had its state change to LOW, then calculate how much time has passed (µs)
    pulseTravelTime[IRQ_Number] = currentTime - timeEchostateOfPinChangedToHigh[IRQ_Number];
  }
}


void loop() {
  // listen for BLE peripherals to connect:
  BLEDevice central = BLE.central();
  // if a central is connected to peripheral:
  if (central) {
    Serial.print("Connected to central: ");
    // print the central's MAC address:
    Serial.println(central.address());
    
    boolean isAutonomous;
    boolean choose = false;
    // while the central is still connected to peripheral:
    while (central.connected()) {
      // if the remote device wrote to the characteristic,
      // use the value to control the LED:
      if (Mode_SwitchCharacteristic.written()) {
        if (Mode_SwitchCharacteristic.value()) {   // any value other than 0
          Serial.println("LED on");
          Serial.println("Autonomous Mode");
          digitalWrite(ledPin, HIGH);     // will turn the LED on
          isAutonomous = true;
          Serial.println(digitalRead(ledPin));
        } else {                              // a 0 value
          Serial.println("LED off");
          Serial.println("Manual Mode");
          digitalWrite(ledPin, LOW);          // will turn the LED off
          isAutonomous = false;
          Serial.println(digitalRead(ledPin));
        }
      }
      if (isAutonomous == true) {
         walls();
         if (frontwall == true && leftwall == false && rightwall == true) {
           //wall on right and front
           turnLeft(5);
           //forward();
           //delay(200);
         } else if (frontwall == true && leftwall == true && rightwall == false) {
           //wall on left and front
           turnRight(5);
           //forward();
           //delay(200);
         } else if (frontwall == true && leftwall == true && rightwall == true) {
           //wall on three sides
           turnAround(10);
         } else if (frontwall == true && leftwall == false && rightwall == false) {
          // wall on the front only
           if (choose) {
             turnLeft(8);
           } else {
             turnRight(8);
           }
           choose = !choose;
        } else if (distanceToObject[0] < 20 && distanceToObject[2] < 20 && diff > 10) {
           //modify the straight line
           turnLeft(1);
        } else if (distanceToObject[0] < 20 && distanceToObject[2] < 20 && diff < -10) {
           //modify the straight line
           turnRight(1);
         } else {
           forward();
         }
      } else {
        if (Send_CommandCharacteristic.written()) {
          Serial.println("command change");
          int action = Send_CommandCharacteristic.value(); 
          switch (action) {
            case 0: Serial.println(action); Serial.println("stop"); stopmove(); break;
            case 1: Serial.println(action); Serial.println("forward"); forward(); break;
            case 2: Serial.println(action); Serial.println("backward"); backward(); break;
            case 3: Serial.println(action); Serial.println("turnleft"); turn_left(); break;
            case 4: Serial.println(action); Serial.println("turnright"); turn_right(); break;
          }
        }
      }
      updateDistance();
    }

    // when the central disconnects, print it out:
    Serial.print(F("Disconnected from central: "));
    Serial.println(central.address());
  }
}
