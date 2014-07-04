package com.genome2d.components.renderables.jointanim;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import flash.display.Bitmap;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.Vector;
import haxe.Timer;

/**
 * ...
 * @author Rise
 */
class JointAnimate {
	public static var Load_Successed:Int = 0;
	public static var Load_MagicError:Int = -1;
	public static var Load_VersionError:Int = -2;
	public static var Load_Failed:Int = -3;
	public static var Load_LoadSpriteError:Int = -4;
	public static var Load_LoadMainSpriteError:Int = -5;
	public static var Load_GetImageTextureAtlasError:Int = -6;

	public static var ImageSearchPathVector:Array<Dynamic> = [];

	private var _loaded:Bool;
	private var _version:UInt;
	private var _animRate:Int;
	private var _animRect:Rectangle;
	private var _imageVector:Vector<JAImage>;
	private var _mainAnimDef:JAAnimDef;
	//private var _remapList:Array<Dynamic>;
	private var _particleAttachOffset:Point;
	//private var _randUsed:Bool;
	//private var _rand:MTRand;
	private var _drawScale:Float;
	private var _imgScale:Float;

	public function new() {
		//_randUsed = false;
		//_rand = new MTRand();
		//_rand.SRand(Math.round(haxe.Timer.stamp() * 1000)); //Timer.stamp();Lib.getTimer()
		_drawScale = 1;
		_imgScale = 1;
		_loaded = false;
		_animRect = new Rectangle();
		_imageVector = new Vector<JAImage>();
		_mainAnimDef = new JAAnimDef();
		//_remapList = [];
	}

	#if swc @:extern #end
	public var drawScale(get, never):Float;
	#if swc @:getter(drawScale) #end
	inline private function get_drawScale():Float {
		return _drawScale;
	}
	#if swc @:extern #end
	public var imgScale(get, never):Float;
	#if swc @:getter(imgScale) #end
	inline private function get_imgScale():Float {
		return _imgScale;
	}
	#if swc @:extern #end
	public var loaded(get, never):Bool;
	#if swc @:getter(loaded) #end
	inline private function get_loaded():Bool {
		return _loaded;
	}
	#if swc @:extern #end
	public var particleAttachOffset(get, never):Point;
	#if swc @:getter(particleAttachOffset) #end
	inline private function get_particleAttachOffset():Point {
		return _particleAttachOffset;
	}
	#if swc @:extern #end
	public var mainAnimDef(get, never):JAAnimDef;
	#if swc @:getter(mainAnimDef) #end
	inline private function get_mainAnimDef():JAAnimDef {
		return _mainAnimDef;
	}
	#if swc @:extern #end
	public var imageVector(get, never):Vector<JAImage>;
	#if swc @:getter(imageVector) #end
	inline private function get_imageVector():Vector<JAImage> {
		return _imageVector;
	}
	#if swc @:extern #end
	public var animRect(get, never):Rectangle;
	#if swc @:getter(animRect) #end
	inline private function get_animRect():Rectangle {
		return _animRect;
	}

