//Marco Salamone
//requerent@gmail.com
//requerent.blogspot.com

package openrl.primitive;
using openrl.primitive.Data;



/**
	Color is an abstraction of various different ways of managing color.

	A color parameter or object can be replaced by any of the following:
		int, hex-color
		[int,int,int], component color
		function(int):int, determine color as a function of the tile's color, a Tint
		function(int,int):int, determine color as a function of the tile's position, a gradient
		function(int,int,int):int, determine color as a function of position and current color.


*/
abstract Color(Int->Int->Int->Int)
{
	public function new(f:Int->Int->Int->Int)
		this = f;
 
	public inline function getValue(x:Int,y:Int,c:Int):Int
		return Reflect.callMethod(null, this, [x,y,c]);

	public inline function getValPos(p:Point,c:Int):Int
		return Reflect.callMethod(null, this, [p.x,p.y,c]);

	@:from static public inline function fromInt(v:Int)
		return new Color(function(_,_,_){ return v; });

	@:from static public inline function fromRGB(a:Array<Int>)
		return new Color(function(_,_,_){ return (a[0] << 16) + (a[1] << 8) + a[2]; });

	@:from static public inline function fromTint(v:Int->Int)
		return new Color(function(_,_,c){ return v(c); });
 
	@:from static public inline function fromGradient(v:Int->Int->Int)
		return new Color(function(x,y,_){ return v(x,y); });

	@:from static public inline function fromFunc3(v:Int->Int->Int->Int)
		return new Color(v);

	//@:from static public inline function fromNull(v:Null<Int>)
	//	return new Color(function(_,_,c){return c; });

	public static inline function getRGB(c:Int):Array<Int>
		return [( c >> 16 ) & 0xFF,( c >> 8 ) & 0xFF,c & 0xFF];

	public static inline function toHEX(c:Array<Int>):Int
		return ( c[0] << 16 ) +( c[1] << 8 ) + c[2];
}


/**
	This is a mixin that allows integers and arrays of integers to switch
	between one another in a slightly more elegant manner.

	usage:
		0.toRGB() returns [0,0,0]
		[0,0,0].toHEX() returns 0x0
*/
class ColorHelper
{
	public static inline function toRGB(c:Int):Array<Int>
		return [( c >> 16 ) & 0xFF,( c >> 8 ) & 0xFF,c & 0xFF];

	public static inline function toHEX(c:Array<Int>):Int
		return ( c[0] << 16 ) +( c[1] << 8 ) + c[2];
}