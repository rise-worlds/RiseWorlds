package com.flengine.components.particles.fields
{
    import com.flengine.components.particles.*;
    import com.flengine.core.*;

    public class FGravityField extends FField
    {
        public var radius:Number = -1;
        public var gravity:Number = 0;
        public var gravityVariance:Number = 0;
        public var inverseGravity:Boolean = false;

        public function FGravityField(param1:FNode)
        {
            super(param1);
            return;
        }

        override public function updateParticle(param1:FParticle, param2:Number) : void
        {
            var _loc_4:* = NaN;
            if (!_bActive)
            {
                return;
            }
            var _loc_5:* = cNode.cTransform.nWorldX - param1.cNode.cTransform.nWorldX;
            var _loc_6:* = cNode.cTransform.nWorldY - param1.cNode.cTransform.nWorldY;
            var _loc_7:* = _loc_5 * _loc_5 + _loc_6 * _loc_6;
            if (_loc_5 * _loc_5 + _loc_6 * _loc_6 > radius * radius && radius > 0)
            {
                return;
            }
            if (_loc_7 != 0)
            {
                _loc_4 = Math.sqrt(_loc_7);
                _loc_5 = _loc_5 / (inverseGravity ? (-_loc_4) : (_loc_4));
                _loc_6 = _loc_6 / (inverseGravity ? (-_loc_4) : (_loc_4));
            }
            var _loc_3:* = gravity;
            if (gravityVariance > 0)
            {
                _loc_3 = _loc_3 + gravityVariance * Math.random();
            }
            param1.nVelocityX = param1.nVelocityX + _loc_3 * _loc_5 * 0.001 * param2;
            param1.nVelocityY = param1.nVelocityY + _loc_3 * _loc_6 * 0.001 * param2;
            return;
        }

        override public function updateSimpleParticle(param1:FSimpleParticle, param2:Number) : void
        {
            var _loc_4:* = NaN;
            if (!_bActive)
            {
                return;
            }
            var _loc_5:* = cNode.cTransform.nWorldX - param1.nX;
            var _loc_6:* = cNode.cTransform.nWorldY - param1.nY;
            var _loc_7:* = _loc_5 * _loc_5 + _loc_6 * _loc_6;
            if (_loc_5 * _loc_5 + _loc_6 * _loc_6 > radius * radius && radius > 0)
            {
                return;
            }
            if (_loc_7 != 0)
            {
                _loc_4 = Math.sqrt(_loc_7);
                _loc_5 = _loc_5 / (inverseGravity ? (-_loc_4) : (_loc_4));
                _loc_6 = _loc_6 / (inverseGravity ? (-_loc_4) : (_loc_4));
            }
            var _loc_3:* = gravity;
            if (gravityVariance > 0)
            {
                _loc_3 = _loc_3 + gravityVariance * Math.random();
            }
            param1.nVelocityX = param1.nVelocityX + _loc_3 * _loc_5 * 0.001 * param2;
            param1.nVelocityY = param1.nVelocityY + _loc_3 * _loc_6 * 0.001 * param2;
            return;
        }

    }
}
