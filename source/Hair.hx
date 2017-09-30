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
	
	public function new(Left:Bool) 
	{
		super();
		
		this.makeGraphic(64, 16, FlxColor.RED);
		this.scale.set(2, 2);
		_left = Left;
		this.velocity.set(0, -20);
		acceleration.set(0, -20);
		maxVelocity.set(0, 110);
		this.updateHitbox();
		
		if (_left)
		{
			this.setPosition( -96, FlxG.height + this.height * 2);
			FlxTween.tween(this, { x: 0 }, 2, { type:FlxTween.PINGPONG, startDelay: FlxG.random.float(0,2) } );
		}
		else
		{
			this.setPosition( FlxG.width - this.width + 96, FlxG.height + this.height * 2);
			FlxTween.tween(this, { x: FlxG.width - this.width  }, 2, { type:FlxTween.PINGPONG, startDelay: FlxG.random.float(0,2) } );
		}
		
	}
	
}