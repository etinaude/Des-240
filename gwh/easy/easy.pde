ArrayList<float[]> particles = new ArrayList<float[]>();

void setup() {
  size(600, 600);
  background(200);
  frameRate(7);
}

void draw() {

}


void mouseClicked() {
    float[] currentPosition = {mouseX, mouseY};
    fill(0);

    if(particles.size() > 0){
        float[] lastPosition = particles.get(particles.size() - 1);
        line(currentPosition[0], currentPosition[1], lastPosition[0], lastPosition[1]);
    }


    particles.add(currentPosition);
    circle(currentPosition[0], currentPosition[1], 20);
}