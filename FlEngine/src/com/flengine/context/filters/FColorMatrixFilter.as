package com.flengine.context.filters
{
    import __AS3__.vec.*;

    public class FColorMatrixFilter extends FFilter
    {
        private static const IDENTITY_MATRIX:Vector.<Number> = new Vector.<Number>(20);

        public function FColorMatrixFilter(param1:Vector.<Number> = null)
        {
            iId = 5;
            setMatrix(param1 == null ? (IDENTITY_MATRIX) : (param1));
            fragmentCode = "max ft0, ft0, fc6             \ndiv ft0.xyz, ft0.xyz, ft0.www \nm44 ft0, ft0, fc1             \nadd ft0, ft0, fc5             \nmul ft0.xyz, ft0.xyz, ft0.www \n";
            return;
        }

        public function setMatrix(param1:Vector.<Number>) : void
        {
            _aFragmentConstants.unshift(param1[0], param1[1], param1[2], param1[3], param1[5], param1[6], param1[7], param1[8], param1[10], param1[11], param1[12], param1[13], param1[15], param1[16], param1[17], param1[18], param1[4] / 255, param1[9] / 255, param1[14] / 255, param1[19] / 255, 0, 0, 0, 0.0001);
            _aFragmentConstants.length = 24;
            return;
        }

        new Vector.<Number>(20)[0] = 1;
        new Vector.<Number>(20)[1] = 0;
        new Vector.<Number>(20)[2] = 0;
        new Vector.<Number>(20)[3] = 0;
        new Vector.<Number>(20)[4] = 0;
        new Vector.<Number>(20)[5] = 0;
        new Vector.<Number>(20)[6] = 1;
        new Vector.<Number>(20)[7] = 0;
        new Vector.<Number>(20)[8] = 0;
        new Vector.<Number>(20)[9] = 0;
        new Vector.<Number>(20)[10] = 0;
        new Vector.<Number>(20)[11] = 0;
        new Vector.<Number>(20)[12] = 1;
        new Vector.<Number>(20)[13] = 0;
        new Vector.<Number>(20)[14] = 0;
        new Vector.<Number>(20)[15] = 0;
        new Vector.<Number>(20)[16] = 0;
        new Vector.<Number>(20)[17] = 0;
        new Vector.<Number>(20)[18] = 1;
        new Vector.<Number>(20)[19] = 0;
    }
}
