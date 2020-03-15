package;
import flixel.ui.FlxButton;

class ButtonUtils
{
	static public function fixButtonText(button:FlxButton, textSize:Int = 22, yLabelOffset:Int = 10, xLabelOffset:Int = 0, alphas:Float = 1) {
        button.label.size = textSize;
        button.label.alignment = "center";
		button.label.color = 0xFF000000;
        for(offsets in button.labelOffsets){
            offsets.x += xLabelOffset;
            offsets.y += yLabelOffset;
        }
		
		button.label.alpha = alphas;
		button.labelAlphas[0] = alphas;
		button.labelAlphas[1] = alphas;
		button.labelAlphas[2] = alphas;
        button.updateHitbox();
	}
	
	static public function setAlphas(button:FlxButton, alphas:Float = 1) {
		button.label.alpha = alphas;
		button.labelAlphas[0] = alphas;
		button.labelAlphas[1] = alphas;
		button.labelAlphas[2] = alphas;
	}
	
}