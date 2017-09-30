package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class PlayStateJump extends FlxState
{

	private var soldier : FlxSprite;
	private var overlay : FlxSprite;
	
	override public function create() 
	{
		super.create();
		
		var bg : FlxSprite = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(30, 30, 30));
		add(bg);
		
		var platform : FlxSprite = new FlxSprite(0, 300 + 24 *2 + 12);
		platform.makeGraphic(300, 300, FlxColor.BLACK);
		add(platform);
		
		
		soldier = new FlxSprite(200, 300);
		soldier.loadGraphic(AssetPaths.Soldier__png, true, 24, 24);
		soldier.scale.set(4, 4);
		soldier.animation.add("run", [5, 6, 7, 8, 9], 12, true);
		soldier.animation.add("jump", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19,20, 21, 23, 24, 25, 26], 8);
		soldier.animation.add("fall", [ 26, 27, 28, 29, 30, 31, 32,33], 8);
		soldier.animation.play("run");
		add(soldier);
		
		soldier.velocity.set(20, 0);
		soldier.acceleration.set(25, 0);
		
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0;
		add(overlay);
		
		
		var t1 : FlxTimer = new FlxTimer();
		t1.start(1.5, function(t) { soldier.animation.play("jump"); } );
		
		var tacc : FlxTimer = new FlxTimer();
		tacc.start(1.75, function(t) 
		{ 
			soldier.acceleration.set(0, 60); 
			soldier.velocity.set(soldier.velocity.x, -75); 
			soldier.drag.set(10, 0); 
			
		} );
		
		var t2 : FlxTimer = new FlxTimer();
		t2.start(10.0 / 8.0 + 4.0 / 8.0 + 1.5, function (t) { soldier.animation.play("fall", true); } );
		
		
		var tend : FlxTimer = new FlxTimer();
		tend.start(7, function (t) 
		{
			FlxTween.tween(overlay, { alpha : 1 }, 0.5);
			
			var te2 : FlxTimer = new FlxTimer();
			te2.start(0.75, function (txx) { FlxG.switchState(new PlayState_Falling()); } );
		} );
		
	}
	
	
	
}