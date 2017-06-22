/** Voronoi that pic
Oscar Frias (oscar@oscarfrias.com)
Create a Voronoi Diagram from an existing picture.
The Voronoi sites are randomly generated and discriminated
by using the brightness of the corresponding pixel
 
Thanks to:
Lee Byron <a href="/two/profile/leeb">@leeb</a> for the library
Golan Levin <a href="/two/profile/golan">@golan</a> for the inspiration
*/

import processing.pdf.*;
import megamu.mesh.*;
 
PImage img;
float threshold = 80;  //% of max brightness
 
int maxPoints = 544;
float[][] points;
float[][] vPoints;
 
void setup(){
  img = loadImage("9.jpg");
  
  //size(500,500,PDF,"test.pdf");
  //size(500,500);
  fullScreen();
  
  background(255);
 
  points = new float[maxPoints][2];
  fillRandomPoints(points);
  vPoints = new float[points.length][2];
  //println(vPoints.length);
  vPoints = discriminatePoints(points, vPoints, img);
  //println(vPoints.length);
 
  //noLoop();
}
 
void draw(){
  background(255);
  //println(vPoints.length);
  Voronoi myVoronoi = new Voronoi(vPoints);
  Delaunay myDelaunay  = new Delaunay(vPoints);
  float[][] myVEdges = myVoronoi.getEdges();
  float[][] myDEdges = myDelaunay.getEdges();
  drawEdges(myVEdges);  //draw them black
  //drawEdges(myDEdges,1);  //draw them red
  drawSites(vPoints,5);    //5pix ellipses
  
  //exit();
}

void drawSites(float[][] vPoints, int diam){
  
  for(int h=0;h<vPoints.length;h++){
   
    float px = vPoints[h][0];
    float py = vPoints[h][1];
    
    float x1 = pmouseX;
    float y1 = pmouseY;
    
    float line_lenght = sqrt(pow(x1-px,2)+pow(y1-py,2));
    
    //DEBUG
    //stroke(50,50,50);
    //line(px,py,pmouseX,pmouseY);
    
    float ellipse_color = map(line_lenght, 0,width/10,10,2);
    
    if(line_lenght < width/10){
      noStroke();
      fill(ellipse_color);
      ellipse(px,py,diam*ellipse_color,diam*ellipse_color);
    } else {
      ellipse_color = map(line_lenght, 0,width,2,0);
      ellipse(px,py,diam*ellipse_color,diam*ellipse_color);
    }
    
    //print(sites[h][0]);print(",");println(sites[h][1]);

  }
}
 
void drawEdges(float[][] vEdges){
  stroke(0);
  
 for(int i=0; i<vEdges.length; i++){
  float startX = vEdges[i][0];
  float startY = vEdges[i][1];
  float endX = vEdges[i][2];
  float endY = vEdges[i][3];
  line(startX, startY, endX, endY);
  }
}
 
void fillRandomPoints(float[][] pArray){
    for(int i=0; i<pArray.length;i++){
    pArray[i][0] = random(width);
    pArray[i][1] = random(height);
  }  
}
 
 
float[][] discriminatePoints(float[][] inArray, float[][]outArray, PImage pic){
 pic.loadPixels();
 int counter=0;
 
 for(int i=0; i<inArray.length;i++){
   int x = int(inArray[i][0]);
   int y = int(inArray[i][1]);
   int pos = x + y*pic.width;
 
   float luma = brightness(pic.pixels[pos]);
   float prob = map(luma,0,255,0,100);
 
   if(prob < threshold){
     outArray[counter][0] = inArray[i][0];
     outArray[counter][1] = inArray[i][1];
     counter++;
     //print("So worthy: ");println(counter);
   } else { /*println("Not worthy");*/}
 
 }
   float tempArray[][] = new float[counter-1][2];
   arraycopy(outArray,0,tempArray,0,tempArray.length);
   outArray = tempArray;
 
return outArray;
 }