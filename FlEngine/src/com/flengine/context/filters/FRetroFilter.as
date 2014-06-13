package com.flengine.context.filters
{
    import __AS3__.vec.*;

    public class FRetroFilter extends FFilter
    {

        public function FRetroFilter()
        {
            iId = 12;
            fragmentCode = "dp3 ft2.x, ft0.xyz, fc1.xyz    \nsub ft3.xyz, fc1.www, ft2.xxx  \nsub ft4.xyz, fc1.www, ft0.xyz  \nmul ft3.xyz, ft3.xyz, ft4.xyz  \nadd ft3.xyz, ft3.xyz, ft3.xyz  \nsub ft3.xyz, fc1.www, ft3.xyz  \nmul ft4.xyz, ft2.xxx, ft0.xyz  \nadd ft4.xyz, ft4.xyz, ft4.xyz  \nsge ft1.xyz, ft0.xyz, fc2.www  \nslt ft5.xyz, ft0.xyz, fc2.www  \nmul ft1.xyz, ft1.xyz, ft3.xyz  \nmul ft5.xyz, ft5.xyz, ft4.xyz  \nadd ft1.xyz, ft1.xyz, ft5.xyz  \nmul ft1.xyz, ft1.xyz, fc2.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmul ft1.xyz, fc3.xyz, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmul ft1.xyz, fc4.xyz, ft1.xyz  \nsub ft1.xyz, fc1.www, ft1.xyz  \nmov ft0.xyz, ft1.xyz           \n";
            new Vector.<Number>(16)[0] = 0.3;
            new Vector.<Number>(16)[1] = 0.59;
            new Vector.<Number>(16)[2] = 0.11;
            new Vector.<Number>(16)[3] = 1;
            new Vector.<Number>(16)[4] = 0.579008;
            new Vector.<Number>(16)[5] = 0.558247;
            new Vector.<Number>(16)[6] = 0.376009;
            new Vector.<Number>(16)[7] = 0.5;
            new Vector.<Number>(16)[8] = 0.818039;
            new Vector.<Number>(16)[9] = 0.920784;
            new Vector.<Number>(16)[10] = 0.859608;
            new Vector.<Number>(16)[11] = 0;
            new Vector.<Number>(16)[12] = 0.994048;
            new Vector.<Number>(16)[13] = 0.951726;
            new Vector.<Number>(16)[14] = 0.845921;
            new Vector.<Number>(16)[15] = 0;
            _aFragmentConstants = new Vector.<Number>(16);
            return;
        }// end function

    }
}
