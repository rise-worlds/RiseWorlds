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
            throw new FError("FError: Cannot instantiate abstract class.");
        }// end function

        static function isValid(param1:int) : Boolean
        {
            if (param1 == 0 || param1 == 1 || param1 == 2 || param1 == 3 || param1 == 4)
            {
                return true;
            }
            return false;
        }// end function

    }
}
