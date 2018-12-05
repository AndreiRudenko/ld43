package processors;


import clay.Family;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.objects.Text;
import clay.objects.Sprite;
import clay.render.Layer;
import clay.math.Vector;
import clay.types.TextAlign;
import components.FPS;


class GameOverStateProcessor extends clay.Processor {


	var title:Text;
	var play_text:Text;
	var score_text:Text;
	var buzy:Bool = false;


    override function init() {
        

    }

    override function onenabled() {

		if(Game.score > Game.best_score) {
			Game.best_score = Game.score;
		}
		
		if(Game.max_speed > Game.best_max_speed) {
			Game.best_max_speed = Game.max_speed;
		}

    	title = new Text({
			text: 'GAME OVER', 
			font: Clay.resources.font('assets/edosz.ttf'),
			size: 64, 
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: Settings.main_color.clone(),
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Clay.screen.mid.x, Clay.screen.mid.y-212)
    	});

    	score_text = new Text({
			text: 'score: ${Std.int(Game.score)}
max speed: ${Std.int(Game.max_speed)}

best score: ${Std.int(Game.best_score)}
best max speed: ${Std.int(Game.best_max_speed)}', 
			font: Clay.resources.font('assets/edosz.ttf'),
			size: 32, 
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: Settings.main_color.clone(),
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Clay.screen.mid.x, Clay.screen.mid.y)
    	});

    	play_text = new Text({
			text: 'press any key to play again', 
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			font: Clay.resources.font('assets/edosz.ttf'),
			size: 24, 
			color: Settings.main_color.clone(),
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Clay.screen.mid.x, Game.height - 64)
    	});

    	Clay.motion.tween(play_text.scale).to({x: 1.1, y: 1.1}, 0.5)
    	// .ease(clay.tween.easing.Expo.easeIn)
    	.reflect()
    	.repeat();

    	buzy = true;
		Clay.timer.schedule(0.5,function() {
			buzy = false;
		});

		Game.particles.stop(true);

    }

	override function onkeyup(e) {

		if(buzy) {
			return;
		}

		buzy = true;

		Clay.timer.schedule(0.2,function() {
			Clay.processors.disable(processors.GameOverStateProcessor);
			Clay.processors.enable(processors.PlayStateProcessor);
			buzy = false;
		});


	}

    override function ondisabled() {

    	Clay.motion.stop(play_text.scale);
    	score_text.destroy();
    	title.destroy();
    	play_text.destroy();
	    
    }

	override function update(dt:Float) {

	}


}
