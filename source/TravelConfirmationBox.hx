package;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxAxes;

class TravelConfirmationBox extends ConfirmationBox{
	var locationName:String;
	var travelCost:Int;
	
	var locationSprite:FlxSprite;
	
    public function new(locationName:String, travelCost:Int){
		this.locationName = locationName;
		this.travelCost = travelCost;
		
        super();
		
		var currentFood:Int = GameVariables.instance.currentFood;
		
		questionText.text = "Travelling here will use up " + travelCost + " food.";
		
		confirmButton.text = "Set out";
		if (currentFood < travelCost) {
			questionText.text += " You do not have enough.";
			confirmButton.alpha = 0.7;
			confirmButton.onUp.callback = null;
		}
		
		cancelButton.text = "Stay put";
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
		
		locationSprite = new FlxSprite(0, 240);
		locationSprite.loadGraphic(GameVariables.getLocationSpriteByName(locationName), true, 190, 134);
		locationSprite.screenCenter(FlxAxes.X);
		FlxG.state.add(locationSprite);
	}
}