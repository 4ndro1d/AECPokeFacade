class PogoHelper implements AECInfoListener {

  AECPokeFacade facade;

  public PogoHelper(AECPokeFacade s) {
    facade = s;
    //PokeGoHelper.registerListener(this); 
    //PokeGoHelper.startAECInfoFetch();
    dummyRoutine();
  }

  void dummyRoutine() {
    sleep(10000);
    AECInfoUpdated(dummyInfo(false, "", 0));
    sleep(2000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 1));
    sleep(5000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));    
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 2));    
    sleep(5000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 1));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "BLUE", 1));
    sleep(5000);
    AECInfoUpdated(dummyInfo(true, "BLUE", 0));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "", 0));
    sleep(5000);
    AECInfoUpdated(dummyInfo(false, "RED", 1));
    sleep(5000);
    AECInfoUpdated(dummyInfo(true, "RED", 1));
    sleep(15000);
    AECInfoUpdated(dummyInfo(false, "RED", 2));
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
    facade.setTeamColor(i.getTeamColor());
    facade.setInBattle(i.isInBattle());
    facade.setGymLevel(i.getGymLevel());
  }
}