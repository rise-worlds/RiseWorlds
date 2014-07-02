package com.genome2d.components.renderables.jointanim;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import flash.geom.Point;
import flash.geom.Rectangle;
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
	private var _remapList:Array<Dynamic>;
	private var _particleAttachOffset:Point;
	private var _randUsed:Bool;
	private var _rand:MTRand;
	private var _drawScale:Float;
	private var _imgScale:Float;

	public function new() {
		_randUsed = false;
		_rand = new MTRand();
		_rand.SRand(Math.round(haxe.Timer.stamp() * 1000)); //Timer.stamp();Lib.getTimer()
		_drawScale = 1;
		_imgScale = 1;
		_loaded = false;
		_animRect = new Rectangle();
		_imageVector = new Vector<JAImage>();
		_mainAnimDef = new JAAnimDef();
		_remapList = [];
	}

	public var drawScale(get, never):Float;

	inline private function get_drawScale():Float {
		return _drawScale;
	}

	public var imgScale(get, never):Float;

	inline private function get_imgScale():Float {
		return _imgScale;
	}

	public var loaded(get, never):Bool;

	inline private function get_loaded():Bool {
		return _loaded;
	}

	public var particleAttachOffset(get, never):Point;

	inline private function get_particleAttachOffset():Point {
		return _particleAttachOffset;
	}

	public var mainAnimDef(get, never):JAAnimDef;

	inline private function get_mainAnimDef():JAAnimDef {
		return _mainAnimDef;
	}

	public var imageVector(get, never):Vector<JAImage>;

	inline private function get_imageVector():Vector<JAImage> {
		return _imageVector;
	}

	public var animRect(get, never):Rectangle;

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
		var _local13:Int;
		var _local10:Int;
		var _local12:Int;
		var _local5:Int;
		var _local6:JAImage = null;
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
		var _local9:Int = steam.readShort();
		_imageVector.length = _local9;
		_local13 = 0;
		while (_local13 < _local9) {
			_imageVector[_local13] = new JAImage();
		//	_local13++;
		//}
		//_local13 = 0;
		//while (_local13 < _local9)
		//{
			_local6 = _imageVector[_local13];
			_local6.drawMode = 0;
			_local11 = ReadString(steam);
			_local8 = Remap(_local11);
			_local17 = "";
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
			_local6.cols = 1;
			_local6.rows = 1;
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
				_local6.origWidth = steam.readShort();
				_local6.origHeight = steam.readShort();
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
				_local6.transform.matrix.a = (steam.readInt() / 0x140000);
				_local6.transform.matrix.c = (steam.readInt() / 0x140000);
				_local6.transform.matrix.b = (steam.readInt() / 0x140000);
				_local6.transform.matrix.d = (steam.readInt() / 0x140000);
				_local6.transform.matrix.tx = (steam.readShort() / 20);
				_local6.transform.matrix.ty = (steam.readShort() / 20);
			}
			_local6.imageName = _local8;
			if (_local6.imageName.length > 0) {
				if (texture != null) {
					if (Load_GetImage(_local6, texture) == false) {
						Load_GetImageNoTexture(_local6);
					}
				}
				else {
					Load_GetImageNoTexture(_local6);
				}
			}
			_local13++;
		}
		var _local14:Int = steam.readShort();
		_mainAnimDef.spriteDefVector.length = _local14;
		_local13 = 0;
		while (_local13 < _local14) {
			_mainAnimDef.spriteDefVector[_local13] = new JASpriteDef();
			_local13++;
		}
		_local13 = 0;
		while (_local13 < _local14) {
			if (LoadSpriteDef(steam, _mainAnimDef.spriteDefVector[_local13]) == false) {
				return Load_LoadSpriteError;
			}
			_local13++;
		}
		//var _local7:Bool = (((_version <= 3)) || (steam.readBoolean()));
		//if (_local7) {
		//	_mainAnimDef.mainSpriteDef = new JASpriteDef();
		//	if (LoadSpriteDef(steam, _mainAnimDef.mainSpriteDef) == false) {
		//		return Load_LoadMainSpriteError;
		//	}
		//}
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
		_local3.loadFlag = 2;
		_local3.texture = _local4;
		p_theImage.OnMemoryImageLoadCompleted(_local3);
		p_theImage.images.push(_local3);
		return (true);
	}

	private function ReadString(bytes:ByteArray):String {
		var _local2:Int = bytes.readShort();
		return (bytes.readUTFBytes(_local2));
	}

	private function Remap(str:String):String {
		var _local5:UInt;
		var _local3:Array<Dynamic> = [];
		var _local4 = str;
		var _local2:UInt = _remapList.length;
		_local5 = 0;
		while (_local5 < _local2) {
			if (WildcardReplace(str, _remapList[_local5][0], _remapList[_local5][1], _local3)) {
				_local4 = _local3[0];
				break;
			}
			_local5++;
		}
		_local3.splice(0, _local3.length);
		_local3 = null;
		return (_local4);
	}

	private function WildcardReplace(theValue:String, theWildcard:String, theReplacement:String, theResult:Array<Dynamic>):Bool {
		var _local6:Int;
		var _local5:Int;
		var _local7:Int;
		var _local8:Bool;
		var _local9:Int;
		if (theWildcard.length == 0) {
			return (false);
		}
		if (theWildcard.charAt(0) == "*") {
			if (theWildcard.length == 1) {
				theResult.push(WildcardExpand(theValue, 0, theValue.length, theReplacement));
				return (true);
			}
			if (theWildcard.charAt((theWildcard.length - 1)) == "*") {
				_local6 = (theWildcard.length - 2);
				_local5 = (theValue.length - _local6);
				_local7 = 0;
				while (_local7 <= _local5) {
					_local8 = true;
					_local9 = 0;
					while (_local9 < _local6) {
						if (theWildcard.charAt((_local9 + 1)).toUpperCase() != theValue.charAt((_local7 + _local9)).toUpperCase()) {
							_local8 = false;
							break;
						}
						_local9++;
					}
					if (_local8) {
						theResult.push(WildcardExpand(theValue, _local7, (_local7 + _local6), theReplacement));
						return (true);
					}
					_local7++;
				}
			}
			else {
				if (theValue.length < (theWildcard.length - 1)) {
					return (false);
				}
				if (theWildcard.substr(1).toUpperCase() != theValue.substr(((theValue.length - theWildcard.length) + 1)).toUpperCase()) {
					return (false);
				}
				theResult.push(WildcardExpand(theValue, ((theValue.length - theWildcard.length) + 1), theValue.length, theReplacement));
				return (true);
			}
		}
		else {
			if (theWildcard.charAt((theWildcard.length - 1)) == "*") {
				if (theValue.length < (theWildcard.length - 1)) {
					return (false);
				}
				if (theWildcard.substr(0, (theWildcard.length - 1)).toUpperCase() != theValue.substr(0, (theWildcard.length - 1)).toUpperCase()) {
					return (false);
				}
				theResult.push(WildcardExpand(theValue, 0, (theWildcard.length - 1), theReplacement));
				return (true);
			}
			if (theWildcard.toUpperCase() == theValue.toUpperCase()) {
				if (theReplacement.length > 0) {
					if (theReplacement.charAt(0) == "*") {
						theResult.push((theValue + theReplacement.substr(1)));
					}
					else {
						if (theReplacement.charAt((theReplacement.length - 1)) == "*") {
							theResult.push((theReplacement.substr(0, (theReplacement.length - 1)) + theValue));
						}
						else {
							theResult.push(theReplacement);
						}
					}
				}
				else {
					theResult.push(theReplacement);
				}
				return (true);
			}
		}
		return (false);
	}

	private function WildcardExpand(theValue:String, theMatchStart:Int, theMatchEnd:Int, theReplacement:String):String {
		var _local5 = null;
		if (theReplacement.length == 0) {
			_local5 = "";
		}
		else {
			if (theReplacement.charAt(0) == "*") {
				if (theReplacement.length == 1) {
					_local5 = (theValue.substr(0, theMatchStart) + theValue.substr(theMatchEnd));
				}
				else {
					if (theReplacement.charAt((theReplacement.length - 1)) == "*") {
						_local5 = ((theValue.substr(0, theMatchStart) + theReplacement.substr(1, (theReplacement.length - 2))) + theValue.substr(theMatchEnd));
					}
					else {
						_local5 = (theValue.substr(0, theMatchStart) + theReplacement.substr(1, (theReplacement.length - 1)));
					}
				}
			}
			else {
				if (theReplacement.charAt((theReplacement.length - 1)) == "*") {
					_local5 = (theReplacement.substr(0, (theReplacement.length - 1)) + theValue.substr(theMatchEnd));
				}
				else {
					_local5 = theReplacement;
				}
			}
		}
		return (_local5);
	}

	private function LoadSpriteDef(steam:ByteArray, jaSpriteDef:JASpriteDef):Bool {
		var _local22:Int;
		var _local19:Int;
		var _local15:JAFrame = null;
		var _local4:Int;
		var _local3:Int;
		var _local17:Int;
		var _local12:Int;
		var _local25:JAObjectPos = null;
		var _local21:Int;
		var _local24:String = null;
		var _local20:Int;
		var _local13:Int;
		var _local7:Int;
		var _local11:Int;
		var _local14:Float;
		var _local16:Float;
		var _local23:Float;
		var _local9:JAMatrix3 = null;
		var _local8:String = null;
		var _local10:Int;
		var _local18:Int;
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
		var _local5:Int = steam.readShort();
		if (_version >= 5) {
			jaSpriteDef.workAreaStart = steam.readShort();
			jaSpriteDef.workAreaDuration = steam.readShort();
		}
		else {
			jaSpriteDef.workAreaStart = 0;
			jaSpriteDef.workAreaDuration = (_local5 - 1);
		}
		jaSpriteDef.workAreaDuration = untyped(Math.min((jaSpriteDef.workAreaStart + jaSpriteDef.workAreaDuration), (_local5 - 1)) - jaSpriteDef.workAreaStart);
		jaSpriteDef.frames.length = _local5;
		_local22 = 0;
		while (_local22 < _local5) {
			jaSpriteDef.frames[_local22] = new JAFrame();
			_local22++;
		}
		var _local6:Dictionary = new Dictionary();
		_local22 = 0;
		while (_local22 < _local5) {
			_local15 = jaSpriteDef.frames[_local22];
			_local4 = steam.readUnsignedByte();
			if ((_local4 & 1) != 0) {
				_local3 = steam.readByte();
				if (_local3 == 0xFF) {
					_local3 = steam.readShort();
				};
				_local19 = 0;
				while (_local19 < _local3) {
					_local17 = steam.readShort();
					if (_local17 >= 0x7FF) {
						_local17 = steam.readUnsignedInt();
					}
					//delete _local6[_local17];
					Reflect.deleteField(_local6, _local17 + "");
					_local19++;
				}
			}
			if ((_local4 & 2) != 0) {
				_local12 = steam.readByte();
				if (_local12 == 0xFF) {
					_local12 = steam.readShort();
				}
				_local19 = 0;
				while (_local19 < _local12) {
					_local25 = new JAObjectPos();
					_local21 = steam.readShort();
					_local25.objectNum = (_local21 & 0x7FF);
					if (_local25.objectNum == 0x7FF) {
						_local25.objectNum = steam.readUnsignedInt();
					}
					_local25.isSprite = !(((_local21 & 0x8000) == 0));
					_local25.isAdditive = !(((_local21 & 0x4000) == 0));
					_local25.resNum = steam.readByte();
					_local25.hasSrcRect = false;
					_local25.color = JAColor.White;
					_local25.animFrameNum = 0;
					_local25.timeScale = 1;
					_local25.name = null;
					if ((_local21 & 0x2000) != 0) {
						_local25.preloadFrames = steam.readShort();
					}
					else {
						_local25.preloadFrames = 0;
					}
					if ((_local21 & 0x1000) != 0) {
						_local24 = ReadString(steam);
						_mainAnimDef.objectNamePool.push(_local24);
						_local25.name = _local24;
						_local24 = null;
					}
					if ((_local21 & 0x0800) != 0) {
						_local25.timeScale = (steam.readUnsignedInt() / 65536);
					}
					if (jaSpriteDef.objectDefVector.length < (_local25.objectNum + 1)) {
						_local20 = 0;
						while (_local20 < (_local25.objectNum + 1)) {
							jaSpriteDef.objectDefVector.push(new JAObjectDef());
							_local20++;
						}
					}
					jaSpriteDef.objectDefVector[_local25.objectNum].name = _local25.name;
					if (_local25.isSprite) {
						jaSpriteDef.objectDefVector[_local25.objectNum].spriteDef = _mainAnimDef.spriteDefVector[_local25.resNum];
					}
					//_local6[_local25.objectNum] = _local25;
					Reflect.setField(_local6, _local25.objectNum + "", _local25);
					_local19++;
				}
			}
			if ((_local4 & 4) != 0) {
				_local13 = steam.readByte();
				if (_local13 == 0xFF) {
					_local13 = steam.readShort();
				}
				_local19 = 0;
				while (_local19 < _local13) {
					_local7 = steam.readShort();
					_local11 = (_local7 & 0x3FF);
					if (_local11 == 0x3FF) {
						_local11 = steam.readUnsignedInt();
					}
					//_local25 = _local6[_local11];
					_local25 = Reflect.field(_local6, _local11 + "");
					_local25.transform.matrix.LoadIdentity();
					if ((_local7 & 0x1000) != 0) {
						_local25.transform.matrix.a = (steam.readInt() / 0x10000);
						_local25.transform.matrix.c = (steam.readInt() / 0x10000);
						_local25.transform.matrix.b = (steam.readInt() / 0x10000);
						_local25.transform.matrix.d = (steam.readInt() / 0x10000);
					}
					else {
						if ((_local7 & 0x4000) != 0) {
							_local14 = (steam.readShort() / 1000);
							_local16 = Math.sin(_local14);
							_local23 = Math.cos(_local14);
							if (_version == 2) {
								_local16 = -(_local16);
							};
							_local25.transform.matrix.a = _local23;
							_local25.transform.matrix.c = -(_local16);
							_local25.transform.matrix.b = _local16;
							_local25.transform.matrix.d = _local23;
						}
					}
					_local9 = new JAMatrix3();
					if ((_local7 & 0x0800) != 0) {
						_local9.tx = (steam.readInt() / 20);
						_local9.ty = (steam.readInt() / 20);
					}
					else {
						_local9.tx = (steam.readShort() / 20);
						_local9.ty = (steam.readShort() / 20);
					};
					_local25.transform.matrix = JAMatrix3.MulJAMatrix3(_local9, _local25.transform.matrix, _local25.transform.matrix);
					_local25.hasSrcRect = !(((_local7 & 0x8000) == 0));
					if ((_local7 & 0x8000) != 0) {
						if (_local25.srcRect == null) {
							_local25.srcRect = new Rectangle();
						}
						_local25.srcRect.x = (steam.readShort() / 20);
						_local25.srcRect.y = (steam.readShort() / 20);
						_local25.srcRect.width = (steam.readShort() / 20);
						_local25.srcRect.height = (steam.readShort() / 20);
					}
					if ((_local7 & 0x2000) != 0) {
						if (_local25.color == JAColor.White) {
							_local25.color = new JAColor();
						}
						_local25.color.red = steam.readUnsignedByte();
						_local25.color.green = steam.readUnsignedByte();
						_local25.color.blue = steam.readUnsignedByte();
						_local25.color.alpha = steam.readUnsignedByte();
					}
					if ((_local7 & 0x0400) != 0) {
						_local25.animFrameNum = steam.readShort();
					}
					_local19++;
				}
			}
			if ((_local4 & 8) != 0) {
				_local8 = ReadString(steam);
				_local8 = Remap(_local8).toUpperCase();
				//jaSpriteDef.label[_local8] = _local22;
				Reflect.setField(jaSpriteDef.label, _local8, _local22);
			}
			if ((_local4 & 16) != 0) {
				_local15.hasStop = true;
			}
			if ((_local4 & 32) != 0) {
				_local10 = steam.readByte();
				_local15.commandVector.length = _local10;
				//_local15.commandVector.splice(0, _local15.commandVector.length);
				_local19 = 0;
				while (_local19 < _local10) {
					_local15.commandVector[_local19] = new JACommand();
					//_local15.commandVector.push(new JACommand());
					_local19++;
				}
				_local19 = 0;
				while (_local19 < _local10) {
					_local15.commandVector[_local19].command = Remap(ReadString(steam));
					_local15.commandVector[_local19].param = Remap(ReadString(steam));
					_local19++;
				}
			}
			_local18 = 0;
			//for (_local26 in _local6)
			var textureIds:Array<String> = untyped __keys__(_local6);
			for (i in 0...textureIds.length) {
				var _local26:JAObjectPos = untyped _local6[textureIds[i]];
				_local15.frameObjectPosVector[_local18] = new JAObjectPos();
				_local15.frameObjectPosVector[_local18].clone(_local26);
				_local26.preloadFrames = 0;
				_local18++;
			}
			_local22++;
		}
		if (_local5 == 0) {
			jaSpriteDef.frames.length = 1;
			jaSpriteDef.frames[0] = new JAFrame();
		}
		_local22 = 0;
		while (_local22 < jaSpriteDef.objectDefVector.length) {
			_local27 = jaSpriteDef.objectDefVector[_local22];
			_local22++;
		}
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
