ArrayList<Building> buildings = new ArrayList<Building>();
int gridSize = 50;
int sidebarWidth = 200;
int topWidth = 100;
int selectedBuilding = -1;

boolean mouseDown = false;

class Building {
    ArrayList<PVector> positions = new ArrayList<PVector>();
    PImage img;
    color c;

    int optionIndex;

    Building(PImage img, int optionIndex) {
        this.img = img;
        this.optionIndex = optionIndex;
    }

    Building(color c, int optionIndex) {
        this.c = c;
        this.optionIndex = optionIndex;
    }

    public void add(PVector p) {
        positions.add(p);
    }

    public void draw() {
        for (int i = 0; i < positions.size(); i++) {
            PVector p = positions.get(i);
            // image(img, p.x, p.y);
            fill(c);
            noStroke();
            square(p.x, p.y, gridSize);

        }

        // draw option
        fill(c);
        noStroke();
        square(50, 50 + (10+ gridSize) * optionIndex , gridSize);
    }

    public void update() {
        for (int i = 0; i < positions.size(); i++) {
            PVector p = positions.get(i);
            p.x += random(-1, 1);
            p.y += random(-1, 1);
        }
    }

    public void remove(int x, int y) {
        for (int i = 0; i < positions.size(); i++) {
            PVector p = positions.get(i);
            if (p.x == x && p.y == y) {
                positions.remove(i);
            }
        }
    }

    public void clear() {
        positions.clear();
    }
}



void setup() {
  size(1000, 1000);
  background(200);
  frameRate(70);
  textSize(10);
  strokeWeight(1);
    buildings.add(new Building(color(random(150), random(200), random(100, 255)) , 0));
    buildings.add(new Building(color(random(150), random(200), random(100, 255)) , 1));
    buildings.add(new Building(color(random(150), random(200), random(100, 255)) , 2));
    buildings.add(new Building(color(random(150), random(200), random(100, 255)) , 3));
    buildings.add(new Building(color(random(150), random(200), random(100, 255)) , 4));

}

void draw() {
    // background(200);
    drawBackground();

    // if(buildings.size() == 0) return;

    for (int i = 0; i < buildings.size(); i++) {
        Building b = buildings.get(i);
        b.draw();
    }



}

void drawBackground(){
  strokeWeight(1);

    for (int x = sidebarWidth; x < width; x += gridSize) {
        for (int y = topWidth; y < height; y += gridSize) {
            line(x, topWidth, x, height);
            line(sidebarWidth, y, width, y);
        }
    }
}


void mouseClicked() {
    PVector currentPosition = new PVector(mouseX, mouseY);
    if (mouseX < sidebarWidth) {
        // add building

        //in optionis column
        if(currentPosition.x > 50 && currentPosition.x < 50 + gridSize){

            float index = (currentPosition.y-50)/(10+ gridSize);
            selectedBuilding = (int)index;

        }

        return;
    }


    currentPosition.x = currentPosition.x -  currentPosition.x % gridSize;
    currentPosition.y = currentPosition.y -  currentPosition.y % gridSize;
    // fill(255, 0, 0);
    // square(currentPosition.x, currentPosition.y, gridSize);

    if(selectedBuilding == -1) return;

    buildings.get(selectedBuilding).add(currentPosition);
}

// void keyPressed() {
//     if ( key == ' ' )  {
//         background(200);
//     }
// }

// void mousePressed() {
//     mouseDown = true;
// }


// void mouseDragged() {
//     PVector currentPosition = new PVector(mouseX, mouseY);

//     if(mouseDown) {
//     }
// }

// void mouseReleased() {
//     mouseDown = false;
// }
