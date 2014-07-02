package com.genome2d.components.renderables.jointanim;

/**
 * ...
 * @author Rise
 */
class JATransform {
	private static var _m00:Float;
	private static var _m01:Float;
	private static var _m10:Float;
	private static var _m11:Float;
	private static var _m02:Float;
	private static var _m12:Float;
	private static var __m00:Float;
	private static var __m01:Float;
	private static var __m10:Float;
	private static var __m11:Float;
	private static var __m02:Float;
	private static var __m12:Float;
	public var matrix:JAMatrix3;

	public function new() {
		matrix = new JAMatrix3();
	}

	public function clone(from:JATransform):Void {
		this.matrix.copy(from.matrix);
	}

	public function TransformSrc(theSrcTransform:JATransform, outTransform:JATransform):JATransform {
		__m00 = theSrcTransform.matrix.a;
		__m01 = theSrcTransform.matrix.c;
		__m10 = theSrcTransform.matrix.b;
		__m11 = theSrcTransform.matrix.d;
		__m02 = theSrcTransform.matrix.tx;
		__m12 = theSrcTransform.matrix.ty;
		_m00 = matrix.a;
		_m01 = matrix.c;
		_m10 = matrix.b;
		_m11 = matrix.d;
		_m02 = matrix.tx;
		_m12 = matrix.ty;
		outTransform.matrix.a = ((_m00 * __m00) + (_m01 * __m10));
		outTransform.matrix.c = ((_m00 * __m01) + (_m01 * __m11));
		outTransform.matrix.b = ((_m10 * __m00) + (_m11 * __m10));
		outTransform.matrix.d = ((_m10 * __m01) + (_m11 * __m11));
		outTransform.matrix.tx = ((_m02 + (_m00 * __m02)) + (_m01 * __m12));
		outTransform.matrix.ty = ((_m12 + (_m10 * __m02)) + (_m11 * __m12));
		return (outTransform);
	}

	public function InterpolateTo(theNextTransform:JATransform, thePct:Float, outTransform:JATransform):JATransform {
		__m00 = theNextTransform.matrix.a;
		__m01 = theNextTransform.matrix.c;
		__m10 = theNextTransform.matrix.b;
		__m11 = theNextTransform.matrix.d;
		__m02 = theNextTransform.matrix.tx;
		__m12 = theNextTransform.matrix.ty;
		_m00 = matrix.a;
		_m01 = matrix.c;
		_m10 = matrix.b;
		_m11 = matrix.d;
		_m02 = matrix.tx;
		_m12 = matrix.ty;
		outTransform.matrix.a = ((_m00 * (1 - thePct)) + (__m00 * thePct));
		outTransform.matrix.c = ((_m01 * (1 - thePct)) + (__m01 * thePct));
		outTransform.matrix.b = ((_m10 * (1 - thePct)) + (__m10 * thePct));
		outTransform.matrix.d = ((_m11 * (1 - thePct)) + (__m11 * thePct));
		outTransform.matrix.tx = ((_m02 * (1 - thePct)) + (__m02 * thePct));
		outTransform.matrix.ty = ((_m12 * (1 - thePct)) + (__m12 * thePct));
		return (outTransform);
	}

}