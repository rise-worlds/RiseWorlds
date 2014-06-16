package com.flengine.geom
{
   import flash.geom.Point;
   import flash.display.Graphics;
   
   public class FCurve extends Object
   {
      
      public function FCurve(param1:Vector.<Number>) {
         super();
         if(param1 == null)
         {
            _aPoints = new Vector.<Number>();
         }
         else
         {
            _aPoints = param1;
         }
      }
      
      protected var _nNormalEpsilon:Number = 0.001;
      
      protected var _bLengthDirty:Boolean = true;
      
      protected var _aPoints:Vector.<Number>;
      
      protected var _nLength:Number = 0;
      
      public function get length() : Number {
         var _loc1_:* = NaN;
         var _loc4_:* = NaN;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(_bLengthDirty)
         {
            _nLength = 0;
            _loc1_ = 1 / _aPoints.length;
            _loc4_ = 0.0;
            while(_loc4_ < 100)
            {
               _loc2_ = interpolateByDistance(_loc4_ * _loc1_);
               if(_loc3_ != null)
               {
                  _nLength = _nLength + Point.distance(_loc3_,_loc2_);
               }
               _loc3_ = _loc2_;
               _loc4_++;
            }
            _bLengthDirty = false;
         }
         return _nLength;
      }
      
      public function set points(param1:Vector.<Number>) : void {
         _aPoints = param1;
         _bLengthDirty = true;
      }
      
      public function get points() : Vector.<Number> {
         return _aPoints;
      }
      
      public function addPoint(param1:Number, param2:Number, param3:Number = -1) : void {
         if(param3 == -1)
         {
            _aPoints.push(param1,param2);
         }
         else
         {
            _aPoints.splice(param3 * 2,0,param1,param2);
         }
         _bLengthDirty = true;
      }
      
      public function removePoint(param1:Number) : void {
         _aPoints.splice(param1,1);
      }
      
      public function getNormalAtDistance(param1:Number) : Point {
         var _loc3_:Point = interpolateByDistance(param1 - _nNormalEpsilon);
         var _loc2_:Point = interpolateByDistance(param1 + _nNormalEpsilon);
         var _loc5_:Number = _loc2_.x - _loc3_.x;
         var _loc4_:Number = _loc2_.y - _loc3_.y;
         return new Point(_loc4_,-_loc5_);
      }
      
      public function interpolateByDistance(param1:Number) : Point {
         return new Point();
      }
      
      public function drawPath(param1:Graphics, param2:Number) : void {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         var _loc4_:* = null;
         _loc3_ = 1 / (param2 - 1);
         _loc5_ = 0.0;
         while(_loc5_ < param2)
         {
            _loc4_ = interpolateByDistance(_loc5_ * _loc3_);
            if(_loc5_ == 0)
            {
               param1.moveTo(_loc4_.x,_loc4_.y);
            }
            else
            {
               param1.lineTo(_loc4_.x,_loc4_.y);
            }
            _loc5_++;
         }
      }
   }
}
