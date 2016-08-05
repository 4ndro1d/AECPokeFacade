//import processing.sound.*;

AEC aec;
PFont font;
PogoHelper pogo;

//SoundFile levelUp;
//SoundFile battle;

String teamColor;
boolean inBattle;
boolean serverUnreachable = true;
int gymLevel;
float[] numbers;
ArrayList<Rect> rects = new ArrayList<Rect>();
int spiralX = 0;
int spiralY = 0;
Direction spiralD = Direction.DOWN;
int spiralW = 10;
int spiralH = 20;
int spiralI = 0;
int waitTime = 500;
int alpha = 0;
int aD = 2;

int countTime = 0;
boolean passedTimeToShowBall = false;
boolean drawBattleSpiral = true;


enum Direction {
  DOWN, UP, LEFT, RIGHT
}

void setup() {
  frameRate(25);
  size(1200, 400);

  //levelUp = new SoundFile(this, "levelup.mp3");
  //battle = new SoundFile(this, "115-battle-vs-trainer-.mp3");

  font = createFont("Arial", 26);
  textFont(font);
  numbers = new float[72];
  newRndNumbers(true);

  aec = new AEC();
  aec.init();
  thread("PokeInfoThread");
}

void newRndNumbers(boolean init) {
  for (int i = 0; i < 40; i ++) {
    if (init) {
      numbers[i] = random(2, 20);
    } else {
      numbers[i] += random(-1, 1);
      if (numbers[i] < 3 || numbers[i] > 19)
        numbers[i] = random(2, 20);
    }
  }
}

void setGymLevel(int i) {
  if (i > gymLevel)   
    //levelUp.play();
  if (i != gymLevel)
    stopPokeTransition();
  gymLevel = i;
}

void setServerUnreachable(boolean b) {
  if (b != serverUnreachable)
    stopPokeTransition();
  serverUnreachable = b;
}

void setInBattle(boolean b) {
  if (b && b != inBattle) {
    //battle.play();
    drawBattleSpiral = true;
    stopPokeTransition();
  }
  if (!b && b != inBattle) {
    stopBattle();
  }
  inBattle = b;
}

void stopBattle() {
  //battle.stop();
  stopBattleSpiral();
}
void stopPokeTransition() {
  alpha = 0;
  countTime = 0;
  aD = 2;
  passedTimeToShowBall = false;
}

