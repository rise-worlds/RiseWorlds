package com.genome2d.components.renderables.jointanim;
import flash.Vector;

/**
 * ...
 * @author Rise
 */
class JASpriteInst {
	public var parent:JASpriteInst;
	public var delayFrames:Int;
	public var frameNum:Float;
	public var lastFrameNum:Float;
	public var frameRepeats:Int;
	public var onNewFrame:Bool;
	public var lastUpdated:Int;
	public var curTransform:JATransform;
	public var curColor:JAColor;
	public var children:Vector<JAObjectInst>;
	public var spriteDef:JASpriteDef;

	public function new() {
		children = new Vector<JAObjectInst>();
		curTransform = new JATransform();
		spriteDef = null;
	}

	public function Dispose():Void {
		var _local1:Int;
		_local1 = 0;
		while (_local1 < children.length) {
			children[_local1].Dispose();
			_local1++;
		}
		children.splice(0, children.length);
		children = null;
		curTransform = null;
		spriteDef = null;
		curColor = null;
	}

	public function Reset():Void {
		var _local1:Int;
		_local1 = 0;
		while (_local1 < children.length) {
			children[_local1].Dispose();
			_local1++;
		}
		children.splice(0, children.length);
	}
}