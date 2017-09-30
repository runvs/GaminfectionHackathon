package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Hair extends FlxSprite
{

	private var _left : Bool;
	
	public var touched : Bool = false;
	
	public function new(Left:Bool) 
	{
		super();
		
		//this.makeGraphic(512, 32, FlxColor.RED);
		this.loadGraphic(AssetPaths.hair__png, true, 96, 16);
		this.animation.add("idle", [for (x in 0...13) x], 8);
		this.animation.play("idle");
		
		_left = Left;
		this.scale.set(4, 4);
		this.velocity.set(0, -20);
		acceleration.set(0, -20);
		maxVelocity.set(0, 110);
		this.updateHitbox();
		
		if (_left)
		{
			this.setPosition( -this.width * 3.0/4.0, FlxG.height + this.height * 2 + FlxG.random.float(0,300));
			FlxTween.tween(this, { x: 0 }, FlxG.random.float(1.75, 2.5), { type:FlxTween.PINGPONG, startDelay: FlxG.random.float(0,0.5) } );
		}
		else
		{
			this.setPosition( FlxG.width - this.width + this.width * 3.0/4.0, FlxG.height + this.height * 2 + FlxG.random.float(0,300));
			FlxTween.tween(this, { x: FlxG.width - this.width  }, FlxG.random.float(1.75, 2.5), { type:FlxTween.PINGPONG, startDelay: FlxG.random.float(0,0.5) } );
		}
		
	}
	
}