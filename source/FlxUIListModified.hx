package;
import flixel.addons.ui.interfaces.IFlxUIButton;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.*;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;

class FlxUIListModified extends FlxUIGroup
{
	public static inline var STACK_HORIZONTAL:Int = 0;
	public static inline var STACK_VERTICAL:Int = 1;
	
	//The array index value of the first visible item in the list
	public var scrollIndex(default, set):Int = 0;
	public function set_scrollIndex(i:Int):Int {
		scrollIndex = i;
		refreshList();
		return i;
	}
	
	//Stack widgets horizontally or vertically?
	public var stacking(default, set):Int;
	public function set_stacking(Stacking:Int):Int {
		stacking = Stacking;
		refreshList();
		return Stacking;
	}
	
	//Spacing between widgets
	public var spacing(default, set):Float;
	public function set_spacing(Spacing:Float):Float {
		spacing = Spacing;
		refreshList();
		return Spacing;
	}
	
	public var prevButtonOffset:FlxPoint;
	public var nextButtonOffset:FlxPoint;
	
	public var prevButton:IFlxUIButton;
	public var nextButton:IFlxUIButton;
	
	public var moreString(default, set):String;
	public function set_moreString(str:String):String {
		moreString = str;
		refreshList();
		return moreString;
	}
	
	public var beforeString(default, set):String;
	public function set_beforeString(str:String):String {
		beforeString = str;
		refreshList();
		return beforeString;
	}
	
	public var amountPrevious(default, null):Int;
	public var amountNext(default, null):Int;
	
	/**
	 * Creates a scrollable list of widgets
	 * @param	X			X position of the list
	 * @param	Y			Y position of the list
	 * @param	Widgets	List of widgets themselves (optional)
	 * @param	W			Width of the invisible "canvas" available for putting widgets in before we have to scroll to see more
	 * @param	H			Height of the invisible "canvas" available for putting widgets in before we have to scroll to see more
	 * @param	MoreString	String that says "<X> more..." in your language (must use <X> variable!)
	 * @param	BeforeString	String that says "<X> more..." in your language (must use <X> variable!)
	 * @param	Stacking	How to stack the widgets? STACK_HORIZONTAL or STACK_VERTICAL
	 * @param	Spacing	Space between widgets 
	 * @param	PrevButtonOffset	Offset for Scroll - Button
	 * @param	NextButtonOffset	Offset for Scroll + Button
	 * @param	PrevButton	Button to Scroll -
	 * @param	NextButton	Button to Scroll +
	 */
	
