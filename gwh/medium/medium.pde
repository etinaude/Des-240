ArrayList<float[]> particles = new ArrayList<float[]>();

void setup() {
  size(600, 600);
  background(200);
  frameRate(7);
  textSize(10);
  strokeWeight(1);
}

void draw() {

}


void mouseClicked() {
    float[] currentPosition = {mouseX, mouseY};
    particles.add(currentPosition);

    if(particles.size() == 0) return;

    for (float[] particle : particles) {
        line(currentPosition[0], currentPosition[1], particle[0], particle[1]);
    }

    fill(0);
    circle(currentPosition[0], currentPosition[1], 15);
    fill(150);
    text("("+ int(currentPosition[0]) + "," + int(currentPosition[1]) +")", currentPosition[0] + 10, currentPosition[1] + 10);
}

void keyPressed() {
    if ( key == ' ' )  {
        background(200);
        particles = new ArrayList<float[]>();
    }
}