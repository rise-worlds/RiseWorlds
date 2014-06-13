package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FEmitterGPU extends FRenderable
    {
        var aParticles:Vector.<Number>;
        var nCurrentTime:int = 0;
        var iMaxParticles:int;
        var iActiveParticles:int;
        var cTexture:FTexture;
        var sHash:String;
        protected var _cMaterial:FCameraTexturedParticlesBatchMaterial;
        private static var __aCached:Dictionary = new Dictionary();
        static var aTransformVector:Vector.<Number> = new Vector.<Number>(16);

        public function FEmitterGPU(param1:FNode)
        {
            super(param1);
            return;
        }// end function

        public function get activeParticles() : int
        {
            return iActiveParticles;
        }// end function

        public function set activeParticles(param1:int) : void
        {
            iActiveParticles = param1;
            return;
        }// end function

        public function setTexture(param1:FTexture) : void
        {
            cTexture = param1;
            return;
        }// end function

        public function get textureId() : String
        {
            if (cTexture)
            {
                return cTexture.id;
            }
            return "";
        }// end function

        public function set textureId(param1:String) : void
        {
            cTexture = FTexture.getTextureById(param1);
            return;
        }// end function

        public function initialize(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int, param7:Number, param8:Number, param9:Number, param10:Number, param11:Boolean, param12:Number, param13:Number, param14:int, param15:int, param16:int, param17:int = 0) : void
        {
            var _loc_21:* = 0;
            var _loc_20:* = NaN;
            var _loc_22:* = NaN;
            var _loc_19:* = NaN;
            var _loc_23:* = NaN;
            var _loc_18:* = NaN;
            sHash = param1 + "|" + param2 + "|" + param3 + "|" + param4 + "|" + param5 + "|" + param6 + "|" + param7 + "|" + param8 + "|" + param9 + "|" + param10 + "|" + param11 + "|" + param12 + "|" + param13 + "|" + param14 + "|" + param15 + "|" + param16 + "|" + param17;
            iMaxParticles = param16;
            aParticles = __aCached[sHash];
            if (aParticles != null)
            {
                return;
            }
            aParticles = new Vector.<Number>;
            cRenderData = null;
            _loc_21 = 0;
            while (_loc_21 < iMaxParticles)
            {
                
                aParticles.push(Math.random() * param2 - param2 * 0.5, Math.random() * param3 - param3 * 0.5);
                _loc_20 = Math.random() * param4 - param4 * 0.5;
                _loc_22 = Math.sin(_loc_20);
                _loc_19 = Math.cos(_loc_20);
                _loc_23 = Math.random() * (param6 - param5) + param5;
                aParticles.push(_loc_23 * _loc_19, _loc_23 * _loc_22);
                if (!param11)
                {
                    aParticles.push(Math.random() * (param8 - param7) + param7, Math.random() * (param10 - param9) + param9);
                }
                else
                {
                    _loc_18 = Math.random() * (param8 - param7) + param7;
                    aParticles.push(_loc_18, _loc_18);
                }
                aParticles.push(param12, param13);
                aParticles.push(_loc_21 * param1, Math.random() * (param15 - param14) + param14);
                _loc_21++;
            }
            __aCached[sHash] = aParticles;
            iActiveParticles = iMaxParticles;
            _cMaterial = FCameraTexturedParticlesBatchMaterial.getByHash(sHash);
            return;
        }// end function

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            nCurrentTime = nCurrentTime + param1;
            return;
        }// end function

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (cTexture == null || iMaxParticles == 0 || _cMaterial == null)
            {
                return;
            }
            if (param1.checkAndSetupRender(_cMaterial, iBlendMode, cTexture.premultiplied, param3))
            {
                _cMaterial.bind(param1.cContext, param1.bReinitialize, param2, aParticles);
            }
            var _loc_4:* = cNode.cTransform;
            aTransformVector[0] = _loc_4.nWorldX;
            aTransformVector[1] = _loc_4.nWorldY;
            aTransformVector[2] = cTexture.iWidth * _loc_4.nWorldScaleX;
            aTransformVector[3] = cTexture.iHeight * _loc_4.nWorldScaleY;
            aTransformVector[4] = cTexture.nUvX;
            aTransformVector[5] = cTexture.nUvY;
            aTransformVector[6] = cTexture.nUvScaleX;
            aTransformVector[7] = cTexture.nUvScaleY;
            aTransformVector[8] = _loc_4.nWorldRotation;
            aTransformVector[9] = nCurrentTime;
            aTransformVector[10] = 2;
            aTransformVector[11] = 1;
            aTransformVector[12] = 1;
            aTransformVector[13] = 1;
            aTransformVector[14] = 1;
            aTransformVector[15] = 0.1;
            _cMaterial.draw(aTransformVector, cTexture.cContextTexture.tTexture, cTexture.iFilteringType, iActiveParticles);
            return;
        }// end function

        new Vector.<Number>(16)[0] = 0;
        new Vector.<Number>(16)[1] = 0;
        new Vector.<Number>(16)[2] = 0;
        new Vector.<Number>(16)[3] = 0;
        new Vector.<Number>(16)[4] = 0;
        new Vector.<Number>(16)[5] = 0;
        new Vector.<Number>(16)[6] = 0;
        new Vector.<Number>(16)[7] = 0;
        new Vector.<Number>(16)[8] = 0;
        new Vector.<Number>(16)[9] = 0;
        new Vector.<Number>(16)[10] = 0;
        new Vector.<Number>(16)[11] = 0;
        new Vector.<Number>(16)[12] = 0;
        new Vector.<Number>(16)[13] = 0;
        new Vector.<Number>(16)[14] = 0;
        new Vector.<Number>(16)[15] = 0;
    }
}
