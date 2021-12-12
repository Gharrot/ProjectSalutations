package;

import flixel.ui.FlxButton;
import flixel.FlxG;

class LocationButton extends FlxButton
{
	var message:String;
	var locked:Bool = false;
	
	var locationName:String;
	var cost:Int;
	
	public function new(locationName:String, cost:Int, x:Int = 0, y:Int = 0) 
	{
		super(x, y);
		
		loadGraphic("assets/images/MapImages/LocationButton.png", true, 23, 23);
		updateHitbox();
		
		this.locationName = locationName;
		this.cost = cost;
		
		onUp.callback = showTravelConfirmation.bind();
	}
	
	public function lock(message:String)
	{
		setMessage(message);
		locked = true;
	}
	
	public function setMessage(message:String)
	{
		this.message = message;
	}
	
	public function showTravelConfirmation()
	{
		var mainGameState:MainGame = cast(FlxG.state, MainGame);
		var travelConfirmationBox:TravelConfirmationBox = mainGameState.locationMovement(locationName, cost, locked);
		
		if (message != null)
		{
			travelConfirmationBox.questionText.text = message;
		}
	}
	
}