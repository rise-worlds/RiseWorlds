package com.genome2d.components.renderables.jointanim;
import flash.Vector;

/**
 * ...
 * @author Rise
 */
class JAAnimDef {
	public var mainSpriteDef:JASpriteDef;
	public var spriteDefVector:Vector<JASpriteDef>;
	public var objectNamePool:Array<Dynamic>;

	public function new() {
		mainSpriteDef = null;
		spriteDefVector = new Vector<JASpriteDef>();
		objectNamePool = [];
	}

}