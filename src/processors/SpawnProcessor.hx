package processors;


import clay.Entity;
import clay.Family;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import clay.render.Layer;
import clay.math.Vector;
import clay.math.Mathf;
import clay.core.ecs.EntityVector;

import components.Balloon;
import components.Player;
import components.Velocity;
import clay.input.Key;
import clay.input.Keyboard;


class SpawnProcessor extends clay.Processor {


	var air_next_dist:Float;
	var fb_next_dist:Float;
	var cr_next_dist:Float;
	var dc_next_dist:Float;
	var level_time:Float = 1;
	var max_diff:Float = 0;

	public var spawned:EntityVector;
	var _clearing:Bool = false;


	override function init() {

		spawned = new EntityVector(world.entities.capacity);
		
	}

	override function onenabled() {

		air_next_dist = -Clay.random.int(Chances.air_min_start * Settings.unit, Chances.air_max_start * Settings.unit);
		fb_next_dist = -Clay.random.int(Chances.baloon_min_start * Settings.unit, Chances.baloon_max_start * Settings.unit);
		cr_next_dist = -Clay.random.int(Chances.crow_min_start * Settings.unit, Chances.crow_max_start * Settings.unit);
		dc_next_dist = -Clay.random.int(Chances.dark_cloud_min_start * Settings.unit, Chances.dark_cloud_max_start * Settings.unit);

		max_diff = Settings.level_time / (Settings.game_time * 60);

	}

	public function remove_spawn(e:Entity) {

		// trace('remove_spawn: $e');
		if(_clearing) {
			return;
		}
		spawned.remove(e);
		
	}

	public function add_spawn(e:Entity) {

		// trace('add_spawn: $e');
		spawned.add(e);
		
	}

	override function ondisabled() {

		_clearing = true;
		var to_remove = [];
		for (e in spawned) {
			if(world.entities.has(e)) {
				to_remove.push(e);
			} else {
				// trace('cant remove $e');
			}
		}
		for (e in to_remove) {
			world.entities.destroy(e);
		}
		spawned.reset();
		_clearing = false;

	}

	override function onkeydown(e:KeyEvent) {

	}

	override function update(dt:Float) {

		level_time += dt;
		if(level_time > Settings.level_time) {
			level_time = 0;
		}
		var level_prog = level_time / Settings.level_time;

		var n = Mathf.lerp(0, max_diff, level_prog);
		var sin = (Math.sin(level_prog * 2 * Math.PI * 2) + 1) * 0.5 * 0.2;

		var t = Game.progress + n + sin;
		Game.diff = t;
		// trace('t: $t, lvl: ${level_prog} sin: ${sin}');
		var spp = Clay.camera.pos.y;
		var rmin:Float;
		var rmax:Float;

		while (air_next_dist > spp) {
			var pos = air_next_dist - Settings.air_radius*2;
			var e = EntityCreator.air(pos - 64);
			rmin = Mathf.lerp(Chances.air_min_start * Settings.unit, Chances.air_min_end* Settings.unit, t);
			rmax = Mathf.lerp(Chances.air_max_start * Settings.unit,   Chances.air_max_end * Settings.unit,   t);
			air_next_dist = air_next_dist - Clay.random.int(rmin,rmax);
		}

		while (fb_next_dist > spp) {
			var pos = fb_next_dist - Settings.balloons_size;
			var e = EntityCreator.free_balloon(pos - 64, Clay.random.float(Chances.balloon_air_min, Chances.balloon_air_max));
			rmin = Mathf.lerp(Chances.baloon_min_start * Settings.unit, Chances.baloon_min_end * Settings.unit, t);
			rmax = Mathf.lerp(Chances.baloon_max_start * Settings.unit,   Chances.baloon_max_end * Settings.unit,   t);
			fb_next_dist = fb_next_dist - Clay.random.int(rmin,rmax);
		}

		while (cr_next_dist > spp) {
			var pos = cr_next_dist - Settings.crow_size;
			var e = EntityCreator.crow(pos - 64);
			rmin = Mathf.lerp(Chances.crow_min_start * Settings.unit, Chances.crow_min_end * Settings.unit, t);
			rmax = Mathf.lerp(Chances.crow_max_start * Settings.unit,   Chances.crow_max_end * Settings.unit,   t);
			cr_next_dist = cr_next_dist - Clay.random.int(rmin,rmax);
		}

		while (dc_next_dist > spp) {
			var pos = dc_next_dist - Settings.dark_cloud_size;
			var e = EntityCreator.dark_cloud(pos - 64);
			rmin = Mathf.lerp(Chances.dark_cloud_min_start * Settings.unit, Chances.dark_cloud_min_end * Settings.unit, t);
			rmax = Mathf.lerp(Chances.dark_cloud_max_start * Settings.unit,   Chances.dark_cloud_max_end * Settings.unit,   t);
			dc_next_dist = dc_next_dist - Clay.random.int(rmin,rmax);
		}

	}


}
