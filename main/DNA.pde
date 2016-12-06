float[] TAIL_MIN = {0.0001, 0, 0.01};
int MAX_FOOD_SENSORS = 4, MAX_TAILS = 8, MODE = 3;
float CHANCE_OF_MUTATION = 0.33, CHANCE_OF_OBJECT_MUTATION = 0.3, CHANCE_OF_DNA_MUTATION = 0.45, CHANGE_MAX = 0.3;
float FOODSENSOR_ANGLE = 10, FOODSENSOR_RANGE = 80;
float TAIL_STATIC_UNIT_ENERGY = 0.001; float TAIL_DYNAMIC_UNIT_ENERGY = 0.01;
float FOODSENSOR_STATIC_UNIT_ENERGY = 0.001;
float SPLITENERGY_MAX = 100, SPLITENERGY_MIN = 50;

// class Genes
//   Method Print         - Prints to console the DNA data
//   Method EnergyLoss    - Calculates current energy loss
//   Method Mutate        - Mutates the DNA A-SEXUALLY
//   Method GetForce      - Updates current tail usage and outputs a normalised force
//   Method Update

class Genes{
  
  // Currently there are two objects a bacteria can attach to itself
  // These can be placed around the bacterium's body
  // FoodSensor - Detects the amount of Food in a cone
  // Tail - Data from the Food Sensor is feed to the Tails which activate depending on the genes
  
  // To simplify the problem for now each bateria is going to have up to 4 food sensors and up to 8 tails
  
  /// DNA
  
  FoodSensor[] foodSensor;
  Tail[] tail;
  float MAX_TIME, MAX_ELAPSED;
  float[] TAIL_MAX = {0,0,0}; // 0 - 1; 
  float maxSize;
  float[][][] dna; // [WHICH FOOD SENSOR (1-4) | (0) which is the default][WHICH TAIL][TAIL FORCE,TAIL TIMER START, TAIL TIMER LENGTH] 
  float splitEnergy;
  int red;
  int green;
  int blue;
  int generation;
  
  /// END DNA
  
  Timer timer;
  
  public Genes()
  {
    // RANDOM DNA
    maxSize = random(SIZE_MAX - SIZE_MIN) + SIZE_MIN;
    
    MAX_TIME = random(6) + 3;
    
    MAX_ELAPSED = random(2) + 0.5;
    
    TAIL_MAX[0] = 0.02;
    TAIL_MAX[1] = MAX_TIME;
    TAIL_MAX[2] = MAX_ELAPSED;
    
    timer = new Timer(MAX_TIME + MAX_ELAPSED);
    
    dna = new float[MAX_FOOD_SENSORS + 1][MAX_TAILS][MODE];
    
    for(int i = 0; i < MAX_FOOD_SENSORS + 1; i++){
      for(int j = 0; j < MAX_TAILS; j++){
        // Tail Force
        dna[i][j][0] = random(TAIL_MAX[0]);
        
        // Tail Start
        dna[i][j][1] = random(TAIL_MAX[1]);
        
        // Tail End
        dna[i][j][2] = random(TAIL_MAX[2]);
      }
    }
    
    red = (int)random(255);
    green = (int)random(255);
    blue = (int)random(255);
    
    generation = 1;
    
    // SplitEnergy
    splitEnergy = random(SPLITENERGY_MAX - SPLITENERGY_MIN) + SPLITENERGY_MIN;
  }
  
  void CreateSensors()
  {
    foodSensor = new FoodSensor[(int)random(MAX_FOOD_SENSORS)];
    
    for(int i = 0; i < foodSensor.length; i++){
       foodSensor[i] = new FoodSensor(); 
    }
    
    tail = new Tail[(int)(random(MAX_TAILS - 1)+1)];
    
    for (int i = 0; i < tail.length; i++){
       tail[i] = new Tail();
    }
  }
  
  public Genes(Genes a)
  {
    this.MAX_TIME = a.MAX_TIME; 
    this.MAX_ELAPSED = a.MAX_ELAPSED;
    this.TAIL_MAX = a.TAIL_MAX; // 0 - 1; 
    this.maxSize = a.maxSize;
    this.dna = a.dna;
    this.splitEnergy = a.splitEnergy;
    this.red = a.red;
    this.blue = a.blue;
    this.green = a.green;
    this.generation = a.generation + 1;
    
    foodSensor = new FoodSensor[a.foodSensor.length];
    
    for(int i = 0; i < a.foodSensor.length; i++){
       foodSensor[i] = new FoodSensor(a.foodSensor[i]); 
    }
    
    tail = new Tail[a.tail.length];
    
    for (int i = 0; i < a.tail.length; i++){
       tail[i] = new Tail(a.tail[i]);
    }
    
    this.timer = new Timer(a.timer);
  }
  
