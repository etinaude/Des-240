class Stage {
    PImage characterImg, characterImg2,  pramImg, pramImg2, backgroundImg;
    int pramWidth = 45;
    int pramBaseOffset = 68; // distance from parm to lady
    int pramasCount, index;
    int toggle =  128;


    Stage (String path, int pramasCount, int index) {

        // load images
        this.backgroundImg = loadImage(path + "/background.png");
        this.characterImg = loadImage(path + "/lady1.png");
        this.characterImg2 = loadImage(path + "/lady2.png");
        this.pramImg = loadImage(path + "/pram1.png");
        this.pramImg2 = loadImage(path + "/pram2.png");

        // initalise parameters
        this.pramasCount = pramasCount;
        this.index = index;

        image(backgroundImg, index * 333, 0, 333, 1000);
    }


    void drawframe(float x){
        // If out of area dont draw (for performace)
        if(x > (index + 1) * 333 + 10) return;
        if((index) * 333 >  pramBaseOffset + (pramWidth * pramasCount) + x) return;

        // clip drawing to area
        clip(index * 333, 0, 333, 1000);
        image(backgroundImg,index * 333, 0, 333, 1000);

        boolean drawFirst = int(x + 1000) % toggle < toggle/2; // calculates which image sets to draw

        // draws lady and first pram
        if (drawFirst) {
            image(characterImg, x, 450, width/12, height/10);
            image(pramImg, x + pramBaseOffset , 480, width/17, height/15);
        } else {
            image(characterImg2, x, 450, width/12, height/10);
            image(pramImg2, x + pramBaseOffset , 480, width/17, height/15);
        }

        // draws subsequent prams
        for(int i = 1; i < pramasCount; i++){
            float currentX = x + pramBaseOffset + (pramWidth * i);
            if (drawFirst) {
                image(pramImg, currentX, 480, width/17, height/15);
            } else {
                image(pramImg2, currentX, 480, width/17, height/15);
            }
        }
    }

}

float x = -200;
Stage[] stages = new Stage[3];

void setup() {
    // initalise stages
    stages[0] = new Stage("./assets/victorian", 3, 0);
    stages[1] = new Stage("./assets/modern",  1, 1);
    stages[2] = new Stage("./assets/future",  2, 2);


    // cleaner devision into 3
    size(999, 999);
    noStroke();
    frameRate(40);
}

void draw() {
    stages[0].drawframe(x);
    stages[1].drawframe(x);
    stages[2].drawframe(x);

    // reset loop
    if(x == 1000) {
        x = -200
    }
    x += 3;
}
