let bluePrints = [];
let currentBuildings = [];

const CELL_SIZE = 150;

let selectedBlueprint = -1;
let score = 0;

class BluePrint {
    optionIndex;
    img;
    src;
    constructor(img, optionIndex, name) {
        this.img = loadImage(img);
        this.optionIndex = optionIndex;
        this.name = name;
        this.src = img;
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
    createCanvas(800, 800);
    frameRate(20);
    bluePrints.push(new BluePrint("../assets/base.png", 0, "Hospital"));
    bluePrints.push(new BluePrint("../assets/base.png", 1, "House"));
    bluePrints.push(new BluePrint("../assets/base.png", 2, "School"));
    bluePrints.push(new BluePrint("../assets/base.png", 3, "University"));
    bluePrints.push(new BluePrint("../assets/base.png", 4, "Drug Den"));
    drawBlueprints();

    refreshGrid();
}

function drawBlueprints() {
    let container = document.getElementById("blueprints");
    container.innerHTML = "<h3>Blue Prints</h3>";

    bluePrints.forEach(b => {
        let img = document.createElement("img");
        img.src = b.src;
        img.width = CELL_SIZE;

        let imgContainer = document.createElement("div");
        imgContainer.className = "imgContainer";
        imgContainer.appendChild(img);

        let name = document.createElement("h4");
        name.innerHTML = b.name;


        let div = document.createElement("div");
        if (selectedBlueprint == b.optionIndex) {
            div.className = "selected blueprint";
        } else {
            div.className = "blueprint";
        }

        div.id = b.optionIndex;
        div.onclick = function () {
            selectBluePrint(b.optionIndex);
        }
        div.appendChild(imgContainer);
        div.appendChild(name);
        container.appendChild(div);
    })

}


function refreshGrid() {
    strokeWeight(1);
    stroke(100);
    background(255);
    drawBlueprints();


    const y1 = 0;
    const y2 = width;

    for (let i = 0; i < width * 3; i += CELL_SIZE) {
        const x1 = - 2 * width + i;
        const x2 = i;
        line(x1, y1, x2, y2);
        line(x2, y1, x1, y2);
    }


    currentBuildings.forEach(b => {
        b.draw();
    })

    drawStats();
}


function drawStats() {
    document.getElementById("score").innerHTML = "Score: " + score;
    document.getElementById("total").innerHTML = "Buildings: " + currentBuildings.length;

    if (selectedBlueprint > 0) {
        document.getElementById("selected").innerHTML = "selected: " + bluePrints[selectedBlueprint].name;
    }
}

function selectBluePrint(id) { selectedBlueprint = id; }

function deleteBuilding() {
    selectedBlueprint = -1;
}



function mouseClicked() {
    let cell = findCell();

    // find and delete building
    if (selectedBlueprint == -1) {
        currentBuildings = currentBuildings.filter(b => {
            score += 1;
            return !(b.position.x == cell.x && b.position.y == cell.y);
        })
        refreshGrid();
        return;
    }

    // add building if not already there
    let found = false;
    currentBuildings.forEach(b => {
        if (b.position.x == cell.x && b.position.y == cell.y) {
            found = true;
            return
        }
    })

    if (!found) {
        currentBuildings.push(new Building(selectedBlueprint, cell));
        refreshGrid();
    }
}

function findCell() {
    const V1 = new createVector(mouseX, mouseY + 1000);
    const V2 = new createVector(mouseX, 0);

    let gridLineB = [];
    let gridLineA = [];

    for (let i = 0; i < width * 3; i += CELL_SIZE) {
        const X1 = - 2 * width + i;
        const X2 = i;

        // increasing lines
        let lineA1 = new createVector(X2, 0);
        let lineA2 = new createVector(X1, width);

        // decreasing lines
        let lineB1 = new createVector(X1, 0);
        let lineB2 = new createVector(X2, width);

        // find last line above cell
        if (findIntersection(V1, V2, lineA1, lineA2).y < mouseY) {
            gridLineA[0] = lineA1;
            gridLineA[1] = lineA2;
        }

        // find last line below cell
        if (findIntersection(V1, V2, lineB2, lineB1).y > mouseY) {
            gridLineB[0] = lineB1;
            gridLineB[1] = lineB2;
        }
    }

    // left corner of cell
    // using the intersection of the grid lines
    let pointA = findIntersection(gridLineB[0], gridLineB[1], gridLineA[0], gridLineA[1]);
    // center of cell to the top left
    pointA.y = pointA.y - CELL_SIZE / 4;

    return pointA;
}


function findIntersection(p1, p2, p3, p4) {
    if (p1 == undefined || p2 == undefined || p3 == undefined || p4 == undefined) return

    const d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x);

    let xi = ((p3.x - p4.x) * (p1.x * p2.y - p1.y * p2.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / d;
    let yi = ((p3.y - p4.y) * (p1.x * p2.y - p1.y * p2.x) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / d;

    return new createVector(xi, yi);
}