  public void Print()
  {
    println("\nFoodSensors = ", foodSensor.length - 1, "\n");
    
    for(int i = 0; i < foodSensor.length; i++)
    {
      print("Position: ", foodSensor[i].pos.heading(),", ");
    }
    
    println("\nTails = ", tail.length);
    println("MaxSize = ", maxSize, "\n");
    
    for(int i = 0; i < MAX_FOOD_SENSORS + 1; i++)
    {
      for(int j = 0; j < tail.length; j++)
      {
        for (int k = 0; k < MODE; k++)
        {
          // "i= ",i,", j= ",j,", k= ",k,", val=" ,
          print(dna[i][j][k], " ");
        }
        print("| ");
      }
    }
  }
  
  public float EnergyLoss()
  {
    // Tails
    float energy = 0;
    
    for(int i = 0; i < tail.length; i++)
    {
      energy += tail[i].GetEnergyUse();
    }
    
    for(int i = 0; i < foodSensor.length; i++)
    {
      energy += foodSensor[i].GetEnergyUse();
    }
    
    return energy;
  }
  
  public void CheckFoodSensor(PVector relativeFoodVector)
  {
    float angle;
    for(int i = 0; i < foodSensor.length; i++)
    {
      angle = PVector.angleBetween(foodSensor[i].pos,relativeFoodVector);
      angle = degrees(angle);
      if(angle > -FOODSENSOR_ANGLE && angle < FOODSENSOR_ANGLE){
        foodSensor[i].SetFoodPresent(true);
        timer.Reset(i);
        return;
      }
    }
  }
  
  public void Update()
  {
    float time = timer.GetTime();
    float start;
    float end;
    
    
    
    for(int i = 0; i < tail.length; i++)
    {
      start = (dna[timer.foodSensorActive + 1][i][1]);
      end = start + (dna[timer.foodSensorActive + 1][i][2]);
     //println("start =",start,", end =",end);
      if(time > start && time < end)
      {
        tail[i].SetUse(dna[timer.foodSensorActive + 1][i][0]);
      }
      else
      {
        tail[i].SetUse(0);
      }
    }
  }
  
  public PVector GetForce()
  {
    PVector force = new PVector();
    //println("Time", timer.GetTime());
    //println("FOOD? ", timer.foodSensorActive);
    //print("TAIL ");
    for(int i = 0; i < tail.length; i++)
    {
      force.add(tail[i].GetForceVector());
      //print(i," = ",tail[i].use,", ");
    }
    //print("\n");
    //if(tail.length > 0){tail[0].Print();}
    return force;
  }
  
