package com.flengine.components.renderables.jointanim
{

    public class JATransform2D extends JAMatrix3
    {
        private static var _helpMatrix:JAMatrix3 = new JAMatrix3();

        public function JATransform2D()
        {
            return;
        }

        public function Scale(param1:Number, param2:Number) : void
        {
            _helpMatrix.LoadIdentity();
            _helpMatrix.m00 = param1;
            _helpMatrix.m11 = param2;
            MulJAMatrix3(_helpMatrix, this, this);
            return;
        }

        public function Translate(param1:Number, param2:Number) : void
        {
            _helpMatrix.LoadIdentity();
            _helpMatrix.m02 = param1;
            _helpMatrix.m12 = param2;
            MulJAMatrix3(_helpMatrix, this, this);
            return;
        }

        public function RotateDeg(param1:Number) : void
        {
            RotateRad(0.0174533 * param1);
            return;
        }

        public function RotateRad(param1:Number) : void
        {
            _helpMatrix.LoadIdentity();
            var _loc_3:* = Math.sin(param1);
            var _loc_2:* = Math.cos(param1);
            _helpMatrix.m00 = _loc_2;
            _helpMatrix.m01 = _loc_3;
            _helpMatrix.m10 = -_loc_3;
            _helpMatrix.m11 = _loc_2;
            MulJAMatrix3(_helpMatrix, this, this);
            return;
        }

    }
}
