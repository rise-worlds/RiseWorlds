package com.flengine.geom
{
   import flash.geom.Point;
   
   public class FNurbsCurve extends FCurve
   {
      
      public function FNurbsCurve(param1:Vector.<Number> = null, param2:int = 3, param3:Array = null) {
         super(param1);
         _d = param2;
         if(param3 != null)
         {
            knot = param3;
         }
         else
         {
            generateKnotVector();
         }
      }
      
      public var knot:Array;
      
      protected var _d:int;
      
      public function generateKnotVector() : void {
         var _loc2_:* = 0;
         knot = [];
         var _loc1_:int = _aPoints.length / 2;
         _loc2_ = 0;
         while(_loc2_ < _d + _loc1_)
         {
            if(_loc2_ <= _d)
            {
               knot.push(0);
            }
            else if(_loc2_ >= _loc1_)
            {
               knot.push(1);
            }
            else
            {
               knot.push((_loc2_ - _d) / (_loc1_ - _d));
            }
            
            _loc2_++;
         }
         knot.push(2);
      }
      
      public function set d(param1:int) : void {
         _d = param1;
      }
      
      public function get d() : int {
         return _d;
      }
      
      override public function addPoint(param1:Number, param2:Number, param3:Number = -1) : void {
         super.addPoint(param1,param2,param3);
         generateKnotVector();
      }
      
      private function Nik(param1:int, param2:int, param3:Number) : Number {
         if(param2 == 0)
         {
            if(param3 >= knot[param1] && param3 < knot[param1 + 1])
            {
               return 1;
            }
            return 0;
         }
         var _loc4_:* = 0;
         if(knot[param1 + param2] != knot[param1])
         {
            _loc4_ = _loc4_ + (param3 - knot[param1]) / (knot[param1 + param2] - knot[param1]) * Nik(param1,param2 - 1,param3);
         }
         if(knot[param1 + param2 + 1] != knot[param1 + 1])
         {
            _loc4_ = _loc4_ + (knot[param1 + param2 + 1] - param3) / (knot[param1 + param2 + 1] - knot[param1 + 1]) * Nik(param1 + 1,param2 - 1,param3);
         }
         return _loc4_;
      }
      
      private function Nikd(param1:int, param2:int, param3:Number) : Number {
         if(param2 == 0)
         {
            return 0;
         }
         var _loc4_:* = 0;
         if(knot[param1 + param2] != knot[param1])
         {
            _loc4_ = _loc4_ + (Nik(param1,param2 - 1,param3) + (param3 - knot[param1]) * Nikd(param1,param2 - 1,param3)) / (knot[param1 + param2] - knot[param1]);
         }
         if(knot[param1 + param2 + 1] != knot[param1 + 1])
         {
            _loc4_ = _loc4_ + (-Nik(param1 + 1,param2 - 1,param3) + (knot[param1 + param2 + 1] - param3) * Nikd(param1 + 1,param2 - 1,param3)) / (knot[param1 + param2 + 1] - knot[param1 + 1]);
         }
         return _loc4_;
      }
      
      override public function getNormalAtDistance(param1:Number) : Point {
         var _loc4_:* = 0;
         var _loc3_:* = NaN;
         var _loc2_:Point = new Point();
         _loc4_ = 0;
         while(_loc4_ < _aPoints.length)
         {
            _loc3_ = Nikd(_loc4_ / 2,d,param1);
            _loc2_.x = _loc2_.x + _aPoints[_loc4_ + 1] * _loc3_;
            _loc2_.y = _loc2_.y - _aPoints[_loc4_] * _loc3_;
            _loc4_ = _loc4_ + 2;
         }
         return _loc2_;
      }
      
      override public function interpolateByDistance(param1:Number) : Point {
         var _loc4_:* = 0;
         var _loc3_:* = NaN;
         var _loc2_:Point = new Point();
         _loc4_ = 0;
         while(_loc4_ < _aPoints.length)
         {
            _loc3_ = Nik(_loc4_ / 2,_d,param1);
            _loc2_.x = _loc2_.x + _aPoints[_loc4_] * _loc3_;
            _loc2_.y = _loc2_.y + _aPoints[_loc4_ + 1] * _loc3_;
            _loc4_ = _loc4_ + 2;
         }
         return _loc2_;
      }
   }
}