  public void Mutate()
  {
    if(random(1) < CHANCE_OF_MUTATION)
    {
      // No of food sensors?
      if(random(1) < CHANCE_OF_OBJECT_MUTATION)
      {
        if(random(1) < 0.5){
          // Remove food sensor
          if(foodSensor.length > 1)
          {
            int i = floor(random(foodSensor.length));
            foodSensor = Pop(foodSensor, i);
          }
        } else {
          // Add food sensor
          if(foodSensor.length < MAX_FOOD_SENSORS)
          {
            FoodSensor newFoodSensor = new FoodSensor();
            foodSensor = Push(foodSensor, newFoodSensor);
          }
        }
      }
      
      // No of tail sensors?
      if(random(1) < CHANCE_OF_OBJECT_MUTATION)
      {
        if(random(1) < 0.5){
          // Remove food sensor
          if(tail.length > 0)
          {
            int i = floor(random(tail.length));
            tail = Pop(tail, i);
          }
        
        } else {
          if(tail.length < MAX_TAILS)
          {
            // Add food sensor
            Tail newTail = new Tail();
            tail = Push(tail, newTail);
          }
        }
      }
      
      // Size
      if(random(1) < CHANCE_OF_OBJECT_MUTATION)
      {
        maxSize += 5*(random(2*CHANGE_MAX) - CHANGE_MAX);
        
        if(maxSize > SIZE_MAX){
          maxSize = SIZE_MAX;
        } else if (maxSize < SIZE_MIN){
          maxSize = SIZE_MIN;
        }
      }
      
      for(int i = 0; i < MAX_FOOD_SENSORS + 1; i++)
      {
        for(int j = 0; j < MAX_TAILS; j++)
        {
          for(int k = 0; k < MODE; k++)
          {
            if(random(1) < CHANCE_OF_DNA_MUTATION)
            {
              dna[i][j][k] += TAIL_MAX[k]*(random(2*CHANGE_MAX) - CHANGE_MAX);
              
              if (dna[i][j][k] > TAIL_MAX[k]){
                dna[i][j][k] = TAIL_MAX[k];
              } else if (dna[i][j][k] < TAIL_MIN[k]){
                dna[i][j][k] = TAIL_MIN[k];
              }
            }
          }
        }
      }
      
      // SplitEnergy
      if(random(1) < CHANCE_OF_OBJECT_MUTATION)
      {
        splitEnergy += 5*(random(2*CHANGE_MAX) - CHANGE_MAX);
        
        if(splitEnergy > SPLITENERGY_MAX){
          splitEnergy = SPLITENERGY_MAX;
        } else if (splitEnergy < SPLITENERGY_MIN){
          splitEnergy = SPLITENERGY_MIN;
        }
      }
      
      if(random(1) < CHANCE_OF_OBJECT_MUTATION)
      {
         red += (int)15*(random(2*CHANGE_MAX) - CHANGE_MAX);
         green += (int)15*(random(2*CHANGE_MAX) - CHANGE_MAX);
         blue += (int)15*(random(2*CHANGE_MAX) - CHANGE_MAX);
         
         if(red > 255){red = 255;}
         if(red < 0){red = 0;}
         if(green > 255){green = 255;}
         if(green < 0){green = 0;}
         if(blue > 255){blue = 255;}
         if(blue < 0){blue = 0;}
      }
      
      timer = new Timer(MAX_TIME + MAX_ELAPSED);
      timer.Random();
    }
  }
  
  void Combine(Genes geneB)
  {
    // Combine two genes
    // Food Sensors
    
    int numberOfFoodSensors;
    boolean[] IndexA = new boolean[this.foodSensor.length];
    boolean[] IndexB = new boolean[geneB.foodSensor.length];
    
    // Create index arrays for when the new food sensor array objects are being assigned
    for(int i = 0; i < this.foodSensor.length; i++){
      IndexA[i] = false;
    }
    for(int i = 0; i < geneB.foodSensor.length; i++){
      IndexB[i] = false;
    }
    
    // Generate a new number of Food Sensors
    if(random(1) > 0.5){
      numberOfFoodSensors = floor((this.foodSensor.length + geneB.foodSensor.length)/2);
    } else {
      numberOfFoodSensors = ceil((this.foodSensor.length + geneB.foodSensor.length)/2);
    }

    FoodSensor[] newFoodSensor = new FoodSensor[numberOfFoodSensors];
    
    // Assign the new food sensor by picking between the two genes
    for(int i = 0; i < numberOfFoodSensors; i++){
      if(random(1) > 0.5){
        int index = floor(random(this.foodSensor.length - 1));
        if(IndexA[index] == false){
          newFoodSensor[i] = this.foodSensor[index];
          IndexA[index] = true; // This Index cannot be used anymore
        } else {
          i--; // REDO LOOP
        }
      } else {
        int index = floor(random(geneB.foodSensor.length - 1));
        if(IndexB[index] == false){
          newFoodSensor[i] = geneB.foodSensor[index];
          IndexB[index] = true;
        }  else {
          i--; // REDO LOOP
        }
      }
    }
    // Tails
    
    int numberOfTails;
    IndexA = new boolean[this.tail.length];
    IndexB = new boolean[geneB.tail.length];
    
    // Create index arrays for when the new food sensor array objects are being assigned
    for(int i = 0; i < this.tail.length; i++){
      IndexA[i] = false;
    }
    for(int i = 0; i < geneB.tail.length; i++){
      IndexB[i] = false;
    }
    
    // Generate a new number of Food Sensors
    if(random(1) > 0.5){
      numberOfTails = floor((this.tail.length + geneB.tail.length)/2);
    } else {
      numberOfTails = ceil((this.tail.length + geneB.tail.length)/2);
    }
    
    Tail[] newTails = new Tail[numberOfTails];
    
    // Size
    // SplitEnergy
    // Mix Colour
  }
}

