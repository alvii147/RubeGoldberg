class Button
{
  float posX;
  float posY;
  float len;
  float wid;
  float scaleFactor;
  float scaleScaler;
  PImage ButtonImage;
  boolean modePlay;
  
  Button(float x, float y, float l, float w, float sF, boolean mP, String img)
  {
    posX = x;
    posY = y;
    len = l;
    wid = w;
    scaleFactor = sF;
    scaleScaler = 1;
    ButtonImage = loadImage(img);
    modePlay = mP;
  }
  
  void display()
  {
    if(mouseHoverDetect() || (modePlay && GAME_MODE == Mode.Play) || (!modePlay && GAME_MODE != Mode.Play))
    {
      scaleScaler = 1.25;
    }
    else
    {
      scaleScaler = 1;
    }
    
    push();
    if((modePlay && GAME_MODE == Mode.Play) || (!modePlay && GAME_MODE != Mode.Play))
    {
      rectMode(CENTER);
      fill(153, 153, 230);
      stroke(30, 45, 66);
      strokeWeight(7);
      rect(posX, posY, len - 20, wid - 20);
    }
    translate(posX, posY);
    scale(scaleFactor * scaleScaler);
    imageMode(CENTER);
    image(ButtonImage, 0, 0);
    pop();
  }
  
  boolean mouseHoverDetect()
  {
    if(mouseX < posX + (len / 2) && mouseX > posX - (len / 2) && mouseY < posY + (wid / 2) && mouseY > posY - (wid / 2))
    {
      return true;
    }
    return false;
  }
}
