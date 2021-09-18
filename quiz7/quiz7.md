```
PVector[] particles = new PVector[10];

void setup() {
size(500, 500);
createDots();
}

void draw() {

// reset the page
background(220);

// stores the mouse position
PVector mousePos = new PVector(mouseX, mouseY);

// loops through each circles position
for (PVector currentPos : particles) {

    // half of the diamater of each circle so 50+12.5
    // if the muse is close enough
    if(PVector.dist(mousePos, currentPos) < 65.5){
      fill(255, 0, 0);
      stroke(255, 0, 0);
    } else {
      fill(0);
      stroke(0);
    }
    circle(currentPos.x, currentPos.y, 25);

}

// draw mouse cirlce
stroke(150);
strokeWeight(1);
noFill();
circle(mousePos.x, mousePos.y, 100);
}

void mouseClicked() {
createDots();
}

// add new dots in random positions to the array
void createDots(){
for(int i = 0; i < particles.length; i++){
particles[i] = new PVector(random(500), random(500));
}
}
```
