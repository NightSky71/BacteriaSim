float MIN_FOODENERGY = 30, MAX_FOODENERGY = 100, SIZE = 5;

class Food{

    PVector pos = new PVector(0,0);
    float energy;
    float size;
    
    public Food(){
      pos = new PVector(random(w-120)+60,random(h-120)+60);
      energy = random(MAX_FOODENERGY - MIN_FOODENERGY) + MIN_FOODENERGY;
      size = SIZE;
    }
    
    public void Draw(){
      fill(255,255,255);
      rect(pos.x, pos.y, size, size);
    }
}