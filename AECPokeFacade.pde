import processing.sound.*;

AEC aec;
PFont font;
PogoHelper pogo;

SoundFile levelUp;
SoundFile battle;

String teamColor = "";
boolean inBattle = false;
int gymLevel;
float[] numbers;

void setup() {
  frameRate(25);
  size(1200, 400);

  levelUp = new SoundFile(this, "chipquest.wav");
  battle = new SoundFile(this, "115-battle-vs-trainer-.mp3");

  font = createFont("Arial", 26);
  textFont(font);
  numbers = new float[72];
  newRndNumbers();

  aec = new AEC();
  aec.init();
  thread("PokeInfoThread");
}

void newRndNumbers() {
  for (int i = 0; i < 72; i ++) {
    numbers[i] = random(2, 24);
  }
}

void setGymLevel(int i) {
  if (gymLevel != 0 && i > gymLevel) 
    levelUp.play();

  gymLevel = i;
}

void setInBattle(boolean b) {
  if (b && b != inBattle)
    battle.play();
  if (!b && b != inBattle)
    battle.stop();
  inBattle = b;
}

void setTeamColor(String c) {
  teamColor = c;
}

void PokeInfoThread() {
  pogo = new PogoHelper(this);
}

void fillBlue() {
  fill (0, 0, 255);
}

void backgroundBlue() {
  background(0, 0, 255);
}

void fillRed() {
  fill (255, 0, 0);
}

void backgroundRed() {
  background(255, 0, 0);
}

void fillYellow() {
  fill (255, 255, 0);
}

void backgroundYellow() {
  background(255, 255, 0);
}

void fillWhite() {
  fill (255, 255, 255, 100);
}

void drawNeutral() {
  int wid = 1;
  int hei = 6;
  int y = 0;
  int x = (frameCount / 3) % 55;  
  for (int i =  0; i < 72; i += wid) {  
    int x2 = (x+i) % 72;
    fillBlue();
    rect(x2, y, wid, hei);
    rect(x2, y - 3 * hei, wid, hei);
    rect(x2, y + 3 * hei, wid, hei);

    fillRed();
    rect(x2, y + hei, wid, hei);
    rect(x2, y - 2 * hei, wid, hei);
    rect(x2, y + 4 * hei, wid, hei);

    fillYellow();
    rect(x2, y + 2 * hei, wid, hei);
    rect(x2, y - hei, wid, hei);
    rect(x2, y + 5 * hei, wid, hei);

    y ++;
    if (y == 3 * hei) y = 0;
  }
}

void draw() {
  aec.beginDraw();

  switch(teamColor) {
  case "BLUE":
    backgroundBlue();
    fillRed();
    break;
  case "RED":   
    backgroundRed();
    fillYellow();
    break; 
  case "YELLOW":
    backgroundYellow();
    fillBlue();
    break;
  default: 
    drawNeutral();
  }  
  noStroke();

  if (inBattle) {
    fill (0, 0, 0);

    for (int i = 0; i < 72; i ++) {
      if (frameCount % 7 == 0)       
        newRndNumbers();
      rect(i, 0, 1, numbers[i]);
    }
  } else {
    if (gymLevel > 0) {
     
      textAlign(LEFT, CENTER);
      pushMatrix();

      if (gymLevel >= 10) {
        scale(0.325, 0.8);
        text(gymLevel, 60, 10);
      } else {
        scale(0.5, 0.8);
        text(gymLevel, 42, 10);
      }
      popMatrix();
    }
  }

  aec.endDraw();
  aec.drawSides();
}

void keyPressed() {
  aec.keyPressed(key);
}