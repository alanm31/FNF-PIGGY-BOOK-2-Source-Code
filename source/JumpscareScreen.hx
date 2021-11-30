package;

// for game shutdown lololololololol
import flash.system.System;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class JumpscareScreen extends MusicBeatState
{
    var tioJumpscare:FlxSprite;
    var staticAnim:FlxSprite;

    override function create()
    {
        FlxG.sound.play(Paths.sound('jumpscare', 'piggy'), 1, true);

        tioJumpscare = new FlxSprite().loadGraphic(Paths.image('secret/tioJumpscare', 'piggy'));
        tioJumpscare.antialiasing = true;
        tioJumpscare.updateHitbox();
        add(tioJumpscare);
    
        staticAnim = new FlxSprite(-1350, -70);
        staticAnim.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
        staticAnim.animation.addByPrefix('idle', "static", 24);
        staticAnim.animation.play('idle', true);
        staticAnim.scale.set(1.2, 1.2);
        staticAnim.alpha = 0.25;
        staticAnim.antialiasing = true;
        staticAnim.updateHitbox();
        add(staticAnim);    

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            shutdownGame();
        });   
    }

   	function shutdownGame()
	{
        System.exit(0);
	}
}