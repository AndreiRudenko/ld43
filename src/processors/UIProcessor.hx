package processors;


import clay.Family;
import clay.components.graphics.Text;
import clay.components.common.Transform;
import clay.objects.Text;
import clay.types.TextAlign;
import clay.render.Layer;
import clay.math.Vector;
import components.FPS;


class UIProcessor extends clay.Processor {


	var scores_text:Text;
	var speed_text:Text;
	// var diff_text:Text;


    override function init() {
        

    }

    override function onenabled() {

    	scores_text = new Text({
			text: 'SCORE:0', 
			font: Clay.resources.font('assets/edosz.ttf'),
			size: 24, 
			align: TextAlign.right,
			color: Settings.main_color,
			layer: Clay.layers.get('ui'),
    		pos: new Vector(Game.width - 32, 16)
    	});

    	speed_text = new Text({
			text: 'SPEED:0', 
			font: Clay.resources.font('assets/edosz.ttf'),
			size: 24, 
			color: Settings.main_color,
			layer: Clay.layers.get('ui'),
    		pos: new Vector(32, 16)
    	});

   //  	diff_text = new Text({
			// text: 'Diff:0', 
			// font: Clay.resources.font('assets/edosz.ttf'),
			// size: 24, 
			// color: Settings.main_color,
			// layer: Clay.layers.get('ui'),
   //  		pos: new Vector(Game.width/2, 16)
   //  	});

    }

    override function ondisabled() {

	    scores_text.destroy();
		speed_text.destroy();
		// diff_text.destroy();

    }

	override function update(dt:Float) {

		scores_text.text = 'SCORE:${Math.floor(Game.score)}';
		speed_text.text = 'SPEED:${Math.floor(Game.speed)}';
		// diff_text.text = 'Diff:${Game.diff}';

	}


}