	public function new(X:Float=0,Y:Float=0,?Widgets:Array<IFlxUIWidget>=null,W:Float=0,H:Float=0,?MoreString:String="",?BeforeString:String="",?Stacking:Int=STACK_VERTICAL,?Spacing:Float=5,PrevButtonOffset:FlxPoint=null,NextButtonOffset:FlxPoint=null,PrevButton:IFlxUIButton=null,NextButton:IFlxUIButton=null) 
	{
		_skipRefresh = true;
		super(X, Y);
		stacking = Stacking;
		spacing = Spacing;
		if(Widgets != null){
			for (widget in Widgets) {
				add(cast widget);
			}
		}
		
		prevButton = PrevButton;
		nextButton = NextButton;
		prevButtonOffset = PrevButtonOffset;
		nextButtonOffset = NextButtonOffset;
		moreString = MoreString;
		beforeString = BeforeString;
		
		if (prevButton == null) {
			var pButton = new FlxUIButton(0, 0, " ", onClick.bind( -1));
			if(stacking == STACK_HORIZONTAL){
				pButton.loadGraphicsUpOverDown(FlxUIAssets.IMG_BUTTON_ARROW_LEFT);
				pButton.label.width = pButton.label.fieldWidth = 100;
				pButton.label.text = getBeforeString(0);
				
				pButton.setAllLabelOffsets(pButton.width - pButton.label.width,
										   pButton.height + 2);
				pButton.label.alignment = "right";
			}else {
				pButton.loadGraphicsUpOverDown(FlxUIAssets.IMG_BUTTON_ARROW_UP);
				pButton.label.width = pButton.label.fieldWidth = 100;
				pButton.label.text = getBeforeString(0);
				pButton.setAllLabelOffsets(0, 0);
				pButton.setCenterLabelOffset(pButton.width+2, pButton.height - pButton.label.height);
				pButton.label.alignment = "left";
			}
			prevButton = pButton;
		}
		else
		{
			if (Std.is(prevButton, FlxUIButton))
			{
				var fuib:FlxUIButton = cast prevButton;
				fuib.onUp.callback = onClick.bind( -1);
			}
			if (Std.is(prevButton, FlxUISpriteButton))
			{
				var fusb:FlxUISpriteButton = cast prevButton;
				fusb.onUp.callback = onClick.bind( -1);
			}
		}
		
		if (nextButton == null) {
			var nButton = new FlxUIButton(0, 0, " ", onClick.bind( 1));
			if(stacking == STACK_HORIZONTAL){
				nButton.loadGraphicsUpOverDown(FlxUIAssets.IMG_BUTTON_ARROW_RIGHT);
				nButton.label.width = nButton.label.fieldWidth = 100;
				nButton.label.text = getMoreString(0);
				nButton.setAllLabelOffsets(0, nButton.height + 2);
				nButton.label.alignment = "left";
			}else {
				nButton.loadGraphicsUpOverDown(FlxUIAssets.IMG_BUTTON_ARROW_DOWN);
				nButton.label.width = nButton.label.fieldWidth = 100;
				nButton.label.text = getMoreString(0);
				nButton.setAllLabelOffsets(0, 0);
				nButton.setCenterLabelOffset(nButton.width+2, 0);
				nButton.label.alignment = "left";
			}
			nextButton = nButton;
		}
		else
		{
			if (Std.is(nextButton, FlxUIButton))
			{
				var fuib:FlxUIButton = cast nextButton;
				fuib.onUp.callback = onClick.bind( 1);
			}
			if (Std.is(nextButton, FlxUISpriteButton))
			{
				var fusb:FlxUISpriteButton = cast nextButton;
				fusb.onUp.callback = onClick.bind( 1);
			}
		}
		
		if (prevButtonOffset == null) {
			prevButtonOffset = FlxPoint.get(211, 287);
		}
		if (nextButtonOffset == null) {
			nextButtonOffset = FlxPoint.get(171, -15);
		}
		_skipRefresh = false;
		setSize(W, H);
	}
	
	public override function destroy():Void {
		prevButton = null;
		nextButton = null;
		prevButtonOffset.put();
		nextButtonOffset.put();
		prevButtonOffset = null;
		nextButtonOffset = null;
		super.destroy();
	}
	
	public override function setSize(W:Float, H:Float):Void {
		var flip:Bool = false;
		if (_skipRefresh == false) {
			_skipRefresh = true;
			flip = true;
		}
		width = W;
		height = H;
		if(flip){
			_skipRefresh = false;
		}
		refreshList();
	}
	
	public override function add(Object:FlxSprite):FlxSprite{
		super.add(Object);
		refreshList();
		return Object;
	}
	
	
	/****PRIVATE****/
	
	private function safeAdd(Object:FlxSprite):FlxSprite {
		return super.add(Object);
	}
	
	
	@:allow(flixel.addons.ui.FlxUIRadioGroup) private var _skipRefresh:Bool = false;
	
	private function getMoreString(i:Int):String {
		var newString:String = moreString;
		while (newString.indexOf("<X>") != -1) {
			newString = StringTools.replace(newString, "<X>", Std.string(i));
		}
		return newString;
	}
	
	private function getBeforeString(i:Int):String {
		var newString:String = beforeString;
		while (newString.indexOf("<X>") != -1) {
			newString = StringTools.replace(newString, "<X>", Std.string(i));
		}
		return newString;
	}
	
	private override function set_visible(Value:Bool):Bool
	{
		super.set_visible(Value);
		refreshList();
		return Value;
	}
	
