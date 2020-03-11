Ball m_Ball;
Cannon m_Cannon;
Button m_EditButton;
Button m_PlayButton;
Label m_ModeLabel;
Label m_ItemLabel;
Bouncer[] m_Bouncer = new Bouncer[100];
BoostPad[] m_BoostPad = new BoostPad[100];

int bouncerCount;
int boostPadCount;
float INIT_X_BALL;
float INIT_Y_BALL;
float INIT_X_CANNON;
float INIT_Y_CANNON;

PImage spaceImg;
PImage aKeyImg;
PImage dKeyImg;

enum Mode
{
  Play,
  Bouncer,
  BoostPad
}

Mode LAST_EDIT_MODE = Mode.Bouncer;

Mode GAME_MODE;

void setup()
{
  size(1875, 950);
  surface.setLocation(20, 20);
  
  bouncerCount = 0;
  boostPadCount = 0;
  INIT_X_BALL = width - 100;
  INIT_Y_BALL = 50;
  INIT_X_CANNON = width - 50;
  INIT_Y_CANNON = 75;
  GAME_MODE = Mode.Play;
  m_Ball = new Ball();
  m_Cannon = new Cannon(INIT_X_CANNON, INIT_Y_CANNON);
  m_PlayButton = new Button(50, 50, 100, 100, 0.12, true, "img/play.png");
  m_EditButton = new Button(150, 50, 100, 100, 0.12, false, "img/wrench.png");
  m_ModeLabel = new Label("Play Mode", 230, 120, 130, 25, "img/QKey.png", "img/EKey.png");
  m_ItemLabel = new Label("Bouncer", 230, 160, 130, 25, "img/WKey.png", "img/SKey.png");
  spaceImg = loadImage("img/SpaceKey.png");
  aKeyImg = loadImage("img/AKey.png");
  dKeyImg = loadImage("img/DKey.png");
}

void draw()
{
  background(153, 153, 230);
  m_Ball.update();
  m_Ball.display();
  m_Cannon.display();
  for(int i = 0; i < bouncerCount; i++)
  {
    m_Bouncer[i].display();
  }
  for(int i = 0; i < boostPadCount; i++)
  {
    m_BoostPad[i].display();
  }
  m_PlayButton.display();
  m_EditButton.display();
  
  if(GAME_MODE == Mode.Play)
  {
    m_ModeLabel.text = "Play Mode";
  }
  else
  {
    m_ModeLabel.text = "Edit Mode";
    if(GAME_MODE == Mode.Bouncer)
    {
      m_ItemLabel.text = "Bouncer";
    }
    else if(GAME_MODE == Mode.BoostPad)
    {
      m_ItemLabel.text = "BoostPad";
    }
  }
  push();
  stroke(0);
  fill(0);
  textSize(18);
  textMode(CENTER);
  textAlign(RIGHT);
  text("Game Mode:", 130, 125);
  text("Item:", 130, 165);
  text("Launch:", 130, 205);
  text("Change Angle:", 130, 245);
  pop();
  
  push();
  translate(230, 200);
  scale(0.1);
  imageMode(CENTER);
  image(spaceImg, 0, 0);
  pop();
  
  push();
  translate(210, 240);
  scale(0.5);
  imageMode(CENTER);
  image(aKeyImg, 0, 0);
  image(dKeyImg, 85, 0);
  pop();
  
  m_ModeLabel.display();
  m_ItemLabel.display();
  CollisionBouncer();
  CollisionBoostPad();
}

