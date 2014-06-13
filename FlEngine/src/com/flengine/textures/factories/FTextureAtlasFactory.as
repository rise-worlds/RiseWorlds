package com.flengine.textures.factories
{
    import __AS3__.vec.*;
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import com.flengine.utils.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class FTextureAtlasFactory extends Object
    {

        public function FTextureAtlasFactory()
        {
            return;
        }

        public static function createFromMovieClip(param1:String, param2:MovieClip, param3:Boolean = false) : FTextureAtlas
        {
            var _loc_11:* = 0;
            var _loc_8:* = 0;
            var _loc_6:* = 0;
            var _loc_5:* = null;
            var _loc_4:* = null;
            var _loc_10:* = new Vector.<BitmapData>;
            var _loc_7:* = new Vector.<String>;
            var _loc_9:* = new Matrix();
            _loc_11 = 1;
            while (_loc_11 < param2.totalFrames)
            {
                
                param2.gotoAndStop(_loc_11);
                _loc_8 = param2.width % 2 != 0 && param3 ? ((param2.width + 1)) : (param2.width);
                _loc_6 = param2.height % 2 != 0 && param3 ? ((param2.height + 1)) : (param2.height);
                _loc_5 = new BitmapData(param2.width, param2.height, true, 0);
                _loc_4 = param2.getBounds(param2);
                _loc_9.identity();
                _loc_9.translate(-_loc_4.x, -_loc_4.y);
                _loc_5.draw(param2, _loc_9);
                _loc_10.push(_loc_5);
                _loc_7.push(_loc_11);
                _loc_11++;
            }
            return createFromBitmapDatas(param1, _loc_10, _loc_7);
        }

        public static function createFromFont(param1:String, param2:TextFormat, param3:String, param4:Boolean = false) : FTextureAtlas
        {
            var _loc_11:* = 0;
            var _loc_9:* = 0;
            var _loc_7:* = 0;
            var _loc_6:* = null;
            var _loc_5:* = new TextField();
            _loc_5.embedFonts = true;
            _loc_5.defaultTextFormat = param2;
            _loc_5.multiline = false;
            _loc_5.autoSize = "left";
            var _loc_10:* = new Vector.<BitmapData>;
            var _loc_8:* = new Vector.<String>;
            _loc_11 = 0;
            while (_loc_11 < param3.length)
            {
                
                _loc_5.text = param3.charAt(_loc_11);
                _loc_9 = _loc_5.width % 2 != 0 && param4 ? ((_loc_5.width + 1)) : (_loc_5.width);
                _loc_7 = _loc_5.height % 2 != 0 && param4 ? ((_loc_5.height + 1)) : (_loc_5.height);
                _loc_6 = new BitmapData(_loc_9, _loc_7, true, 0);
                _loc_6.draw(_loc_5);
                _loc_10.push(_loc_6);
                _loc_8.push(param3.charCodeAt(_loc_11));
                _loc_11++;
            }
            return createFromBitmapDatas(param1, _loc_10, _loc_8);
        }

        public static function createFromBitmapDatas(param1:String, param2:Vector.<BitmapData>, param3:Vector.<String>, param4:FPacker = null, param5:int = 2) : FTextureAtlas
        {
            var _loc_12:* = 0;
            var _loc_10:* = null;
            var _loc_8:* = null;
            var _loc_11:* = new Vector.<FPackerRectangle>;
            _loc_12 = 0;
            while (_loc_12 < param2.length)
            {
                
                _loc_8 = param2[_loc_12];
                _loc_10 = FPackerRectangle.get(0, 0, _loc_8.width, _loc_8.height, param3[_loc_12], _loc_8);
                _loc_11.push(_loc_10);
                _loc_12++;
            }
            if (param4 == null)
            {
                param4 = new FMaxRectPacker(1, 1, 2048, 2048, true);
            }
            param4.packRectangles(_loc_11, param5);
            if (param4.rectangles.length != param2.length)
            {
                return null;
            }
            var _loc_9:* = new BitmapData(param4.width, param4.height, true, 0);
            param4.draw(_loc_9);
            var _loc_7:* = new FTextureAtlas(param1, 3, _loc_9.width, _loc_9.height, _loc_9, FTextureUtils.isBitmapDataTransparent(_loc_9), null);
            var _loc_6:* = param4.rectangles.length;
            _loc_12 = 0;
            while (_loc_12 < _loc_6)
            {
                
                _loc_10 = param4.rectangles[_loc_12];
                _loc_7.addSubTexture(_loc_10.id, _loc_10.rect, _loc_10.rect.width, _loc_10.rect.height, _loc_10.pivotX, _loc_10.pivotY);
                _loc_12++;
            }
            _loc_7.invalidate();
            return _loc_7;
        }

        public static function createFromBitmapDataAndXML(param1:String, param2:BitmapData, param3:XML) : FTextureAtlas
        {
            var _loc_11:* = 0;
            var _loc_6:* = null;
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_7:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_8:* = new FTextureAtlas(param1, 3, param2.width, param2.height, param2, FTextureUtils.isBitmapDataTransparent(param2), null);
            _loc_11 = 0;
            while (_loc_11 < param3.children().length())
            {
                
                _loc_6 = param3.children()[_loc_11];
                _loc_4 = new Rectangle(_loc_6.@x, _loc_6.@y, _loc_6.@width, _loc_6.@height);
                _loc_5 = _loc_6.@frameX == undefined && _loc_6.@frameWidth == undefined ? (0) : ((_loc_6.@frameWidth - _loc_4.width) / 2 + _loc_6.@frameX);
                _loc_7 = _loc_6.@frameY == undefined && _loc_6.@frameHeight == undefined ? (0) : ((_loc_6.@frameHeight - _loc_4.height) / 2 + _loc_6.@frameY);
                _loc_9 = _loc_6.@frameWidth == undefined ? (_loc_6.@width) : (_loc_6.@frameWidth);
                _loc_10 = _loc_6.@frameHeight == undefined ? (_loc_6.@height) : (_loc_6.@frameHeight);
                _loc_8.addSubTexture(_loc_6.@name, _loc_4, _loc_9, _loc_10, _loc_5, _loc_7, false);
                _loc_11++;
            }
            _loc_8.invalidate();
            return _loc_8;
        }

        public static function createFromAssets(param1:String, param2:Class, param3:Class) : FTextureAtlas
        {
            var _loc_4:* = new param2;
            var _loc_5:* = FTextureAtlasFactory.XML(new param3);
            return createFromBitmapDataAndXML(param1, _loc_4.bitmapData, _loc_5);
        }

        public static function createFromBitmapDataAndFontXML(param1:String, param2:BitmapData, param3:XML) : FTextureAtlas
        {
            var _loc_9:* = 0;
            var _loc_6:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = new FTextureAtlas(param1, 3, param2.width, param2.height, param2, FTextureUtils.isBitmapDataTransparent(param2), null);
            _loc_9 = 0;
            while (_loc_9 < param3.chars.children().length())
            {
                
                _loc_6 = param3.chars.children()[_loc_9];
                _loc_4 = new Rectangle(_loc_6.@x, _loc_6.@y, _loc_6.@width, _loc_6.@height);
                _loc_5 = -_loc_6.@xoffset;
                _loc_7 = -_loc_6.@yoffset;
                _loc_8.addSubTexture(_loc_6.@id, _loc_4, _loc_4.width, _loc_4.height, _loc_5, _loc_7);
                _loc_9++;
            }
            _loc_8.invalidate();
            return _loc_8;
        }

        public static function createFromATFAndXML(param1:String, param2:ByteArray, param3:XML, param4:Function = null) : FTextureAtlas
        {
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_14:* = String.fromCharCode(param2[0], param2[1], param2[2]);
            if (String.fromCharCode(param2[0], param2[1], param2[2]) != "ATF")
            {
                throw new FError("FError: Invalid ATF data.");
            }
            var _loc_15:* = true;
            var _loc_16:* = param2[6];
            while (_loc_16 === 1)
            {
                
                _loc_9 = 0;
                do
                {
                    
                    _loc_9 = 1;
                    _loc_15 = false;
                    do
                    {
                        
                        _loc_9 = 2;
                        break;
                    }
                }while (_loc_16 === 3)
            }while (_loc_16 === 5)
            var _loc_8:* = Math.pow(2, param2[7]);
            var _loc_12:* = Math.pow(2, param2[8]);
            var _loc_13:* = new FTextureAtlas(param1, _loc_9, _loc_8, _loc_12, param2, _loc_15, param4);
            _loc_10 = 0;
            while (_loc_10 < param3.children().length())
            {
                
                _loc_11 = param3.children()[_loc_10];
                _loc_5 = new Rectangle(_loc_11.@x, _loc_11.@y, _loc_11.@width, _loc_11.@height);
                _loc_6 = _loc_11.@frameX == undefined && _loc_11.@frameWidth == undefined ? (0) : ((_loc_11.@frameWidth - _loc_5.width) / 2 + _loc_11.@frameX);
                _loc_7 = _loc_11.@frameY == undefined && _loc_11.@frameHeight == undefined ? (0) : ((_loc_11.@frameHeight - _loc_5.height) / 2 + _loc_11.@frameY);
                _loc_13.addSubTexture(_loc_11.@name, _loc_5, _loc_5.width, _loc_5.height, _loc_6, _loc_7);
                _loc_10++;
            }
            _loc_13.invalidate();
            return _loc_13;
        }

        public static function createFromBitmapDataAndRegions(param1:String, param2:BitmapData, param3:Vector.<Rectangle>, param4:Vector.<String> = null, param5:Vector.<Point> = null) : FTextureAtlas
        {
            var _loc_9:* = 0;
            var _loc_6:* = null;
            var _loc_8:* = false;
            var _loc_7:* = new FTextureAtlas(param1, 3, param2.width, param2.height, param2, FTextureUtils.isBitmapDataTransparent(param2), null);
            _loc_9 = 0;
            while (_loc_9 < param3.length)
            {
                
                _loc_6 = param4 == null ? (_loc_9) : (param4[_loc_9]);
                _loc_8 = param2.histogram(param3[_loc_9])[3][255] != param3[_loc_9].width * param3[_loc_9].height;
                if (param5)
                {
                    _loc_7.addSubTexture(_loc_6, param3[_loc_9], param3[_loc_9].width, param3[_loc_9].height, param5[_loc_9].x, param5[_loc_9].y);
                }
                else
                {
                    _loc_7.addSubTexture(_loc_6, param3[_loc_9], param3[_loc_9].width, param3[_loc_9].height);
                }
                _loc_9++;
            }
            _loc_7.invalidate();
            return _loc_7;
        }

    }
}
