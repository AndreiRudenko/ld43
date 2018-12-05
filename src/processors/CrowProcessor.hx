package processors;


import clay.Entity;
import clay.Family;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.components.graphics.QuadGeometry;
import clay.render.Layer;
import clay.math.Vector;

import components.Crow;
import components.Player;
import components.Velocity;
import clay.input.Key;
import clay.input.Keyboard;


class CrowProcessor extends clay.Processor {


	var crow_family:Family<Crow, QuadGeometry, Transform>;


	override function update(dt:Float) {

		var c:Crow;
		var t:Transform;
		var q:QuadGeometry;

		for (e in crow_family) {
			c = crow_family.get_crow(e);
			t = crow_family.get_transform(e);
			q = crow_family.get_quadGeometry(e);

			if(t.pos.x + Settings.crow_size/2 > Game.width) {
				t.pos.x = Game.width - Settings.crow_size/2;
				c.dir = -1;
			}
			if(t.pos.x - Settings.crow_size/2 < 0) {
				t.pos.x = Settings.crow_size/2;
				c.dir = 1;
			}

			if((q.flipx && c.dir == -1) || (!q.flipx && c.dir == 1)) {
				q.flipx = c.dir == 1 ? true : false;
			}

			t.pos.x += c.dir * Settings.crow_speed_x * dt;
			t.pos.y += Settings.crow_speed_y * dt;

			// if(t.pos.y + Settings.crow_size > Game.height) {
			// 	Clay.entities.destroy(e);
			// }

		}

	}





}
