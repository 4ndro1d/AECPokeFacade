class PogoHelper implements AECInfoListener{
  
  AECPokeFacade facade;
  
  public PogoHelper(AECPokeFacade s){
     facade = s;
     PokeGoHelper.registerListener(this); 
     PokeGoHelper.startAECInfoFetch();
  }
  
  @Override
  public void AECInfoUpdated(AECInfo i) {
    facade.setTeamColor(i.getTeamColor());
    facade.setInBattle(i.isInBattle());
    facade.setGymLevel(i.getGymLevel());
  }
 
}