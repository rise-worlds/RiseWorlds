package com.flengine.components.renderables.jointanim
{
   import com.flengine.components.renderables.FRenderable;
   import flash.geom.Rectangle;
   import flash.geom.Matrix3D;
   import flash.geom.Matrix;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import com.flengine.components.renderables.JAMemoryImage;
   import com.flengine.core.FNode;
   
   public class JAnim extends FRenderable
   {
      
      public function JAnim(param1:FNode, param2:JointAnimate, param3:int, param4:JAnimListener = null) {
         _helpGetTransformedVertices3DVector = new Vector.<Number>();
         super(param1);
         if(param2 == null)
         {
            throw new Error("Joint Animate is null!");
         }
         else
         {
            _inNode = !(param1 == null);
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
         }
      }
      
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
      
      private static const NORMALIZED_VERTICES_3D:Vector.<Number> = Vector.<Number>([-0.5,0.5,0,-0.5,-0.5,0,0.5,-0.5,0,0.5,0.5,0]);
      
      private static var _helpMatrix3DVector1:Vector.<Number> = Vector.<Number>([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]);
      
      private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
      
      private static var _helpJAnimRender:JATransform2D = new JATransform2D();
      
      private static var _helpJAnimRenderVector:Vector.<Number> = new Vector.<Number>(16);
      
      private static var bInit:Boolean = false;
      
      public static function HelpCallInitialize() : void {
         var _loc1_:* = 0;
         if(!bInit)
         {
            _helpCallTransform.fixed = true;
            _helpCallColor.fixed = true;
            _loc1_ = 0;
            while(_loc1_ < 1000)
            {
               _helpCallTransform[_loc1_] = new JATransform();
               _helpCallColor[_loc1_] = new JAColor();
               _loc1_++;
            }
            bInit = true;
         }
      }
      
      private static var _helpDrawSprite:Matrix = new Matrix();
      
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
      
      override public function dispose() : void {
         super.dispose();
         _color = null;
         _transform = null;
         _mainSpriteInst.Dispose();
         _JointAnimate = null;
      }
      
      override public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean {
         return false;
      }
      
      override public function getWorldBounds(param1:Rectangle = null) : Rectangle {
         var _loc4_:* = 0;
         var _loc2_:Vector.<Number> = getTransformedVertices3D();
         if(param1)
         {
            param1.setTo(_loc2_[0],_loc2_[1],0,0);
         }
         else
         {
            param1 = new Rectangle(_loc2_[0],_loc2_[1],0,0);
         }
         var _loc3_:int = _loc2_.length;
         _loc4_ = 3;
         while(_loc4_ < _loc3_)
         {
            if(param1.left > _loc2_[_loc4_])
            {
               param1.left = _loc2_[_loc4_];
            }
            if(param1.right < _loc2_[_loc4_])
            {
               param1.right = _loc2_[_loc4_];
            }
            if(param1.top > _loc2_[_loc4_ + 1])
            {
               param1.top = _loc2_[_loc4_ + 1];
            }
            if(param1.bottom < _loc2_[_loc4_ + 1])
            {
               param1.bottom = _loc2_[_loc4_ + 1];
            }
            _loc4_ = _loc4_ + 3;
         }
         return param1;
      }
      
      private var _helpGetTransformedVertices3DVector:Vector.<Number>;
      
      private function getTransformedVertices3D() : Vector.<Number> {
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
         _helpGetTransformedVertices3DTransformMatrix.transformVectors(NORMALIZED_VERTICES_3D,_helpGetTransformedVertices3DVector);
         return _helpGetTransformedVertices3DVector;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(_inNode)
         {
            _drawTransform = JAMatrix3.MulJAMatrix3_M3D(cNode.cTransform.worldTransformMatrix,_transform,_helpJAnimRender);
         }
         else
         {
            _drawTransform = _transform;
         }
         Draw(param1);
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         if(_inNode)
         {
            _drawTransform = JAMatrix3.MulJAMatrix3_M3D(cNode.cTransform.worldTransformMatrix,_transform,_helpJAnimRender);
         }
         else
         {
            _drawTransform = _transform;
         }
         Update(param1 * 0.1);
      }
      
      public function get transform() : JATransform2D {
         return _transform;
      }
      
      public function get lastPlayedLabel() : String {
         return _lastPlayedFrameLabel;
      }
      
      public function get interpolate() : Boolean {
         return _interpolate;
      }
      
      public function set interpolate(param1:Boolean) : void {
         _interpolate = param1;
      }
      
      public function set mirror(param1:Boolean) : void {
         _mirror = param1;
      }
      
      public function get mirror() : Boolean {
         return _mirror;
      }
      
      public function set additive(param1:Boolean) : void {
         _additive = param1;
      }
      
      public function get additive() : Boolean {
         return _additive;
      }
      
      public function set color(param1:uint) : void {
         _color.alpha = param1 >> 24 & 255;
         _color.red = param1 >> 16 & 255;
         _color.green = param1 >> 8 & 255;
         _color.blue = param1 & 255;
      }
      
      public function get color() : uint {
         return _color.toInt();
      }
      
      public function get mainSpriteInst() : JASpriteInst {
         return _mainSpriteInst;
      }
      
      public function IsActive() : Boolean {
         if(_animRunning)
         {
            return true;
         }
         return false;
      }
      
      public function GetToFirstFrame() : void {
         var _loc1_:* = false;
         var _loc2_:* = false;
         while(!(_mainSpriteInst.spriteDef == null) && _mainSpriteInst.frameNum < _mainSpriteInst.spriteDef.workAreaStart)
         {
            _loc1_ = _animRunning;
            _loc2_ = _paused;
            _animRunning = true;
            _paused = false;
            Update(0);
            _animRunning = _loc1_;
            _paused = _loc2_;
         }
      }
      
      public function ResetAnim() : void {
         ResetAnimHelper(_mainSpriteInst);
         _animRunning = false;
         GetToFirstFrame();
         _blendTicksTotal = 0;
         _blendTicksCur = 0;
         _blendDelay = 0;
      }
      
      public function SetupSpriteInst(param1:String = "") : Boolean {
         var _loc4_:* = 0;
         if(_mainSpriteInst == null)
         {
            return false;
         }
         if(!(_mainSpriteInst.spriteDef == null) && param1 == "")
         {
            return true;
         }
         if(_JointAnimate.mainAnimDef.mainSpriteDef != null)
         {
            InitSpriteInst(_mainSpriteInst,_JointAnimate.mainAnimDef.mainSpriteDef);
            return true;
         }
         if(_JointAnimate.mainAnimDef.spriteDefVector.length == 0)
         {
            return false;
         }
         var _loc3_:* = param1;
         if(_loc3_.length == 0)
         {
            _loc3_ = "main";
         }
         var _loc2_:JASpriteDef = null;
         _loc4_ = 0;
         while(_loc4_ < _JointAnimate.mainAnimDef.spriteDefVector.length)
         {
            if(!(_JointAnimate.mainAnimDef.spriteDefVector[_loc4_].name == null) && _JointAnimate.mainAnimDef.spriteDefVector[_loc4_].name == _loc3_)
            {
               _loc2_ = _JointAnimate.mainAnimDef.spriteDefVector[_loc4_];
               _lastPlayedFrameLabel = _loc3_;
               break;
            }
            _loc4_++;
         }
         if(_loc2_ == null)
         {
            _loc2_ = _JointAnimate.mainAnimDef.spriteDefVector[0];
         }
         if(_loc2_ != _mainSpriteInst.spriteDef)
         {
            if(_mainSpriteInst.spriteDef != null)
            {
               _mainSpriteInst.Reset();
               _mainSpriteInst.parent = null;
            }
            InitSpriteInst(_mainSpriteInst,_loc2_);
            _transDirty = true;
         }
         return true;
      }
      
      public function Play(param1:String, param2:Boolean = true) : Boolean {
         var _loc3_:* = 0;
         _animRunning = false;
         if(_JointAnimate.mainAnimDef.mainSpriteDef)
         {
            if(!SetupSpriteInst())
            {
               return false;
            }
            _loc3_ = _JointAnimate.mainAnimDef.mainSpriteDef.GetLabelFrame(param1);
            if(_loc3_ == -1)
            {
               return false;
            }
            _lastPlayedFrameLabel = param1;
            return PlayIndex(_loc3_,param2);
         }
         _lastPlayedFrameLabel = param1;
         SetupSpriteInst(param1);
         return PlayIndex(_mainSpriteInst.spriteDef.workAreaStart,param2);
      }
      
      public function PlayIndex(param1:int = 0, param2:Boolean = true) : Boolean {
         if(!SetupSpriteInst())
         {
            return false;
         }
         if(param1 >= _mainSpriteInst.spriteDef.frames.length)
         {
            _animRunning = false;
            return false;
         }
         if(!(_mainSpriteInst.frameNum == (param1)) && param2)
         {
            ResetAnim();
         }
         _paused = false;
         _animRunning = true;
         _mainSpriteInst.delayFrames = 0;
         _mainSpriteInst.frameNum = param1;
         _mainSpriteInst.lastFrameNum = param1;
         _mainSpriteInst.frameRepeats = 0;
         if(_blendDelay == 0)
         {
            DoFramesHit(_mainSpriteInst,null);
         }
         return true;
      }
      
      public function Update(param1:Number) : void {
         if(!SetupSpriteInst())
         {
            return;
         }
         UpdateF(param1);
      }
      
      private function UpdateF(param1:Number) : void {
         if(_paused)
         {
            return;
         }
         AnimUpdate(param1);
      }
      
      public function Draw(param1:FContext) : void {
         if(!SetupSpriteInst())
         {
            return;
         }
         _helpCallDepth = 0;
         if(!_inNode)
         {
            _drawTransform = _transform;
         }
         if(_transDirty)
         {
            UpdateTransforms(_mainSpriteInst,null,_color,false);
            _transDirty = false;
         }
         DrawSprite(param1,_mainSpriteInst,null,_color,_additive,false);
      }
      
      private function DrawSprite(param1:FContext, param2:JASpriteInst, param3:JATransform, param4:JAColor, param5:Boolean, param6:Boolean) : void {
         var _loc7_:* = null;
         var _loc16_:* = 0;
         var _loc20_:* = null;
         var _loc9_:* = null;
         var _loc24_:* = null;
         var _loc8_:* = null;
         var _loc19_:* = 0;
         var _loc11_:* = null;
         var _loc13_:* = null;
         var _loc21_:* = null;
         var _loc23_:* = null;
         var _loc12_:* = NaN;
         var _loc14_:* = NaN;
         var _loc18_:* = 0;
         var _loc17_:JAFrame = param2.spriteDef.frames[param2.frameNum];
         var _loc22_:JATransform = _helpCallTransform[_helpCallDepth];
         var _loc10_:JAColor = _helpCallColor[_helpCallDepth];
         _helpCallDepth = _helpCallDepth + 1;
         var _loc15_:Boolean = param6 || param2.delayFrames > 0 || _loc17_.hasStop;
         _loc16_ = 0;
         while(_loc16_ < _loc17_.frameObjectPosVector.length)
         {
            _loc20_ = _loc17_.frameObjectPosVector[_loc16_];
            _loc9_ = param2.children[_loc20_.objectNum];
            if(!(_listener == null) && _loc9_.predrawCallback)
            {
               _loc9_.predrawCallback = _listener.JAnimObjectPredraw(_id,this,param1,param2,_loc9_,param3,param4);
            }
            if(_loc20_.isSprite)
            {
               _loc7_ = param2.children[_loc20_.objectNum].spriteInst;
               _loc10_.clone(_loc7_.curColor);
               _loc22_.clone(_loc7_.curTransform);
            }
            else
            {
               CalcObjectPos(param2,_loc16_,_loc15_);
               _loc22_ = _helpCalcTransform;
               _loc10_ = _helpCalcColor;
               _helpCalcTransform = null;
               _helpCalcColor = null;
            }
            if(param3 == null && !(_JointAnimate.drawScale == 1))
            {
               _helpTransform.matrix.LoadIdentity();
               _helpTransform.matrix.m00 = _JointAnimate.drawScale;
               _helpTransform.matrix.m11 = _JointAnimate.drawScale;
               _helpTransform.matrix = JAMatrix3.MulJAMatrix3(_drawTransform,_helpTransform.matrix,_helpTransform.matrix);
               _loc24_ = _helpTransform.TransformSrc(_loc22_,_loc22_);
            }
            else if(param3 == null || _loc20_.isSprite)
            {
               _loc24_ = _loc22_;
               if(_JointAnimate.drawScale != 1)
               {
                  _helpTransform.matrix.LoadIdentity();
                  _helpTransform.matrix.m00 = _JointAnimate.drawScale;
                  _helpTransform.matrix.m11 = _JointAnimate.drawScale;
                  _loc24_.matrix = JAMatrix3.MulJAMatrix3(_helpTransform.matrix,_loc24_.matrix,_loc24_.matrix);
               }
               _loc24_.matrix = JAMatrix3.MulJAMatrix3(_drawTransform,_loc24_.matrix,_loc24_.matrix);
            }
            else
            {
               _loc24_ = param3.TransformSrc(_loc22_,_loc22_);
            }
            
            _loc8_ = _helpCallColor[_helpCallDepth];
            _helpCallDepth = _helpCallDepth + 1;
            _loc8_.Set(_loc10_.red * param4.red * _loc9_.colorMult.red / 65025,_loc10_.green * param4.green * _loc9_.colorMult.green / 65025,_loc10_.blue * param4.blue * _loc9_.colorMult.blue / 65025,_loc10_.alpha * param4.alpha * _loc9_.colorMult.alpha / 65025);
            if(_loc8_.alpha != 0)
            {
               if(_loc20_.isSprite)
               {
                  _loc7_ = param2.children[_loc20_.objectNum].spriteInst;
                  DrawSprite(param1,_loc7_,_loc24_,_loc8_,_loc20_.isAdditive || param5,_loc15_);
               }
               else
               {
                  _loc19_ = 0;
                  while(true)
                  {
                     _loc11_ = _JointAnimate.imageVector[_loc20_.resNum];
                     _loc13_ = _loc24_.TransformSrc(_loc11_.transform,_loc24_);
                     _loc23_ = _helpDrawSpriteASrcRect;
                     if(_loc20_.animFrameNum == 0 || _loc11_.images.length == 1)
                     {
                        _loc21_ = _loc11_.images[0];
                        _loc21_.GetCelRect(_loc20_.animFrameNum,_loc23_);
                     }
                     else
                     {
                        _loc21_ = _loc11_.images[_loc20_.animFrameNum];
                        _loc21_.GetCelRect(0,_loc23_);
                     }
                     if(_loc20_.hasSrcRect)
                     {
                        _loc23_ = _loc20_.srcRect;
                     }
                     if(_JointAnimate.imgScale != 1)
                     {
                        _loc12_ = _loc13_.matrix.m02;
                        _loc14_ = _loc13_.matrix.m12;
                        _helpTransform.matrix.LoadIdentity();
                        _helpTransform.matrix.m00 = 1 / _JointAnimate.imgScale;
                        _helpTransform.matrix.m11 = 1 / _JointAnimate.imgScale;
                        _loc13_ = _helpTransform.TransformSrc(_loc13_,_loc13_);
                        _loc13_.matrix.m02 = _loc12_;
                        _loc13_.matrix.m12 = _loc14_;
                     }
                     _loc18_ = 0;
                     if(!(_listener == null) && _loc9_.imagePredrawCallback)
                     {
                        _loc18_ = _listener.JAnimImagePredraw(param2,_loc9_,_loc13_,_loc21_,param1,_loc19_);
                        if(_loc18_ == 0)
                        {
                           _loc9_.imagePredrawCallback = false;
                        }
                        if(_loc18_ == 2)
                        {
                           break;
                        }
                        break;
                     }
                     _helpTransform.matrix.LoadIdentity();
                     _helpTransform.matrix.m02 = _loc23_.width / 2;
                     _helpTransform.matrix.m12 = _loc23_.height / 2;
                     if(_mirror)
                     {
                        _helpTransform.matrix.m00 = -1;
                     }
                     _loc13_.matrix = JAMatrix3.MulJAMatrix3(_loc13_.matrix,_helpTransform.matrix,_loc13_.matrix);
                     if(_mirror)
                     {
                        _loc13_.matrix.m02 = _JointAnimate.animRect.width - _loc13_.matrix.m02 + 2 * _drawTransform.m02;
                        _loc13_.matrix.m01 = -_loc13_.matrix.m01;
                        _loc13_.matrix.m10 = -_loc13_.matrix.m10;
                     }
                     _helpDrawSprite.a = _loc13_.matrix.m00;
                     _helpDrawSprite.b = _loc13_.matrix.m10;
                     _helpDrawSprite.c = _loc13_.matrix.m01;
                     _helpDrawSprite.d = _loc13_.matrix.m11;
                     _helpDrawSprite.tx = _loc13_.matrix.m02;
                     _helpDrawSprite.ty = _loc13_.matrix.m12;
                     if(_loc21_.imageExist)
                     {
                        param1.draw3(_loc21_.texture,_helpDrawSprite,_loc8_.red * 0.003921568627451,_loc8_.green * 0.003921568627451,_loc8_.blue * 0.003921568627451,_loc8_.alpha * 0.003921568627451,param5 || _loc20_.isAdditive?2:1);
                     }
                     else if(_listener != null)
                     {
                        _listener.JAnimImageNotExistDraw(_loc21_.name,param1,_helpDrawSprite,_loc8_.red * 0.003921568627451,_loc8_.green * 0.003921568627451,_loc8_.blue * 0.003921568627451,_loc8_.alpha * 0.003921568627451,param5 || _loc20_.isAdditive?2:1);
                     }
                     
                     if(_loc18_ == 3)
                     {
                        _loc19_++;
                        continue;
                     }
                     break;
                  }
                  if(!(_listener == null) && _loc9_.postdrawCallback)
                  {
                     _loc9_.postdrawCallback = _listener.JAnimObjectPostdraw(_id,this,param1,param2,_loc9_,param3,param4);
                  }
               }
            }
            _loc16_++;
         }
      }
      
      private function AnimUpdate(param1:Number) : void {
         if(!_animRunning)
         {
            return;
         }
         if(_blendTicksTotal > 0)
         {
            _blendTicksCur = _blendTicksCur + param1;
            if(_blendTicksCur >= _blendTicksTotal)
            {
               _blendTicksTotal = 0;
            }
         }
         _transDirty = true;
         if(_blendDelay > 0)
         {
            _blendDelay = _blendDelay - param1;
            if(_blendDelay <= 0)
            {
               _blendDelay = 0;
               DoFramesHit(_mainSpriteInst,null);
            }
            return;
         }
         IncSpriteInstFrame(_mainSpriteInst,null,param1);
         PrepSpriteInstFrame(_mainSpriteInst,null);
      }
      
      private function PrepSpriteInstFrame(param1:JASpriteInst, param2:JAObjectPos) : void {
         var _loc6_:* = 0;
         var _loc10_:* = 0;
         var _loc7_:* = null;
         var _loc11_:* = 0;
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc9_:JAFrame = param1.spriteDef.frames[param1.frameNum];
         if(param1.onNewFrame)
         {
            if(param1.lastFrameNum < param1.frameNum)
            {
               _loc6_ = param1.frameNum;
               _loc10_ = (param1.lastFrameNum) + 1;
               while(_loc10_ < _loc6_)
               {
                  _loc7_ = param1.spriteDef.frames[_loc10_];
                  FrameHit(param1,_loc7_,param2);
                  _loc10_++;
               }
            }
            FrameHit(param1,_loc9_,param2);
         }
         if(_loc9_.hasStop)
         {
            if(param1 == _mainSpriteInst)
            {
               _animRunning = false;
               if(_listener != null)
               {
                  _listener.JAnimStopped(_id,this);
               }
            }
            return;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc9_.frameObjectPosVector.length)
         {
            _loc5_ = _loc9_.frameObjectPosVector[_loc11_];
            if(_loc5_.isSprite)
            {
               _loc8_ = param1.children[_loc5_.objectNum].spriteInst;
               if(_loc8_ != null)
               {
                  _loc4_ = (param1.frameNum) + param1.frameRepeats * param1.spriteDef.frames.length;
                  _loc3_ = (param1.lastFrameNum) + param1.frameRepeats * param1.spriteDef.frames.length;
                  if(!(_loc8_.lastUpdated == _loc3_) && !(_loc8_.lastUpdated == _loc4_))
                  {
                     _loc8_.frameNum = 0;
                     _loc8_.lastFrameNum = 0;
                     _loc8_.frameRepeats = 0;
                     _loc8_.delayFrames = 0;
                     _loc8_.onNewFrame = true;
                  }
                  PrepSpriteInstFrame(_loc8_,_loc5_);
                  _loc8_.lastUpdated = _loc4_;
               }
            }
            _loc11_++;
         }
      }
      
      private function IncSpriteInstFrame(param1:JASpriteInst, param2:JAObjectPos, param3:Number) : void {
         var _loc9_:* = 0;
         var _loc4_:* = null;
         var _loc8_:* = null;
         var _loc5_:int = param1.frameNum;
         var _loc7_:JAFrame = param1.spriteDef.frames[_loc5_];
         if(_loc7_.hasStop)
         {
            return;
         }
         param1.lastFrameNum = param1.frameNum;
         var _loc6_:Number = param2 != null?param2.timeScale:1;
         param1.frameNum = param1.frameNum + param3 * param1.spriteDef.animRate / 100 / _loc6_;
         if(param1 == _mainSpriteInst)
         {
            if(!param1.spriteDef.frames[param1.spriteDef.frames.length - 1].hasStop)
            {
               if((param1.frameNum) >= param1.spriteDef.workAreaStart + param1.spriteDef.workAreaDuration + 1)
               {
                  param1.frameRepeats++;
                  param1.frameNum = param1.frameNum - (param1.spriteDef.workAreaDuration + 1);
                  param1.lastFrameNum = param1.frameNum;
               }
            }
            else if((param1.frameNum) >= param1.spriteDef.workAreaStart + param1.spriteDef.workAreaDuration)
            {
               param1.onNewFrame = true;
               param1.frameNum = param1.spriteDef.workAreaStart + param1.spriteDef.workAreaDuration;
               param1.lastFrameNum = param1.frameNum;
               if(param1.spriteDef.workAreaDuration != 0)
               {
                  _animRunning = false;
                  if(_listener != null)
                  {
                     _listener.JAnimStopped(_id,this);
                  }
                  return;
               }
               param1.frameRepeats++;
            }
            
         }
         else if((param1.frameNum) >= param1.spriteDef.frames.length)
         {
            param1.frameRepeats++;
            param1.frameNum = param1.frameNum - (param1.spriteDef.frames.length);
         }
         
         param1.onNewFrame = !((param1.frameNum) == _loc5_);
         if(param1.onNewFrame && param1.delayFrames > 0)
         {
            param1.onNewFrame = false;
            param1.frameNum = _loc5_;
            param1.lastFrameNum = param1.frameNum;
            param1.delayFrames--;
            return;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc7_.frameObjectPosVector.length)
         {
            _loc4_ = _loc7_.frameObjectPosVector[_loc9_];
            if(_loc4_.isSprite)
            {
               _loc8_ = param1.children[_loc4_.objectNum].spriteInst;
               IncSpriteInstFrame(_loc8_,_loc4_,param3 / _loc6_);
            }
            _loc9_++;
         }
      }
      
      private function DoFramesHit(param1:JASpriteInst, param2:JAObjectPos) : void {
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:JAFrame = param1.spriteDef.frames[param1.frameNum];
         FrameHit(param1,_loc5_,param2);
         _loc6_ = 0;
         while(_loc6_ < _loc5_.frameObjectPosVector.length)
         {
            _loc3_ = _loc5_.frameObjectPosVector[_loc6_];
            if(_loc3_.isSprite)
            {
               _loc4_ = param1.children[_loc3_.objectNum].spriteInst;
               if(_loc4_ != null)
               {
                  DoFramesHit(_loc4_,_loc3_);
               }
            }
            _loc6_++;
         }
      }
      
      private function FrameHit(param1:JASpriteInst, param2:JAFrame, param3:JAObjectPos) : void {
         var _loc13_:* = 0;
         var _loc14_:* = null;
         var _loc8_:* = null;
         var _loc18_:* = 0;
         var _loc16_:* = 0;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = false;
         var _loc17_:* = 0;
         var _loc11_:* = 0;
         var _loc10_:* = null;
         var _loc20_:* = 0;
         var _loc19_:* = null;
         var _loc5_:* = 0;
         var _loc12_:* = NaN;
         var _loc15_:* = NaN;
         var _loc9_:* = null;
         param1.onNewFrame = false;
         _loc13_ = 0;
         while(_loc13_ < param2.frameObjectPosVector.length)
         {
            _loc14_ = param2.frameObjectPosVector[_loc13_];
            if(_loc14_.isSprite)
            {
               _loc8_ = param1.children[_loc14_.objectNum].spriteInst;
               if(_loc8_ != null)
               {
                  _loc18_ = 0;
                  while(_loc18_ < _loc14_.preloadFrames)
                  {
                     IncSpriteInstFrame(_loc8_,_loc14_,100 / param1.spriteDef.animRate);
                     _loc18_++;
                  }
               }
            }
            _loc13_++;
         }
         _loc11_ = 0;
         while(_loc11_ < param2.commandVector.length)
         {
            _loc10_ = param2.commandVector[_loc11_];
            if(_listener == null || !_listener.JAnimCommand(_id,this,param1,_loc10_.command,_loc10_.param))
            {
               if(_loc10_.command == "delay")
               {
                  _loc6_ = _loc10_.param.indexOf(",");
                  if(_loc6_ != -1)
                  {
                     _loc16_ = _loc10_.param.substr(0,_loc6_);
                     _loc20_ = _loc10_.param.substr(_loc6_ + 1);
                     if(_loc20_ <= _loc16_)
                     {
                        _loc20_ = _loc16_ + 1;
                     }
                     param1.delayFrames = _loc16_ + Math.random() * 100000 % (_loc20_ - _loc16_);
                  }
                  else
                  {
                     _loc16_ = _loc10_.param;
                     param1.delayFrames = _loc16_;
                  }
               }
               else if(_loc10_.command == "playsample")
               {
                  _loc19_ = _loc10_.param;
                  _loc5_ = 0;
                  _loc12_ = 1.0;
                  _loc15_ = 0.0;
                  _loc7_ = true;
                  while(_loc19_.length > 0)
                  {
                     _loc6_ = _loc19_.indexOf(",");
                     if(_loc6_ == -1)
                     {
                        _loc4_ = _loc19_;
                     }
                     else
                     {
                        _loc4_ = _loc19_.substr(0,_loc6_);
                     }
                     if(_loc7_)
                     {
                        _loc9_ = _loc4_;
                        _loc7_ = false;
                     }
                     else
                     {
                        while(true)
                        {
                           _loc17_ = _loc4_.indexOf(" ");
                           if(_loc4_.indexOf(" ") == -1)
                           {
                              break;
                           }
                           _loc4_ = _loc4_.substr(0,_loc17_) + _loc4_.substr(_loc17_ + 1);
                        }
                        if(_loc4_.substr(0,7) == "volume=")
                        {
                           _loc12_ = _loc4_.substr(7);
                        }
                        else if(_loc4_.substr(0,4) == "pan=")
                        {
                           _loc5_ = _loc4_.substr(4);
                        }
                        else if(_loc4_.substr(0,6) == "steps=")
                        {
                           _loc15_ = _loc4_.substr(6);
                        }
                        
                        
                     }
                     if(_loc6_ != -1)
                     {
                        _loc19_ = _loc19_.substr(_loc6_ + 1);
                        continue;
                     }
                     break;
                  }
                  if(_listener != null)
                  {
                     _listener.JAnimPLaySample(_loc9_,_loc5_,_loc12_,_loc15_);
                  }
               }
               
            }
            _loc11_++;
         }
      }
      
      private function UpdateTransforms(param1:JASpriteInst, param2:JATransform, param3:JAColor, param4:Boolean) : void {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         if(param2)
         {
            param1.curTransform.clone(param2);
         }
         else
         {
            param1.curTransform.matrix.clone(_drawTransform);
         }
         if(param1.curColor == null)
         {
            param1.curColor = new JAColor();
         }
         param1.curColor.clone(param3);
         var _loc5_:JAFrame = param1.spriteDef.frames[param1.frameNum];
         var _loc7_:JATransform = _helpCallTransform[_helpCallDepth];
         var _loc8_:JAColor = _helpCallColor[_helpCallDepth];
         _helpCallDepth = _helpCallDepth + 1;
         var _loc10_:Boolean = param4 || param1.delayFrames > 0 || _loc5_.hasStop;
         _loc9_ = 0;
         while(_loc9_ < _loc5_.frameObjectPosVector.length)
         {
            _loc6_ = _loc5_.frameObjectPosVector[_loc9_];
            if(_loc6_.isSprite)
            {
               CalcObjectPos(param1,_loc9_,_loc10_);
               _loc7_ = _helpCalcTransform;
               _loc8_ = _helpCalcColor;
               _helpCalcTransform = null;
               _helpCalcColor = null;
               if(param2 != null)
               {
                  _loc7_ = param2.TransformSrc(_loc7_,_loc7_);
               }
               UpdateTransforms(param1.children[_loc6_.objectNum].spriteInst,_loc7_,_loc8_,_loc10_);
            }
            _loc9_++;
         }
      }
      
      private function CalcObjectPos(param1:JASpriteInst, param2:int, param3:Boolean) : void {
         var _loc17_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc10_:* = 0;
         var _loc19_:* = null;
         var _loc8_:* = 0;
         var _loc9_:* = NaN;
         var _loc18_:* = false;
         var _loc11_:JAFrame = param1.spriteDef.frames[param1.frameNum];
         var _loc12_:JAObjectPos = _loc11_.frameObjectPosVector[param2];
         var _loc5_:JAObjectInst = param1.children[_loc12_.objectNum];
         _helpANextObjectPos[0] = null;
         _helpANextObjectPos[1] = null;
         _helpANextObjectPos[2] = null;
         var _loc14_:int = param1.spriteDef.frames.length - 1;
         var _loc16_:* = 1;
         var _loc13_:* = 2;
         if(param1 == _mainSpriteInst && param1.frameNum >= param1.spriteDef.workAreaStart)
         {
            _loc14_ = param1.spriteDef.workAreaDuration - 1;
         }
         var _loc15_:JATransform = _helpCallTransform[_helpCallDepth];
         var _loc4_:JAColor = _helpCallColor[_helpCallDepth];
         _helpCallDepth = _helpCallDepth + 1;
         if(_interpolate && !param3)
         {
            _loc10_ = 0;
            while(_loc10_ < 3)
            {
               _loc19_ = param1.spriteDef.frames[(param1.frameNum + (_loc10_ == 0?_loc14_:_loc10_ == 1?_loc16_:_loc13_)) % param1.spriteDef.frames.length];
               if(param1 == _mainSpriteInst && param1.frameNum >= param1.spriteDef.workAreaStart)
               {
                  _loc19_ = param1.spriteDef.frames[((param1.frameNum) + (_loc10_ == 0?_loc14_:_loc10_ == 1?_loc16_:_loc13_) - param1.spriteDef.workAreaStart) % (param1.spriteDef.workAreaDuration + 1) + param1.spriteDef.workAreaStart];
               }
               else
               {
                  _loc19_ = param1.spriteDef.frames[((param1.frameNum) + (_loc10_ == 0?_loc14_:_loc10_ == 1?_loc16_:_loc13_)) % param1.spriteDef.frames.length];
               }
               if(_loc11_.hasStop)
               {
                  _loc19_ = _loc11_;
               }
               if(_loc19_.frameObjectPosVector.length > param2)
               {
                  _helpANextObjectPos[_loc10_] = _loc19_.frameObjectPosVector[param2];
                  if(_helpANextObjectPos[_loc10_].objectNum != _loc12_.objectNum)
                  {
                     _helpANextObjectPos[_loc10_] = null;
                  }
               }
               if(_helpANextObjectPos[_loc10_] == null)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc19_.frameObjectPosVector.length)
                  {
                     if(_loc19_.frameObjectPosVector[_loc8_].objectNum == _loc12_.objectNum)
                     {
                        _helpANextObjectPos[_loc10_] = _loc19_.frameObjectPosVector[_loc8_];
                        break;
                     }
                     _loc8_++;
                  }
               }
               _loc10_++;
            }
            if(_helpANextObjectPos[1] != null)
            {
               _loc9_ = param1.frameNum - Math.floor(param1.frameNum);
               _loc18_ = false;
               _loc15_ = _loc12_.transform.InterpolateTo(_helpANextObjectPos[1].transform,_loc9_,_loc15_);
               _loc4_.Set(_loc12_.color.red * (1 - _loc9_) + _helpANextObjectPos[1].color.red * _loc9_ + 0.5,_loc12_.color.green * (1 - _loc9_) + _helpANextObjectPos[1].color.green * _loc9_ + 0.5,_loc12_.color.blue * (1 - _loc9_) + _helpANextObjectPos[1].color.blue * _loc9_ + 0.5,_loc12_.color.alpha * (1 - _loc9_) + _helpANextObjectPos[1].color.alpha * _loc9_ + 0.5);
            }
            else
            {
               _loc15_.clone(_loc12_.transform);
               _loc4_.clone(_loc12_.color);
            }
         }
         else
         {
            _loc15_.clone(_loc12_.transform);
            _loc4_.clone(_loc12_.color);
         }
         _loc15_.matrix = JAMatrix3.MulJAMatrix3(_loc5_.transform,_loc15_.matrix,_loc15_.matrix);
         if(_loc5_.isBlending && !(_blendTicksTotal == 0) && param1 == _mainSpriteInst)
         {
            _loc9_ = _blendTicksCur / _blendTicksTotal;
            _loc15_ = _loc5_.blendSrcTransform.InterpolateTo(_loc15_,_loc9_,_loc15_);
            _loc4_.Set(_loc5_.blendSrcColor.red * (1 - _loc9_) + _loc4_.red * _loc9_ + 0.5,_loc5_.blendSrcColor.green * (1 - _loc9_) + _loc4_.green * _loc9_ + 0.5,_loc5_.blendSrcColor.blue * (1 - _loc9_) + _loc4_.blue * _loc9_ + 0.5,_loc5_.blendSrcColor.alpha * (1 - _loc9_) + _loc4_.alpha * _loc9_ + 0.5);
         }
         _helpCalcTransform = _loc15_;
         _helpCalcColor = _loc4_;
         _helpANextObjectPos[0] = null;
         _helpANextObjectPos[1] = null;
         _helpANextObjectPos[2] = null;
      }
      
      private function InitSpriteInst(param1:JASpriteInst, param2:JASpriteDef) : void {
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         param1.frameRepeats = 0;
         param1.delayFrames = 0;
         param1.spriteDef = param2;
         param1.lastUpdated = -1;
         param1.onNewFrame = true;
         param1.frameNum = 0;
         param1.lastFrameNum = 0;
         param1.children.splice(0,param1.children.length);
         param1.children.length = param2.objectDefVector.length;
         _loc7_ = 0;
         while(_loc7_ < param2.objectDefVector.length)
         {
            param1.children[_loc7_] = new JAObjectInst();
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < param2.objectDefVector.length)
         {
            _loc6_ = param2.objectDefVector[_loc7_];
            _loc5_ = param1.children[_loc7_];
            _loc5_.colorMult = new JAColor();
            _loc5_.colorMult.clone(JAColor.White);
            _loc5_.name = _loc6_.name;
            _loc5_.isBlending = false;
            _loc4_ = _loc6_.spriteDef;
            if(_loc4_ != null)
            {
               _loc3_ = new JASpriteInst();
               _loc3_.parent = param1;
               InitSpriteInst(_loc3_,_loc4_);
               _loc5_.spriteInst = _loc3_;
            }
            _loc7_++;
         }
         if(param1 == _mainSpriteInst)
         {
            GetToFirstFrame();
         }
      }
      
      private function ResetAnimHelper(param1:JASpriteInst) : void {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         param1.frameNum = 0;
         param1.lastFrameNum = 0;
         param1.frameRepeats = 0;
         param1.delayFrames = 0;
         param1.lastUpdated = -1;
         param1.onNewFrame = true;
         _loc3_ = 0;
         while(_loc3_ < param1.children.length)
         {
            _loc2_ = param1.children[_loc3_].spriteInst;
            if(_loc2_ != null)
            {
               ResetAnimHelper(_loc2_);
            }
            _loc3_++;
         }
         _transDirty = true;
      }
   }
}
