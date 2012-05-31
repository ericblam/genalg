/*=====================================
 Each gene contains the code for a specific trait
 Instance Variables:
 genotype: int array to store a binary number
 value: corresponding base 10 number of the genotype
 geneLenght: desired length of the gene
 ====================================*/


class Gene {

  int geneLength;
  int[] genotype;
  int value;

  /*===================================== 
   Takes the length of the gene as a parameter,
   randomly sets every bit in the genotype array to
   a 1 or a 0, then calcuate the value.
   ====================================*/
  Gene(int l) {
    geneLength = l;
    genotype = new int[l];
    for (int i = 0; i < l; i++) {
      genotype[i] = round(random(1));
    }
    setValue();
  }

  /*=====================================
   Create a new gene that is a copy
   of the parameter
   ====================================*/
  Gene(Gene g) {
    geneLength = g.geneLength;
    genotype = new int[geneLength];
    for(int i = 0; i < geneLength; i++) {
      genotype[i] = g.genotype[i];
    }
    value = g.value;
  }

  /*=====================================
   Pick a random element from genotype
   and switch it from 1 to 0 or vice-versa
   ====================================*/
  void mutate() {
    int index = (int) random(geneLength);
    if (genotype[index] == 0)
      genotype[index] = 1;
    else
      genotype[index] = 0;
    setValue();
  }
  /*=====================================
   Go through the genotype and set value to the
   correct bast 10 equvalent of the binary number
   ====================================*/
  void setValue() {
    value = 0;
    int l = genotype.length;
    for (int i = 0; i < l; i++) {
      value += genotype[l - i - 1] * pow(2, i);
    }
  }

  /*=====================================
   Print the genotype array and value.
   used for debugging and development only
   ====================================*/
  void display() {

    println( genotype );
    println( value );
  }
}

