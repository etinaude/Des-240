void setup() {
  size(600, 600);
  background(255);
  frameRate(7);
}

void draw() {
  for(int x = 50; x< 600; x += 50){
      for(int y = 20; y< 600; y += 50){
         fill(random(0, 255));
          circle(y, x, y/14 + 10);
    }
  }
}