package com.flengine.textures
{
    import com.flengine.error.*;

    public class FTextureResampleType extends Object
    {
        public static const NEAREST_RESAMPLE:int = 0;
        public static const NEAREST_DOWN_RESAMPLE_UP_CROP:int = 1;
        public static const UP_CROP:int = 2;
        public static const UP_RESAMPLE:int = 3;
        public static const DOWN_RESAMPLE:int = 4;
        public static const NEAREST_RESAMPLE_WIDTH:int = 5;
        public static const NEAREST_RESAMPLE_HEIGHT:int = 6;

        public function FTextureResampleType()
        {
            throw new FError(FError.CANNOT_INSTANTATE_ABSTRACT);
        }

        static public function isValid(param1:int) : Boolean
        {
            if (param1 == NEAREST_RESAMPLE || param1 == NEAREST_DOWN_RESAMPLE_UP_CROP || param1 == UP_CROP || param1 == UP_RESAMPLE || param1 == DOWN_RESAMPLE)
            {
                return true;
            }
            return false;
        }

    }
}
