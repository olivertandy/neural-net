class Vector{
  float[] components;
  
  Vector(float[] values){
    components = new float[values.length];
    for(int i = 0; i < values.length; i++){
      components[i] = values[i];
    }
  }
  
  float get(int i){
    return components[i];
  }
  
  void set(int i, float value){
    components[i] = value;
  }
  
  int size(){
    return components.length;
  }
}