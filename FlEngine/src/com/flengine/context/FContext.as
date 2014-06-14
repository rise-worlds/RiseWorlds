package com.flengine.context
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.filters.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.error.*;
    import com.flengine.signals.*;
    import com.flengine.textures.*;
    import flash.display.*;
    import flash.display3D.*;
    import flash.events.*;
    import flash.geom.*;

    public class FContext extends Object
    {
        public var eInitialized:HelpSignal;
        public var eFailed:HelpSignal;
        private var __bInitialized:Boolean = false;
        public var bReinitialize:Boolean = false;
        public var cContext:Context3D;
        private var __mProjectionMatrix:Matrix3D;
        private var __stStage:Stage;
        private var __st3Stage3D:Stage3D;
        private var __cCore:FlEngine;
        public var cActiveMaterial:IGMaterial;
        public var iActiveBlendMode:int;
        public var bActivePremultiplied:Boolean;
        public var rActiveMaskRect:Rectangle;
        protected var _cRenderTarget:FTexture;
        protected var _cBlitColorMaterial:FBlitColorVertexShaderBatchMaterial;
        protected var _cBlitMaterial:FBlitTexturedVertexShaderBatchMaterial;
        protected var _cShadowMaterial:FShadowMaterial;
        protected var _cDrawColorShaderMaterial:FDrawColorCameraVertexShaderBatchMaterial;
        protected var _cDrawColorBufferMaterial:FDrawColorCameraVertexBufferCPUBatchMaterial;
        protected var _cDrawTextureShaderMaterial:FDrawTextureCameraVertexShaderBatchMaterial;
        protected var _cDrawTextureShaderMaterial2:FDrawTextureCameraVertexShaderBatchMaterial2;
        protected var _cDrawTextureBufferCPUMaterial:FDrawTextureCameraVertexBufferCPUBatchMaterial;
        protected var _aBlitColorTransform:Vector.<Number>;
        protected var _aBlitTexturedTransform:Vector.<Number>;
        private var __cActiveCamera:FCamera;
        private var __iActiveStencilMaskLayer:int = 0;
        public static const NEAR:int = 0;
        public static const FAR:int = 100;

        public function FContext(param1:FlEngine)
        {
            eInitialized = new HelpSignal();
            eFailed = new HelpSignal();
            rActiveMaskRect = new Rectangle();
            new Vector.<Number>(8)[0] = 0;
            new Vector.<Number>(8)[1] = 0;
            new Vector.<Number>(8)[2] = 0;
            new Vector.<Number>(8)[3] = 0;
            new Vector.<Number>(8)[4] = 0;
            new Vector.<Number>(8)[5] = 0;
            new Vector.<Number>(8)[6] = 0;
            new Vector.<Number>(8)[7] = 0;
            _aBlitColorTransform = new Vector.<Number>(8);
            new Vector.<Number>(8)[0] = 0;
            new Vector.<Number>(8)[1] = 0;
            new Vector.<Number>(8)[2] = 0;
            new Vector.<Number>(8)[3] = 0;
            new Vector.<Number>(8)[4] = 0;
            new Vector.<Number>(8)[5] = 0;
            new Vector.<Number>(8)[6] = 0;
            new Vector.<Number>(8)[7] = 0;
            _aBlitTexturedTransform = new Vector.<Number>(8);
            __cCore = param1;
            return;
        }

        public function get context() : Context3D
        {
            return cContext;
        }

        public function setCamera(param1:FCamera) : void
        {
            if (__cActiveCamera == param1)
            {
                return;
            }
            if (cActiveMaterial != null)
            {
                cActiveMaterial.push();
                cActiveMaterial.clear();
                cActiveMaterial = null;
            }
            __cActiveCamera = param1;
            return;
        }

        public function init(param1:Stage, param2:Stage3D = null) : void
        {
            __stStage = param1;
            if (param2 == null)
            {
                __st3Stage3D = __stStage.stage3Ds[0];
                __st3Stage3D.addEventListener("context3DCreate", onContextInitialized);
                __st3Stage3D.addEventListener("error", onContextError);
                initStage3D();
            }
            else
            {
                onContextInitialized(null);
            }
            return;
        }

        private function initStage3D() : void
        {
            if (__st3Stage3D.requestContext3D.length == 1)
            {
                __st3Stage3D.requestContext3D(__cCore.cConfig.renderMode);
            }
            else
            {
                __st3Stage3D.requestContext3D(__cCore.cConfig.renderMode, __cCore.cConfig.profile);
            }
            return;
        }

        public function dispose() : void
        {
            eInitialized.dispose();
            eInitialized = null;
            eFailed.dispose();
            eFailed = null;
            __stStage.stage3Ds[0].removeEventListener("context3DCreate", onContextInitialized);
            __stStage.stage3Ds[0].removeEventListener("error", onContextError);
            cContext.dispose();
            return;
        }

        private function onContextError(event:ErrorEvent) : void
        {
            eFailed.dispatch(event);
            return;
        }

        private function onContextInitialized(event:Event) : void
        {
            var _loc_2:* = null;
            if (__cCore.cConfig.externalStage3D == null)
            {
                _loc_2 = event.target as Stage3D;
                cContext = _loc_2.context3D;
                cContext.enableErrorChecking = false;
            }
            else
            {
                cContext = __cCore.cConfig.externalStage3D.context3D;
            }
            invalidate();
            _cBlitColorMaterial = new FBlitColorVertexShaderBatchMaterial();
            _cBlitMaterial = new FBlitTexturedVertexShaderBatchMaterial();
            _cShadowMaterial = new FShadowMaterial();
            _cDrawColorShaderMaterial = new FDrawColorCameraVertexShaderBatchMaterial();
            _cDrawColorBufferMaterial = new FDrawColorCameraVertexBufferCPUBatchMaterial();
            _cDrawTextureShaderMaterial = new FDrawTextureCameraVertexShaderBatchMaterial();
            _cDrawTextureShaderMaterial2 = new FDrawTextureCameraVertexShaderBatchMaterial2();
            _cDrawTextureBufferCPUMaterial = new FDrawTextureCameraVertexBufferCPUBatchMaterial();
            FTextureBase.invalidate();
            if (!__bInitialized)
            {
                eInitialized.dispatch(null);
                __bInitialized = true;
            }
            bReinitialize = true;
            return;
        }

        private function getProjectionMatrix(param1:int, param2:int, param3:Matrix3D = null) : Matrix3D
        {
            var _loc_4:* = new Matrix3D(this.Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 1]));
            _loc_4.prependTranslation((-param1) / 2, (-param2) / 2, 0);
            _loc_4.appendScale(2 / param1, -2 / param2, 1);
            if (param3)
            {
                _loc_4.prepend(param3);
            }
            return _loc_4;
        }

        public function invalidate() : void
        {
            if (__cCore.cConfig.externalStage3D == null)
            {
                __st3Stage3D.x = __cCore.cConfig.viewRect.left;
                __st3Stage3D.y = __cCore.cConfig.viewRect.top;
                if (cContext == null)
                {
                    return;
                }
                try
                {
                    cContext.configureBackBuffer(__cCore.cConfig.viewRect.width, __cCore.cConfig.viewRect.height, __cCore.cConfig.antiAliasing, __cCore.cConfig.enableDepthAndStencil);
                }
                catch (e:Error)
                {
                    throw new FError("FError: Cannot initialize Context3D.");
                }
            }
            __cCore.cDefaultCamera.node.cTransform.x = __cCore.cConfig.viewRect.width / 2;
            __cCore.cDefaultCamera.node.cTransform.y = __cCore.cConfig.viewRect.height / 2;
            __mProjectionMatrix = getProjectionMatrix(__cCore.cConfig.viewRect.width, __cCore.cConfig.viewRect.height);
            return;
        }

        public function createTexture(param1:int, param2:int, param3:String, param4:Boolean) : FContextTexture
        {
            return new FContextTexture(cContext, param1, param2, param3, param4);
        }

        public function begin(param1:Number, param2:Number, param3:Number) : void
        {
            FStats.clear();
            _cRenderTarget = null;
            cActiveMaterial = null;
            bActivePremultiplied = true;
            iActiveBlendMode = 0;
            __cActiveCamera = __cCore.cDefaultCamera;
            if (__cCore.cConfig.externalStage3D == null)
            {
                cContext.clear(param1, param2, param3, 1);
            }
            cContext.setDepthTest(false, "always");
            cContext.setStencilActions("frontAndBack", "always", "keep", "keep", "keep");
            FBlendMode.setBlendMode(cContext, 0, bActivePremultiplied);
            cContext.setProgramConstantsFromMatrix("vertex", 0, __mProjectionMatrix, true);
            return;
        }

        public function end() : void
        {
            if (__cCore.cConfig.enableStats)
            {
                FStats.draw();
            }
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
                cActiveMaterial.clear();
            }
            if (__cCore.cConfig.externalStage3D == null)
            {
                cContext.present();
            }
            bReinitialize = false;
            return;
        }

        public function blitColor(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:int, param10:Rectangle) : void
        {
            var _loc_12:* = _cBlitColorMaterial != cActiveMaterial;
            var _loc_11:* = param9 != iActiveBlendMode;
            var _loc_13:* = !rActiveMaskRect.equals(param10);
            if (_cBlitColorMaterial != cActiveMaterial)
            {
                if (cActiveMaterial != null)
                {
                    cActiveMaterial.push();
                    cActiveMaterial.clear();
                }
                if (_loc_12)
                {
                    cActiveMaterial = _cBlitColorMaterial;
                    _cBlitColorMaterial.bind(cContext, bReinitialize);
                }
                if (_loc_11)
                {
                    iActiveBlendMode = param9;
                    FBlendMode.setBlendMode(cContext, iActiveBlendMode, bActivePremultiplied);
                }
                if (_loc_13)
                {
                    rActiveMaskRect.setTo(param10.x, param10.y, param10.width, param10.height);
                    cContext.setScissorRectangle(rActiveMaskRect);
                }
            }
            _aBlitColorTransform[0] = param1;
            _aBlitColorTransform[1] = param2;
            _aBlitColorTransform[2] = param3;
            _aBlitColorTransform[3] = param4;
            _aBlitColorTransform[4] = param5;
            _aBlitColorTransform[5] = param6;
            _aBlitColorTransform[6] = param7;
            _aBlitColorTransform[7] = param8;
            _cBlitColorMaterial.draw(_aBlitColorTransform);
            return;
        }

        public function blit(param1:FTexture, param2:Number, param3:Number, param4:Number = 1, param5:Number = 1, param6:int = 1, param7:Rectangle = null) : void
        {
            var _loc_9:* = null;
            var _loc_10:* = _cBlitMaterial != cActiveMaterial;
            var _loc_8:* = param6 != iActiveBlendMode || param1.premultiplied != bActivePremultiplied;
            if (_loc_10 || _loc_8)
            {
                if (cActiveMaterial != null)
                {
                    cActiveMaterial.push();
                    if (_loc_10)
                    {
                        cActiveMaterial.clear();
                    }
                }
                if (_loc_10)
                {
                    cActiveMaterial = _cBlitMaterial;
                    _cBlitMaterial.bind(cContext, bReinitialize);
                    if (!rActiveMaskRect.equals(__cCore.cDefaultCamera.rViewRectangle))
                    {
                        _loc_9 = __cCore.cDefaultCamera.rViewRectangle;
                        rActiveMaskRect.setTo(_loc_9.x, _loc_9.y, _loc_9.width, _loc_9.height);
                        cContext.setScissorRectangle(rActiveMaskRect);
                    }
                }
                if (_loc_8)
                {
                    iActiveBlendMode = param6;
                    bActivePremultiplied = param1.premultiplied;
                    FBlendMode.setBlendMode(cContext, iActiveBlendMode, bActivePremultiplied);
                }
            }
            _cBlitMaterial.draw(param2, param3, param4, param5, param1);
            return;
        }

        public function drawShadow(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number = 1, param9:Rectangle = null) : void
        {
            if (param9 == null)
            {
                param9 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cShadowMaterial, iActiveBlendMode, bActivePremultiplied, param9))
            {
                _cShadowMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cShadowMaterial.draw(param1, param2, param3, param4, param5, param6, param7, param8);
            return;
        }

        public function drawLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1, param6:Number = 1, param7:Number = 1, param8:Number = 1, param9:Number = 1, param10:int = 1, param11:Rectangle = null) : void
        {
            if (param11 == null)
            {
                param11 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawColorShaderMaterial, param10, bActivePremultiplied, param11))
            {
                _cDrawColorShaderMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            var _loc_16:* = (param1 + param3) * 0.5;
            var _loc_15:* = (param2 + param4) * 0.5;
            var _loc_13:* = Math.sqrt((param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4));
            var _loc_14:* = (param3 - param1) / _loc_13;
            var _loc_12:* = 0;
            if (_loc_13 > 0.001)
            {
                if (param2 < param4)
                {
                    _loc_12 = Math.acos(_loc_14) + Math.PI;
                }
                else
                {
                    _loc_12 = Math.acos(-_loc_14);
                }
            }
            _cDrawColorShaderMaterial.draw(_loc_16, _loc_15, _loc_13, param5, _loc_12, param6, param7, param8, param9);
            return;
        }

        public function drawColorQuad(param1:Number, param2:Number, param3:Number = 1, param4:Number = 1, param5:Number = 0, param6:Number = 1, param7:Number = 1, param8:Number = 1, param9:Number = 1, param10:int = 1, param11:Rectangle = null) : void
        {
            if (param11 == null)
            {
                param11 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawColorShaderMaterial, param10, bActivePremultiplied, param11))
            {
                _cDrawColorShaderMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cDrawColorShaderMaterial.draw(param1, param2, param3, param4, param5, param6, param7, param8, param9);
            return;
        }

        public function drawColorPoly(param1:Vector.<Number>, param2:Number, param3:Number, param4:Number = 1, param5:Number = 1, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1, param10:Number = 1, param11:int = 1, param12:Rectangle = null) : void
        {
            if (param12 == null)
            {
                param12 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawColorBufferMaterial, param11, bActivePremultiplied, param12))
            {
                _cDrawColorBufferMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cDrawColorBufferMaterial.drawPoly(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10);
            return;
        }

        public function draw(param1:FTexture, param2:Number, param3:Number, param4:Number = 1, param5:Number = 1, param6:Number = 0, param7:Number = 1, param8:Number = 1, param9:Number = 1, param10:Number = 1, param11:int = 1, param12:Rectangle = null, param13:FFilter = null) : void
        {
            if (param10 == 0 || param1 == null)
            {
                return;
            }
            if (param12 == null)
            {
                param12 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawTextureShaderMaterial, param11, param1.premultiplied, param12))
            {
                _cDrawTextureShaderMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cDrawTextureShaderMaterial.draw(param2, param3, param4, param5, param6, param7, param8, param9, param10, param1, param13);
            return;
        }

        public function draw2(param1:FTexture, param2:Matrix, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:int = 1, param8:Rectangle = null, param9:FFilter = null) : void
        {
            if (param6 == 0)
            {
                return;
            }
            if (param8 == null)
            {
                param8 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawTextureBufferCPUMaterial, param7, param1.premultiplied, param8))
            {
                _cDrawTextureBufferCPUMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cDrawTextureBufferCPUMaterial.drawMatrix(param2, param3, param4, param5, param6, param1, param9);
            return;
        }

        public function draw3(param1:FTexture, param2:Matrix, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:int = 1, param8:Rectangle = null, param9:FFilter = null) : void
        {
            if (param6 == 0 || param1 == null)
            {
                return;
            }
            if (param8 == null)
            {
                param8 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawTextureShaderMaterial2, param7, param1.premultiplied, param8))
            {
                _cDrawTextureShaderMaterial2.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cDrawTextureShaderMaterial2.draw(param2, param3, param4, param5, param6, param1, param9);
            return;
        }

        public function drawPoly(param1:FTexture, param2:Vector.<Number>, param3:Vector.<Number>, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number = 1, param10:Number = 1, param11:Number = 1, param12:Number = 1, param13:int = 1, param14:Rectangle = null, param15:FFilter = null) : void
        {
            if (param12 == 0)
            {
                return;
            }
            if (param14 == null)
            {
                param14 = __cActiveCamera.rViewRectangle;
            }
            if (checkAndSetupRender(_cDrawTextureBufferCPUMaterial, param13, param1.premultiplied, param14))
            {
                _cDrawTextureBufferCPUMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            }
            _cDrawTextureBufferCPUMaterial.drawPoly(param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param1, param15);
            return;
        }

        public function checkAndSetupRender(param1:IGMaterial, param2:int, param3:Boolean, param4:Rectangle) : Boolean
        {
            var _loc_7:* = param1 != cActiveMaterial || cActiveMaterial == null;
            var _loc_5:* = param2 != iActiveBlendMode || param3 != bActivePremultiplied;
            var _loc_6:* = !rActiveMaskRect.equals(param4);
            if (_loc_7 || _loc_5 || _loc_6)
            {
                if (cActiveMaterial != null)
                {
                    cActiveMaterial.push();
                    if (_loc_7)
                    {
                        cActiveMaterial.clear();
                    }
                }
                if (_loc_7)
                {
                    cActiveMaterial = param1;
                }
                if (_loc_5)
                {
                    iActiveBlendMode = param2;
                    bActivePremultiplied = param3;
                    FBlendMode.setBlendMode(cContext, iActiveBlendMode, bActivePremultiplied);
                }
                if (_loc_6)
                {
                    rActiveMaskRect.setTo(param4.x, param4.y, param4.width, param4.height);
                    cContext.setScissorRectangle(rActiveMaskRect);
                }
            }
            return _loc_7;
        }

        public function push() : void
        {
            if (cActiveMaterial != null)
            {
                cActiveMaterial.push();
            }
            return;
        }

        public function clearStencil() : void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            }
            cContext.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.STENCIL);
            return;
        }

        public function renderAsStencilMask(param1:int) : void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            }
            __iActiveStencilMaskLayer = param1;
            cContext.setStencilReferenceValue(__iActiveStencilMaskLayer);
            cContext.setStencilActions("frontAndBack", "greaterEqual", "incrementSaturate");
            cContext.setColorMask(false, false, false, false);
            return;
        }

        public function renderToColor(param1:int) : void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            }
            __iActiveStencilMaskLayer = param1;
            cContext.setStencilReferenceValue(__iActiveStencilMaskLayer);
            cContext.setStencilActions("frontAndBack", "lessEqual", "keep");
            cContext.setColorMask(true, true, true, true);
            return;
        }

        public function setRenderTarget(param1:FTexture = null, param2:Matrix3D = null, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0) : void
        {
            if (_cRenderTarget == param1)
            {
                return;
            }
            if (cActiveMaterial != null)
            {
                cActiveMaterial.push();
            }
            if (param1 == null)
            {
                cContext.setRenderToBackBuffer();
                cContext.setProgramConstantsFromMatrix("vertex", 0, param2 ? (getProjectionMatrix(__cCore.cConfig.viewRect.width, __cCore.cConfig.viewRect.height, param2)) : (__mProjectionMatrix), true);
            }
            else
            {
                cContext.setRenderToTexture(param1.cContextTexture.tTexture, __cCore.cConfig.enableDepthAndStencil, __cCore.cConfig.antiAliasing);
                cContext.clear(param3, param4, param5, param6);
                cContext.setProgramConstantsFromMatrix("vertex", 0, getProjectionMatrix(param1.gpuWidth, param1.gpuHeight, param2), true);
            }
            _cRenderTarget = param1;
            return;
        }

        public function getRenderTarget() : FTexture
        {
            return _cRenderTarget;
        }

        public function drawToBitmapData(param1:BitmapData) : void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            }
            cContext.drawToBitmapData(param1);
            return;
        }

    }
}
