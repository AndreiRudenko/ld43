package components;

import clay.Entity;

class Player {


	public var entity:Entity;
	public var x:Float;
	public var balloons:Array<Balloon>;
	// public var focus:Bool = true;


	public function new(_e:Entity, _x:Float) {

		entity = _e;
		x = 0;
		balloons = [];

	}


}