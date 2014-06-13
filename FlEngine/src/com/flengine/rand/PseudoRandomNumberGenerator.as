package com.flengine.rand
{

    public interface PseudoRandomNumberGenerator
    {

        public function PseudoRandomNumberGenerator();

        function SetSeed(param1:Number) : void;

        function Next() : Number;

        function Reset() : void;

    }
}
