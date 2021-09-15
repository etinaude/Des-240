void setup() {
  size(600, 600);
  background(0);
  frameRate(2);
  noStroke();
}

void draw() {
  background(0);

  // Create new circles
  for (int i = 0; i < 10; i += 1) {
    // Change colour to random and pick random co ordinates
    fill(random(255));
    float x = random(600);
    float y = random(600);

    circle(x, y, 30);
  }
}