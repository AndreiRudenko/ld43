package;

import clay.data.Color;


class Settings {


	public static var paper_color:Color = new Color().from_int(0xe2ca99);
	public static var main_color:Color = new Color(0,0,0,1);

	public static var level_time:Float = 60; // sec
	public static var game_time:Float = 10; // min

	public static var speed_modifer:Float = 64;
	public static var unit:Float = 64;

	public static var balloons_size:Float = 64;
	public static var balloons_distance:Float = 192;
	public static var balloon_leakage:Float = 0.25;

	public static var balloon_strength_min:Float = 0.5;
	public static var balloon_strength_max:Float = 1;

	public static var balloon_blowtime_min:Float = 1;
	public static var balloon_blowtime_max:Float = 4;

	public static var player_size:Float = 128;
	public static var player_distance:Float = 128;

	public static var dark_cloud_size:Float = 128;
	public static var dark_cloud_force:Float = 0.2; // air per sec
	public static var dark_cloud_lightning_chance:Float = 5; // lightning per sec

	public static var air_radius:Float = 16;
	public static var air_amount:Float = 0.2;
	public static var air_amount_max:Float = 3.5;

	public static var crow_size:Float = 64;
	public static var crow_speed_x:Float = 80;
	public static var crow_speed_y:Float = 10;


	public static var cloud_size:Float = 64;
	public static var cloud_speed:Float = 10;
	public static var falling_player_speed:Float = 60;


	

}
