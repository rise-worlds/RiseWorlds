package com.flengine.core
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.components.physics.*;
    import com.flengine.components.renderables.*;
    import com.flengine.context.*;
    import com.flengine.context.postprocesses.*;
    import com.flengine.error.*;
    import com.flengine.signals.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FNode extends Object
    {
        private var __eOnAddedToStage:HelpSignal;
        private var __eOnRemovedFromStage:HelpSignal;
        private var __eOnComponentAdded:HelpSignal;
        private var __eOnComponentRemoved:HelpSignal;
        var cPool:FNodePool;
        var cPoolPrevious:FNode;
        var cPoolNext:FNode;
        var cPrevious:FNode;
        var cNext:FNode;
        private var __bChangedParent:Boolean = false;
        public var cameraGroup:int = 0;
        private var __bParentActive:Boolean = true;
        var iUsedAsMask:int = 0;
        private var __bActive:Boolean = true;
        private var __aTags:Vector.<String>;
        private var __oUserData:Object;
        var cCore:FlEngine;
        protected var _iId:uint;
        protected var _sName:String;
        var cTransform:FTransform;
        var cBody:FBody;
        var cParent:FNode;
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
        var cMouseOver:FNode;
        var cMouseDown:FNode;
        var cRightMouseDown:FNode;
        private var __dComponentsLookupTable:Dictionary;
        private var __cFirstComponent:FComponent;
        private var __cLastComponent:FComponent;
        private var _iChildCount:int = 0;
        private var _cFirstChild:FNode;
        private var _cLastChild:FNode;
        var iUsedAsPPMask:int;
        private static var __iCount:int = 0;
        private static var __aActiveMasks:Vector.<FNode> = new Vector.<FNode>;

        public function FNode(param1:String = "")
        {
            __aTags = new Vector.<String>;
            (__iCount + 1);
            _iId = __iCount;
            _sName = param1 == "" ? ("FNode#" + __iCount) : (param1);
            cCore = FlEngine.getInstance();
            __dComponentsLookupTable = new Dictionary();
            cTransform = new FTransform(this);
            __dComponentsLookupTable[FTransform] = cTransform;
            return;
        }// end function

        public function getPrototype() : XML
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            var _loc_3:* = <node/>;
            _loc_3.@name = _sName;
            _loc_3.@mouseEnabled = mouseEnabled;
            _loc_3.@mouseChildren = mouseChildren;
            _loc_3.@tags = __aTags.join(",");
            _loc_3.components = <components/>;
            _loc_3.components.appendChild(cTransform.getPrototype());
            if (cBody)
            {
                _loc_3.components.appendChild(cBody.getPrototype());
            }
            var _loc_2:* = __cFirstComponent;
            while (_loc_2)
            {
                
                _loc_3.components.appendChild(_loc_2.getPrototype());
                _loc_2 = _loc_2.cNext;
            }
            _loc_3.children = <children/>;
            var _loc_1:* = _cFirstChild;
            while (_loc_1)
            {
                
                _loc_3.children.appendChild(_loc_1.getPrototype());
                _loc_1 = _loc_1.cNext;
            }
            return _loc_3;
        }// end function

        public function get onAddedToStage() : HelpSignal
        {
            if (__eOnAddedToStage == null)
            {
                __eOnAddedToStage = new HelpSignal();
            }
            return __eOnAddedToStage;
        }// end function

        public function get onRemovedFromStage() : HelpSignal
        {
            if (__eOnRemovedFromStage == null)
            {
                __eOnRemovedFromStage = new HelpSignal();
            }
            return __eOnRemovedFromStage;
        }// end function

        public function get onComponentAdded() : HelpSignal
        {
            if (__eOnComponentAdded == null)
            {
                __eOnComponentAdded = new HelpSignal();
            }
            return __eOnComponentAdded;
        }// end function

        public function get onComponentRemoved() : HelpSignal
        {
            if (__eOnComponentRemoved == null)
            {
                __eOnComponentRemoved = new HelpSignal();
            }
            return __eOnComponentRemoved;
        }// end function

        public function get previous() : FNode
        {
            return cPrevious;
        }// end function

        public function get next() : FNode
        {
            return cNext;
        }// end function

        function set bParentActive(param1:Boolean) : void
        {
            var _loc_2:* = _cFirstChild;
            while (_loc_2)
            {
                
                _loc_2.bParentActive = param1;
                _loc_2 = _loc_2.cNext;
            }
            return;
        }// end function

        public function set active(param1:Boolean) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = null;
            if (param1 == __bActive)
            {
                return;
            }
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            __bActive = param1;
            cTransform.active = __bActive;
            if (cPool)
            {
                if (param1)
                {
                    cPool.putToBack(this);
                }
                else
                {
                    cPool.putToFront(this);
                }
            }
            if (cBody)
            {
                cBody.active = __bActive;
            }
            _loc_3 = __cFirstComponent;
            while (_loc_3)
            {
                
                _loc_3.active = __bActive;
                _loc_3 = _loc_3.cNext;
            }
            _loc_2 = _cFirstChild;
            while (_loc_2)
            {
                
                _loc_2.bParentActive = __bActive;
                _loc_2 = _loc_2.cNext;
            }
            return;
        }// end function

        public function get active() : Boolean
        {
            return __bActive;
        }// end function

        public function hasTag(param1:String) : Boolean
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            if (__aTags.indexOf(param1) != -1)
            {
                return true;
            }
            return false;
        }// end function

        public function addTag(param1:String) : void
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            if (__aTags.indexOf(param1) != -1)
            {
                return;
            }
            __aTags.push(param1);
            return;
        }// end function

        public function removeTag(param1:String) : void
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            var _loc_2:* = __aTags.indexOf(param1);
            if (_loc_2 == -1)
            {
                return;
            }
            __aTags.splice(_loc_2, 1);
            return;
        }// end function

        public function get userData() : Object
        {
            if (__oUserData == null)
            {
                __oUserData = {};
            }
            return __oUserData;
        }// end function

        public function get core() : FlEngine
        {
            return cCore;
        }// end function

        public function get name() : String
        {
            return _sName;
        }// end function

        public function set name(param1:String) : void
        {
            _sName = param1;
            return;
        }// end function

        public function get transform() : FTransform
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            return cTransform;
        }// end function

        public function get parent() : FNode
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            return cParent;
        }// end function

        function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            var _loc_5:* = null;
            if (!__bActive || !__bParentActive)
            {
                return;
            }
            __bChangedParent = false;
            __bUpdating = true;
            var _loc_8:* = param2 || cTransform.bTransformDirty;
            var _loc_7:* = param3 || cTransform.bColorDirty;
            if (_loc_8 || _loc_7 || cBody != null && cBody.isDynamic())
            {
                cTransform.invalidate(_loc_8, _loc_7);
            }
            if (cBody != null)
            {
                cBody.update(param1, _loc_8, _loc_7);
            }
            var _loc_6:* = __cFirstComponent;
            while (_loc_6)
            {
                
                _loc_6.update(param1, _loc_8, _loc_7);
                _loc_6 = _loc_6.cNext;
            }
            _loc_8 = _loc_8 || cTransform.bTransformDirty;
            _loc_7 = _loc_7 || cTransform.bColorDirty;
            if (cTransform.bTransformDirty || cTransform.bColorDirty)
            {
                cTransform.invalidate(cTransform.bTransformDirty, cTransform.bColorDirty);
            }
            var _loc_4:* = _cFirstChild;
            while (_loc_4)
            {
                
                _loc_4.update(param1, _loc_8, _loc_7);
                _loc_5 = _loc_4.next;
                if (_loc_4.__bDisposeAfterUpdate)
                {
                    _loc_4.dispose();
                }
                if (_loc_4.__bRemoveAfterUpdate)
                {
                    removeChild(_loc_4);
                }
                _loc_4 = _loc_5;
            }
            __bUpdating = false;
            return;
        }// end function

        function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:Boolean) : void
        {
            if (!__bActive || __bChangedParent || !__bParentActive || !cTransform.visible || (cameraGroup & param2.mask) == 0 && cameraGroup != 0 || iUsedAsMask > 0 && !param4)
            {
                return;
            }
            if (!param4)
            {
                if (cTransform.cMask != null)
                {
                    param1.renderAsStencilMask(__aActiveMasks.length);
                    cTransform.cMask.render(param1, param2, param3, true);
                    __aActiveMasks.push(cTransform.cMask);
                    param1.renderToColor(__aActiveMasks.length);
                }
            }
            __bRendering = true;
            if (cTransform.rAbsoluteMaskRect != null)
            {
                param3 = param3.intersection(cTransform.rAbsoluteMaskRect);
            }
            var _loc_6:* = __cFirstComponent;
            while (_loc_6)
            {
                
                _loc_6.render(param1, param2, param3);
                _loc_6 = _loc_6.cNext;
            }
            var _loc_5:* = _cFirstChild;
            while (_loc_5)
            {
                
                if (_loc_5.postProcess)
                {
                    _loc_5.postProcess.render(param1, param2, param3, _loc_5);
                }
                else
                {
                    _loc_5.render(param1, param2, param3, param4);
                }
                _loc_5 = _loc_5.cNext;
            }
            if (core.cConfig.enableStats && core.cConfig.showExtendedStats)
            {
                (param2.iRenderedNodesCount + 1);
            }
            if (!param4)
            {
                if (cTransform.cMask != null)
                {
                    __aActiveMasks.pop();
                    if (__aActiveMasks.length == 0)
                    {
                        param1.clearStencil();
                    }
                    param1.renderToColor(__aActiveMasks.length);
                }
            }
            __bRendering = false;
            return;
        }// end function

        public function toString() : String
        {
            return "[G2DNode]" + _sName;
        }// end function

        public function disposeChildren() : void
        {
            if (__bRendering)
            {
                throw new FError("FError: Cannot do this while rendering.");
            }
            if (_cFirstChild == null)
            {
                return;
            }
            var _loc_1:* = _cFirstChild.cNext;
            while (_loc_1)
            {
                
                _loc_1.cPrevious.dispose();
                _loc_1 = _loc_1.cNext;
            }
            _cFirstChild.dispose();
            _cFirstChild = null;
            _cLastChild = null;
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_2:* = null;
            if (__bRendering)
            {
                throw new FError("FError: Cannot do this while rendering.");
            }
            if (__bUpdating)
            {
                __bDisposeAfterUpdate = true;
                return;
            }
            if (__bDisposed)
            {
                return;
            }
            __bActive = false;
            disposeChildren();
            for (_loc_1 in __dComponentsLookupTable)
            {
                
                _loc_2 = _loc_3[_loc_1];
                delete _loc_3[_loc_1];
                _loc_2.dispose();
            }
            cBody = null;
            cTransform = null;
            __cFirstComponent = null;
            __cLastComponent = null;
            __dComponentsLookupTable = null;
            if (cParent != null)
            {
                cParent.removeChild(this);
            }
            cNext = null;
            cPrevious = null;
            if (cPoolNext)
            {
                cPoolNext.cPoolPrevious = cPoolPrevious;
            }
            if (cPoolPrevious)
            {
                cPoolPrevious.cPoolNext = cPoolNext;
            }
            cPoolNext = null;
            cPoolPrevious = null;
            cPool = null;
            if (__eOnMouseDown)
            {
                __eOnMouseDown.dispose();
                __eOnMouseDown = null;
            }
            if (__eOnMouseMove)
            {
                __eOnMouseMove.dispose();
                __eOnMouseMove = null;
            }
            if (__eOnMouseUp)
            {
                __eOnMouseUp.dispose();
                __eOnMouseUp = null;
            }
            if (__eOnMouseOver)
            {
                __eOnMouseOver.dispose();
                __eOnMouseOver = null;
            }
            if (__eOnMouseClick)
            {
                __eOnMouseClick.dispose();
                __eOnMouseClick = null;
            }
            if (__eOnMouseOut)
            {
                __eOnMouseOut.dispose();
                __eOnMouseOut = null;
            }
            if (__eOnRemovedFromStage)
            {
                __eOnRemovedFromStage.dispose();
                __eOnRemovedFromStage = null;
            }
            if (__eOnAddedToStage)
            {
                __eOnAddedToStage.dispose();
                __eOnAddedToStage = null;
            }
            __bDisposed = true;
            return;
        }// end function

        public function get onMouseDown() : HelpSignal
        {
            if (__eOnMouseDown == null)
            {
                __eOnMouseDown = new HelpSignal();
            }
            return __eOnMouseDown;
        }// end function

        public function get onMouseMove() : HelpSignal
        {
            if (__eOnMouseMove == null)
            {
                __eOnMouseMove = new HelpSignal();
            }
            return __eOnMouseMove;
        }// end function

        public function get onMouseUp() : HelpSignal
        {
            if (__eOnMouseUp == null)
            {
                __eOnMouseUp = new HelpSignal();
            }
            return __eOnMouseUp;
        }// end function

        public function get onMouseOver() : HelpSignal
        {
            if (__eOnMouseOver == null)
            {
                __eOnMouseOver = new HelpSignal();
            }
            return __eOnMouseOver;
        }// end function

        public function get onMouseClick() : HelpSignal
        {
            if (__eOnMouseClick == null)
            {
                __eOnMouseClick = new HelpSignal();
            }
            return __eOnMouseClick;
        }// end function

        public function get onMouseOut() : HelpSignal
        {
            if (__eOnMouseOut == null)
            {
                __eOnMouseOut = new HelpSignal();
            }
            return __eOnMouseOut;
        }// end function

        function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D, param4:FCamera) : Boolean
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (!active || !cTransform.visible || (cameraGroup & param4.mask) == 0 && cameraGroup != 0)
            {
                return false;
            }
            if (mouseChildren)
            {
                _loc_5 = _cLastChild;
                while (_loc_5)
                {
                    
                    param1 = _loc_5.processMouseEvent(param1, param2, param3, param4) || param1;
                    _loc_5 = _loc_5.cPrevious;
                }
            }
            if (mouseEnabled)
            {
                _loc_6 = __cFirstComponent;
                while (_loc_6)
                {
                    
                    param1 = _loc_6.processMouseEvent(param1, param2, param3) || param1;
                    _loc_6 = _loc_6.cNext;
                }
            }
            return param1;
        }// end function

        function handleMouseEvent(param1:FNode, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (mouseEnabled)
            {
                _loc_7 = new FMouseSignal(this, param1, param3, param4, param5, param6, param2);
                if (param2 == "mouseDown")
                {
                    cMouseDown = param1;
                    if (__eOnMouseDown)
                    {
                        __eOnMouseDown.dispatch(_loc_7);
                    }
                }
                else if (param2 == "mouseMove")
                {
                    if (__eOnMouseMove)
                    {
                        __eOnMouseMove.dispatch(_loc_7);
                    }
                }
                else if (param2 == "mouseUp")
                {
                    if (cMouseDown == param1 && __eOnMouseClick)
                    {
                        _loc_8 = new FMouseSignal(this, param1, param3, param4, param5, param6, "mouseUp");
                        __eOnMouseClick.dispatch(_loc_8);
                    }
                    cMouseDown = null;
                    if (__eOnMouseUp)
                    {
                        __eOnMouseUp.dispatch(_loc_8);
                    }
                }
                else if (param2 == "mouseOver")
                {
                    cMouseOver = param1;
                    if (__eOnMouseOver)
                    {
                        __eOnMouseOver.dispatch(_loc_8);
                    }
                }
                else if (param2 == "mouseOut")
                {
                    cMouseOver = null;
                    if (__eOnMouseOut)
                    {
                        __eOnMouseOut.dispatch(_loc_7);
                    }
                }
            }
            if (cParent)
            {
                cParent.handleMouseEvent(param1, param2, param3, param4, param5, param6);
            }
            return;
        }// end function

        public function getComponents() : Dictionary
        {
            return __dComponentsLookupTable;
        }// end function

        public function getComponent(param1:Class) : FComponent
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            return __dComponentsLookupTable[param1];
        }// end function

        public function hasComponent(param1:Class) : Boolean
        {
            return __dComponentsLookupTable[param1] != null;
        }// end function

        public function addExistComponent(param1:FComponent, param2:Class, param3:Object = null) : FComponent
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            if (param3 == null)
            {
                param3 = param2;
            }
            if (__dComponentsLookupTable[param3] != null)
            {
                return __dComponentsLookupTable[param3];
            }
            param1.cLookupClass = param3;
            __dComponentsLookupTable[param3] = param1;
            if (param1 is FBody)
            {
                if (cBody)
                {
                    throw new FError("FError: Node cannot have multiple body components.");
                }
                cBody = param1 as FBody;
                return param1;
            }
            if (__cFirstComponent == null)
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
            if (__eOnComponentAdded)
            {
                __eOnComponentAdded.dispatch(param3);
            }
            return param1;
        }// end function

        public function addComponent(param1:Class, param2:Class = null) : FComponent
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            if (param2 == null)
            {
                param2 = param1;
            }
            if (__dComponentsLookupTable[param2] != null)
            {
                return __dComponentsLookupTable[param2];
            }
            var _loc_3:* = new param1(this);
            if (_loc_3 == null)
            {
                throw new FError("FError: Invalid component class.");
            }
            _loc_3.cLookupClass = param2;
            __dComponentsLookupTable[param2] = _loc_3;
            if (_loc_3 is FBody)
            {
                if (cBody)
                {
                    throw new FError("FError: Node cannot have multiple body components.");
                }
                cBody = _loc_3 as FBody;
                return _loc_3;
            }
            if (__cFirstComponent == null)
            {
                __cFirstComponent = _loc_3;
                __cLastComponent = _loc_3;
            }
            else
            {
                __cLastComponent.cNext = _loc_3;
                _loc_3.cPrevious = __cLastComponent;
                __cLastComponent = _loc_3;
            }
            if (__eOnComponentAdded)
            {
                __eOnComponentAdded.dispatch(param2);
            }
            return _loc_3;
        }// end function

        public function addComponentFromPrototype(param1:XML) : FComponent
        {
            var _loc_4:* = this.getDefinitionByName(param1.@componentClass.split("-").join("::"));
            var _loc_2:* = this.getDefinitionByName(param1.@componentLookupClass.split("-").join("::"));
            var _loc_3:* = addComponent(_loc_4 as Class, _loc_2 as Class);
            _loc_3.bindFromPrototype(param1);
            return _loc_3;
        }// end function

        public function removeComponent(param1:Class) : void
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            var _loc_2:* = __dComponentsLookupTable[param1];
            if (_loc_2 == null || _loc_2 == cTransform)
            {
                return;
            }
            if (_loc_2.cPrevious != null)
            {
                _loc_2.cPrevious.cNext = _loc_2.cNext;
            }
            if (_loc_2.cNext != null)
            {
                _loc_2.cNext.cPrevious = _loc_2.cPrevious;
            }
            if (__cFirstComponent == _loc_2)
            {
                __cFirstComponent = __cFirstComponent.cNext;
            }
            if (__cLastComponent == _loc_2)
            {
                __cLastComponent = __cLastComponent.cPrevious;
            }
            delete __dComponentsLookupTable[param1];
            if (_loc_2 is FBody)
            {
                cBody = null;
            }
            _loc_2.dispose();
            if (__eOnComponentAdded)
            {
                __eOnComponentAdded.dispatch(param1);
            }
            return;
        }// end function

        public function get firstChild() : FNode
        {
            return _cFirstChild;
        }// end function

        public function get lastChild() : FNode
        {
            return _cLastChild;
        }// end function

        public function get numChildren() : int
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            return _iChildCount;
        }// end function

        public function addChild(param1:FNode) : void
        {
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            if (param1 == this)
            {
                throw new FError("FError: Node cannot be the child of itself.");
            }
            if (param1.parent != null)
            {
                param1.parent.removeChild(param1);
            }
            param1.__bChangedParent = true;
            param1.cParent = this;
            if (_cFirstChild == null)
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
            (_iChildCount + 1);
            if (isOnStage())
            {
                param1.addedToStage();
            }
            return;
        }// end function

        public function removeChild(param1:FNode) : void
        {
            if (param1.__bRendering)
            {
                throw new FError("FError: Cannot do this while rendering.");
            }
            if (__bDisposed)
            {
                throw new FError("FError: Node is already disposed.");
            }
            if (param1.cParent != this)
            {
                return;
            }
            if (param1.__bUpdating)
            {
                param1.__bRemoveAfterUpdate = true;
                return;
            }
            if (param1.cPrevious != null)
            {
                param1.cPrevious.cNext = param1.cNext;
            }
            else
            {
                _cFirstChild = _cFirstChild.cNext;
            }
            if (param1.cNext)
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
            (_iChildCount - 1);
            param1.__bRemoveAfterUpdate = false;
            if (isOnStage())
            {
                param1.removedFromStage();
            }
            return;
        }// end function

        public function swapChildren(param1:FNode, param2:FNode) : void
        {
            if (param1.parent != this || param2.parent != this)
            {
                return;
            }
            var _loc_3:* = param1.cNext;
            if (param2.cNext == param1)
            {
                param1.cNext = param2;
            }
            else
            {
                param1.cNext = param2.cNext;
                if (param1.cNext)
                {
                    _loc_3.cPrevious = param1;
                }
            }
            if (_loc_3 == param2)
            {
                param2.cNext = param1;
            }
            else
            {
                param2.cNext = _loc_3;
                if (param2.cNext)
                {
                    param2.cNext.cPrevious = param2;
                }
            }
            _loc_3 = param1.cPrevious;
            if (param2.cPrevious == param1)
            {
                param1.cPrevious = param2;
            }
            else
            {
                param1.cPrevious = param2.cPrevious;
                if (param1.cPrevious)
                {
                    _loc_3.cNext = param1;
                }
            }
            if (_loc_3 == param2)
            {
                param2.cPrevious = param1;
            }
            else
            {
                param2.cPrevious = _loc_3;
                if (param2.cPrevious)
                {
                    param2.cPrevious.cNext = param2;
                }
            }
            if (param1 == _cFirstChild)
            {
                _cFirstChild = param2;
            }
            else if (param2 == _cFirstChild)
            {
                _cFirstChild = param1;
            }
            if (param1 == _cLastChild)
            {
                _cLastChild = param2;
            }
            else if (param2 == _cLastChild)
            {
                _cLastChild = param1;
            }
            return;
        }// end function

        public function putChildToFront(param1:FNode) : void
        {
            if (param1 == _cLastChild)
            {
                return;
            }
            if (param1.cNext)
            {
                param1.cNext.cPrevious = param1.cPrevious;
            }
            if (param1.cPrevious)
            {
                param1.cPrevious.cNext = param1.cNext;
            }
            if (param1 == _cFirstChild)
            {
                _cFirstChild = _cFirstChild.cNext;
            }
            if (_cLastChild != null)
            {
                _cLastChild.cNext = param1;
            }
            param1.cPrevious = _cLastChild;
            param1.cNext = null;
            _cLastChild = param1;
            return;
        }// end function

        public function putChildToBack(param1:FNode) : void
        {
            if (param1 == _cFirstChild)
            {
                return;
            }
            if (param1.cNext)
            {
                param1.cNext.cPrevious = param1.cPrevious;
            }
            if (param1.cPrevious)
            {
                param1.cPrevious.cNext = param1.cNext;
            }
            if (param1 == _cLastChild)
            {
                _cLastChild = _cLastChild.cPrevious;
            }
            if (_cFirstChild != null)
            {
                _cFirstChild.cPrevious = param1;
            }
            param1.cPrevious = null;
            param1.cNext = _cFirstChild;
            _cFirstChild = param1;
            return;
        }// end function

        private function addedToStage() : void
        {
            if (__eOnAddedToStage)
            {
                __eOnAddedToStage.dispatch(null);
            }
            if (cBody != null)
            {
                cBody.addToSpace();
            }
            var _loc_1:* = _cFirstChild;
            while (_loc_1)
            {
                
                _loc_1.addedToStage();
                _loc_1 = _loc_1.cNext;
            }
            return;
        }// end function

        private function removedFromStage() : void
        {
            if (__eOnRemovedFromStage)
            {
                __eOnRemovedFromStage.dispatch(null);
            }
            if (cBody != null)
            {
                cBody.removeFromSpace();
            }
            var _loc_1:* = _cFirstChild;
            while (_loc_1)
            {
                
                _loc_1.removedFromStage();
                _loc_1 = _loc_1.cNext;
            }
            return;
        }// end function

        public function isOnStage() : Boolean
        {
            if (cCore.root == this)
            {
                return true;
            }
            if (cParent == null)
            {
                return false;
            }
            return cParent.isOnStage();
        }// end function

        public function sortChildrenOnY(param1:Boolean = true) : void
        {
            var _loc_8:* = 0;
            var _loc_2:* = 0;
            var _loc_6:* = 0;
            var _loc_9:* = 0;
            var _loc_7:* = null;
            var _loc_5:* = null;
            var _loc_4:* = null;
            if (_cFirstChild == null)
            {
                return;
            }
            var _loc_3:* = 1;
            while (true)
            {
                
                _loc_7 = _cFirstChild;
                _cFirstChild = null;
                _cLastChild = null;
                _loc_6 = 0;
                while (_loc_7)
                {
                    
                    _loc_6++;
                    _loc_5 = _loc_7;
                    _loc_8 = 0;
                    _loc_9 = 0;
                    while (_loc_9 < _loc_3)
                    {
                        
                        _loc_8++;
                        _loc_5 = _loc_5.cNext;
                        if (_loc_5)
                        {
                            _loc_9++;
                        }
                    }
                    _loc_2 = _loc_3;
                    while (_loc_8 > 0 || _loc_2 > 0 && _loc_5)
                    {
                        
                        if (_loc_8 == 0)
                        {
                            _loc_4 = _loc_5;
                            _loc_5 = _loc_5.cNext;
                            _loc_2--;
                        }
                        else if (_loc_2 == 0 || !_loc_5)
                        {
                            _loc_4 = _loc_7;
                            _loc_7 = _loc_7.cNext;
                            _loc_8--;
                        }
                        else if (param1)
                        {
                            if (_loc_7.cTransform.nLocalY >= _loc_5.cTransform.nLocalY)
                            {
                                _loc_4 = _loc_7;
                                _loc_7 = _loc_7.cNext;
                                _loc_8--;
                            }
                            else
                            {
                                _loc_4 = _loc_5;
                                _loc_5 = _loc_5.cNext;
                                _loc_2--;
                            }
                        }
                        else if (_loc_7.cTransform.nLocalY <= _loc_5.cTransform.nLocalY)
                        {
                            _loc_4 = _loc_7;
                            _loc_7 = _loc_7.cNext;
                            _loc_8--;
                        }
                        else
                        {
                            _loc_4 = _loc_5;
                            _loc_5 = _loc_5.cNext;
                            _loc_2--;
                        }
                        if (_cLastChild)
                        {
                            _cLastChild.cNext = _loc_4;
                        }
                        else
                        {
                            _cFirstChild = _loc_4;
                        }
                        _loc_4.cPrevious = _cLastChild;
                        _cLastChild = _loc_4;
                    }
                    _loc_7 = _loc_5;
                }
                _cLastChild.cNext = null;
                if (_loc_6 <= 1)
                {
                    return;
                }
                _loc_3 = _loc_3 * 2;
            }
            return;
        }// end function

        public function sortChildrenOnX(param1:Boolean = true) : void
        {
            var _loc_8:* = 0;
            var _loc_2:* = 0;
            var _loc_6:* = 0;
            var _loc_9:* = 0;
            var _loc_7:* = null;
            var _loc_5:* = null;
            var _loc_4:* = null;
            if (_cFirstChild == null)
            {
                return;
            }
            var _loc_3:* = 1;
            while (true)
            {
                
                _loc_7 = _cFirstChild;
                _cFirstChild = null;
                _cLastChild = null;
                _loc_6 = 0;
                while (_loc_7)
                {
                    
                    _loc_6++;
                    _loc_5 = _loc_7;
                    _loc_8 = 0;
                    _loc_9 = 0;
                    while (_loc_9 < _loc_3)
                    {
                        
                        _loc_8++;
                        _loc_5 = _loc_5.cNext;
                        if (_loc_5)
                        {
                            _loc_9++;
                        }
                    }
                    _loc_2 = _loc_3;
                    while (_loc_8 > 0 || _loc_2 > 0 && _loc_5)
                    {
                        
                        if (_loc_8 == 0)
                        {
                            _loc_4 = _loc_5;
                            _loc_5 = _loc_5.cNext;
                            _loc_2--;
                        }
                        else if (_loc_2 == 0 || !_loc_5)
                        {
                            _loc_4 = _loc_7;
                            _loc_7 = _loc_7.cNext;
                            _loc_8--;
                        }
                        else if (param1)
                        {
                            if (_loc_7.cTransform.nLocalX >= _loc_5.cTransform.nLocalX)
                            {
                                _loc_4 = _loc_7;
                                _loc_7 = _loc_7.cNext;
                                _loc_8--;
                            }
                            else
                            {
                                _loc_4 = _loc_5;
                                _loc_5 = _loc_5.cNext;
                                _loc_2--;
                            }
                        }
                        else if (_loc_7.cTransform.nLocalX <= _loc_5.cTransform.nLocalX)
                        {
                            _loc_4 = _loc_7;
                            _loc_7 = _loc_7.cNext;
                            _loc_8--;
                        }
                        else
                        {
                            _loc_4 = _loc_5;
                            _loc_5 = _loc_5.cNext;
                            _loc_2--;
                        }
                        if (_cLastChild)
                        {
                            _cLastChild.cNext = _loc_4;
                        }
                        else
                        {
                            _cFirstChild = _loc_4;
                        }
                        _loc_4.cPrevious = _cLastChild;
                        _cLastChild = _loc_4;
                    }
                    _loc_7 = _loc_5;
                }
                _cLastChild.cNext = null;
                if (_loc_6 <= 1)
                {
                    return;
                }
                _loc_3 = _loc_3 * 2;
            }
            return;
        }// end function

        public function sortChildrenOnUserData(param1:String, param2:Boolean = true) : void
        {
            var _loc_9:* = 0;
            var _loc_3:* = 0;
            var _loc_7:* = 0;
            var _loc_10:* = 0;
            var _loc_8:* = null;
            var _loc_6:* = null;
            var _loc_5:* = null;
            if (_cFirstChild == null)
            {
                return;
            }
            var _loc_4:* = 1;
            while (true)
            {
                
                _loc_8 = _cFirstChild;
                _cFirstChild = null;
                _cLastChild = null;
                _loc_7 = 0;
                while (_loc_8)
                {
                    
                    _loc_7++;
                    _loc_6 = _loc_8;
                    _loc_9 = 0;
                    _loc_10 = 0;
                    while (_loc_10 < _loc_4)
                    {
                        
                        _loc_9++;
                        _loc_6 = _loc_6.cNext;
                        if (_loc_6)
                        {
                            _loc_10++;
                        }
                    }
                    _loc_3 = _loc_4;
                    while (_loc_9 > 0 || _loc_3 > 0 && _loc_6)
                    {
                        
                        if (_loc_9 == 0)
                        {
                            _loc_5 = _loc_6;
                            _loc_6 = _loc_6.cNext;
                            _loc_3--;
                        }
                        else if (_loc_3 == 0 || !_loc_6)
                        {
                            _loc_5 = _loc_8;
                            _loc_8 = _loc_8.cNext;
                            _loc_9--;
                        }
                        else if (param2)
                        {
                            if (_loc_8.userData[param1] >= _loc_6.userData[param1])
                            {
                                _loc_5 = _loc_8;
                                _loc_8 = _loc_8.cNext;
                                _loc_9--;
                            }
                            else
                            {
                                _loc_5 = _loc_6;
                                _loc_6 = _loc_6.cNext;
                                _loc_3--;
                            }
                        }
                        else if (_loc_8.userData[param1] <= _loc_6.userData[param1])
                        {
                            _loc_5 = _loc_8;
                            _loc_8 = _loc_8.cNext;
                            _loc_9--;
                        }
                        else
                        {
                            _loc_5 = _loc_6;
                            _loc_6 = _loc_6.cNext;
                            _loc_3--;
                        }
                        if (_cLastChild)
                        {
                            _cLastChild.cNext = _loc_5;
                        }
                        else
                        {
                            _cFirstChild = _loc_5;
                        }
                        _loc_5.cPrevious = _cLastChild;
                        _cLastChild = _loc_5;
                    }
                    _loc_8 = _loc_6;
                }
                _cLastChild.cNext = null;
                if (_loc_7 <= 1)
                {
                    return;
                }
                _loc_4 = _loc_4 * 2;
            }
            return;
        }// end function

        public function getWorldBounds(param1:Rectangle = null) : Rectangle
        {
            var _loc_2:* = null;
            if (param1 == null)
            {
                param1 = new Rectangle();
            }
            var _loc_8:* = 1;
            var _loc_7:* = -1;
            var _loc_9:* = 1;
            var _loc_6:* = -1;
            var _loc_5:* = new Rectangle();
            var _loc_4:* = __cFirstComponent;
            while (_loc_4)
            {
                
                _loc_2 = _loc_4 as FRenderable;
                if (_loc_2)
                {
                    _loc_2.getWorldBounds(_loc_5);
                    _loc_8 = _loc_8 < _loc_5.x ? (_loc_8) : (_loc_5.x);
                    _loc_7 = _loc_7 > _loc_5.right ? (_loc_7) : (_loc_5.right);
                    _loc_9 = _loc_9 < _loc_5.y ? (_loc_9) : (_loc_5.y);
                    _loc_6 = _loc_6 > _loc_5.bottom ? (_loc_6) : (_loc_5.bottom);
                }
                _loc_4 = _loc_4.cNext;
            }
            var _loc_3:* = _cFirstChild;
            while (_loc_3)
            {
                
                _loc_3.getWorldBounds(_loc_5);
                _loc_8 = _loc_8 < _loc_5.x ? (_loc_8) : (_loc_5.x);
                _loc_7 = _loc_7 > _loc_5.right ? (_loc_7) : (_loc_5.right);
                _loc_9 = _loc_9 < _loc_5.y ? (_loc_9) : (_loc_5.y);
                _loc_6 = _loc_6 > _loc_5.bottom ? (_loc_6) : (_loc_5.bottom);
                _loc_3 = _loc_3.cNext;
            }
            param1.setTo(_loc_8, _loc_9, _loc_7 - _loc_8, _loc_6 - _loc_9);
            return param1;
        }// end function

    }
}
