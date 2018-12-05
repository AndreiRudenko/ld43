package;


import clay.Entity;
import clay.data.Color;
import clay.math.Vector;
import clay.math.Mathf;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import clay.components.graphics.LineGeometry;

import clay.particles.ParticleEmitter;
import clay.particles.ParticleSystem;
import clay.particles.modules.*;


class EntityCreator {


	public static function player():Entity {

		var e = Clay.entities.create();
		var p = new components.Player(e, Clay.screen.mid.x);
		var sz = Settings.player_size;
		var t = new Transform({
			pos: new Vector(Clay.screen.mid.x, 192),
			origin: new Vector(sz/2, sz/4),
			scale: new Vector(1, 0.95)
		});

		Clay.motion.tween(t.scale)
		.to({x: 0.95, y: 1}, 0.682)
		.ease(clay.tween.easing.Expo.easeIn)
		.reflect()
		.repeat(); // todo: remove ondestroy

		Clay.world.components.set_many(
			e,
			[
				p,
				new components.Velocity(),
				new QuadGeometry({
					size : new Vector(sz, sz),
					texture : Clay.resources.texture('assets/player.png'),
					color : Settings.main_color,
				}),
				t,
				new components.Destroy(function() {
					Clay.motion.stop(t.scale);
				})
			]
		);

		Game.player = p;

		return e;

	}

	public static function balloon(_img:Int, _idx:Int, _air:Float):Entity {
		
		var e = Clay.entities.create();

		var sz = Settings.balloons_size;

		Clay.world.components.set_many(
			e,
			[
				new components.Balloon(e, _idx, _air, sz*0.25),
				new components.Velocity(),
				new LineGeometry({
					// p0: new Vector(100,100),
					// p1: new Vector(100,200),
					strength: 4,
					color0: Settings.main_color,
					color1: Settings.main_color,
					texture: Clay.resources.texture('assets/thread.png'),
				}),
				new QuadGeometry({
					size: new Vector(sz,sz),
					texture: Clay.resources.texture('assets/balloon${_img}.png'),
					color: Settings.main_color,
				}),
				// new Transform({pos: new Vector(Clay.screen.mid.x + Clay.random.int(-128, 128), Game.height - 256 - 128)})
				new Transform({
					origin: new Vector(sz/2, sz/2),
					scale: new Vector(_air,_air)
				}),
				new components.Destroy(function() {
					Game.spawner.remove_spawn(e);
				})
			]
		);

		Game.spawner.add_spawn(e);

		return e;

	}

	public static function air(_y:Float):Entity {

		var e = Clay.entities.create();

		var sz = Settings.air_radius*2;
		var rndx = Clay.random.float(sz/2, Game.width-sz);
		var t = new Transform({
			pos: new Vector(rndx, _y),
			origin: new Vector(sz/2, sz/2),
			scale: new Vector(1, 0.75)
		});

		Clay.motion.tween(t.scale)
		.to({x: 0.75, y: 1}, 0.341)
		.ease(clay.tween.easing.Expo.easeIn)
		.reflect()
		.repeat(); // todo: remove ondestroy

		Clay.world.components.set_many(
			e,
			[
				new components.Air(),
				new QuadGeometry({
					size : new Vector(sz, sz),
					texture : Clay.resources.texture('assets/air${Clay.random.int(3)}.png'),
					color : Settings.main_color
				}),
				t,
				new components.Destroy(function() {
					Game.spawner.remove_spawn(e);
					Clay.motion.stop(t.scale);
				})
			]
		);

		Game.spawner.add_spawn(e);

		return e;
		
	}

	public static function crow(_y:Float) {
		
		var e = Clay.entities.create();

		var sz = Settings.crow_size;
		var rndx = Clay.random.float(sz/2, Game.width-sz);
		var t = new Transform({
			pos: new Vector(rndx, _y),
			origin: new Vector(sz/2, sz/2)
		});

		Clay.motion.tween(t)
		.to({rotation: 15}, 0.682)
		.ease(clay.tween.easing.Quad.easeIn)
		.reflect()
		.repeat(); // todo: remove ondestroy

		Clay.world.components.set_many(
			e,
			[
				new components.Crow(),
				new QuadGeometry({
					size : new Vector(sz, sz),
					texture : Clay.resources.texture('assets/crow.png'),
					color : Settings.main_color
				}),
				t,
				new components.Destroy(function() {
					Clay.motion.stop(t);
					Game.spawner.remove_spawn(e);
				})
			]
		);

		Game.spawner.add_spawn(e);

		return e;

	}

	public static function free_balloon(_y:Float, _air:Float):Entity {




		var e = Clay.entities.create();
		var et = Clay.entities.create();

		var sz = Settings.balloons_size;
		var rndx = Clay.random.float(sz/2, Game.width-sz);
		var img = Clay.random.int(6);
		var t = new Transform({
			origin: new Vector(sz/2, sz/2),
			scale: new Vector(_air,_air),
			pos: new Vector(rndx, _y)
		});

		Clay.world.components.set_many(
			e,
			[
				new components.FreeBalloon(img, _air, sz*0.25),
				new QuadGeometry({
					size: new Vector(sz,sz),
					texture: Clay.resources.texture('assets/balloon${img}.png'),
					color: Settings.main_color,
				}),
				t,
				new components.Destroy(function() {
					Clay.entities.destroy(et);
					Game.spawner.remove_spawn(e);
				})
			]
		);

		var tt = new Transform({
			scale: new Vector(_air, _air),
			origin: new Vector(8, 0),
			pos: new Vector(rndx, _y + sz*0.25 + (10 * _air))
		});
		// tt.parent = t;

		Clay.world.components.set_many(
			et,
			[
				new QuadGeometry({
					size: new Vector(16,64),
					texture: Clay.resources.texture('assets/thread1.png'),
					color: Settings.main_color,
				}),
				tt
			]
		);

		Game.spawner.add_spawn(e);

		return e;

	}

	public static function dark_cloud(_y:Float):Entity {
		
		var e = Clay.entities.create();

		var sz = Settings.dark_cloud_size;
		var rndx = Clay.random.float(sz/2, Game.width-sz);
		var t = new Transform({
			pos: new Vector(rndx, _y),
			origin: new Vector(sz/2, sz/2),
			scale: new Vector(0.95, 1)
		});

		Clay.motion.tween(t.scale)
		.to({x: 1, y: 0.95}, 2.728)
		.ease(clay.tween.easing.Quad.easeIn)
		.reflect()
		.repeat(); // todo: remove ondestroy

		Clay.world.components.set_many(
			e,
			[
				new components.DarkCloud(),
				new QuadGeometry({
					size : new Vector(sz, sz),
					texture : Clay.resources.texture('assets/dark_cloud${Clay.random.int(3)}.png'),
					color : Settings.main_color
				}),
				t,
				new components.Destroy(function() {
					Clay.motion.stop(t.scale);
					Game.spawner.remove_spawn(e);
				})
			]
		);

		Game.spawner.add_spawn(e);

		return e;

	}


}
