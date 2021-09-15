ArrayList<PVector> particles = new ArrayList<PVector>();
boolean mouseDown = false;
int particleIndex;

void setup() {
  size(600, 600);
  background(200);
  frameRate(7);
  textSize(10);
  strokeWeight(1);
}

void draw() {
    background(200);

    if(particles.size() == 0) return;
    for (int i = 0; i < particles.size(); i++) {
        for (int j = 0; j < particles.size(); j++) {
            float distance = PVector.dist(particles.get(j), particles.get(i));
            if(j >= i) continue;
            stroke(150);

            if(distance < 10){
                particles.remove(i);
                mouseDown = false;
                continue;
            }

            if(distance < 100){
                line(particles.get(j).x, particles.get(j).y, particles.get(i).x, particles.get(i).y);
                fill(150);

                PVector mid = PVector.lerp(particles.get(j), particles.get(i), 0.5);
                float angle = getAngle(particles.get(j), particles.get(i));

                pushMatrix();
                    translate(mid.x , mid.y);
                    rotate(angle);
                    translate(-10, -5);

                    text(nf(distance, 0, 1), 0, 0);
                popMatrix();
            }

        }

    }

    // Draw circles
    for (PVector particle : particles) {
         if(dist(particle.x, particle.y, mouseX, mouseY) < 10){
            fill(255, 0, 0);
            stroke(255, 0, 0);
        } else{
            fill(0);
            stroke(0);
        }
        circle(particle.x, particle.y, 15);
    }

}


void mouseClicked() {
    PVector currentPosition = new PVector(mouseX, mouseY);
    for (PVector particle : particles) {
        float distance = PVector.dist(currentPosition, particle);
        if(distance < 50) return;
    }
    particles.add(new PVector(mouseX, mouseY));
}

void keyPressed() {
    if ( key == ' ' )  {
        background(200);
        particles = new ArrayList<PVector>();
    }
}

void mousePressed() {

    for (int i = 0; i < particles.size(); i++) {
        if(dist(particles.get(i).x, particles.get(i).y, mouseX, mouseY) < 10){
            particleIndex = i;
            mouseDown = true;
        }
    }
}


void mouseDragged() {
    PVector currentPosition = new PVector(mouseX, mouseY);

    if(mouseDown) {
        particles.set(particleIndex, currentPosition);
    }
}

void mouseReleased() {
    mouseDown = false;
}

float getAngle(PVector a, PVector b){
    float x = b.x - a.x;
    float y = b.y - a.y;

    return atan2(y, x);
}