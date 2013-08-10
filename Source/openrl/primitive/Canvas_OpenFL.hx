//Marco Salamone
//requerent@gmail.com
//requerent.blogspot.com

package openrl.primitive;

import flash.text.TextField;
import flash.text.Font;
import flash.display.Sprite;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.events.Event;
import haxe.ds.StringMap;

using openrl.primitive.Console;
using openrl.primitive.Data;

/**
	OpenFL is an abstraction of the flash API for targeting native platforms.

	This is an OpenFL implementation of the ICanvas interface in Console.hx.

	It uses textfields to manage the rendering in a Curses-like manner.
*/

@:font("Andale_Mono.ttf") class DefaultFont extends Font {}

class Canvas_OpenFL extends Sprite implements ICanvas
{
	var screen:Grid<TextField>;	
	public var console:Console;

	function new(?host:Sprite)
	{
		super();		
		Font.registerFont(DefaultFont);
		screen = new Grid<TextField>();
		if(host!=null) host.addChild(this);
		stage.addEventListener(Event.RESIZE,renew);
	}

	public function commit(c:StringMap<Tile>)
		for(t in c)
		{
			screen[t.pos].backgroundColor = t.back;
			screen[t.pos].textColor 	  = t.fore;
			screen[t.pos].text 			  = t.text;
			screen[t.pos].border 		  = false;
		}

	private function renew(?e:Event) resolve();

	private function resolve(font:String = "Andale Mono")
	{
		var size = 24;
		var dim:Dimension = {w:0,h:0};
		var d:Dimension = screen.length;
		var targ:Dimension = {w:stage.stageWidth, h:stage.stageHeight};
		
		for(i in 1...48)
		{	
			var best:Dimension = metric(i,font);
			if(best*d <= targ)
			{									
				dim = best;	
				size = i;
			} else break;
		}
		
		var format = new TextFormat(font,size);
		
		var temp:Point = (targ/2 - dim*d/2);	

		for(i in new Dimension(0,0)...screen.length)
		{
			TFRefresh(screen[i],(i*dim)+temp,dim,format);
			debugField(screen[i]);
		}
	}

	public function resize(d:Dimension)
	{
		var t = screen.length;
		for(i in t...d)
			if(i < t) removeChild(screen[i] = null);
			else if(i < d)
				addChild(screen[i] = TFFactory());

		resolve();
	}


	private static function metric(size:Int,font:String = "Andale Mono") : Dimension
	{
		var max:Dimension = {h:0,w:0};
		var temp = TFFactory();
		
		temp.defaultTextFormat = new TextFormat(font,size);
		for(i in 32...127)
		{
			temp.text = String.fromCharCode(i);	
			max.w = Math.floor(Math.max(temp.width, max.w));
			max.h = Math.floor(Math.max(temp.height,max.h));
		}
		temp = null;
		return max;
	}

	private static function TFRefresh(field:TextField,?pos:Point,?dim:Dimension,?format:TextFormat)
	{
		if(format != null)	
		{
			var t = field.textColor;
			field.defaultTextFormat = format;
			field.textColor = t;
		}

		if(Reflect.isObject(pos))
		{
			field.x = pos.x;
			field.y = pos.y;
		}

		if(Reflect.isObject(dim))
		{
			field.width = dim.w;
			field.height = dim.h;
		}
	}

	private static function TFFactory():TextField
	{
		
		var	field = new TextField();

		field.autoSize = TextFieldAutoSize.LEFT;		
		field.embedFonts = true;
		field.background = true;
		field.selectable = false;
		field.cacheAsBitmap = true;
		field.border = true;		
		field.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		return field;
	}

	private static function debugField(field:TextField)
	{
		if(field.border)
		{			
			field.backgroundColor = Math.floor(Math.random() *0xffffff);
			field.textColor 	  = Math.floor(Math.random() *0xffffff);
			field.borderColor     = Math.floor(Math.random() *0xffffff);
			field.text = String.fromCharCode(Math.ceil(Math.random() * (126-32) + 32));		
		}
		else field.text = field.text;
	}
}