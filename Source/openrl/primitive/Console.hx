//Marco Salamone
//requerent@gmail.com
//requerent.blogspot.com

package openrl.primitive;
using openrl.primitive.Data;
using haxe.ds.StringMap;

//	Interface for back-end drawing systems.
interface ICanvas
{
	public var console:Console;
	public function commit(c:StringMap<Tile>):Void;
	public function resize(d:Dimension):Void;
	//TODO: GetValidDimensions
}

/**
	An object that represents the LOGICAL state of a graphical console.

	Intended to represent the essential functionality of Curses for rendering purposes.


	Console mimmicks a fixed drawing pipeline whereby a user may open a stack
	and make a series of changes before drawing operators are sent to the canvas.
	This allows a form of ad-hoc shading that is about as flexible as can be expected
	for a console emulator.
*/

class Console
{
		private var canvas:ICanvas;
	private var screen:Grid<Tile>; //The logical grid of tiles
	private var changes:StringMap<Tile>; //Stores changes before commiting
	private var drawing:Bool = false; //Whether to use the stack or not


	public function new(?canvas:ICanvas)
	{
		screen = new Grid<Tile>();
		if(canvas != null)
		{
			this.canvas = canvas;
			canvas.console = this;
		}
	}

	public function getDimension():Dimension return screen.length;

	public function setDimension(d:Dimension)
	{
		var t = screen.length;
		for(i in t...d) //xor iteration between old and new dimensions
			if(i < t)
				screen[i] = null;
			else if(i < d)
				screen[i] = new Tile(i);			

		canvas.resize(d); //inform the backend that we should be drawn differently
	}



	public inline function begin_draw(additive:Bool = true)
		if(!drawing)
		{
			changes = new StringMap<Tile>();
			drawing = additive;
		}

	public inline function end_draw(additive:Bool = true)
		if(!additive || drawing)
		{
			canvas.commit(changes);
			drawing = false;
		}

	private inline function write(q:Point, ? text:String, ? f:Color, ? b:Color)	
		if(q < screen.length && screen[q].set(text,f,b))			
			changes.set(q,screen[q]);
	


	/**
		Basic curses style drawing commands
	*/
	public function plot_char(q:Point, ? text:String, ? f:Color, ? b:Color)
	{
		begin_draw(false);
		write(q,text,f,b);
		end_draw(false);
	}

	public function draw_text(pos:Point,text:String, ? f:Color, ? b:Color)
	{
		begin_draw(false);
		for(i in 0...text.length)
				write([pos.x+i,pos.y],text.charAt(i),f,b);
		end_draw(false);
	}

	public function fill_rect(pos:Point,dim:Dimension,? f:Color,? b:Color, ? text:String)
	{
		begin_draw(false);
		for(i in new Dimension(0,0) ... dim)
			write(pos+i,text,f,b);			
		end_draw(false);
	}

	public inline function clean() fill_rect([0,0],screen.length, 0x0,0x0, " ");
}


// logical state of a given tile
class Tile
{
	public var fore:Int = 0x0;
	public var back:Int = 0x0;
	public var text:String = " ";	
	public var pos:Point;

	public function new(p:Point) pos = p;

	/*
		Since all of the drawing commands are nullable, it's possible
		certain changes won't take place, so a set command doesn't
		necessarily result in a dirty tile.
	*/
	public function set( ? t:String, ?f:Color, ?b:Color):Bool
	{		
		var dirty = 
			((f == null || fore == f.getValPos(pos,fore)) &&
			 (b == null || back == b.getValPos(pos,back)) &&
			 (t == null || text == t));

		if(f != null) fore = f.getValPos(pos,fore);
		if(b != null) back = b.getValPos(pos,back);
		if(t != null) text = t;

		return dirty;
	}
}