ArrayList<BluePrint> bluePrints = new ArrayList<BluePrint>();
ArrayList<Building> currentBuildings = new ArrayList<Building>();

final int CELL_SIZE = 150;
final int GRID_SIZE = CELL_SIZE * 5;

final int SIDE_WIDTH = 200;
final int TOP_HEIGHT = 100;

int selectedBlueprint = -1;
int score= 0;

class BluePrint {
    int optionIndex;
    PImage img;
    color c;
    String name;

    // BluePrint(PImage img, int optionIndex, String name) {
    //     this.img = img;
    //     this.optionIndex = optionIndex;
    //     this.name = name;
    // }

    BluePrint(color c, int optionIndex, String name) {
        this.c = c;
        this.optionIndex = optionIndex;
        this.name = name;
    }

    public void  draw(){
            // draw option
        fill(c);
        noStroke();
        square(50, 50 + (10+ CELL_SIZE) * optionIndex , CELL_SIZE);
    }
}

class Building implements Comparable<Building>{
    PVector position;
    int optionIndex;


    Building(int optionIndex, PVector position) {
        this.position = position;
        this.optionIndex = optionIndex;
    }

    public void draw() {
        fill(bluePrints.get(optionIndex).c);
        noStroke();
        square(position.x, position.y, CELL_SIZE);

    }

    public int	compareTo(Building other) {
        return (int)(other.position.y - position.y);
    }

}



void setup() {
    size(1000, 1000);
    background(200);
    frameRate(20);
    textSize(10);
    strokeWeight(1);
    bluePrints.add(new BluePrint(color(random(150), random(200), random(100, 255)) , 0, "Hospital"));
    bluePrints.add(new BluePrint(color(random(150), random(200), random(100, 255)) , 1, "House"));
    bluePrints.add(new BluePrint(color(random(150), random(200), random(100, 255)) , 2, "School"));
    bluePrints.add(new BluePrint(color(random(150), random(200), random(100, 255)) , 3, "University"));
    bluePrints.add(new BluePrint(color(random(150), random(200), random(100, 255)) , 4, "Drug Den"));

}

void draw() {
    // background(200);
    drawBackground();

    // if(buildings.size() == 0) return;
    // for(BluePrint b : bluePrints) {
    //     b.draw();
    // }

    // for(Building b : currentBuildings) {
    //     b.draw();
    // }

    // draw stats

    fill(0);
    textSize(20);
    text("Score: " + score, width - 400, 20);
    text("Buildings: " + currentBuildings.size(), width - 400, 50);
    textSize(20);

    if(selectedBlueprint != -1) {
        text("Selected Building: " + bluePrints.get(selectedBlueprint).name , width - 400, 80);
    }

    drawButtons();
}

void drawBackground(){
    background(200);

    strokeWeight(1);
    stroke(100);


    int y1 = TOP_HEIGHT;
    int y2 = TOP_HEIGHT + GRID_SIZE;

    clip(SIDE_WIDTH, TOP_HEIGHT, GRID_SIZE, GRID_SIZE);
    for(int i = 0; i < GRID_SIZE * 3; i += CELL_SIZE) {
        int x1 = SIDE_WIDTH - 2 * GRID_SIZE + i;
        int x2 = SIDE_WIDTH + i;
        line(x1, y1,  x2 , y2);
        line(x2, y1,  x1 , y2);
    }

}

void drawButtons(){
    fill(230);
    rect(0, height - 60, SIDE_WIDTH, 60);
    fill(0);
    textSize(20);
    text("DELETE", 60, height - 30);
}


void mouseClicked() {
    PVector currentPosition = new PVector(mouseX, mouseY);
    if (mouseX < SIDE_WIDTH) {
        //in options column
        if(currentPosition.x > 50 && currentPosition.x < 50 + CELL_SIZE){

            float index = (currentPosition.y-50)/(10+ CELL_SIZE);
            if(index >= 0 && index < bluePrints.size()){
                selectedBlueprint = (int)index;
            }
        }

        // if clicked button
        if(currentPosition.y > height - 60){
                // delete
                selectedBlueprint = -1;
        }

        return;
    }

    currentPosition.x = currentPosition.x -  currentPosition.x % CELL_SIZE;
    currentPosition.y = currentPosition.y -  currentPosition.y % CELL_SIZE;

    if(selectedBlueprint == -1) {
        // delete building
        for(Building b : currentBuildings) {
            if(b.position.x == currentPosition.x && b.position.y == currentPosition.y) {
                currentBuildings.remove(b);
                score += 1;
                return;
            }
        }
        return;
    }



    // add building if not already there
    boolean found = false;
    for(Building b : currentBuildings) {
        if(b.position.x == currentPosition.x && b.position.y == currentPosition.y) {
            found = true;
            return;
        }
    }


    currentBuildings.add(new Building(selectedBlueprint, currentPosition));
    currentBuildings.sort(null);
}
