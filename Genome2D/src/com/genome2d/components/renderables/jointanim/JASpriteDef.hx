package com.genome2d.components.renderables.jointanim;
import flash.Vector;

/**
 * ...
 * @author Rise
 */
class JASpriteDef
{
	public var name:String;
	public var animRate:Float;
	public var workAreaStart : Int;
	public var workAreaDuration:Int;
	public var frames:Vector<JAFrame>;
	public var objectDefVector:Array<JAObjectDef>;
	public var label:Dynamic;

	public function new() 
	{
		frames = new Vector<JAFrame>();
		objectDefVector = new Array<JAObjectDef>();
		label = {};
	}
	
	public function GetLabelFrame(theLabel:String):Int
	{
		var _local2:String = theLabel.toUpperCase();
		if (Reflect.field(label, _local2) != null)
		{
			return Reflect.field(label, _local2);
		};
		return (-1);
	}
}