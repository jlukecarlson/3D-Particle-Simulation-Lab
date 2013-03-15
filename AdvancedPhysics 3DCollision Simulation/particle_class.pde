class Ball {
 
  PVector location = new PVector();
  PVector speed;
 
  int radius;
 
  Ball(PVector speed, int radius) {
    this.speed = speed;
    this.radius = radius;
    location.x = random(radius*2,box.boxsize/2-radius*2);
    location.y = random(radius*2,box.boxsize/2-radius*2);
    location.z = random(radius*2,box.boxsize/2-radius*2);
  } 
 
  void move() {
    //speed.y+= -gravity;
    location.add(speed);
 
    if(location.x > box.boxsize/2-radius) {
      location.x= box.boxsize/2-radius;
      speed.x*=-1;
    }
    else if (location.x < -box.boxsize/2 + radius) {
      location.x = -box.boxsize/2 +radius;
      speed.x*=-1;
    }
    if (location.y > box.boxsize/2-radius) {
      location.y = box.boxsize/2-radius ;
      speed.y*= -1;
    }
    else if (location.y < -box.boxsize/2 + radius) {
      location.y= -box.boxsize/2+radius;
      speed.y*= -1;
    }
    if (location.z > box.boxsize/2-radius) { //This is the wall used to compute Pressure
      location.z = box.boxsize/2-radius;
      speed.z*= -1;
      sigmaVelocity += speed.z * -2; //negative because the speed.z is negative in this instant
    }
    else if (location.z < -box.boxsize/2 + radius) {
      location.z = -box.boxsize/2 + radius;
      speed.z*= -1;
    }
  }
 
  void collide() {
    for (int i=0; i < balls.size() -1; i++) {
      Ball ballA = (Ball) balls.get(i);
      for (int j= i+1; j < balls.size(); j++) {
        Ball ballB = (Ball) balls.get(j);
        if (!ballA.equals(ballB) && ballA.location.dist(ballB.location) < (ballA.radius+ ballB.radius)) {
          bounce(ballA,ballB);
        }
      }
    }
  }
 
  void display() {
    noStroke();
    if (light == true){
      fill(255);
    }else{
      fill(0);                   
    }
    pushMatrix();
    translate(location.x,location.y,location.z);
    sphere(radius);
    popMatrix();
  }
 
  void bounce(Ball ballA, Ball ballB) {
    PVector ab = new PVector();
    ab.set(ballA.location);
    ab.sub(ballB.location);
    ab.normalize();
    while(ballA.location.dist(ballB.location) < (ballA.radius + ballB.radius)) {   //*spring) {
      ballA.location.add(ab);
    }
    PVector n = PVector.sub(ballA.location, ballB.location);
    n.normalize();
    PVector u = PVector.sub(ballA.speed, ballB.speed);
    PVector un = componentVector(u,n);
    u.sub(un);
    ballA.speed = PVector.add(u, ballB.speed);
    ballB.speed= PVector.add(un, ballB.speed);
  }
 
  PVector componentVector (PVector vector, PVector directionVector) {
    directionVector.normalize();
    directionVector.mult(vector.dot(directionVector));
    return directionVector;
  }
}