	//private function AddOnceImageToList(name:String, list:Array<Dynamic>):Void
	//{
	//	var _local4:Int;
	//	var _local3 = null;
	//	_local4 = 0;
	//	while (_local4 < list.length)
	//	{
	//		_local3 = list[_local4];
	//		if (name == _local3.imageName)
	//		{
	//			return;
	//		};
	//		_local4++;
	//	};
	//	list.push({"imageName":name});
	//}
	//
	//public function GetImageFileList(stream:ByteArray, list:Array<Dynamic>):Int
	//{
	//	var _local10:Int;
	//	var _local8 = null;
	//	var _local5 = null;
	//	var _local3 = null;
	//	var _local9:Int;
	//	var _local7:Int;
	//	var _local4:UInt = stream.readUnsignedInt();
	//	if (_local4 != PAM_MAGIC)
	//	{
	//		return Load_MagicError;
	//	};
	//	var version:UInt = stream.readUnsignedInt();
	//	if (version > PAM_VERSION)
	//	{
	//		return Load_VersionError;
	//	};
	//	var temp:Int = stream.readUnsignedByte();
	//	var temp:Int = stream.readShort();
	//	var temp:Int = stream.readShort();
	//	var temp:Int = stream.readShort();
	//	var temp:Int = stream.readShort();
	//	var _local6:Int = stream.readShort();
	//	_local10 = 0;
	//	while (_local10 < _local6)
	//	{
	//		_local8 = ReadString(stream);
	//		_local5 = Remap(_local8);
	//		_local3 = "";
	//		_local9 = _local5.indexOf("(");
	//		_local7 = _local5.indexOf(")");
	//		if (((((!((_local9 == -1))) && (!((_local7 == -1))))) && ((_local9 < _local7))))
	//		{
	//			_local3 = _local5.substr((_local9 + 1), ((_local7 - _local9) - 1)).toLowerCase();
	//			_local5 = (_local5.substr(0, _local9) + _local5.substr((_local7 + 1)));
	//		}
	//		else
	//		{
	//			_local7 = _local5.indexOf("$");
	//			if (_local7 != -1)
	//			{
	//				_local3 = _local5.substr(0, _local7).toLowerCase();
	//				_local5 = _local5.substr((_local7 + 1));
	//			};
	//		};
	//		if (version >= 4)
	//		{
	//			stream.readShort();
	//			stream.readShort();
	//		};
	//		if (version == 1)
	//		{
	//			stream.readShort();
	//			stream.readShort();
	//			stream.readShort();
	//		}
	//		else
	//		{
	//			stream.readInt();
	//			stream.readInt();
	//			stream.readInt();
	//			stream.readInt();
	//			stream.readShort();
	//			stream.readShort();
	//		};
	//		if (_local5.length > 0)
	//		{
	//			AddOnceImageToList(_local5, list);
	//		};
	//		_local10++;
	//	};
	//	return (0);
	//}

