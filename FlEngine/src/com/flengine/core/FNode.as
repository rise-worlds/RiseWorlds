package com.flengine.core
{
   import com.flengine.signals.HelpSignal;
   import com.flengine.components.FTransform;
   import com.flengine.components.physics.FBody;
   import com.flengine.context.postprocesses.FPostProcess;
   import flash.utils.Dictionary;
   import com.flengine.components.FComponent;
   import com.flengine.error.FError;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import com.flengine.signals.FMouseSignal;
   import flash.utils.getDefinitionByName;
   import com.flengine.components.renderables.FRenderable;
   
   public class FNode extends Object
   {
      
      public function FNode(param1:String = "") {
         super();
         __aTags = new Vector.<String>();
         __iCount = __iCount + 1;
         _iId = __iCount;
         _sName = param1 == ""?"FNode#" + __iCount:param1;
         cCore = FlEngine.getInstance();
         __dComponentsLookupTable = new Dictionary();
         cTransform = new FTransform(this);
         __dComponentsLookupTable[FTransform] = cTransform;
      }
      
      private static var __iCount:int = 0;
      
      private static var __aActiveMasks:Vector.<FNode>;
      
      private var __eOnAddedToStage:HelpSignal;
      
      private var __eOnRemovedFromStage:HelpSignal;
      
      private var __eOnComponentAdded:HelpSignal;
      
      private var __eOnComponentRemoved:HelpSignal;
      
      fl2d var cPool:FNodePool;
      
      fl2d var cPoolPrevious:FNode;
      
      fl2d var cPoolNext:FNode;
      
      fl2d var cPrevious:FNode;
      
      fl2d var cNext:FNode;
      
      private var __bChangedParent:Boolean = false;
      
      public var cameraGroup:int = 0;
      
      private var __bParentActive:Boolean = true;
      
      fl2d var iUsedAsMask:int = 0;
      
      private var __bActive:Boolean = true;
      
      private var __aTags:Vector.<String>;
      
      private var __oUserData:Object;
      
      fl2d var cCore:FlEngine;
      
      protected var _iId:uint;
      
      protected var _sName:String;
      
      fl2d var cTransform:FTransform;
      
      fl2d var cBody:FBody;
      
      fl2d var cParent:FNode;
      
      private var __bUpdating:Boolean = false;
      
      private var __bDisposeAfterUpdate:Boolean = false;
      
      private var __bRemoveAfterUpdate:Boolean = false;
      
      private var __bDisposed:Boolean = false;
      
      private var __bRendering:Boolean = false;
      
      public var postProcess:FPostProcess;
      
      private var __eOnMouseDown:HelpSignal;
      
      private var __eOnMouseMove:HelpSignal;
      
      private var __eOnMouseUp:HelpSignal;
      
      private var __eOnMouseOver:HelpSignal;
      
      private var __eOnMouseClick:HelpSignal;
      
      private var __eOnMouseOut:HelpSignal;
      
      public var mouseEnabled:Boolean = false;
      
      public var mouseChildren:Boolean = true;
      
      fl2d var cMouseOver:FNode;
      
      fl2d var cMouseDown:FNode;
      
      fl2d var cRightMouseDown:FNode;
      
      private var __dComponentsLookupTable:Dictionary;
      
      private var __cFirstComponent:FComponent;
      
      private var __cLastComponent:FComponent;
      
      private var _iChildCount:int = 0;
      
      private var _cFirstChild:FNode;
      
      private var _cLastChild:FNode;
      
      fl2d var iUsedAsPPMask:int;
      
      public function getPrototype() : XML {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            _loc3_ = <node/>;
            _loc3_.@name = _sName;
            _loc3_.@mouseEnabled = mouseEnabled;
            _loc3_.@mouseChildren = mouseChildren;
            _loc3_.@tags = __aTags.join(",");
            _loc3_.components = <components/>;
            _loc3_.components.appendChild(cTransform.getPrototype());
            if(cBody)
            {
               _loc3_.components.appendChild(cBody.getPrototype());
            }
            _loc2_ = __cFirstComponent;
            while(_loc2_)
            {
               _loc3_.components.appendChild(_loc2_.getPrototype());
               _loc2_ = _loc2_.cNext;
            }
            _loc3_.children = <children/>;
            _loc1_ = _cFirstChild;
            while(_loc1_)
            {
               _loc3_.children.appendChild(_loc1_.getPrototype());
               _loc1_ = _loc1_.cNext;
            }
            return _loc3_;
         }
      }
      
      public function get onAddedToStage() : HelpSignal {
         if(__eOnAddedToStage == null)
         {
            __eOnAddedToStage = new HelpSignal();
         }
         return __eOnAddedToStage;
      }
      
      public function get onRemovedFromStage() : HelpSignal {
         if(__eOnRemovedFromStage == null)
         {
            __eOnRemovedFromStage = new HelpSignal();
         }
         return __eOnRemovedFromStage;
      }
      
      public function get onComponentAdded() : HelpSignal {
         if(__eOnComponentAdded == null)
         {
            __eOnComponentAdded = new HelpSignal();
         }
         return __eOnComponentAdded;
      }
      
      public function get onComponentRemoved() : HelpSignal {
         if(__eOnComponentRemoved == null)
         {
            __eOnComponentRemoved = new HelpSignal();
         }
         return __eOnComponentRemoved;
      }
      
      public function get previous() : FNode {
         return cPrevious;
      }
      
      public function get next() : FNode {
         return cNext;
      }
      
      fl2d function set bParentActive(param1:Boolean) : void {
         var _loc2_:FNode = _cFirstChild;
         while(_loc2_)
         {
            _loc2_.bParentActive = param1;
            _loc2_ = _loc2_.cNext;
         }
      }
      
      public function set active(param1:Boolean) : void {
         var _loc3_:FComponent = null;
         var _loc2_:FNode = null;
         if(param1 == __bActive)
         {
            return;
         }
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            __bActive = param1;
            cTransform.active = __bActive;
            if(cPool)
            {
               if(param1)
               {
                  cPool.putToBack(this);
               }
               else
               {
                  cPool.putToFront(this);
               }
            }
            if(cBody)
            {
               cBody.active = __bActive;
            }
            _loc3_ = __cFirstComponent;
            while(_loc3_)
            {
               _loc3_.active = __bActive;
               _loc3_ = _loc3_.cNext;
            }
            _loc2_ = _cFirstChild;
            while(_loc2_)
            {
               _loc2_.bParentActive = __bActive;
               _loc2_ = _loc2_.cNext;
            }
            return;
         }
      }
      
      public function get active() : Boolean {
         return __bActive;
      }
      
      public function hasTag(param1:String) : Boolean {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            if(__aTags.indexOf(param1) != -1)
            {
               return true;
            }
            return false;
         }
      }
      
      public function addTag(param1:String) : void {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            if(__aTags.indexOf(param1) != -1)
            {
               return;
            }
            __aTags.push(param1);
            return;
         }
      }
      
      public function removeTag(param1:String) : void {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            _loc2_ = __aTags.indexOf(param1);
            if(_loc2_ == -1)
            {
               return;
            }
            __aTags.splice(_loc2_,1);
            return;
         }
      }
      
      public function get userData() : Object {
         if(__oUserData == null)
         {
            __oUserData = {};
         }
         return __oUserData;
      }
      
      public function get core() : FlEngine {
         return cCore;
      }
      
      public function get name() : String {
         return _sName;
      }
      
      public function set name(param1:String) : void {
         _sName = param1;
      }
      
      public function get transform() : FTransform {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            return cTransform;
         }
      }
      
      public function get parent() : FNode {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            return cParent;
         }
      }
      
      fl2d function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         var _loc5_:* = null;
         if(!__bActive || !__bParentActive)
         {
            return;
         }
         __bChangedParent = false;
         __bUpdating = true;
         var _loc8_:Boolean = param2 || cTransform.bTransformDirty;
         var _loc7_:Boolean = param3 || cTransform.bColorDirty;
         if(_loc8_ || _loc7_ || !(cBody == null) && cBody.isDynamic())
         {
            cTransform.invalidate(_loc8_,_loc7_);
         }
         if(cBody != null)
         {
            cBody.update(param1,_loc8_,_loc7_);
         }
         var _loc6_:FComponent = __cFirstComponent;
         while(_loc6_)
         {
            _loc6_.update(param1,_loc8_,_loc7_);
            _loc6_ = _loc6_.cNext;
         }
         _loc8_ = _loc8_ || cTransform.bTransformDirty;
         _loc7_ = _loc7_ || cTransform.bColorDirty;
         if(cTransform.bTransformDirty || cTransform.bColorDirty)
         {
            cTransform.invalidate(cTransform.bTransformDirty,cTransform.bColorDirty);
         }
         var _loc4_:FNode = _cFirstChild;
         while(_loc4_)
         {
            _loc4_.update(param1,_loc8_,_loc7_);
            _loc5_ = _loc4_.next;
            if(_loc4_.__bDisposeAfterUpdate)
            {
               _loc4_.dispose();
            }
            if(_loc4_.__bRemoveAfterUpdate)
            {
               removeChild(_loc4_);
            }
            _loc4_ = _loc5_;
         }
         __bUpdating = false;
      }
      
      fl2d function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:Boolean) : void {
         if(!__bActive || __bChangedParent || !__bParentActive || !cTransform.visible || (cameraGroup & param2.mask) == 0 && !(cameraGroup == 0) || iUsedAsMask > 0 && !param4)
         {
            return;
         }
         if(!param4)
         {
            if(cTransform.cMask != null)
            {
               param1.renderAsStencilMask(__aActiveMasks.length);
               cTransform.cMask.render(param1,param2,param3,true);
               __aActiveMasks.push(cTransform.cMask);
               param1.renderToColor(__aActiveMasks.length);
            }
         }
         __bRendering = true;
         if(cTransform.rAbsoluteMaskRect != null)
         {
            param3 = param3.intersection(cTransform.rAbsoluteMaskRect);
         }
         var _loc6_:FComponent = __cFirstComponent;
         while(_loc6_)
         {
            _loc6_.render(param1,param2,param3);
            _loc6_ = _loc6_.cNext;
         }
         var _loc5_:FNode = _cFirstChild;
         while(_loc5_)
         {
            if(_loc5_.postProcess)
            {
               _loc5_.postProcess.render(param1,param2,param3,_loc5_);
            }
            else
            {
               _loc5_.render(param1,param2,param3,param4);
            }
            _loc5_ = _loc5_.cNext;
         }
         if(core.cConfig.enableStats && core.cConfig.showExtendedStats)
         {
            param2.iRenderedNodesCount++;
         }
         if(!param4)
         {
            if(cTransform.cMask != null)
            {
               __aActiveMasks.pop();
               if(__aActiveMasks.length == 0)
               {
                  param1.clearStencil();
               }
               param1.renderToColor(__aActiveMasks.length);
            }
         }
         __bRendering = false;
      }
      
      public function toString() : String {
         return "[G2DNode]" + _sName;
      }
      
      public function disposeChildren() : void {
         if(__bRendering)
         {
            throw new FError("FError: Cannot do this while rendering.");
         }
         else
         {
            if(_cFirstChild == null)
            {
               return;
            }
            _loc1_ = _cFirstChild.cNext;
            while(_loc1_)
            {
               _loc1_.cPrevious.dispose();
               _loc1_ = _loc1_.cNext;
            }
            _cFirstChild.dispose();
            _cFirstChild = null;
            _cLastChild = null;
            return;
         }
      }
      
      public function dispose() : void {
         var _loc2_:* = null;
         if(__bRendering)
         {
            throw new FError("FError: Cannot do this while rendering.");
         }
         else
         {
            if(__bUpdating)
            {
               __bDisposeAfterUpdate = true;
               return;
            }
            if(__bDisposed)
            {
               return;
            }
            __bActive = false;
            disposeChildren();
            _loc4_ = 0;
            _loc3_ = __dComponentsLookupTable;
            for(_loc1_ in __dComponentsLookupTable)
            {
               _loc2_ = __dComponentsLookupTable[_loc1_];
               delete __dComponentsLookupTable[_loc1_];
               _loc2_.dispose();
            }
            cBody = null;
            cTransform = null;
            __cFirstComponent = null;
            __cLastComponent = null;
            __dComponentsLookupTable = null;
            if(cParent != null)
            {
               cParent.removeChild(this);
            }
            cNext = null;
            cPrevious = null;
            if(cPoolNext)
            {
               cPoolNext.cPoolPrevious = cPoolPrevious;
            }
            if(cPoolPrevious)
            {
               cPoolPrevious.cPoolNext = cPoolNext;
            }
            cPoolNext = null;
            cPoolPrevious = null;
            cPool = null;
            if(__eOnMouseDown)
            {
               __eOnMouseDown.dispose();
               __eOnMouseDown = null;
            }
            if(__eOnMouseMove)
            {
               __eOnMouseMove.dispose();
               __eOnMouseMove = null;
            }
            if(__eOnMouseUp)
            {
               __eOnMouseUp.dispose();
               __eOnMouseUp = null;
            }
            if(__eOnMouseOver)
            {
               __eOnMouseOver.dispose();
               __eOnMouseOver = null;
            }
            if(__eOnMouseClick)
            {
               __eOnMouseClick.dispose();
               __eOnMouseClick = null;
            }
            if(__eOnMouseOut)
            {
               __eOnMouseOut.dispose();
               __eOnMouseOut = null;
            }
            if(__eOnRemovedFromStage)
            {
               __eOnRemovedFromStage.dispose();
               __eOnRemovedFromStage = null;
            }
            if(__eOnAddedToStage)
            {
               __eOnAddedToStage.dispose();
               __eOnAddedToStage = null;
            }
            __bDisposed = true;
            return;
         }
      }
      
      public function get onMouseDown() : HelpSignal {
         if(__eOnMouseDown == null)
         {
            __eOnMouseDown = new HelpSignal();
         }
         return __eOnMouseDown;
      }
      
      public function get onMouseMove() : HelpSignal {
         if(__eOnMouseMove == null)
         {
            __eOnMouseMove = new HelpSignal();
         }
         return __eOnMouseMove;
      }
      
      public function get onMouseUp() : HelpSignal {
         if(__eOnMouseUp == null)
         {
            __eOnMouseUp = new HelpSignal();
         }
         return __eOnMouseUp;
      }
      
      public function get onMouseOver() : HelpSignal {
         if(__eOnMouseOver == null)
         {
            __eOnMouseOver = new HelpSignal();
         }
         return __eOnMouseOver;
      }
      
      public function get onMouseClick() : HelpSignal {
         if(__eOnMouseClick == null)
         {
            __eOnMouseClick = new HelpSignal();
         }
         return __eOnMouseClick;
      }
      
      public function get onMouseOut() : HelpSignal {
         if(__eOnMouseOut == null)
         {
            __eOnMouseOut = new HelpSignal();
         }
         return __eOnMouseOut;
      }
      
      fl2d function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D, param4:FCamera) : Boolean {
         var _loc5_:FNode = null;
         var _loc6_:FComponent = null;
         if(!active || !cTransform.visible || (cameraGroup & param4.mask) == 0 && !(cameraGroup == 0))
         {
            return false;
         }
         if(mouseChildren)
         {
            _loc5_ = _cLastChild;
            while(_loc5_)
            {
               param1 = _loc5_.processMouseEvent(param1,param2,param3,param4) || param1;
               _loc5_ = _loc5_.cPrevious;
            }
         }
         if(mouseEnabled)
         {
            _loc6_ = __cFirstComponent;
            while(_loc6_)
            {
               param1 = _loc6_.processMouseEvent(param1,param2,param3) || param1;
               _loc6_ = _loc6_.cNext;
            }
         }
         return param1;
      }
      
      fl2d function handleMouseEvent(param1:FNode, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean) : void {
         var _loc7_:* = null;
         var _loc8_:* = null;
         if(mouseEnabled)
         {
            _loc7_ = new FMouseSignal(this,param1,param3,param4,param5,param6,param2);
            if(param2 == "mouseDown")
            {
               cMouseDown = param1;
               if(__eOnMouseDown)
               {
                  __eOnMouseDown.dispatch(_loc7_);
               }
            }
            else if(param2 == "mouseMove")
            {
               if(__eOnMouseMove)
               {
                  __eOnMouseMove.dispatch(_loc7_);
               }
            }
            else if(param2 == "mouseUp")
            {
               if(cMouseDown == param1 && __eOnMouseClick)
               {
                  _loc8_ = new FMouseSignal(this,param1,param3,param4,param5,param6,"mouseUp");
                  __eOnMouseClick.dispatch(_loc8_);
               }
               cMouseDown = null;
               if(__eOnMouseUp)
               {
                  __eOnMouseUp.dispatch(_loc8_);
               }
            }
            else if(param2 == "mouseOver")
            {
               cMouseOver = param1;
               if(__eOnMouseOver)
               {
                  __eOnMouseOver.dispatch(_loc8_);
               }
            }
            else if(param2 == "mouseOut")
            {
               cMouseOver = null;
               if(__eOnMouseOut)
               {
                  __eOnMouseOut.dispatch(_loc7_);
               }
            }
            
            
            
            
         }
         if(cParent)
         {
            cParent.handleMouseEvent(param1,param2,param3,param4,param5,param6);
         }
      }
      
      public function getComponents() : Dictionary {
         return __dComponentsLookupTable;
      }
      
      public function getComponent(param1:Class) : FComponent {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            return __dComponentsLookupTable[param1];
         }
      }
      
      public function hasComponent(param1:Class) : Boolean {
         return !(__dComponentsLookupTable[param1] == null);
      }
      
      public function addExistComponent(param1:FComponent, param2:Class, param3:Object = null) : FComponent {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            if(param3 == null)
            {
               param3 = param2;
            }
            if(__dComponentsLookupTable[param3] != null)
            {
               return __dComponentsLookupTable[param3];
            }
            param1.cLookupClass = param3;
            __dComponentsLookupTable[param3] = param1;
            if(param1 is FBody)
            {
               if(cBody)
               {
                  throw new FError("FError: Node cannot have multiple body components.");
               }
               else
               {
                  cBody = param1 as FBody;
                  return param1;
               }
            }
            else
            {
               if(__cFirstComponent == null)
               {
                  __cFirstComponent = param1;
                  __cLastComponent = param1;
               }
               else
               {
                  __cLastComponent.cNext = param1;
                  param1.cPrevious = __cLastComponent;
                  __cLastComponent = param1;
               }
               if(__eOnComponentAdded)
               {
                  __eOnComponentAdded.dispatch(param3);
               }
               return param1;
            }
         }
      }
      
      public function addComponent(param1:Class, param2:Class = null) : FComponent {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            if(param2 == null)
            {
               param2 = param1;
            }
            if(__dComponentsLookupTable[param2] != null)
            {
               return __dComponentsLookupTable[param2];
            }
            _loc3_ = new param1(this);
            if(_loc3_ == null)
            {
               throw new FError("FError: Invalid component class.");
            }
            else
            {
               _loc3_.cLookupClass = param2;
               __dComponentsLookupTable[param2] = _loc3_;
               if(_loc3_ is FBody)
               {
                  if(cBody)
                  {
                     throw new FError("FError: Node cannot have multiple body components.");
                  }
                  else
                  {
                     cBody = _loc3_ as FBody;
                     return _loc3_;
                  }
               }
               else
               {
                  if(__cFirstComponent == null)
                  {
                     __cFirstComponent = _loc3_;
                     __cLastComponent = _loc3_;
                  }
                  else
                  {
                     __cLastComponent.cNext = _loc3_;
                     _loc3_.cPrevious = __cLastComponent;
                     __cLastComponent = _loc3_;
                  }
                  if(__eOnComponentAdded)
                  {
                     __eOnComponentAdded.dispatch(param2);
                  }
                  return _loc3_;
               }
            }
         }
      }
      
      public function addComponentFromPrototype(param1:XML) : FComponent {
         var _loc4_:Object = getDefinitionByName(param1.@componentClass.split("-").join("::"));
         var _loc2_:Object = getDefinitionByName(param1.@componentLookupClass.split("-").join("::"));
         var _loc3_:FComponent = addComponent(_loc4_ as Class,_loc2_ as Class);
         _loc3_.bindFromPrototype(param1);
         return _loc3_;
      }
      
      public function removeComponent(param1:Class) : void {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            _loc2_ = __dComponentsLookupTable[param1];
            if(_loc2_ == null || _loc2_ == cTransform)
            {
               return;
            }
            if(_loc2_.cPrevious != null)
            {
               _loc2_.cPrevious.cNext = _loc2_.cNext;
            }
            if(_loc2_.cNext != null)
            {
               _loc2_.cNext.cPrevious = _loc2_.cPrevious;
            }
            if(__cFirstComponent == _loc2_)
            {
               __cFirstComponent = __cFirstComponent.cNext;
            }
            if(__cLastComponent == _loc2_)
            {
               __cLastComponent = __cLastComponent.cPrevious;
            }
            delete __dComponentsLookupTable[param1];
            if(_loc2_ is FBody)
            {
               cBody = null;
            }
            _loc2_.dispose();
            if(__eOnComponentAdded)
            {
               __eOnComponentAdded.dispatch(param1);
            }
            return;
         }
      }
      
      public function get firstChild() : FNode {
         return _cFirstChild;
      }
      
      public function get lastChild() : FNode {
         return _cLastChild;
      }
      
      public function get numChildren() : int {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            return _iChildCount;
         }
      }
      
      public function addChild(param1:FNode) : void {
         if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else if(param1 == this)
         {
            throw new FError("FError: Node cannot be the child of itself.");
         }
         else
         {
            if(param1.parent != null)
            {
               param1.parent.removeChild(param1);
            }
            param1.__bChangedParent = true;
            param1.cParent = this;
            if(_cFirstChild == null)
            {
               _cFirstChild = param1;
               _cLastChild = param1;
            }
            else
            {
               _cLastChild.cNext = param1;
               param1.cPrevious = _cLastChild;
               _cLastChild = param1;
            }
            _iChildCount = _iChildCount + 1;
            if(isOnStage())
            {
               param1.addedToStage();
            }
            return;
         }
         
      }
      
      public function removeChild(param1:FNode) : void {
         if(param1.__bRendering)
         {
            throw new FError("FError: Cannot do this while rendering.");
         }
         else if(__bDisposed)
         {
            throw new FError("FError: Node is already disposed.");
         }
         else
         {
            if(param1.cParent != this)
            {
               return;
            }
            if(param1.__bUpdating)
            {
               param1.__bRemoveAfterUpdate = true;
               return;
            }
            if(param1.cPrevious != null)
            {
               param1.cPrevious.cNext = param1.cNext;
            }
            else
            {
               _cFirstChild = _cFirstChild.cNext;
            }
            if(param1.cNext)
            {
               param1.cNext.cPrevious = param1.cPrevious;
            }
            else
            {
               _cLastChild = _cLastChild.cPrevious;
            }
            param1.cParent = null;
            param1.cNext = null;
            param1.cPrevious = null;
            _iChildCount = _iChildCount - 1;
            param1.__bRemoveAfterUpdate = false;
            if(isOnStage())
            {
               param1.removedFromStage();
            }
            return;
         }
         
      }
      
      public function swapChildren(param1:FNode, param2:FNode) : void {
         if(!(param1.parent == this) || !(param2.parent == this))
         {
            return;
         }
         var _loc3_:FNode = param1.cNext;
         if(param2.cNext == param1)
         {
            param1.cNext = param2;
         }
         else
         {
            param1.cNext = param2.cNext;
            if(param1.cNext)
            {
               param1.cNext.cPrevious = param1;
            }
         }
         if(_loc3_ == param2)
         {
            param2.cNext = param1;
         }
         else
         {
            param2.cNext = _loc3_;
            if(param2.cNext)
            {
               param2.cNext.cPrevious = param2;
            }
         }
         _loc3_ = param1.cPrevious;
         if(param2.cPrevious == param1)
         {
            param1.cPrevious = param2;
         }
         else
         {
            param1.cPrevious = param2.cPrevious;
            if(param1.cPrevious)
            {
               param1.cPrevious.cNext = param1;
            }
         }
         if(_loc3_ == param2)
         {
            param2.cPrevious = param1;
         }
         else
         {
            param2.cPrevious = _loc3_;
            if(param2.cPrevious)
            {
               param2.cPrevious.cNext = param2;
            }
         }
         if(param1 == _cFirstChild)
         {
            _cFirstChild = param2;
         }
         else if(param2 == _cFirstChild)
         {
            _cFirstChild = param1;
         }
         
         if(param1 == _cLastChild)
         {
            _cLastChild = param2;
         }
         else if(param2 == _cLastChild)
         {
            _cLastChild = param1;
         }
         
      }
      
      public function putChildToFront(param1:FNode) : void {
         if(param1 == _cLastChild)
         {
            return;
         }
         if(param1.cNext)
         {
            param1.cNext.cPrevious = param1.cPrevious;
         }
         if(param1.cPrevious)
         {
            param1.cPrevious.cNext = param1.cNext;
         }
         if(param1 == _cFirstChild)
         {
            _cFirstChild = _cFirstChild.cNext;
         }
         if(_cLastChild != null)
         {
            _cLastChild.cNext = param1;
         }
         param1.cPrevious = _cLastChild;
         param1.cNext = null;
         _cLastChild = param1;
      }
      
      public function putChildToBack(param1:FNode) : void {
         if(param1 == _cFirstChild)
         {
            return;
         }
         if(param1.cNext)
         {
            param1.cNext.cPrevious = param1.cPrevious;
         }
         if(param1.cPrevious)
         {
            param1.cPrevious.cNext = param1.cNext;
         }
         if(param1 == _cLastChild)
         {
            _cLastChild = _cLastChild.cPrevious;
         }
         if(_cFirstChild != null)
         {
            _cFirstChild.cPrevious = param1;
         }
         param1.cPrevious = null;
         param1.cNext = _cFirstChild;
         _cFirstChild = param1;
      }
      
      private function addedToStage() : void {
         if(__eOnAddedToStage)
         {
            __eOnAddedToStage.dispatch(null);
         }
         if(cBody != null)
         {
            cBody.addToSpace();
         }
         var _loc1_:FNode = _cFirstChild;
         while(_loc1_)
         {
            _loc1_.addedToStage();
            _loc1_ = _loc1_.cNext;
         }
      }
      
      private function removedFromStage() : void {
         if(__eOnRemovedFromStage)
         {
            __eOnRemovedFromStage.dispatch(null);
         }
         if(cBody != null)
         {
            cBody.removeFromSpace();
         }
         var _loc1_:FNode = _cFirstChild;
         while(_loc1_)
         {
            _loc1_.removedFromStage();
            _loc1_ = _loc1_.cNext;
         }
      }
      
      public function isOnStage() : Boolean {
         if(this == cCore.root)
         {
            return true;
         }
         if(cParent == null)
         {
            return false;
         }
         return cParent.isOnStage();
      }
      
      public function sortChildrenOnY(param1:Boolean = true) : void {
         var _loc8_:* = 0;
         var _loc2_:* = 0;
         var _loc6_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:FNode = null;
         var _loc5_:FNode = null;
         var _loc4_:FNode = null;
         if(_cFirstChild == null)
         {
            return;
         }
         var _loc3_:* = 1;
         while(true)
         {
            _loc7_ = _cFirstChild;
            _cFirstChild = null;
            _cLastChild = null;
            _loc6_ = 0;
            while(_loc7_)
            {
               _loc6_++;
               _loc5_ = _loc7_;
               _loc8_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc3_)
               {
                  _loc8_++;
                  _loc5_ = _loc5_.cNext;
                  if(_loc5_)
                  {
                     _loc9_++;
                     continue;
                  }
                  break;
               }
               _loc2_ = _loc3_;
               while(_loc8_ > 0 || _loc2_ > 0 && _loc5_)
               {
                  if(_loc8_ == 0)
                  {
                     _loc4_ = _loc5_;
                     _loc5_ = _loc5_.cNext;
                     _loc2_--;
                  }
                  else if(_loc2_ == 0 || !_loc5_)
                  {
                     _loc4_ = _loc7_;
                     _loc7_ = _loc7_.cNext;
                     _loc8_--;
                  }
                  else if(param1)
                  {
                     if(_loc7_.cTransform.nLocalY >= _loc5_.cTransform.nLocalY)
                     {
                        _loc4_ = _loc7_;
                        _loc7_ = _loc7_.cNext;
                        _loc8_--;
                     }
                     else
                     {
                        _loc4_ = _loc5_;
                        _loc5_ = _loc5_.cNext;
                        _loc2_--;
                     }
                  }
                  else if(_loc7_.cTransform.nLocalY <= _loc5_.cTransform.nLocalY)
                  {
                     _loc4_ = _loc7_;
                     _loc7_ = _loc7_.cNext;
                     _loc8_--;
                  }
                  else
                  {
                     _loc4_ = _loc5_;
                     _loc5_ = _loc5_.cNext;
                     _loc2_--;
                  }
                  
                  
                  
                  if(_cLastChild)
                  {
                     _cLastChild.cNext = _loc4_;
                  }
                  else
                  {
                     _cFirstChild = _loc4_;
                  }
                  _loc4_.cPrevious = _cLastChild;
                  _cLastChild = _loc4_;
               }
               _loc7_ = _loc5_;
            }
            _cLastChild.cNext = null;
            if(_loc6_ <= 1)
            {
               break;
            }
            _loc3_ = _loc3_ * 2;
         }
      }
      
      public function sortChildrenOnX(param1:Boolean = true) : void {
         var _loc8_:* = 0;
         var _loc2_:* = 0;
         var _loc6_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:FNode = null;
         var _loc5_:FNode = null;
         var _loc4_:FNode = null;
         if(_cFirstChild == null)
         {
            return;
         }
         var _loc3_:* = 1;
         while(true)
         {
            _loc7_ = _cFirstChild;
            _cFirstChild = null;
            _cLastChild = null;
            _loc6_ = 0;
            while(_loc7_)
            {
               _loc6_++;
               _loc5_ = _loc7_;
               _loc8_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc3_)
               {
                  _loc8_++;
                  _loc5_ = _loc5_.cNext;
                  if(_loc5_)
                  {
                     _loc9_++;
                     continue;
                  }
                  break;
               }
               _loc2_ = _loc3_;
               while(_loc8_ > 0 || _loc2_ > 0 && _loc5_)
               {
                  if(_loc8_ == 0)
                  {
                     _loc4_ = _loc5_;
                     _loc5_ = _loc5_.cNext;
                     _loc2_--;
                  }
                  else if(_loc2_ == 0 || !_loc5_)
                  {
                     _loc4_ = _loc7_;
                     _loc7_ = _loc7_.cNext;
                     _loc8_--;
                  }
                  else if(param1)
                  {
                     if(_loc7_.cTransform.nLocalX >= _loc5_.cTransform.nLocalX)
                     {
                        _loc4_ = _loc7_;
                        _loc7_ = _loc7_.cNext;
                        _loc8_--;
                     }
                     else
                     {
                        _loc4_ = _loc5_;
                        _loc5_ = _loc5_.cNext;
                        _loc2_--;
                     }
                  }
                  else if(_loc7_.cTransform.nLocalX <= _loc5_.cTransform.nLocalX)
                  {
                     _loc4_ = _loc7_;
                     _loc7_ = _loc7_.cNext;
                     _loc8_--;
                  }
                  else
                  {
                     _loc4_ = _loc5_;
                     _loc5_ = _loc5_.cNext;
                     _loc2_--;
                  }
                  
                  
                  
                  if(_cLastChild)
                  {
                     _cLastChild.cNext = _loc4_;
                  }
                  else
                  {
                     _cFirstChild = _loc4_;
                  }
                  _loc4_.cPrevious = _cLastChild;
                  _cLastChild = _loc4_;
               }
               _loc7_ = _loc5_;
            }
            _cLastChild.cNext = null;
            if(_loc6_ <= 1)
            {
               break;
            }
            _loc3_ = _loc3_ * 2;
         }
      }
      
      public function sortChildrenOnUserData(param1:String, param2:Boolean = true) : void {
         var _loc9_:* = 0;
         var _loc3_:* = 0;
         var _loc7_:* = 0;
         var _loc10_:* = 0;
         var _loc8_:FNode = null;
         var _loc6_:FNode = null;
         var _loc5_:FNode = null;
         if(_cFirstChild == null)
         {
            return;
         }
         var _loc4_:* = 1;
         while(true)
         {
            _loc8_ = _cFirstChild;
            _cFirstChild = null;
            _cLastChild = null;
            _loc7_ = 0;
            while(_loc8_)
            {
               _loc7_++;
               _loc6_ = _loc8_;
               _loc9_ = 0;
               _loc10_ = 0;
               while(_loc10_ < _loc4_)
               {
                  _loc9_++;
                  _loc6_ = _loc6_.cNext;
                  if(_loc6_)
                  {
                     _loc10_++;
                     continue;
                  }
                  break;
               }
               _loc3_ = _loc4_;
               while(_loc9_ > 0 || _loc3_ > 0 && _loc6_)
               {
                  if(_loc9_ == 0)
                  {
                     _loc5_ = _loc6_;
                     _loc6_ = _loc6_.cNext;
                     _loc3_--;
                  }
                  else if(_loc3_ == 0 || !_loc6_)
                  {
                     _loc5_ = _loc8_;
                     _loc8_ = _loc8_.cNext;
                     _loc9_--;
                  }
                  else if(param2)
                  {
                     if(_loc8_.userData[param1] >= _loc6_.userData[param1])
                     {
                        _loc5_ = _loc8_;
                        _loc8_ = _loc8_.cNext;
                        _loc9_--;
                     }
                     else
                     {
                        _loc5_ = _loc6_;
                        _loc6_ = _loc6_.cNext;
                        _loc3_--;
                     }
                  }
                  else if(_loc8_.userData[param1] <= _loc6_.userData[param1])
                  {
                     _loc5_ = _loc8_;
                     _loc8_ = _loc8_.cNext;
                     _loc9_--;
                  }
                  else
                  {
                     _loc5_ = _loc6_;
                     _loc6_ = _loc6_.cNext;
                     _loc3_--;
                  }
                  
                  
                  
                  if(_cLastChild)
                  {
                     _cLastChild.cNext = _loc5_;
                  }
                  else
                  {
                     _cFirstChild = _loc5_;
                  }
                  _loc5_.cPrevious = _cLastChild;
                  _cLastChild = _loc5_;
               }
               _loc8_ = _loc6_;
            }
            _cLastChild.cNext = null;
            if(_loc7_ <= 1)
            {
               break;
            }
            _loc4_ = _loc4_ * 2;
         }
      }
      
      public function getWorldBounds(param1:Rectangle = null) : Rectangle {
         var _loc2_:* = null;
         if(param1 == null)
         {
            param1 = new Rectangle();
         }
         var _loc8_:* = Infinity;
         var _loc7_:* = -Infinity;
         var _loc9_:* = Infinity;
         var _loc6_:* = -Infinity;
         var _loc5_:Rectangle = new Rectangle();
         var _loc4_:FComponent = __cFirstComponent;
         while(_loc4_)
         {
            _loc2_ = _loc4_ as FRenderable;
            if(_loc2_)
            {
               _loc2_.getWorldBounds(_loc5_);
               _loc8_ = _loc8_ < _loc5_.x?_loc8_:_loc5_.x;
               _loc7_ = _loc7_ > _loc5_.right?_loc7_:_loc5_.right;
               _loc9_ = _loc9_ < _loc5_.y?_loc9_:_loc5_.y;
               _loc6_ = _loc6_ > _loc5_.bottom?_loc6_:_loc5_.bottom;
            }
            _loc4_ = _loc4_.cNext;
         }
         var _loc3_:FNode = _cFirstChild;
         while(_loc3_)
         {
            _loc3_.getWorldBounds(_loc5_);
            _loc8_ = _loc8_ < _loc5_.x?_loc8_:_loc5_.x;
            _loc7_ = _loc7_ > _loc5_.right?_loc7_:_loc5_.right;
            _loc9_ = _loc9_ < _loc5_.y?_loc9_:_loc5_.y;
            _loc6_ = _loc6_ > _loc5_.bottom?_loc6_:_loc5_.bottom;
            _loc3_ = _loc3_.cNext;
         }
         param1.setTo(_loc8_,_loc9_,_loc7_ - _loc8_,_loc6_ - _loc9_);
         return param1;
      }
   }
}
