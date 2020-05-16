# Snake-AI-With-Genetic-Algorithm
Snake game with a genetic algorithm AI

## Snake
### Brain
The brain of the snake is a feed forward neural network which based on the vision input of the snake produces an output of which direction
the snake should go.

### Vision
The snake looks in 8 directions, and in each direction it looks for 3 things (whether there is food in that direction or not, whether there
is a tail part in that direction or not and the distance to the wall) so a total of 24 vision inputs

## Population
Each population is a collection of snakes competing to pass their genes to the next population

### Evaluation
Each snake in the population is given a fitness which is calculated based on the score it got and the time it was alive

### Selection
After all the snakes in the population are dead, their fitnesses are calculated and normalized, then a mating pool is created where the higher
the snake's fitness the more it will appear in the mating pool

### Cross over
Two parents are chosen from the mating pool and their brains (neural networks' weights and biases) are crossed over two produce a new child Snake
which is added to the new generation of snakes

### Mutation
Each child snake is mutated by altering some of the weights and biases of its neural network
