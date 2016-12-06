float SIZE_MAX = 7, SIZE_MIN = 1, STARTENERGY = 40, STATIC_ENERGY_LOSS_MULTIPLIER = 0.01;


class Bacteria{

  PVector pos = new PVector(0,0);
  PVector vel = new PVector(0,0);
  PVector acc = new PVector(0,0);
  
  float energy;
  float size;
  
  Genes genes;
  
  public Bacteria()
  {
    pos = new PVector(random(w),random(h));
    //size = random(SIZE_MAX - SIZE_MIN) + SIZE_MIN;
    
    genes = new Genes();
    genes.CreateSensors();
    size = genes.maxSize;
    energy = STARTENERGY*size;
  }
  
  public Bacteria(Bacteria a)
  {
    this.pos.set(a.pos);
    this.vel.set(a.vel);
    this.acc.set(a.acc);
    this.energy = a.energy;
    this.size = a.size;
    
    this.genes = new Genes(a.genes);
  }
  
  void addForce(PVector force)
  {
    force.div(size);
    acc.add(force);
  }
  
  void addEnergy(float energy)
  {
    this.energy += energy;
  }
  
  void Update()
  { 
    
    genes.Update();
    addForce(genes.GetForce());
    //println("POS: ", pos);
    
    
    
    // Drag
    PVector drag = new PVector();
    drag.set(vel);
    drag.mult(-0.02*size*drag.mag());
    addForce(drag);
    
    
    checkWallCollisions();
    
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
    
    //println("position: ",pos);
    
    energy -= genes.EnergyLoss()*pow(size,0.5);
  }
  
  boolean checkSplitEnergy()
  {
    if(energy > genes.splitEnergy*size)
    {
      return true;
    }
    return false;
  }
  
  void Stop()
  {
    this.vel.mult(0);
    this.acc.mult(0);
  }
  
  void halfEnergy()
  {
    energy *= 0.5;
  }
  
  void checkWallCollisions()
  {
    if(pos.x > w || pos.x < 0){
      //addForce(acc.mult(-1));
      vel.x = -1.5*vel.x;
      if(pos.x < 0)
      {
        pos.x = 0;
      } else {
        pos.x = w;
      }
    } 
    if(pos.y > h || pos.y < 0){
      //addForce(acc.mult(-1));
      vel.y = -1.5*vel.y;
      if(pos.y < 0)
      {
        pos.y = 0;
      } else {
        pos.y = h;
      }
    } 
    
  }
  
  public void CheckFoodSensor(PVector foodVector)
  {
    PVector relativeFoodVector = foodVector.sub(pos);
    genes.CheckFoodSensor(relativeFoodVector);
  }
  
  public void Draw()
  {
    fill(genes.red, genes.green, genes.blue);
   
    ellipse(pos.x, pos.y, size*2, size*2);
  }
  
}