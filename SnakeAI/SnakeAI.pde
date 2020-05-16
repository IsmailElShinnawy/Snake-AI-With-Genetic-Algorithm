int cols;
int rows;

Snake snake;
Population pop;

/*
  SETTINGS
*/
int frameRate = 100;
int size = 20;

float mutationRate = 0.05;
int popSize = 10000;

boolean humanPlaying = false;
boolean replayingBest = true;
boolean seeVision = false;

int[] brainLayers = {24, 32, 32, 4};

void setup() {
  size(800, 800);
  cols = width/size;
  rows = height/size;
  frameRate(frameRate);
  if (humanPlaying) {
    snake = new Snake();
  } else {
    pop = new Population(popSize);
  }
}

void draw() {
  background(0);
  if (humanPlaying) {
    snake.update();
    snake.show(); 
    if (snake.dead) {
      snake = new Snake();
    }
  } else {
    if (pop.isDone()) {
      pop.evaluate();
      pop.selection();
    } else {
      pop.update();
      pop.show();
    }
  }
}

void keyPressed() {
  if (humanPlaying) {
    if (keyCode==UP && snake.velocity.y==0) {
      snake.velocity.y = -size;
      snake.velocity.x = 0;
    } else if (keyCode==DOWN && snake.velocity.y==0) {
      snake.velocity.y = size;
      snake.velocity.x = 0;
    } else if (keyCode==LEFT && snake.velocity.x==0) {
      snake.velocity.y = 0;
      snake.velocity.x = -size;
    } else if (keyCode==RIGHT && snake.velocity.x==0) {
      snake.velocity.y = 0;
      snake.velocity.x = size;
    }
  }
}
