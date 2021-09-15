int x = 10;
int y = 20;


void setup() {
  size(600, 600);
  background(255);
  frameRate(20);
  noStroke();
}

void draw() {
    // Reset at the end
    if (y > 600) {
        background(255);
        x = 10;
        y = 20;
    }

    // Change colour to random
    fill(random(255),random(255),random(255));

    // Create new circles
    for (int offset = 0; offset < 5; offset += 1) {
      circle(x + offset * 30, y, 30);
    }

    // Move the circles starting position
    x += 5;
    y += 5;


    /* Note:

        This isn't using arrays as nothing needs to be stored

        also notice that y is always x + 10.
        this means we shouldn't need to store both X and Y but for flexabilty and readbilty I have stored both.

    */
}