package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxAxes;
import flixel.addons.ui.FlxInputText;

class DeerRenamingBox extends FlxObject
{
	var transparentBG:FlxSprite;
	var background:FlxSprite;
	
	var nameBox:FlxInputText;
	
	var deer:Deer;
	var actionScreen:DeerActionScreen;

    var confirmButton:FlxButton;
    var cancelButton:FlxButton;
	
	public function new(deer:Deer, actionScreen:DeerActionScreen){
		super();
		
		this.deer = deer;
		this.actionScreen = actionScreen;

		transparentBG = new FlxSprite(0, 0);
		transparentBG.loadGraphic("assets/images/TransparentBG.png");
		transparentBG.screenCenter();
		FlxG.state.add(transparentBG);
		
        background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/ConfirmationBox.png");
		background.screenCenter();
		FlxG.state.add(background);
		
		nameBox = new FlxInputText(0, 0, 154, this.deer.name, 16);
		nameBox.screenCenter();
		FlxG.state.add(nameBox);

        setupButtons();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		while(nameBox.text.length >= 11){
			nameBox.text = nameBox.text.substring(0, nameBox.text.length - 1);
			nameBox.caretIndex = nameBox.text.length;
		}
	}
	
    public function close(){
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
		
        FlxG.state.remove(confirmButton);
        FlxG.state.remove(cancelButton);
		
        FlxG.state.remove(nameBox);

        actionScreen.show();
        FlxG.state.remove(this);
    }
	
	public function confirm(){
		close();
		deer.name = nameBox.text;
        actionScreen.updateName();
	}

    public function setupButtons(){
        confirmButton = new FlxButton(200, 460, "Confirm");
		confirmButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		ButtonUtils.fixButtonText(confirmButton, 14, 24, 1);
		confirmButton.screenCenter();
		confirmButton.x -= 80;
		confirmButton.y = 410;
		confirmButton.onUp.callback = confirm.bind();
        FlxG.state.add(confirmButton);
		
        cancelButton = new FlxButton(280, 460, "Cancel");
		cancelButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		ButtonUtils.fixButtonText(cancelButton, 14, 24, 1);
		cancelButton.screenCenter();
		cancelButton.x += 80;
		cancelButton.y = 410;
		cancelButton.onUp.callback = close.bind();
		cancelButton.label.color = 0xFF000000;
        FlxG.state.add(cancelButton);
    }
}