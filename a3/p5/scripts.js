let bluePrints = [];
let currentBuildings = [];

const CELL_SIZE = 150;
const GRID_SIZE = CELL_SIZE * 5;

const SIDE_WIDTH = 200;
const TOP_HEIGHT = 100;

let selectedBlueprint = -1;
let score = 0;

class BluePrint {
    optionIndex;
    img;
    constructor(img, optionIndex, name) {
        this.img = loadImage(img);
        this.optionIndex = optionIndex;
        this.name = name;
    }

    draw() {
        image(this.img, 50, 50 + (10 + CELL_SIZE) * this.optionIndex, CELL_SIZE, CELL_SIZE / 2);
    }
}

class Building {
    position;
    optionIndex;


    constructor(optionIndex, position) {
        this.position = position;
        this.optionIndex = round(optionIndex);
    }

    draw() {
        print(this.optionIndex)
        image(bluePrints[this.optionIndex].img, this.position.x, this.position.y, CELL_SIZE, CELL_SIZE / 2);
        print("DRAW BUILDING \n");
    }

}

function setup() {
    createCanvas(1000, 1000);
    frameRate(20);
    bluePrints.push(new BluePrint("../assets/base.png", 0, "Hospital"));
    bluePrints.push(new BluePrint("../assets/base.png", 1, "House"));
    bluePrints.push(new BluePrint("../assets/base.png", 2, "School"));
    bluePrints.push(new BluePrint("../assets/base.png", 3, "University"));
    bluePrints.push(new BluePrint("../assets/base.png", 4, "Drug Den"));

    refreshGrid();
}

function drawButtons() {
    fill(230);
    rect(0, height - 60, SIDE_WIDTH, 60);
    fill(0);
    textSize(20);
    text("DELETE", 60, height - 30);
}

function refreshGrid() {
    background(200);
    strokeWeight(1);
    stroke(100);


    const y1 = TOP_HEIGHT;
    const y2 = TOP_HEIGHT + GRID_SIZE;

    for (let i = 0; i < GRID_SIZE * 3; i += CELL_SIZE) {
        const x1 = SIDE_WIDTH - 2 * GRID_SIZE + i;
        const x2 = SIDE_WIDTH + i;
        line(x1, y1, x2, y2);
        line(x2, y1, x1, y2);
    }

    bluePrints.forEach(b => {
        b.draw();
    });

    currentBuildings.forEach(b => {
        b.draw();
    })

    drawButtons();
    drawStats();
}


function drawStats() {
    fill(0);
    textSize(20);
    text("Score: " + score, width - 400, 20);
    text("Buildings: " + currentBuildings.length, width - 400, 50);

    if (selectedBlueprint != -1) {
        console.log(selectedBlueprint)
        console.log(bluePrints)

        text("Selected Building: " + bluePrints[round(selectedBlueprint)].name, width - 400, 80);
    }
}


function mouseClicked() {
    const MOUSE = new createVector(mouseX, mouseY);
    const V1 = new createVector(mouseX, mouseY + 1000);
    const V2 = new createVector(mouseX, 0);
    const Y1 = TOP_HEIGHT;
    const Y2 = TOP_HEIGHT + GRID_SIZE;

    if (MOUSE.x < SIDE_WIDTH) {
        //in options column
        if (MOUSE.x > 50 && MOUSE.x < 50 + CELL_SIZE) {

            const index = (MOUSE.y - 50) / (10 + CELL_SIZE);
            if (index >= 0 && index < bluePrints.length) {
                selectedBlueprint = index;
            }
        }
        // if clicked button
        if (MOUSE.y > height - 60) {
            // delete
            selectedBlueprint = -1;
        }

        refreshGrid();
        return;
    }

    let gridLineB = [];
    let gridLineA = [];

    // Find cell
    for (let i = 0; i < GRID_SIZE * 3; i += CELL_SIZE) {
        const X1 = SIDE_WIDTH - 2 * GRID_SIZE + i;
        const X2 = SIDE_WIDTH + i;

        // increasing lines
        let lineA1 = new createVector(X2, Y1);
        let lineA2 = new createVector(X1, Y2);

        // decreasing lines
        let lineB1 = new createVector(X1, Y1);
        let lineB2 = new createVector(X2, Y2);

        // find last line above cell
        if (findIntersection(V1, V2, lineA1, lineA2).y < MOUSE.y) {
            gridLineA[0] = lineA1;
            gridLineA[1] = lineA2;
        }

        // find last line below cell
        if (findIntersection(V1, V2, lineB2, lineB1).y > MOUSE.y) {
            gridLineB[0] = lineB1;
            gridLineB[1] = lineB2;
        }
    }

    // left corner of cell
    // using the intersection of the grid lines
    let pointA = findIntersection(gridLineB[0], gridLineB[1], gridLineA[0], gridLineA[1]);

    // center of cell to the top left
    pointA.y = pointA.y - CELL_SIZE / 4;

    // find and delete building
    if (selectedBlueprint == -1) {
        currentBuildings = currentBuildings.filter(b => {
            score += 1;
            return !(b.position.x == pointA.x && b.position.y == pointA.y);
        })
        refreshGrid();
        return;
    }

    // add building if not already there
    let found = false;
    currentBuildings.forEach(b => {
        if (b.position.x == pointA.x && b.position.y == pointA.y) {
            found = true;
            return
        }
    })

    if (!found) {
        currentBuildings.push(new Building(selectedBlueprint, pointA));
        refreshGrid();
    }


}


function findIntersection(p1, p2, p3, p4) {
    const d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x);

    let xi = ((p3.x - p4.x) * (p1.x * p2.y - p1.y * p2.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / d;
    let yi = ((p3.y - p4.y) * (p1.x * p2.y - p1.y * p2.x) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / d;

    return new createVector(xi, yi);
}