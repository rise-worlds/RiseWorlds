package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class JAMatrix3 extends Object
    {
        public var m00:Number;
        public var m01:Number;
        public var m02:Number;
        public var m10:Number;
        public var m11:Number;
        public var m12:Number;
        private static var _helpMatrixArg1:JAMatrix3 = new JAMatrix3;
        private static var _helpMatrixArg2:JAMatrix3 = new JAMatrix3;
        private static var _helpMatrix3DVector1:Vector.<Number> = JAMatrix3.Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
        private static var _helpMatrix3DVector2:Vector.<Number> = JAMatrix3.Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
        private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
        private static var _helpMatrix3DArg2:Matrix3D = new Matrix3D();

        public function JAMatrix3()
        {
            LoadIdentity();
            return;
        }// end function

        public function clone(param1:JAMatrix3) : void
        {
            this.m00 = param1.m00;
            this.m01 = param1.m01;
            this.m02 = param1.m02;
            this.m10 = param1.m10;
            this.m11 = param1.m11;
            this.m12 = param1.m12;
            return;
        }// end function

        public function ZeroMatrix() : void
        {
            m00 = 0;
            m01 = 0;
            m02 = 0;
            m10 = 0;
            m11 = 0;
            m12 = 0;
            return;
        }// end function

        public function LoadIdentity() : void
        {
            m00 = 1;
            m01 = 0;
            m02 = 0;
            m10 = 0;
            m11 = 1;
            m12 = 0;
            return;
        }// end function

        public static function MulJAMatrix3(param1:JAMatrix3, param2:JAMatrix3, param3:JAMatrix3) : JAMatrix3
        {
            _helpMatrixArg1.m00 = param1.m00;
            _helpMatrixArg1.m01 = param1.m01;
            _helpMatrixArg1.m02 = param1.m02;
            _helpMatrixArg1.m10 = param1.m10;
            _helpMatrixArg1.m11 = param1.m11;
            _helpMatrixArg1.m12 = param1.m12;
            _helpMatrixArg2.m00 = param2.m00;
            _helpMatrixArg2.m01 = param2.m01;
            _helpMatrixArg2.m02 = param2.m02;
            _helpMatrixArg2.m10 = param2.m10;
            _helpMatrixArg2.m11 = param2.m11;
            _helpMatrixArg2.m12 = param2.m12;
            param3.m00 = _helpMatrixArg1.m00 * _helpMatrixArg2.m00 + _helpMatrixArg1.m01 * _helpMatrixArg2.m10;
            param3.m10 = _helpMatrixArg1.m10 * _helpMatrixArg2.m00 + _helpMatrixArg1.m11 * _helpMatrixArg2.m10;
            param3.m01 = _helpMatrixArg1.m00 * _helpMatrixArg2.m01 + _helpMatrixArg1.m01 * _helpMatrixArg2.m11;
            param3.m11 = _helpMatrixArg1.m10 * _helpMatrixArg2.m01 + _helpMatrixArg1.m11 * _helpMatrixArg2.m11;
            param3.m02 = _helpMatrixArg1.m00 * _helpMatrixArg2.m02 + _helpMatrixArg1.m01 * _helpMatrixArg2.m12 + _helpMatrixArg1.m02;
            param3.m12 = _helpMatrixArg1.m10 * _helpMatrixArg2.m02 + _helpMatrixArg1.m11 * _helpMatrixArg2.m12 + _helpMatrixArg1.m12;
            return param3;
        }// end function

        public static function MulJAMatrix3_M3D(param1:Matrix3D, param2:JATransform2D, param3:JATransform2D) : JATransform2D
        {
            _helpMatrix3DVector1[0] = param2.m00;
            _helpMatrix3DVector1[1] = param2.m10;
            _helpMatrix3DVector1[4] = param2.m01;
            _helpMatrix3DVector1[5] = param2.m11;
            _helpMatrix3DVector1[12] = param2.m02;
            _helpMatrix3DVector1[13] = param2.m12;
            _helpMatrix3DArg1.copyRawDataFrom(_helpMatrix3DVector1);
            _helpMatrix3DArg1.prepend(param1);
            _helpMatrix3DArg1.copyRawDataTo(_helpMatrix3DVector1);
            param3.m00 = _helpMatrix3DVector1[0];
            param3.m10 = _helpMatrix3DVector1[1];
            param3.m01 = _helpMatrix3DVector1[4];
            param3.m11 = _helpMatrix3DVector1[5];
            param3.m02 = _helpMatrix3DVector1[12];
            param3.m12 = _helpMatrix3DVector1[13];
            return param3;
        }// end function

        public static function MulJAMatrix3_2D(param1:JAMatrix3, param2:JATransform2D, param3:JATransform2D) : JATransform2D
        {
            _helpMatrixArg1.m00 = param1.m00;
            _helpMatrixArg1.m01 = param1.m01;
            _helpMatrixArg1.m02 = param1.m02;
            _helpMatrixArg1.m10 = param1.m10;
            _helpMatrixArg1.m11 = param1.m11;
            _helpMatrixArg1.m12 = param1.m12;
            _helpMatrixArg2.m00 = param2.m00;
            _helpMatrixArg2.m01 = param2.m01;
            _helpMatrixArg2.m02 = param2.m02;
            _helpMatrixArg2.m10 = param2.m10;
            _helpMatrixArg2.m11 = param2.m11;
            _helpMatrixArg2.m12 = param2.m12;
            param3.m00 = _helpMatrixArg1.m00 * _helpMatrixArg2.m00 + _helpMatrixArg1.m01 * _helpMatrixArg2.m10;
            param3.m10 = _helpMatrixArg1.m10 * _helpMatrixArg2.m00 + _helpMatrixArg1.m11 * _helpMatrixArg2.m10;
            param3.m01 = _helpMatrixArg1.m00 * _helpMatrixArg2.m01 + _helpMatrixArg1.m01 * _helpMatrixArg2.m11;
            param3.m11 = _helpMatrixArg1.m10 * _helpMatrixArg2.m01 + _helpMatrixArg1.m11 * _helpMatrixArg2.m11;
            param3.m02 = _helpMatrixArg1.m00 * _helpMatrixArg2.m02 + _helpMatrixArg1.m01 * _helpMatrixArg2.m12 + _helpMatrixArg1.m02;
            param3.m12 = _helpMatrixArg1.m10 * _helpMatrixArg2.m02 + _helpMatrixArg1.m11 * _helpMatrixArg2.m12 + _helpMatrixArg1.m12;
            return param3;
        }// end function

        public static function MulJAVec2X(param1:JAMatrix3, param2:Number, param3:Number) : Number
        {
            return param1.m00 * param2 + param1.m01 * param3 + param1.m02;
        }// end function

        public static function MulJAVec2Y(param1:JAMatrix3, param2:Number, param3:Number) : Number
        {
            return param1.m10 * param2 + param1.m11 * param3 + param1.m12;
        }// end function

        public static function cloneTo(param1:JAMatrix3, param2:JAMatrix3) : void
        {
            param1.m00 = param2.m00;
            param1.m01 = param2.m01;
            param1.m02 = param2.m02;
            param1.m10 = param2.m10;
            param1.m11 = param2.m11;
            param1.m12 = param2.m12;
            return;
        }// end function

    }
}
