package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import locations.Location;

class Tutorial extends FlxState
{
	var textBG:FlxSprite;
	
	var title:FlxText;
	var text1:FlxText;
	var text2:FlxText;
	var text3:FlxText;
	var text4:FlxText;
	var text5:FlxText;
	
	var nextButton:FlxButton;
	var backButton:FlxButton;
	var beginButton:FlxButton;

	override public function create():Void
	{
		FlxG.camera.fade(0xFFD8F6F3, 0.5, true);
		super.create();
		this.bgColor = 0xFFD8F6F3;
		
		textBG = new FlxSprite(0, 0, "assets/images/tutorialBG.png");
		add(textBG);
		textBG.screenCenter();
		
		title = new flixel.text.FlxText(50, 0, 0, "How to Play", 32);
		title.color = 0xFF000000;
		title.alignment = FlxTextAlign.CENTER;
		
		text1 = new flixel.text.FlxText(50, 0, 360, "Each day you'll choose an action for each of your deer and then set out.", 18);
		text1.color = 0xFF000000;
		text1.alignment = FlxTextAlign.CENTER;
		
		text2 = new flixel.text.FlxText(50, 0, 360, "You can either click on a deer and select an action in their menu, or hover over a deer and press the corresponding key.", 18);
		text2.color = 0xFF000000;
		text2.alignment = FlxTextAlign.CENTER;
		
		text3 = new flixel.text.FlxText(50, 0, 0, "E - Explore\nF - Forage\nH - Hunt\nD - Defend\nR - Rest", 22);
		text3.color = 0xFF000000;
		text3.alignment = FlxTextAlign.CENTER;
		
		text4 = new flixel.text.FlxText(50, 0, 360, "There's a lot more to learn, including what your true goal is, but I'll leave the rest up to you to discover.", 18);
		text4.color = 0xFF000000;
		text4.alignment = FlxTextAlign.CENTER;
		
		text5 = new flixel.text.FlxText(50, 0, 360, "Good luck!", 26);
		text5.color = 0xFF000000;
		text5.alignment = FlxTextAlign.CENTER;
		
		add(title);
		title.screenCenter();
		title.y = 70;
		
		add(text1);
		text1.screenCenter();
		text1.y = 130;
		
		add(text2);
		text2.screenCenter();
		text2.y = 220;
		
		add(text3);
		text3.screenCenter();
		text3.y = 340;
		
		add(text4);
		text4.screenCenter();
		text4.y = 230;
		
		add(text5);
		text5.screenCenter();
		text5.y = 400;
		
		beginButton = new FlxButton(370, 500, "Start", startGame);
		beginButton.loadGraphic("assets/images/OctaButton.png", true, 160, 74);
		ButtonUtils.fixButtonText(beginButton, 20, 19, 2);
		beginButton.screenCenter(FlxAxes.X);
		beginButton.x += 80;
		add(beginButton);
		
		nextButton = new FlxButton(250, 500, "Next", showPage2);
		nextButton.loadGraphic("assets/images/OctaButton.png", true, 160, 74);
		ButtonUtils.fixButtonText(nextButton, 20, 19, 2);
		nextButton.screenCenter(FlxAxes.X);
		add(nextButton);
		
		backButton = new FlxButton(370, 500, "Back", showPage1);
		backButton.loadGraphic("assets/images/OctaButton.png", true, 160, 74);
		ButtonUtils.fixButtonText(backButton, 20, 19, 2);
		backButton.screenCenter(FlxAxes.X);
		backButton.x -= 80;
		add(backButton);
		
		showPage1();
	}
	
	private function showPage1()
	{
		text1.visible = true;
		text2.visible = true;
		text3.visible = true;
		
		text4.visible = false;
		text5.visible = false;
		
		nextButton.visible = true;
		
		backButton.visible = false;
		beginButton.visible = false;
	}
	
	private function showPage2()
	{
		text1.visible = false;
		text2.visible = false;
		text3.visible = false;
		
		text4.visible = true;
		text5.visible = true;
		
		nextButton.visible = false;
		
		backButton.visible = true;
		beginButton.visible = true;
	}
	
	private function startGame()
	{
		FlxG.switchState(new CharacterCreation());
	}
}
