```java
float x = 50;
float y = 50;

void setup() {
  size(500, 500);
  frameRate(70);
  background(0);
  noStroke();
}

void draw() {
    if(y> 480) return;
    fill(255);
    if(y >= 450 || y < 100) fill(255, 0, 0);
    circle(x, y, 25);
    x++;
    if(x >= 450){
        x = 50;
        y+=50;
    }
}
```
