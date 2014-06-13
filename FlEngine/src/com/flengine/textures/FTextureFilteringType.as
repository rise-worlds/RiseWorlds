package com.flengine.textures
{
    import com.flengine.error.*;

    public class FTextureFilteringType extends Object
    {
        public static const NEAREST:int = 0;
        public static const LINEAR:int = 1;

        public function FTextureFilteringType()
        {
            throw new FError("FError: Cannot instantiate abstract class.");
        }// end function

        static function isValid(param1:int) : Boolean
        {
            if (param1 == 0 || param1 == 1)
            {
                return true;
            }
            return false;
        }// end function

    }
}
