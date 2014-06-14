package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;
    import com.flengine.components.renderables.*;
    import com.flengine.rand.*;
    import com.flengine.textures.*;
    import flash.geom.*;
    import flash.utils.*;

    public class JointAnimate extends Object
    {
        private var _loaded:Boolean;
        private var _version:uint;
        private var _animRate:int;
        private var _animRect:Rectangle;
        private var _imageVector:Vector.<JAImage>;
        private var _mainAnimDef:JAAnimDef;
        private var _remapList:Array;
        private var _particleAttachOffset:Point;
        private var _randUsed:Boolean;
        private var _rand:MTRand;
        private var _drawScale:Number;
        private var _imgScale:Number;
        public static const Load_Successed:int = 0;
        public static const Load_MagicError:int = -1;
        public static const Load_VersionError:int = -2;
        public static const Load_Failed:int = -3;
        public static const Load_LoadSpriteError:int = -4;
        public static const Load_LoadMainSpriteError:int = -5;
        public static const Load_GetImageTextureAtlasError:int = -6;
        public static var ImageSearchPathVector:Array = [];

        public function JointAnimate()
        {
            _randUsed = false;
            _rand = new MTRand();
            _rand.SRand(this.getTimer());
            _drawScale = 1;
            _imgScale = 1;
            _loaded = false;
            _animRect = new Rectangle();
            _imageVector = new Vector.<JAImage>;
            _mainAnimDef = new JAAnimDef();
            _remapList = [];
            return;
        }

        public function get drawScale() : Number
        {
            return _drawScale;
        }

        public function get imgScale() : Number
        {
            return _imgScale;
        }

        public function get loaded() : Boolean
        {
            return _loaded;
        }

        public function get particleAttachOffset() : Point
        {
            return _particleAttachOffset;
        }

        public function get mainAnimDef() : JAAnimDef
        {
            return _mainAnimDef;
        }

        public function get imageVector() : Vector.<JAImage>
        {
            return _imageVector;
        }

        public function get animRect() : Rectangle
        {
            return _animRect;
        }

        private function AddOnceImageToList(param1:String, param2:Array) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = null;
            _loc_4 = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3 = param2[_loc_4];
                if (param1 == _loc_3.imageName)
                {
                    return;
                }
                _loc_4++;
            }
            param2.push({imageName:param1});
            return;
        }

        public function GetImageFileList(param1:ByteArray, param2:Array) : int
        {
            var _loc_10:* = 0;
            var _loc_8:* = null;
            var _loc_5:* = null;
            var _loc_3:* = null;
            var _loc_9:* = 0;
            var _loc_7:* = 0;
            var _loc_4:* = param1.readUnsignedInt();
            if (param1.readUnsignedInt() != PAM_MAGIC)
            {
                return Load_MagicError;
            }
            var _loc_11:* = param1.readUnsignedInt();
            if (param1.readUnsignedInt() > PAM_VERSION)
            {
                return Load_VersionError;
            }
            param1.readUnsignedByte();
            param1.readShort();
            param1.readShort();
            param1.readShort();
            param1.readShort();
            var _loc_6:* = param1.readShort();
            _loc_10 = 0;
            while (_loc_10 < _loc_6)
            {
                
                _loc_8 = ReadString(param1);
                _loc_5 = Remap(_loc_8);
                _loc_3 = "";
                _loc_9 = _loc_5.indexOf("(");
                _loc_7 = _loc_5.indexOf(")");
                if (_loc_9 != -1 && _loc_7 != -1 && _loc_9 < _loc_7)
                {
                    _loc_3 = _loc_5.substr((_loc_9 + 1), _loc_7 - _loc_9 - 1).toLowerCase();
                    _loc_5 = _loc_5.substr(0, _loc_9) + _loc_5.substr((_loc_7 + 1));
                }
                else
                {
                    _loc_7 = _loc_5.indexOf("$");
                    if (_loc_7 != -1)
                    {
                        _loc_3 = _loc_5.substr(0, _loc_7).toLowerCase();
                        _loc_5 = _loc_5.substr((_loc_7 + 1));
                    }
                }
                if (_loc_11 >= 4)
                {
                    param1.readShort();
                    param1.readShort();
                }
                if (_loc_11 == 1)
                {
                    param1.readShort();
                    param1.readShort();
                    param1.readShort();
                }
                else
                {
                    param1.readInt();
                    param1.readInt();
                    param1.readInt();
                    param1.readInt();
                    param1.readShort();
                    param1.readShort();
                }
                if (_loc_5.length > 0)
                {
                    AddOnceImageToList(_loc_5, param2);
                }
                _loc_10++;
            }
            return Load_Successed;
        }

        public function LoadPam(param1:ByteArray, param2:FTextureAtlas) : int
        {
            var _loc_13:* = 0;
            var _loc_10:* = 0;
            var _loc_12:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_11:* = null;
            var _loc_8:* = null;
            var _loc_17:* = null;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = param1.readUnsignedInt();
            if (param1.readUnsignedInt() != PAM_MAGIC)
            {
                return Load_MagicError;
            }
            _version = param1.readUnsignedInt();
            if (_version > PAM_VERSION)
            {
                return Load_VersionError;
            }
            _animRate = param1.readUnsignedByte();
            _animRect.x = param1.readShort() / 20;
            _animRect.y = param1.readShort() / 20;
            _animRect.width = param1.readShort() / 20;
            _animRect.height = param1.readShort() / 20;
            var _loc_9:* = param1.readShort();
            _imageVector.length = _loc_9;
            _loc_13 = 0;
            while (_loc_13 < _loc_9)
            {
                
                _imageVector[_loc_13] = new JAImage();
                _loc_13++;
            }
            _loc_13 = 0;
            while (_loc_13 < _loc_9)
            {
                
                _loc_6 = _imageVector[_loc_13];
                _loc_6.drawMode = JAAnimRenderMode.DRAWMODE_NORMAL;
                _loc_11 = ReadString(param1);
                _loc_8 = Remap(_loc_11);
                _loc_17 = "";
                _loc_12 = _loc_8.indexOf("(");
                _loc_10 = _loc_8.indexOf(")");
                if (_loc_12 != -1 && _loc_10 != -1 && _loc_12 < _loc_10)
                {
                    _loc_17 = _loc_8.substr((_loc_12 + 1), _loc_10 - _loc_12 - 1).toLowerCase();
                    _loc_8 = _loc_8.substr(0, _loc_12) + _loc_8.substr((_loc_10 + 1));
                }
                else
                {
                    _loc_10 = _loc_8.indexOf("$");
                    if (_loc_10 != -1)
                    {
                        _loc_17 = _loc_8.substr(0, _loc_10).toLowerCase();
                        _loc_8 = _loc_8.substr((_loc_10 + 1));
                    }
                }
                _loc_6.cols = 1;
                _loc_6.rows = 1;
                _loc_12 = _loc_8.indexOf("[");
                _loc_10 = _loc_8.indexOf("]");
                if (_loc_12 != -1 && _loc_10 != -1 && _loc_12 < _loc_10)
                {
                    _loc_17 = _loc_8.substr((_loc_12 + 1), _loc_10 - _loc_12 - 1).toLowerCase();
                    _loc_8 = _loc_8.substr(0, _loc_12) + _loc_8.substr((_loc_10 + 1));
                    _loc_5 = _loc_17.indexOf(",");
                    if (_loc_5 != -1)
                    {
                        _loc_6.cols = _loc_17.substr(0, _loc_5);
                        _loc_6.rows = _loc_17.substr((_loc_5 + 1));
                    }
                }
                if (_loc_17.indexOf("add") != -1)
                {
                    _loc_6.drawMode = JAAnimRenderMode.DRAWMODE_ADDITIVE;
                }
                if (_version >= 4)
                {
                    _loc_6.origWidth = param1.readShort();
                    _loc_6.origHeight = param1.readShort();
                }
                else
                {
                    _loc_6.origWidth = -1;
                    _loc_6.origHeight = -1;
                }
                if (_version == 1)
                {
                    _loc_3 = param1.readShort() / 1000;
                    _loc_4 = Math.sin(_loc_3);
                    _loc_15 = Math.cos(_loc_3);
                    _loc_6.transform.matrix.m00 = _loc_15;
                    _loc_6.transform.matrix.m01 = -_loc_4;
                    _loc_6.transform.matrix.m10 = _loc_4;
                    _loc_6.transform.matrix.m11 = _loc_15;
                    _loc_6.transform.matrix.m02 = param1.readShort() / 20;
                    _loc_6.transform.matrix.m12 = param1.readShort() / 20;
                }
                else
                {
                    _loc_6.transform.matrix.m00 = param1.readInt() / (65536 * 20);
                    _loc_6.transform.matrix.m01 = param1.readInt() / (65536 * 20);
                    _loc_6.transform.matrix.m10 = param1.readInt() / (65536 * 20);
                    _loc_6.transform.matrix.m11 = param1.readInt() / (65536 * 20);
                    _loc_6.transform.matrix.m02 = param1.readShort() / 20;
                    _loc_6.transform.matrix.m12 = param1.readShort() / 20;
                }
                _loc_6.imageName = _loc_8;
                if (_loc_6.imageName.length > 0)
                {
                    if (param2 != null)
                    {
                        if (Load_GetImage(_loc_6, param2) == false)
                        {
                            Load_GetImageNoTexture(_loc_6);
                        }
                    }
                    else
                    {
                        Load_GetImageNoTexture(_loc_6);
                    }
                }
                _loc_13++;
            }
            var _loc_14:* = param1.readShort();
            _mainAnimDef.spriteDefVector.length = _loc_14;
            _loc_13 = 0;
            while (_loc_13 < _loc_14)
            {
                
                _mainAnimDef.spriteDefVector[_loc_13] = new JASpriteDef();
                _loc_13++;
            }
            _loc_13 = 0;
            while (_loc_13 < _loc_14)
            {
                
                if (LoadSpriteDef(param1, _mainAnimDef.spriteDefVector[_loc_13]) == false)
                {
                    return Load_LoadSpriteError;
                }
                _loc_13++;
            }
            var _loc_7:* = _version <= 3 || param1.readBoolean();
            if (_version <= 3 || param1.readBoolean())
            {
                _mainAnimDef.mainSpriteDef = new JASpriteDef();
                if (LoadSpriteDef(param1, _mainAnimDef.mainSpriteDef) == false)
                {
                    return Load_LoadMainSpriteError;
                }
            }
            _loaded = true;
            return Load_Successed;
        }

        private function Load_GetImageNoTexture(param1:JAImage) : void
        {
            var _loc_2:* = new JAMemoryImage(null);
            _loc_2.width = param1.origWidth;
            _loc_2.height = param1.origHeight;
            _loc_2.loadFlag = 2;
            _loc_2.texture = null;
            _loc_2.name = param1.imageName;
            _loc_2.imageExist = false;
            param1.images.push(_loc_2);
            return;
        }

        private function Load_GetImage(param1:JAImage, param2:FTextureAtlas) : Boolean
        {
            var _loc_4:* = param2.getTexture(param1.imageName);
            if (param2.getTexture(param1.imageName) == null)
            {
                return false;
            }
            var _loc_3:* = new JAMemoryImage(null);
            _loc_3.width = _loc_4.frameWidth;
            _loc_3.height = _loc_4.frameHeight;
            _loc_3.loadFlag = JAMemoryImage.Image_Loaded;
            _loc_3.texture = _loc_4;
            param1.OnMemoryImageLoadCompleted(_loc_3);
            param1.images.push(_loc_3);
            return true;
        }

        private function ReadString(param1:ByteArray) : String
        {
            var _loc_2:* = param1.readShort();
            return param1.readUTFBytes(_loc_2);
        }

        private function Remap(param1:String) : String
        {
            var _loc_5:* = 0;
            var _loc_3:* = [];
            var _loc_4:* = param1;
            var _loc_2:* = _remapList.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_2)
            {
                
                if (WildcardReplace(param1, _remapList[_loc_5][0], _remapList[_loc_5][1], _loc_3))
                {
                    _loc_4 = _loc_3[0];
                    break;
                }
                _loc_5 = _loc_5 + 1;
            }
            _loc_3.splice(0);
            _loc_3 = null;
            return _loc_4;
        }

        private function WildcardReplace(param1:String, param2:String, param3:String, param4:Array) : Boolean
        {
            var _loc_6:* = 0;
            var _loc_5:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = false;
            var _loc_9:* = 0;
            if (param2.length == 0)
            {
                return false;
            }
            if (param2.charAt(0) == "*")
            {
                if (param2.length == 1)
                {
                    param4.push(WildcardExpand(param1, 0, param1.length, param3));
                    return true;
                }
                if (param2.charAt((param2.length - 1)) == "*")
                {
                    _loc_6 = param2.length - 2;
                    _loc_5 = param1.length - _loc_6;
                    _loc_7 = 0;
                    while (_loc_7 <= _loc_5)
                    {
                        
                        _loc_8 = true;
                        _loc_9 = 0;
                        while (_loc_9 < _loc_6)
                        {
                            
                            if (param2.charAt((_loc_9 + 1)).toUpperCase() != param1.charAt(_loc_7 + _loc_9).toUpperCase())
                            {
                                _loc_8 = false;
                                break;
                            }
                            _loc_9++;
                        }
                        if (_loc_8)
                        {
                            param4.push(WildcardExpand(param1, _loc_7, _loc_7 + _loc_6, param3));
                            return true;
                        }
                        _loc_7++;
                    }
                }
                else
                {
                    if (param1.length < (param2.length - 1))
                    {
                        return false;
                    }
                    if (param2.substr(1).toUpperCase() != param1.substr(param1.length - param2.length + 1).toUpperCase())
                    {
                        return false;
                    }
                    param4.push(WildcardExpand(param1, param1.length - param2.length + 1, param1.length, param3));
                    return true;
                }
            }
            else
            {
                if (param2.charAt((param2.length - 1)) == "*")
                {
                    if (param1.length < (param2.length - 1))
                    {
                        return false;
                    }
                    if (param2.substr(0, (param2.length - 1)).toUpperCase() != param1.substr(0, (param2.length - 1)).toUpperCase())
                    {
                        return false;
                    }
                    param4.push(WildcardExpand(param1, 0, (param2.length - 1), param3));
                    return true;
                }
                if (param2.toUpperCase() == param1.toUpperCase())
                {
                    if (param3.length > 0)
                    {
                        if (param3.charAt(0) == "*")
                        {
                            param4.push(param1 + param3.substr(1));
                        }
                        else if (param3.charAt((param3.length - 1)) == "*")
                        {
                            param4.push(param3.substr(0, (param3.length - 1)) + param1);
                        }
                        else
                        {
                            param4.push(param3);
                        }
                    }
                    else
                    {
                        param4.push(param3);
                    }
                    return true;
                }
            }
            return false;
        }

        private function WildcardExpand(param1:String, param2:int, param3:int, param4:String) : String
        {
            var _loc_5:* = null;
            if (param4.length == 0)
            {
                _loc_5 = "";
            }
            else if (param4.charAt(0) == "*")
            {
                if (param4.length == 1)
                {
                    _loc_5 = param1.substr(0, param2) + param1.substr(param3);
                }
                else if (param4.charAt((param4.length - 1)) == "*")
                {
                    _loc_5 = param1.substr(0, param2) + param4.substr(1, param4.length - 2) + param1.substr(param3);
                }
                else
                {
                    _loc_5 = param1.substr(0, param2) + param4.substr(1, (param4.length - 1));
                }
            }
            else if (param4.charAt((param4.length - 1)) == "*")
            {
                _loc_5 = param4.substr(0, (param4.length - 1)) + param1.substr(param3);
            }
            else
            {
                _loc_5 = param4;
            }
            return _loc_5;
        }

        private function LoadSpriteDef(param1:ByteArray, param2:JASpriteDef) : Boolean
        {
            var _loc_22:* = 0;
            var _loc_19:* = 0;
            var _loc_15:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = 0;
            var _loc_17:* = 0;
            var _loc_12:* = 0;
            var _loc_25:* = null;
            var _loc_21:* = 0;
            var _loc_24:* = null;
            var _loc_20:* = 0;
            var _loc_13:* = 0;
            var _loc_7:* = 0;
            var _loc_11:* = 0;
            var _loc_14:* = NaN;
            var _loc_16:* = NaN;
            var _loc_23:* = NaN;
            var _loc_9:* = null;
            var _loc_8:* = null;
            var _loc_10:* = 0;
            var _loc_18:* = 0;
            var _loc_27:* = null;
            if (_version >= 4)
            {
                param2.name = ReadString(param1);
                param2.animRate = param1.readInt() / 65536;
                _mainAnimDef.objectNamePool.push(param2.name);
            }
            else
            {
                param2.name = null;
                param2.animRate = _animRate;
            }
            var _loc_5:* = param1.readShort();
            if (_version >= 5)
            {
                param2.workAreaStart = param1.readShort();
                param2.workAreaDuration = param1.readShort();
            }
            else
            {
                param2.workAreaStart = 0;
                param2.workAreaDuration = _loc_5 - 1;
            }
            param2.workAreaDuration = Math.min(param2.workAreaStart + param2.workAreaDuration, (_loc_5 - 1)) - param2.workAreaStart;
            param2.frames.length = _loc_5;
            _loc_22 = 0;
            while (_loc_22 < _loc_5)
            {
                
                param2.frames[_loc_22] = new JAFrame();
                _loc_22++;
            }
            var _loc_6:* = new Dictionary();
            _loc_22 = 0;
            while (_loc_22 < _loc_5)
            {
                
                _loc_15 = param2.frames[_loc_22];
                _loc_4 = param1.readUnsignedByte();
                if (_loc_4 & FRAMEFLAGS_HAS_REMOVES)
                {
                    _loc_3 = param1.readByte();
                    if (_loc_3 == 255)
                    {
                        _loc_3 = param1.readShort();
                    }
                    _loc_19 = 0;
                    while (_loc_19 < _loc_3)
                    {
                        
                        _loc_17 = param1.readShort();
                        if (_loc_17 >= 2047)
                        {
                            _loc_17 = param1.readUnsignedInt();
                        }
                        delete _loc_6[_loc_17];
                        _loc_19++;
                    }
                }
                if (_loc_4 & FRAMEFLAGS_HAS_ADDS)
                {
                    _loc_12 = param1.readByte();
                    if (_loc_12 == 255)
                    {
                        _loc_12 = param1.readShort();
                    }
                    _loc_19 = 0;
                    while (_loc_19 < _loc_12)
                    {
                        
                        _loc_25 = new JAObjectPos();
                        _loc_21 = param1.readShort();
                        _loc_25.objectNum = _loc_21 & 2047;
                        if (_loc_25.objectNum == 2047)
                        {
                            _loc_25.objectNum = param1.readUnsignedInt();
                        }
                        _loc_25.isSprite = (_loc_21 & 32768) != 0;
                        _loc_25.isAdditive = (_loc_21 & 16384) != 0;
                        _loc_25.resNum = param1.readByte();
                        _loc_25.hasSrcRect = false;
                        _loc_25.color = JAColor.White;
                        _loc_25.animFrameNum = 0;
                        _loc_25.timeScale = 1;
                        _loc_25.name = null;
                        if ((_loc_21 & 8192) != 0)
                        {
                            _loc_25.preloadFrames = param1.readShort();
                        }
                        else
                        {
                            _loc_25.preloadFrames = 0;
                        }
                        if (_loc_21 & 4096)
                        {
                            _loc_24 = ReadString(param1);
                            _mainAnimDef.objectNamePool.push(_loc_24);
                            _loc_25.name = _loc_24;
                            _loc_24 = null;
                        }
                        if (_loc_21 & 2048)
                        {
                            _loc_25.timeScale = param1.readUnsignedInt() / 65536;
                        }
                        if (param2.objectDefVector.length < (_loc_25.objectNum + 1))
                        {
                            _loc_20 = 0;
                            while (_loc_20 < (_loc_25.objectNum + 1))
                            {
                                
                                param2.objectDefVector.push(new JAObjectDef());
                                _loc_20++;
                            }
                        }
                        param2.objectDefVector[_loc_25.objectNum].name = _loc_25.name;
                        if (_loc_25.isSprite)
                        {
                            param2.objectDefVector[_loc_25.objectNum].spriteDef = _mainAnimDef.spriteDefVector[_loc_25.resNum];
                        }
                        _loc_6[_loc_25.objectNum] = _loc_25;
                        _loc_19++;
                    }
                }
                if (_loc_4 & FRAMEFLAGS_HAS_MOVES)
                {
                    _loc_13 = param1.readByte();
                    if (_loc_13 == 255)
                    {
                        _loc_13 = param1.readShort();
                    }
                    _loc_19 = 0;
                    while (_loc_19 < _loc_13)
                    {
                        
                        _loc_7 = param1.readShort();
                        _loc_11 = _loc_7 & 1023;
                        if (_loc_11 == 1023)
                        {
                            _loc_11 = param1.readUnsignedInt();
                        }
                        _loc_25 = _loc_6[_loc_11];
                        _loc_25.transform.matrix.LoadIdentity();
                        if (_loc_7 & MOVEFLAGS_HAS_MATRIX)
                        {
                            _loc_25.transform.matrix.m00 = param1.readInt() / 65536;
                            _loc_25.transform.matrix.m01 = param1.readInt() / 65536;
                            _loc_25.transform.matrix.m10 = param1.readInt() / 65536;
                            _loc_25.transform.matrix.m11 = param1.readInt() / 65536;
                        }
                        else if (_loc_7 & MOVEFLAGS_HAS_ROTATE)
                        {
                            _loc_14 = param1.readShort() / 1000;
                            _loc_16 = Math.sin(_loc_14);
                            _loc_23 = Math.cos(_loc_14);
                            if (_version == 2)
                            {
                                _loc_16 = -_loc_16;
                            }
                            _loc_25.transform.matrix.m00 = _loc_23;
                            _loc_25.transform.matrix.m01 = -_loc_16;
                            _loc_25.transform.matrix.m10 = _loc_16;
                            _loc_25.transform.matrix.m11 = _loc_23;
                        }
                        _loc_9 = new JAMatrix3();
                        if (_loc_7 & MOVEFLAGS_HAS_LONGCOORDS)
                        {
                            _loc_9.m02 = param1.readInt() / 20;
                            _loc_9.m12 = param1.readInt() / 20;
                        }
                        else
                        {
                            _loc_9.m02 = param1.readShort() / 20;
                            _loc_9.m12 = param1.readShort() / 20;
                        }
                        _loc_25.transform.matrix = JAMatrix3.MulJAMatrix3(_loc_9, _loc_25.transform.matrix, _loc_25.transform.matrix);
                        _loc_25.hasSrcRect = (_loc_7 & MOVEFLAGS_HAS_SRCRECT) != 0;
                        if (_loc_7 & MOVEFLAGS_HAS_SRCRECT)
                        {
                            if (_loc_25.srcRect == null)
                            {
                                _loc_25.srcRect = new Rectangle();
                            }
                            _loc_25.srcRect.x = param1.readShort() / 20;
                            _loc_25.srcRect.y = param1.readShort() / 20;
                            _loc_25.srcRect.width = param1.readShort() / 20;
                            _loc_25.srcRect.height = param1.readShort() / 20;
                        }
                        if (_loc_7 & MOVEFLAGS_HAS_COLOR)
                        {
                            if (_loc_25.color == JAColor.White)
                            {
                                _loc_25.color = new JAColor();
                            }
                            _loc_25.color.red = param1.readUnsignedByte();
                            _loc_25.color.green = param1.readUnsignedByte();
                            _loc_25.color.blue = param1.readUnsignedByte();
                            _loc_25.color.alpha = param1.readUnsignedByte();
                        }
                        if (_loc_7 & MOVEFLAGS_HAS_ANIMFRAMENUM)
                        {
                            _loc_25.animFrameNum = param1.readShort();
                        }
                        _loc_19++;
                    }
                }
                if (_loc_4 & FRAMEFLAGS_HAS_FRAME_NAME)
                {
                    _loc_8 = ReadString(param1);
                    _loc_8 = Remap(_loc_8).toUpperCase();
                    param2.label[_loc_8] = _loc_22;
                }
                if (_loc_4 & FRAMEFLAGS_HAS_STOP)
                {
                    _loc_15.hasStop = true;
                }
                if (_loc_4 & FRAMEFLAGS_HAS_COMMANDS)
                {
                    _loc_10 = param1.readByte();
                    _loc_15.commandVector.length = _loc_10;
                    _loc_19 = 0;
                    while (_loc_19 < _loc_10)
                    {
                        
                        _loc_15.commandVector[_loc_19] = new JACommand();
                        _loc_19++;
                    }
                    _loc_19 = 0;
                    while (_loc_19 < _loc_10)
                    {
                        
                        _loc_15.commandVector[_loc_19].command = Remap(ReadString(param1));
                        _loc_15.commandVector[_loc_19].param = Remap(ReadString(param1));
                        _loc_19++;
                    }
                }
                _loc_18 = 0;
                for each (_loc_26 in _loc_6)
                {
                    
                    _loc_15.frameObjectPosVector[_loc_18] = new JAObjectPos();
                    _loc_15.frameObjectPosVector[_loc_18].clone(_loc_26);
                    _loc_26.preloadFrames = 0;
                    _loc_18++;
                }
                _loc_22++;
            }
            if (_loc_5 == 0)
            {
                param2.frames.length = 1;
                param2.frames[0] = new JAFrame();
            }
            _loc_22 = 0;
            while (_loc_22 < param2.objectDefVector.length)
            {
                
                _loc_27 = param2.objectDefVector[_loc_22];
                _loc_22++;
            }
            return true;
        }

    }
}
