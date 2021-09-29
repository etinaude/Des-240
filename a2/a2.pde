class Stage {
    PImage characterImg, characterImg2,  pramImg, pramImg2;
    int toggle =  100;
    int pramWidth = 75;
    int pramBaseOffset = 100; // distance from parm to lady
    int y = 500;
    int pramasCount, index;


    Stage (String path, int pramasCount, int index) {

        // load images
        this.characterImg = loadImage(path + "/lady1.png");
        this.characterImg2 = loadImage(path + "/lady2.png");
        this.pramImg = loadImage(path + "/pram1.png");
        this.pramImg2 = loadImage(path + "/pram2.png");

        // initalise parameters
        this.pramasCount = pramasCount;
        this.index = index;
    }


    void drawframe(float x){
        // If out of area dont draw (for performace)
        if(x > (index + 1) * 333 + 10) return;
        if((index) * 333 >  pramBaseOffset + (pramWidth * pramasCount) + x) return;

        // clip drawing to area
        clip(index * 333, 0, 333, 1000);

        boolean drawFirst = int(x + 1000) % toggle < toggle/2; // calculates which image sets to draw

        // draws lady and first pram
        if (drawFirst) {
            image(characterImg, x, y, width/8, height/6);
            image(pramImg, x + pramBaseOffset , y + 60, width/12, height/10);
        } else {
            image(characterImg2, x, y, width/8, height/6);
            image(pramImg2, x + pramBaseOffset , y + 60, width/12, height/10);
        }

        // draws subsequent prams
        for(int i = 1; i < pramasCount; i++){
            float currentX = x + pramBaseOffset + (pramWidth * i);
            if (drawFirst) {
                image(pramImg, currentX, y + 60, width/12, height/10);
            } else {
                image(pramImg2, currentX, y + 60, width/12, height/10);
            }
        }
    }

}

float x = -200;
Stage[] stages = new Stage[3];
PImage backgroundImg;

void setup() {
    // initalise stages
    stages[0] = new Stage("./assets/victorian", 3, 0);
    stages[1] = new Stage("./assets/modern",  1, 1);
    stages[2] = new Stage("./assets/future",  2, 2);
    backgroundImg = loadImage("./assets/background.png");


    // cleaner devision into 3
    size(999, 999);
    noStroke();
    frameRate(40);

    image(backgroundImg, 0, 0, width, height);
}

void draw() {
    image(backgroundImg, 0, 0, width, height);
    stages[0].drawframe(x);
    stages[1].drawframe(x);
    stages[2].drawframe(x);


    // reset loop
    if(x == 1000) {
        x = -200;
    }
    x += 3;
}