void CollisionBouncer()
{
  for(int i = 0; i < bouncerCount; i++)
  {
    if(!m_Bouncer[i].active)
    {
      continue;
    }
    float verticalLength = m_Bouncer[i].len * sin(radians(m_Bouncer[i].angle + 90));
    float horizontalLength = m_Bouncer[i].len * cos(radians(m_Bouncer[i].angle + 90));
    float x1 = m_Bouncer[i].posX + (verticalLength/2);
    float x2 = m_Bouncer[i].posX - (verticalLength/2);
    float y1 = m_Bouncer[i].posY - (horizontalLength/2);
    float y2 = m_Bouncer[i].posY + (horizontalLength/2);
    
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
    
    float velMag = sqrt((m_Ball.velX * m_Ball.velX) + (m_Ball.velY * m_Ball.velY));
    float ballAngle = 0;
    if(m_Ball.velX >= 0 && m_Ball.velY >= 0)
    {
      ballAngle = degrees(atan(m_Ball.velY/m_Ball.velX));
    }
    else if(m_Ball.velX >=0 && m_Ball.velY <= 0)
    {
      ballAngle = 360 - degrees(atan((-m_Ball.velY)/m_Ball.velX));
    }
    else if(m_Ball.velX <= 0 && m_Ball.velY >= 0)
    {
      ballAngle = 180 - degrees(atan(m_Ball.velY/(-m_Ball.velX)));
    }
    else if(m_Ball.velX <= 0 && m_Ball.velY <= 0)
    {
      ballAngle = 180 + degrees(atan(m_Ball.velY/m_Ball.velX));
    }
    
    if((x1 >= x2 && m_Ball.posX >= x2 && m_Ball.posX <= x1) || (x1 <= x2 && m_Ball.posX >= x1 && m_Ball.posX <= x2))
    {
      if((y1 >= y2 && m_Ball.posY >= y2 && m_Ball.posY <= y1) || (y1 <= y2 && m_Ball.posY >= y1 && m_Ball.posY <= y2))
      {
        float delGrad = ((y2 - y1)/(x2 - x1)) - ((y2 - m_Ball.posY)/(x2 - m_Ball.posX));
        if(m_Bouncer[i].status == 0 || m_Bouncer[i].status == int(delGrad/abs(delGrad)))
        {
          m_Bouncer[i].status = int(delGrad/abs(delGrad));
        }
        else if(m_Bouncer[i].status != int(delGrad/abs(delGrad)) && m_Bouncer[i].status != 2)
        {
          float normal_1 = (m_Bouncer[i].angle + 270) % 360;
          float normal_2 = (m_Bouncer[i].angle + 450) % 360;
          float deflectionAngle = 0;
          if(abs(ballAngle - normal_1) <= abs(ballAngle - normal_2))
          {
            float delAngle = ballAngle - normal_1;
            deflectionAngle = (normal_2 - delAngle + 360) % 360;
          }
          else
          {
            float delAngle = ballAngle - normal_2;
            deflectionAngle = (normal_1 - delAngle + 360) % 360;
          }
          
          if(deflectionAngle <= 90)
          {
            m_Ball.velX = velMag * cos(radians(deflectionAngle)) * m_Bouncer[i].efficiency;
            m_Ball.velY = velMag * sin(radians(deflectionAngle)) * m_Bouncer[i].efficiency;
          }
          else if(deflectionAngle <= 180)
          {
            m_Ball.velX = -velMag * cos(radians(180 - deflectionAngle)) * m_Bouncer[i].efficiency;
            m_Ball.velY = velMag * sin(radians(180 - deflectionAngle)) * m_Bouncer[i].efficiency;
          }
          else if(deflectionAngle <= 270)
          {
            m_Ball.velX = -velMag * cos(radians(deflectionAngle - 180)) * m_Bouncer[i].efficiency;
            m_Ball.velY = -velMag * sin(radians(deflectionAngle - 180)) * m_Bouncer[i].efficiency;
          }
          else
          {
            m_Ball.velX = velMag * cos(radians(360 - deflectionAngle)) * m_Bouncer[i].efficiency;
            m_Ball.velY = -velMag * sin(radians(360 - deflectionAngle)) * m_Bouncer[i].efficiency;
          }
          m_Bouncer[i].status = 2;
        }
      }
      else
      {
        m_Bouncer[i].status = 0;
      }
    }
    else
    {
      m_Bouncer[i].status = 0;
    }
  }
}

