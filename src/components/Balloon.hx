package components;


import clay.Entity;


class Balloon {


	public var x:Float;
	public var entity:Entity;
	public var index:Int;
	public var radius:Float;
	public var air_amount:Float;
	public var strength:Float;
	public var scale_offset:Float; // for tween
	public var has_tween:Bool;
	public var t:Float = 0;
	public var ts:Int = 1;
	public var next_blow:Float;


	public function new(_e:Entity, _idx:Int, _air:Float, _r:Float) {

		strength = Clay.random.float(Settings.balloon_strength_min, Settings.balloon_strength_max);

		has_tween = false;
		scale_offset = 0;
		next_blow = 0;
		x = 0;
		entity = _e;
		index = _idx;
		air_amount = _air;
		radius = _r;
		
	}


}