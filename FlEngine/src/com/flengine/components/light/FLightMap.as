package com.flengine.components.light
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.components.renderables.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import com.flengine.textures.factories.*;
    import flash.display3D.*;
    import flash.geom.*;

    public class FLightMap extends FRenderable
    {
        protected var _cLightMap:FTexture;
        protected var _cLightMapBlurred:FTexture;
        protected var _nLightMapScale:Number = 1;
        protected var _cBlurV:FBlurPassFilter;
        protected var _cBlurH:FBlurPassFilter;
        public var ambientRed:Number = 0;
        public var ambientGreen:Number = 0;
        public var ambientBlue:Number = 0;
        public var ambientAlpha:Number = 1;
        public var softShadows:Boolean = false;
        public var stencilOverdraw:Boolean = false;
        public var pad:int = 20;
        protected var _aLights:Vector.<FLight>;
        protected var _cCasterContainer:FNode;
        protected var _aSpotVertices:Vector.<Number>;
        private static var __iCount:int = 0;

        public function FLightMap(param1:FNode)
        {
            _aLights = new Vector.<FLight>;
            _aSpotVertices = new Vector.<Number>(6);
            super(param1);
            (__iCount + 1);
            _cLightMap = FTextureFactory.createRenderTexture("lightMap_gen" + __iCount, node.core.config.viewRect.width + pad, node.core.config.viewRect.height + pad, false);
            _cLightMap.filteringType = 1;
            _cLightMapBlurred = FTextureFactory.createRenderTexture("lightMapBlurred_gen" + __iCount, node.core.config.viewRect.width + pad, node.core.config.viewRect.height + pad, false);
            _cLightMapBlurred.filteringType = 1;
            _cBlurV = new FBlurPassFilter(4, 0);
            _cBlurH = new FBlurPassFilter(4, 1);
            return;
        }// end function

        public function get lights() : Vector.<FLight>
        {
            return _aLights;
        }// end function

        public function set casterContainer(param1:FNode) : void
        {
            _cCasterContainer = param1;
            return;
        }// end function

        public function addLight(param1:FLight) : void
        {
            _aLights.push(param1);
            return;
        }// end function

        public function removeLight(param1:FLight) : void
        {
            _aLights.splice(_aLights.indexOf(param1), 1);
            return;
        }// end function

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            var _loc_7:* = 0;
            var _loc_6:* = null;
            param1.setRenderTarget(_cLightMap, null, ambientRed, ambientGreen, ambientBlue, ambientAlpha);
            var _loc_5:* = node.core.defaultCamera;
            _loc_5.aCameraVector[4] = param2.cNode.cTransform.nWorldX;
            _loc_5.aCameraVector[5] = param2.cNode.cTransform.nWorldY;
            var _loc_4:* = _aLights.length;
            _loc_7 = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_6 = _aLights[_loc_7];
                if (!(_loc_6.active == false || !_loc_6.node.isOnStage()))
                {
                    if (_loc_6 is FSpotLight)
                    {
                        drawSpotLight(param1, _loc_6 as FSpotLight);
                    }
                    else
                    {
                        drawOmniLight(param1, _loc_6, param2.zoom);
                    }
                }
                _loc_7++;
            }
            if (softShadows)
            {
                param1.setRenderTarget(_cLightMapBlurred, null, ambientRed, ambientGreen, ambientBlue, ambientAlpha);
                param1.setCamera(FlEngine.getInstance().defaultCamera);
                param1.draw(_cLightMap, _nLightMapScale * _cLightMap.width * 0.5, _nLightMapScale * _cLightMap.height * 0.5, 1, 1, 0, 1, 1, 1, 1, 1, null, _cBlurV);
                param1.setRenderTarget(null);
                param1.setCamera(param2);
                param1.draw(_cLightMapBlurred, param2.cNode.cTransform.nWorldX, param2.cNode.cTransform.nWorldY, 1 / _nLightMapScale, 1 / _nLightMapScale, 0, 1, 1, 1, 1, 3, null, _cBlurH);
            }
            else
            {
                param1.setRenderTarget(null);
                param1.setCamera(param2);
                param1.draw(_cLightMap, param2.cNode.cTransform.nWorldX, param2.cNode.cTransform.nWorldY, 1 / (param2.zoom * _nLightMapScale), 1 / (param2.zoom * _nLightMapScale), 0, 1, 1, 1, 1, 3);
            }
            return;
        }// end function

        protected function drawOmniLight(param1:FContext, param2:FLight, param3:Number) : void
        {
            var _loc_10:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_11:* = param2.cNode.cTransform.nWorldX;
            var _loc_9:* = param2.cNode.cTransform.nWorldY;
            var _loc_8:* = param1.context;
            if (param2.shadows)
            {
                param1.push();
                _loc_8.setCulling("front");
                _loc_8.setStencilReferenceValue(1);
                _loc_8.setStencilActions("frontAndBack", "always", "set");
                _loc_8.setColorMask(false, false, false, false);
                _loc_4 = _cCasterContainer.firstChild;
                while (_loc_4)
                {
                    
                    _loc_5 = _loc_4.getComponent(FSprite) as FTexturedQuad;
                    if (_loc_5 == null)
                    {
                    }
                    if (_loc_5 != null)
                    {
                        _loc_6 = Math.abs(_loc_11 - _loc_4.cTransform.x);
                        _loc_7 = Math.abs(_loc_9 - _loc_4.cTransform.y);
                        if (_loc_6 * _loc_6 + _loc_7 * _loc_7 < param2.iRadiusSquared)
                        {
                            param1.drawShadow(_loc_4.cTransform.nWorldX * _nLightMapScale, _loc_4.cTransform.nWorldY * _nLightMapScale, _loc_5.getTexture().width * _nLightMapScale * _loc_4.cTransform.nWorldScaleX, _loc_5.getTexture().height * _nLightMapScale * _loc_4.cTransform.nWorldScaleY, _loc_4.transform.rotation, _loc_11 * _nLightMapScale, _loc_9 * _nLightMapScale, _loc_4.userData.shadowDepth);
                        }
                    }
                    _loc_4 = _loc_4.next;
                }
                param1.push();
                if (stencilOverdraw)
                {
                    _loc_8.setCulling("back");
                    _loc_8.setStencilReferenceValue(0);
                    _loc_4 = _cCasterContainer.firstChild;
                    while (_loc_4)
                    {
                        
                        _loc_5 = _loc_4.getComponent(FSprite) as FTexturedQuad;
                        if (_loc_5 == null)
                        {
                        }
                        if (_loc_5 != null)
                        {
                            _loc_6 = Math.abs(_loc_11 - _loc_4.transform.x);
                            _loc_7 = Math.abs(_loc_9 - _loc_4.transform.y);
                            if (_loc_6 * _loc_6 + _loc_7 * _loc_7 < param2.iRadiusSquared)
                            {
                                param1.drawColorQuad(_loc_4.cTransform.nWorldX * _nLightMapScale, _loc_4.cTransform.nWorldY * _nLightMapScale, _loc_5.getTexture().width * _nLightMapScale, _loc_5.getTexture().height * _nLightMapScale, _loc_4.transform.rotation);
                            }
                        }
                        _loc_4 = _loc_4.next;
                    }
                    param1.push();
                }
                _loc_8.setCulling("back");
                _loc_8.setStencilReferenceValue(0);
                _loc_8.setColorMask(true, true, true, true);
                _loc_8.setStencilActions("frontAndBack", "equal", "keep");
            }
            param1.draw(param2.getTexture(), _loc_11 * _nLightMapScale, _loc_9 * _nLightMapScale, _nLightMapScale * param2.cNode.cTransform.nWorldScaleX, _nLightMapScale * param2.cNode.cTransform.nWorldScaleY, param2.cNode.cTransform.nWorldRotation, param2.cNode.cTransform.nWorldRed, param2.cNode.cTransform.nWorldGreen, param2.cNode.cTransform.nWorldBlue, param2.cNode.cTransform.nWorldAlpha, 2);
            if (param2.shadows)
            {
                param1.push();
                _loc_8.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.STENCIL);
            }
            return;
        }// end function

        protected function drawSpotLight(param1:FContext, param2:FSpotLight) : void
        {
            var _loc_7:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_11:* = NaN;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_13:* = param2.cNode.cTransform.nWorldX;
            var _loc_12:* = param2.cNode.cTransform.nWorldY;
            var _loc_6:* = param1.context;
            _loc_6.clear(0, 0, 0, 1, 1, 1, Context3DClearMask.STENCIL);
            _loc_6.setCulling("front");
            _loc_6.setStencilReferenceValue(1);
            _loc_6.setStencilActions("frontAndBack", "always", "set");
            _loc_6.setColorMask(false, false, false, false);
            var _loc_8:* = 0;
            var _loc_3:* = param2.dispersion;
            _aSpotVertices[0] = 0;
            _aSpotVertices[1] = 0;
            _aSpotVertices[2] = Math.cos(_loc_8 + _loc_3) * 1000;
            _aSpotVertices[3] = Math.sin(_loc_8 + _loc_3) * 1000;
            _aSpotVertices[4] = Math.cos(_loc_8 - _loc_3) * 1000;
            _aSpotVertices[5] = Math.sin(_loc_8 - _loc_3) * 1000;
            param1.drawColorPoly(_aSpotVertices, _loc_13 * _nLightMapScale, _loc_12 * _nLightMapScale, 1, 1, param2.cNode.cTransform.nWorldRotation - 1.5708);
            param1.push();
            _loc_6.setStencilReferenceValue(0);
            _loc_9 = _cCasterContainer.firstChild;
            while (_loc_9)
            {
                
                _loc_10 = _loc_9.getComponent(FSprite) as FTexturedQuad;
                if (_loc_10 == null)
                {
                }
                if (_loc_10 != null)
                {
                    _loc_7 = 10;
                    _loc_4 = Math.abs(_loc_13 - _loc_9.transform.x);
                    _loc_5 = Math.abs(_loc_12 - _loc_9.transform.y);
                    _loc_11 = _loc_9.userData.shadowPad;
                    if (_loc_4 * _loc_4 + _loc_5 * _loc_5 < param2.iRadiusSquared)
                    {
                        param1.drawShadow(_loc_9.transform.x * _nLightMapScale, _loc_9.transform.y * _nLightMapScale, _loc_11 + _loc_10.getTexture().width * _nLightMapScale * _loc_9.cTransform.nWorldScaleX, _loc_11 + _loc_10.getTexture().height * _nLightMapScale * _loc_9.cTransform.nWorldScaleY, _loc_9.transform.rotation, _loc_13 * _nLightMapScale, _loc_12 * _nLightMapScale, _loc_9.userData.shadowDepth);
                    }
                }
                _loc_9 = _loc_9.next;
            }
            param1.push();
            if (stencilOverdraw)
            {
                _loc_6.setCulling("back");
                _loc_6.setStencilReferenceValue(1);
                _loc_9 = _cCasterContainer.firstChild;
                while (_loc_9)
                {
                    
                    _loc_10 = _loc_9.getComponent(FSprite) as FTexturedQuad;
                    if (_loc_10 == null)
                    {
                    }
                    if (_loc_10 != null)
                    {
                        _loc_4 = Math.abs(_loc_13 - _loc_9.transform.x);
                        _loc_5 = Math.abs(_loc_12 - _loc_9.transform.y);
                        if (_loc_4 * _loc_4 + _loc_5 * _loc_5 < param2.iRadiusSquared)
                        {
                            param1.drawColorQuad(_loc_9.transform.x * _nLightMapScale, _loc_9.transform.y * _nLightMapScale, _loc_10.getTexture().width * _nLightMapScale, _loc_10.getTexture().height * _nLightMapScale, _loc_9.transform.rotation);
                        }
                    }
                    _loc_9 = _loc_9.next;
                }
                param1.push();
            }
            _loc_6.setCulling("back");
            _loc_6.setColorMask(true, true, true, true);
            _loc_6.setStencilReferenceValue(1);
            _loc_6.setStencilActions("frontAndBack", "equal", "keep");
            param1.draw(param2.getTexture(), _loc_13 * _nLightMapScale, _loc_12 * _nLightMapScale, _nLightMapScale * param2.cNode.cTransform.nWorldScaleX, _nLightMapScale * param2.cNode.cTransform.nWorldScaleY, param2.cNode.cTransform.nWorldRotation, param2.cNode.cTransform.nWorldRed, param2.cNode.cTransform.nWorldGreen, param2.cNode.cTransform.nWorldBlue, param2.cNode.cTransform.nWorldAlpha, 2);
            param1.push();
            _loc_6.setStencilReferenceValue(0);
            _loc_6.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.STENCIL);
            return;
        }// end function

    }
}
