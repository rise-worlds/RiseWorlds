package com.flengine.components.renderables.jointanim
{

    public class JATransform extends Object
    {
        public var matrix:JAMatrix3;
        private static var _m00:Number;
        private static var _m01:Number;
        private static var _m10:Number;
        private static var _m11:Number;
        private static var _m02:Number;
        private static var _m12:Number;
        private static var __m00:Number;
        private static var __m01:Number;
        private static var __m10:Number;
        private static var __m11:Number;
        private static var __m02:Number;
        private static var __m12:Number;

        public function JATransform()
        {
            matrix = new JAMatrix3();
            return;
        }

        public function clone(param1:JATransform) : void
        {
            this.matrix.clone(param1.matrix);
            return;
        }

        public function TransformSrc(param1:JATransform, param2:JATransform) : JATransform
        {
            __m00 = param1.matrix.m00;
            __m01 = param1.matrix.m01;
            __m10 = param1.matrix.m10;
            __m11 = param1.matrix.m11;
            __m02 = param1.matrix.m02;
            __m12 = param1.matrix.m12;
            _m00 = matrix.m00;
            _m01 = matrix.m01;
            _m10 = matrix.m10;
            _m11 = matrix.m11;
            _m02 = matrix.m02;
            _m12 = matrix.m12;
            param2.matrix.m00 = _m00 * __m00 + _m01 * __m10;
            param2.matrix.m01 = _m00 * __m01 + _m01 * __m11;
            param2.matrix.m10 = _m10 * __m00 + _m11 * __m10;
            param2.matrix.m11 = _m10 * __m01 + _m11 * __m11;
            param2.matrix.m02 = _m02 + _m00 * __m02 + _m01 * __m12;
            param2.matrix.m12 = _m12 + _m10 * __m02 + _m11 * __m12;
            return param2;
        }

        public function InterpolateTo(param1:JATransform, param2:Number, param3:JATransform) : JATransform
        {
            __m00 = param1.matrix.m00;
            __m01 = param1.matrix.m01;
            __m10 = param1.matrix.m10;
            __m11 = param1.matrix.m11;
            __m02 = param1.matrix.m02;
            __m12 = param1.matrix.m12;
            _m00 = matrix.m00;
            _m01 = matrix.m01;
            _m10 = matrix.m10;
            _m11 = matrix.m11;
            _m02 = matrix.m02;
            _m12 = matrix.m12;
            param3.matrix.m00 = _m00 * (1 - param2) + __m00 * param2;
            param3.matrix.m01 = _m01 * (1 - param2) + __m01 * param2;
            param3.matrix.m10 = _m10 * (1 - param2) + __m10 * param2;
            param3.matrix.m11 = _m11 * (1 - param2) + __m11 * param2;
            param3.matrix.m02 = _m02 * (1 - param2) + __m02 * param2;
            param3.matrix.m12 = _m12 * (1 - param2) + __m12 * param2;
            return param3;
        }

    }
}
