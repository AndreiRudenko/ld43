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


class MenuStateProcessor extends clay.Processor {


	var balloon:Sprite;
	var thread:Sprite;
	var sheep:Sprite;
	var title:Text;
	var play_text:Text;
	var buzy:Bool = false;


    override function init() {
        

    }

    override function onenabled() {

    	balloon = new Sprite({
			texture: Clay.resources.texture('assets/balloon0.png'),
			size: new Vector(128, 128), 
			origin: new Vector(64, 64),
			color: Settings.main_color,
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Clay.screen.mid.x-4, Clay.screen.mid.y-66)
    	});

    	thread = new Sprite({
			texture: Clay.resources.texture('assets/thread.png'),
			size: new Vector(160, 8), 
			origin: new Vector(80, 2),
			color: Settings.main_color,
			layer: Clay.layers.get('ui'),
			rotation: 90,
    		pos: new Vector(Clay.screen.mid.x, Clay.screen.mid.y+64)
    	});

    	sheep = new Sprite({
			texture: Clay.resources.texture('assets/player.png'),
			size: new Vector(192, 192), 
			origin: new Vector(96, 96),
			color: Settings.main_color,
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Clay.screen.mid.x, Clay.screen.mid.y+192)
    	});

    	title = new Text({
			text: 'SHEEBALLOON', 
			font: Clay.resources.font('assets/edosz.ttf'),
			size: 64, 
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: Settings.main_color.clone(),
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Clay.screen.mid.x, Clay.screen.mid.y-212)
    	});

    	play_text = new Text({
			text: 'press any key to play', 
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

		var s = Clay.audio.play(Clay.resources.audio('assets/sheep.mp3'));
		s.volume = 0.3;

    	Clay.motion.tween(balloon.pos).to({y: -512-66}, 0.9).ease(clay.tween.easing.Quad.easeIn);
    	Clay.motion.tween(thread.pos).to({y: -512+64}, 0.9).ease(clay.tween.easing.Quad.easeIn);
    	Clay.motion.tween(sheep.pos).to({y: -512+192}, 0.9).ease(clay.tween.easing.Quad.easeIn);
    	Clay.motion.tween(title.color).to({a: 0}, 0.5).ease(clay.tween.easing.Quad.easeIn);
    	Clay.motion.tween(title.scale).to({x: 2, y: 2}, 0.5).ease(clay.tween.easing.Quad.easeIn);
    	Clay.motion.tween(play_text.color).to({a: 0}, 0.2).ease(clay.tween.easing.Quad.easeIn);

		Clay.timer.schedule(1,function() {
			Clay.processors.disable(processors.MenuStateProcessor);
			Clay.processors.enable(processors.PlayStateProcessor);
			buzy = false;
		});


	}

    override function ondisabled() {

    	Clay.motion.stop(play_text.scale);
    	balloon.destroy();
    	thread.destroy();
    	sheep.destroy();
    	title.destroy();
    	play_text.destroy();
	    
    }

	override function update(dt:Float) {

	}


}