	public function LoadPam(steam:ByteArray, texture:GTextureAtlas):Int {
		var i:Int;
		var _local10:Int;
		var _local12:Int;
		var _local5:Int;
		var image:JAImage = null;
		var _local11 = null;
		var _local8:String = null;
		var _local17:String = null;
		var _local3:Float;
		var _local4:Float;
		var _local15:Float;
		var _local16:UInt = steam.readUnsignedInt();
		if (_local16 != PAM_MAGIC) {
			return Load_MagicError;
		};
		_version = steam.readUnsignedInt();
		if (_version > 5) {
			return Load_VersionError;
		};
		_animRate = steam.readUnsignedByte();
		_animRect.x = (steam.readShort() / 20);
		_animRect.y = (steam.readShort() / 20);
		_animRect.width = (steam.readShort() / 20);
		_animRect.height = (steam.readShort() / 20);
		var aNumImages:Int = steam.readShort();
		_imageVector.length = aNumImages;
		i = 0;
		while (i < aNumImages) {
			_imageVector[i] = new JAImage();
		//	_local13++;
		//}
		//_local13 = 0;
		//while (_local13 < _local9)
		//{
			image = _imageVector[i];
			image.drawMode = 0;
			//_local11 = ReadString(steam);
			//_local8 = Remap(_local11);
			_local8 = ReadString(steam);
			//_local17 = "";
			//_local12 = _local8.indexOf("(");
			//_local10 = _local8.indexOf(")");
			//if (((((!((_local12 == -1))) && (!((_local10 == -1))))) && ((_local12 < _local10))))
			//{
			//	_local17 = _local8.substr((_local12 + 1), ((_local10 - _local12) - 1)).toLowerCase();
			//	_local8 = (_local8.substr(0, _local12) + _local8.substr((_local10 + 1)));
			//}
			//else
			//{
			//	_local10 = _local8.indexOf("$");
			//	if (_local10 != -1)
			//	{
			//		_local17 = _local8.substr(0, _local10).toLowerCase();
			//		_local8 = _local8.substr((_local10 + 1));
			//	}
			//}
			image.cols = 1;
			image.rows = 1;
			//_local12 = _local8.indexOf("[");
			//_local10 = _local8.indexOf("]");
			//if (((((!((_local12 == -1))) && (!((_local10 == -1))))) && ((_local12 < _local10))))
			//{
			//	_local17 = _local8.substr((_local12 + 1), ((_local10 - _local12) - 1)).toLowerCase();
			//	_local8 = (_local8.substr(0, _local12) + _local8.substr((_local10 + 1)));
			//	_local5 = _local17.indexOf(",");
			//	if (_local5 != -1)
			//	{
			//		_local6.cols = untyped(_local17.substr(0, _local5));
			//		_local6.rows = untyped(_local17.substr((_local5 + 1)));
			//	}
			//}
			//if (_local17.indexOf("add") != -1)
			//{
			//	_local6.drawMode = 1;
			//}
			//if (_version >= 4)
			{
				image.origWidth = steam.readShort();
				image.origHeight = steam.readShort();
			}
			//else
			//{
			//	_local6.origWidth = -1;
			//	_local6.origHeight = -1;
			//}
			//if (_version == 1)
			//{
			//	_local3 = (steam.readShort() / 1000);
			//	_local4 = Math.sin(_local3);
			//	_local15 = Math.cos(_local3);
			//	_local6.transform.matrix.a = _local15;
			//	_local6.transform.matrix.c = -(_local4);
			//	_local6.transform.matrix.b = _local4;
			//	_local6.transform.matrix.d = _local15;
			//	_local6.transform.matrix.tx = (steam.readShort() / 20);
			//	_local6.transform.matrix.ty = (steam.readShort() / 20);
			//}
			//else
			{
				image.transform.matrix.a = (steam.readInt() / (65536.0 * 20.0));
				image.transform.matrix.c = (steam.readInt() / (65536.0 * 20.0));
				image.transform.matrix.b = (steam.readInt() / (65536.0 * 20.0));
				image.transform.matrix.d = (steam.readInt() / (65536.0 * 20.0));
				image.transform.matrix.tx = (steam.readShort() / 20);
				image.transform.matrix.ty = (steam.readShort() / 20);
				// new
				if ((Math.abs(image.transform.matrix.a - 1.0) < 0.005) 
					&& (image.transform.matrix.b == 0.0) 
					&& (image.transform.matrix.c == 0.0) 
					&& (Math.abs(image.transform.matrix.d - 1.0) < 0.005) 
					&& (image.transform.matrix.tx == 0.0) 
					&& (image.transform.matrix.ty == 0.0)) {
						image.transform.matrix.LoadIdentity();
				}
			}
			image.imageName = _local8;
			if (image.imageName.length > 0) {
				if (texture != null) {
					if (Load_GetImage(image, texture) == false) {
						Load_GetImageNoTexture(image);
					}
				}
				else {
					Load_GetImageNoTexture(image);
				}
			}
			i++;
		}
		var aNumSprites:Int = steam.readShort();
		_mainAnimDef.spriteDefVector.length = aNumSprites;
		i = 0;
		while (i < aNumSprites) {
			_mainAnimDef.spriteDefVector[i] = new JASpriteDef();
		//	i++;
		//}
		//i = 0;
		//while (i < aNumSprites) {
		//	if (LoadSpriteDef(steam, _mainAnimDef.spriteDefVector[i]) == false) {
		//		return Load_LoadSpriteError;
		//	}
			LoadSpriteDef(steam, _mainAnimDef.spriteDefVector[i]);
			i++;
		}
		//var hasMainSpriteDef:Bool = (((_version <= 3)) || (steam.readBoolean()));
		//if (hasMainSpriteDef) {
		//	_mainAnimDef.mainSpriteDef = new JASpriteDef();
		//	if (LoadSpriteDef(steam, _mainAnimDef.mainSpriteDef) == false) {
		//		return Load_LoadMainSpriteError;
		//	}
		//}
		var hasMainSpriteDef:Bool = steam.readBoolean();
		if (hasMainSpriteDef) {
			_mainAnimDef.mainSpriteDef = new JASpriteDef();
			LoadSpriteDef(steam, _mainAnimDef.mainSpriteDef);
		}
		_loaded = true;
		return (0);
	}

