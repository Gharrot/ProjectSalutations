package;
import flixel.FlxSprite;
import statuses.DeerStatusEffect;
import statuses.BabyStatusEffect;
import haxe.display.Position.Location;
import locations.Location;
import flixel.math.FlxRandom;

class Deer{
    public var name:String;
    public var gender:String;
    public var player:Bool;

    public var str:Int;
	public var res:Int;
	public var dex:Int;
	public var int:Int;
	public var lck:Int;
	
	public var baseStr:Int;
	public var baseRes:Int;
	public var baseDex:Int;
	public var baseInt:Int;
	public var baseLck:Int;

	public var statusEffects:Array<statuses.DeerStatusEffect>;

    public var currentAction:String;
	public var actedThisRound:Bool;
	
	public var health:Int;
	public var maxHealth:Int;
	
	public var pregnant:Bool;
	public var baby:Bool;

    public function new(name:String, gender:String, str:Int, res:Int, dex:Int, int:Int, lck:Int, player:Bool = false) {
        this.name = name;
        this.gender = gender;
        this.player = player;
		
        this.str = str;      
        this.res = res;      
        this.dex = dex;      
        this.int = int;      
        this.lck = lck;
		
		this.baseStr = str;
		this.baseRes = res;
		this.baseDex = dex;
		this.baseInt = int;
		this.baseLck = lck;
		
		this.maxHealth = res * 2;
		if(maxHealth == 0){
			maxHealth = 1;
		}
		this.health = maxHealth;
		
		statusEffects = new Array<DeerStatusEffect>();

        currentAction = "Exploring";
		
		pregnant = false;
		baby = false;
    }
	
	static public function getNewBlankDeer():Deer{
		var newDeer:Deer = new Deer("Pley Soulder", "Undetermined", 0, 0, 0, 0, 0);
        newDeer.currentAction = "Waiting";
		
		return newDeer;
    }
	
	public function getStatus():String{
		var status:String = "";
		
		if(health == maxHealth){
			status = "in perfect health";
		}else if (health <= 0){
			status = "continuing to rest";
		}else if (health <= 2){
			status = "still weak, but able to move";
		}else if (health <= 3){
			status = "a bit roughed up, but able to move";
		}else{
			status = "in decent condition";
		}
		
		return status;
	}
	
	public function getHealthStatus():String{
		var status:String = "";
		
		if(health == maxHealth){
			status = "Healthy";
		}else if (health <= 0){
			status = "Injured";
		}else if (health <= 2){
			status = "Weak";
		}else if (health <= 3){
			status = "Fair";
		}else{
			status = "Decent";
		}
		
		return status;
	}
	
	public function getHealthSpriteString():String{
		var spriteString:String = "";
		
		if(health == maxHealth){
			spriteString = "assets/images/DeerTileSprites/HealthMarkerTransparent.png";
		}else if (health <= 0){
			spriteString = "assets/images/DeerTileSprites/HealthMarkerRed.png";
		}else if (health <= 2){
			spriteString = "assets/images/DeerTileSprites/HealthMarkerOrange.png";
		}else if (health <= 3){
			spriteString = "assets/images/DeerTileSprites/HealthMarkerYellow.png";
		}else{
			spriteString = "assets/images/DeerTileSprites/HealthMarkerYellowGreen.png";
		}
		
		return spriteString;
	}
	
	public function getStatusIcons():Array<FlxSprite>{
		var statusIcons:Array<FlxSprite> = new Array<FlxSprite>();
		
		if (checkForStatusByName("Carrying Planks"))
		{
			statusIcons.push(new FlxSprite(0, 0, "assets/images/DeerTileSprites/Planks.png"));
		}
		
		if (checkForStatusByName("Carrying Ropes"))
		{
			statusIcons.push(new FlxSprite(0, 0, "assets/images/DeerTileSprites/Ropes.png"));
		}
		
		return statusIcons;
	}
	
	public function isAvailable():Bool{
		if(health <= 0){
			return false;
		}else if(pregnant){
			return false;
		}
		
		return true;
	}
	
	public function heal(amount:Int){
		health += amount;
		if(health > maxHealth){
			health = maxHealth;
		}
	}
	
	public function fullyHeal(){
		health = maxHealth;
	}
	
	public function takeDamage(amount:Int, canReachNegativeHealth:Bool = false){
		if (!canReachNegativeHealth && health <= 0)
		{
			return;
		}
		
		health -= amount;
		if (health <= 0){
			if(!canReachNegativeHealth){
				health = 0;
			}
			currentAction = "Resting";
		}
	}
	
	public function becomeABaby(){
		addStatusEffect(new BabyStatusEffect("Baby", 3, -1 * str, -1 * res, -1 * dex, -1 * int, -1 * lck));
		baby = true;
	}
	
