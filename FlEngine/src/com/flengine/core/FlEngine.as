package com.flengine.core
{
	import com.flengine.fl2d;
	import com.flengine.components.FCamera;
	import com.flengine.context.FContext;
	import com.flengine.error.FError;
	import com.flengine.physics.FPhysics;
	import com.flengine.signals.HelpSignal;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	use namespace fl2d;
	
	public class FlEngine extends Object
	{
		
		public function FlEngine()
		{
			super();
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
			else
			{
				__cInstance = this;
				aCameras = new Vector.<FCamera>();
				root = new FNode("root");
				cDefaultCamera = FNodeFactory.createNodeWithComponent(FCamera) as FCamera;
				__nLastTime = getTimer();
				return;
			}
		}
		
		public static const VERSION:String = "0.9.3.1186";
		private static var __cInstance:FlEngine;
		private static var __bInstantiable:Boolean = false;
		
		public static function getInstance():FlEngine
		{
			__bInstantiable = true;
			if (__cInstance == null)
			{
				new FlEngine;
			}
			__bInstantiable = false;
			return __cInstance;
		}
		
		public static function get frameId():int
		{
			if (!__cInstance)
			{
				return 0;
			}
			return __cInstance.__iFrameId;
		}
		
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
		fl2d var nCurrentDeltaTime:Number = 0;
		fl2d var aCameras:Vector.<FCamera>;
		fl2d var cDefaultCamera:FCamera;
		fl2d var cConfig:FConfig;
		fl2d var cContext:FContext;
		private var __stStage:Stage;
		private var __nLastTime:Number;
		private var __iFrameId:int = 0;
		
		public function get onInitialized():HelpSignal
		{
			return __eOnInitialized;
		}
		
		public function get onFailed():HelpSignal
		{
			return __eOnFailed;
		}
		
		public function get onPreUpdate():HelpSignal
		{
			return __eOnPreUpdate;
		}
		
		public function get onPostUpdate():HelpSignal
		{
			return __eOnPostUpdate;
		}
		
		public function get onCameraAdded():HelpSignal
		{
			return __eOnCameraAdded;
		}
		
		public function get onPreRender():HelpSignal
		{
			return __eOnPreRender;
		}
		
		public function get onPostRender():HelpSignal
		{
			return __eOnPostRender;
		}
		
		public function isInitialized():Boolean
		{
			return __bInitialized;
		}
		
		public function get defaultCamera():FCamera
		{
			return cDefaultCamera;
		}
		
		public function get config():FConfig
		{
			return cConfig;
		}
		
		public function get context():FContext
		{
			return cContext;
		}
		
		public function get driverInfo():String
		{
			if (!__bInitialized)
			{
				return "FlEngine not initialized yet.";
			}
			return cContext.cContext.driverInfo;
		}
		
		public function get stage():Stage
		{
			return __stStage;
		}
		
		public function init(param1:Stage, param2:FConfig):void
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
		}
		
		private function onContextFailed(param1:Object):void
		{
			__eOnFailed.dispatch(null);
		}
		
		private function onContextInitialized(param1:Object):void
		{
			__bInitialized = true;
			cDefaultCamera.invalidate();
			__stStage.addEventListener("enterFrame", onEnterFrame);
			onInitialized.dispatch(null);
		}
		
		private function onEnterFrame(param1:Event):void
		{
			FStats.update();
			if (!autoUpdate)
			{
				return;
			}
			__iFrameId = __iFrameId + 1;
			update();
			__iRenderFrameCount = __iRenderFrameCount + 1;
			if (__iRenderFrameCount >= cConfig.renderFrameSkip + 1)
			{
				__iRenderFrameCount = 0;
				beginRender();
				render();
				endRender();
			}
		}
		
		public function beginRender():void
		{
			cContext.begin(cConfig.backgroundRed, cConfig.backgroundGreen, cConfig.backgroundBlue);
		}
		
		public function endRender():void
		{
			cContext.end();
		}
		
		public function update():void
		{
			var _loc1_:Number = getTimer();
			nCurrentDeltaTime = paused ? 0 : _loc1_ - __nLastTime;
			if (cConfig.enableFixedTimeStep && !paused)
			{
				nCurrentDeltaTime = cConfig.fixedTimeStep;
			}
			nCurrentDeltaTime = nCurrentDeltaTime * cConfig.timeStepScale;
			__nLastTime = _loc1_;
			__eOnPreUpdate.dispatch(nCurrentDeltaTime);
			root.update(nCurrentDeltaTime, false, false);
			if (!(physics == null) && nCurrentDeltaTime > 0)
			{
				physics.step(nCurrentDeltaTime);
			}
			__eOnPostUpdate.dispatch(nCurrentDeltaTime);
		}
		
		public function render():void
		{
			var _loc1_:* = 0;
			__eOnPreRender.dispatch(null);
			if (aCameras.length == 0)
			{
				cDefaultCamera.invalidate();
				cDefaultCamera.render(cContext, null, null);
			}
			else
			{
				_loc1_ = 0;
				while (_loc1_ < aCameras.length)
				{
					if (aCameras[_loc1_] != null)
					{
						aCameras[_loc1_].invalidate();
						aCameras[_loc1_].render(cContext, null, null);
					}
					_loc1_++;
				}
			}
			__eOnPostRender.dispatch(null);
		}
		
		private function onMouseEvent(param1:MouseEvent):void
		{
			var _loc2_:* = false;
			var _loc3_:* = 0;
			if (cConfig.enableNativeContentMouseCapture && !(param1.target == __stStage))
			{
				_loc2_ = true;
			}
			if (aCameras.length == 0)
			{
				cDefaultCamera.bCapturedThisFrame = false;
				cDefaultCamera.captureMouseEvent(_loc2_, param1, new Vector3D(param1.stageX - cConfig.viewRect.x, param1.stageY - cConfig.viewRect.y));
			}
			else
			{
				_loc3_ = 0;
				while (_loc3_ < aCameras.length)
				{
					aCameras[_loc3_].bCapturedThisFrame = false;
					_loc3_++;
				}
				_loc3_ = aCameras.length - 1;
				while (_loc3_ >= 0)
				{
					if (aCameras.length > _loc3_)
					{
						_loc2_ = aCameras[_loc3_].captureMouseEvent(_loc2_, param1, new Vector3D(param1.stageX - cConfig.viewRect.x, param1.stageY - cConfig.viewRect.y)) || _loc2_;
					}
					_loc3_--;
				}
			}
		}
		
		private function onTouchEvent(param1:TouchEvent):void
		{
		}
		
		public function getCameraAt(param1:int):FCamera
		{
			if (param1 >= aCameras.length || param1 < 0)
			{
				return null;
			}
			return aCameras[param1];
		}
		
		public function setCameraIndex(param1:FCamera, param2:int):void
		{
			var _loc3_:int = aCameras.indexOf(param1);
			if (_loc3_ == -1)
			{
				throw new FError("FError: Camera is not present inside render graph.");
			}
			else if (param2 > aCameras.length || param2 < 0)
			{
				throw new FError("FError: Camera index is outside of valid index range.");
			}
			else
			{
				var _loc4_:FCamera = aCameras[param2];
				aCameras[param2] = param1;
				aCameras[_loc3_] = _loc4_;
				return;
			}
		
		}
		
		public function getCameraIndex(param1:FCamera):int
		{
			var _loc2_:* = 0;
			_loc2_ = 0;
			while (_loc2_ < aCameras.length)
			{
				if (aCameras[_loc2_] == param1)
				{
					return _loc2_;
				}
				_loc2_++;
			}
			return -1;
		}
		
		fl2d function addCamera(param1:FCamera):void
		{
			if (aCameras.indexOf(param1) != -1)
			{
				return;
			}
			aCameras.push(param1);
			__eOnCameraAdded.dispatch(param1);
		}
		
		fl2d function removeCamera(param1:FCamera):void
		{
			var _loc2_:int = aCameras.indexOf(param1);
			if (_loc2_ != -1)
			{
				aCameras.splice(_loc2_, 1);
			}
		}
	}
}
