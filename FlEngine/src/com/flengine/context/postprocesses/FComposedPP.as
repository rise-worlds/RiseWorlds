package com.flengine.context.postprocesses
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FComposedPP extends FPostProcess
    {
        protected var _cEmptyPass:FFilterPP;
        protected var _aPostProcesses:Vector.<FPostProcess>;

        public function FComposedPP(param1:Vector.<FPostProcess>)
        {
            super((param1.length + 1));
            throw new Error("Not supported yet.");
            new Vector.<FFilter>(1)[0] = null;
            _cEmptyPass = new FFilterPP(new Vector.<FFilter>(1));
            _aPostProcesses = param1;
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void
        {
            var _loc_10:* = 0;
            var _loc_8:* = _rDefinedBounds ? (_rDefinedBounds) : (param4.getWorldBounds(_rActiveBounds));
            if ((_loc_8).x == 17976931348623161000000000000)
            {
                return;
            }
            updatePassTextures(_loc_8);
            _cEmptyPass.render(param1, param2, param3, param4, _loc_8, null, _aPassTextures[0]);
            var _loc_9:* = _aPostProcesses.length;
            _loc_10 = 0;
            while (_loc_10 < (_loc_9 - 1))
            {
                
                _aPostProcesses[_loc_10].render(param1, param2, param3, param4, _loc_8, _aPassTextures[_loc_10], _aPassTextures[(_loc_10 + 1)]);
                _loc_10++;
            }
            _aPostProcesses[(_loc_9 - 1)].render(param1, param2, param3, param4, _loc_8, _aPassTextures[(_loc_9 - 1)], null);
            return;
        }

    }
}
