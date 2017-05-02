/* ----------------------------------------------------------------------------------------------------
 * Le Feel, 2017
 * Update: 02/05/17
 *
 * More Soon
 * 
 * V0
 * Written by Bastien DIDIER
 *
 * ----------------------------------------------------------------------------------------------------
 */

import processing.serial.*;
Serial myPort;

int rectSize = 150;
int row = 2;
int cols = 2;
int addRow = 0;
int addCols = 0;

int mapWidth = rectSize*row;
int mapHeight = rectSize*cols;

int maxNumberOfSensors = row*cols;     
float[] sensorValue = new float[maxNumberOfSensors];    // global variable for storing mapped sensor values
float[] previousValue = new float[maxNumberOfSensors];  // array of previous values

void setup () { 
  size(600, 600);
  //println(Serial.list());  // List all the available serial ports
  String portName = "/dev/cu.usbmodem1421";
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte
  background(255);
  smooth();
  rectMode(CORNER);
}

void draw () {
  
  for(int i=0; i<=maxNumberOfSensors-1; i++){
    if(i % cols == 0 && i != 0){
      addCols++;
      addRow = 0;
    }
    fill(sensorValue[i]);
    rect((width/2-mapWidth/2)+addRow*rectSize, (height/2-mapHeight/2)+addCols*rectSize, rectSize,rectSize);
    addRow++;
  }
  addRow = 0;
  addCols = 0;
}


void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');  // get the ASCII string

  if (inString != null) {  // if it's not empty
    inString = trim(inString);  // trim off any whitespace
    int incomingValues[] = int(split(inString, ","));  // convert to an array of ints
    
    if (incomingValues.length <= maxNumberOfSensors && incomingValues.length > 0) {
      for (int i = 0; i < incomingValues.length; i++) {
        // map the incoming values (0 to  1023) to an appropriate gray-scale range (0-255):
        sensorValue[i] = map(incomingValues[i], 1010, 1015, 0, 255);  
      }
    }
  }
}