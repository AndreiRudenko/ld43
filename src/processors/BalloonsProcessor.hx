package processors;


import clay.Entity;
import clay.Family;
import clay.Wire;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import clay.components.graphics.LineGeometry;
import clay.render.Layer;
import clay.math.Vector;
import clay.math.Mathf;

import processors.PlayStateProcessor;
import components.FreeBalloon;
import components.DarkCloud;
import components.Crow;
import components.Air;
import components.Balloon;
import components.Player;
import components.Velocity;
import clay.input.Key;
import clay.input.Keyboard;


class BalloonsProcessor extends clay.Processor {


	var balloons_family:Family<Balloon, QuadGeometry, LineGeometry, Transform, Velocity>;
	var player_family:Family<Player, QuadGeometry, Transform, Velocity>;

	var air_family:Family<Air, Transform>;
	var crow_family:Family<Crow, QuadGeometry, Transform>;
	var dc_family:Family<DarkCloud, QuadGeometry, Transform>;
	var fb_family:Family<FreeBalloon, QuadGeometry, Transform>;
	var playstate:Wire<PlayStateProcessor>;


	var vel:Float = 0;
	var damp:Float = 0.95;
	var movespeed:Float = 32;


	override function init() {
		
	}

	override function onenabled() {
		
		balloons_family.listen(balloon_added, balloon_removed);

	}

	override function ondisabled() {

		balloons_family.unlisten(balloon_added, balloon_removed);

	}

	function balloon_added(e:Entity) {
		
		var pe = player_family.get_by_index(0);

		if(pe.is_null()) {
			trace('cant add balloon, there is no player');
			return;
		}

		var p = player_family.get_player(pe);
		var pt = player_family.get_transform(pe);

		var b = balloons_family.get_balloon(e);
		var bt = balloons_family.get_transform(e);
		var bl = balloons_family.get_lineGeometry(e);

		bl.p0.set(-128, -128); // oh... //todo: fix this in engine
		bl.p1.set(-256, -256);

		b.next_blow = Clay.random.float(Settings.balloon_blowtime_min, Settings.balloon_blowtime_max);

		bt.pos.y = pt.pos.y - Settings.balloons_distance;
		bt.pos.x = -128; // yup... //todo: fix this in engine

		var cpos = pt.pos.x;

		if(p.balloons.length > 0) {
			cpos = p.balloons[Math.floor(p.balloons.length/2)].x;
		}

		p.balloons.insert(b.index, b);

		update_balloons_position(cpos, p.balloons);

		bt.update();

		var s = Clay.audio.play(Clay.resources.audio('assets/pick2.mp3'));
		s.volume = 0.2;
		// Clay.audio.play_sound('pick2', 0.2);

	}

	function balloon_removed(e:Entity) {
		
		if(Game.player == null) {
			return;
		}

		var p = Game.player;
		var b = balloons_family.get_balloon(e);
		var bt = balloons_family.get_transform(e);

		var pe = Game.particles.emitters[0];
		pe.get_module(clay.particles.modules.RadialSpawnModule).radius = b.radius;
		pe.count = Std.int(b.radius);
		pe.pos.copy_from(bt.pos);
		pe.emit();

		var s = Clay.audio.play(Clay.resources.audio('assets/pop${Clay.random.int(3)}.mp3'));
		s.volume = 0.5;
		// Clay.audio.play_sound('pop${Clay.random.int(3)}', 0.5);


		if(Clay.random.bool(0.3 * (b.air_amount / Settings.air_amount_max))) {
			player_poop();
		}

		p.balloons.remove(b);

		if(p.balloons.length > 0) {
			var cpos = p.balloons[Math.floor(p.balloons.length/2)].x;
			update_balloons_position(cpos, p.balloons);
		} else {
			Game.speed = 0;
			playstate.game_over();
			// Clay.motion.tween()
			// game over
		}

	}

	function player_poop() {
		
		if(Game.player == null) {
			return;
		}

		var p = Game.player;

		var pt = player_family.get_transform(p.entity);

		var pe = Game.particles.emitters[1];
		pe.pos.set(pt.pos.x-48, pt.pos.y+16);
		pe.start();

		var s = Clay.audio.play(Clay.resources.audio('assets/poop.mp3'));
		s.volume = 0.5;
		// Clay.audio.play_sound('poop', 0.5);

	}

