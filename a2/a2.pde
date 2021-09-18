float x = -450;

class Stage {
    PImage characterImg, pramImg, backgroundImg;
    int pramOffset, pramBaseOffset, pramasCount, index;

    Stage (String path, int pramBaseOffset, int pramOffset, int pramasCount, int index) {
        this.characterImg = loadImage(path + "/lady1.png");
        this.pramImg = loadImage(path + "/pram1.png");
        // this.backgroundImg = loadImage(path + "/back1.png");

        this.pramOffset = pramOffset;
        this.pramasCount = pramasCount;
        this.pramBaseOffset = pramBaseOffset;
        this.index = index;
    }

    void drawframe(float x){

        clip(this.index * 333, 0, 333, 1000);
        image(this.characterImg, x, 500, width/12, height/10);
        image(this.pramImg, x + this.pramBaseOffset, 550, width/20, height/20);
        for(int i = 1; i < pramasCount; i++){
            image(this.pramImg, x + this.pramBaseOffset + this.pramOffset* i, 550, width/20, height/20);
        }
        noClip();
    }

}

Stage[] stages = new Stage[3];
// Stage currentStage;
int lastStage = 0;



void setup() {
    stages[0] = new Stage("./assets/victorian", 72, 45, 8, 0);
    stages[1] = new Stage("./assets/modern", 82, 0, 1, 1);
    stages[2] = new Stage("./assets/future", 80, 45, 2, 2);

    size(999, 999);
    noStroke();
}

void draw() {
    background(255);
    fill(255);
    rect(0, 0, 333, 1000);
    stages[0].drawframe(x);
    fill(225);
    rect(333, 0, 333, 1000);
    stages[1].drawframe(x);
    fill(200);
    rect(666, 0, 333, 1000);
    stages[2].drawframe(x);
    if(x == 1000)x = -450;
    x += 1;
}