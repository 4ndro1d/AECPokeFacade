class PogoHelper implements AECInfoListener { //<>//

  AECPokeFacade facade;

  int serverUnreachableCount = 0;

  public PogoHelper(AECPokeFacade s) {
    facade = s;   

    //dummyRoutine();
    //dummyRoutine();
    //dummyRoutine();

    AECPokeInfo info = new AECPokeInfo();
    info.registerListener(this);
    info.startRoutine();

    //dummyUnderAttack();
    //dummyServerUnreachable();
  }

  void dummyUnderAttack() {
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));
  }

  void dummyServerUnreachable() {
    facade.setServerUnreachable(true);
  }

  void dummyRoutine() {
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
    sleep(30000);
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

  AECInfo dummyInfo(boolean battle, String c, int level) {
    AECInfo i = new AECInfo();
    i.setInBattle(battle);
    i.setTeamColor(c);
    i.setGymLevel(level);
    return i;
  }

  void sleep (int milis) {
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