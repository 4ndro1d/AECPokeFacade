# AECPokeFacade
Processing Example to control the facade of the Ars Electronica Center by using data about the gym in Pokemon Go.

#First setup
Please read carefully when trying to setup this sketch.

##UPDATE
Google Login is disabled for the moment and we are using PTC login. For this reason the refreshToken.txt file is not needed anymore.

##Option 1
Copy the refreshToken.txt file from the repository in the the root directory of your Processing folder. Run the sketch by opening the file AECPokeFacade.pde with the Processing IDE.

##Option 2
Run the sketch by opening the file AECPokeFacade.pde with the Processing IDE. Run the sketch and watch for console output. It is necessary to go to https://google.com/device, select a Pokemon Go connected Google account and enter the shown code. Note that the Pokemon Go account must have finished the ingame tutorial by catching a starter Pokemon. After authenticating the application will receive an OAuth token which will be saved in the file system, what makes it necessary for the Processing IDE to be within a writeable directory at the moment. Not under C:\Program Files\ !

## Note
The processing sketch requires the sound library processing.sound.*;
