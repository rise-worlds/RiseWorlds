package com.flengine.context.filters
{
    import __AS3__.vec.*;

    public class FDesaturateFilter extends FFilter
    {

        public function FDesaturateFilter()
        {
            iId = 6;
            fragmentCode = "dp3 ft0.xyz, ft0.xyz, fc1.xyz";
            new Vector.<Number>(4)[0] = 0.299;
            new Vector.<Number>(4)[1] = 0.587;
            new Vector.<Number>(4)[2] = 0.114;
            new Vector.<Number>(4)[3] = 0;
            _aFragmentConstants = new Vector.<Number>(4);
            return;
        }

    }
}
