let bluePrints = [];
let currentBuildings = [];

const CELL_SIZE = 200;

let blueprintIndex = -1;
let score = 0;

class BluePrint {
    optionIndex;
    img;
    src;
    scoreArray = [];
    count;

    constructor(img, optionIndex, name, scoreArray) {
        this.img = loadImage(img);
        this.optionIndex = optionIndex;
        this.name = name;
        this.src = img;
        this.scoreArray = scoreArray;
        this.count = 0;
    }

    draw() {
        image(this.img, 50, 50 + (10 + CELL_SIZE) * this.optionIndex, CELL_SIZE, CELL_SIZE / 2);
    }

    getScore(index) {
        if (index > this.scoreArray.length) {
            return this.scoreArray[this.scoreArray.length - 1];
        }
        return this.scoreArray[index - 1];

    }

}

class Building {
    position;
    optionIndex;

    constructor(optionIndex, position,) {
        this.position = position;
        this.optionIndex = round(optionIndex);
    }

    draw() {
        image(bluePrints[this.optionIndex].img, this.position.x, this.position.y, CELL_SIZE, CELL_SIZE / 2);
    }

}

function setup() {
    createCanvas(800, 800);
    frameRate(20);
    bluePrints.push(new BluePrint("../assets/base.png", 0, "Hospital", [3, 1, 0.5, 0.2, 0.2, 0.2, 0.1]));
    bluePrints.push(new BluePrint("../assets/base.png", 1, "House", [0.15]));
    bluePrints.push(new BluePrint("../assets/base.png", 2, "School", [2, 1, 1, 0.5, 0.4, 0.2, 0.1]));
    bluePrints.push(new BluePrint("../assets/base.png", 3, "Workplace", [2, 2, 1, 1, 0.5, 0.5]));
    bluePrints.push(new BluePrint("../assets/base.png", 4, "University", [3, 0.5, 0.1, 0.05,]));
    bluePrints.push(new BluePrint("../assets/base.png", 5, "Drug Den", [-2, -1, -0.5]))
    drawBlueprints();

    refreshGrid();
}

function drawBlueprints() {
    let container = document.getElementById("blueprints");

    container.innerHTML = "";
    bluePrints.forEach(b => {
        let img = document.createElement("img");
        img.src = b.src;
        img.width = CELL_SIZE * 0.8;

        let imgContainer = document.createElement("div");
        imgContainer.className = "imgContainer";
        imgContainer.appendChild(img);

        let name = document.createElement("h4");
        name.innerHTML = b.name;


        let div = document.createElement("div");
        if (blueprintIndex == b.optionIndex) {
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

function updateGraph(previous, current, colour = "orange") {
    print(previous, current);
    if (!previous || !current || selectBluePrint == -1 || current == previous) {
        return
    }
    element = document.getElementById("chart-inner");
    element.innerHTML += `
    <tr>
    <td style="--start: ${previous / 20}; --size: ${current / 20}; --color: ${colour}"></td>
    </tr>`
}

function refreshGrid() {
    strokeWeight(1);
    stroke(100);
    background(255);
    drawBlueprints();
    updateGraph()


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
    getScore();
    document.getElementById("score").innerHTML = score;
    document.getElementById("total").innerHTML = currentBuildings.length;

    if (blueprintIndex > 0) {
        document.getElementById("selected").innerHTML = bluePrints[blueprintIndex].name;
    } else {
        document.getElementById("selected").innerHTML = "None";
    }
}

function getScore() {
    const previousScore = score;
    // default fertility rate is 20BPW
    score = 20
    var blueprintDict = {}
    currentBuildings.forEach(b => {
        if (blueprintDict[b.optionIndex] == undefined) {
            blueprintDict[b.optionIndex] = 0;
        }
        blueprintDict[b.optionIndex]++;
        score -= bluePrints[b.optionIndex].getScore(blueprintDict[b.optionIndex])
    })

    if (score < 0) {
        score = 0;
    }

    if (score > 20) {
        score = 20;
    }

    score = Math.round(score * 100) / 100;

    if (score <= 3 && score >= 1.5) {
        updateGraph(previousScore, score, "green");
    } else if (score > 3 && score < 5) {
        updateGraph(previousScore, score, "yellow");
    } else if (score < 1.5 && score > 1) {
        updateGraph(previousScore, score, "yellow");
    } else {
        updateGraph(previousScore, score, "red");
    }

}

function selectBluePrint(id) { blueprintIndex = id; refreshGrid() }

function deleteBuilding() {
    blueprintIndex = -1;
}

function mouseClicked() {
    let cell = findCell();
    if (cell == null) return;


    // find and delete building
    if (blueprintIndex == -1) {
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
    var selectedBluePrint = bluePrints[blueprintIndex]
    if (!found) {
        selectedBluePrint.count++;
        currentBuildings.push(new Building(blueprintIndex, cell));
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
    try {
        let pointA = findIntersection(gridLineB[0], gridLineB[1], gridLineA[0], gridLineA[1]);
        // center of cell to the top left
        pointA.y = pointA.y - CELL_SIZE / 4;

        if (pointA.x < 0 || pointA.y < 0) return null;
        if (pointA.x + (CELL_SIZE / 2) >= width || pointA.y + (CELL_SIZE / 4) >= width) return null;
        return pointA;

    }
    catch (e) {
        return null;
    }


}

function findIntersection(p1, p2, p3, p4) {
    if (p1 == undefined || p2 == undefined || p3 == undefined || p4 == undefined) return

    const d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x);

    let xi = ((p3.x - p4.x) * (p1.x * p2.y - p1.y * p2.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) / d;
    let yi = ((p3.y - p4.y) * (p1.x * p2.y - p1.y * p2.x) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) / d;

    return new createVector(xi, yi);
}