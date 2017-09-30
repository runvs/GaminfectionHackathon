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
	
	private var ending : Bool = false;
	
	private var arrow : FlxSprite;
	private var vignette : Vignette;
	
	
	override public function create() 
	{
		super.create();
		
		var backgroundSprite : FlxSprite = new FlxSprite(0, 0);
		backgroundSprite.loadGraphic(AssetPaths.background__png, false, 200, 150);
		backgroundSprite.origin.set();
		backgroundSprite.scale.set(4, 4);
		add(backgroundSprite);
		
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
		
		arrow = new FlxSprite(600, 200 );
		arrow.loadGraphic(AssetPaths.sign__png, false, 24, 24);
		arrow.scale.set(4, 4);
		FlxTween.tween(arrow, { y : 225 } , 0.5, { type:FlxTween.LOOPING } );
		add(arrow);
		
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0;
		add(overlay);
		
		vignette = new Vignette(FlxG.camera, 0.35);
		add(vignette);
		
		
		var t1 : FlxTimer = new FlxTimer();
		t1.start(1.0, function(t) { soldier.animation.play("jump"); } );
		
		var tacc : FlxTimer = new FlxTimer();
		tacc.start(1.25, function(t) 
		{ 
			soldier.acceleration.set(0, 60); 
			soldier.velocity.set(soldier.velocity.x, -75); 
			soldier.drag.set(10, 0); 
			
		} );
		
		var t2 : FlxTimer = new FlxTimer();
		t2.start(10.0 / 8.0 + 4.0 / 8.0 + 1.0, function (t) { soldier.animation.play("fall", true); } );
		
		
		var tend : FlxTimer = new FlxTimer();
		tend.start(6.5, function (t) 
		{
			SwitchToNext();
		} );
		
	}
	
	function SwitchToNext() 
	{
		if (!ending)
		{
			ending = true;
			FlxTween.tween(overlay, { alpha : 1 }, 0.5);
				
			var te2 : FlxTimer = new FlxTimer();
			te2.start(0.75, function (txx) { FlxG.switchState(new PlayState_Falling()); } );
		}
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ANY)
		{
			SwitchToNext();
		}
	}
	
	
	
}