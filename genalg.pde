//"Constants"
int POPULATION_SIZE = 36;
float MUTATION_CHANCE = 0.3;
int DRAW_OFFSET = int((pow( 2, RADIUS_GENE_SIZE ) + RADIUS_EXTRA) * 2);

//Global Variables
float popRoot = sqrt(POPULATION_SIZE);
int selectedX;
int selectedY;
int selectedNum;
int bestX;
int bestY;
int bestNum;
boolean continuous = false;
float totalFitness;
int speed;
int generation;
float mutationRate = 0.05;

// Blobs across (across) and down (bill)
int across;
int bill;

//The actual individuals
Individual[] population;
Individual selected;
Individual bestI;


/*=====================================
 Create an initial population of randomly
 generated individuals.
 Setup the basic window properties
 ====================================*/
void setup() {
  across = ceil(popRoot);
  bill = round(popRoot);
  int x = across * DRAW_OFFSET;
  int y = bill * DRAW_OFFSET;
  size(x,y);
  populate();
  // "Clicks" mouse in order to set a selected individual, temporarily.
  mouseClicked();
}

/*=====================================
 Redraw every Individual in the population
 each frame. Make sure they are drawn in a grid without
 overlaping each other.
 If an individual has been slected (by the mouse), draw a box
 around it and draw a box around the individual with the
 highest fitness value.
 If mating mode is set to continuous, call mating season
 ====================================*/
void draw() {
  background(255);
  noFill();
  rect(selectedX * DRAW_OFFSET, selectedY * DRAW_OFFSET, DRAW_OFFSET, DRAW_OFFSET);
  rect(bestX * DRAW_OFFSET, bestY * DRAW_OFFSET, DRAW_OFFSET, DRAW_OFFSET);
  for(int i = 0; i < POPULATION_SIZE; i++) {
     population[i].display(false, false);
     population[i].setFitness(selected);
  }
  setTotalFitness();
  findBest();
  noFill();
  rect(bestX * DRAW_OFFSET, bestY * DRAW_OFFSET, DRAW_OFFSET, DRAW_OFFSET);
}

/*=====================================
 When the mouse is clicked, set selected to
 the individual clicked on, and set 
 selectedX and selectedY so that a box can be
 drawn around it.
 ====================================*/
void mouseClicked() {
  selectedX = mouseX / DRAW_OFFSET;
  selectedY = mouseY / DRAW_OFFSET;
  selectedNum = selectedX + selectedY * bill;
  selected = population[selectedNum];
}

  /*====================================
 The following keys are mapped to actions:
 
 Right Arrow: move forard one generation
 Up Arrow: speed up when in continuous mode
 Down Arrow: slow down when in continuous mode
 Shift: toggle continuous mode
 Space: reset the population
 f: toggle fitness value display
 m: increase mutation rate
 n: decrease mutation rate
 ==================================*/
void keyPressed() {
  println(keyCode); //will display the integer value for whatever key has been pressed
  /*
  Right: 39
  Up: 38
  Down: 40
  Shift: 16
  Space: 32
  f: 70
  m: 77
  n: 78
  */
}


/*====================================
 select will return a pseudo-random chromosome from the population
 Uses roulette wheel selection:
 A random number is generated between 0 and the total fitness 
 Go through the population and add each member's fitness until you exceed the random 
 number that was generated.
 Return the individual that the algorithm stopped on
 Do not include the "selected" shape as a possible return value
 ==================================*/
Individual select() {
  float roulette = random(totalFitness);
  float ball = 0;
  for(int i = 0; i < POPULATION_SIZE; i++) {
    if(ball >= roulette && i != selectedNum) {
      return population[i];
    }
    ball += population[i].fitness;
  }
  return null;
}

/*====================================
 
 Replaces the current population with a totally new one by
 selecting pairs of Individuals and "mating" them.
 Make sure that totalFitness is set before you use select().
 The goal shape (selected) should always be the first Individual
 in the population, unmodified.
 ==================================*/

void matingSeason() {
  Individual[] newPopulation = new Individual[POPULATION_SIZE];
  newPopulation[0] = selected;
  
  population = newPopulation;
}

/*====================================
 
 Randomly call the mutate method an Individual (or Individuals)
 in the population.
 ==================================*/
void mutate() {
}

/*====================================
 
 Set the totalFitness to the sum of the fitness values
 of each individual.
 Make sure that each individual has an accurate fitness value
 ==================================*/
void setTotalFitness() {
  totalFitness = 0;
  for(int i = 0; i < POPULATION_SIZE; i++) {
    totalFitness += population[i].fitness;
  }
}

/*====================================
 Fill the population with randomly generated Individuals
 Make sure to set the location of each individual such that
 they display nicely in a grid.
 ==================================*/
void populate() {
  population = new Individual[POPULATION_SIZE];
  int y = 1;
  for(int i = 0; i < POPULATION_SIZE; i++) {
    float acx = ((DRAW_OFFSET / 2) + (DRAW_OFFSET * i)) % (DRAW_OFFSET * across);
    float acy = (y * DRAW_OFFSET) - (DRAW_OFFSET / 2);
    population[i] = new Individual(acx,acy);
    if((i + 1) % across == 0)
      y++;
  }
}

/*====================================
 Go through the population and find the Individual with the 
 highest fitness value.
 Set bestX and bestY so that the best Individual can have a 
 square border drawn around it.
 ==================================*/
void findBest() {
  if(selectedNum == 0) {
    bestNum = 1;
    bestI = population[bestNum];
    for(int i = 2; i < POPULATION_SIZE; i++) {
      if(population[i].fitness > bestI.fitness) {
        bestNum = i;
        bestI = population[i];
      }
    }
  }
  else {
    bestNum = 0;
    bestI = population[bestNum];
    for(int i = 1; i < POPULATION_SIZE; i++) {
      if(population[i].fitness > bestI.fitness && i != selectedNum) {
        bestNum = i;
        bestI = population[i];
      }
    }
  }
  bestX = (bestNum % across);
  bestY = (bestNum / across);
}


