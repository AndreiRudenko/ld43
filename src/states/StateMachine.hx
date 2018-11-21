package states;


@:access(states.State)
class StateMachine {


	public var current	(default, null):State;
	public var states 	(default, null):Map<String, State>;


	public function new() {
		
		states = new Map();

	}

	public function add(s:State) {

		if(states.exists(s.name)) {
			trace('State add: state `${s.name}` already exists');
			return;
		}

		states.set(s.name, s);
		s.onadded();
		
	}

	public function remove(s:State) {

		if(states.exists(s.name)) {
			states.remove(s.name);
			if (current == s) {
				current = null;
			}
			s.onleave(null);
			s.onremoved();
		} else {
			trace('State remove: state `${s.name}` not exists');
		}
		
	}

	public function set(name:String, ?enter_data:Dynamic, ?leave_data:Dynamic) {
		
		if(states.exists(name)) {
			var s = states.get(name);
			if (current != null) {
				current.onleave(leave_data);
			}
			s.onenter(enter_data);
			current = s;
		} else {
			trace('State set: state `${name}` not exists');
		}

	}


}
