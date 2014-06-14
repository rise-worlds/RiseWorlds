package com.flengine.textures
{
    import com.flengine.error.*;

    public class FTextureFilteringType extends Object
    {
        public static const NEAREST:int = 0;
        public static const LINEAR:int = 1;

        public function FTextureFilteringType()
        {
            throw new FError(FError.CANNOT_INSTANTATE_ABSTRACT);
        }

        static public function isValid(param1:int) : Boolean
        {
            if (param1 == NEAREST || param1 == LINEAR)
            {
                return true;
            }
            return false;
        }

    }
}