	public function addStatusEffect(statusEffect:DeerStatusEffect, stackable:Bool = false){
		if (!stackable)
		{
			var originalLength:Int = statusEffects.length;
			for (i in 1...(originalLength + 1)) {
				var currentStatus:DeerStatusEffect = statusEffects[originalLength - i];
				
				if (currentStatus.statusName == statusEffect.statusName)
				{
					statusEffects.remove(currentStatus);
				}
			}
		}
		
		statusEffects.push(statusEffect);
		updateStats();
	}
	
	public function removeAllStatusEffects(){
		var originalLength:Int = statusEffects.length;
		for (i in 1...(originalLength + 1)) {
			var currentStatus:DeerStatusEffect = statusEffects[originalLength - i];
			statusEffects.remove(currentStatus);
		}
		
		updateStats();
	}
	
	public function updateStatuses(){
		var originalLength:Int = statusEffects.length;
		for (i in 1...(originalLength + 1)) {
			var currentStatus:DeerStatusEffect = statusEffects[originalLength - i];
			
			currentStatus.progressStatusEffect();
			
			if(currentStatus.duration <= 0){
				statusEffects.remove(currentStatus);
				if(currentStatus.statusName == "Baby"){
					GameVariables.instance.addDeer(this);
					GameVariables.instance.babyDeer.remove(this);
					currentAction = "Foraging";
				}
			}
		}
		
		updateStats();
	}
	
	public function updateStats(){
		str = baseStr;
		res = baseRes;
		dex = baseDex;
		int = baseInt;
		lck = baseLck;
		
		for(i in 0...statusEffects.length){
			str += statusEffects[i].strChange;
			res += statusEffects[i].resChange;
			dex += statusEffects[i].dexChange;
			int += statusEffects[i].intChange;
			lck += statusEffects[i].lckChange;
		}
		
		str = cast(Math.max(0, str), Int);
		res = cast(Math.max(0, res), Int);
		dex = cast(Math.max(0, dex), Int);
		int = cast(Math.max(0, int), Int);
		lck = cast(Math.max(0, lck), Int);
	}
	
	//Returns a hint about the deer's stats
	public function getGlimmer(?resultNames:Array<String>):String{
		var result:String = "(insert glimmer here)";
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		
		if (resultNames == null)
		{
			resultNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		}
		
		var randomizer:FlxRandom = new FlxRandom();
		randomizer.shuffle(statNames);
		
		var maxSkillName:String = "Nothing";
		var maxSkillValue = 0;
		
		for(i in 0...statNames.length){
			if(getStatByName(statNames[i]) > maxSkillValue){
				maxSkillName = statNames[i];
				maxSkillValue = getStatByName(statNames[i]);
			}
		} 
		
		if(maxSkillName == "Strength"){
			result = resultNames[0];
		}else if(maxSkillName == "Resilience"){
			result = resultNames[1];
		}else if(maxSkillName == "Dexterity"){
			result = resultNames[2];
		}else if(maxSkillName == "Intellect"){
			result = resultNames[3];
		}else if(maxSkillName == "Fortune"){
			result = resultNames[4];
		}
		
		return result;
	}
	
	public function modifyStatByName(statName:String, amount:Int = 1, ?baseStats:Bool = true){
		if(statName == "Strength"){
			str += amount;
			if(baseStats){
				baseStr += amount;
			}
		}else if(statName == "Resilience"){
			res += amount;
			if(baseStats){
				baseRes += amount;
			}
		}else if(statName == "Dexterity"){
			dex += amount;
			if(baseStats){
				baseDex += amount;
			}
		}else if(statName == "Intellect"){
			int += amount;
			if(baseStats){
				baseInt += amount;
			}
		}else if(statName == "Fortune"){
			lck += amount;
			if(baseStats){
				baseLck += amount;
			}
		}
	}
	
	public function getStatByName(statName:String):Int{
		if(statName == "Strength"){
			return str;
		}else if(statName == "Resilience"){
			return res;
		}else if(statName == "Dexterity"){
			return dex;
		}else if(statName == "Intellect"){
			return int;
		}else if(statName == "Fortune"){
			return lck;
		}
		
		return -1;
	}
	
	public function getStatTotal():Int{
		return this.str + this.res + this.dex + this.int + this.lck;
	}
	
	public function getStatsOverZero(?shuffle:Bool = true):Array<String>{
		var statNames = new Array<String>();
		
		if(str > 0){
			statNames.push("Strength");
		}
		if(res > 0){
			statNames.push("Resilience");
		}
		if(dex > 0){
			statNames.push("Dexterity");
		}
		if(int > 0){
			statNames.push("Intellect");
		}
		if(lck > 0){
			statNames.push("Fortune");
		}
		
		if(shuffle){
			var randomizer:FlxRandom = new FlxRandom();
			randomizer.shuffle(statNames);
		}
		
		return statNames;
	}
	
	public function getName(){
		return name;
	}
	
