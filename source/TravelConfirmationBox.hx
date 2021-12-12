package;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxAxes;

class TravelConfirmationBox extends ConfirmationBox
{
	var locationName:String;
	var travelCost:Int;
	
	var locationSprite:FlxSprite;
	
    public function new(locationName:String, travelCost:Int, ?locked:Bool = false){
		this.locationName = locationName;
		this.travelCost = travelCost;
		
        super();
		
		var currentFood:Int = GameVariables.instance.currentFood;
		
		questionText.text = "Travelling here will\ncost " + travelCost + " food.";
		confirmButton.text = "Set out";
		cancelButton.text = "Stay put";
		
		if (currentFood < travelCost)
		{
			questionText.text += " You do not have enough.";
			
			locked = true;
		}
		
		if (locked)
		{
			cancelButton.screenCenter(FlxAxes.X);
			FlxG.state.remove(confirmButton);
		}
    }
	
	override public function close()
	{
		super.close();
		FlxG.state.remove(locationSprite);
	}
	
	override public function confirm(){
		var mainState:MainGame = cast(FlxG.state, MainGame);
		mainState.confirmMovement(locationName, travelCost);
		super.confirm();
	}
	
	override public function setupGraphics()
	{
		super.setupGraphics();
		
		locationSprite = new FlxSprite(0, 270);
		locationSprite.loadGraphic(GameVariables.getLocationSpriteByName(locationName), true, 190, 134);
		locationSprite.screenCenter(FlxAxes.X);
		FlxG.state.add(locationSprite);
	}
}