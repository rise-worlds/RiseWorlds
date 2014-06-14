package com.flengine.core
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.error.*;
    import com.flengine.physics.*;
    import com.flengine.signals.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FlEngine extends Object
    {
        private var __eOnInitialized:HelpSignal;
        private var __eOnFailed:HelpSignal;
        private var __eOnPreUpdate:HelpSignal;
        private var __eOnPostUpdate:HelpSignal;
        private var __eOnCameraAdded:HelpSignal;
        private var __eOnPreRender:HelpSignal;
        private var __eOnPostRender:HelpSignal;
        public var root:FNode;
        public var physics:FPhysics;
        public var autoUpdate:Boolean = true;
        public var paused:Boolean = false;
        private var __iRenderFrameCount:int = 0;
        private var __bInitialized:Boolean = false;
        public var nCurrentDeltaTime:Number = 0;
        public var aCameras:Vector.<FCamera>;
        public var cDefaultCamera:FCamera;
        public var cConfig:FConfig;
        public var cContext:FContext;
        private var __stStage:Stage;
        private var __nLastTime:Number;
        private var __iFrameId:int = 0;
        public static const VERSION:String = "0.9.3.1186";
        private static var __cInstance:FlEngine;
        private static var __bInstantiable:Boolean = false;

        public function FlEngine()
        {
            __eOnInitialized = new HelpSignal();
            __eOnFailed = new HelpSignal();
            __eOnPreUpdate = new HelpSignal();
            __eOnPostUpdate = new HelpSignal();
            __eOnCameraAdded = new HelpSignal();
            __eOnPreRender = new HelpSignal();
            __eOnPostRender = new HelpSignal();
            if (!__bInstantiable)
            {
                throw new FError("FError: FlEngine is a singleton and cannot be instantiated directly use getInstance instead.");
            }
            __cInstance = this;
            aCameras = new Vector.<FCamera>;
            root = new FNode("root");
            cDefaultCamera = FNodeFactory.createNodeWithComponent(FCamera) as FCamera;
            __nLastTime = getTimer();
            return;
        }

        public function get onInitialized() : HelpSignal
        {
            return __eOnInitialized;
        }

        public function get onFailed() : HelpSignal
        {
            return __eOnFailed;
        }

        public function get onPreUpdate() : HelpSignal
        {
            return __eOnPreUpdate;
        }

        public function get onPostUpdate() : HelpSignal
        {
            return __eOnPostUpdate;
        }

        public function get onCameraAdded() : HelpSignal
        {
            return __eOnCameraAdded;
        }

        public function get onPreRender() : HelpSignal
        {
            return __eOnPreRender;
        }

        public function get onPostRender() : HelpSignal
        {
            return __eOnPostRender;
        }

        public function isInitialized() : Boolean
        {
            return __bInitialized;
        }

        public function get defaultCamera() : FCamera
        {
            return cDefaultCamera;
        }

        public function get config() : FConfig
        {
            return cConfig;
        }

        public function get context() : FContext
        {
            return cContext;
        }

        public function get driverInfo() : String
        {
            if (!__bInitialized)
            {
                return "FlEngine not initialized yet.";
            }
            return cContext.cContext.driverInfo;
        }

        public function get stage() : Stage
        {
            return __stStage;
        }

        public function init(param1:Stage, param2:FConfig) : void
        {
            __stStage = param1;
            cConfig = param2;
            if (cContext)
            {
                cContext.dispose();
            }
            cContext = new FContext(this);
            cContext.eInitialized.add(onContextInitialized);
            cContext.eFailed.add(onContextFailed);
            cContext.init(__stStage, cConfig.externalStage3D);
            return;
        }

        private function onContextFailed(param1:Object) : void
        {
            __eOnFailed.dispatch(null);
            return;
        }

        private function onContextInitialized(param1:Object) : void
        {
            __bInitialized = true;
            cDefaultCamera.invalidate();
            __stStage.addEventListener("enterFrame", onEnterFrame);
            onInitialized.dispatch(null);
            return;
        }

        private function onEnterFrame(event:Event) : void
        {
            FStats.update();
            if (!autoUpdate)
            {
                return;
            }
            (__iFrameId + 1);
            update();
            (__iRenderFrameCount + 1);
            if (__iRenderFrameCount >= (cConfig.renderFrameSkip + 1))
            {
                __iRenderFrameCount = 0;
                beginRender();
                render();
                endRender();
            }
            return;
        }

        public function beginRender() : void
        {
            cContext.begin(cConfig.backgroundRed, cConfig.backgroundGreen, cConfig.backgroundBlue);
            return;
        }

        public function endRender() : void
        {
            cContext.end();
            return;
        }

        public function update() : void
        {
            var _loc_1:* = getTimer();
            nCurrentDeltaTime = paused ? (0) : (_loc_1 - __nLastTime);
            if (cConfig.enableFixedTimeStep && !paused)
            {
                nCurrentDeltaTime = cConfig.fixedTimeStep;
            }
            nCurrentDeltaTime = nCurrentDeltaTime * cConfig.timeStepScale;
            __nLastTime = _loc_1;
            __eOnPreUpdate.dispatch(nCurrentDeltaTime);
            root.update(nCurrentDeltaTime, false, false);
            if (physics != null && nCurrentDeltaTime > 0)
            {
                physics.step(nCurrentDeltaTime);
            }
            __eOnPostUpdate.dispatch(nCurrentDeltaTime);
            return;
        }

        public function render() : void
        {
            var _loc_1:* = 0;
            __eOnPreRender.dispatch(null);
            if (aCameras.length == 0)
            {
                cDefaultCamera.invalidate();
                cDefaultCamera.render(cContext, null, null);
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < aCameras.length)
                {
                    
                    if (aCameras[_loc_1] != null)
                    {
                        aCameras[_loc_1].invalidate();
                        aCameras[_loc_1].render(cContext, null, null);
                    }
                    _loc_1++;
                }
            }
            __eOnPostRender.dispatch(null);
            return;
        }

        private function onMouseEvent(event:MouseEvent) : void
        {
            var _loc_2:* = false;
            var _loc_3:* = 0;
            if (cConfig.enableNativeContentMouseCapture && event.target != __stStage)
            {
                _loc_2 = true;
            }
            if (aCameras.length == 0)
            {
                cDefaultCamera.bCapturedThisFrame = false;
                cDefaultCamera.captureMouseEvent(_loc_2, event, new Vector3D(event.stageX - cConfig.viewRect.x, event.stageY - cConfig.viewRect.y));
            }
            else
            {
                _loc_3 = 0;
                while (_loc_3 < aCameras.length)
                {
                    
                    aCameras[_loc_3].bCapturedThisFrame = false;
                    _loc_3++;
                }
                _loc_3 = aCameras.length - 1;
                while (_loc_3 >= 0)
                {
                    
                    if (aCameras.length > _loc_3)
                    {
                        _loc_2 = aCameras[_loc_3].captureMouseEvent(_loc_2, event, new Vector3D(event.stageX - cConfig.viewRect.x, event.stageY - cConfig.viewRect.y)) || _loc_2;
                    }
                    _loc_3--;
                }
            }
            return;
        }

        private function onTouchEvent(event:TouchEvent) : void
        {
            return;
        }

        public function getCameraAt(param1:int) : FCamera
        {
            if (param1 >= aCameras.length || param1 < 0)
            {
                return null;
            }
            return aCameras[param1];
        }

        public function setCameraIndex(param1:FCamera, param2:int) : void
        {
            var _loc_3:* = aCameras.indexOf(param1);
            if (_loc_3 == -1)
            {
                throw new FError("FError: Camera is not present inside render graph.");
            }
            if (param2 > aCameras.length || param2 < 0)
            {
                throw new FError("FError: Camera index is outside of valid index range.");
            }
            var _loc_4:* = aCameras[param2];
            aCameras[param2] = param1;
            aCameras[_loc_3] = _loc_4;
            return;
        }

        public function getCameraIndex(param1:FCamera) : int
        {
            var _loc_2:* = 0;
            _loc_2 = 0;
            while (_loc_2 < aCameras.length)
            {
                
                if (aCameras[_loc_2] == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }

        public function addCamera(param1:FCamera) : void
        {
            if (aCameras.indexOf(param1) != -1)
            {
                return;
            }
            aCameras.push(param1);
            __eOnCameraAdded.dispatch(param1);
            return;
        }

        public function removeCamera(param1:FCamera) : void
        {
            var _loc_2:* = aCameras.indexOf(param1);
            if (_loc_2 != -1)
            {
                aCameras.splice(_loc_2, 1);
            }
            return;
        }

        public static function getInstance() : FlEngine
        {
            __bInstantiable = true;
            if (__cInstance == null)
            {
                new FlEngine;
            }
            __bInstantiable = false;
            return __cInstance;
        }

        public static function get frameId() : int
        {
            if (!__cInstance)
            {
                return 0;
            }
            return __cInstance.__iFrameId;
        }

    }
}