	function get_all_balloons_size(balloons:Array<Balloon>):Float {

		var size:Float = 0;

		for (b in balloons) {
			size += b.radius*2;
		}

		return size;
		
	}

	function get_player_pos(balloons:Array<Balloon>):Float {

		var pos:Float = 0;

		for (b in balloons) {
			pos += b.x;
		}

		pos /= balloons.length;

		return pos;
		
	}

	function update_balloons_position(center:Float, balloons:Array<Balloon>) {

		if(balloons.length == 0) {
			return;
		}

		var cbi = Math.floor(balloons.length/2);
		var cb = balloons[cbi];
		cb.x = center;
		cb.index = cbi;

		var b:Balloon;
		var pos:Float = cb.x - cb.radius;

		var i:Int = cbi-1;

		while(i >= 0) { // left
			b = balloons[i];
			b.index = i;
			b.x = pos - b.radius;
			pos -= b.radius*2;
			i--;
		}

		i = cbi+1;
		pos = cb.x + cb.radius;
		while(i < balloons.length) { // right
			b = balloons[i];
			b.index = i;
			b.x = pos + b.radius;
			pos += b.radius*2;
			i++;
		}

	}

/*	override function onkeydown(e:KeyEvent) {

		if(Game.player == null) {
			return;
		}

		if(e.key == Key.up) {
			var p = Game.player;
			EntityCreator.balloon(Clay.random.int(6), Clay.random.int(p.balloons.length), Clay.random.float(0.5, 2));
		} else if(e.key == Key.down) {
			var p = Game.player;
			if(p.balloons.length > 0) {
				var e = p.balloons[Clay.random.int(p.balloons.length)].entity;
				Clay.entities.destroy(e);
			}
		}

	}*/

	function balloon_leak(t:Transform):Void {
		
		var pe = Game.particles.emitters[2];
		// pe.get_module(clay.particles.modules.RadialSpawnModule).radius = b.radius;
		// pe.count = Std.int(b.radius);
		pe.pos.set(t.pos.x, t.pos.y+32*t.scale.y);
		pe.emit();

	}

	override function update(dt:Float) {

		var b:Balloon;
		var l:LineGeometry;
		var q:QuadGeometry;
		var t:Transform;

		var p:Player;
		var pt:Transform;

		for (pe in player_family) {

			p = player_family.get_player(pe);
			pt = player_family.get_transform(pe);

			if(p.balloons.length > 0) {
				
				if(Clay.input.keyboard.down(Key.left)) {
					vel -= movespeed;
				}

				if(Clay.input.keyboard.down(Key.right)) {
					vel += movespeed;
				}

			}

			for (e in balloons_family) {
				b = balloons_family.get_balloon(e);
				t = balloons_family.get_transform(e);
				q = balloons_family.get_quadGeometry(e);

				if(check_collision(b, t, dt)) {
					Clay.entities.destroy(e);
					continue;
				}

				b.x += vel * dt;
				b.next_blow -= dt;
				// b.air_amount -= Settings.balloon_leakage * dt / b.strength;
				if(b.next_blow <= 0) {
					b.air_amount -= Settings.balloon_leakage / b.strength;
					b.next_blow = Clay.random.float(Settings.balloon_blowtime_min, Settings.balloon_blowtime_max);
					balloon_leak(t);
					var s = Clay.audio.play(Clay.resources.audio('assets/squeak${Clay.random.int(3)}.mp3'));
					s.volume = 0.2;
				}

				t.pos.y = pt.pos.y - Settings.balloons_distance;
				t.scale.set(b.air_amount, b.air_amount);
				b.radius = q.size.x * 0.25 * t.scale.x;
				t.scale.add_scalar(b.scale_offset);

				if(b.air_amount > Settings.air_amount_max - 1) {

					b.t += dt * b.ts * Mathf.lerp(8, 32, b.air_amount - (Settings.air_amount_max - 1));
					if(b.t > 1) {
						b.t = 1;
						b.ts = -1;
					} else if(b.t < 0) {
						b.t = 0;
						b.ts = 1;
					}

					b.scale_offset = b.t * 0.2;
				}

				if(b.air_amount <= 0.25) {
					Clay.entities.destroy(e);
				}
			}

			if(p.balloons.length == 0) {
				// game over
				return;
			}

			var cpos = p.balloons[Math.floor(p.balloons.length/2)].x;
			update_balloons_position(cpos, p.balloons);

			var balloons = Game.player.balloons;
			if(balloons.length > 0) {
				
				var corr:Float = 0;
				var first = balloons[0];
				var last = balloons[balloons.length-1];

				if(first.x - first.radius < 0) {
					corr = -(first.x - first.radius);
				}
				if(last.x + last.radius > Game.width) {
					corr = Game.width - (last.x + last.radius);
				}

				if(corr != 0) {
					for (bl in balloons) {
						bl.x += corr;
					}
					vel = 0;
				}
			}

			if(p.balloons.length > 0) {
				p.x = get_player_pos(p.balloons);
				pt.pos.x = Mathf.lerp(pt.pos.x, p.x, 10 * dt);
				pt.rotation = (p.x - pt.pos.x) * 0.5;
			}

			var spd:Float = 0;
			for (e in balloons_family) {
				if(!Clay.entities.has(e)) {
					continue;
				}
				b = balloons_family.get_balloon(e);
				t = balloons_family.get_transform(e);
				l = balloons_family.get_lineGeometry(e);
				l.p0.set(b.x, t.pos.y + b.radius + (10 * t.scale.x));
				l.p1.set(pt.pos.x, pt.pos.y);
				t.pos.x = b.x;
				spd += b.air_amount;
			}

			Game.speed = spd; // - (0.5 * p.balloons.length);

			vel *= damp;

		}

	}

