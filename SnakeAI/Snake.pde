import java.util.Arrays;

class Snake {

  ArrayList<PVector> body = new ArrayList<PVector>();
  PVector velocity = new PVector();
  int len = 0;
  boolean dead = false;
  boolean crashedWall = false;

  Food food;
  ArrayList<Food> foodList = new ArrayList<Food>();
  int foodIterator = 0;

  Brain brain;
  float[] vision = new float[24];

  int score = 0;
  float fitness = 0;
  boolean replaying = false;
  int timeAlive = 0;
  int remainingMoves = 200;

  Snake() {
    body.add(new PVector(width/2, height/2));
    len++;
    score++;
    if (!humanPlaying) {
      body.add(new PVector((width/2)-size, height/2));
      body.add(new PVector((width/2)-(2*size), height/2));
      brain = new Brain();
      len+=2;
      score+=2;
    }
    spawnFood();
  }

  void spawnFood() {
    if (replaying) {
      food = foodList.get(foodIterator++);
    } else {
      do {
        food = new Food();
      } while (bodyCollide((int)food.pos.x, (int)food.pos.y) || foodCollide((int)body.get(0).x, (int)body.get(0).y));
      foodList.add(food.clone());
    }
  }

  boolean bodyCollide(int x, int y) {
    for (int i = 1; i<body.size(); i++) {
      PVector v = body.get(i);
      if (v.x==x&&v.y==y) return true;
    }
    return false;
  }

  boolean wallCollide(int x, int y) {
    if (x>=width) return true;
    if (x<0) return true;
    if (y>=height) return true;
    if (y<0) return true;
    return false;
  }

  boolean foodCollide(int x, int y) {
    return food.pos.x==x && food.pos.y==y;
  }

  void look() {
    vision = new float[24];

    float[] tmp = lookInDir(new PVector(-size, -size));
    vision[0] = tmp[0];
    vision[1] = tmp[1];
    vision[2] = tmp[2];
    tmp = lookInDir(new PVector(0, -size));
    vision[3] = tmp[0];
    vision[4] = tmp[1];
    vision[5] = tmp[2];
    tmp = lookInDir(new PVector(size, -size));
    vision[6] = tmp[0];
    vision[7] = tmp[1];
    vision[8] = tmp[2];
    tmp = lookInDir(new PVector(size, 0));
    vision[9] = tmp[0];
    vision[10] = tmp[1];
    vision[11] = tmp[2];
    tmp = lookInDir(new PVector(size, size));
    vision[12] = tmp[0];
    vision[13] = tmp[1];
    vision[14] = tmp[2];
    tmp = lookInDir(new PVector(0, size));
    vision[15] = tmp[0];
    vision[16] = tmp[1];
    vision[17] = tmp[2];
    tmp = lookInDir(new PVector(-size, size));
    vision[18] = tmp[0];
    vision[19] = tmp[1];
    vision[20] = tmp[2];
    tmp = lookInDir(new PVector(-size, 0));
    vision[21] = tmp[0];
    vision[22] = tmp[1];
    vision[23] = tmp[2];
  }

  float[] lookInDir(PVector dir) {
    float[] res = new float[3];
    boolean foundFood = false;
    boolean foundBody = false;
    int distance = 1;

    PVector pos = new PVector(body.get(0).x, body.get(0).y);
    pos.add(dir);

    while (!wallCollide((int)pos.x, (int)pos.y)) {
      if (replaying&&seeVision) {
        fill(255);
        strokeWeight(1);
        ellipse(pos.x, pos.y, size, size);
      }
      if (!foundFood && foodCollide((int)pos.x, (int)pos.y)) {
        res[0] = 1;
        foundFood = true;
        if (replaying&&seeVision) {
          fill(0, 0, 255);
          ellipse(pos.x, pos.y, size, size);
        }
      }
      if (!foundBody && bodyCollide((int)pos.x, (int)pos.y)) {
        res[1] = 1;
        foundBody = true;
        if (replaying&&seeVision) {
          fill(0, 255, 0);
          ellipse(pos.x, pos.y, size, size);
        }
      }
      distance++;
      pos.add(dir);
    }
    res[2] = 1.0/distance;
    return res;
  }

  void think() {
    float[] a = brain.feedForward(vision);
    float max = 0;
    int dir = 0;
    for (int i = 0; i<a.length; i++) {
      if (a[i]>max) {
        max = a[i];
        dir = i;
      }
    }
    if (dir == 0 && velocity.y==0) {
      velocity.y = -size;
      velocity.x = 0;
    } else if (dir==1 && velocity.y==0) {
      velocity.y = size;
      velocity.x = 0;
    } else if (dir==2 && velocity.x==0) {
      velocity.y = 0;
      velocity.x = -size;
    } else if (dir==3 && velocity.x==0) {
      velocity.y = 0;
      velocity.x = size;
    }
  }


  void calculateFitness() {
    if (score < 10) {
      fitness = floor(timeAlive * timeAlive) * pow(2, score);
    } else {
      fitness = floor(timeAlive * timeAlive);
      fitness *= pow(2, 10);
      fitness *= (score-9);
    }
    //fitness = score;
  }

  Snake crossOver(Snake parent) {
    Snake child = new Snake();
    child.brain = brain.crossOver(parent.brain);
    return child;
  }

  void mutate() {
    brain.mutate();
  }

  Snake clone() {
    Snake clone = new Snake();
    clone.brain = brain.clone();
    return clone;
  }

  Snake cloneForReplay() {
    Snake s = new Snake();
    s.foodList = new ArrayList<Food>();
    s.foodIterator = 0;
    s.brain = brain.clone();
    for (Food f : foodList) {
      s.foodList.add(f.clone());
    }
    s.food = s.foodList.get(s.foodIterator);
    s.foodIterator++;
    s.replaying = true;
    return s;
  }


  void show() {
    food.show();
    stroke(0);
    fill(255);
    for (PVector b : body) {
      rect(b.x, b.y, size, size);
    }
  }

  void update() {

    if (!dead) {
      timeAlive++;
      remainingMoves--;
      if (remainingMoves==0) {
        dead = true;
      }
      if (velocity.x!=0 || velocity.y!=0) {
        for (int i = body.size()-1; i>0; i--) {
          body.get(i).x = body.get(i-1).x;
          body.get(i).y = body.get(i-1).y;
        }
        body.get(0).add(velocity);
      }

      if (wallCollide((int)body.get(0).x, (int)body.get(0).y) || bodyCollide((int)body.get(0).x, (int)body.get(0).y)) {
        if(wallCollide((int)body.get(0).x, (int)body.get(0).y)){
          crashedWall = true;
        }
        dead = true;
      }

      if (foodCollide((int)body.get(0).x, (int)body.get(0).y)) {
        if (!humanPlaying) {
          if (remainingMoves < 500) {
            if (remainingMoves > 400) {
              remainingMoves = 500;
            } else {
              remainingMoves+=100;
            }
          }
        }
        body.add(new PVector(body.get(body.size()-1).x, body.get(body.size()-1).y));
        len++;
        score++;
        spawnFood();
      }

      if (!humanPlaying) {
        look();
        think();
      }
    }
  }
}
