int x = 15;

class Snow {
    float x = 0.0;
    float y = 0.0;
    float speed = 0.0;
    float size = 0.0;
    color c;

    public Snow(float x, float y, float speed, float size, color c) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.size = size;
        this.c = c;
    }

    public void draw() {
        fill(c);
        ellipse(x, y, size, size);
    }

    public void move() {
        y += speed;

    }

}

ArrayList<Snow> snow = new ArrayList<Snow>();

void setup() {
  size(500, 500);
  noStroke();
}

void draw() {

    background(100);

    for (int i = 0; i < snow.size(); i++) {
        snow.get(i).draw();
        snow.get(i).move();
        if(snow.get(i).y > height) {
            snow.remove(i);
        }
    }

}

void mouseDragged() {
    Snow newSnow = new Snow(mouseX, mouseY, random(2, 10), random(2, 20), color(random(150,255)));
    snow.add(newSnow);
}
