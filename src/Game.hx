package;


import clay.Entity;
import clay.math.Vector;
import clay.render.types.BlendMode;
import clay.render.types.BlendEquation;
import clay.render.types.TextureAddressing;
import clay.render.Shader;
import clay.data.Color;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.Shaders;

import clay.particles.ParticleEmitter;
import clay.particles.ParticleSystem;
import clay.particles.modules.*;


class Game {


	public static var player:components.Player;

	public static var speed:Float = 1;
	public static var max_speed:Float = 0;
	public static var best_max_speed:Float = 0;

	public static var score:Float = 0;
	public static var best_score:Float = 0;

	public static var width:Float = 540;
	public static var height:Float = 960;
	public static var time:Float = 0;
	// public static var time_max:Float = 10*60; // 10 mins
	public static var diff:Float = 0;
	public static var progress(get, never):Float;
	public static var spawner:processors.SpawnProcessor;
	public static var particles:ParticleSystem;


	static function get_progress():Float {
		
		return time / (Settings.game_time * 60);

	}


	public function new() {

		Clay.resources.load_all(
			[
				'assets/settings.json',
				'assets/paper.png',
				'assets/player.png'
			], 
			function() {

				setup_settings();

				Clay.processors.add(new processors.PlayStateProcessor(), null, false);
				Clay.processors.add(new processors.MenuStateProcessor(), null, false);
				Clay.processors.add(new processors.GameOverStateProcessor(), null, false);

				Clay.processors.add(new processors.CrowProcessor());
				Clay.processors.add(new processors.PlayerProcessor());
				Clay.processors.add(new processors.BalloonsProcessor());
				Clay.processors.add(new processors.DestroyProcessor());
		
				setup_cameras();
				setup_paper_texture();

				progress_entity = Clay.entities.create();
				progress_transform = new Transform({
					pos: new Vector(64, Game.height - 128),
					origin: new Vector(32, 32)
				});

				Clay.world.components.set_many(
					progress_entity,
					[
						new QuadGeometry({
							size : new Vector(64, 64),
							texture : Clay.resources.texture('assets/player.png'),
							color : Settings.main_color,
						}),
						progress_transform
					]
				);

				Clay.resources.load_all(
					[
						'assets/balloon0.png',
						'assets/balloon1.png',
						'assets/balloon2.png',
						'assets/balloon3.png',
						'assets/balloon4.png',
						'assets/balloon5.png',
						// 'assets/balloon6.png',
						// 'assets/balloon7.png',
						'assets/thread.png',
						'assets/thread1.png',
						// 'assets/player.png',
						// 'assets/cloud0.png',
						// 'assets/cloud1.png',
						// 'assets/cloud2.png',
						'assets/dark_cloud0.png',
						'assets/dark_cloud1.png',
						'assets/dark_cloud2.png',
						'assets/air0.png',
						'assets/air1.png',
						'assets/air2.png',
						'assets/particle0.png',
						'assets/particle1.png',
						// 'assets/particle2.png',
						// 'assets/particle3.png',
						'assets/crow.png',

						'assets/blow0.mp3',
						'assets/blow1.mp3',
						'assets/blow2.mp3',
						'assets/pop0.mp3',
						'assets/pop1.mp3',
						'assets/pop2.mp3',
						'assets/squeak0.mp3',
						'assets/squeak1.mp3',
						'assets/squeak2.mp3',
						// 'assets/pick0.mp3',
						// 'assets/pick1.mp3',
						'assets/pick2.mp3',
						'assets/poop.mp3',
						'assets/sheep.mp3',
						'assets/music.mp3',
						// 'assets/test.png',
						'assets/edosz.ttf'
					], 
					ready,
					onprogress
				);
			}
		);

	}

	var progress_entity:Entity;
	var progress_transform:Transform;

	function ready() {

		setup_particles();
		setup_sounds();

		Clay.entities.destroy(progress_entity);
		progress_transform = null;
		spawner = new processors.SpawnProcessor();

		// Clay.processors.add(new processors.FPSProcessor());
		Clay.processors.add(new processors.UIProcessor(), null, false);
		Clay.processors.add(spawner, null, false);

		Clay.processors.enable(processors.MenuStateProcessor);

	}

