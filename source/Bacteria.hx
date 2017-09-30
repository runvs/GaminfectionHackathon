package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Bacteria extends FlxSprite
{
	
	// encoded in phi, r;
	private var age : Float = 0;
	

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(24, 24, FlxColor.WHITE);
		this.drag.set(GP.BaceteriaMoveDrag, GP.BaceteriaMoveDrag);
		this.maxVelocity.set(GP.BacteriaMoveMaxSpeed, GP.BacteriaMoveMaxSpeed);

	}
	
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		age += elapsed;
		
		this.acceleration.set();
		DoMovement();
		AddrandomMovement(elapsed);
		
		
		ClampPosition();
		
		
		
		
	}
	
	function AddrandomMovement(elapsed : Float) 
	{
		
		var val : Float = Math.pow((Math.sin(age)*Math.sin(2*age)*Math.sin(0.66*age)),2);
	
		var rvx : Float = Math.cos(age) * GP.BacteriaRandomMoveStrength * val;
		var rvy : Float = Math.sin(age) * GP.BacteriaRandomMoveStrength * val;
		
		//velocity.set(velocity.x + rvx, velocity.y + rvy);
		this.setPosition(x + rvx * elapsed, y + rvy * elapsed);
	}
	
	function ClampPosition() 
	{
		if (x < GP.WorldPadding)
		{
			x = GP.WorldPadding; 
			this.velocity.x = 0;
			this.acceleration.x = 0;
		}
		if (x > FlxG.width - GP.WorldPadding - this.width)
		{
			x = FlxG.width - GP.WorldPadding - this.width;
			this.velocity.x = 0;
			this.acceleration.x = 0;
		}
		
		if (y < GP.WorldPadding)
		{
			y = GP.WorldPadding;
			this.velocity.y = 0;
			this.acceleration.y = 0;
		}
		if (y > FlxG.height - GP.WorldPadding - this.height)
		{
			y = FlxG.height - GP.WorldPadding - this.height;
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