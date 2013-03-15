class Box {
  int boxsize = 300;//This changes the length of the box
                    //Since Volume = Length^3, alter this variable to change the volume 
  void display() {
    stroke(0);
    fill(0,10);
    box(boxsize);
  }
}

