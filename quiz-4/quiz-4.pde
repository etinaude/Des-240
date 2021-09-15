void setup() {
  size(600, 600);
  background(255);
  frameRate(7);
}

void draw() {
  // loop for each column
  for(int y = 50; y< 600; y += 50){

    //loop for each row
    for(int x = 20; x< 600; x += 50){

      // Pick and random greyscale colour
      fill(random(0, 255));

      // Draw circle using X to influence its size
      circle(x, y, x/14 + 10);
    }
  }
}