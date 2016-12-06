int POPULATION_MIN = 30, FOOD_MIN = 50;
int frames = 0;

Bacteria[] bacteria;
Food[] food;
CollisionGrid collisionGrid;

// class population Manager
//   Method Update                  - runs the following methods marked with*
//   Method *FoodCollision          - Checks Whether a Bacteria has collided with food and adds it to its energy level
//   Method *CheckEnergyLevels      - Checks Bacteria energy levels and kills any negative ones
//   Method Pop                     - Deletes and Cleans an Object Array
//   Method Push                    - Concatenates two Object Arrays
//   Method *FoodManager            - Creates new Food
//   Method *PopulationCheck        - Creates new Bacteria

//   NEW METHODS
//   Method FoodSensorCheck         - Checks the surroundings accordingly for food / maybe can be run with food collisions since the calcs for dist are all done there
//   Method 

class PopulationManager
{
  private int population;
  private int foodlevel;
  private int collisionGridw = 100;
  private int collisionGridh = 100;
  
  public PopulationManager()
  {
    population = POPULATION_MIN; // + (int)random(10);
    foodlevel = FOOD_MIN + (int)random(10);
    
    bacteria = new Bacteria[population];
    food = new Food[foodlevel];
    
    for(int i = 0; i < population; i++)
    {
      bacteria[i] = new Bacteria();
    }
    for(int i = 0; i < foodlevel; i++)
    {
      food[i] = new Food();
    }
    
    //CreateCollisionGrid();
  }
  
  public void Update()
  {
    // Update Bacteria
    for(int i = 0; i < population; i++)
    {
      bacteria[i].Update();
    }
        
    // Check Energy levels
    CheckEnergyLevels();
    
    // Check for food collisions
    FoodCollision();

    // Check food levels
    FoodManager();
    
    // Check Population levels
    PopulationCheck();
    
    frames++;
    //println(frames);
  }
  
  public void Draw()
  {
    // Draw
    for(int i = 0; i < bacteria.length; i++){
      bacteria[i].Draw();
    }
    
    for(int j = 0; j < food.length; j++){
      //println(j," ",food.length - 1);
      food[j].Draw();
    }
    
    // Draw Text
    text(("Population: "+ str(population)), 0, h-18);
    text(("Frames: " + str(frames)), 0, h-3);
    
  }
  
  private void CreateCollisionGrid()
  {
    collisionGrid = new CollisionGrid(w,h,100,100);
    
    for (int i = 0; i < food.length; i++)
    {
        collisionGrid.AddFood(food[i].pos,i);
    }
  };
  
  private void FoodCollision()
  {
    
    int[] index = new int[food.length];
    
    for (int i = 0; i < food.length; i++)
    {
      index[i] = i;
      
    }
    
    float dist;
    
    /*
    for(int i = 0; i < bacteria.length; i++)
    {
      collisionGrid.AddBacteria(bacteria[i].pos,i);
    }
    */
    
    for(int i = 0; i < food.length; i++)
    {
      if(index[i] != -1)
      {
        for(int j = 0; j < bacteria.length; j++)
        {
          dist = bacteria[j].pos.dist(food[i].pos);
          // Check for collision, Add energy to bacteria and destroy food
          if(dist < (bacteria[j].size + food[i].size))
          {
            println(dist);
            index[i] = -1;
            bacteria[j].addEnergy(food[i].energy);
            j = bacteria.length;
          } else if(dist < FOODSENSOR_RANGE){
            PVector p = new PVector();
            p.set(food[i].pos);
            bacteria[j].CheckFoodSensor(p);
          }
        }
      }
    }
    
    food = Pop(food, index);
    
    index = new int[bacteria.length];
    
    for (int i = 0; i < bacteria.length; i++)
    {
      index[i] = i;
      
    }
    
    for(int i = 0; i < bacteria.length; i++)
    {
      if(index[i] != -1)
      {
        for(int j = i; j < bacteria.length; j++)
        {
          if(index[j] != -1)
          {
            dist = bacteria[i].pos.dist(bacteria[j].pos);
            
            if(dist < (bacteria[i].size + bacteria[j].size))
            {
              if(bacteria[i].size > 2*bacteria[j].size)
              {
                index[j] = -1;
                bacteria[i].addEnergy(0.75*bacteria[i].energy);
              } else if( bacteria[j].size > 2*bacteria[i].size ){
                index[i] = -1;
                bacteria[j].addEnergy(0.75*bacteria[i].energy);
              }
            }
          }
        }
      }
    }
    
    bacteria = Pop(bacteria, index);
  }
  
