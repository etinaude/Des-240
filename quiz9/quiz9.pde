ArrayList<Block> blocks = new ArrayList<Block>();

class Block {
  int x;
  int y;
  color c;

  Block(int x, int y, color c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }

  void draw(){
    fill(c);
    rect(x, y, 50, 50);
  }
}

void setup() {
  size(600, 600);
  frameRate(3);
  stroke(50);
  strokeWeight(2);
}

void mousePressed() {
  blocks.add(new Block(mouseX, mouseY, color(random(255), random(255), random(255))));

  if(blocks.size() > 5) {
    blocks.remove(0);
  }

  background(200);
  for (Block b : blocks) {
    b.draw();
  }

}