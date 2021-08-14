/**
  Des 240 Assignment 1, showing data through geometric primitives


  by Etienne Naude, 2021
*/

// set up constants
final int WIDTH = 1200;
final int HEIGHT = 900;

final int SIZE = 15;
final float Y_SIZE = SIZE*1.1;
final float X_SIZE = SIZE*0.9;

final int X_MAX = int(WIDTH/(SIZE));
final int Y_MAX = int(HEIGHT/(SIZE));



// set up the grid variables
int[][] grid = new int[X_MAX + 1][Y_MAX + 1];
ArrayList<ArrayList<Integer>> liveCells = new startData().initalArray;



void setup() {
  size(1000, 1000);
  stroke(255);
  frameRate(2);
  for (int x = 0; x<X_MAX + 1; x++) {
    for (int y = 0; y<Y_MAX + 1; y++) {
      grid[x][y] = 0;
    }
  }

   for (int i = 0; i < liveCells.size(); ++i) {
    ArrayList<Integer> s = liveCells.get(i);
    int cell_x = s.get(0);
    int cell_y = s.get(1);
    grid[cell_x][cell_y] = 1;
  }
}


void draw() {

  for (int x = 0; x<X_MAX + 1; x++) {
    for (int y = 0; y<Y_MAX + 1; y++) {
      grid[x][y] = 0;
    }
  }

  for (int i = 0; i < liveCells.size(); ++i) {
    ArrayList<Integer> s = liveCells.get(i);
    int cell_x = s.get(0);
    int cell_y = s.get(1);
    grid[cell_x][cell_y] = 1;
  }


  liveCells.remove(int(random(liveCells.size())));
  print(liveCells.size());

  // toggles and renders every cell
  for (int x = 0; x < X_MAX ; x++) {
    for (int y = 0; y < Y_MAX; y++) {

        // default colour
        fill(100);
        stroke(100);

        // if cell is alive or ocean change the color
        if(grid[x][y] == 1){fill(200);}

        // draw hexagons (change location based on)
        if(x%2 ==0)drawHexagon(X_SIZE*x, Y_SIZE*y+Y_SIZE/2, SIZE*0.64);
        else drawHexagon(X_SIZE*x, Y_SIZE*y, SIZE*0.64);
    }
  }
}


/**
  draws hexagons with a given size in a given position

  @see https://processing.org/examples/regularpolygon.html

  @param  x  x-position
  @param  y  y-position
  @param  radius radius of the hexagon
*/
void drawHexagon(float x, float y, float radius) {
  pushMatrix();
  float angle = TWO_PI / 6;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
  popMatrix();
}
