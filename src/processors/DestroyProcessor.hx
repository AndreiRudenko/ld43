package processors;


import clay.Entity;
import clay.Family;
import clay.components.common.Transform;
import clay.render.Layer;
import clay.math.Vector;

import components.Destroy;
import clay.input.Key;
import clay.input.Keyboard;


class DestroyProcessor extends clay.Processor {


	var destroy_family:Family<Destroy>;
	var dt_family:Family<Destroy, Transform>;


	override function onenabled() {
		
		destroy_family.listen(destroy_added, destroy_removed);

	}

	override function ondisabled() {

		destroy_family.unlisten(destroy_added, destroy_removed);

	}

	function destroy_added(e:Entity) {
		
	}

	function destroy_removed(e:Entity) {

		var d = destroy_family.get_destroy(e);

		if(d.callback != null) {
			d.callback();
		}

	}

	override function update(dt:Float) {

		var t:Transform;

		for (e in dt_family) {
			t = dt_family.get_transform(e);
			if(t.pos.y > Clay.camera.pos.y + Game.height + 256) {
				Clay.entities.destroy(e);
			}

		}

	}





}
