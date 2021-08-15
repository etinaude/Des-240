/**
  Des 240 Assignment 1, showing data through geometric primitives


  by Etienne Naude, 2021

  showing fertility rate of New Zealand - 1.61 bpw.
  http://www.stats.govt.nz/statistics/geos/geos-datasets/fertility-rate-nz/
*/

int stage = 0;


/**
  a class to storage the location of a human
*/
class Human {
  public float x, y, extent, percent;

  Human(int x, int y, int extent, int percent) {
    this.x = x;
    this.y = y;
    this.extent = extent;
    this.percent = percent;
  }

  void draw(){
    if(percent == 0) return;
    fill(255);
    circle(x, y, extent);

    if(percent < 100){
      fill(0);
      rect(x+extent*(percent-50)/100, (y-extent/2)-2, extent+10, extent+10);
    }
  }

}

// initalize the humans
Human parentA = new Human(600, 400, 100, 100);
Human parentB = new Human(400, 400, 100, 100);

Human childA = new Human(500, 400, 50, 0);
Human childB = new Human(500, 400, 50, 0);

void setup() {
  size(1000, 1000);
  noStroke();
  frameRate(60);
}

void draw() {
  if(stage > 5) return;
  background(0);

  // draw each circle
  childA.draw();
  childB.draw();

  parentA.draw();
  parentB.draw();

  // animate based on stage of life
  switch (stage) {
    // reporductive stage
    case 0:
      comeTogether();
      break;
    // first child
    case 1:
      if(childA.y > 600) stage++;
      childA.percent = 100;
      moveAway();

      childA.x--;
      childA.y+=2;
      break;

    // reporductive stage
    case 2:
      comeTogether();
      break;
    // second child
    case 3:
      if(childB.y > 600) stage++;
      childB.percent = 61;
      moveAway();

      childB.x++;
      childB.y+=2;
      break;

    // death
    case 4:
      if(parentA.y > 1200) stage++;
      parentA.y+=3;
      parentB.y+=3;
      break;

    // growing up
    case 5:
      if(childA.extent > 100) stage++;
      childA.extent+=1;
      childB.extent+=1;

      childA.y-=3;
      childB.y-=3;

      childA.x-=1;
      childB.x+=1;
      break;
  }
}

void moveAway(){
  if(parentA.x >= 650) return;
  parentA.x++;
  parentB.x--;
}

void comeTogether(){
   if(parentA.x <= 500) stage++;
    parentA.x--;
    parentB.x++;
}