void stopBattleSpiral() {
  spiralX = 0;
  spiralY = 0;
  spiralD = Direction.DOWN;
  spiralW = 10;
  spiralH = 20;
  spiralI = 0;
  rects = new ArrayList<Rect>();
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

void backgroundGreen() {
  background(88, 133, 40);
}

void fillGreen() {
  fill (88, 133, 40);
}

void drawNeutral() {
  background(255, 255, 255);
  drawPokeBall(14, 0, 0, 0, 255);
  drawPokeBall(24, 0, 0, 0, 255);
  drawPokeBall(34, 0, 0, 0, 255);
}

void drawColorSpiral() {
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

void drawPokeBallTransition() {
  if (!inBattle) {
    int b = g.backgroundColor;
    alpha += aD;
    if (alpha < 0) {
      alpha = 0;
      aD *= -1;
      stopPokeTransition();
    }
    if (alpha > 500)
      aD *= -1;

    background(red(b), green(b), blue(b), alpha);
    drawPokeBall(14, 0, 0, 0, alpha);
    drawPokeBall(24, 0, 0, 0, alpha);
    drawPokeBall(34, 0, 0, 0, alpha);
  }
}

void drawPokeBall(int x, int r, int g, int b, int a) {
  int w = 8;
  int y = 10;

  fill(r, g, b, a);
  rect(x - 4, 0, 10, 20);

  fill (255, 0, 0, a);
  rect(x - 3, y - 4, w, 3);
  rect(x - 2, y - 6, w - 2, 2);
  rect(x - 1, y - 7, w - 4, 1);

  fill (255, 255, 255, a);
  rect(x - 3, y, w, 3);
  rect(x - 2, y + 3, w - 2, 2);
  rect(x - 1, y + 5, w - 4, 1);

  fill(r, g, b, a);
  rect(x, y - 2, 2, 3);
}

void drawEqualizer() {
  fill (0, 0, 0, 200);
  for (int i = 0; i < 40; i ++) {
    if (frameCount % 10 == 0)       
      newRndNumbers(false);
    rect(i, 0, 1, numbers[i]);
  }
}

void drawBattleSpiral(int x) {
  fill (0, 0, 0);
  int y = 0;

  if (spiralD == Direction.DOWN || spiralD == Direction.UP) {
    rects.add(verticalRect(x + spiralX, y + spiralY ));
  } else {
    rects.add(horizontalRect(x + spiralX, y + spiralY ));
  }
}

void drawBattle() {
  if (drawBattleSpiral) {
    drawBattleSpiral(10);
    drawBattleSpiral(20);
    drawBattleSpiral(30);

    switch(spiralD) {
    case DOWN:
      if (spiralD == Direction.DOWN || spiralD == Direction.UP) 
        spiralY++;
      spiralY++;
      break;
    case UP:
      if (spiralD == Direction.DOWN || spiralD == Direction.UP) 
        spiralY--;
      spiralY--;
      break;
    case LEFT:
      spiralX--;
      break;
    case RIGHT:
      spiralX++;
      break;
    }

    if (spiralD == Direction.DOWN && spiralY >= spiralH - 2 - spiralI) {
      spiralD = Direction.RIGHT;
    }
    if (spiralD == Direction.UP && spiralY <= spiralI*2 ) {
      spiralD = Direction.LEFT;
    }
    if (spiralD == Direction.RIGHT && spiralX >= spiralW - 1  ) { 
      spiralD = Direction.UP;
    }
    if (spiralD == Direction.LEFT && spiralX <= spiralI + 1) {
      spiralD = Direction.DOWN;
      spiralW--;
      spiralH--;
      spiralI++;
    }

    if (spiralW < spiralI) {
      drawBattleSpiral = false;
      stopBattleSpiral();
    }

    for (int i = 0; i < rects.size(); i ++) {
      Rect rec = rects.get(i);
      rect (rec.x, rec.y, rec.w, rec.h);
    }
  } else {
    drawEqualizer();
  }
}

Rect verticalRect(int x, int y) {
  Rect rect = new Rect();
  rect.x = x;
  rect.y = y;
  rect.w = 1;
  rect.h = 2;
  return rect;
}

Rect horizontalRect(int x, int y) {
  Rect rect = new Rect();
  rect = new Rect();
  rect.x = x;
  rect.y = y;
  rect.w = 1;
  rect.h = 2;
  rects.add(rect);
  return rect;
}

void drawServerUnreachable() {
  backgroundGreen();
  drawPokeBall(14, 88, 133, 40, 255);
  drawPokeBall(24, 88, 133, 40, 255);
  drawPokeBall(34, 88, 133, 40, 255);
}

void drawGymLevel() {
  if (!inBattle && gymLevel > 0 && !passedTimeToShowBall) {
    textAlign(LEFT, CENTER);
    pushMatrix();
    if (gymLevel >= 10) {
      scale(0.325, 0.8);
      text(gymLevel, 29, 10);
      text(gymLevel, 60, 10);
      text(gymLevel, 91, 10);
    } else {
      scale(0.5, 0.8);
      text(gymLevel, 22, 10);
      text(gymLevel, 42, 10);
      text(gymLevel, 62, 10);
    }
    popMatrix();
  }
}

void drawTeamColors() {
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
}

void drawNormal() {
  drawTeamColors();

  countTime++;
  if (countTime > waitTime) {
    passedTimeToShowBall = true;
  }

  if (!passedTimeToShowBall) {
    drawGymLevel();
  } else {
    if (!teamColor.equals("NEUTRAL"))
      drawPokeBallTransition();
  }
}

void draw() {
  aec.beginDraw();
  noStroke();

  if (serverUnreachable) {
    drawServerUnreachable();
  } else {
    drawNormal();
    if (inBattle)
      drawBattle();
  }

  aec.endDraw();
  aec.drawSides();
}

void keyPressed() {
  aec.keyPressed(key);
}