	private function Load_GetImageNoTexture(p_theImage:JAImage):Void {
		var _local2:JAMemoryImage = new JAMemoryImage(null);
		_local2.width = p_theImage.origWidth;
		_local2.height = p_theImage.origHeight;
		_local2.loadFlag = 2;
		_local2.texture = null;
		_local2.name = p_theImage.imageName;
		_local2.imageExist = false;
		p_theImage.images.push(_local2);
	}

	private function Load_GetImage(p_theImage:JAImage, p_texture:GTextureAtlas):Bool {
		var _local4:GTexture = p_texture.getSubTexture(p_theImage.imageName);
		if (_local4 == null) {
			return (false);
		}
		var _local3:JAMemoryImage = new JAMemoryImage(null);
		_local3.width = _local4.width;
		_local3.height = _local4.height;
		_local3.loadFlag = JAMemoryImage.Image_Loaded;
		_local3.texture = _local4;
		var bmp:Bitmap = new Bitmap(_local4.g2d_bitmapData);
		bmp.bitmapData.fillRect(new Rectangle(0, 0, _local4.width, _local4.height), 0xFF0000);
		p_theImage.OnMemoryImageLoadCompleted(_local3);
		p_theImage.images.push(_local3);
		return (true);
	}

	private function ReadString(bytes:ByteArray):String {
		var _local2:Int = bytes.readShort();
		return (bytes.readUTFBytes(_local2));
	}

