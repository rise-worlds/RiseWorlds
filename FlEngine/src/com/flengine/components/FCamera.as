package com.flengine.components
{
    import __AS3__.vec.*;
    import com.flengine.context.*;
    import com.flengine.core.*;
    import flash.events.*;
    import flash.geom.*;

    public class FCamera extends FComponent
    {
        public var mask:int = 16777215;
        public var normalizedViewX:Number = 0;
        public var normalizedViewY:Number = 0;
        public var normalizedViewWidth:Number = 1;
        public var normalizedViewHeight:Number = 1;
        public var backgroundRed:Number = 0;
        public var backgroundGreen:Number = 0;
        public var backgroundBlue:Number = 0;
        public var backgroundAlpha:Number = 0;
        public var rViewRectangle:Rectangle;
        public var rendererData:Object;
        public var bCapturedThisFrame:Boolean = false;
        public var nViewX:Number = 0;
        public var nViewY:Number = 0;
        public var nScaleX:Number = 1;
        public var nScaleY:Number = 1;
        public var aCameraVector:Vector.<Number>;
        public var iRenderedNodesCount:int;

        public function FCamera(param1:FNode)
        {
            new Vector.<Number>(8)[0] = 0;
            new Vector.<Number>(8)[1] = 0;
            new Vector.<Number>(8)[2] = 0;
            new Vector.<Number>(8)[3] = 0;
            new Vector.<Number>(8)[4] = 0;
            new Vector.<Number>(8)[5] = 0;
            new Vector.<Number>(8)[6] = 0;
            new Vector.<Number>(8)[7] = 0;
            aCameraVector = new Vector.<Number>(8);
            super(param1);
            rViewRectangle = new Rectangle();
            if (cNode != cNode.cCore.root && cNode.isOnStage())
            {
                cNode.cCore.addCamera(this);
            }
            cNode.onAddedToStage.add(onAddedToStage);
            cNode.onRemovedFromStage.add(onRemovedFromStage);
            return;
        }

        override public function getPrototype() : XML
        {
            _xPrototype = super.getPrototype();
            return _xPrototype;
        }

        public function get backgroundColor() : uint
        {
            var _loc_1:* = uint(this.backgroundAlpha * 255) << 24;
            var _loc_2:* = uint(this.backgroundRed * 255) << 16;
            var _loc_3:* = uint(this.backgroundGreen * 255) << 8;
            var _loc_4:* = uint(this.backgroundBlue * 255);
            return _loc_1 + _loc_2 + _loc_3 + _loc_4;
        }

        public function get zoom() : Number
        {
            return nScaleX;
        }

        public function set zoom(param1:Number) : void
        {
            nScaleY = param1;
            nScaleX = param1;
            return;
        }

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            return;
        }

        public function invalidate() : void
        {
            rViewRectangle.x = normalizedViewX * cNode.cCore.cConfig.viewRect.width;
            rViewRectangle.y = normalizedViewY * cNode.cCore.cConfig.viewRect.height;
            var _loc_2:* = normalizedViewWidth + normalizedViewX > 1 ? (1 - normalizedViewX) : (normalizedViewWidth);
            var _loc_1:* = normalizedViewHeight + normalizedViewY > 1 ? (1 - normalizedViewY) : (normalizedViewHeight);
            rViewRectangle.width = _loc_2 * cNode.cCore.cConfig.viewRect.width;
            rViewRectangle.height = _loc_1 * cNode.cCore.cConfig.viewRect.height;
            aCameraVector[0] = cNode.cTransform.nWorldRotation;
            aCameraVector[1] = rViewRectangle.x + rViewRectangle.width / 2;
            aCameraVector[2] = rViewRectangle.y + rViewRectangle.height / 2;
            aCameraVector[4] = cNode.cTransform.nWorldX;
            aCameraVector[5] = cNode.cTransform.nWorldY;
            aCameraVector[6] = nScaleX;
            aCameraVector[7] = nScaleY;
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (param2 != null || !cNode.active)
            {
                return;
            }
            iRenderedNodesCount = 0;
            if (backgroundAlpha != 0)
            {
                param1.blitColor(rViewRectangle.x + rViewRectangle.width / 2, rViewRectangle.y + rViewRectangle.height / 2, rViewRectangle.width, rViewRectangle.height, backgroundRed, backgroundGreen, backgroundBlue, backgroundAlpha, 1, rViewRectangle);
            }
            param1.setCamera(this);
            cNode.cCore.root.render(param1, this, rViewRectangle, false);
            return;
        }

        public function captureMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean
        {
            if (bCapturedThisFrame || !cNode.active)
            {
                return false;
            }
            bCapturedThisFrame = true;
            if (!rViewRectangle.contains(param3.x, param3.y))
            {
                return false;
            }
            param3.x = param3.x - (rViewRectangle.x + rViewRectangle.width / 2);
            param3.y = param3.y - (rViewRectangle.y + rViewRectangle.height / 2);
            var _loc_6:* = Math.cos(-cNode.cTransform.nWorldRotation);
            var _loc_7:* = Math.sin(-cNode.cTransform.nWorldRotation);
            var _loc_5:* = param3.x * _loc_6 - param3.y * _loc_7;
            var _loc_4:* = param3.y * _loc_6 + param3.x * _loc_7;
            _loc_5 = _loc_5 / nScaleY;
            _loc_4 = _loc_4 / nScaleX;
            param3.x = _loc_5 + cNode.cTransform.nWorldX;
            param3.y = _loc_4 + cNode.cTransform.nWorldY;
            return cNode.cCore.root.processMouseEvent(param1, param2, param3, this);
        }

        override public function dispose() : void
        {
            cNode.cCore.removeCamera(this);
            cNode.onAddedToStage.remove(onAddedToStage);
            cNode.onRemovedFromStage.remove(onRemovedFromStage);
            super.dispose();
            return;
        }

        private function onAddedToStage(param1:Object) : void
        {
            cNode.cCore.addCamera(this);
            return;
        }

        private function onRemovedFromStage(param1:Object) : void
        {
            cNode.cCore.removeCamera(this);
            return;
        }

    }
}
