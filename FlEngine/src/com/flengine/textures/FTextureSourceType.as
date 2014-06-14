package com.flengine.textures
{
    import com.flengine.error.*;

    public class FTextureSourceType extends Object
    {
        public static const ATF_BGRA:int = 0;
        public static const ATF_COMPRESSED:int = 1;
        public static const ATF_COMPRESSEDALPHA:int = 2;
        public static const BYTEARRAY:int = 2;
        public static const BITMAPDATA:int = 3;
        public static const RENDER_TARGET:int = 4;

        public function FTextureSourceType()
        {
            throw new FError(FError.CANNOT_INSTANTATE_ABSTRACT);
        }

        public static function isValid(param1:int) : Boolean
        {
            if (param1 == ATF_COMPRESSED || param1 == ATF_COMPRESSEDALPHA || param1 == BYTEARRAY || param1 == BITMAPDATA || param1 == RENDER_TARGET)
            {
                return true;
            }
            return false;
        }

    }
}
