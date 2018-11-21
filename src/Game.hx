package;

import states.StateMachine;


class Game {


	public static var states:StateMachine;


	public function new() {

		Clay.resources.load_all(
			[
				// 'assets/player.png'
			], 
			ready
		);

	}

	function ready() {

		Clay.processors.add(new processors.FPSProcessor());

		states = new StateMachine();

		states.add(new states.MenuState());
		states.add(new states.PlayState());

		states.set('play');

	}


}
