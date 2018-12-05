package components;


class Destroy {


	public var callback:Void->Void;


	public function new(?_cb:Void->Void) {

		callback = _cb;

	}


}