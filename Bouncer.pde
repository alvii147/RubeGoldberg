class Bouncer
{
  float posX;
  float posY;
  float angle;
  float len;
  float wid;
  float efficiency;
  int status;
  boolean active;
  
  Bouncer(float x, float y, float a)
  {
    posX = x;
    posY = y;
    angle = a % 360;
    len = 100;
    wid = 5;
    efficiency = 0.65;
    status = 0;
    active = true;
  }
  
  void display()
  {
    if(!active)
    {
      return;
    }
    push();
    translate(posX, posY);
    rotate(radians(angle));
    strokeWeight(2);
    stroke(255, 191, 0);
    fill(255, 255, 179);
    rectMode(CENTER);
    rect(0, 0, len, wid);
    pop();
  }
  
  boolean mouseHoverDetect()
  {
    float verticalLength = len * sin(radians(angle + 90));
    float horizontalLength = len * cos(radians(angle + 90));
    float x1 = posX + (verticalLength/2);
    float x2 = posX - (verticalLength/2);
    float y1 = posY - (horizontalLength/2);
    float y2 = posY + (horizontalLength/2);
    
    if(abs(x1 - x2) <= 50)
    {
      if(x1 <= x2)
      {
        x1 = x1 - 25;
        x2 = x2 + 25;
      }
      else
      {
        x1 = x1 + 25;
        x2 = x2 - 25;
      }
    }
    
    if(abs(y1 - y2) <= 50)
    {
      if(y1 <= y2)
      {
        y1 = y1 - 25;
        y2 = y2 + 25;
      }
      else
      {
        y1 = y1 + 25;
        y2 = y2 - 25;
      }
    }
    
    if((x1 >= x2 && mouseX >= x2 && mouseX <= x1) || (x1 <= x2 && mouseX >= x1 && mouseX <= x2))
    {
      if((y1 >= y2 && mouseY >= y2 && mouseY <= y1) || (y1 <= y2 && mouseY >= y1 && mouseY <= y2))
      {
        return true;
      }
    }
    
    return false;
  }
}
