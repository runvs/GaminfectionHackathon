package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState_Falling extends FlxState
{
	
	public var backgroundSprite : FlxSprite;
	public var overlay : FlxSprite;
	private var ending : Bool;
	
	public var Score : Int = 0;
	private var scoreText : FlxText;
	
	private var timer : Float;
	private var timerText : FlxText;
	
	private var bacteria : Bacteria;
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		backgroundSprite = new FlxSprite();
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height);
		backgroundSprite.color = Palette.primary3();
		add(backgroundSprite);
		
		
		// add stuff here
		
		bacteria = new Bacteria(400, 30);
		add(bacteria);
		
		
		
		
		ending = false;
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0;
		add(overlay);
	
		
		timer = 25;
		timerText = new FlxText(10, 10, 0, "0", 16);
		timerText.color = Palette.primary0();
		add(timerText);
		scoreText = new FlxText(10, 32, 0, "0", 16);
		scoreText.color = Palette.primary0();
		add(scoreText);
	}
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function draw() : Void
	{
		//super.draw();
		backgroundSprite.draw();
		bacteria.draw();
		overlay.draw();
		
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		super.update(elapsed);
		MyInput.update();
		scoreText.text = "Score: " + Std.string(Score);
		
		var dec: Int = Std.int((timer * 10) % 10);
		if (dec < 0) dec *= -1;
		timerText.text = "Timer: " + Std.string(Std.int(timer) + "." + Std.string(dec));
		
		if (!ending)
		{
			
			if (timer <= 0)
			{
				EndGame();
			}
			
			var speed : Float = 108; 
			timer -= FlxG.elapsed;
			
		}
	}	
	

	
	function EndGame() 
	{
		if (!ending)
		{
			ending = true;
			
			MenuState.setNewScore(Score);
			
			FlxTween.tween(overlay, {alpha : 1.0}, 0.9);
			
			var t: FlxTimer = new FlxTimer();
			t.start(1,function(t:FlxTimer): Void { FlxG.switchState(new MenuState()); } );
		}
		
	}
	
}