	function setup_settings() {

		var res = Clay.resources.json('assets/settings.json');

		if(res == null) {
			throw('cant find assets/settings.json');
		}

		var _game = res.json.game;
		var _chances = res.json.chances;
		var _colors = res.json.colors;

		Settings.speed_modifer = Std.parseFloat(_game.speed);

		Settings.level_time = Std.parseFloat(_game.level_time);
		Settings.game_time = Std.parseFloat(_game.game_time);

		Settings.player_size = Std.parseFloat(_game.player_size);
		Settings.player_distance = Std.parseFloat(_game.player_distance);

		Settings.balloons_size = Std.parseFloat(_game.balloons_size);
		Settings.balloons_distance = Std.parseFloat(_game.balloons_distance);
		Settings.balloon_leakage = Std.parseFloat(_game.balloon_leakage);
		Settings.balloon_strength_min = Std.parseFloat(_chances.balloon_strength_min);
		Settings.balloon_strength_max = Std.parseFloat(_chances.balloon_strength_max);
		Settings.balloon_blowtime_min = Std.parseFloat(_chances.balloon_blowtime_min);
		Settings.balloon_blowtime_max = Std.parseFloat(_chances.balloon_blowtime_max);

		Settings.air_radius = Std.parseFloat(_game.air_radius);
		Settings.air_amount = Std.parseFloat(_game.air_amount);
		Settings.air_amount_max = Std.parseFloat(_game.air_amount_max);

		Settings.crow_size = Std.parseFloat(_game.crow_size);
		Settings.crow_speed_x = Std.parseFloat(_game.crow_speed_x);
		Settings.crow_speed_y = Std.parseFloat(_game.crow_speed_y);

		Settings.dark_cloud_size = Std.parseFloat(_game.dark_cloud_size);
		Settings.dark_cloud_force = Std.parseFloat(_game.dark_cloud_force);
		Settings.dark_cloud_lightning_chance = Std.parseFloat(_chances.dark_cloud_lightning_chance);

		Settings.main_color = new Color().from_int(Std.parseInt(_colors.main));
		Settings.paper_color = new Color().from_int(Std.parseInt(_colors.paper));

		Chances.air_min_start           = Std.parseFloat(_chances.air_min_start);
		Chances.air_max_start           = Std.parseFloat(_chances.air_max_start);
		Chances.air_min_end             = Std.parseFloat(_chances.air_min_end);
		Chances.air_max_end             = Std.parseFloat(_chances.air_max_end);
		Chances.baloon_min_start        = Std.parseFloat(_chances.baloon_min_start);
		Chances.baloon_max_start        = Std.parseFloat(_chances.baloon_max_start);
		Chances.baloon_min_end          = Std.parseFloat(_chances.baloon_min_end);
		Chances.baloon_max_end          = Std.parseFloat(_chances.baloon_max_end);
		Chances.balloon_air_min          = Std.parseFloat(_chances.balloon_air_min);
		Chances.balloon_air_max          = Std.parseFloat(_chances.balloon_air_max);
		Chances.crow_min_start          = Std.parseFloat(_chances.crow_min_start);
		Chances.crow_max_start          = Std.parseFloat(_chances.crow_max_start);
		Chances.crow_min_end            = Std.parseFloat(_chances.crow_min_end);
		Chances.crow_max_end            = Std.parseFloat(_chances.crow_max_end);
		Chances.dark_cloud_min_start    = Std.parseFloat(_chances.dark_cloud_min_start);
		Chances.dark_cloud_max_start    = Std.parseFloat(_chances.dark_cloud_max_start);
		Chances.dark_cloud_min_end      = Std.parseFloat(_chances.dark_cloud_min_end);
		Chances.dark_cloud_max_end      = Std.parseFloat(_chances.dark_cloud_max_end);

	}

	function setup_sounds() {

		var s = Clay.audio.play(Clay.resources.audio('assets/music.mp3'));
		s.volume = 0.2;
		s.loop = true;

	}


	function setup_cameras() {
		
		Clay.layers.create('bg', -1);
		Clay.layers.create('ui', 800);
		Clay.cameras.create('bg_camera', null, -1).hide_layers().show_layers(['bg']);
		Clay.camera.hide_layers(['bg']);

	}

