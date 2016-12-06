int w = 1600, h = 1000;
int n = 100;
int[] speed = {1,2,4,8,16,32,64,128,256};
int speedIndex = 0;
PFont f;

PopulationManager popMan;

void setup()
{
  size(1600, 1000);

  popMan = new PopulationManager();
  
  // Setup Font
  f = createFont("Arial",16,true);
  /*
  genes = new Genes();
  
  genes.Print();
  for(int i = 0; i < 2000; i++)
  {
    genes.Mutate();
    genes.Print();
  }
  */
  
}

void draw()
{
  background(150);
  
  int t = speedIndex;
  for(int i = 0; i < speed[t]; i++)
  {
    popMan.Update();
  }
  popMan.Draw();
}

void keyPressed()
{
  if(keyCode == 37 || keyCode == 65){
    speedIndex++;
    if( speedIndex >= speed.length)
    {
      speedIndex = speed.length - 1;
    }
  }
  
  if(keyCode == 39 || keyCode == 68){
    speedIndex--;
    
    if(speedIndex < 0)
    {
      speedIndex = 0;
    }
  }
}