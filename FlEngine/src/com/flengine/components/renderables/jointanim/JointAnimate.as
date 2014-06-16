package com.flengine.components.renderables.jointanim
{
   import com.flengine.rand.MTRand;
   import com.adobe.utils.*;
   import flash.geom.*;
   import flash.utils.*;
   import com.flengine.textures.FTextureAtlas;
   import com.flengine.components.renderables.JAMemoryImage;
   import com.flengine.textures.FTexture;
   
   public class JointAnimate extends Object
   {
      
      public function JointAnimate() {
         super();
         _randUsed = false;
         _rand = new MTRand();
         _rand.SRand(getTimer());
         _drawScale = 1;
         _imgScale = 1;
         _loaded = false;
         _animRect = new Rectangle();
         _imageVector = new Vector.<JAImage>();
         _mainAnimDef = new JAAnimDef();
         _remapList = [];
      }
      
      public static const Load_Successed:int = 0;
      
      public static const Load_MagicError:int = -1;
      
      public static const Load_VersionError:int = -2;
      
      public static const Load_Failed:int = -3;
      
      public static const Load_LoadSpriteError:int = -4;
      
      public static const Load_LoadMainSpriteError:int = -5;
      
      public static const Load_GetImageTextureAtlasError:int = -6;
      
      public static var ImageSearchPathVector:Array;
      
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
      
      public function get drawScale() : Number {
         return _drawScale;
      }
      
      public function get imgScale() : Number {
         return _imgScale;
      }
      
      public function get loaded() : Boolean {
         return _loaded;
      }
      
      public function get particleAttachOffset() : Point {
         return _particleAttachOffset;
      }
      
      public function get mainAnimDef() : JAAnimDef {
         return _mainAnimDef;
      }
      
      public function get imageVector() : Vector.<JAImage> {
         return _imageVector;
      }
      
      public function get animRect() : Rectangle {
         return _animRect;
      }
      
      private function AddOnceImageToList(param1:String, param2:Array) : void {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ = param2[_loc4_];
            if(param1 == _loc3_.imageName)
            {
               return;
            }
            _loc4_++;
         }
         param2.push({"imageName":param1});
      }
      
      public function GetImageFileList(param1:ByteArray, param2:Array) : int {
         var _loc10_:* = 0;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc9_:* = 0;
         var _loc7_:* = 0;
         var _loc4_:uint = param1.readUnsignedInt();
         if(_loc4_ != 3136297300)
         {
            return -1;
         }
         var _loc11_:int = param1.readUnsignedInt();
         if(_loc11_ > 5)
         {
            return -2;
         }
         param1.readUnsignedByte();
         param1.readShort();
         param1.readShort();
         param1.readShort();
         param1.readShort();
         var _loc6_:int = param1.readShort();
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            _loc8_ = ReadString(param1);
            _loc5_ = Remap(_loc8_);
            _loc3_ = "";
            _loc9_ = _loc5_.indexOf("(");
            _loc7_ = _loc5_.indexOf(")");
            if(!(_loc9_ == -1) && !(_loc7_ == -1) && _loc9_ < _loc7_)
            {
               _loc3_ = _loc5_.substr(_loc9_ + 1,_loc7_ - _loc9_ - 1).toLowerCase();
               _loc5_ = _loc5_.substr(0,_loc9_) + _loc5_.substr(_loc7_ + 1);
            }
            else
            {
               _loc7_ = _loc5_.indexOf("$");
               if(_loc7_ != -1)
               {
                  _loc3_ = _loc5_.substr(0,_loc7_).toLowerCase();
                  _loc5_ = _loc5_.substr(_loc7_ + 1);
               }
            }
            if(_loc11_ >= 4)
            {
               param1.readShort();
               param1.readShort();
            }
            if(_loc11_ == 1)
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
            if(_loc5_.length > 0)
            {
               AddOnceImageToList(_loc5_,param2);
            }
            _loc10_++;
         }
         return 0;
      }
      
      public function LoadPam(param1:ByteArray, param2:FTextureAtlas) : int {
         var _loc13_:* = 0;
         var _loc10_:* = 0;
         var _loc12_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc11_:* = null;
         var _loc8_:* = null;
         var _loc17_:* = null;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc15_:* = NaN;
         var _loc16_:uint = param1.readUnsignedInt();
         if(_loc16_ != 3136297300)
         {
            return -1;
         }
         _version = param1.readUnsignedInt();
         if(_version > 5)
         {
            return -2;
         }
         _animRate = param1.readUnsignedByte();
         _animRect.x = (param1.readShort()) / 20;
         _animRect.y = (param1.readShort()) / 20;
         _animRect.width = (param1.readShort()) / 20;
         _animRect.height = (param1.readShort()) / 20;
         var _loc9_:int = param1.readShort();
         _imageVector.length = _loc9_;
         _loc13_ = 0;
         while(_loc13_ < _loc9_)
         {
            _imageVector[_loc13_] = new JAImage();
            _loc13_++;
         }
         _loc13_ = 0;
         while(_loc13_ < _loc9_)
         {
            _loc6_ = _imageVector[_loc13_];
            _loc6_.drawMode = 0;
            _loc11_ = ReadString(param1);
            _loc8_ = Remap(_loc11_);
            _loc17_ = "";
            _loc12_ = _loc8_.indexOf("(");
            _loc10_ = _loc8_.indexOf(")");
            if(!(_loc12_ == -1) && !(_loc10_ == -1) && _loc12_ < _loc10_)
            {
               _loc17_ = _loc8_.substr(_loc12_ + 1,_loc10_ - _loc12_ - 1).toLowerCase();
               _loc8_ = _loc8_.substr(0,_loc12_) + _loc8_.substr(_loc10_ + 1);
            }
            else
            {
               _loc10_ = _loc8_.indexOf("$");
               if(_loc10_ != -1)
               {
                  _loc17_ = _loc8_.substr(0,_loc10_).toLowerCase();
                  _loc8_ = _loc8_.substr(_loc10_ + 1);
               }
            }
            _loc6_.cols = 1;
            _loc6_.rows = 1;
            _loc12_ = _loc8_.indexOf("[");
            _loc10_ = _loc8_.indexOf("]");
            if(!(_loc12_ == -1) && !(_loc10_ == -1) && _loc12_ < _loc10_)
            {
               _loc17_ = _loc8_.substr(_loc12_ + 1,_loc10_ - _loc12_ - 1).toLowerCase();
               _loc8_ = _loc8_.substr(0,_loc12_) + _loc8_.substr(_loc10_ + 1);
               _loc5_ = _loc17_.indexOf(",");
               if(_loc5_ != -1)
               {
                  _loc6_.cols = _loc17_.substr(0,_loc5_);
                  _loc6_.rows = _loc17_.substr(_loc5_ + 1);
               }
            }
            if(_loc17_.indexOf("add") != -1)
            {
               _loc6_.drawMode = 1;
            }
            if(_version >= 4)
            {
               _loc6_.origWidth = param1.readShort();
               _loc6_.origHeight = param1.readShort();
            }
            else
            {
               _loc6_.origWidth = -1;
               _loc6_.origHeight = -1;
            }
            if(_version == 1)
            {
               _loc3_ = (param1.readShort()) / 1000;
               _loc4_ = Math.sin(_loc3_);
               _loc15_ = Math.cos(_loc3_);
               _loc6_.transform.matrix.m00 = _loc15_;
               _loc6_.transform.matrix.m01 = -_loc4_;
               _loc6_.transform.matrix.m10 = _loc4_;
               _loc6_.transform.matrix.m11 = _loc15_;
               _loc6_.transform.matrix.m02 = param1.readShort() / 20;
               _loc6_.transform.matrix.m12 = param1.readShort() / 20;
            }
            else
            {
               _loc6_.transform.matrix.m00 = (param1.readInt()) / 1310720;
               _loc6_.transform.matrix.m01 = (param1.readInt()) / 1310720;
               _loc6_.transform.matrix.m10 = (param1.readInt()) / 1310720;
               _loc6_.transform.matrix.m11 = (param1.readInt()) / 1310720;
               _loc6_.transform.matrix.m02 = (param1.readShort()) / 20;
               _loc6_.transform.matrix.m12 = (param1.readShort()) / 20;
            }
            _loc6_.imageName = _loc8_;
            if(_loc6_.imageName.length > 0)
            {
               if(param2 != null)
               {
                  if(Load_GetImage(_loc6_,param2) == false)
                  {
                     Load_GetImageNoTexture(_loc6_);
                  }
               }
               else
               {
                  Load_GetImageNoTexture(_loc6_);
               }
            }
            _loc13_++;
         }
         var _loc14_:int = param1.readShort();
         _mainAnimDef.spriteDefVector.length = _loc14_;
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _mainAnimDef.spriteDefVector[_loc13_] = new JASpriteDef();
            _loc13_++;
         }
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            if(LoadSpriteDef(param1,_mainAnimDef.spriteDefVector[_loc13_]) == false)
            {
               return -4;
            }
            _loc13_++;
         }
         var _loc7_:Boolean = _version <= 3 || param1.readBoolean();
         if(_loc7_)
         {
            _mainAnimDef.mainSpriteDef = new JASpriteDef();
            if(LoadSpriteDef(param1,_mainAnimDef.mainSpriteDef) == false)
            {
               return -5;
            }
         }
         _loaded = true;
         return 0;
      }
      
      private function Load_GetImageNoTexture(param1:JAImage) : void {
         var _loc2_:JAMemoryImage = new JAMemoryImage(null);
         _loc2_.width = param1.origWidth;
         _loc2_.height = param1.origHeight;
         _loc2_.loadFlag = 2;
         _loc2_.texture = null;
         _loc2_.name = param1.imageName;
         _loc2_.imageExist = false;
         param1.images.push(_loc2_);
      }
      
      private function Load_GetImage(param1:JAImage, param2:FTextureAtlas) : Boolean {
         var _loc4_:FTexture = param2.getTexture(param1.imageName);
         if(_loc4_ == null)
         {
            return false;
         }
         var _loc3_:JAMemoryImage = new JAMemoryImage(null);
         _loc3_.width = _loc4_.frameWidth;
         _loc3_.height = _loc4_.frameHeight;
         _loc3_.loadFlag = 2;
         _loc3_.texture = _loc4_;
         param1.OnMemoryImageLoadCompleted(_loc3_);
         param1.images.push(_loc3_);
         return true;
      }
      
      private function ReadString(param1:ByteArray) : String {
         var _loc2_:uint = param1.readShort();
         return param1.readUTFBytes(_loc2_);
      }
      
      private function Remap(param1:String) : String {
         var _loc5_:* = 0;
         var _loc3_:Array = [];
         var _loc4_:* = param1;
         var _loc2_:uint = _remapList.length;
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            if(WildcardReplace(param1,_remapList[_loc5_][0],_remapList[_loc5_][1],_loc3_))
            {
               _loc4_ = _loc3_[0];
               break;
            }
            _loc5_++;
         }
         _loc3_.splice(0);
         _loc3_ = null;
         return _loc4_;
      }
      
      private function WildcardReplace(param1:String, param2:String, param3:String, param4:Array) : Boolean {
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = false;
         var _loc9_:* = 0;
         if(param2.length == 0)
         {
            return false;
         }
         if(param2.charAt(0) == "*")
         {
            if(param2.length == 1)
            {
               param4.push(WildcardExpand(param1,0,param1.length,param3));
               return true;
            }
            if(param2.charAt(param2.length - 1) == "*")
            {
               _loc6_ = param2.length - 2;
               _loc5_ = param1.length - _loc6_;
               _loc7_ = 0;
               while(true)
               {
                  if(_loc7_ <= _loc5_)
                  {
                     _loc8_ = true;
                     _loc9_ = 0;
                     while(_loc9_ < _loc6_)
                     {
                        if(param2.charAt(_loc9_ + 1).toUpperCase() != param1.charAt(_loc7_ + _loc9_).toUpperCase())
                        {
                           _loc8_ = false;
                           break;
                        }
                        _loc9_++;
                     }
                     if(_loc8_)
                     {
                        break;
                     }
                     _loc7_++;
                     continue;
                  }
               }
               param4.push(WildcardExpand(param1,_loc7_,_loc7_ + _loc6_,param3));
               return true;
            }
            if(param1.length < param2.length - 1)
            {
               return false;
            }
            if(param2.substr(1).toUpperCase() != param1.substr(param1.length - param2.length + 1).toUpperCase())
            {
               return false;
            }
            param4.push(WildcardExpand(param1,param1.length - param2.length + 1,param1.length,param3));
            return true;
         }
         if(param2.charAt(param2.length - 1) == "*")
         {
            if(param1.length < param2.length - 1)
            {
               return false;
            }
            if(param2.substr(0,param2.length - 1).toUpperCase() != param1.substr(0,param2.length - 1).toUpperCase())
            {
               return false;
            }
            param4.push(WildcardExpand(param1,0,param2.length - 1,param3));
            return true;
         }
         if(param2.toUpperCase() == param1.toUpperCase())
         {
            if(param3.length > 0)
            {
               if(param3.charAt(0) == "*")
               {
                  param4.push(param1 + param3.substr(1));
               }
               else if(param3.charAt(param3.length - 1) == "*")
               {
                  param4.push(param3.substr(0,param3.length - 1) + param1);
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
         return false;
      }
      
      private function WildcardExpand(param1:String, param2:int, param3:int, param4:String) : String {
         var _loc5_:* = null;
         if(param4.length == 0)
         {
            _loc5_ = "";
         }
         else if(param4.charAt(0) == "*")
         {
            if(param4.length == 1)
            {
               _loc5_ = param1.substr(0,param2) + param1.substr(param3);
            }
            else if(param4.charAt(param4.length - 1) == "*")
            {
               _loc5_ = param1.substr(0,param2) + param4.substr(1,param4.length - 2) + param1.substr(param3);
            }
            else
            {
               _loc5_ = param1.substr(0,param2) + param4.substr(1,param4.length - 1);
            }
            
         }
         else if(param4.charAt(param4.length - 1) == "*")
         {
            _loc5_ = param4.substr(0,param4.length - 1) + param1.substr(param3);
         }
         else
         {
            _loc5_ = param4;
         }
         
         
         return _loc5_;
      }
      
      private function LoadSpriteDef(param1:ByteArray, param2:JASpriteDef) : Boolean {
         var _loc22_:* = 0;
         var _loc19_:* = 0;
         var _loc15_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc17_:* = 0;
         var _loc12_:* = 0;
         var _loc25_:* = null;
         var _loc21_:* = 0;
         var _loc24_:* = null;
         var _loc20_:* = 0;
         var _loc13_:* = 0;
         var _loc7_:* = 0;
         var _loc11_:* = 0;
         var _loc14_:* = NaN;
         var _loc16_:* = NaN;
         var _loc23_:* = NaN;
         var _loc9_:* = null;
         var _loc8_:* = null;
         var _loc10_:* = 0;
         var _loc18_:* = 0;
         var _loc27_:* = null;
         if(_version >= 4)
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
         var _loc5_:int = param1.readShort();
         if(_version >= 5)
         {
            param2.workAreaStart = param1.readShort();
            param2.workAreaDuration = param1.readShort();
         }
         else
         {
            param2.workAreaStart = 0;
            param2.workAreaDuration = _loc5_ - 1;
         }
         param2.workAreaDuration = Math.min(param2.workAreaStart + param2.workAreaDuration,_loc5_ - 1) - param2.workAreaStart;
         param2.frames.length = _loc5_;
         _loc22_ = 0;
         while(_loc22_ < _loc5_)
         {
            param2.frames[_loc22_] = new JAFrame();
            _loc22_++;
         }
         var _loc6_:Dictionary = new Dictionary();
         _loc22_ = 0;
         while(_loc22_ < _loc5_)
         {
            _loc15_ = param2.frames[_loc22_];
            _loc4_ = param1.readUnsignedByte();
            if(_loc4_ & 1)
            {
               _loc3_ = param1.readByte();
               if(_loc3_ == 255)
               {
                  _loc3_ = param1.readShort();
               }
               _loc19_ = 0;
               while(_loc19_ < _loc3_)
               {
                  _loc17_ = param1.readShort();
                  if(_loc17_ >= 2047)
                  {
                     _loc17_ = param1.readUnsignedInt();
                  }
                  delete _loc6_[_loc17_];
                  _loc19_++;
               }
            }
            if(_loc4_ & 2)
            {
               _loc12_ = param1.readByte();
               if(_loc12_ == 255)
               {
                  _loc12_ = param1.readShort();
               }
               _loc19_ = 0;
               while(_loc19_ < _loc12_)
               {
                  _loc25_ = new JAObjectPos();
                  _loc21_ = param1.readShort();
                  _loc25_.objectNum = _loc21_ & 2047;
                  if(_loc25_.objectNum == 2047)
                  {
                     _loc25_.objectNum = param1.readUnsignedInt();
                  }
                  _loc25_.isSprite = !((_loc21_ & 32768) == 0);
                  _loc25_.isAdditive = !((_loc21_ & 16384) == 0);
                  _loc25_.resNum = param1.readByte();
                  _loc25_.hasSrcRect = false;
                  _loc25_.color = JAColor.White;
                  _loc25_.animFrameNum = 0;
                  _loc25_.timeScale = 1;
                  _loc25_.name = null;
                  if((_loc21_ & 8192) != 0)
                  {
                     _loc25_.preloadFrames = param1.readShort();
                  }
                  else
                  {
                     _loc25_.preloadFrames = 0;
                  }
                  if(_loc21_ & 4096)
                  {
                     _loc24_ = ReadString(param1);
                     _mainAnimDef.objectNamePool.push(_loc24_);
                     _loc25_.name = _loc24_;
                     _loc24_ = null;
                  }
                  if(_loc21_ & 2048)
                  {
                     _loc25_.timeScale = (param1.readUnsignedInt()) / 65536;
                  }
                  if(param2.objectDefVector.length < _loc25_.objectNum + 1)
                  {
                     _loc20_ = 0;
                     while(_loc20_ < _loc25_.objectNum + 1)
                     {
                        param2.objectDefVector.push(new JAObjectDef());
                        _loc20_++;
                     }
                  }
                  param2.objectDefVector[_loc25_.objectNum].name = _loc25_.name;
                  if(_loc25_.isSprite)
                  {
                     param2.objectDefVector[_loc25_.objectNum].spriteDef = _mainAnimDef.spriteDefVector[_loc25_.resNum];
                  }
                  _loc6_[_loc25_.objectNum] = _loc25_;
                  _loc19_++;
               }
            }
            if(_loc4_ & 4)
            {
               _loc13_ = param1.readByte();
               if(_loc13_ == 255)
               {
                  _loc13_ = param1.readShort();
               }
               _loc19_ = 0;
               while(_loc19_ < _loc13_)
               {
                  _loc7_ = param1.readShort();
                  _loc11_ = _loc7_ & 1023;
                  if(_loc11_ == 1023)
                  {
                     _loc11_ = param1.readUnsignedInt();
                  }
                  _loc25_ = _loc6_[_loc11_];
                  _loc25_.transform.matrix.LoadIdentity();
                  if(_loc7_ & 4096)
                  {
                     _loc25_.transform.matrix.m00 = (param1.readInt()) / 65536;
                     _loc25_.transform.matrix.m01 = (param1.readInt()) / 65536;
                     _loc25_.transform.matrix.m10 = (param1.readInt()) / 65536;
                     _loc25_.transform.matrix.m11 = (param1.readInt()) / 65536;
                  }
                  else if(_loc7_ & 16384)
                  {
                     _loc14_ = (param1.readShort()) / 1000;
                     _loc16_ = Math.sin(_loc14_);
                     _loc23_ = Math.cos(_loc14_);
                     if(_version == 2)
                     {
                        _loc16_ = -_loc16_;
                     }
                     _loc25_.transform.matrix.m00 = _loc23_;
                     _loc25_.transform.matrix.m01 = -_loc16_;
                     _loc25_.transform.matrix.m10 = _loc16_;
                     _loc25_.transform.matrix.m11 = _loc23_;
                  }
                  
                  _loc9_ = new JAMatrix3();
                  if(_loc7_ & 2048)
                  {
                     _loc9_.m02 = (param1.readInt()) / 20;
                     _loc9_.m12 = (param1.readInt()) / 20;
                  }
                  else
                  {
                     _loc9_.m02 = (param1.readShort()) / 20;
                     _loc9_.m12 = (param1.readShort()) / 20;
                  }
                  _loc25_.transform.matrix = JAMatrix3.MulJAMatrix3(_loc9_,_loc25_.transform.matrix,_loc25_.transform.matrix);
                  _loc25_.hasSrcRect = !((_loc7_ & 32768) == 0);
                  if(_loc7_ & 32768)
                  {
                     if(_loc25_.srcRect == null)
                     {
                        _loc25_.srcRect = new Rectangle();
                     }
                     _loc25_.srcRect.x = (param1.readShort()) / 20;
                     _loc25_.srcRect.y = (param1.readShort()) / 20;
                     _loc25_.srcRect.width = (param1.readShort()) / 20;
                     _loc25_.srcRect.height = (param1.readShort()) / 20;
                  }
                  if(_loc7_ & 8192)
                  {
                     if(_loc25_.color == JAColor.White)
                     {
                        _loc25_.color = new JAColor();
                     }
                     _loc25_.color.red = param1.readUnsignedByte();
                     _loc25_.color.green = param1.readUnsignedByte();
                     _loc25_.color.blue = param1.readUnsignedByte();
                     _loc25_.color.alpha = param1.readUnsignedByte();
                  }
                  if(_loc7_ & 1024)
                  {
                     _loc25_.animFrameNum = param1.readShort();
                  }
                  _loc19_++;
               }
            }
            if(_loc4_ & 8)
            {
               _loc8_ = ReadString(param1);
               _loc8_ = Remap(_loc8_).toUpperCase();
               param2.label[_loc8_] = _loc22_;
            }
            if(_loc4_ & 16)
            {
               _loc15_.hasStop = true;
            }
            if(_loc4_ & 32)
            {
               _loc10_ = param1.readByte();
               _loc15_.commandVector.length = _loc10_;
               _loc19_ = 0;
               while(_loc19_ < _loc10_)
               {
                  _loc15_.commandVector[_loc19_] = new JACommand();
                  _loc19_++;
               }
               _loc19_ = 0;
               while(_loc19_ < _loc10_)
               {
                  _loc15_.commandVector[_loc19_].command = Remap(ReadString(param1));
                  _loc15_.commandVector[_loc19_].param = Remap(ReadString(param1));
                  _loc19_++;
               }
            }
            _loc18_ = 0;
            _loc29_ = 0;
            _loc28_ = _loc6_;
            for each(_loc26_ in _loc6_)
            {
               _loc15_.frameObjectPosVector[_loc18_] = new JAObjectPos();
               _loc15_.frameObjectPosVector[_loc18_].clone(_loc26_);
               _loc26_.preloadFrames = 0;
               _loc18_++;
            }
            _loc22_++;
         }
         if(_loc5_ == 0)
         {
            param2.frames.length = 1;
            param2.frames[0] = new JAFrame();
         }
         _loc22_ = 0;
         while(_loc22_ < param2.objectDefVector.length)
         {
            _loc27_ = param2.objectDefVector[_loc22_];
            _loc22_++;
         }
         return true;
      }
   }
}
const PAM_MAGIC:uint = 3136297300;
const PAM_VERSION:uint = 5;
const FRAMEFLAGS_HAS_REMOVES:uint = 1;
const FRAMEFLAGS_HAS_ADDS:uint = 2;
const FRAMEFLAGS_HAS_MOVES:uint = 4;
const FRAMEFLAGS_HAS_FRAME_NAME:uint = 8;
const FRAMEFLAGS_HAS_STOP:uint = 16;
const FRAMEFLAGS_HAS_COMMANDS:uint = 32;
const MOVEFLAGS_HAS_SRCRECT:uint = 32768;
const MOVEFLAGS_HAS_ROTATE:uint = 16384;
const MOVEFLAGS_HAS_COLOR:uint = 8192;
const MOVEFLAGS_HAS_MATRIX:uint = 4096;
const MOVEFLAGS_HAS_LONGCOORDS:uint = 2048;
const MOVEFLAGS_HAS_ANIMFRAMENUM:uint = 1024;