void CollisionBoostPad()
{
  for(int i = 0; i < boostPadCount; i++)
  {
    if(!m_BoostPad[i].active)
    {
      continue;
    }
    float verticalLength = m_BoostPad[i].len * sin(radians(m_BoostPad[i].angle + 90));
    float horizontalLength = m_BoostPad[i].len * cos(radians(m_BoostPad[i].angle + 90));
    float x1 = m_BoostPad[i].posX + (verticalLength/2);
    float x2 = m_BoostPad[i].posX - (verticalLength/2);
    float y1 = m_BoostPad[i].posY - (horizontalLength/2);
    float y2 = m_BoostPad[i].posY + (horizontalLength/2);
    
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
    
    float velMag = sqrt((m_Ball.velX * m_Ball.velX) + (m_Ball.velY * m_Ball.velY));
    float ballAngle = 0;
    if(m_Ball.velX >= 0 && m_Ball.velY >= 0)
    {
      ballAngle = degrees(atan(m_Ball.velY/m_Ball.velX));
    }
    else if(m_Ball.velX >=0 && m_Ball.velY <= 0)
    {
      ballAngle = 360 - degrees(atan((-m_Ball.velY)/m_Ball.velX));
    }
    else if(m_Ball.velX <= 0 && m_Ball.velY >= 0)
    {
      ballAngle = 180 - degrees(atan(m_Ball.velY/(-m_Ball.velX)));
    }
    else if(m_Ball.velX <= 0 && m_Ball.velY <= 0)
    {
      ballAngle = 180 + degrees(atan(m_Ball.velY/m_Ball.velX));
    }
    
    if((x1 >= x2 && m_Ball.posX >= x2 && m_Ball.posX <= x1) || (x1 <= x2 && m_Ball.posX >= x1 && m_Ball.posX <= x2))
    {
      if((y1 >= y2 && m_Ball.posY >= y2 && m_Ball.posY <= y1) || (y1 <= y2 && m_Ball.posY >= y1 && m_Ball.posY <= y2))
      {
        float delGrad = ((y2 - y1)/(x2 - x1)) - ((y2 - m_Ball.posY)/(x2 - m_Ball.posX));
        if(m_BoostPad[i].status == 0 || m_BoostPad[i].status == int(delGrad/abs(delGrad)))
        {
          m_BoostPad[i].status = int(delGrad/abs(delGrad));
        }
        else if(m_BoostPad[i].status != int(delGrad/abs(delGrad)) && m_BoostPad[i].status != 2)
        {
          float normal_1 = (m_BoostPad[i].angle + 270) % 360;
          float normal_2 = (m_BoostPad[i].angle + 450) % 360;
          float deflectionAngle = 0;
          if(abs(ballAngle - normal_1) <= abs(ballAngle - normal_2))
          {
            float delAngle = ballAngle - normal_1;
            deflectionAngle = (normal_2 - delAngle + 360) % 360;
          }
          else
          {
            float delAngle = ballAngle - normal_2;
            deflectionAngle = (normal_1 - delAngle + 360) % 360;
          }
          
          if(deflectionAngle <= 90)
          {
            m_Ball.velX = velMag * cos(radians(deflectionAngle)) * m_BoostPad[i].efficiency;
            m_Ball.velY = velMag * sin(radians(deflectionAngle)) * m_BoostPad[i].efficiency;
          }
          else if(deflectionAngle <= 180)
          {
            m_Ball.velX = -velMag * cos(radians(180 - deflectionAngle)) * m_BoostPad[i].efficiency;
            m_Ball.velY = velMag * sin(radians(180 - deflectionAngle)) * m_BoostPad[i].efficiency;
          }
          else if(deflectionAngle <= 270)
          {
            m_Ball.velX = -velMag * cos(radians(deflectionAngle - 180)) * m_BoostPad[i].efficiency;
            m_Ball.velY = -velMag * sin(radians(deflectionAngle - 180)) * m_BoostPad[i].efficiency;
          }
          else
          {
            m_Ball.velX = velMag * cos(radians(360 - deflectionAngle)) * m_BoostPad[i].efficiency;
            m_Ball.velY = -velMag * sin(radians(360 - deflectionAngle)) * m_BoostPad[i].efficiency;
          }
          m_BoostPad[i].status = 2;
        }
      }
      else
      {
        m_BoostPad[i].status = 0;
      }
    }
    else
    {
      m_BoostPad[i].status = 0;
    }
  }
}

