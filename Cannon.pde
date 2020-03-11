class Cannon
{
  float posX;
  float posY;
  PImage CannonImage;
  
  Cannon(float x, float y)
  {
    posX = x;
    posY = y;
    CannonImage = loadImage("img/Cannon.png");
  }
  
  void display()
  {
    push();
    translate(posX, posY);
    scale(-0.35, 0.35);
    imageMode(CENTER);
    image(CannonImage, 0, 0);
    pop();
  }
}