class Object
{
  PVector pos; // between 0 to 360 degrees
  float staticUnitEnergy; // Energy to just exist
  float dynamicUnitEnergy; // Energy whilst active
  
  public float GetEnergyUse()
  {
    float r = staticUnitEnergy;
    return r;
  }
  
  public PVector GetPos()
  {
    return pos;
  }
}

class FoodSensor extends Object
{
  boolean foodPresent;
  
  public FoodSensor()
  {
    pos = new PVector(random(1),random(1));
    pos.normalize();
    staticUnitEnergy = FOODSENSOR_STATIC_UNIT_ENERGY;
    dynamicUnitEnergy = 0;
    foodPresent = false;
  }
  
  public FoodSensor(FoodSensor a)
  {
    this.pos = a.pos;
    this.staticUnitEnergy = a.staticUnitEnergy;
    this.dynamicUnitEnergy = a.dynamicUnitEnergy;
    this.foodPresent = a.foodPresent;
  }
  
  public float GetEnergyUse()
  {
    float r = staticUnitEnergy;
    return r;
  }
  
  public void SetFoodPresent(boolean foodPresent)
  {
    this.foodPresent = foodPresent;
  }
}

class BacteriaSensor extends Object
{
  float detectionRadius;
  float sizeThreshold;
  

}

class Tail extends Object
{
  float maxUnitForce;
  float use;
  
  public Tail()
  {
    pos = PVector.random2D();
    maxUnitForce = 1;
    use = 0;
    staticUnitEnergy = TAIL_STATIC_UNIT_ENERGY;
    dynamicUnitEnergy = TAIL_DYNAMIC_UNIT_ENERGY;
  }
  
  public Tail(Tail a)
  {
    this.pos = a.pos;
    this.maxUnitForce = a.maxUnitForce;
    this.use = a.use;
    this.staticUnitEnergy = a.staticUnitEnergy;
    this.dynamicUnitEnergy = a.dynamicUnitEnergy;
  }
  
  public float GetEnergyUse()
  {
    float r = staticUnitEnergy + dynamicUnitEnergy*use;
    return r;
  }
  
  public PVector GetForceVector()
  {
    PVector r = new PVector();
    r.set(pos);
    
    return r.mult(use);
  }
  
  public void Print()
  {
    println("****", pos);
  }
  
  public void SetUse(float use)
  {
    this.use = use;
  }
  
  public float GetUse()
  {
    return use;
  }
}

// ARRAYS OEPRATIONS

private Tail[] Pop(Tail[] a, int k)
  {
    // Remove specific tail
    int j = 0;
    for(int i = 0; i < (a.length-j); i++)
    {
      if(i == k)
      {
        j++;
      }
      
      if(i+j < a.length){
        a[i] = a[i+j];
      }
      else{
        a[i] = a[a.length - 1];
      }

    }
    
    Tail[] b = new Tail[a.length-j];
    System.arraycopy(a,0,b,0,a.length-j);
    return b;
  }
  
  private Tail[] Push(Tail[] a, Tail b)
  {
    Tail[] c = new Tail[a.length + 1];
    System.arraycopy(a,0,c,0,a.length);
    c[c.length - 1] = b;
    return c;
  }

private FoodSensor[] Pop(FoodSensor[] a, int k)
  {
    // Remove specific tail
    int j = 0;
    for(int i = 0; i < (a.length-j); i++)
    {
      if(i == k)
      {
        j++;
      }
      
      if(i+j < a.length){
        a[i] = a[i+j];
      }
      else{
        a[i] = a[a.length - 1];
      }

    }
    
    FoodSensor[] b = new FoodSensor[a.length-j];
    System.arraycopy(a,0,b,0,a.length-j);
    return b;
  }
  
  private FoodSensor[] Push(FoodSensor[] a, FoodSensor b)
  {
    FoodSensor[] c = new FoodSensor[a.length + 1];
    System.arraycopy(a,0,c,0,a.length);
    c[c.length - 1] = b;
    return c;
  }