void mouseReleased()
{
  if(GAME_MODE == Mode.Bouncer && !m_PlayButton.mouseHoverDetect() && !m_EditButton.mouseHoverDetect() && !m_ModeLabel.mouseHoverDetect() && !m_ItemLabel.mouseHoverDetect())
  {
    if(mouseButton == LEFT)
    {
      m_Bouncer[bouncerCount] = new Bouncer(mouseX, mouseY, 0);
      bouncerCount++;
    }
    else if(mouseButton == RIGHT)
    {
      for(int i = 0; i < bouncerCount; i++)
      {
        if(m_Bouncer[i].mouseHoverDetect())
        {
          m_Bouncer[i].active = false;
        }
      }
      for(int i = 0; i < boostPadCount; i++)
      {
        if(m_BoostPad[i].mouseHoverDetect())
        {
          m_BoostPad[i].active = false;
        }
      }
    }
  }
  else if(GAME_MODE == Mode.BoostPad && !m_PlayButton.mouseHoverDetect() && !m_EditButton.mouseHoverDetect())
  {
    if(mouseButton == LEFT)
    {
      m_BoostPad[boostPadCount] = new BoostPad(mouseX, mouseY, 0);
      boostPadCount++;
    }
    else if(mouseButton == RIGHT)
    {
      for(int i = 0; i < bouncerCount; i++)
      {
        if(m_Bouncer[i].mouseHoverDetect())
        {
          m_Bouncer[i].active = false;
        }
      }
      for(int i = 0; i < boostPadCount; i++)
      {
        if(m_BoostPad[i].mouseHoverDetect())
        {
          m_BoostPad[i].active = false;
        }
      }
    }
  }
}

void mouseClicked()
{
  if(m_PlayButton.mouseHoverDetect() && GAME_MODE != Mode.Play)
  {
    GAME_MODE = Mode.Play;
  }
  else if(m_EditButton.mouseHoverDetect() && GAME_MODE == Mode.Play)
  {
    m_Ball.reset(4000, 4000);
    GAME_MODE = LAST_EDIT_MODE;
  }
}

void keyReleased()
{
  if(keyCode == ' ')
  {
    m_Ball.trackPoints = 0;
    GAME_MODE = Mode.Play;
    m_Ball.reset(INIT_X_BALL, INIT_Y_BALL);
  }
}

void keyPressed()
{
  if(keyCode == 'a' || keyCode == 'A')
  {
    if(GAME_MODE == Mode.Bouncer && bouncerCount != 0)
    {
      m_Bouncer[bouncerCount - 1].angle = (m_Bouncer[bouncerCount - 1].angle + 355) % 360;
    }
    if(GAME_MODE == Mode.BoostPad && boostPadCount != 0)
    {
      m_BoostPad[boostPadCount - 1].angle = (m_BoostPad[boostPadCount - 1].angle + 355) % 360;
    }
  }
  else if(keyCode == 'd' || keyCode == 'D')
  {
    if(GAME_MODE == Mode.Bouncer && bouncerCount != 0)
    {
      m_Bouncer[bouncerCount - 1].angle = (m_Bouncer[bouncerCount - 1].angle + 365) % 360;
    }
    if(GAME_MODE == Mode.BoostPad && boostPadCount != 0)
    {
      m_BoostPad[boostPadCount - 1].angle = (m_BoostPad[boostPadCount - 1].angle + 365) % 360;
    }
  }
  else if(keyCode == 'w' || keyCode == 'W')
  {
    if(GAME_MODE == Mode.Bouncer)
    {
      GAME_MODE = Mode.BoostPad;
      LAST_EDIT_MODE = Mode.BoostPad;
    }
    else if(GAME_MODE == Mode.BoostPad)
    {
      GAME_MODE = Mode.Bouncer;
      LAST_EDIT_MODE = Mode.Bouncer;
    }
  }
  else if(keyCode == 's' || keyCode == 'S')
  {
    if(GAME_MODE == Mode.Bouncer)
    {
      GAME_MODE = Mode.BoostPad;
      LAST_EDIT_MODE = Mode.BoostPad;
    }
    else if(GAME_MODE == Mode.BoostPad)
    {
      GAME_MODE = Mode.Bouncer;
      LAST_EDIT_MODE = Mode.Bouncer;
    }
  }
  else if(keyCode == 'q' || keyCode == 'Q')
  {
    if(GAME_MODE != Mode.Play)
    {
      LAST_EDIT_MODE = GAME_MODE;
      GAME_MODE = Mode.Play;
    }
    else
    {
      GAME_MODE = LAST_EDIT_MODE;
      m_Ball.reset(4000, 4000);
    }
  }
  else if(keyCode == 'e' || keyCode == 'E')
  {
    if(GAME_MODE != Mode.Play)
    {
      LAST_EDIT_MODE = GAME_MODE;
      GAME_MODE = Mode.Play;
    }
    else
    {
      GAME_MODE = LAST_EDIT_MODE;
      m_Ball.reset(4000, 4000);
    }
  }
}
