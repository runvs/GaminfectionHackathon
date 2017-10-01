package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class Hair extends FlxSprite
{

	private var _left : Bool;
	
	public var touched : Bool = false;
	public var hairsound : FlxSound;
	public var inScreen : Bool = false;
	
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
		
		hairsound  = FlxG.sound.load(AssetPaths.hairsound__ogg, 0.125, true);
		var yPos : Float = FlxG.height + this.height * 2 + FlxG.random.float(0, 300);

		//hairsound.play();
		
		
		if (_left)
		{
			this.setPosition( -this.width * 3.0 / 4.0, yPos);
			var T : Float = FlxG.random.float(1.75, 2.5);
			var TS : Float = FlxG.random.float(0, 0.5);
			FlxTween.tween(this, { x: 0 }, T, { type:FlxTween.PINGPONG, startDelay: TS } );
			FlxTween.tween(hairsound, { volume: 0.25 }, T, { type:FlxTween.PINGPONG, startDelay: TS } );
			hairsound.pan = -0.75;
		}
		else
		{
			this.setPosition( FlxG.width - this.width + this.width * 3.0 / 4.0, yPos);
			var T : Float = FlxG.random.float(1.75, 2.5);
			var TS : Float = FlxG.random.float(0, 0.5);
			FlxTween.tween(this, { x: FlxG.width - this.width  }, T, { type:FlxTween.PINGPONG, startDelay: TS } );
			FlxTween.tween(hairsound, { volume: 0.25 }, T, { type:FlxTween.PINGPONG, startDelay: TS } );
			hairsound.pan = 0.75;
		}
		
		
		
	}
	
}