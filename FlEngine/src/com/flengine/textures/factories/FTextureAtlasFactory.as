package com.flengine.textures.factories
{
   import com.flengine.textures.FTextureAtlas;
   import flash.display.MovieClip;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import flash.text.TextField;
   import com.flengine.utils.FPacker;
   import com.flengine.utils.FPackerRectangle;
   import com.flengine.utils.FMaxRectPacker;
   import com.flengine.textures.FTextureUtils;
   import flash.display.Bitmap;
   import flash.utils.ByteArray;
   import com.flengine.error.FError;
   import flash.geom.Point;
   
   public class FTextureAtlasFactory extends Object
   {
      
      public function FTextureAtlasFactory() {
         super();
      }
      
      public static function createFromMovieClip(param1:String, param2:MovieClip, param3:Boolean = false) : FTextureAtlas {
         var _loc11_:* = 0;
         var _loc8_:* = 0;
         var _loc6_:* = 0;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc10_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc7_:Vector.<String> = new Vector.<String>();
         var _loc9_:Matrix = new Matrix();
         _loc11_ = 1;
         while(_loc11_ < param2.totalFrames)
         {
            param2.gotoAndStop(_loc11_);
            _loc8_ = !(param2.width % 2 == 0) && param3?param2.width + 1:param2.width;
            _loc6_ = !(param2.height % 2 == 0) && param3?param2.height + 1:param2.height;
            _loc5_ = new BitmapData(param2.width,param2.height,true,0);
            _loc4_ = param2.getBounds(param2);
            _loc9_.identity();
            _loc9_.translate(-_loc4_.x,-_loc4_.y);
            _loc5_.draw(param2,_loc9_);
            _loc10_.push(_loc5_);
            _loc7_.push(_loc11_);
            _loc11_++;
         }
         return createFromBitmapDatas(param1,_loc10_,_loc7_);
      }
      
      public static function createFromFont(param1:String, param2:TextFormat, param3:String, param4:Boolean = false) : FTextureAtlas {
         var _loc11_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc5_:TextField = new TextField();
         _loc5_.embedFonts = true;
         _loc5_.defaultTextFormat = param2;
         _loc5_.multiline = false;
         _loc5_.autoSize = "left";
         var _loc10_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc8_:Vector.<String> = new Vector.<String>();
         _loc11_ = 0;
         while(_loc11_ < param3.length)
         {
            _loc5_.text = param3.charAt(_loc11_);
            _loc9_ = !(_loc5_.width % 2 == 0) && param4?_loc5_.width + 1:_loc5_.width;
            _loc7_ = !(_loc5_.height % 2 == 0) && param4?_loc5_.height + 1:_loc5_.height;
            _loc6_ = new BitmapData(_loc9_,_loc7_,true,0);
            _loc6_.draw(_loc5_);
            _loc10_.push(_loc6_);
            _loc8_.push(param3.charCodeAt(_loc11_));
            _loc11_++;
         }
         return createFromBitmapDatas(param1,_loc10_,_loc8_);
      }
      
      public static function createFromBitmapDatas(param1:String, param2:Vector.<BitmapData>, param3:Vector.<String>, param4:FPacker = null, param5:int = 2) : FTextureAtlas {
         var _loc12_:* = 0;
         var _loc10_:* = null;
         var _loc8_:* = null;
         var _loc11_:Vector.<FPackerRectangle> = new Vector.<FPackerRectangle>();
         _loc12_ = 0;
         while(_loc12_ < param2.length)
         {
            _loc8_ = param2[_loc12_];
            _loc10_ = FPackerRectangle.get(0,0,_loc8_.width,_loc8_.height,param3[_loc12_],_loc8_);
            _loc11_.push(_loc10_);
            _loc12_++;
         }
         if(param4 == null)
         {
            param4 = new FMaxRectPacker(1,1,2048,2048,true);
         }
         param4.packRectangles(_loc11_,param5);
         if(param4.rectangles.length != param2.length)
         {
            return null;
         }
         var _loc9_:BitmapData = new BitmapData(param4.width,param4.height,true,0);
         param4.draw(_loc9_);
         var _loc7_:FTextureAtlas = new FTextureAtlas(param1,3,_loc9_.width,_loc9_.height,_loc9_,FTextureUtils.isBitmapDataTransparent(_loc9_),null);
         var _loc6_:int = param4.rectangles.length;
         _loc12_ = 0;
         while(_loc12_ < _loc6_)
         {
            _loc10_ = param4.rectangles[_loc12_];
            _loc7_.addSubTexture(_loc10_.id,_loc10_.rect,_loc10_.rect.width,_loc10_.rect.height,_loc10_.pivotX,_loc10_.pivotY);
            _loc12_++;
         }
         _loc7_.invalidate();
         return _loc7_;
      }
      
      public static function createFromBitmapDataAndXML(param1:String, param2:BitmapData, param3:XML) : FTextureAtlas {
         var _loc11_:* = 0;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = NaN;
         var _loc7_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc8_:FTextureAtlas = new FTextureAtlas(param1,3,param2.width,param2.height,param2,FTextureUtils.isBitmapDataTransparent(param2),null);
         _loc11_ = 0;
         while(_loc11_ < param3.children().length())
         {
            _loc6_ = param3.children()[_loc11_];
            _loc4_ = new Rectangle(_loc6_.@x,_loc6_.@y,_loc6_.@width,_loc6_.@height);
            _loc5_ = _loc6_.@frameX == undefined && _loc6_.@frameWidth == undefined?0:(_loc6_.@frameWidth - _loc4_.width) / 2 + (_loc6_.@frameX);
            _loc7_ = _loc6_.@frameY == undefined && _loc6_.@frameHeight == undefined?0:(_loc6_.@frameHeight - _loc4_.height) / 2 + (_loc6_.@frameY);
            _loc9_ = _loc6_.@frameWidth == undefined?_loc6_.@width:_loc6_.@frameWidth;
            _loc10_ = _loc6_.@frameHeight == undefined?_loc6_.@height:_loc6_.@frameHeight;
            _loc8_.addSubTexture(_loc6_.@name,_loc4_,_loc9_,_loc10_,_loc5_,_loc7_,false);
            _loc11_++;
         }
         _loc8_.invalidate();
         return _loc8_;
      }
      
      public static function createFromAssets(param1:String, param2:Class, param3:Class) : FTextureAtlas {
         var _loc4_:Bitmap = new param2();
         var _loc5_:XML = XML(new param3());
         return createFromBitmapDataAndXML(param1,_loc4_.bitmapData,_loc5_);
      }
      
      public static function createFromBitmapDataAndFontXML(param1:String, param2:BitmapData, param3:XML) : FTextureAtlas {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:FTextureAtlas = new FTextureAtlas(param1,3,param2.width,param2.height,param2,FTextureUtils.isBitmapDataTransparent(param2),null);
         _loc9_ = 0;
         while(_loc9_ < param3.chars.children().length())
         {
            _loc6_ = param3.chars.children()[_loc9_];
            _loc4_ = new Rectangle(_loc6_.@x,_loc6_.@y,_loc6_.@width,_loc6_.@height);
            _loc5_ = -(_loc6_.@xoffset);
            _loc7_ = -(_loc6_.@yoffset);
            _loc8_.addSubTexture(_loc6_.@id,_loc4_,_loc4_.width,_loc4_.height,_loc5_,_loc7_);
            _loc9_++;
         }
         _loc8_.invalidate();
         return _loc8_;
      }
      
      public static function createFromATFAndXML(param1:String, param2:ByteArray, param3:XML, param4:Function = null) : FTextureAtlas {
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc14_:String = String.fromCharCode(param2[0],param2[1],param2[2]);
         if(_loc14_ != "ATF")
         {
            throw new FError("FError: Invalid ATF data.");
         }
         else
         {
            var _loc15_:Boolean = true;
			var _loc16_:int = param2[6];
            if(1 !== _loc16_)
            {
               if(3 !== _loc16_)
               {
                  if(5 === _loc16_)
                  {
                     _loc9_ = 2;
                  }
               }
               else
               {
                  _loc9_ = 1;
                  _loc15_ = false;
               }
            }
            else
            {
               _loc9_ = 0;
            }
            var _loc8_:Number = Math.pow(2,param2[7]);
            var _loc12_:Number = Math.pow(2,param2[8]);
            var _loc13_:FTextureAtlas = new FTextureAtlas(param1,_loc9_,_loc8_,_loc12_,param2,_loc15_,param4);
            _loc10_ = 0;
            while(_loc10_ < param3.children().length())
            {
               _loc11_ = param3.children()[_loc10_];
               _loc5_ = new Rectangle(_loc11_.@x,_loc11_.@y,_loc11_.@width,_loc11_.@height);
               _loc6_ = _loc11_.@frameX == undefined && _loc11_.@frameWidth == undefined?0:(_loc11_.@frameWidth - _loc5_.width) / 2 + (_loc11_.@frameX);
               _loc7_ = _loc11_.@frameY == undefined && _loc11_.@frameHeight == undefined?0:(_loc11_.@frameHeight - _loc5_.height) / 2 + (_loc11_.@frameY);
               _loc13_.addSubTexture(_loc11_.@name,_loc5_,_loc5_.width,_loc5_.height,_loc6_,_loc7_);
               _loc10_++;
            }
            _loc13_.invalidate();
            return _loc13_;
         }
      }
      
      public static function createFromBitmapDataAndRegions(param1:String, param2:BitmapData, param3:Vector.<Rectangle>, param4:Vector.<String> = null, param5:Vector.<Point> = null) : FTextureAtlas {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc8_:* = false;
         var _loc7_:FTextureAtlas = new FTextureAtlas(param1,3,param2.width,param2.height,param2,FTextureUtils.isBitmapDataTransparent(param2),null);
         _loc9_ = 0;
         while(_loc9_ < param3.length)
         {
            _loc6_ = param4 == null?_loc9_:param4[_loc9_];
            _loc8_ = !(param2.histogram(param3[_loc9_])[3][255] == param3[_loc9_].width * param3[_loc9_].height);
            if(param5)
            {
               _loc7_.addSubTexture(_loc6_,param3[_loc9_],param3[_loc9_].width,param3[_loc9_].height,param5[_loc9_].x,param5[_loc9_].y);
            }
            else
            {
               _loc7_.addSubTexture(_loc6_,param3[_loc9_],param3[_loc9_].width,param3[_loc9_].height);
            }
            _loc9_++;
         }
         _loc7_.invalidate();
         return _loc7_;
      }
   }
}
