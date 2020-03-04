package;
import flixel.FlxState;
import flixel.FlxG;

class TravelConfirmationBox extends ConfirmationBox{
	var locationName:String;
	var travelCost:Int;
	
    public function new(locationName:String, travelCost:Int){
        super();
		
		this.locationName = locationName;
		this.travelCost = travelCost;
		
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
	
	override public function confirm(){
		var mainState:MainGame = cast(FlxG.state, MainGame);
		mainState.confirmMovement(locationName, travelCost);
		super.confirm();
	}
	
}