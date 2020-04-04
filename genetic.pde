class GeneticTrainer{
  Vector[] targetInputVectors;
  Vector[] targetOutputVectors;
  Perceptron[] currentGeneration;
  int population;
  int hiddenNodes;
  
  GeneticTrainer(Vector[] targetInputVectors, Vector[] targetOutputVectors,
                 int population, int hiddenNodes){
    if(targetInputVectors.length != targetOutputVectors.length){
      System.out.println("Input vectors != output vectors");
    }
    this.targetInputVectors = targetInputVectors;
    this.targetOutputVectors = targetOutputVectors;
    this.population = population;
    this.hiddenNodes = hiddenNodes;
    this.currentGeneration = new Perceptron[population];
  }
  
  void createNewRandomGeneration(){
    for(int i = 0; i < population; i++){
      //need to make sure vector size matches layer size
      currentGeneration[i] =
        new Perceptron(targetInputVectors[0].size(), hiddenNodes,
        targetOutputVectors[0].size());
    }
  }
  
  void createNewGenerationFromIndividual(Perceptron individual){
    for(int i = 0; i < population; i++){
      currentGeneration[i] = individual.clone();
      currentGeneration[i].mutate(0.5);
    }
  }
  
  //get individual with least error in current generation
  Perceptron bestIndividual(){
    Perceptron best = currentGeneration[0];
    
    for(int n = 0; n < population; n++){
      if(errorFunction(best) > errorFunction(currentGeneration[n])){
        best = currentGeneration[n];
      }
    }
    System.out.println("Error = " + errorFunction(best));
    return best;
  }
  
  //compare a given perceptron output with target output and return measure of error
  float errorFunction(Perceptron p){
    float error = 0;
    
    for(int n = 0; n < targetInputVectors.length; n++){
      //assign inputs to perceptron
      for(int i = 0; i < targetInputVectors[n].size(); i++){
        p.setInput(i, targetInputVectors[n].get(i));
      }

      p.evaluateOutputs();
      
      for(int i = 0; i < targetOutputVectors[n].size(); i++){
        float target = targetOutputVectors[n].get(i);
        //System.out.println("Target = " + target);
        float output = p.outputLayer[i];
        //System.out.println("Output = " + output);
        error += pow(target - output, 2);
      }
    }

    return error;
  }
}