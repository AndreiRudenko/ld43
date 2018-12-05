package processors;


import clay.Entity;
import clay.Family;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import clay.render.Layer;
import clay.math.Vector;

import components.Paper;
import components.Balloon;
import components.Player;
import components.Velocity;
import clay.input.Key;
import clay.input.Keyboard;


class PlayerProcessor extends clay.Processor {


	// var balloons_family:Family<Balloon, QuadGeometry, Transform, Velocity>;
	var player_family:Family<Player, QuadGeometry, Transform, Velocity>;
	var paper_family:Family<Paper, QuadGeometry>;

	var upper_pos:Float = 0;
	// var last_pos:Float = 0;


	override function init() {
		
	}

	override function onenabled() {
		
		player_family.listen(player_added, player_removed);

	}

	override function ondisabled() {

		player_family.unlisten(player_added, player_removed);

	}
	override function onkeydown(e:KeyEvent) {

	}

	override function update(dt:Float) {

		Game.time += dt;

		var p:Player;
		var t:Transform;
		var q:QuadGeometry;

		for (e in player_family) {

			p = player_family.get_player(e);
			t = player_family.get_transform(e);

			t.pos.y -= Game.speed * Settings.speed_modifer * dt;
			if(t.pos.y < upper_pos) {
				Game.score += Math.abs(t.pos.y - upper_pos) * 0.001;
				upper_pos = t.pos.y;
			}

			if(t.pos.y < Clay.camera.pos.y + (Game.height - Settings.player_distance) ) {
				Clay.camera.pos.y = t.pos.y - (Game.height - Settings.player_distance);
				for (e in paper_family) {
					q = paper_family.get_quadGeometry(e);
					q.uv.y -= 1/960 * (Game.speed * Settings.speed_modifer * 2 * dt);
				}
			}

		}

	}

	function player_added(e:Entity) {

		var t = player_family.get_transform(e);
		upper_pos = t.pos.y;

	}

	function player_removed(e:Entity) {

	}

}
