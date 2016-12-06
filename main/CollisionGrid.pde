class CollisionGrid
{
  int sw;
  int sh;
  int w;
  int h;
  List[][] foodList;
  List[][] bacteriaList;
  
  public CollisionGrid(int sw, int sh, int w, int h)
  {
    this.sw = sw;
    this.sh = sh;
    this.w = w;
    this.h = h;
    
    foodList = new List[ceil(sw/w)][ceil(sh/h)];
    bacteriaList = new List[ceil(sw/w)][ceil(sh/h)];
  }
  
  public void AddFood(PVector pos, int i)
  {
    foodList[floor(pos.x/w)][floor(pos.y/h)].Add(i);
  }
  
  public void RemoveFood(PVector pos, int i)
  {
    foodList[floor(pos.x/w)][floor(pos.y/h)].Remove(i);
  }
  
  public void AddBacteria(PVector pos, int i)
  {
    bacteriaList[floor(pos.x/w)][floor(pos.y/h)].Add(i);
  }
  
  public void RemoveBacteria(PVector pos, int i)
  {
    bacteriaList[floor(pos.x/w)][floor(pos.y/h)].Remove(i);
  }
   
  public void Clear()
  {
    foodList = new List[ceil(sw/w)][ceil(sh/h)];
    bacteriaList = new List[ceil(sw/w)][ceil(sh/h)];
  }
}

class List
{
  int[] list;
  
  public List()
  {
    list = new int[0];
  }
  
  public void Add(int i)
  {
    for(i = 0; i < list.length; i++)
    {
      if(list[i] == i)
      {
        return;
      }
    }
    
    list = push(list, i);
  }
  
  public void Remove(int i)
  {
    for(i = 0; i < list.length; i++)
    {
      if(list[i] == i)
      {
        list = pop(list, i);
        return;
      }
    }
  }
  
  private int[] push(int[] a, int b)
  {
    int[] c = new int[a.length + 1];
    System.arraycopy(a,0,c,0,a.length);
    c[c.length - 1] = b;
    return c;
  }
  
  private int[] pop(int[] a, int id)
  {
    int j = 0;
    
    for(int i = 0; i < a.length; i++)
    {
      if(list[i] == id)
      {
        j++;
      }
      
      if(i+j < a.length){
        a[i] = a[i+j];
      }
      else{
        a[i] = a[a.length - j];
      }
    }
    
    int[] b = new int[a.length-j];
    System.arraycopy(a,0,b,0,a.length-j);
    return b;
  }
}