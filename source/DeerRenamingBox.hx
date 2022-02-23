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
	var boxTitle:FlxText;
	
	var transparentBG:FlxSprite;
	var background:FlxSprite;
	
	var nameBox:FlxInputText;
	
	var deerCharacterSprite:DeerTile;
	
	var deer:Deer;
	var actionScreen:DeerActionScreen;

    var confirmButton:FlxButton;
    var cancelButton:FlxButton;
    var clearButton:FlxButton;
	
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
		nameBox.y += 40;
		FlxG.state.add(nameBox);
		
        boxTitle = new FlxText(0, 0, 360, "Deer Renaming", 30);
        boxTitle.screenCenter();
        boxTitle.y = boxTitle.y - 175;
		boxTitle.color = 0xFF000000;
		boxTitle.alignment = "center";
        FlxG.state.add(boxTitle);

        setupButtons();
		
        deerCharacterSprite = new DeerTile(deer);
        deerCharacterSprite.moveDisplay(145, 180);
		FlxG.state.add(deerCharacterSprite);
	}
	
	function clearNameText()
	{
		nameBox.text = "";
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		while(nameBox.text.length >= 11){
			nameBox.text = nameBox.text.substring(0, nameBox.text.length - 1);
			nameBox.caretIndex = nameBox.text.length;
		}
		
		deerCharacterSprite.nameText.text = nameBox.text;
	}
	
    public function close(showActionScreen:Bool = true){
        FlxG.state.remove(boxTitle);
        FlxG.state.remove(clearButton);
		
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
		
        FlxG.state.remove(confirmButton);
        FlxG.state.remove(cancelButton);
		
        FlxG.state.remove(nameBox);
		
        FlxG.state.remove(deerCharacterSprite);
		deerCharacterSprite.destroyChildren();
		
		actionScreen.renaming = false;
		if (showActionScreen)
		{
			actionScreen.show();
		}
        FlxG.state.remove(this);
    }
	
	public function confirm(){
		close();
		deer.name = nameBox.text;
        actionScreen.updateName();
	}

    public function setupButtons(){
        confirmButton = new FlxButton(200, 455, "Confirm");
		confirmButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		ButtonUtils.fixButtonText(confirmButton, 14, 24, 1);
		confirmButton.screenCenter();
		confirmButton.x -= 80;
		confirmButton.y = 435;
		confirmButton.onUp.callback = confirm.bind();
        FlxG.state.add(confirmButton);
		confirmButton.updateHitbox();
		
        cancelButton = new FlxButton(280, 455, "Cancel");
		cancelButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		ButtonUtils.fixButtonText(cancelButton, 14, 24, 1);
		cancelButton.screenCenter();
		cancelButton.x += 80;
		cancelButton.y = 435;
		cancelButton.onUp.callback = close.bind();
		cancelButton.label.color = 0xFF000000;
        FlxG.state.add(cancelButton);
		cancelButton.updateHitbox();
		
        clearButton = new FlxButton(280, 460, "Clear");
		clearButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		clearButton.scale.set(0.6, 0.6);
		ButtonUtils.fixButtonText(clearButton, 12, 10, -31);
		clearButton.screenCenter();
		clearButton.y = 375;
		clearButton.onUp.callback = clearNameText.bind();
		clearButton.label.color = 0xFF000000;
        FlxG.state.add(clearButton);
		clearButton.updateHitbox();
    }
}