package com.flengine.context.postprocesses
{
    import __AS3__.vec.*;

    public class FFilterPP extends FPostProcess
    {

        public function FFilterPP(param1:Vector.<FFilter>)
        {
            super(param1.length);
            _aPassFilters = param1;
            return;
        }

    }
}
