float x = -200;

class Stage {
    PImage characterImg, pramImg, backgroundImg, pramImg2;
    int pramOffset, pramBaseOffset, pramasCount, index;

    Stage (String path, int pramasCount, int index) {
        this.characterImg = loadImage(path + "/lady1.png");
        this.pramImg = loadImage(path + "/pram1.png");
        this.backgroundImg = loadImage(path + "/background.png");

        // this.characterImg2 = loadImage(path + "/lady2.png");
        this.pramImg2 = loadImage(path + "/pram2.png");
        // this.backgroundImg2 = loadImage(path + "/background2.png");

        this.pramasCount = pramasCount;
        this.pramOffset = 45;
        this.pramBaseOffset = 68;
        this.index = index;
    }

    void drawBackground() {
          image(this.backgroundImg,this.index * 333, 0, 333, 1000);
    }

    void drawframe(float x){
        if(x > (this.index+1) * 333 + 10) return;
        if((this.index) * 333 >  this.pramBaseOffset + (this.pramOffset * pramasCount) + x) return;
        clip(this.index * 333, 0, 333, 1000);
        image(this.backgroundImg,this.index * 333, 0, 333, 1000);


        image(this.characterImg, x, 450, width/12, height/10);
        // if(int(x) % 2 == 0){
        //     image(this.pramImg, x + this.pramBaseOffset, 550, width/20, height/20);
        // }else{
        //     image(this.pramImg2, x + this.pramBaseOffset, 550, width/20, height/20);
        // }
         image(this.pramImg, x + this.pramBaseOffset , 500, width/17, height/15);



        for(int i = 1; i < pramasCount; i++){
            // if(int(x) % 2 == 0){
                image(this.pramImg, x + this.pramBaseOffset + this.pramOffset* i, 500, width/17, height/15);
            // }else{
            //     image(this.pramImg2, x + this.pramBaseOffset + this.pramOffset* i, 550, width/15, height/15);
            // }
        }
        noClip();
    }

}

Stage[] stages = new Stage[3];
int lastStage = 0;



void setup() {
    stages[0] = new Stage("./assets/victorian", 4, 0);
    stages[1] = new Stage("./assets/modern",  1, 1);
    stages[2] = new Stage("./assets/future",  2, 2);

    stages[0].drawBackground();
    stages[1].drawBackground();
    stages[2].drawBackground();

    size(999, 999);
    noStroke();
    frameRate(40);
}

void draw() {
    stages[0].drawframe(x);
    stages[1].drawframe(x);
    stages[2].drawframe(x);
    if(x == 1000)x = -200;
    x += 3;
}
