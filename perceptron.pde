class Perceptron{
	float[] inputLayer;
	float[] outputLayer;
	float[] hiddenLayer;
	//generalise to multiple layers later

	float[][] inputToHidden;
	float[][] hiddenToOutput;

	Perceptron(int inputNodes, int hiddenNodes, int outputNodes){
		//create all nodes and connections, initialise weights to 1
		//and inputs to 0
		inputLayer = new float[inputNodes];
		outputLayer = new float[outputNodes];
		hiddenLayer = new float[hiddenNodes];

		inputToHidden = generateRandomConnections(inputLayer, hiddenLayer);
		hiddenToOutput = generateRandomConnections(hiddenLayer, outputLayer);		
	}

  Perceptron(int inputNodes, int hiddenNodes, int outputNodes,
    float[][] inputToHidden, float[][] hiddenToOutput){
    //create all nodes and connections, initialise weights to 1
    //and inputs to 0
    inputLayer = new float[inputNodes];
    outputLayer = new float[outputNodes];
    hiddenLayer = new float[hiddenNodes];

		setInput(inputNodes - 1, 1);

    this.inputToHidden = copyFloatArray(inputToHidden, inputNodes, hiddenNodes);
    this.hiddenToOutput = copyFloatArray(hiddenToOutput, hiddenNodes, outputNodes);
  }
  
  float[][] copyFloatArray(float[][] input, int arrayWidth, int arrayHeight){
    float[][] output = new float[arrayWidth][arrayHeight];
    for(int i = 0; i < arrayWidth; i++){
      for(int j = 0; j < arrayHeight; j++){
        output[i][j] = input[i][j];
      }
    }
    
    return output;
  }
  
  @Override
  Perceptron clone(){
    return new Perceptron(this.inputLayer.length, 
      this.hiddenLayer.length, 
      this.outputLayer.length,
      this.inputToHidden,
      this.hiddenToOutput);
  }

	float[][] generateRandomConnections(float[] a, float[] b){
		float[][] connectionTable = new float[a.length][b.length];
		for(int i = 0; i < a.length; i++){
			for(int j = 0; j < b.length; j++){
				connectionTable[i][j] = random(-1, 1);
			}
		}
		return connectionTable;
	}

	void inputsToZero(){
		for(int i = 0; i < inputLayer.length; i++){
			inputLayer[i] = 0;
		}
	}

  void mutate(float mutationRate){
    for(int i = 0; i < inputLayer.length; i++){
      for(int j = 0; j < hiddenLayer.length; j++){
        inputToHidden[i][j] += random(-mutationRate, mutationRate);
      }   
    }
    
    for(int i = 0; i < hiddenLayer.length; i++){
      for(int j = 0; j < outputLayer.length; j++){
        hiddenToOutput[i][j] += random(-mutationRate, mutationRate);
      }   
    }
  }
  
  void setInput(float[] values){
    for(int i = 0; i < inputLayer.length; i++){
      inputLayer[i] = values[i];
    }
  }

	void setInput(int index, float value){
		inputLayer[index] = value;
	}

	void evaluateOutputs(){
		//evaluate connections: input*weight

		//evaluate hidden layer
		for(int j = 0; j < hiddenLayer.length; j++){
			float sum = sumOfWeightedInputs(j, inputLayer, inputToHidden);
			hiddenLayer[j] = logisticFunction(sum);
		}

		//evaluate outputs
		for(int j = 0; j < outputLayer.length; j++){
			float sum = sumOfWeightedInputs(j, hiddenLayer, hiddenToOutput);
			outputLayer[j] = logisticFunction(sum);
		}

		//return outputLayer;
	}

	float sumOfWeightedInputs(int j, float[] inputs, float[][] weights){
		float sumOfInputs = 0;
		for(int i = 0; i < inputLayer.length; i++){
			sumOfInputs += weights[i][j] * inputs[i];
		}
		return sumOfInputs;
	}

  /*
  void drawPerceptron(Perceptron p){
  
  }
  */
}