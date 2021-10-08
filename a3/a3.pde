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

    drawBackground();
}

void draw() {
    // background(200);
    // drawBackground();

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
    // background(200);

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
    final PVector MOUSE = new PVector(mouseX, mouseY);
    final PVector V1 = new PVector(mouseX, mouseY + 1000);
    final PVector V2 = new PVector(mouseX, 0);
    final int Y1 = TOP_HEIGHT;
    final int Y2 = TOP_HEIGHT + GRID_SIZE;

    // if (mouseX < SIDE_WIDTH) {
    //     //in options column
    //     if(currentPosition.x > 50 && currentPosition.x < 50 + CELL_SIZE){

    //         float index = (currentPosition.y-50)/(10+ CELL_SIZE);
    //         if(index >= 0 && index < bluePrints.size()){
    //             selectedBlueprint = (int)index;
    //         }
    //     }

    //     // if clicked button
    //     if(currentPosition.y > height - 60){
    //             // delete
    //             selectedBlueprint = -1;
    //     }

    //     return;
    // }




    PVector[] gridLineB = new PVector[2];
    PVector[] gridLineA = new PVector[2];


    for(int i = 0; i < GRID_SIZE * 3 ; i += CELL_SIZE) {
        final int X1 = SIDE_WIDTH - 2 * GRID_SIZE + i;
        final int X2 = SIDE_WIDTH + i;

        PVector lineA1 = new PVector(X2, Y1);
        PVector lineA2 = new PVector(X1, Y2);

        PVector lineB1 = new PVector(X1, Y1);
        PVector lineB2 = new PVector(X2, Y2);

        if(findIntersection(V1, V2, lineA1, lineA2).y < MOUSE.y){
            gridLineA[0] = lineA1;
            gridLineA[1] = lineA2;

        }

        if(findIntersection(V1, V2, lineB2, lineB1).y > MOUSE.y){
            gridLineB[0] = lineB1;
            gridLineB[1] = lineB2;
        }
    }



        // if(V5.y > currentPosition.y)
        // continue;

        // gridB = new PVector(gridA.x, gridA.y - CELL_SIZE/2);

        // left corner of cell
        PVector pointA = findIntersection(gridLineB[0], gridLineB[1], gridLineA[0], gridLineA[1]);
        // PVector pointB = findIntersection(gridLineB[0], gridLineB[1], gridLineA[0], gridLineA[1]);



        fill(250, 0,0);
        // circle(pointA.x, pointA.y, 10);
        circle(pointA.x, pointA.y - CELL_SIZE/4, 10);
        fill(250, 255,0);

        circle(pointA.x + CELL_SIZE/2, pointA.y , 10);



    // if(selectedBlueprint == -1) {
    //     // delete building
    //     for(Building b : currentBuildings) {
    //         if(b.position.x == currentPosition.x && b.position.y == currentPosition.y) {
    //             currentBuildings.remove(b);
    //             score += 1;
    //             return;
    //         }
    //     }
    //     return;
    // }



    // // add building if not already there
    // boolean found = false;
    // for(Building b : currentBuildings) {
    //     if(b.position.x == currentPosition.x && b.position.y == currentPosition.y) {
    //         found = true;
    //         return;
    //     }
    // }


    // currentBuildings.add(new Building(selectedBlueprint, currentPosition));
    currentBuildings.sort(null);
}


PVector findIntersection(PVector p1, PVector p2, PVector p3, PVector p4) {
    float x1 = p1.x;
    float y1 = p1.y;
    float x2 = p2.x;
    float y2 = p2.y;
    float x3 = p3.x;
    float y3 = p3.y;
    float x4 = p4.x;
    float y4 = p4.y;

    float d = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
    if (d == 0) return null;  // parallel

    float xi = ((x3-x4)*(x1*y2-y1*x2)-(x1-x2)*(x3*y4-y3*x4))/d;
    float yi = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4))/d;

    return new PVector(xi, yi);
}