	var tmp_vec:Vector = new Vector();
	var lst:Int = 0;
	function check_collision(b:Balloon, bt:Transform, dt:Float) {

		var ot:Transform;
		var ob:FreeBalloon;
		for (e in fb_family) {
			if(!Clay.entities.has(e)) {
				continue;
			}
			ot = fb_family.get_transform(e);
			ob = fb_family.get_freeBalloon(e);
			if(Intersect.circle_circle(bt.pos, b.radius, ot.pos, ob.radius)) {
				if(get_all_balloons_size(Game.player.balloons) + ob.radius*2 < Game.width) {
					if(ot.pos.x > bt.pos.x) {
						EntityCreator.balloon(ob.img, b.index+1, ob.air_amount);
					} else {
						EntityCreator.balloon(ob.img, b.index, ob.air_amount);
					}
					Clay.entities.destroy(e);
				}
			}
		}

		for (e in air_family) {
			if(!Clay.entities.has(e)) {
				continue;
			}
			ot = air_family.get_transform(e);
			if(Intersect.circle_circle(bt.pos, b.radius, ot.pos, Settings.air_radius)) {

				b.air_amount += Settings.air_amount;
				Clay.entities.destroy(e);

				var s = Clay.audio.play(Clay.resources.audio('assets/blow${Clay.random.int(3)}.mp3'));
				s.volume = 0.2;

				if(b.air_amount > Settings.air_amount_max) {
					return true;
				}
			}
		}

		tmp_vec.set(Settings.dark_cloud_size, Settings.dark_cloud_size/2);
		for (e in dc_family) {
			ot = dc_family.get_transform(e);
			if(Intersect.circle_rectangle(bt.pos, b.radius, ot.pos, tmp_vec)) { 
				b.air_amount -= Settings.dark_cloud_force * dt;
				balloon_leak(bt);
				lst--;
				if(lst <= 0) {
					var s = Clay.audio.play(Clay.resources.audio('assets/squeak${Clay.random.int(3)}.mp3'));
					s.volume = 0.2;
					lst = 6;
				}
			}
		}

		for (e in crow_family) {
			ot = crow_family.get_transform(e);
			if(Intersect.circle_circle(bt.pos, b.radius, ot.pos, Settings.crow_size/2)) { 
				return true;
			}
		}

		return false;
		
	}


}