	public function onClick(i:Int):Void {
		
		if (group.members.indexOf(cast prevButton) != -1) {
			remove(cast prevButton, true);
		}
		if (group.members.indexOf(cast nextButton) != -1) {
			remove(cast nextButton, true);
		}
		
		if(i > 0){
			var textsVisible:Int = 0;
			for (widget in group.members) {
				if(widget.visible == true){
					textsVisible++;
				}
			}
			scrollIndex += textsVisible;
		}
		else
		{
			var initialScrollIndex = scrollIndex;
			var textsVisible:Int = 0;
			
			var finished:Bool = false;
			while(!finished){
				scrollIndex--;
				
				refreshList();
				if (group.members.indexOf(cast prevButton) != -1) {
					remove(cast prevButton, true);
				}
				if (group.members.indexOf(cast nextButton) != -1) {
					remove(cast nextButton, true);
				}
				
				var textsVisible:Int = 0;
				for (widget in group.members) {
					if(widget.visible == true){
						textsVisible++;
					}
				}
				
				if(scrollIndex + textsVisible <= initialScrollIndex){
					finished = true;
				}
			} 
		}
		
		if(scrollIndex < 0){
			scrollIndex = 0;
		}
		refreshList();
	}
	
	@:allow(flixel.addons.ui.FlxUIRadioGroup) private function refreshList():Void {
		if (_skipRefresh) {
			return;
		}
		
		autoBounds = false;
		
		if (group.members.indexOf(cast prevButton) != -1) {
			remove(cast prevButton, true);
		}
		if (group.members.indexOf(cast nextButton) != -1) {
			remove(cast nextButton, true);
		}
		
		var XX:Float = 0;
		var YY:Float = 0;
		
		var i:Int = 0;
		var inBounds:Bool = true;
		
		if (stacking == STACK_HORIZONTAL) {
			prevButton.x = prevButtonOffset.x - prevButton.width - 2;
			prevButton.y = prevButtonOffset.y;
			nextButton.x = nextButtonOffset.x + width + 2;
			nextButton.y = nextButtonOffset.y;
		}else {
			prevButton.x = prevButtonOffset.x;
			prevButton.y = prevButtonOffset.y - prevButton.height - 2;
			nextButton.x = nextButtonOffset.x;
			nextButton.y = nextButtonOffset.y + height + 2;
		}
		
		prevButton.x = Std.int(prevButton.x);
		prevButton.y = Std.int(prevButton.y);
		nextButton.x = Std.int(nextButton.x);
		nextButton.y = Std.int(nextButton.y);
		
		var highestIndex:Int = 0;
		
		var outOfSpace:Bool = false;
		for (widget in group.members) {
			inBounds = false;
			
			if (!outOfSpace && i >= scrollIndex) 
			{
				if (stacking == STACK_VERTICAL) {
					inBounds = YY+widget.height <= height || height <= 0;
				}else {
					inBounds = XX+widget.width <= width || width <= 0;
				}
				
				if(!inBounds){
					outOfSpace = true;
				}
			}
			if (inBounds)
			{
				highestIndex = i;
				widget.visible = widget.active = true;
				widget.x = x + XX;
				widget.y = y + YY;
				if (stacking == STACK_VERTICAL)
				{
					YY += widget.height + spacing;
				}
				else
				{
					XX += widget.width + spacing;
				}
			}
			else 
			{
				widget.x = widget.y = 0;
				widget.visible = widget.active = false;
			}
			i++;
		}
		
		amountPrevious = scrollIndex;
		amountNext = group.members.length - (highestIndex+1);
		
		var fuibutton:FlxUIButton;
		
		if (amountPrevious > 0) {
			safeAdd(cast prevButton);
			if (Std.is(prevButton, FlxUIButton)) {
				fuibutton = cast prevButton;
				fuibutton.label.text = getBeforeString(amountPrevious);
			}
		}
		if (amountNext > 0) {
			safeAdd(cast nextButton);
			if(Std.is(nextButton, FlxUIButton)) {
				fuibutton = cast nextButton;
				fuibutton.label.text = getMoreString(amountNext);
			}
		}
	}
	
	private override function get_width():Float {
		return width;
	}
	
	private override function get_height():Float { 
		return height;
	}
	
	private override function set_width(W:Float):Float {
		width = W;
		refreshList();
		return W;
	}
	
	private override function set_height(H:Float):Float {
		height = H;
		refreshList();
		return H;
	}
	
}