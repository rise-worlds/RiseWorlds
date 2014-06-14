package com.flengine.textures.factories
{
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FTextureFactory extends Object
    {

        public function FTextureFactory()
        {
            return;
        }

        public static function createFromAsset(param1:String, param2:Class) : FTexture
        {
            var _loc_3:* = new param2;
            return new FTexture(param1, FTextureSourceType.BITMAPDATA, _loc_3.bitmapData, _loc_3.bitmapData.rect, FTextureUtils.isBitmapDataTransparent(_loc_3.bitmapData), _loc_3.bitmapData.rect.width, _loc_3.bitmapData.rect.height);
        }

        public static function createFromColor(param1:String, param2:uint, param3:int, param4:int) : FTexture
        {
            var _loc_5:* = new BitmapData(param3, param4, false, param2);
            return new FTexture(param1, FTextureSourceType.BITMAPDATA, _loc_5, _loc_5.rect, false, _loc_5.rect.width, _loc_5.rect.height);
        }

        public static function createFromBitmapData(param1:String, param2:BitmapData) : FTexture
        {
            if (param2 == null)
            {
                throw new FError(FError.NULL_BITMAPDATA);
            }
            return new FTexture(param1, FTextureSourceType.BITMAPDATA, param2, param2.rect, FTextureUtils.isBitmapDataTransparent(param2), param2.rect.width, param2.rect.height);
        }

        public static function createFromATF(param1:String, param2:ByteArray, param3:Function = null) : FTexture
        {
            var _loc_8:* = 0;
            var _loc_6:* = String.fromCharCode(param2[0], param2[1], param2[2]);
            if (_loc_6 != "ATF")
            {
                throw new FError(FError.INVALID_ATF_DATA);
            }
            var _loc_7:* = true;
            var _loc_9:* = param2[6];
            switch(_loc_9)
            {
                case 1:
                {
                    _loc_5 = FTextureSourceType.ATF_BGRA;
                    break;
                }
                case 3:
                {
                    _loc_5 = FTextureSourceType.ATF_COMPRESSED;
                    _loc_6 = false;
                    break;
                }
                case 5:
                {
                    _loc_5 = FTextureSourceType.ATF_COMPRESSEDALPHA;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var _loc_5:* = Math.pow(2, param2[7]);
            var _loc_4:* = Math.pow(2, param2[8]);
            return new FTexture(param1, _loc_8, param2, new Rectangle(0, 0, _loc_5, _loc_4), _loc_7, _loc_5, _loc_4, 0, 0, param3);
        }

        public static function createFromByteArray(param1:String, param2:ByteArray, param3:int, param4:int, param5:Boolean) : FTexture
        {
            return new FTexture(param1, FTextureSourceType.BYTEARRAY, param2, new Rectangle(0, 0, param3, param4), param5, param3, param4);
        }

        public static function createRenderTexture(param1:String, param2:int, param3:int, param4:Boolean) : FTexture
        {
            return new FTexture(param1, FTextureSourceType.RENDER_TARGET, null, new Rectangle(0, 0, param2, param3), param4, param2, param3);
        }

    }
}