	//private function Remap(str:String):String {
	//	var _local5:UInt;
	//	var _local3:Array<Dynamic> = [];
	//	var _local4 = str;
	//	var _local2:UInt = _remapList.length;
	//	_local5 = 0;
	//	while (_local5 < _local2) {
	//		if (WildcardReplace(str, _remapList[_local5][0], _remapList[_local5][1], _local3)) {
	//			_local4 = _local3[0];
	//			break;
	//		}
	//		_local5++;
	//	}
	//	_local3.splice(0, _local3.length);
	//	_local3 = null;
	//	return (_local4);
	//}
	//
	//private function WildcardReplace(theValue:String, theWildcard:String, theReplacement:String, theResult:Array<Dynamic>):Bool {
	//	var _local6:Int;
	//	var _local5:Int;
	//	var _local7:Int;
	//	var _local8:Bool;
	//	var _local9:Int;
	//	if (theWildcard.length == 0) {
	//		return (false);
	//	}
	//	if (theWildcard.charAt(0) == "*") {
	//		if (theWildcard.length == 1) {
	//			theResult.push(WildcardExpand(theValue, 0, theValue.length, theReplacement));
	//			return (true);
	//		}
	//		if (theWildcard.charAt((theWildcard.length - 1)) == "*") {
	//			_local6 = (theWildcard.length - 2);
	//			_local5 = (theValue.length - _local6);
	//			_local7 = 0;
	//			while (_local7 <= _local5) {
	//				_local8 = true;
	//				_local9 = 0;
	//				while (_local9 < _local6) {
	//					if (theWildcard.charAt((_local9 + 1)).toUpperCase() != theValue.charAt((_local7 + _local9)).toUpperCase()) {
	//						_local8 = false;
	//						break;
	//					}
	//					_local9++;
	//				}
	//				if (_local8) {
	//					theResult.push(WildcardExpand(theValue, _local7, (_local7 + _local6), theReplacement));
	//					return (true);
	//				}
	//				_local7++;
	//			}
	//		}
	//		else {
	//			if (theValue.length < (theWildcard.length - 1)) {
	//				return (false);
	//			}
	//			if (theWildcard.substr(1).toUpperCase() != theValue.substr(((theValue.length - theWildcard.length) + 1)).toUpperCase()) {
	//				return (false);
	//			}
	//			theResult.push(WildcardExpand(theValue, ((theValue.length - theWildcard.length) + 1), theValue.length, theReplacement));
	//			return (true);
	//		}
	//	}
	//	else {
	//		if (theWildcard.charAt((theWildcard.length - 1)) == "*") {
	//			if (theValue.length < (theWildcard.length - 1)) {
	//				return (false);
	//			}
	//			if (theWildcard.substr(0, (theWildcard.length - 1)).toUpperCase() != theValue.substr(0, (theWildcard.length - 1)).toUpperCase()) {
	//				return (false);
	//			}
	//			theResult.push(WildcardExpand(theValue, 0, (theWildcard.length - 1), theReplacement));
	//			return (true);
	//		}
	//		if (theWildcard.toUpperCase() == theValue.toUpperCase()) {
	//			if (theReplacement.length > 0) {
	//				if (theReplacement.charAt(0) == "*") {
	//					theResult.push((theValue + theReplacement.substr(1)));
	//				}
	//				else {
	//					if (theReplacement.charAt((theReplacement.length - 1)) == "*") {
	//						theResult.push((theReplacement.substr(0, (theReplacement.length - 1)) + theValue));
	//					}
	//					else {
	//						theResult.push(theReplacement);
	//					}
	//				}
	//			}
	//			else {
	//				theResult.push(theReplacement);
	//			}
	//			return (true);
	//		}
	//	}
	//	return (false);
	//}
	//
	//private function WildcardExpand(theValue:String, theMatchStart:Int, theMatchEnd:Int, theReplacement:String):String {
	//	var _local5 = null;
	//	if (theReplacement.length == 0) {
	//		_local5 = "";
	//	}
	//	else {
	//		if (theReplacement.charAt(0) == "*") {
	//			if (theReplacement.length == 1) {
	//				_local5 = (theValue.substr(0, theMatchStart) + theValue.substr(theMatchEnd));
	//			}
	//			else {
	//				if (theReplacement.charAt((theReplacement.length - 1)) == "*") {
	//					_local5 = ((theValue.substr(0, theMatchStart) + theReplacement.substr(1, (theReplacement.length - 2))) + theValue.substr(theMatchEnd));
	//				}
	//				else {
	//					_local5 = (theValue.substr(0, theMatchStart) + theReplacement.substr(1, (theReplacement.length - 1)));
	//				}
	//			}
	//		}
	//		else {
	//			if (theReplacement.charAt((theReplacement.length - 1)) == "*") {
	//				_local5 = (theReplacement.substr(0, (theReplacement.length - 1)) + theValue.substr(theMatchEnd));
	//			}
	//			else {
	//				_local5 = theReplacement;
	//			}
	//		}
	//	}
	//	return (_local5);
	//}

