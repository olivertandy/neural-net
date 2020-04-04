Perceptron p;
GeneticTrainer gt;

public final float a = 75;
float[] x = {100, 250, 400};

void setup(){
	size(500, 500);
	//background(0);

	Vector[] inputVectors = new Vector[4];
	for(int i = 0; i < 4; i++){
		float[] vectorArray = new float[2];
		vectorArray[0] = float(i & 1);
		vectorArray[1] = float(i >> 1);
		//vectorArray[2] = 1;

		inputVectors[i] = new Vector(vectorArray);
		System.out.println("Vector array " + i + " = ("
											 + inputVectors[i].get(0) + ", "
											 + inputVectors[i].get(1) + ")");
	}

	Vector[] outputVectors = new Vector[4];
	for(int i = 0; i < 4; i++){
		float[] vectorArray = new float[1];
		if((inputVectors[i].get(0) == 1 || inputVectors[i].get(1) == 1) &&
			 !(inputVectors[i].get(0) == 1 && inputVectors[i].get(1) == 1)){
			vectorArray[0] = 1;
		}
		else vectorArray[0] = 0;

		outputVectors[i] = new Vector(vectorArray);
		System.out.println("Vector array " + i + " = ("
											 + outputVectors[i].get(0));
	}

	
	gt = new GeneticTrainer(inputVectors, outputVectors, 50, 3);

	gt.createNewRandomGeneration();
	int count = 0;
	
	while(gt.errorFunction(gt.bestIndividual()) > 0.01){
		Perceptron bestIndividual = gt.bestIndividual();
		gt.createNewGenerationFromIndividual(bestIndividual);
		System.out.println("GENERATION" + count);
		count++;
	}

	p = gt.bestIndividual();
}

void draw(){
  background(0);
  
  drawConnections(p.inputToHidden, p.inputLayer.length, p.hiddenLayer.length,
                  x[0], x[1]);
  drawConnections(p.hiddenToOutput, p.hiddenLayer.length, p.outputLayer.length,
                  x[1], x[2]);
                  
	drawLayer(p.inputLayer, x[0]);
	drawLayer(p.hiddenLayer, x[1]);
	drawLayer(p.outputLayer, x[2]);
}

boolean withinRadius(float x0, float y0, float xCentre, float yCentre, float radius){
  if(dist(x0, y0, xCentre, yCentre) <= radius) return true;
  else return false;
}

void mouseClicked(){
  for(int i = 0; i < p.inputLayer.length; i++){
    float xCentre = x[0];
    float yCentre = yValuesOfArrayLength(p.inputLayer.length)[i];
    
    if(withinRadius(mouseX, mouseY, xCentre, yCentre, 8)){
      if(p.inputLayer[i] < 0.5) p.inputLayer[i] = 1.0f;
      else p.inputLayer[i] = 0.0f;
    }
  }
  
  p.evaluateOutputs();
}

void drawLayer(float[] layer, float x){
	float[] y = yValuesOfArrayLength(layer.length);

	for(int i = 0; i < layer.length; i++){
		stroke(255);
		fill(greenComponent(layer[i]));
		ellipse(x, y[i], 15, 15);
		fill(255);
		String value = String.format("%.2f", layer[i]);
		text(value, x - 10, y[i] - 20);
	}
}

float redComponent(float weight){
  if(weight >= 0){
    return 0;
  }
  else if(weight < -1) return 255;
  else return 255*(1.0f - weight);
}

float greenComponent(float weight){
  if(weight < 0){
    return 0;
  }
  else if(weight > 1) return 255;
  else return 255*weight;
}
	
float[] yValuesOfArrayLength(int length){
	float[] output = new float[length];

	for(int i = 0; i < length; i++){
		output[i] = height/2 + (float(i) - float(length)/2)*a;
	}
	
	return output;
}

void drawConnections(float[][] connections, int arrayWidth, int arrayHeight,
										 float x0, float x1){
	float[] y0 = yValuesOfArrayLength(arrayWidth);
	float[] y1 = yValuesOfArrayLength(arrayHeight);

	for(int i = 0; i < arrayWidth; i++){
		for(int j = 0; j < arrayHeight; j++){
			stroke(redComponent(connections[i][j]), greenComponent(connections[i][j]), 0);
      line(x0, y0[i], x1, y1[j]);
      String valueString = String.format("%.2f", connections[i][j]);
      textOnLine(valueString, x0, y0[i], x1, y1[j]);
		}
	}
}

void textOnLine(String string, float x0, float y0, float x1, float y1){
	float t = 0.2;
	float x = lerp(x0, x1, t);
	float y = lerp(y0, y1, t);

  fill(255);
	text(string, x, y);
}

float stepFunction(float input){
  if(input > 0) return 1.0f;
  else return 0.0f;
}

float logisticFunction(float input){
  float k = 0.5;
  return 1.0f/(1.0f + exp(-k*input));
}