class Ball
{
  float posX;
  float posY;
  float velX;
  float velY;
  float accY;
  float trackX[];
  float trackY[];
  int trackPoints;
  
  Ball()
  {
    posX = -20;
    posY = -20;
    velX = 0;
    velY = 0;
    accY = 0;
    trackX = new float[10000];
    trackY = new float[10000];
    trackPoints = 0;
  }
  
  void reset(float x, float y)
  {
    posX = x;
    posY = y;
    velX = -5;
    velY = -2;
    accY = 0.05;
  }
  
  void display()
  {
    push();
    strokeWeight(4);
    stroke(0);
    for(int i = 0; i < trackPoints/5; i++)
    {
      point(trackX[i], trackY[i]);
    }
    pop();
    
    if(!(posX < 0 || posX > width || posY < 0 || posY > height))
    {
      trackPoints++;
      if(trackPoints >= 5 * 10000)
      {
        trackPoints = 0;
      }
      if(trackPoints % 5 == 0)
      {
        trackX[trackPoints/5] = posX;
        trackY[trackPoints/5] = posY;
      }
    }
    println(trackPoints);
    
    push();
    strokeWeight(1);
    stroke(0);
    fill(204, 102, 0);
    ellipseMode(CENTER);
    ellipse(posX, posY, 17, 17);
    pop();
  }
  
  void update()
  {
    velY = velY + accY;
    posX = posX + velX;
    posY = posY + velY;
  }
}