	static public function buildADeer(totalStatPoints:Int, ?maxStatValue:Int = -1, ?minStatValue:Int = 0, ?distributions:Array<Array<Int>>, ?shuffleDistributions:Bool = true):Deer{
		var randomizer:FlxRandom = new FlxRandom();
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		
		if (shuffleDistributions)
		{
			randomizer.shuffle(statNames);
		}
		
		if(distributions == null){
			distributions = [[26, 49, 69, 88, 100]];
		}
		
		var chosenDistribution:Array<Int> = distributions[randomizer.int(0, distributions.length - 1)];
		
		var newDeer:Deer = getNewBlankDeer();
		var statsGiven:Int = 0;
		
		//give base stats
		for (i in 0...minStatValue)
		{
			for (j in 0...statNames.length) 
			{
				newDeer.modifyStatByName(statNames[j]);
				statsGiven++;
			}
		}
		
		//give the other stats
		while (statsGiven < totalStatPoints) {
			var statRoll:Int = randomizer.int(0, 100);
			statsGiven++;
			
			for (i in 0...chosenDistribution.length) 
			{
				if (statRoll <= chosenDistribution[i]) 
				{
					if (maxStatValue == -1 || newDeer.getStatByName(statNames[i]) < maxStatValue)
					{
						newDeer.modifyStatByName(statNames[i]);
					}
					else
					{
						statsGiven--;
					}
					break;
				}
			}
		}
		
		newDeer.maxHealth = newDeer.res * 2;
		if(newDeer.maxHealth == 0){
			newDeer.maxHealth = 1;
		}
		newDeer.health = newDeer.maxHealth;
			
		if(randomizer.bool()){
			newDeer.gender = "Female";
		}else{
			newDeer.gender = "Male";
		}
		
		newDeer.name = NameGenerator.getRandomName();
		
		return newDeer;
	}
	
	static public function generateBabyDeer(motherDeer:Deer, fatherDeer:Deer):Deer{
		var randomizer:FlxRandom = new FlxRandom();
		var statNames = ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune"];
		randomizer.shuffle(statNames);
		
		var newDeer:Deer = getNewBlankDeer();
		
		var mothersInfluence:Int = randomizer.int(2, 3);
		
		//Inheriting mother's stats
		for (i in 0...mothersInfluence) {
			newDeer.modifyStatByName(statNames[i], motherDeer.getStatByName(statNames[i]));
		}
		
		//Inheriting father's stats
		for (i in mothersInfluence...5) {
			newDeer.modifyStatByName(statNames[i], fatherDeer.getStatByName(statNames[i]));
		}
		
		//shuffling a bit
		var shuffles:Int = randomizer.int(1, 4);
		
		for (i in 0...shuffles) {
			var statToDecrease:String = statNames[randomizer.int(0, statNames.length)];
			if(newDeer.getStatByName(statToDecrease) > 0){
				newDeer.modifyStatByName(statToDecrease, -1);
				newDeer.modifyStatByName(statNames[randomizer.int(0, statNames.length)], 1);
			}
		}
		
		//Balance out the stats if they have more or less than their parents
		var parentsTotalStats = motherDeer.getStatTotal() + fatherDeer.getStatTotal();
		var statDifference:Int = newDeer.getStatTotal() - Math.floor(parentsTotalStats / 2);
		
		var statChanges:Int = cast(Math.abs(statDifference), Int);
		
		if(statDifference > 0){
			var statsOverZero:Array<String> = newDeer.getStatsOverZero();
			while(statChanges > 0 && statsOverZero.length > 0){
				newDeer.modifyStatByName(statsOverZero[randomizer.int(0, statsOverZero.length)], -1);
				
				statsOverZero = newDeer.getStatsOverZero();
				statChanges--;
			}
		}
		else if (statDifference < 0)
		{
			for(i in 0...statChanges){
				newDeer.modifyStatByName(statNames[randomizer.int(0, statNames.length)], 1);
			}
		}
		
		newDeer.maxHealth = newDeer.res * 2;
		if(newDeer.maxHealth == 0){
			newDeer.maxHealth = 1;
		}
		newDeer.health = newDeer.maxHealth;
			
		if(randomizer.bool()){
			newDeer.gender = "Female";
		}else{
			newDeer.gender = "Male";
		}
		
		newDeer.name = NameGenerator.getRandomName();
		
		newDeer.becomeABaby();
		
		return newDeer;
	}
	
	public function checkForStatusByName(name:String):Bool
	{
		for (i in 0...statusEffects.length)
		{
			if (statusEffects[i].statusName == name)
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function removeStatusByName(name:String)
	{
		var i:Int = statusEffects.length - 1;
		
		while (i >= 0)
		{
			if (statusEffects[i].statusName == name)
			{
				statusEffects.remove(statusEffects[i]);
			}
			
			i--;
		}
	}
}