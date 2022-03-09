package;

import flixel.FlxState;
import flixel.util.FlxAxes;

class SettingsMenu extends PauseMenu 
{
	public var makerState:PlayState;
	
	public function new() 
	{
		super();
	}
	
	override public function create()
	{
		super.create();
		
		title.text = "Settings";
		
		unpauseButton.y += 10;
		unpauseButton.label.text = "Main Menu";
		unpauseButton.label.size = 22;
        for(offsets in unpauseButton.labelOffsets){
            offsets.y += 2;
        }
		
		remove(infiniteFoodText);
		remove(infiniteFoodToggle);
		
		remove(saveAndQuitButton);
		
		tutorialButton.screenCenter(FlxAxes.X);
	}
	
	override public function returnToGame()
	{
		makerState.paused = false;
		close();
	}
	
}