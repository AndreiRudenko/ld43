package;


class Main {


	public static function main() {

		Clay.init(
			{
				title: 'ld43',
				width: 540,
				height: 960,
				window: {
					mode: clay.types.WindowMode.Windowed,
					resizable: false
				}
			}, 
			onready
		);

	}

	static function onready() {

		new Game();

	}
	

}