  private void CheckEnergyLevels()
  {
    int[] index = new int[bacteria.length];
    
    for(int i = 0; i < bacteria.length; i++)
    {
      if(bacteria[i].energy < 0)
      {
        index[i] = -1;
        population--;
      }
    }
    
    bacteria = Pop(bacteria, index);
  }
  
  private Food[] Pop(Food[] a, int[] index)
  {
    // Remove eaten food
    int j = 0;
    for(int i = 0; i < (a.length-j); i++)
    {
      if(index[i] == -1)
      {
        j++;
        print("WHAT");
      }
      
      if(i+j < a.length){
        a[i] = a[i+j];
      }
      else{
        a[i] = a[a.length - 1];
      }

    }
    
    Food[] b = new Food[a.length-j];
    System.arraycopy(a,0,b,0,a.length-j);
    return b;
  }
  
  private Food[] push(Food[] a, Food[] b)
  {
    Food[] c = new Food[a.length + b.length];
    System.arraycopy(a,0,c,0,a.length);
    System.arraycopy(b,0,c,a.length,b.length);
    return c;
  }
  
  private Bacteria[] Pop(Bacteria[] a, int[] index)
  {
    int j = 0;
    for(int i = 0; i < a.length-j; i++)
    {
      if(index[i] == -1)
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
    
    Bacteria[] b = new Bacteria[a.length-j];
    System.arraycopy(a,0,b,0,a.length-j);
    return b;
  }
  
  private Bacteria[] push(Bacteria[] a, Bacteria[] b)
  {
    Bacteria[] c = new Bacteria[a.length + b.length];
    
    System.arraycopy(a,0,c,0,a.length);
    System.arraycopy(b,0,c,a.length,b.length);
    
    /* DEBUG
    println(a.length);
    println(b.length);
    
    for(int i = 0; i < a.length; i++)
    {
      println(i,", size:",a[i].size);
    }
    for(int i = 0; i < b.length; i++)
    {
      println(i,", size:",b[i].size);
    }
    for(int i = 0; i < c.length; i++)
    {
      println(i,", size:",c[i].size);
    }
    */
    
    return c;
  }
  
   private Bacteria[] push(Bacteria[] a, Bacteria b)
  {
    Bacteria[] c = new Bacteria[a.length + 1];
    
    System.arraycopy(a,0,c,0,a.length);
    c[c.length - 1] = b;
    
    return c;
  }
  
  private void FoodManager()
  {
    // Check if food level is below threshold
    foodlevel = food.length;
    
    if(frames%500 == 0)
    {
      Food[] nfood = new Food[1];
      // Create more food
      for(int i = 0; i < 1; i++)
      {
        nfood[i] = new Food();
      }
    
      food = push(food, nfood);
    }
  }
  
  private void PopulationCheck()
  {
    population = bacteria.length;
    
    for(int i = 0; i < population; i++)
    {
      Bacteria nBacteria = new Bacteria();
      
      if(bacteria[i].checkSplitEnergy()){
        bacteria[i].halfEnergy();
        nBacteria = new Bacteria(bacteria[i]);
        nBacteria.genes.Mutate();
        println(nBacteria.pos, bacteria[i].pos);
        
        
        PVector force;
        force = PVector.random2D();
        
        bacteria[i].addForce(force.mult(0.01));
        nBacteria.addForce(force.mult(-0.01));
        
        
        bacteria = push(bacteria, nBacteria);
        //bacteria[bacteria.length - 1].genes.Mutate();
      }
    }
    
    population = bacteria.length;
    println("POP: ", bacteria.length);
    
    if(population < POPULATION_MIN)
    {
      Bacteria[] nBacteria = new Bacteria[POPULATION_MIN - population];
      
      for(int i = 0; i < (POPULATION_MIN - population); i++)
      {
        // Optimisation construct a Bacteria[] the size of the missing population and then push into the existing bacteria[]
        nBacteria[i] = new Bacteria();
      }
      
       bacteria = push(bacteria, nBacteria);
    }
  }
}