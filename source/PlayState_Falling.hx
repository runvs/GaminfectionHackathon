package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
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
	
	private var flakesBG : Flakes;
	
	private var hairs : FlxTypedGroup<Hair>;
	
	private var velocityY : Float = -30;
	
	private var spawnTimer :Float = 0;
	
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		backgroundSprite = new FlxSprite();
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height);
		backgroundSprite.color = FlxColor.fromRGB(30, 30, 30);
		add(backgroundSprite);
		
		
		// add stuff here
		
		flakesBG = new Flakes(FlxG.camera, 50, 30);
		add(flakesBG);
		bacteria = new Bacteria(400, 30);
		add(bacteria);
		
		
		hairs = new FlxTypedGroup<Hair>();
		//hairs.add(new Hair(true));
		//add(hairs);
		
		
		
		ending = false;
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 1;
		FlxTween.tween (overlay, { alpha : 0 }, 0.5);
		
		add(overlay);
		
		timer = 250;
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
		flakesBG.draw();
		hairs.draw();
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
		
		cleanUp();
		hairs.update(elapsed);
		spawnTimer -= elapsed;
		spawn();
		
	
		if (velocityY < 50)
		{
			velocityY += elapsed * (-20);
		}
		else if (velocityY < 70)
		{
			velocityY += elapsed * (-15);
		}
		else if (velocityY < GP.WorldMovementMax)
		{
			velocityY += elapsed * (-10);
		}
		else 
		{
			velocityY = GP.WorldMovementMax;
		}
		
		flakesBG._globalVelocityY = velocityY * 0.8;
		for (h in hairs)
		{
			h.velocity.y = velocityY;
		}
		
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
	
	function spawn() 
	{
		if (spawnTimer <= 0)
		{
			spawnTimer = FlxG.random.float(2, 5);
			var l : Bool = FlxG.random.bool();
			hairs.add(new Hair(l));
			if (l) trace ("left");
			else  trace ("right");
		}
	}
	
	function cleanUp() 
	{
		var l : FlxTypedGroup<Hair> = new FlxTypedGroup<Hair>();
		for ( s in hairs)
		{
			if (s.alive) l.add(s);
		}
		hairs = l;
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