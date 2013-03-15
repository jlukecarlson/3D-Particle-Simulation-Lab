import processing.opengl.*;
 
ArrayList balls;
Box box = new Box();
 
PVector location;
PVector speed;
int radius;
boolean light = false;

//NONEDITABLE CONSTANTS
//These are used for important behind the scenes computations
float sigmaVelocity = 0; //holds the summation of velocities when particles hit the wall

//These two are used to compute time from frames per second
float totalframes = 0;
float totaltime = 0;

float timeChecker = 0; 

float totalForce = 0;  //Will end up being the total force on one wall
float pressure = 0; //This variable is the computed pressure

//EDITABLE CONSTANTS

int numberOfParticles = 25;//This variable changes the number of particles in the simulation
//int tempKelvin = 273;

float computationInterval = 3;  //change the number to alter how often Pressure is computed (in seconds)
                                //Currently every 3 seconds

//To edit the volume of the box go to boxclass.pde

float[] particleSpeeds = { 6.3, 6.3, 5.6, 5.6, 5.6, 4.6, 4.6, 4.6, 4.6, 4.6, 4.6, 3.6, 3.6, 3.6 };

void setup() {
  size (600,600,P3D);
  smooth();
  balls = new ArrayList();
  for (int i=0; i< numberOfParticles+1;i++) { //to increase number of particles, change the # i is less than
    int randomSpeedChooser = int(random(0, particleSpeeds.length-1));
    float randomSpeedValue = particleSpeeds[randomSpeedChooser];
    radius = 10; 
    speed = new PVector(randomSpeedValue, randomSpeedValue, randomSpeedValue); //other options: random(-5,5),random(5), random(5)); or 4.6,4.6,4.6
    balls.add(new Ball(speed, radius));
  }
}
 
void draw() {
  //Calculations
  totalframes+=1; //keeps track of the frames since the simulation stared
  totaltime = totalframes/60; // since this is 60fps, this variable is the total time in seconds since start
  
  timeChecker+= 1;
  if (timeChecker == computationInterval*60){  
    //Experimentally determining Pressure
    totalForce = 32 * sigmaVelocity / totaltime; // This finds Force
    pressure = totalForce/900000000; //Pressure = F/A
  
    println(pressure);
    timeChecker = 0;
  }
  
  
  background(255);
  if (light == true){
    light();
  }
  rotatectrl();
  
  
  //The following is the representation of the Wall used to compute Pressure (dark grey)
  pushMatrix();
  fill(100);
  translate(0, 0, 150);
  box(300, 300, 0);
  popMatrix();
  
  for (int i=0; i< balls.size() -1;i++) { 
    Ball thisBall = (Ball) balls.get(i);
    thisBall.move();
    thisBall.display();
    thisBall.collide();
  }
  box.display();
}
 
void keyPressed(){
  if (key == 'a'){
    light = true;
  }else if (key == 's'){
    light = false;
  }
}

//This code is adapted from'3D Balls Bouncing' on Open Processing
