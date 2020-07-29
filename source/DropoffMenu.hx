package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class DropoffMenu extends FlxObject
{
	var transparentBG:FlxSprite;
	var background:FlxSprite;
	
    var questionText:FlxText;
    var xButton:FlxButton;
	
	//Depositing
	var depositDeerCharacterDisplay:DeerDisplay;
	var depositLeftButton:FlxButton;
	var depositRightButton:FlxButton;
	var depositButton:FlxButton;
	
	var depositPage:Int;
	
	var depositDeerList:Array<Deer>;
	
	//Withdrawing
	var withdrawDeerCharacterDisplay:DeerDisplay;
	var withdrawLeftButton:FlxButton;
	var withdrawRightButton:FlxButton;
	var withdrawButton:FlxButton;
	
	var withdrawPage:Int;
	
	var withdrawDeerList:Array<Deer>;
	
	public function new(){
		super();
		
		updateDeerLists();
		
		depositPage = 0;
		withdrawPage = 0;

		transparentBG = new FlxSprite(0, 0);
		transparentBG.loadGraphic("assets/images/TransparentBG.png");
		transparentBG.screenCenter();
		FlxG.state.add(transparentBG);
		
        background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/ConfirmationBox.png");
		background.screenCenter();
		FlxG.state.add(background);

        setupTexts();
        setupButtons();
		setupDeerDisplays();
		
		updateArrowButtons();
		updateDeerDisplays();
		updateWithdrawDepositButtons();
	}
	
    public function close(){
        FlxG.state.remove(background);
        FlxG.state.remove(transparentBG);
        FlxG.state.remove(xButton);
		
		//Deposit
        FlxG.state.remove(depositLeftButton);
        FlxG.state.remove(depositRightButton);
        FlxG.state.remove(depositButton);
		
		FlxG.state.remove(depositDeerCharacterDisplay);
		depositDeerCharacterDisplay.destroyChildren();
		
		//Withdraw
        FlxG.state.remove(withdrawLeftButton);
        FlxG.state.remove(withdrawRightButton);
        FlxG.state.remove(withdrawButton);
		
		FlxG.state.remove(withdrawDeerCharacterDisplay);
		withdrawDeerCharacterDisplay.destroyChildren();
		
        FlxG.state.remove(questionText);

        GameObjects.instance.mainGameMenu.returnToMainScreen();
        FlxG.state.remove(this);
    }
	
	public function confirm(){
		close();
	}
	
	function setupDeerDisplays(){
		depositDeerCharacterDisplay = new DeerDisplay(depositDeerList[0]);
		depositDeerCharacterDisplay.moveDisplay(67, 240);
		FlxG.state.add(depositDeerCharacterDisplay);
		
		withdrawDeerCharacterDisplay = new DeerDisplay(depositDeerList[0]);
		withdrawDeerCharacterDisplay.moveDisplay(257, 240);
		FlxG.state.add(withdrawDeerCharacterDisplay);
	}

    function setupButtons(){
        xButton = new FlxButton(404, 116);
		xButton.loadGraphic("assets/images/XButton.png", true, 64, 64);
        xButton.scale.set(0.4,0.4);
        xButton.updateHitbox();
        xButton.onUp.callback = close.bind();
        FlxG.state.add(xButton);

		//Deposit buttons
        depositLeftButton = new FlxButton(80, 390);
		depositLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
		depositLeftButton.scale.set(0.5, 0.5);
        depositLeftButton.updateHitbox();
        FlxG.state.add(depositLeftButton);
		
        depositRightButton = new FlxButton(163, 390);
		depositRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
		depositRightButton.scale.set(0.5, 0.5);
        depositRightButton.updateHitbox();
        FlxG.state.add(depositRightButton);
		
		depositButton = new FlxButton(66, 420, "Drop off", depositDeer);
		depositButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		ButtonUtils.fixButtonText(depositButton, 18, 20);
		FlxG.state.add(depositButton);
		
		//Withdraw buttons
        withdrawLeftButton = new FlxButton(270, 390);
		withdrawLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
		withdrawLeftButton.scale.set(0.5, 0.5);
        withdrawLeftButton.updateHitbox();
        FlxG.state.add(withdrawLeftButton);
		
        withdrawRightButton = new FlxButton(353, 390);
		withdrawRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
		withdrawRightButton.scale.set(0.5, 0.5);
        withdrawRightButton.updateHitbox();
        FlxG.state.add(withdrawRightButton);
		
		withdrawButton = new FlxButton(256, 420, "Pick up", depositDeer);
		withdrawButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
		ButtonUtils.fixButtonText(withdrawButton, 18, 20);
		FlxG.state.add(withdrawButton);
    }

    function setupTexts(){
        questionText = new FlxText(0, 0, 360, "Underground City Shelter", 30);
        questionText.screenCenter();
        questionText.y = questionText.y - 140;
		questionText.color = 0xFF000000;
		questionText.alignment = "center";
        FlxG.state.add(questionText);
    }
	
	function depositDeer()
	{
		var deerToDeposit:Deer = depositDeerList[depositPage];
		
		deerToDeposit.fullyHeal();
		deerToDeposit.removeAllStatusEffects();
		GameVariables.instance.controlledDeer.remove(deerToDeposit);
		GameVariables.instance.undergroundCityDeer.push(deerToDeposit);
		
		updateDeerLists();
		
		if (depositPage >= depositDeerList.length && depositPage > 0)
		{
			depositPage--;
		}
		
		updateWithdrawDepositButtons();
		updateArrowButtons();
		updateDeerDisplays();
	}
	
	function withdrawDeer()
	{
		var deerToWithdraw:Deer = withdrawDeerList[withdrawPage];
		
		GameVariables.instance.undergroundCityDeer.remove(deerToWithdraw);
		GameVariables.instance.controlledDeer.push(deerToWithdraw);
		
		updateDeerLists();
		
		if (withdrawPage >= withdrawDeerList.length && withdrawPage > 0)
		{
			withdrawPage--;
		}
		
		updateWithdrawDepositButtons();
		updateArrowButtons();
		updateDeerDisplays();
	}
	
	function updateDeerLists()
	{
		depositDeerList = GameVariables.instance.getControlledDeer(false);
		withdrawDeerList = GameVariables.instance.getUndergroundCityDeer();
	}
	
	function updateWithdrawDepositButtons()
	{
		if (depositDeerList.length == 0)
		{
			depositButton.loadGraphic("assets/images/OctaButtonSkinnyStatic.png", false);
			depositButton.labelAlphas[1] = 0.6;
			ButtonUtils.fixButtonText(depositButton, 18, 0, 0, 0.6);
			depositButton.alpha = 0.6;
			depositButton.onUp.callback = null;
		}
		else
		{
			depositButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
			depositButton.labelAlphas[1] = 1;
			ButtonUtils.fixButtonText(depositButton, 18, 0);
			depositButton.alpha = 1;
			depositButton.onUp.callback = depositDeer.bind();
		}
		
		if (withdrawDeerList.length == 0)
		{
			withdrawButton.loadGraphic("assets/images/OctaButtonSkinnyStatic.png", false);
			withdrawButton.labelAlphas[1] = 0.6;
			ButtonUtils.fixButtonText(withdrawButton, 18, 0, 0, 0.6);
			withdrawButton.alpha = 0.6;
			withdrawButton.onUp.callback = null;
		}
		else
		{
			withdrawButton.loadGraphic("assets/images/OctaButtonSkinny.png", true, 160, 74);
			withdrawButton.labelAlphas[1] = 1;
			ButtonUtils.fixButtonText(withdrawButton, 18, 0);
			withdrawButton.alpha = 1;
			withdrawButton.onUp.callback = withdrawDeer.bind();
		}
	}
	
	function updateArrowButtons()
	{
		//Disposit buttons
		if(depositPage == 0){
			depositLeftButton.loadGraphic("assets/images/StaticLeftButton.png");
			depositLeftButton.alpha = 0.4;
			depositLeftButton.onUp.callback = null;
		}else{
			depositLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
			depositLeftButton.alpha = 1;
			depositLeftButton.onUp.callback = scrollDepositDeer.bind(-1);
		}
		
		if(depositPage >= depositDeerList.length - 1){
			depositRightButton.loadGraphic("assets/images/StaticRightButton.png");
			depositRightButton.alpha = 0.4;
			depositRightButton.onUp.callback = null;
		}else{
			depositRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
			depositRightButton.alpha = 1;
			depositRightButton.onUp.callback = scrollDepositDeer.bind(1);
		}
		
        depositLeftButton.updateHitbox();
        depositRightButton.updateHitbox();
		
		//Withdraw buttons
		if(withdrawPage == 0){
			withdrawLeftButton.loadGraphic("assets/images/StaticLeftButton.png");
			withdrawLeftButton.alpha = 0.4;
			withdrawLeftButton.onUp.callback = null;
		}else{
			withdrawLeftButton.loadGraphic("assets/images/LeftButton.png", true, 96, 60);
			withdrawLeftButton.alpha = 1;
			withdrawLeftButton.onUp.callback = scrollWithdrawDeer.bind(-1);
		}
		
		if(withdrawPage >= withdrawDeerList.length - 1){
			withdrawRightButton.loadGraphic("assets/images/StaticRightButton.png");
			withdrawRightButton.alpha = 0.4;
			withdrawRightButton.onUp.callback = null;
		}else{
			withdrawRightButton.loadGraphic("assets/images/RightButton.png", true, 96, 60);
			withdrawRightButton.alpha = 1;
			withdrawRightButton.onUp.callback = scrollWithdrawDeer.bind(1);
		}
		
        withdrawLeftButton.updateHitbox();
        withdrawRightButton.updateHitbox();
	}
	
	function scrollDepositDeer(amount:Int)
	{
		depositPage += amount;
		
		if(depositPage < 0){
			depositPage = 0;
		}else if (depositPage >= depositDeerList.length){
			depositPage = depositDeerList.length - 1;
		}
		
		if(depositDeerList.length > 0){
			depositDeerCharacterDisplay.updateDeer(depositDeerList[depositPage]);
		}
		
		updateArrowButtons();
	}
	
	function scrollWithdrawDeer(amount:Int)
	{
		withdrawPage += amount;
		
		if(withdrawPage < 0){
			withdrawPage = 0;
		}else if (withdrawPage >= withdrawDeerList.length){
			withdrawPage = withdrawDeerList.length - 1;
		}
		
		if(withdrawDeerList.length > 0){
			withdrawDeerCharacterDisplay.updateDeer(withdrawDeerList[withdrawPage]);
		}
		
		updateArrowButtons();
	}
	
	function updateDeerDisplays()
	{
		if(depositDeerList.length > 0){
			depositDeerCharacterDisplay.updateDeer(depositDeerList[depositPage]);
		}
		else
		{
			depositDeerCharacterDisplay.emptyDisplay();
		}
		
		if(withdrawDeerList.length > 0){
			withdrawDeerCharacterDisplay.updateDeer(withdrawDeerList[withdrawPage]);
		}
		else
		{
			withdrawDeerCharacterDisplay.emptyDisplay();
		}
	}
}