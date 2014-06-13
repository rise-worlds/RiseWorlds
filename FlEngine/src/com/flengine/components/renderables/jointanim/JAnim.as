package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.components.renderables.*;
    import com.flengine.context.*;
    import com.flengine.core.*;
    import flash.events.*;
    import flash.geom.*;

    public class JAnim extends FRenderable
    {
        private var _JointAnimate:JointAnimate;
        private var _id:int;
        private var _listener:JAnimListener;
        private var _animRunning:Boolean;
        private var _paused:Boolean;
        private var _interpolate:Boolean;
        private var _color:JAColor;
        private var _transform:JATransform2D;
        private var _drawTransform:JATransform2D;
        private var _mirror:Boolean;
        private var _additive:Boolean;
        private var _inNode:Boolean;
        private var _mainSpriteInst:JASpriteInst;
        private var _transDirty:Boolean;
        private var _blendTicksTotal:Number;
        private var _blendTicksCur:Number;
        private var _blendDelay:Number;
        private var _lastPlayedFrameLabel:String;
        private var _helpGetTransformedVertices3DVector:Vector.<Number>;
        private static var _helpTransform:JATransform = new JATransform();
        private static var _helpCallTransform:Vector.<JATransform> = new Vector.<JATransform>(1000);
        private static var _helpCallColor:Vector.<JAColor> = new Vector.<JAColor>(1000);
        private static var _helpCallDepth:int = 0;
        private static var _helpDrawSpriteASrcRect:Rectangle = new Rectangle();
        private static var _helpCalcTransform:JATransform;
        private static var _helpCalcColor:JAColor;
        private static var _helpANextObjectPos:Vector.<JAObjectPos> = new Vector.<JAObjectPos>(3);
        public static var UpdateCnt:int = 0;
        private static var _helpGetTransformedVertices3DTransformMatrix:Matrix3D = new Matrix3D();
        private static const NORMALIZED_VERTICES_3D:Vector.<Number> = JAnim.Vector.<Number>([-0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, 0.5, 0]);
        private static var _helpMatrix3DVector1:Vector.<Number> = JAnim.Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
        private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
        private static var _helpJAnimRender:JATransform2D = new JATransform2D();
        private static var _helpJAnimRenderVector:Vector.<Number> = new Vector.<Number>(16);
        private static var bInit:Boolean = false;
        private static var _helpDrawSprite:Matrix = new Matrix();

        public function JAnim(param1:FNode, param2:JointAnimate, param3:int, param4:JAnimListener = null)
        {
            _helpGetTransformedVertices3DVector = new Vector.<Number>;
            super(param1);
            if (param2 == null)
            {
                throw new Error("Joint Animate is null!");
            }
            _inNode = param1 != null;
            _JointAnimate = param2;
            _id = param3;
            _listener = param4;
            _mirror = false;
            _animRunning = false;
            _paused = false;
            _transform = new JATransform2D();
            _interpolate = true;
            _color = new JAColor();
            _color.clone(JAColor.White);
            _additive = false;
            _transDirty = true;
            _mainSpriteInst = new JASpriteInst();
            _mainSpriteInst.spriteDef = null;
            _mainSpriteInst.parent = null;
            _blendDelay = 0;
            _blendTicksCur = 0;
            _blendTicksTotal = 0;
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            _color = null;
            _transform = null;
            _mainSpriteInst.Dispose();
            _JointAnimate = null;
            return;
        }// end function

        override public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean
        {
            return false;
        }// end function

        override public function getWorldBounds(param1:Rectangle = null) : Rectangle
        {
            var _loc_4:* = 0;
            var _loc_2:* = getTransformedVertices3D();
            if (param1)
            {
                param1.setTo(_loc_2[0], _loc_2[1], 0, 0);
            }
            else
            {
                param1 = new Rectangle(_loc_2[0], _loc_2[1], 0, 0);
            }
            var _loc_3:* = _loc_2.length;
            _loc_4 = 3;
            while (_loc_4 < _loc_3)
            {
                
                if (param1.left > _loc_2[_loc_4])
                {
                    param1.left = _loc_2[_loc_4];
                }
                if (param1.right < _loc_2[_loc_4])
                {
                    param1.right = _loc_2[_loc_4];
                }
                if (param1.top > _loc_2[(_loc_4 + 1)])
                {
                    param1.top = _loc_2[(_loc_4 + 1)];
                }
                if (param1.bottom < _loc_2[(_loc_4 + 1)])
                {
                    param1.bottom = _loc_2[(_loc_4 + 1)];
                }
                _loc_4 = _loc_4 + 3;
            }
            return param1;
        }// end function

        private function getTransformedVertices3D() : Vector.<Number>
        {
            _helpGetTransformedVertices3DTransformMatrix.copyFrom(cNode.cTransform.worldTransformMatrix);
            _helpMatrix3DVector1[0] = _transform.m00;
            _helpMatrix3DVector1[1] = _transform.m10;
            _helpMatrix3DVector1[4] = _transform.m01;
            _helpMatrix3DVector1[5] = _transform.m11;
            _helpMatrix3DVector1[12] = _transform.m02;
            _helpMatrix3DVector1[13] = _transform.m12;
            _helpMatrix3DArg1.copyRawDataFrom(_helpMatrix3DVector1);
            _helpGetTransformedVertices3DTransformMatrix.prepend(_helpMatrix3DArg1);
            NORMALIZED_VERTICES_3D[0] = _JointAnimate.animRect.x;
            NORMALIZED_VERTICES_3D[1] = _JointAnimate.animRect.y;
            NORMALIZED_VERTICES_3D[2] = 0;
            NORMALIZED_VERTICES_3D[3] = _JointAnimate.animRect.x;
            NORMALIZED_VERTICES_3D[4] = _JointAnimate.animRect.y + _JointAnimate.animRect.height;
            NORMALIZED_VERTICES_3D[5] = 0;
            NORMALIZED_VERTICES_3D[6] = _JointAnimate.animRect.x + _JointAnimate.animRect.width;
            NORMALIZED_VERTICES_3D[7] = _JointAnimate.animRect.y + _JointAnimate.animRect.height;
            NORMALIZED_VERTICES_3D[8] = 0;
            NORMALIZED_VERTICES_3D[9] = _JointAnimate.animRect.x + _JointAnimate.animRect.width;
            NORMALIZED_VERTICES_3D[10] = _JointAnimate.animRect.y;
            NORMALIZED_VERTICES_3D[11] = 0;
            _helpGetTransformedVertices3DTransformMatrix.transformVectors(NORMALIZED_VERTICES_3D, _helpGetTransformedVertices3DVector);
            return _helpGetTransformedVertices3DVector;
        }// end function

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            if (_inNode)
            {
                _drawTransform = JAMatrix3.MulJAMatrix3_M3D(cNode.cTransform.worldTransformMatrix, _transform, _helpJAnimRender);
            }
            else
            {
                _drawTransform = _transform;
            }
            Draw(param1);
            return;
        }// end function

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            if (_inNode)
            {
                _drawTransform = JAMatrix3.MulJAMatrix3_M3D(cNode.cTransform.worldTransformMatrix, _transform, _helpJAnimRender);
            }
            else
            {
                _drawTransform = _transform;
            }
            Update(param1 * 0.1);
            return;
        }// end function

        public function get transform() : JATransform2D
        {
            return _transform;
        }// end function

        public function get lastPlayedLabel() : String
        {
            return _lastPlayedFrameLabel;
        }// end function

        public function get interpolate() : Boolean
        {
            return _interpolate;
        }// end function

        public function set interpolate(param1:Boolean) : void
        {
            _interpolate = param1;
            return;
        }// end function

        public function set mirror(param1:Boolean) : void
        {
            _mirror = param1;
            return;
        }// end function

        public function get mirror() : Boolean
        {
            return _mirror;
        }// end function

        public function set additive(param1:Boolean) : void
        {
            _additive = param1;
            return;
        }// end function

        public function get additive() : Boolean
        {
            return _additive;
        }// end function

        public function set color(param1:uint) : void
        {
            _color.alpha = param1 >> 24 & 255;
            _color.red = param1 >> 16 & 255;
            _color.green = param1 >> 8 & 255;
            _color.blue = param1 & 255;
            return;
        }// end function

        public function get color() : uint
        {
            return _color.toInt();
        }// end function

        public function get mainSpriteInst() : JASpriteInst
        {
            return _mainSpriteInst;
        }// end function

        public function IsActive() : Boolean
        {
            if (_animRunning)
            {
                return true;
            }
            return false;
        }// end function

        public function GetToFirstFrame() : void
        {
            var _loc_1:* = false;
            var _loc_2:* = false;
            while (_mainSpriteInst.spriteDef != null && _mainSpriteInst.frameNum < _mainSpriteInst.spriteDef.workAreaStart)
            {
                
                _loc_1 = _animRunning;
                _loc_2 = _paused;
                _animRunning = true;
                _paused = false;
                Update(0);
                _animRunning = _loc_1;
                _paused = _loc_2;
            }
            return;
        }// end function

        public function ResetAnim() : void
        {
            ResetAnimHelper(_mainSpriteInst);
            _animRunning = false;
            GetToFirstFrame();
            _blendTicksTotal = 0;
            _blendTicksCur = 0;
            _blendDelay = 0;
            return;
        }// end function

        public function SetupSpriteInst(param1:String = "") : Boolean
        {
            var _loc_4:* = 0;
            if (_mainSpriteInst == null)
            {
                return false;
            }
            if (_mainSpriteInst.spriteDef != null && param1 == "")
            {
                return true;
            }
            if (_JointAnimate.mainAnimDef.mainSpriteDef != null)
            {
                InitSpriteInst(_mainSpriteInst, _JointAnimate.mainAnimDef.mainSpriteDef);
                return true;
            }
            if (_JointAnimate.mainAnimDef.spriteDefVector.length == 0)
            {
                return false;
            }
            var _loc_3:* = param1;
            if (_loc_3.length == 0)
            {
                _loc_3 = "main";
            }
            var _loc_2:* = null;
            _loc_4 = 0;
            while (_loc_4 < _JointAnimate.mainAnimDef.spriteDefVector.length)
            {
                
                if (_JointAnimate.mainAnimDef.spriteDefVector[_loc_4].name != null && _JointAnimate.mainAnimDef.spriteDefVector[_loc_4].name == _loc_3)
                {
                    _loc_2 = _JointAnimate.mainAnimDef.spriteDefVector[_loc_4];
                    _lastPlayedFrameLabel = _loc_3;
                    break;
                }
                _loc_4++;
            }
            if (_loc_2 == null)
            {
                _loc_2 = _JointAnimate.mainAnimDef.spriteDefVector[0];
            }
            if (_loc_2 != _mainSpriteInst.spriteDef)
            {
                if (_mainSpriteInst.spriteDef != null)
                {
                    _mainSpriteInst.Reset();
                    _mainSpriteInst.parent = null;
                }
                InitSpriteInst(_mainSpriteInst, _loc_2);
                _transDirty = true;
            }
            return true;
        }// end function

        public function Play(param1:String, param2:Boolean = true) : Boolean
        {
            var _loc_3:* = 0;
            _animRunning = false;
            if (_JointAnimate.mainAnimDef.mainSpriteDef)
            {
                if (!SetupSpriteInst())
                {
                    return false;
                }
                _loc_3 = _JointAnimate.mainAnimDef.mainSpriteDef.GetLabelFrame(param1);
                if (_loc_3 == -1)
                {
                    return false;
                }
                _lastPlayedFrameLabel = param1;
                return PlayIndex(_loc_3, param2);
            }
            _lastPlayedFrameLabel = param1;
            SetupSpriteInst(param1);
            return PlayIndex(_mainSpriteInst.spriteDef.workAreaStart, param2);
        }// end function

        public function PlayIndex(param1:int = 0, param2:Boolean = true) : Boolean
        {
            if (!SetupSpriteInst())
            {
                return false;
            }
            if (param1 >= _mainSpriteInst.spriteDef.frames.length)
            {
                _animRunning = false;
                return false;
            }
            if (_mainSpriteInst.frameNum != param1 && param2)
            {
                ResetAnim();
            }
            _paused = false;
            _animRunning = true;
            _mainSpriteInst.delayFrames = 0;
            _mainSpriteInst.frameNum = param1;
            _mainSpriteInst.lastFrameNum = param1;
            _mainSpriteInst.frameRepeats = 0;
            if (_blendDelay == 0)
            {
                DoFramesHit(_mainSpriteInst, null);
            }
            return true;
        }// end function

        public function Update(param1:Number) : void
        {
            if (!SetupSpriteInst())
            {
                return;
            }
            UpdateF(param1);
            return;
        }// end function

        private function UpdateF(param1:Number) : void
        {
            if (_paused)
            {
                return;
            }
            AnimUpdate(param1);
            return;
        }// end function

        public function Draw(param1:FContext) : void
        {
            if (!SetupSpriteInst())
            {
                return;
            }
            _helpCallDepth = 0;
            if (!_inNode)
            {
                _drawTransform = _transform;
            }
            if (_transDirty)
            {
                UpdateTransforms(_mainSpriteInst, null, _color, false);
                _transDirty = false;
            }
            DrawSprite(param1, _mainSpriteInst, null, _color, _additive, false);
            return;
        }// end function

        private function DrawSprite(param1:FContext, param2:JASpriteInst, param3:JATransform, param4:JAColor, param5:Boolean, param6:Boolean) : void
        {
            var _loc_7:* = null;
            var _loc_16:* = 0;
            var _loc_20:* = null;
            var _loc_9:* = null;
            var _loc_24:* = null;
            var _loc_8:* = null;
            var _loc_19:* = 0;
            var _loc_11:* = null;
            var _loc_13:* = null;
            var _loc_21:* = null;
            var _loc_23:* = null;
            var _loc_12:* = NaN;
            var _loc_14:* = NaN;
            var _loc_18:* = 0;
            var _loc_17:* = param2.spriteDef.frames[param2.frameNum];
            var _loc_22:* = _helpCallTransform[_helpCallDepth];
            var _loc_10:* = _helpCallColor[_helpCallDepth];
            (_helpCallDepth + 1);
            var _loc_15:* = param6 || param2.delayFrames > 0 || _loc_17.hasStop;
            _loc_16 = 0;
            while (_loc_16 < _loc_17.frameObjectPosVector.length)
            {
                
                _loc_20 = _loc_17.frameObjectPosVector[_loc_16];
                _loc_9 = param2.children[_loc_20.objectNum];
                if (_listener != null && _loc_9.predrawCallback)
                {
                    _loc_9.predrawCallback = _listener.JAnimObjectPredraw(_id, this, param1, param2, _loc_9, param3, param4);
                }
                if (_loc_20.isSprite)
                {
                    _loc_7 = _loc_9.spriteInst;
                    _loc_10.clone(_loc_7.curColor);
                    _loc_22.clone(_loc_7.curTransform);
                }
                else
                {
                    CalcObjectPos(param2, _loc_16, _loc_15);
                    _loc_22 = _helpCalcTransform;
                    _loc_10 = _helpCalcColor;
                    _helpCalcTransform = null;
                    _helpCalcColor = null;
                }
                if (param3 == null && _JointAnimate.drawScale != 1)
                {
                    _helpTransform.matrix.LoadIdentity();
                    _helpTransform.matrix.m00 = _JointAnimate.drawScale;
                    _helpTransform.matrix.m11 = _JointAnimate.drawScale;
                    _helpTransform.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _helpTransform.matrix, _helpTransform.matrix);
                    _loc_24 = _helpTransform.TransformSrc(_loc_22, _loc_22);
                }
                else if (param3 == null || _loc_20.isSprite)
                {
                    _loc_24 = _loc_22;
                    if (_JointAnimate.drawScale != 1)
                    {
                        _helpTransform.matrix.LoadIdentity();
                        _helpTransform.matrix.m00 = _JointAnimate.drawScale;
                        _helpTransform.matrix.m11 = _JointAnimate.drawScale;
                        _loc_24.matrix = JAMatrix3.MulJAMatrix3(_helpTransform.matrix, _loc_24.matrix, _loc_24.matrix);
                    }
                    _loc_24.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _loc_24.matrix, _loc_24.matrix);
                }
                else
                {
                    _loc_24 = param3.TransformSrc(_loc_22, _loc_22);
                }
                _loc_8 = _helpCallColor[_helpCallDepth];
                (_helpCallDepth + 1);
                _loc_8.Set(_loc_10.red * param4.red * _loc_9.colorMult.red / 65025, _loc_10.green * param4.green * _loc_9.colorMult.green / 65025, _loc_10.blue * param4.blue * _loc_9.colorMult.blue / 65025, _loc_10.alpha * param4.alpha * _loc_9.colorMult.alpha / 65025);
                if (_loc_8.alpha != 0)
                {
                    if (_loc_20.isSprite)
                    {
                        _loc_7 = _loc_9.spriteInst;
                        DrawSprite(param1, _loc_7, _loc_24, _loc_8, _loc_20.isAdditive || param5, _loc_15);
                    }
                    else
                    {
                        _loc_19 = 0;
                        while (true)
                        {
                            
                            _loc_11 = _JointAnimate.imageVector[_loc_20.resNum];
                            _loc_13 = _loc_24.TransformSrc(_loc_11.transform, _loc_24);
                            _loc_23 = _helpDrawSpriteASrcRect;
                            if (_loc_20.animFrameNum == 0 || _loc_11.images.length == 1)
                            {
                                _loc_21 = _loc_11.images[0];
                                _loc_21.GetCelRect(_loc_20.animFrameNum, _loc_23);
                            }
                            else
                            {
                                _loc_21 = _loc_11.images[_loc_20.animFrameNum];
                                _loc_21.GetCelRect(0, _loc_23);
                            }
                            if (_loc_20.hasSrcRect)
                            {
                                _loc_23 = _loc_20.srcRect;
                            }
                            if (_JointAnimate.imgScale != 1)
                            {
                                _loc_12 = _loc_13.matrix.m02;
                                _loc_14 = _loc_13.matrix.m12;
                                _helpTransform.matrix.LoadIdentity();
                                _helpTransform.matrix.m00 = 1 / _JointAnimate.imgScale;
                                _helpTransform.matrix.m11 = 1 / _JointAnimate.imgScale;
                                _loc_13 = _helpTransform.TransformSrc(_loc_13, _loc_13);
                                _loc_13.matrix.m02 = _loc_12;
                                _loc_13.matrix.m12 = _loc_14;
                            }
                            _loc_18 = 0;
                            if (_listener != null && _loc_9.imagePredrawCallback)
                            {
                                _loc_18 = _listener.JAnimImagePredraw(param2, _loc_9, _loc_13, _loc_21, param1, _loc_19);
                                if (_loc_18 == 0)
                                {
                                    _loc_9.imagePredrawCallback = false;
                                }
                            }
                            _helpTransform.matrix.LoadIdentity();
                            _helpTransform.matrix.m02 = _loc_23.width / 2;
                            _helpTransform.matrix.m12 = _loc_23.height / 2;
                            if (_mirror)
                            {
                                _helpTransform.matrix.m00 = -1;
                            }
                            _loc_13.matrix = JAMatrix3.MulJAMatrix3(_loc_13.matrix, _helpTransform.matrix, _loc_13.matrix);
                            if (_mirror)
                            {
                                _loc_13.matrix.m02 = _JointAnimate.animRect.width - _loc_13.matrix.m02 + 2 * _drawTransform.m02;
                                _loc_13.matrix.m01 = -_loc_13.matrix.m01;
                                _loc_13.matrix.m10 = -_loc_13.matrix.m10;
                            }
                            _helpDrawSprite.a = _loc_13.matrix.m00;
                            _helpDrawSprite.b = _loc_13.matrix.m10;
                            _helpDrawSprite.c = _loc_13.matrix.m01;
                            _helpDrawSprite.d = _loc_13.matrix.m11;
                            _helpDrawSprite.tx = _loc_13.matrix.m02;
                            _helpDrawSprite.ty = _loc_13.matrix.m12;
                            if (_loc_21.imageExist)
                            {
                                param1.draw3(_loc_21.texture, _helpDrawSprite, _loc_8.red * 0.00392157, _loc_8.green * 0.00392157, _loc_8.blue * 0.00392157, _loc_8.alpha * 0.00392157, param5 || _loc_20.isAdditive ? (2) : (1));
                            }
                            else if (_listener != null)
                            {
                                _listener.JAnimImageNotExistDraw(_loc_21.name, param1, _helpDrawSprite, _loc_8.red * 0.00392157, _loc_8.green * 0.00392157, _loc_8.blue * 0.00392157, _loc_8.alpha * 0.00392157, param5 || _loc_20.isAdditive ? (2) : (1));
                            }
                            if (_loc_18 == 3)
                            {
                                _loc_19++;
                            }
                        }
                        if (_listener != null && _loc_9.postdrawCallback)
                        {
                            _loc_9.postdrawCallback = _listener.JAnimObjectPostdraw(_id, this, param1, param2, _loc_9, param3, param4);
                        }
                    }
                }
                _loc_16++;
            }
            return;
        }// end function

        private function AnimUpdate(param1:Number) : void
        {
            if (!_animRunning)
            {
                return;
            }
            if (_blendTicksTotal > 0)
            {
                _blendTicksCur = _blendTicksCur + param1;
                if (_blendTicksCur >= _blendTicksTotal)
                {
                    _blendTicksTotal = 0;
                }
            }
            _transDirty = true;
            if (_blendDelay > 0)
            {
                _blendDelay = _blendDelay - param1;
                if (_blendDelay <= 0)
                {
                    _blendDelay = 0;
                    DoFramesHit(_mainSpriteInst, null);
                }
                return;
            }
            IncSpriteInstFrame(_mainSpriteInst, null, param1);
            PrepSpriteInstFrame(_mainSpriteInst, null);
            return;
        }// end function

        private function PrepSpriteInstFrame(param1:JASpriteInst, param2:JAObjectPos) : void
        {
            var _loc_6:* = 0;
            var _loc_10:* = 0;
            var _loc_7:* = null;
            var _loc_11:* = 0;
            var _loc_5:* = null;
            var _loc_8:* = null;
            var _loc_4:* = 0;
            var _loc_3:* = 0;
            var _loc_9:* = param1.spriteDef.frames[param1.frameNum];
            if (param1.onNewFrame)
            {
                if (param1.lastFrameNum < param1.frameNum)
                {
                    _loc_6 = param1.frameNum;
                    _loc_10 = param1.lastFrameNum + 1;
                    while (_loc_10 < _loc_6)
                    {
                        
                        _loc_7 = param1.spriteDef.frames[_loc_10];
                        FrameHit(param1, _loc_7, param2);
                        _loc_10++;
                    }
                }
                FrameHit(param1, _loc_9, param2);
            }
            if (_loc_9.hasStop)
            {
                if (param1 == _mainSpriteInst)
                {
                    _animRunning = false;
                    if (_listener != null)
                    {
                        _listener.JAnimStopped(_id, this);
                    }
                }
                return;
            }
            _loc_11 = 0;
            while (_loc_11 < _loc_9.frameObjectPosVector.length)
            {
                
                _loc_5 = _loc_9.frameObjectPosVector[_loc_11];
                if (_loc_5.isSprite)
                {
                    _loc_8 = param1.children[_loc_5.objectNum].spriteInst;
                    if (_loc_8 != null)
                    {
                        _loc_4 = param1.frameNum + param1.frameRepeats * param1.spriteDef.frames.length;
                        _loc_3 = param1.lastFrameNum + param1.frameRepeats * param1.spriteDef.frames.length;
                        if (_loc_8.lastUpdated != _loc_3 && _loc_8.lastUpdated != _loc_4)
                        {
                            _loc_8.frameNum = 0;
                            _loc_8.lastFrameNum = 0;
                            _loc_8.frameRepeats = 0;
                            _loc_8.delayFrames = 0;
                            _loc_8.onNewFrame = true;
                        }
                        PrepSpriteInstFrame(_loc_8, _loc_5);
                        _loc_8.lastUpdated = _loc_4;
                    }
                }
                _loc_11++;
            }
            return;
        }// end function

        private function IncSpriteInstFrame(param1:JASpriteInst, param2:JAObjectPos, param3:Number) : void
        {
            var _loc_9:* = 0;
            var _loc_4:* = null;
            var _loc_8:* = null;
            var _loc_5:* = param1.frameNum;
            var _loc_7:* = param1.spriteDef.frames[_loc_5];
            if (_loc_7.hasStop)
            {
                return;
            }
            param1.lastFrameNum = param1.frameNum;
            var _loc_6:* = param2 != null ? (param2.timeScale) : (1);
            param1.frameNum = param1.frameNum + param3 * (param1.spriteDef.animRate / 100) / _loc_6;
            if (param1 == _mainSpriteInst)
            {
                if (!param1.spriteDef.frames[(param1.spriteDef.frames.length - 1)].hasStop)
                {
                    if (param1.frameNum >= param1.spriteDef.workAreaStart + param1.spriteDef.workAreaDuration + 1)
                    {
                        (param1.frameRepeats + 1);
                        param1.frameNum = param1.frameNum - (param1.spriteDef.workAreaDuration + 1);
                        param1.lastFrameNum = param1.frameNum;
                    }
                }
                else if (param1.frameNum >= param1.spriteDef.workAreaStart + param1.spriteDef.workAreaDuration)
                {
                    param1.onNewFrame = true;
                    param1.frameNum = param1.spriteDef.workAreaStart + param1.spriteDef.workAreaDuration;
                    param1.lastFrameNum = param1.frameNum;
                    if (param1.spriteDef.workAreaDuration != 0)
                    {
                        _animRunning = false;
                        if (_listener != null)
                        {
                            _listener.JAnimStopped(_id, this);
                        }
                        return;
                    }
                    (param1.frameRepeats + 1);
                }
            }
            else if (param1.frameNum >= param1.spriteDef.frames.length)
            {
                (param1.frameRepeats + 1);
                param1.frameNum = param1.frameNum - param1.spriteDef.frames.length;
            }
            param1.onNewFrame = param1.frameNum != _loc_5;
            if (param1.onNewFrame && param1.delayFrames > 0)
            {
                param1.onNewFrame = false;
                param1.frameNum = _loc_5;
                param1.lastFrameNum = param1.frameNum;
                (param1.delayFrames - 1);
                return;
            }
            _loc_9 = 0;
            while (_loc_9 < _loc_7.frameObjectPosVector.length)
            {
                
                _loc_4 = _loc_7.frameObjectPosVector[_loc_9];
                if (_loc_4.isSprite)
                {
                    _loc_8 = param1.children[_loc_4.objectNum].spriteInst;
                    IncSpriteInstFrame(_loc_8, _loc_4, param3 / _loc_6);
                }
                _loc_9++;
            }
            return;
        }// end function

        private function DoFramesHit(param1:JASpriteInst, param2:JAObjectPos) : void
        {
            var _loc_6:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = param1.spriteDef.frames[param1.frameNum];
            FrameHit(param1, _loc_5, param2);
            _loc_6 = 0;
            while (_loc_6 < _loc_5.frameObjectPosVector.length)
            {
                
                _loc_3 = _loc_5.frameObjectPosVector[_loc_6];
                if (_loc_3.isSprite)
                {
                    _loc_4 = param1.children[_loc_3.objectNum].spriteInst;
                    if (_loc_4 != null)
                    {
                        DoFramesHit(_loc_4, _loc_3);
                    }
                }
                _loc_6++;
            }
            return;
        }// end function

        private function FrameHit(param1:JASpriteInst, param2:JAFrame, param3:JAObjectPos) : void
        {
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_8:* = null;
            var _loc_18:* = 0;
            var _loc_16:* = 0;
            var _loc_6:* = 0;
            var _loc_4:* = null;
            var _loc_7:* = false;
            var _loc_17:* = 0;
            var _loc_11:* = 0;
            var _loc_10:* = null;
            var _loc_20:* = 0;
            var _loc_19:* = null;
            var _loc_5:* = 0;
            var _loc_12:* = NaN;
            var _loc_15:* = NaN;
            var _loc_9:* = null;
            param1.onNewFrame = false;
            _loc_13 = 0;
            while (_loc_13 < param2.frameObjectPosVector.length)
            {
                
                _loc_14 = param2.frameObjectPosVector[_loc_13];
                if (_loc_14.isSprite)
                {
                    _loc_8 = param1.children[_loc_14.objectNum].spriteInst;
                    if (_loc_8 != null)
                    {
                        _loc_18 = 0;
                        while (_loc_18 < _loc_14.preloadFrames)
                        {
                            
                            IncSpriteInstFrame(_loc_8, _loc_14, 100 / param1.spriteDef.animRate);
                            _loc_18++;
                        }
                    }
                }
                _loc_13++;
            }
            _loc_11 = 0;
            while (_loc_11 < param2.commandVector.length)
            {
                
                _loc_10 = param2.commandVector[_loc_11];
                if (_listener == null || !_listener.JAnimCommand(_id, this, param1, _loc_10.command, _loc_10.param))
                {
                    if (_loc_10.command == "delay")
                    {
                        _loc_6 = _loc_10.param.indexOf(",");
                        if (_loc_6 != -1)
                        {
                            _loc_16 = _loc_10.param.substr(0, _loc_6);
                            _loc_20 = _loc_10.param.substr((_loc_6 + 1));
                            if (_loc_20 <= _loc_16)
                            {
                                _loc_20 = _loc_16 + 1;
                            }
                            param1.delayFrames = _loc_16 + Math.random() * 100000 % (_loc_20 - _loc_16);
                        }
                        else
                        {
                            _loc_16 = _loc_10.param;
                            param1.delayFrames = _loc_16;
                        }
                    }
                    else if (_loc_10.command == "playsample")
                    {
                        _loc_19 = _loc_10.param;
                        _loc_5 = 0;
                        _loc_12 = 1;
                        _loc_15 = 0;
                        _loc_7 = true;
                        while (_loc_19.length > 0)
                        {
                            
                            _loc_6 = _loc_19.indexOf(",");
                            if (_loc_6 == -1)
                            {
                                _loc_4 = _loc_19;
                            }
                            else
                            {
                                _loc_4 = _loc_19.substr(0, _loc_6);
                            }
                            if (_loc_7)
                            {
                                _loc_9 = _loc_4;
                                _loc_7 = false;
                            }
                            else
                            {
                                do
                                {
                                    
                                    _loc_4 = _loc_4.substr(0, _loc_17) + _loc_4.substr((_loc_17 + 1));
                                    _loc_17 = _loc_4.indexOf(" ");
                                }while (_loc_4.indexOf(" ") != -1)
                                if (_loc_4.substr(0, 7) == "volume=")
                                {
                                    _loc_12 = _loc_4.substr(7);
                                }
                                else if (_loc_4.substr(0, 4) == "pan=")
                                {
                                    _loc_5 = _loc_4.substr(4);
                                }
                                else if (_loc_4.substr(0, 6) == "steps=")
                                {
                                    _loc_15 = _loc_4.substr(6);
                                }
                            }
                            if (_loc_6 != -1)
                            {
                                _loc_19 = _loc_19.substr((_loc_6 + 1));
                            }
                        }
                        if (_listener != null)
                        {
                            _listener.JAnimPLaySample(_loc_9, _loc_5, _loc_12, _loc_15);
                        }
                    }
                }
                _loc_11++;
            }
            return;
        }// end function

        private function UpdateTransforms(param1:JASpriteInst, param2:JATransform, param3:JAColor, param4:Boolean) : void
        {
            var _loc_9:* = 0;
            var _loc_6:* = null;
            if (param2)
            {
                param1.curTransform.clone(param2);
            }
            else
            {
                param1.curTransform.matrix.clone(_drawTransform);
            }
            if (param1.curColor == null)
            {
                param1.curColor = new JAColor();
            }
            param1.curColor.clone(param3);
            var _loc_5:* = param1.spriteDef.frames[param1.frameNum];
            var _loc_7:* = _helpCallTransform[_helpCallDepth];
            var _loc_8:* = _helpCallColor[_helpCallDepth];
            (_helpCallDepth + 1);
            var _loc_10:* = param4 || param1.delayFrames > 0 || _loc_5.hasStop;
            _loc_9 = 0;
            while (_loc_9 < _loc_5.frameObjectPosVector.length)
            {
                
                _loc_6 = _loc_5.frameObjectPosVector[_loc_9];
                if (_loc_6.isSprite)
                {
                    CalcObjectPos(param1, _loc_9, _loc_10);
                    _loc_7 = _helpCalcTransform;
                    _loc_8 = _helpCalcColor;
                    _helpCalcTransform = null;
                    _helpCalcColor = null;
                    if (param2 != null)
                    {
                        _loc_7 = param2.TransformSrc(_loc_7, _loc_7);
                    }
                    UpdateTransforms(param1.children[_loc_6.objectNum].spriteInst, _loc_7, _loc_8, _loc_10);
                }
                _loc_9++;
            }
            return;
        }// end function

        private function CalcObjectPos(param1:JASpriteInst, param2:int, param3:Boolean) : void
        {
            var _loc_17:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_10:* = 0;
            var _loc_19:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = NaN;
            var _loc_18:* = false;
            var _loc_11:* = param1.spriteDef.frames[param1.frameNum];
            var _loc_12:* = _loc_11.frameObjectPosVector[param2];
            var _loc_5:* = param1.children[_loc_12.objectNum];
            _helpANextObjectPos[0] = null;
            _helpANextObjectPos[1] = null;
            _helpANextObjectPos[2] = null;
            var _loc_14:* = param1.spriteDef.frames.length - 1;
            var _loc_16:* = 1;
            var _loc_13:* = 2;
            if (param1 == _mainSpriteInst && param1.frameNum >= param1.spriteDef.workAreaStart)
            {
                _loc_14 = param1.spriteDef.workAreaDuration - 1;
            }
            var _loc_15:* = _helpCallTransform[_helpCallDepth];
            var _loc_4:* = _helpCallColor[_helpCallDepth];
            (_helpCallDepth + 1);
            if (_interpolate && !param3)
            {
                _loc_10 = 0;
                while (_loc_10 < 3)
                {
                    
                    _loc_19 = param1.spriteDef.frames[(param1.frameNum + (_loc_10 == 0 ? (_loc_14) : (_loc_10 == 1 ? (_loc_16) : (_loc_13)))) % param1.spriteDef.frames.length];
                    if (param1 == _mainSpriteInst && param1.frameNum >= param1.spriteDef.workAreaStart)
                    {
                        _loc_19 = param1.spriteDef.frames[(param1.frameNum + (_loc_10 == 0 ? (_loc_14) : (_loc_10 == 1 ? (_loc_16) : (_loc_13))) - param1.spriteDef.workAreaStart) % (param1.spriteDef.workAreaDuration + 1) + param1.spriteDef.workAreaStart];
                    }
                    else
                    {
                        _loc_19 = param1.spriteDef.frames[(param1.frameNum + (_loc_10 == 0 ? (_loc_14) : (_loc_10 == 1 ? (_loc_16) : (_loc_13)))) % param1.spriteDef.frames.length];
                    }
                    if (_loc_11.hasStop)
                    {
                        _loc_19 = _loc_11;
                    }
                    if (_loc_19.frameObjectPosVector.length > param2)
                    {
                        _helpANextObjectPos[_loc_10] = _loc_19.frameObjectPosVector[param2];
                        if (_helpANextObjectPos[_loc_10].objectNum != _loc_12.objectNum)
                        {
                            _helpANextObjectPos[_loc_10] = null;
                        }
                    }
                    if (_helpANextObjectPos[_loc_10] == null)
                    {
                        _loc_8 = 0;
                        while (_loc_8 < _loc_19.frameObjectPosVector.length)
                        {
                            
                            if (_loc_19.frameObjectPosVector[_loc_8].objectNum == _loc_12.objectNum)
                            {
                                _helpANextObjectPos[_loc_10] = _loc_19.frameObjectPosVector[_loc_8];
                                break;
                            }
                            _loc_8++;
                        }
                    }
                    _loc_10++;
                }
                if (_helpANextObjectPos[1] != null)
                {
                    _loc_9 = param1.frameNum - Math.floor(param1.frameNum);
                    _loc_18 = false;
                    _loc_15 = _loc_12.transform.InterpolateTo(_helpANextObjectPos[1].transform, _loc_9, _loc_15);
                    _loc_4.Set(_loc_12.color.red * (1 - _loc_9) + _helpANextObjectPos[1].color.red * _loc_9 + 0.5, _loc_12.color.green * (1 - _loc_9) + _helpANextObjectPos[1].color.green * _loc_9 + 0.5, _loc_12.color.blue * (1 - _loc_9) + _helpANextObjectPos[1].color.blue * _loc_9 + 0.5, _loc_12.color.alpha * (1 - _loc_9) + _helpANextObjectPos[1].color.alpha * _loc_9 + 0.5);
                }
                else
                {
                    _loc_15.clone(_loc_12.transform);
                    _loc_4.clone(_loc_12.color);
                }
            }
            else
            {
                _loc_15.clone(_loc_12.transform);
                _loc_4.clone(_loc_12.color);
            }
            _loc_15.matrix = JAMatrix3.MulJAMatrix3(_loc_5.transform, _loc_15.matrix, _loc_15.matrix);
            if (_loc_5.isBlending && _blendTicksTotal != 0 && param1 == _mainSpriteInst)
            {
                _loc_9 = _blendTicksCur / _blendTicksTotal;
                _loc_15 = _loc_5.blendSrcTransform.InterpolateTo(_loc_15, _loc_9, _loc_15);
                _loc_4.Set(_loc_5.blendSrcColor.red * (1 - _loc_9) + _loc_4.red * _loc_9 + 0.5, _loc_5.blendSrcColor.green * (1 - _loc_9) + _loc_4.green * _loc_9 + 0.5, _loc_5.blendSrcColor.blue * (1 - _loc_9) + _loc_4.blue * _loc_9 + 0.5, _loc_5.blendSrcColor.alpha * (1 - _loc_9) + _loc_4.alpha * _loc_9 + 0.5);
            }
            _helpCalcTransform = _loc_15;
            _helpCalcColor = _loc_4;
            _helpANextObjectPos[0] = null;
            _helpANextObjectPos[1] = null;
            _helpANextObjectPos[2] = null;
            return;
        }// end function

        private function InitSpriteInst(param1:JASpriteInst, param2:JASpriteDef) : void
        {
            var _loc_7:* = 0;
            var _loc_6:* = null;
            var _loc_5:* = null;
            var _loc_4:* = null;
            var _loc_3:* = null;
            param1.frameRepeats = 0;
            param1.delayFrames = 0;
            param1.spriteDef = param2;
            param1.lastUpdated = -1;
            param1.onNewFrame = true;
            param1.frameNum = 0;
            param1.lastFrameNum = 0;
            param1.children.splice(0, param1.children.length);
            param1.children.length = param2.objectDefVector.length;
            _loc_7 = 0;
            while (_loc_7 < param2.objectDefVector.length)
            {
                
                param1.children[_loc_7] = new JAObjectInst();
                _loc_7++;
            }
            _loc_7 = 0;
            while (_loc_7 < param2.objectDefVector.length)
            {
                
                _loc_6 = param2.objectDefVector[_loc_7];
                _loc_5 = param1.children[_loc_7];
                _loc_5.colorMult = new JAColor();
                _loc_5.colorMult.clone(JAColor.White);
                _loc_5.name = _loc_6.name;
                _loc_5.isBlending = false;
                _loc_4 = _loc_6.spriteDef;
                if (_loc_4 != null)
                {
                    _loc_3 = new JASpriteInst();
                    _loc_3.parent = param1;
                    InitSpriteInst(_loc_3, _loc_4);
                    _loc_5.spriteInst = _loc_3;
                }
                _loc_7++;
            }
            if (param1 == _mainSpriteInst)
            {
                GetToFirstFrame();
            }
            return;
        }// end function

        private function ResetAnimHelper(param1:JASpriteInst) : void
        {
            var _loc_3:* = 0;
            var _loc_2:* = null;
            param1.frameNum = 0;
            param1.lastFrameNum = 0;
            param1.frameRepeats = 0;
            param1.delayFrames = 0;
            param1.lastUpdated = -1;
            param1.onNewFrame = true;
            _loc_3 = 0;
            while (_loc_3 < param1.children.length)
            {
                
                _loc_2 = param1.children[_loc_3].spriteInst;
                if (_loc_2 != null)
                {
                    ResetAnimHelper(_loc_2);
                }
                _loc_3++;
            }
            _transDirty = true;
            return;
        }// end function

        public static function HelpCallInitialize() : void
        {
            var _loc_1:* = 0;
            if (!bInit)
            {
                _helpCallTransform.fixed = true;
                _helpCallColor.fixed = true;
                _loc_1 = 0;
                while (_loc_1 < 1000)
                {
                    
                    _helpCallTransform[_loc_1] = new JATransform();
                    _helpCallColor[_loc_1] = new JAColor();
                    _loc_1++;
                }
                bInit = true;
            }
            return;
        }// end function

    }
}