	private function LoadSpriteDef(steam:ByteArray, jaSpriteDef:JASpriteDef):Bool {
		var aFrameNum:Int;
		var aRemoveNum:Int;
		var aFrame:JAFrame = null;
		var aFrameFlags:Int;
		var aNumRemoves:Int;
		var anObjectId:Int;
		var aNumAdds:Int;
		var aPopAnimObjectPos:JAObjectPos = null;
		//var _local21:Int;
		var _local24:String = null;
		var _local20:Int;
		//var _local13:Int;
		//var _local7:Int;
		//var _local11:Int;
		var _local14:Float;
		var _local16:Float;
		var _local23:Float;
		//var _local9:JAMatrix3 = null;
		//var _local8:String = null;
		//var _local10:Int;
		//var _local18:Int;
		var _local27:JAObjectDef = null;
		if (_version >= 4) {
			jaSpriteDef.name = ReadString(steam);
			jaSpriteDef.animRate = (steam.readInt() / 0x10000);
			_mainAnimDef.objectNamePool.push(jaSpriteDef.name);
		}
		else {
			jaSpriteDef.name = null;
			jaSpriteDef.animRate = _animRate;
		}
		var aNumFrames:Int = steam.readShort();	// 总时间
		if (_version >= 5) {
			jaSpriteDef.workAreaStart = steam.readShort();
			jaSpriteDef.workAreaDuration = steam.readShort();
		}
		else {
			jaSpriteDef.workAreaStart = 0;
			jaSpriteDef.workAreaDuration = (aNumFrames - 1);
		}
		jaSpriteDef.workAreaDuration = untyped(Math.min((jaSpriteDef.workAreaStart + jaSpriteDef.workAreaDuration), (aNumFrames - 1)) - jaSpriteDef.workAreaStart);
		jaSpriteDef.frames.length = aNumFrames;
		aFrameNum = 0;
		var aCurObjectMap:Dictionary = new Dictionary();
		while (aFrameNum < aNumFrames) {
			jaSpriteDef.frames[aFrameNum] = new JAFrame();
		//	aFrameNum++;
		//}
		//aFrameNum = 0;
		//while (aFrameNum < aNumFrames) {
			aFrame = jaSpriteDef.frames[aFrameNum];
			aFrameFlags = steam.readUnsignedByte();
			if ((aFrameFlags & FRAMEFLAGS_HAS_REMOVES) != 0) {
				aNumRemoves = steam.readByte();
				if (aNumRemoves == 0xFF) {
					aNumRemoves = steam.readShort();
				}
				aRemoveNum = 0;
				while (aRemoveNum < aNumRemoves) {
					anObjectId = steam.readShort();
					if (anObjectId >= 0x7FF) {
						anObjectId = steam.readUnsignedInt();
					}
					//delete aCurObjectMap[anObjectId];
					Reflect.deleteField(aCurObjectMap, anObjectId + "");
					aRemoveNum++;
				}
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_ADDS) != 0) {
				aNumAdds = steam.readByte();
				if (aNumAdds == 0xFF) {
					aNumAdds = steam.readShort();
				}
				var anAddNum:Int = 0;
				while (anAddNum < aNumAdds) {
					aPopAnimObjectPos = new JAObjectPos();
					var anObjectNumAndType:Int = steam.readShort();
					aPopAnimObjectPos.objectNum = (anObjectNumAndType & 0x7FF);
					if (aPopAnimObjectPos.objectNum == 0x7FF) {
						aPopAnimObjectPos.objectNum = steam.readUnsignedInt();
					}
					aPopAnimObjectPos.isSprite = !(((anObjectNumAndType & 0x8000) == 0));
					aPopAnimObjectPos.isAdditive = !(((anObjectNumAndType & 0x4000) == 0));
					aPopAnimObjectPos.resNum = steam.readByte();
					aPopAnimObjectPos.hasSrcRect = false;
					aPopAnimObjectPos.color = JAColor.White;
					aPopAnimObjectPos.animFrameNum = 0;
					aPopAnimObjectPos.timeScale = 1;
					aPopAnimObjectPos.name = null;
					if ((anObjectNumAndType & 0x2000) != 0) {
						aPopAnimObjectPos.preloadFrames = steam.readShort();
					}
					else {
						aPopAnimObjectPos.preloadFrames = 0;
					}
					if ((anObjectNumAndType & 0x1000) != 0) {
						_local24 = ReadString(steam);
						_mainAnimDef.objectNamePool.push(_local24);
						aPopAnimObjectPos.name = _local24;
						_local24 = null;
					}
					if ((anObjectNumAndType & 0x0800) != 0) {
						aPopAnimObjectPos.timeScale = (steam.readUnsignedInt() / 0x10000);
					}
					if (jaSpriteDef.objectDefVector.length < (aPopAnimObjectPos.objectNum + 1)) {
						_local20 = 0;
						while (_local20 < (aPopAnimObjectPos.objectNum + 1)) {
							jaSpriteDef.objectDefVector.push(new JAObjectDef());
							_local20++;
						}
					}
					jaSpriteDef.objectDefVector[aPopAnimObjectPos.objectNum].name = aPopAnimObjectPos.name;
					if (aPopAnimObjectPos.isSprite) {
						jaSpriteDef.objectDefVector[aPopAnimObjectPos.objectNum].spriteDef = _mainAnimDef.spriteDefVector[aPopAnimObjectPos.resNum];
					}
					//_local6[_local25.objectNum] = _local25;
					Reflect.setField(aCurObjectMap, aPopAnimObjectPos.objectNum + "", aPopAnimObjectPos);
					anAddNum++;
				}
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_MOVES) != 0) {
				var aNumMoves:Int = steam.readByte();
				if (aNumMoves == 0xFF) {
					aNumMoves = steam.readShort();
				}
				var aMoveNum:Int = 0;
				while (aMoveNum < aNumMoves) {
					var aFlagsAndObjectNum:Int = steam.readShort();
					var anObjectNum:Int = (aFlagsAndObjectNum & 0x3FF);
					if (anObjectNum == 0x3FF) {
						anObjectNum = steam.readUnsignedInt();
					}
					//_local25 = _local6[anObjectNum];
					aPopAnimObjectPos = Reflect.field(aCurObjectMap, anObjectNum + "");
					aPopAnimObjectPos.transform.matrix.LoadIdentity();
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_MATRIX) != 0) {
						aPopAnimObjectPos.transform.matrix.a = (steam.readInt() / 65536.0);
						aPopAnimObjectPos.transform.matrix.c = (steam.readInt() / 65536.0);
						aPopAnimObjectPos.transform.matrix.b = (steam.readInt() / 65536.0);
						aPopAnimObjectPos.transform.matrix.d = (steam.readInt() / 65536.0);
					}
					else {
						if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_ROTATE) != 0) {
							var aRot:Float = (steam.readShort() / 1000);
							//_local16 = Math.sin(aRot);
							//_local23 = Math.cos(aRot);
							//if (_version == 2) {
							//	_local16 = -(_local16);
							//};
							//aPopAnimObjectPos.transform.matrix.a = _local23;
							//aPopAnimObjectPos.transform.matrix.c = -(_local16);
							//aPopAnimObjectPos.transform.matrix.b = _local16;
							//aPopAnimObjectPos.transform.matrix.d = _local23;
							aPopAnimObjectPos.transform.matrix.LoadIdentity();
							aPopAnimObjectPos.transform.matrix.rotate(aRot);
						}
					}
					var aMatrix:JAMatrix3 = new JAMatrix3();
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_LONGCOORDS) != 0) {
						aMatrix.tx = (steam.readInt() / 20);
						aMatrix.ty = (steam.readInt() / 20);
					}
					else {
						aMatrix.tx = (steam.readShort() / 20);
						aMatrix.ty = (steam.readShort() / 20);
					};
					aPopAnimObjectPos.transform.matrix = JAMatrix3.MulJAMatrix3(aMatrix, aPopAnimObjectPos.transform.matrix, aPopAnimObjectPos.transform.matrix);
					//aPopAnimObjectPos.transform.concat(aMatrix); // new
					//Lib.trace(aPopAnimObjectPos.transform.matrix.toString());
					aPopAnimObjectPos.hasSrcRect = ((aFlagsAndObjectNum & MOVEFLAGS_HAS_SRCRECT) != 0);
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_SRCRECT) != 0) {
						if (aPopAnimObjectPos.srcRect == null) {
							aPopAnimObjectPos.srcRect = new Rectangle();
						}
						aPopAnimObjectPos.srcRect.x = (steam.readShort() / 20);
						aPopAnimObjectPos.srcRect.y = (steam.readShort() / 20);
						aPopAnimObjectPos.srcRect.width = (steam.readShort() / 20);
						aPopAnimObjectPos.srcRect.height = (steam.readShort() / 20);
					}
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_COLOR) != 0) {
						if (aPopAnimObjectPos.color == JAColor.White) {
							aPopAnimObjectPos.color = new JAColor();
						}
						aPopAnimObjectPos.color.red = steam.readUnsignedByte();
						aPopAnimObjectPos.color.green = steam.readUnsignedByte();
						aPopAnimObjectPos.color.blue = steam.readUnsignedByte();
						aPopAnimObjectPos.color.alpha = steam.readUnsignedByte();
					}
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_ANIMFRAMENUM) != 0) {
						aPopAnimObjectPos.animFrameNum = steam.readShort();
					}
					aMoveNum++;
				}
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_FRAME_NAME) != 0) {
				var aFrameName:String = ReadString(steam);
				//aFrameName = Remap(aFrameName).toUpperCase();
				//jaSpriteDef.label[aFrameName] = _local22;
				Reflect.setField(jaSpriteDef.label, aFrameName, aFrameNum);
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_STOP) != 0) {
				aFrame.hasStop = true;
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_COMMANDS) != 0) {
				var aNumCmds:Int = steam.readByte();
				aFrame.commandVector.length = aNumCmds;
				//_local15.commandVector.splice(0, _local15.commandVector.length);
				var aCmdNum:Int = 0;
				while (aCmdNum < aNumCmds) {
					aFrame.commandVector[aCmdNum] = new JACommand();
					//_local15.commandVector.push(new JACommand());
				//	aCmdNum++;
				//}
				//aCmdNum = 0;
				//while (aCmdNum < aNumCmds) {
					//_local15.commandVector[_local19].command = Remap(ReadString(steam));
					//_local15.commandVector[_local19].param = Remap(ReadString(steam));
					aFrame.commandVector[aCmdNum].command = ReadString(steam);
					aFrame.commandVector[aCmdNum].param = ReadString(steam);
					aCmdNum++;
				}
			}
			var aCurObjectNum:Int = 0;
			//for (_local26 in _local6)
			var textureIds:Array<String> = untyped __keys__(aCurObjectMap);
			for (i in 0...textureIds.length) {
				var anObjectPos:JAObjectPos = untyped aCurObjectMap[textureIds[i]];
				aFrame.frameObjectPosVector[aCurObjectNum] = new JAObjectPos();
				aFrame.frameObjectPosVector[aCurObjectNum].clone(anObjectPos);
				anObjectPos.preloadFrames = 0;
				aCurObjectNum++;
			}
			aFrameNum++;
		}
		if (aNumFrames == 0) {
			jaSpriteDef.frames.length = 1;
			jaSpriteDef.frames[0] = new JAFrame();
		}
		//aFrameNum = 0;
		//while (aFrameNum < jaSpriteDef.objectDefVector.length) {
		//	_local27 = jaSpriteDef.objectDefVector[aFrameNum];
		//	aFrameNum++;
		//}
		return (true);
	}

	private static var PAM_MAGIC:UInt = 0xBAF01954;
	private static var PAM_VERSION:UInt = 5;
	private static var FRAMEFLAGS_HAS_REMOVES:UInt = 1;
	private static var FRAMEFLAGS_HAS_ADDS:UInt = 2;
	private static var FRAMEFLAGS_HAS_MOVES:UInt = 4;
	private static var FRAMEFLAGS_HAS_FRAME_NAME:UInt = 8;
	private static var FRAMEFLAGS_HAS_STOP:UInt = 16;
	private static var FRAMEFLAGS_HAS_COMMANDS:UInt = 32;
	private static var MOVEFLAGS_HAS_SRCRECT:UInt = 0x8000;
	private static var MOVEFLAGS_HAS_ROTATE:UInt = 0x4000;
	private static var MOVEFLAGS_HAS_COLOR:UInt = 0x2000;
	private static var MOVEFLAGS_HAS_MATRIX:UInt = 0x1000;
	private static var MOVEFLAGS_HAS_LONGCOORDS:UInt = 0x0800;
	private static var MOVEFLAGS_HAS_ANIMFRAMENUM:UInt = 0x0400;
}
