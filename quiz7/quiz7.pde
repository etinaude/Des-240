int x = 15;

void setup() {
  size(400, 400);
  frameRate(3);
  stroke(100);
  strokeWeight(2);
}

void draw() {
  background(255);
    fill(random(255));
    circle(x, 200, 30);

    fill(random(255));
    circle(x+30, 200, 30);

    fill(random(255));
    circle(x+60, 200, 30);

    fill(random(255));
    circle(x+90, 200, 30);

    x+= 70;
    if(x > 350) {
      x = 15;
    }
}