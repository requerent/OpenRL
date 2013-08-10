
import flash.display.Sprite;
using openrl.primitive.Console;
using openrl.primitive.Canvas_OpenFL;
using openrl.primitive.Color;
 
class Main extends Canvas_OpenFL
{ 
        public function new ()
        {
        	super ();
        	console = new Console(this);
 
        		var blueOnly = function(c:Int):Int
        			{
        				var t = c.toRGB();
        				t[0] = t[1] = 0;
        				return t.toHEX(); };

        		var gradient = function(x:Int,y:Int):Int return x*0x110000+y*0x001111;
        	var random = function(_,_,_):Int return Math.floor(Math.random() *0xffffff);
                
                
                console.setDimension([30,16]);
                console.clean();				
                console.begin_draw();
                console.fill_rect([0,0],[16,6],random,random,"#");                
                console.fill_rect([0,0],[32,12],null,gradient);
                console.plot_char([0,0],"X",0xffffff,0x0);
                console.draw_text([0,1],"Logical Shading",null);
                console.fill_rect([0,0],[5,5],0xff00ff,0x0f0f0f);
                console.fill_rect([12,3],[16,6],null,blueOnly);
                console.fill_rect([12,0],[16,3],blueOnly);
                console.fill_rect([0,0],[32,12]);
                console.end_draw();
                
        }

}

