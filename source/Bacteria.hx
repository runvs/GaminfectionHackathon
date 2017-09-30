package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Bacteria extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(24, 24, FlxColor.WHITE);
		this.drag.set(GP.BaceteriaMoveDrag, GP.BaceteriaMoveDrag);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		this.acceleration.set();
		DoMovement();
		
		
		
		ClampPosition();
		
		
	}
	
	function ClampPosition() 
	{
		if (x < GP.WorldBounds)
		{
			x = GP.WorldBounds; 
			this.velocity.x = 0;
			this.acceleration.x = 0;
		}
		if (x > FlxG.width - GP.WorldBounds - this.width)
		{
			x = FlxG.width - GP.WorldBounds - this.width;
			this.velocity.x = 0;
			this.acceleration.x = 0;
		}
		
		if (y < GP.WorldBounds)
		{
			y = GP.WorldBounds;
			this.velocity.y = 0;
			this.acceleration.y = 0;
		}
		if (y > FlxG.height - GP.WorldBounds - this.height)
		{
			y = FlxG.height - GP.WorldBounds - this.height;
			this.velocity.y = 0;
			this.acceleration.y = 0;
		}
	}
	
	function DoMovement() 
	{
		this.acceleration.x = MyInput.xVal * GP.BacteriaMoveStrength;
		this.acceleration.y = MyInput.yVal * GP.BacteriaMoveStrength;
	}
	
}