class Label
{
  String text;
  float posX;
  float posY;
  float len;
  float wid;
  float keyScale;
  float scaleScaler;
  PImage keyImageLeft;
  PImage keyImageRight;
  
  Label(String txt, float x, float y, float l, float w, String kImgL, String kImgR)
  {
    text = txt;
    posX = x;
    posY = y;
    len = l;
    wid = w;
    keyScale = 0.5;
    scaleScaler = 1;
    keyImageLeft = loadImage(kImgL);
    keyImageRight = loadImage(kImgR);
  }
  
  void display()
  {
    push();
    rectMode(CENTER);
    stroke(0);
    fill(0);
    rect(posX, posY, len, wid);
    stroke(255);
    fill(255);
    textSize(18);
    textMode(CENTER);
    textAlign(CENTER);
    text(text, posX, posY, len, wid);
    pop();
    
    push();
    translate(posX - (len/2) - 10, posY);
    scale(keyScale * scaleScaler);
    imageMode(CENTER);
    image(keyImageLeft, 0, 0);
    pop();
    
    push();
    translate(posX + (len/2) + 10, posY);
    scale(keyScale * scaleScaler);
    imageMode(CENTER);
    image(keyImageRight, 0, 0);
    pop();
  }
  
  boolean mouseHoverDetect()
  {
    if(mouseX < posX + (len / 2) + 20 && mouseX > posX - (len / 2) - 20 && mouseY < posY + (wid / 2) + 10 && mouseY > posY - (wid / 2) - 10)
    {
      return true;
    }
    return false;
  }
}
