package;

import flixel.ui.FlxButton;
import flixel.FlxG;

class LocationButton extends FlxButton
{
	var lockedMessage:String = "";
	var locked:Bool = false;
	
	var locationName:String;
	var cost:Int;
	
	public function new(locationName:String, cost:Int) 
	{
		super();
		
		loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
		scale.set(3, 3);
		updateHitbox();
		
		this.locationName = locationName;
		this.cost = cost;
		
		onUp.callback = showTravelConfirmation.bind();
	}
	
	public function lock(message:String)
	{
		lockedMessage = message;
		locked = true;
	}
	
	public function showTravelConfirmation()
	{
		var mainGameState:MainGame = cast(FlxG.state, MainGame);
		var travelConfirmationBox:TravelConfirmationBox = mainGameState.locationMovement(locationName, cost, locked);
		
		if (locked)
		{
			travelConfirmationBox.questionText.text = lockedMessage;
		}
	}
	
}