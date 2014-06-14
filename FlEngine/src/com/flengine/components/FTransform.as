package com.flengine.components
{
    import com.flengine.core.*;
    import flash.geom.*;

    public class FTransform extends FComponent
    {
        public var visible:Boolean = true;
        private var __bWorldTransformMatrixDirty:Boolean = true;
        private var __mWorldTransformMatrix:Matrix3D;
        private var __mLocalTransformMatrix:Matrix3D;
        public var bTransformDirty:Boolean = true;
        public var nWorldX:Number = 0;
        public var nLocalX:Number = 0;
        public var nWorldY:Number = 0;
        public var nLocalY:Number = 0;
        public var nWorldScaleX:Number = 1;
        public var nWorldScaleY:Number = 1;
        public var nWorldRotation:Number = 0;
        public var bColorDirty:Boolean = true;
        public var nWorldRed:Number = 1;
        public var nWorldGreen:Number = 1;
        public var nWorldBlue:Number = 1;
        public var nWorldAlpha:Number = 1;
        private var __nLocalScaleX:Number = 1;
        private var __nLocalScaleY:Number = 1;
        private var __nLocalRotation:Number = 0;
        private var _red:Number = 1;
        private var _green:Number = 1;
        private var _blue:Number = 1;
        private var _alpha:Number = 1;
        public var useWorldSpace:Boolean = false;
        public var useWorldColor:Boolean = false;
        public var cMask:FNode;
        public var rMaskRect:Rectangle;
        public var rAbsoluteMaskRect:Rectangle;

        public function FTransform(param1:FNode)
        {
            __mWorldTransformMatrix = new Matrix3D();
            __mLocalTransformMatrix = new Matrix3D();
            super(param1);
            return;
        }

        public function get worldTransformMatrix() : Matrix3D
        {
            var _loc_2:* = NaN;
            var _loc_1:* = NaN;
            if (__bWorldTransformMatrixDirty)
            {
                _loc_2 = nWorldScaleX == 0 ? (1e-006) : (nWorldScaleX);
                _loc_1 = nWorldScaleY == 0 ? (1e-006) : (nWorldScaleY);
                __mWorldTransformMatrix.identity();
                __mWorldTransformMatrix.prependScale(_loc_2, _loc_1, 1);
                __mWorldTransformMatrix.prependRotation(nWorldRotation * 180 / Math.PI, Vector3D.Z_AXIS);
                __mWorldTransformMatrix.appendTranslation(nWorldX, nWorldY, 0);
                __bWorldTransformMatrixDirty = false;
            }
            return __mWorldTransformMatrix;
        }

        public function get localTransformMatrix() : Matrix3D
        {
            __mLocalTransformMatrix.identity();
            __mLocalTransformMatrix.prependScale(__nLocalScaleX, __nLocalScaleY, 1);
            __mLocalTransformMatrix.prependRotation(__nLocalRotation * 180 / Math.PI, Vector3D.Z_AXIS);
            __mLocalTransformMatrix.appendTranslation(nLocalX, nLocalY, 0);
            return __mLocalTransformMatrix;
        }

        override public function set active(param1:Boolean) : void
        {
            active = param1;
            bTransformDirty = _bActive;
            return;
        }

        public function getTransformedWorldTransformMatrix(param1:Number, param2:Number, param3:Number, param4:Boolean) : Matrix3D
        {
            var _loc_5:* = worldTransformMatrix.clone();
            if (param1 != 1 && param2 != 1)
            {
                _loc_5.prependScale(param1, param2, 1);
            }
            if (param3 != 0)
            {
                _loc_5.prependRotation(param3, Vector3D.Z_AXIS);
            }
            if (param4)
            {
                _loc_5.invert();
            }
            return _loc_5;
        }

        public function get x() : Number
        {
            return nLocalX;
        }

        public function set x(param1:Number) : void
        {
            nLocalX = param1;
            nWorldX = param1;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.x = param1;
            }
            if (rMaskRect)
            {
                rAbsoluteMaskRect.x = rMaskRect.x + nWorldX;
            }
            return;
        }

        public function get y() : Number
        {
            return nLocalY;
        }

        public function set y(param1:Number) : void
        {
            nLocalY = param1;
            nWorldY = param1;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.y = param1;
            }
            if (rMaskRect)
            {
                rAbsoluteMaskRect.y = rMaskRect.y + nWorldY;
            }
            return;
        }

        public function setPosition(param1:Number, param2:Number) : void
        {
            nLocalX = param1;
            nWorldX = param1;
            nLocalY = param2;
            nWorldY = param2;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.x = param1;
                cNode.cBody.y = param2;
            }
            if (rMaskRect)
            {
                rAbsoluteMaskRect.x = rMaskRect.x + nWorldX;
                rAbsoluteMaskRect.y = rMaskRect.y + nWorldY;
            }
            return;
        }

        public function setScale(param1:Number, param2:Number) : void
        {
            __nLocalScaleX = param1;
            nWorldScaleX = param1;
            __nLocalScaleY = param2;
            nWorldScaleY = param2;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.scaleX = param1;
                cNode.cBody.scaleY = param2;
            }
            return;
        }

        public function get scaleX() : Number
        {
            return __nLocalScaleX;
        }

        public function set scaleX(param1:Number) : void
        {
            __nLocalScaleX = param1;
            nWorldScaleX = param1;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.scaleX = param1;
            }
            return;
        }

        public function get scaleY() : Number
        {
            return __nLocalScaleY;
        }

        public function set scaleY(param1:Number) : void
        {
            __nLocalScaleY = param1;
            nWorldScaleY = param1;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.scaleY = param1;
            }
            return;
        }

        public function get rotation() : Number
        {
            return __nLocalRotation;
        }

        public function set rotation(param1:Number) : void
        {
            __nLocalRotation = param1;
            nWorldRotation = param1;
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.rotation = param1;
            }
            return;
        }

        public function set color(param1:int) : void
        {
            red = (param1 >> 16 & 255) / 255;
            green = (param1 >> 8 & 255) / 255;
            blue = (param1 & 255) / 255;
            return;
        }

        public function get red() : Number
        {
            return _red;
        }

        public function set red(param1:Number) : void
        {
            _red = param1;
            nWorldRed = param1;
            bColorDirty = true;
            return;
        }

        public function get green() : Number
        {
            return _green;
        }

        public function set green(param1:Number) : void
        {
            _green = param1;
            nWorldGreen = param1;
            bColorDirty = true;
            return;
        }

        public function get blue() : Number
        {
            return _blue;
        }

        public function set blue(param1:Number) : void
        {
            _blue = param1;
            nWorldBlue = param1;
            bColorDirty = true;
            return;
        }

        public function get alpha() : Number
        {
            return _alpha;
        }

        public function set alpha(param1:Number) : void
        {
            _alpha = param1;
            nWorldAlpha = param1;
            bColorDirty = true;
            return;
        }

        public function get mask() : FNode
        {
            return cMask;
        }

        public function set mask(param1:FNode) : void
        {
            if (cMask)
            {
                (cMask.iUsedAsMask - 1);
            }
            cMask = param1;
            (cMask.iUsedAsMask + 1);
            return;
        }

        public function get maskRect() : Rectangle
        {
            return rMaskRect;
        }

        public function set maskRect(param1:Rectangle) : void
        {
            rMaskRect = param1;
            rAbsoluteMaskRect = param1.clone();
            rAbsoluteMaskRect.x = rAbsoluteMaskRect.x + nWorldX;
            rAbsoluteMaskRect.y = rAbsoluteMaskRect.y + nWorldY;
            return;
        }

        public function invalidate(param1:Boolean, param2:Boolean) : void
        {
            var _loc_3:* = NaN;
            var _loc_5:* = NaN;
            if (cNode.cParent == null)
            {
                bTransformDirty = false;
                bColorDirty = false;
                return;
            }
            var _loc_4:* = cNode.cParent.cTransform;
            if (cNode.cBody != null && cNode.cBody.isDynamic())
            {
                nWorldX = cNode.cBody.x;
                nLocalX = cNode.cBody.x;
                nWorldY = cNode.cBody.y;
                nLocalY = cNode.cBody.y;
                nWorldRotation = cNode.cBody.rotation;
                __nLocalRotation = cNode.cBody.rotation;
                __bWorldTransformMatrixDirty = true;
            }
            else if (param1)
            {
                if (!useWorldSpace)
                {
                    if (_loc_4.nWorldRotation != 0)
                    {
                        _loc_3 = Math.cos(_loc_4.nWorldRotation);
                        _loc_5 = Math.sin(_loc_4.nWorldRotation);
                        nWorldX = nLocalX * _loc_4.nWorldScaleX * _loc_3 - nLocalY * _loc_4.nWorldScaleY * _loc_5 + _loc_4.nWorldX;
                        nWorldY = nLocalY * _loc_4.nWorldScaleY * _loc_3 + nLocalX * _loc_4.nWorldScaleX * _loc_5 + _loc_4.nWorldY;
                    }
                    else
                    {
                        nWorldX = nLocalX * _loc_4.nWorldScaleX + _loc_4.nWorldX;
                        nWorldY = nLocalY * _loc_4.nWorldScaleY + _loc_4.nWorldY;
                    }
                    nWorldScaleX = __nLocalScaleX * _loc_4.nWorldScaleX;
                    nWorldScaleY = __nLocalScaleY * _loc_4.nWorldScaleY;
                    nWorldRotation = __nLocalRotation + _loc_4.nWorldRotation;
                    if (rMaskRect)
                    {
                        rAbsoluteMaskRect.x = rMaskRect.x + nWorldX;
                        rAbsoluteMaskRect.y = rMaskRect.y + nWorldY;
                    }
                    if (cNode.cBody != null && cNode.cBody.isKinematic())
                    {
                        cNode.cBody.x = nWorldX;
                        cNode.cBody.y = nWorldY;
                        cNode.cBody.rotation = nWorldRotation;
                    }
                    bTransformDirty = false;
                    __bWorldTransformMatrixDirty = true;
                }
            }
            if (param2 && !useWorldColor)
            {
                nWorldRed = _red * _loc_4.nWorldRed;
                nWorldGreen = _green * _loc_4.nWorldGreen;
                nWorldBlue = _blue * _loc_4.nWorldBlue;
                nWorldAlpha = _alpha * _loc_4.nWorldAlpha;
                bColorDirty = false;
            }
            return;
        }

        public function setColor(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1) : void
        {
            red = param1;
            green = param2;
            blue = param3;
            alpha = param4;
            return;
        }

        public function worldToLocal(param1:Vector3D) : Vector3D
        {
            if (cNode.cParent == null)
            {
                return param1;
            }
            var _loc_2:* = getTransformedWorldTransformMatrix(1, 1, 0, true);
            return _loc_2.transformVector(param1);
        }

        public function localToWorld(param1:Vector3D) : Vector3D
        {
            if (cNode.cParent == null)
            {
                return param1;
            }
            param1 = localTransformMatrix.transformVector(param1);
            return cNode.cParent.cTransform.localToWorld(param1);
        }

        public function toString() : String
        {
            return "[" + x + "," + y + "," + scaleX + "," + scaleY + "]\n[" + nWorldX + "," + nWorldY + "]";
        }

    }
}
