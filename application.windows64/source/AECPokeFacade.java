import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.Color; 

import alldev.aec.*; 
import svarzee.gps.gpsoauth.*; 
import okio.*; 
import com.squareup.moshi.*; 
import com.annimon.stream.*; 
import com.annimon.stream.function.*; 
import com.annimon.stream.function.ints.*; 
import com.google.protobuf.*; 
import com.google.protobuf.compiler.*; 
import okhttp3.*; 
import okhttp3.internal.*; 
import okhttp3.internal.cache.*; 
import okhttp3.internal.connection.*; 
import okhttp3.internal.framed.*; 
import okhttp3.internal.http.*; 
import okhttp3.internal.io.*; 
import okhttp3.internal.platform.*; 
import okhttp3.internal.tls.*; 
import com.pokegoapi.api.gym.*; 
import com.pokegoapi.api.inventory.*; 
import com.pokegoapi.api.map.fort.*; 
import com.pokegoapi.api.map.*; 
import com.pokegoapi.api.map.pokemon.*; 
import com.pokegoapi.api.player.*; 
import com.pokegoapi.api.pokemon.*; 
import com.pokegoapi.api.*; 
import com.pokegoapi.api.settings.*; 
import com.pokegoapi.auth.*; 
import com.pokegoapi.examples.*; 
import com.pokegoapi.exceptions.*; 
import com.pokegoapi.google.common.geometry.*; 
import com.pokegoapi.main.*; 
import com.pokegoapi.util.*; 
import POGOProtos.Data.*; 
import POGOProtos.Data.Battle.*; 
import POGOProtos.Data.Capture.*; 
import POGOProtos.Data.Gym.*; 
import POGOProtos.Data.Logs.*; 
import POGOProtos.Data.Player.*; 
import POGOProtos.Enums.*; 
import POGOProtos.Inventory.*; 
import POGOProtos.Inventory.Item.*; 
import POGOProtos.Map.Fort.*; 
import POGOProtos.Map.*; 
import POGOProtos.Map.Pokemon.*; 
import POGOProtos.Networking.Envelopes.*; 
import POGOProtos.Networking.Requests.Messages.*; 
import POGOProtos.Networking.Requests.*; 
import POGOProtos.Networking.Responses.*; 
import POGOProtos.Settings.*; 
import POGOProtos.Settings.Master.*; 
import POGOProtos.Settings.Master.Item.*; 
import POGOProtos.Settings.Master.Pokemon.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AECPokeFacade extends PApplet {

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

public void setup() {
  frameRate(25);
  

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

public void newRndNumbers(boolean init) {
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

public void setGymLevel(int i) {
  if (i > gymLevel)   
    //levelUp.play();
  if (i != gymLevel)
    stopPokeTransition();
  gymLevel = i;
}

public void setServerUnreachable(boolean b) {
  if (b != serverUnreachable)
    stopPokeTransition();
  serverUnreachable = b;
}

public void setInBattle(boolean b) {
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

public void stopBattle() {
  //battle.stop();
  stopBattleSpiral();
}
public void stopPokeTransition() {
  alpha = 0;
  countTime = 0;
  aD = 2;
  passedTimeToShowBall = false;
}

public void stopBattleSpiral() {
  spiralX = 0;
  spiralY = 0;
  spiralD = Direction.DOWN;
  spiralW = 10;
  spiralH = 20;
  spiralI = 0;
  rects = new ArrayList<Rect>();
}

public void setTeamColor(String c) {
  teamColor = c;
}

public void PokeInfoThread() {
  pogo = new PogoHelper(this);
}

public void fillBlue() {
  fill (0, 0, 255);
}

public void backgroundBlue() {
  background(0, 0, 255);
}

public void fillRed() {
  fill (255, 0, 0);
}

public void backgroundRed() {
  background(255, 0, 0);
}

public void fillYellow() {
  fill (255, 255, 0);
}

public void backgroundYellow() {
  background(255, 255, 0);
}

public void backgroundGreen() {
  background(88, 133, 40);
}

public void fillGreen() {
  fill (88, 133, 40);
}

public void drawNeutral() {
  background(255, 255, 255);
  drawPokeBall(14, 0, 0, 0, 255);
  drawPokeBall(24, 0, 0, 0, 255);
  drawPokeBall(34, 0, 0, 0, 255);
}

public void drawColorSpiral() {
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

public void drawPokeBallTransition() {
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

public void drawPokeBall(int x, int r, int g, int b, int a) {
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

public void drawEqualizer() {
  fill (0, 0, 0, 200);
  for (int i = 0; i < 40; i ++) {
    if (frameCount % 10 == 0)       
      newRndNumbers(false);
    rect(i, 0, 1, numbers[i]);
  }
}

public void drawBattleSpiral(int x) {
  fill (0, 0, 0);
  int y = 0;

  if (spiralD == Direction.DOWN || spiralD == Direction.UP) {
    rects.add(verticalRect(x + spiralX, y + spiralY ));
  } else {
    rects.add(horizontalRect(x + spiralX, y + spiralY ));
  }
}

public void drawBattle() {
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

public Rect verticalRect(int x, int y) {
  Rect rect = new Rect();
  rect.x = x;
  rect.y = y;
  rect.w = 1;
  rect.h = 2;
  return rect;
}

public Rect horizontalRect(int x, int y) {
  Rect rect = new Rect();
  rect = new Rect();
  rect.x = x;
  rect.y = y;
  rect.w = 1;
  rect.h = 2;
  rects.add(rect);
  return rect;
}

public void drawServerUnreachable() {
  backgroundGreen();
  drawPokeBall(14, 88, 133, 40, 255);
  drawPokeBall(24, 88, 133, 40, 255);
  drawPokeBall(34, 88, 133, 40, 255);
}

public void drawGymLevel() {
  if (!inBattle && gymLevel > 0 && !passedTimeToShowBall) {
    textAlign(LEFT, CENTER);
    pushMatrix();
    if (gymLevel >= 10) {
      scale(0.325f, 0.8f);
      text(gymLevel, 29, 10);
      text(gymLevel, 60, 10);
      text(gymLevel, 91, 10);
    } else {
      scale(0.5f, 0.8f);
      text(gymLevel, 22, 10);
      text(gymLevel, 42, 10);
      text(gymLevel, 62, 10);
    }
    popMatrix();
  }
}

public void drawTeamColors() {
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

public void drawNormal() {
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

public void draw() {
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

public void keyPressed() {
  aec.keyPressed(key);
}



class AEC {
  AECPlugin plugin = new AECPlugin();
  HouseDrawer house = new HouseDrawer(plugin);
  
  public AEC() {
  }

  public void init() {
    plugin.setFrameWidth(width);
    plugin.init();
    loadConfig();
  }
    
  public void loadConfig() {
    plugin.loadConfig();
  }
  
  public void beginDraw() {
    scale(2 * plugin.scale, plugin.scale);
  }
  
  public void endDraw() {
    // reset of the transformation
    resetMatrix();
    
    loadPixels();
    plugin.update(pixels);
  }
  
  public void drawSides() {
    house.draw();
  }
  
  public void keyPressed(int value) {
    plugin.keyPressed(value, keyCode);
    
    if (value == 'i') {
      house.toggleIds();
    }
  }

  public void setActiveColor(Color c) {
    plugin.setActiveColor(c);
  }

  public void setInActiveColor(Color c) {
    plugin.setInActiveColor(c);
  }
  
  public int getScaleX() {
    return 2 * plugin.scale;
  }
  
  public int getScaleY() {
    return plugin.scale;
  }  
}

class HouseDrawer {
  AECPlugin aec;
  int size = 10;  
  PFont font;
  boolean showIds = false;
  
  public HouseDrawer(AECPlugin aec_) {
    aec = aec_;
    font = loadFont("LucidaConsole-8.vlw"); 
  }
  
  public void toggleIds() {
    showIds = !showIds;
  }
  
  public void draw() {
    resetMatrix();
    
    for (int i = 0; i < Building.SIDE.values().length; ++i) {
      Building.SIDE sideEnum = Building.SIDE.values()[i];
      Side side = aec.getSide(sideEnum);
      
      stroke(side.getColor().getRed(), side.getColor().getGreen(), side.getColor().getBlue(), side.getColor().getAlpha());
      noFill();
      drawSide(side);     
    }
  }
  
  public void drawSide(Side s) {
    int[][] adr = s.getWindowAddress();
    int pWidth = s.getPixelWidth();
    int pHeight = s.getPixelHeight();

    for (int y = 0; y < adr.length; ++y) {
      for (int x = 0; x < adr[y].length; ++x) {
        if (adr[y][x] > -1) {
          int fx = (s.getX() + x * pWidth) * aec.scale;
          int fy = (s.getY() + y * pHeight) * aec.scale;
          rect(fx, fy, pWidth * aec.scale, pHeight * aec.scale);
          
          if (showIds) {
            textFont(font, 8); 
            text("" + adr[y][x], fx + pWidth * aec.scale / 4, fy + pHeight * aec.scale * 0.9f);
          }
        }
      }
    }
  }
}
class PogoHelper implements AECInfoListener {

  AECPokeFacade facade;

  int serverUnreachableCount = 0;

  public PogoHelper(AECPokeFacade s) {
    facade = s;   

    dummyRoutine();
    dummyRoutine();
    //dummyRoutine();

    AECPokeInfo info = new AECPokeInfo();
    info.registerListener(this);
    info.startRoutine();

    //dummyUnderAttack();
    //dummyServerUnreachable();
  }

  public void dummyUnderAttack() {
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));
  }

  public void dummyServerUnreachable() {
    facade.setServerUnreachable(true);
  }

  public void dummyRoutine() {
    dummyServerUnreachable();
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "", 0));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 1));
    sleep(40000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));    
    sleep(35000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 2));   
    sleep(15000);
    dummyServerUnreachable();
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 2));    
    sleep(25000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));
    sleep(10000);
    dummyServerUnreachable();
    sleep(15000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));
    sleep(10000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 1));
    sleep(5000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 0));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "", 0));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "RED", 1));
    sleep(15000);
    AECInfoUpdated(dummyInfo(true, "RED", 1));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "RED", 2));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 3));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 4));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 5));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 6));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 7));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 8));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 9));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "YELLOW", 10));
    sleep(5000);
  }

  public AECInfo dummyInfo(boolean battle, String c, int level) {
    AECInfo i = new AECInfo();
    i.setInBattle(battle);
    i.setTeamColor(c);
    i.setGymLevel(level);
    return i;
  }

  public void sleep (int milis) {
    try {
      Thread.sleep(milis);
    } 
    catch(InterruptedException e) {
      e.printStackTrace();
    }
  }

  @Override
    public void AECInfoUpdated(AECInfo i) {
    if (i.getExc() != null) {
      serverUnreachableCount++;
      if (serverUnreachableCount >= 5) {
        facade.setServerUnreachable(true);
        System.out.println("10 sec since we last reached the server. do something?");
        serverUnreachableCount = 0;
      }
    } else {
      facade.setServerUnreachable(false);
      facade.setTeamColor(i.getTeamColor());
      facade.setInBattle(i.isInBattle());
      facade.setGymLevel(i.getGymLevel());
    }
  }
}

public class Rect {
  
  int x;
  int y;
  int w;
  int h;
  
}
  public void settings() {  size(1200, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AECPokeFacade" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