	function setup_particles() {

		var e = Clay.entities.create();
		
		particles = new ParticleSystem();

		particles.add(new ParticleEmitter({
				name : 'balloon_pop', 
				// pos: new Vector(-48, 16),
				enabled: false,
				// duration: 0.2,
				// rate : 20,
				// rate_max : 50,
				cache_size : 128,
				lifetime : 0.25,
				lifetime_max : 0.5,
				count: 1,
				// cache_wrap : true,
				image_path: 'assets/particle1.png',
				modules : [
					new RadialSpawnModule({
						radius: 16
					}),
					new DirectionModule({
						// direction: 180,
						direction_variance: 180,
						speed_variance: 40,
						speed: 80
					}),
					// new RotationModule({
					// 	initial_rotation: 0,
					// 	initial_rotation_max: 360,
					// 	angular_velocity: 1,
					// 	angular_velocity_max: 2
					// }),
					new GravityModule({
						gravity : new Vector(0, 90)
					}),
					new ScaleLifeModule({
						initial_scale : 0.2,
						initial_scale_max : 0.5,
						end_scale : 0
					}),
					new ColorModule({
						initial_color : Settings.main_color
					}),
				]

			})
		);

		particles.add(new ParticleEmitter({
				name : 'sheep_poop', 
				enabled: false,
				// pos: new Vector(-48, 16),
				duration: 0.2,
				rate : 20,
				rate_max : 50,
				cache_size : 128,
				lifetime : 2,
				lifetime_max : 2,
				count: 1,
				// cache_wrap : true,
				image_path: 'assets/particle0.png',
				modules : [
					new SpawnModule(),
					new DirectionModule({
						direction: 180,
						direction_variance: 20,
						speed_variance: 50,
						speed: 200
					}),
					new GravityModule({
						gravity : new Vector(0, 90)
					}),
					new ScaleModule({
						initial_scale : 0.2,
						initial_scale_max : 0.5,
						// end_scale : 0
					}),
					new ColorModule({
						initial_color : Settings.main_color
					}),
				]

			})
		);

		particles.add(new ParticleEmitter({
				name : 'balloon_leak1', 
				enabled: false,
				// pos: new Vector(-48, 16),
				// duration: 0.2,
				rate : 40,
				rate_max : 50,
				cache_size : 128,
				lifetime : 0.2,
				lifetime_max : 0.5,
				count: 5,
				// cache_wrap : true,
				image_path: 'assets/particle1.png',
				modules : [
					new SpawnModule(),
					new DirectionModule({
						direction: 90,
						direction_variance: 40,
						speed_variance: 50,
						speed: 100
					}),
					new ScaleLifeModule({
						initial_scale : 0.2,
						initial_scale_max : 0.5,
						end_scale : 0
					}),
					new ColorModule({
						initial_color : Settings.main_color
					}),
				]

			})
		);

		Clay.components.set(e, particles);

	}

	function setup_paper_texture() {

		var c = Clay.cameras.create('ui_camera', null, 2);
		Clay.camera.hide_layers(['ui']);
		c.hide_layers();
		c.show_layers(['ui']);
		
		var w = 540;
		var h = 960;

		var r = w / h;
		var tex = Clay.resources.texture('assets/paper.png');
		tex.u_addressing = TextureAddressing.Repeat;
		tex.v_addressing = TextureAddressing.Repeat;

		var s = 2;

		var e = Clay.entities.create();
		var q = new clay.components.graphics.QuadGeometry({
			size : new Vector(w,h),
			texture : tex,
			color : Settings.paper_color,
			layer : Clay.layers.get('bg')
		});
		q.set_uv(0, 0, s*r, s);

		var p = new components.Paper();

		Clay.components.set_many(e, [q, p]);

		Clay.renderer.clear_color.set(1,1,1,1);

	}

	function onprogress(p:Float) {
		
		progress_transform.pos.x = clay.math.Mathf.lerp(64, Game.width-128, p);
		// progress_transform.rotation = clay.math.Mathf.lerp(0, 360, p);

	}


}
