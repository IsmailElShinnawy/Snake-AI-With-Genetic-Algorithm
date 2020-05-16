class Brain {

  float[][] biases;
  float[][][] weights;
  int numberOfLayers;

  Brain() {
    numberOfLayers = brainLayers.length;
    biases = new float[numberOfLayers-1][];
    weights = new float[numberOfLayers-1][][];

    for (int i = 0; i<biases.length; i++) {
      biases[i] = new float[brainLayers[i+1]];
      for (int j = 0; j<biases[i].length; j++) {
        biases[i][j] = random(-1, 1);
      }
    }

    for (int i = 0; i<weights.length; i++) {
      weights[i] = new float[brainLayers[i+1]][brainLayers[i]];
      for (int j = 0; j<brainLayers[i+1]; j++) {
        for (int k = 0; k<brainLayers[i]; k++) {
          weights[i][j][k] = random(-1, 1);
        }
      }
    }
  }

  Brain crossOver(Brain parent) {
    Brain child = new Brain();
    for (int i = 0; i<weights.length; i++) {
      int r = floor(random(1)*weights[i].length);
      for (int j = 0; j<weights[i].length; j++) {
        int c = floor(random(1)*weights[i][j].length);
        for (int k = 0; k<weights[i][j].length; k++) {
          if (j<r || (j==r&&k<=c)) {
            child.weights[i][j][k] = weights[i][j][k];
          } else {
            child.weights[i][j][k] = parent.weights[i][j][k];
          }
        }
      }
    }
    for (int i = 0; i<biases.length; i++) {
      int r = floor(random(1)*biases[i].length);
      for (int j = 0; j<biases[i].length; j++) {
        if (j<=r) {
          child.biases[i][j] = biases[i][j];
        } else {
          child.biases[i][j] = parent.biases[i][j];
        }
      }
    }
    return child.clone();
  }

  void mutate() {
    for (int i = 0; i<weights.length; i++) {
      for (int j = 0; j<weights[i].length; j++) {
        for (int k = 0; k<weights[i][j].length; k++) {
          if (random(1)<mutationRate) {
            weights[i][j][k] = random(-1, 1);
          }
        }
      }
    }
    for (int i = 0; i<biases.length; i++) {
      for (int j = 0; j<biases[i].length; j++) {
        if (random(1)<mutationRate) {
          biases[i][j] = random(-1, 1);
        }
      }
    }
  }

  Brain clone() {
    Brain clone = new Brain();
    for (int i = 0; i<weights.length; i++) {
      for (int j = 0; j<weights[i].length; j++) {
        for (int k = 0; k<weights[i][j].length; k++) {
          clone.weights[i][j][k] = weights[i][j][k];
        }
      }
    }
    for (int i = 0; i<biases.length; i++) {
      for (int j = 0; j<biases[i].length; j++) {
        clone.biases[i][j] = biases[i][j];
      }
    }
    return clone;
  }

  float[] feedForward(float[] a) {
    for (int i = 0; i<numberOfLayers-1; i++) {
      a = relu(addVec(matMult(weights[i], a), biases[i]));
    }
    return a.clone();
  }

  float[] sigmoid(float[] z) {
    float[] res = new float[z.length];
    for (int i = 0; i<z.length; i++) {
      res[i] = 1.0/(1+exp(-z[i]));
    }
    return res.clone();
  }

  float[] relu(float[] z) {
    float[] res = new float[z.length];
    for (int i = 0; i<z.length; i++) {
      res[i] = max(0, z[i]);
    }
    return res.clone();
  }

  float[] addVec(float[] v1, float[] v2){
    float[] res = new float[v1.length];
    for(int i = 0; i<v1.length; i++){
      res[i] = v1[i]+v2[i];
    }
    return res;
  }
      

  float[] matMult(float[][] m, float[] v) {
    float[][] vCol = rowToColVec(v);
    float[][] resCol = new float[m.length][1];
    for (int i = 0; i<resCol.length; i++) {
      for (int j = 0; j<resCol[i].length; j++) {
        for (int k = 0; k<v.length; k++) {
          resCol[i][j] += m[i][k]*vCol[k][j];
        }
      }
    }
    return colToRowVec(resCol).clone();
  }

  float[] colToRowVec(float[][] col) {
    float[] res = new float[col.length];
    for (int i = 0; i<res.length; i++) {
      res[i] = col[i][0];
    }
    return res.clone();
  }

  float[][] rowToColVec(float[] row) {
    float[][] res = new float[row.length][1];
    for (int i = 0; i<row.length; i++) {
      res[i][0] = row[i];
    }
    return res.clone();
  }
}
