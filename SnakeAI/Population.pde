import java.util.Collections;

class Population {

  Snake[] snakes;
  Snake bestSnake;
  int sameBest = 0;
  float recordFitness = 0;
  int size;
  boolean done;  

  Population(int size) {
    this.size = size;
    snakes = new Snake[size];
    for (int i = 0; i<size; i++) {
      snakes[i] = new Snake();
    }
    bestSnake = snakes[0].cloneForReplay();
  }

  void show() {
    if (replayingBest) {
      bestSnake.show();
    } else {
      for (Snake s : snakes) {
        s.show();
      }
    }
  }

  void update() {
    for (Snake s : snakes) {
      if (!s.dead) {
        s.update();
      }
    }
    if (!bestSnake.dead) {
      bestSnake.update();
    }
  }

  boolean isDone() {
    if (!bestSnake.dead) return false;
    for (Snake s : snakes) {
      if (!s.dead) {
        return false;
      }
    }
    return true;
  }

  void evaluate() {
    for (Snake s : snakes) {
      s.calculateFitness();
    }

    float bestFitness = 0;
    int bestIndex = 0;
    for (int i = 0; i<snakes.length; i++) {
      if (snakes[i].fitness>bestFitness) {
        bestFitness = snakes[i].fitness;
        bestIndex = i;
      }
    }

    //if (bestFitness>recordFitness) {
    //mutationRate = 0.05;
    //sameBest = 0;
    //recordFitness = bestFitness;
    bestSnake = snakes[bestIndex].cloneForReplay();
    //} else {
    //bestSnake = bestSnake.cloneForReplay();
    //sameBest++;
    //if (sameBest>=3) {
    //  mutationRate+=0.01;
    //}
    //}

    //snakes[bestIndex].fitness*=10;

    for (int i = 0; i<snakes.length; i++) {
      //if (snakes[i].crashedWall && i!=bestIndex) snakes[i].fitness/=10.0;
      if(snakes[i].score==snakes[bestIndex].score) snakes[i].fitness*=10;
      snakes[i].fitness/=bestFitness;
    }
  }

  void selection() {
    Snake[] newSnakes = new Snake[snakes.length];
    ArrayList<Snake> matingPool = new ArrayList<Snake>();
    for (int i = 0; i<snakes.length; i++) {
      int n = floor(snakes[i].fitness*100);
      for (int j = 0; j<n; j++) {
        matingPool.add(snakes[i]);
      }
    }

    //Collections.shuffle(matingPool);

    //newSnakes[0] = bestSnake;

    for (int m = 0; m<newSnakes.length; m++) {
      Snake parentA = matingPool.get((int)(random(1)*matingPool.size()));
      Snake parentB = matingPool.get((int)(random(1)*matingPool.size()));
      Snake child = parentA.crossOver(parentB);
      child.mutate();
      //newSnakes[m] = child.clone();
      newSnakes[m] = child;
    }

    for (int i = 0; i<snakes.length; i++) {
      snakes[i] = newSnakes[i];
    }
  }
}
