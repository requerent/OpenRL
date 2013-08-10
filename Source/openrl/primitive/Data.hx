//Marco Salamone
//requerent@gmail.com
//requerent.blogspot.com

package openrl.primitive;

/**
	Some basic types for abstracting some syntactical parameters between like ideas.


	Objectives:
		To provide a flexible and vast library of discrete (integer) 2D types
		with appropriate arithmetic support.


	Current Contents:
		Point - An abstraction for a position in discrete space
		Dimension - An abstraction for dimensionality in discrete space
		Grid - a Safe 2D array
		DimIterXOR - A XOR iterator between two Dimensions

	TODO:
		Rectangle and Vector types
		Fill in non-unique arithmetic operators with Macros
		extend iterators to include additional use-cases
		utilities for managing world and local spaces
*/


/*
	An abstraction to allow [x,y] as a shortcut for a point-type in function parameters.
*/
abstract Point({x:Int,y:Int})
{	 
	public var x(get,set):Int;
    public var y(get,set):Int;

    inline function get_x() return this.x;
    inline function get_y() return this.y;
    inline function set_x(x:Int) return this.x=x;
    inline function set_y(y:Int) return this.y=y;

	public inline function new(x:Int,y:Int)
		this = {x:x,y:y};


	@:to public inline function toString() : String
		return this.x + " " + this.y;

	@:from static public inline function fromArray(p:Array<Int>) 
		return new Point(p[0],p[1]);
	
	@:from static public inline function fromStruct(p:{x:Int,y:Int}) 
		return new Point(p.x,p.y);

	@:from static public inline function fromDimension(p:Dimension) 
		return new Point(p.w,p.h);

	@:op(A + B) static public function add(l:Point,r:Point)
		return new Point(l.x+r.x,l.y+r.y);

	@:op(A * B) static public function times(l:Point,r:Dimension)
		return new Point(l.x*r.w,l.y*r.h);

	//@:op(A ... B) static public function iterate(l:Point,r:Point)
	//	return new PointIter(l,r);
}


/*
	An abstraction of dimension to provide specific arithmetic and parameter shortcuts.
*/
abstract Dimension({w:Int,h:Int})
{
	//Allow users to access values in whichever way they wish.
	public var COL(get,set)   :Int;
	public var ROW(get,set)   :Int;
	public var height(get,set):Int;
	public var width(get,set) :Int;
	public var h(get,set)	  :Int;
	public var w(get,set)     :Int;

	inline function get_width() return this.w;
    inline function get_height() return this.h;
    inline function set_width(w:Int) return this.w = w;
    inline function set_height(h:Int) return this.h = h;

	inline function get_ROW() return this.w;
    inline function get_COL() return this.h;
    inline function set_ROW(w:Int) return this.w = w;
    inline function set_COL(h:Int) return this.h = h;

	inline function get_w() return this.w;
    inline function get_h() return this.h;
    inline function set_w(w:Int) return this.w = w;
    inline function set_h(h:Int) return this.h = h;

	public inline function new(w:Int,h:Int)
		this = {h:h,w:w};

	@:from static public inline function fromArray(p:Array<Int>)
		return new Dimension(p[0],p[1]);

	@:from static public inline function fromStruct1(p:{height:Int,width:Int})
		return new Dimension(p.width,p.height);

	@:from static public inline function fromStruct2(p:{h:Int,w:Int})
		return new Dimension(p.w,p.h);

	@:op(A < B) static public function within(l:Point,r:Dimension):Bool
		return l.x < r.w && l.y < r.h;
	
	@:op(A <= B) static public function lessThan(l:Dimension,r:Dimension):Bool
		return l.w <= r.w && l.h <= r.h;

	@:op(A * B) static public function times(l:Dimension,r:Dimension):Dimension
		return new Dimension((l.w * r.w),(l.h * r.h));

	@:op(A / B) static public function scalar(l:Dimension,r:Int):Dimension
		return new Dimension(Std.int(l.w / r),Std.int(l.h / r));

	@:op(A - B) static public function difference(l:Dimension,r:Dimension):Dimension
		return new Dimension((l.w - r.w),(l.h - r.h));

	@:op(A ... B) static public function iterate(l:Dimension,r:Dimension)
		return new DimIterXOR(l,r);

	@:op(A == B)  static public function equals(l:Dimension,r:Dimension):Bool
		return l.h == r.h && l.w == r.w;
	
	@:op(A != B)  static public function notEquals(l:Dimension,r:Dimension):Bool
		return l.h != r.h || l.w != r.w;

}


/**
	Builds an iterator for the disjunction of two dimensions
	ie. The XOR region.
*/
class DimIterXOR
{
	var iter  : Array<Point>;

	public function new(start:Dimension,end:Dimension)
	{
		var max = new Dimension(
			  		Math.floor(Math.max(start.w,end.w)),
					Math.floor(Math.max(start.h,end.h)));
		
		iter = new Array<Point>();
		var head = new Point(0,0);

		while(head < max)
		{
			var p = head < start;
			var q = head < end;

			if((p || q) && !(p && q))
				iter.push(new Point(head.x,head.y));

			if(head.y < max.h-1)
				head.y = head.y+1;

			else if (head.x <= max.w-1)
			{
				head.y = 0;
				head.x = head.x+1;
			}
		}
		iter.reverse();
	}
	public inline function next()
		return iter.pop();

	public inline function hasNext()
		return iter.length > 0;

}

/**
	A simple and managed two-dimensional array with permissive* access security.
	* out of index results in a new row or column.
*/
abstract Grid<T>(Array<Array<T>>) from Array<Array<T>> to Array<Array<T>>
{
	public function new()
		this = new Array<Array<T>>();

	private inline function nullate():Null<T> return null;

	
	public var length(get,never):Dimension;

	public function get_length():Dimension 
		return [this.length, this[0]==null? 0 : this[0].length];

	@:arrayAccess public inline function arrayRead1D(i:Int):Array<T>
		return this[i] == null ? this[i] = new Array<T>() : this[i];

	@:arrayAccess public inline function arrayRead(p:Point):Null<T>
		return this[p.x] == null ? null : this[p.x][p.y];
	
	@:arrayAccess public inline function arrayWrite(p:Point,value:T):T
		return arrayRead1D(p.x)[p.y] = value;
}


/*
class DupleIter
{
	var start : Duple;
	var end   : Duple;
	var head  : Duple;

	public function new(s:Duple,t:Duple)
		{ start = s; end = t; head = start; }

	public inline function next():Duple
	{
		if(head.b != end.b)
			if(head.b < end.b) head++;
			else head--;
		else
		{
			head.b = start.b;
			if(head.a < end.a) ++head;
			else --head;
		}
		return head;
	}
	public inline function hasNext() return head <= end;
}


*/