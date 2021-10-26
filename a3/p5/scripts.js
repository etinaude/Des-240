let bluePrints = [];
let currentBuildings = [];

const CELL_SIZE = 250;

let blueprintIndex = -1;
let score = 0;
let lockBuilding = false;

let lastReset = Date.now();
let lastRefresh = Date.now()

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
    locked;

    constructor(optionIndex, position, locked = false) {
        this.position = position;
        this.optionIndex = round(optionIndex);
        this.locked = locked;
    }

    draw() {
        image(bluePrints[this.optionIndex].img, this.position.x, this.position.y, CELL_SIZE, CELL_SIZE / 2);
    }

}

function setup() {
    createCanvas(750, 750);
    smooth();
    frameRate(20);
    bluePrints.push(new BluePrint("./assets/hospital.png", 0, "Hospital", [3, 1, 0.5, 0.2, 0.2, 0.2, 0.1]));
    bluePrints.push(new BluePrint("./assets/house.png", 1, "House", [0.15]));
    bluePrints.push(new BluePrint("./assets/school.png", 2, "School", [2, 1, 1, 0.5, 0.4, 0.2, 0.1]));
    bluePrints.push(new BluePrint("./assets/work.png", 3, "Workplace", [2, 2, 1, 1, 1, 0.5, 0.5]));
    bluePrints.push(new BluePrint("./assets/uni.png", 4, "University", [3, 0.5, 0.1, 0.05,]));
    bluePrints.push(new BluePrint("./assets/drug_den.png", 5, "Drug Den", [-2, -1, -0.5]));
    reset();
}

function draw() {
    if (Date.now() - lastRefresh > 1000 * 60 && lastRefresh != lastReset) {
        reset();
    }
}

function reset() {
    blueprintIndex = -1;
    currentBuildings = [];
    score = 20;

    bluePrints.forEach(b => {
        b.count = 0;
    })
    refreshGrid();
    drawBlueprints();


    document.getElementById("chart-inner").innerHTML = "";
    document.getElementById("modal").classList.remove("Hidden");

    const time = Date.now();

    lastReset = time;
    lastRefresh = time;
}

function placeInitial() {
    let x = 0;
    let y = 0;
    selectBluePrint(1);


    lockBuilding = true;
    for (let i = 0; i < 30; i++) {
        x = random(0, 800)
        y = random(0, 800)
        handleClicks(x, y);
    }
    lockBuilding = false;
    selectBluePrint(-1)


    refreshGrid();
}

function drawBlueprints() {
    let container = document.getElementById("blueprints");

    let item = document.createElement("div");
    item.classList.add("blueprints");


    container.innerHTML = "";
    bluePrints.forEach(b => {
        let img = document.createElement("img");
        img.src = b.src;
        img.width = CELL_SIZE * 0.8;

        let imgContainer = document.createElement("div");
        imgContainer.className = "imgContainer";
        imgContainer.appendChild(img);


        let count = document.createElement("div");
        count.className = "count-container";
        count.innerText = b.count;


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
        div.appendChild(count);
        div.appendChild(name);
        item.appendChild(div);
    })

    container.appendChild(item);

}

function updateGraph(previous, current, colour = "orange") {
    if (current == previous) {
        return;
    }

    let table = document.getElementById("chart-inner");
    table.innerHTML += `
    <tr>
    <td style="--start: ${previous / 20}; --size: ${current / 20}; --color: ${colour}"></td>
    </tr>`

    let bar = document.getElementById("marker")

    let barWidth = Math.sqrt(current / 0.002)
    bar.style.marginLeft = `${barWidth}%`;
}

function refreshGrid() {
    strokeWeight(1);
    stroke(150);
    background(255);
    drawBlueprints();
    // updateGraph();
    lastRefresh = Date.now();



    const y1 = 0;
    const y2 = width;

    for (let i = 0; i < width * 3; i += CELL_SIZE) {
        const x1 = -2 * width + i;
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

function selectBluePrint(id) {
    blueprintIndex = id;
    refreshGrid()
}

function deleteBuilding() {
    blueprintIndex = -1;
}

function handleClicks(x, y) {
    const V1 = new createVector(x, y + 1000);
    const V2 = new createVector(x, 0);

    let cell = findCell(V1, V2, y);
    if (cell == null) return;


    // find and delete building
    if (blueprintIndex == -1) {
        currentBuildings = currentBuildings.filter(b => {
            if (b.locked) return true;
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
        currentBuildings.push(new Building(blueprintIndex, cell, lockBuilding));
        refreshGrid();
    }
}

function mouseClicked() {
    handleClicks(mouseX, mouseY);
}

function findCell(V1, V2, Y) {
    let gridLineB = [];
    let gridLineA = [];

    for (let i = 0; i < width * 3; i += CELL_SIZE) {
        const X1 = -2 * width + i;
        const X2 = i;

        // increasing lines
        let lineA1 = new createVector(X2, 0);
        let lineA2 = new createVector(X1, width);

        // decreasing lines
        let lineB1 = new createVector(X1, 0);
        let lineB2 = new createVector(X2, width);

        // find last line above cell
        if (findIntersection(V1, V2, lineA1, lineA2).y < Y) {
            gridLineA[0] = lineA1;
            gridLineA[1] = lineA2;
        }

        // find last line below cell
        if (findIntersection(V1, V2, lineB2, lineB1).y > Y) {
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

    } catch (e) {
        console.log(e);
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

function done() {
    document.getElementById("modal").classList.add("Hidden");
    placeInitial();
    lastRefresh = Date.now()
}
