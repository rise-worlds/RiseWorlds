package com.flengine.rand
{
   public class Hermite extends Object
   {
      
      public function Hermite() {
         var _loc1_:* = 0;
         points = new Vector.<HermitePoint>();
         mPieces = new Vector.<HermitePiece>();
         mXSub = new Vector.<Number>(2,true);
         super();
         q = new Vector.<Vector.<Number>>(4,true);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            q[_loc1_] = new Vector.<Number>(4,true);
            _loc1_++;
         }
         z = new Vector.<Number>(4,true);
      }
      
      public static const NUM_DIMS:int = 4;
      
      public var points:Vector.<HermitePoint>;
      
      private var q:Vector.<Vector.<Number>>;
      
      private var z:Vector.<Number>;
      
      private var mPieces:Vector.<HermitePiece>;
      
      private var mIsBuilt:Boolean = false;
      
      private var mXSub:Vector.<Number>;
      
      public function rebuild() : void {
         mIsBuilt = false;
      }
      
      public function evaluate(param1:Number) : Number {
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         if(!mIsBuilt)
         {
            if(!build())
            {
               return 0;
            }
            mIsBuilt = true;
         }
         var _loc3_:int = mPieces.length;
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            if(param1 < points[_loc6_ + 1].x)
            {
               _loc2_ = points[_loc6_];
               _loc5_ = points[_loc6_ + 1];
               _loc4_ = mPieces[_loc6_];
               return evaluatePiece(param1,_loc2_.x,_loc5_.x,_loc4_);
            }
            _loc6_++;
         }
         return points[points.length - 1].fx;
      }
      
      private function build() : Boolean {
         var _loc3_:* = 0;
         mPieces.length = 0;
         var _loc1_:int = points.length;
         if(_loc1_ < 2)
         {
            return false;
         }
         var _loc2_:int = _loc1_ - 1;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            mPieces[_loc3_] = createPiece(_loc3_);
            _loc3_++;
         }
         return true;
      }
      
      private function createPiece(param1:int) : HermitePiece {
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         _loc6_ = 0;
         while(_loc6_ <= 1)
         {
            _loc2_ = points[param1 + _loc6_];
            _loc5_ = 2 * _loc6_;
            z[_loc5_] = _loc2_.x;
            z[_loc5_ + 1] = _loc2_.x;
            q[_loc5_][0] = _loc2_.fx;
            q[_loc5_ + 1][0] = _loc2_.fx;
            q[_loc5_ + 1][1] = _loc2_.fxp;
            if(_loc6_ > 0)
            {
               q[_loc5_][1] = (q[_loc5_][0] - q[_loc5_ - 1][0]) / (z[_loc5_] - z[_loc5_ - 1]);
            }
            _loc6_++;
         }
         _loc6_ = 2;
         while(_loc6_ < 4)
         {
            _loc3_ = 2;
            while(_loc3_ <= _loc6_)
            {
               q[_loc6_][_loc3_] = (q[_loc6_][_loc3_ - 1] - q[_loc6_ - 1][_loc3_ - 1]) / (z[_loc6_] - z[_loc6_ - _loc3_]);
               _loc3_++;
            }
            _loc6_++;
         }
         var _loc4_:HermitePiece = new HermitePiece();
         _loc6_ = 0;
         while(_loc6_ < 4)
         {
            _loc4_.coeffs[_loc6_] = q[_loc6_][_loc6_];
            _loc6_++;
         }
         return _loc4_;
      }
      
      private function evaluatePiece(param1:Number, param2:Number, param3:Number, param4:HermitePiece) : Number {
         var _loc7_:* = 0;
         mXSub[0] = param1 - param2;
         mXSub[1] = param1 - param3;
         var _loc5_:* = 1.0;
         var _loc6_:Number = param4.coeffs[0];
         _loc7_ = 1;
         while(_loc7_ < 4)
         {
            _loc5_ = _loc5_ * mXSub[(_loc7_ - 1) / 2];
            _loc6_ = _loc6_ + _loc5_ * param4.coeffs[_loc7_];
            _loc7_++;
         }
         return _loc6_;
      }
   }
}
