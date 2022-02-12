package;

import flixel.FlxG;
import flixel.util.FlxColor;
/**
 * ...
 * @author Luc
 */
class TutorialSubState extends Tutorial 
{

	public function new() 
	{
		super();
	}
	
	public override function create()
	{
		super.create();
		beginButton.label.text = "Continue";
		beginButton.label.size = 18;
        for(offsets in beginButton.labelOffsets){
            offsets.y += 2;
        }
	}
	
	public override function update(elapsed)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justReleasedRight)
		{
			close();
		}
	}
	
	public override function startGame()
	{
		close();
	}
}