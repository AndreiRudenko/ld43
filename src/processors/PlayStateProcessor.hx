package processors;


import clay.Entity;
import clay.Family;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import clay.render.Layer;
import clay.math.Vector;

import components.Balloon;
import components.Player;
import components.Velocity;
import clay.input.Key;
import clay.input.Keyboard;


class PlayStateProcessor extends clay.Processor {


	var player_family:Family<Player, QuadGeometry, Transform, Velocity>;
	var buzy:Bool = false;

	override function init() {
		
	}

	function play() {
		
		Game.time = 0;
		Game.score = 0;
		Game.max_speed = 0;

		Game.speed = 0;

		EntityCreator.player();
		EntityCreator.balloon(0, 0, 1.5);

		world.processors.enable(processors.UIProcessor);
		world.processors.enable(processors.SpawnProcessor);

		Clay.camera.pos.y = -Game.height;


		// buzy = true;
		// Clay.timer.schedule(1,function() {
			// buzy = false;
		// });

	}

	function finish() {
		
		world.processors.disable(processors.SpawnProcessor);
		world.entities.destroy(Game.player.entity);
		Game.player = null;
		world.processors.disable(processors.UIProcessor);

	}

	public function game_over() {

		if(buzy) {
			return;
		}

		buzy = true;

		var pt = player_family.get_transform(Game.player.entity);
    	Clay.motion.tween(pt.origin).to({y: -256}, 0.8).ease(clay.tween.easing.Quad.easeIn);

		Clay.timer.schedule(0.3,function() {
			var s = Clay.audio.play(Clay.resources.audio('assets/sheep.mp3'));
			s.volume = 0.3;
		});

		Clay.timer.schedule(1,function() {
			world.processors.disable(processors.PlayStateProcessor);
			world.processors.enable(processors.GameOverStateProcessor);
			buzy = false;
		});

	}

	override function onenabled() {

		play();
		Game.particles.stop(true);

	}

	override function ondisabled() {

		finish();

	}

	override function onkeyup(e:KeyEvent) {

		if(buzy) {
			return;
		}

		if(e.key == Key.escape) {
			world.processors.disable(processors.PlayStateProcessor);
			world.processors.enable(processors.MenuStateProcessor);
		}

	}

	override function update(dt:Float) {

		if(buzy) {
			return;
		}

		Game.time += dt;

		if(Game.speed > Game.max_speed) {
			Game.max_speed = Game.speed;
		}


	}

}
