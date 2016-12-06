class Timer
{
  
  // Method AddtoStartTime - To offset the time lost when drawing
  
  float startTime;
  float currentTime;
  float duration;
  int foodSensorActive = -1;
  
  public Timer(float duration)
  {
    startTime = millis()*0.001;
    currentTime = 0;
    this.duration = duration;
  }
  
  public Timer(Timer timer)
  {
    this.startTime = timer.startTime;
    this.currentTime = timer.currentTime;
    this.duration = timer.duration;
    this.foodSensorActive = timer.foodSensorActive;
  }
  
  void UpdateTimer()
  {
    currentTime = millis()*0.001 - startTime;
    if(currentTime > duration)
    {
      startTime += duration;
      currentTime = millis()*0.001 - startTime;
      foodSensorActive = -1;
    }
  }
  
  void Reset()
  {
    startTime = millis()*0.001;
    currentTime = 0;
  }
  
  void Reset(int foodSensorActive)
  {
    startTime = millis()*0.001;
    this.foodSensorActive = foodSensorActive;
    currentTime = 0;
  }
  
  public void OffsetStartTime()
  {
    startTime += (millis()*0.001 - (currentTime + startTime));
  }
  
  public float GetTime()
  {
    UpdateTimer();
    return currentTime;
  }
  
  public float GetOverallTime()
  {
    return millis()*0.001;
  }
  
  void Random()
  {
    startTime += random(duration);
  }
}