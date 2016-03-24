/**
 *
 * 2D向量类
 * @author
 *
 */
var Vector2D = (function () {
    /**
    * Constructor.
    */
    function Vector2D(x, y) {
        if (x === void 0) { x = 0; }
        if (y === void 0) { y = 0; }
        this._x = x;
        this._y = y;
    }
    var d = __define,c=Vector2D,p=c.prototype;
    /**
    * Can be used to visualize the vector. Generally used for debug purposes only.
    * @param graphics The Graphics instance to draw the vector on.
    * @param color The color of the line used to represent the vector.
    */
    p.draw = function (graphics, color) {
        if (color === void 0) { color = 0; }
        graphics.lineStyle(0, color);
        graphics.moveTo(0, 0);
        graphics.lineTo(this._x, this._y);
    };
    /**
    * 拷贝向量
    */
    p.clone = function () {
        return new Vector2D(this.x, this.y);
    };
    /**
    * 将当前向量变为0向量
    */
    p.zero = function () {
        this._x = 0;
        this._y = 0;
        return this;
    };
    /**
    * 判断是否是0向量
    */
    p.isZero = function () {
        return this._x == 0 && this._y == 0;
    };
    d(p, "length"
        ,function () {
            return Math.sqrt(this.lengthSQ);
        }
        /**
        * 设置/获取向量大小
        */
        ,function (value) {
            var a = this.angle;
            this._x = Math.cos(a) * value;
            this._y = Math.sin(a) * value;
        }
    );
    d(p, "lengthSQ"
        /**
        * 获取当前向量平方
        */
        ,function () {
            return this._x * this._x + this._y * this._y;
        }
    );
    d(p, "angle"
        ,function () {
            return Math.atan2(this._y, this._x);
        }
        /**
        * 设置/获取 角度
        */
        ,function (value) {
            var len = this.length;
            this._x = Math.cos(value) * len;
            this._y = Math.sin(value) * len;
        }
    );
    /**
    * 将当前向量转化成单位向量
    */
    p.normalize = function () {
        if (this.length == 0) {
            this._x = 1;
            return this;
        }
        var len = this.length;
        this._x /= len;
        this._y /= len;
        return this;
    };
    /**
    * 截取当前向量
    */
    p.truncate = function (max) {
        this.length = Math.min(max, this.length);
        return this;
    };
    /**
    * 反转向量
    */
    p.reverse = function () {
        this._x = -this._x;
        this._y = -this._y;
        return this;
    };
    /**
    * 判断当前向量是否是单位向量
    */
    p.isNormalized = function () {
        return this.length == 1.0;
    };
    /**
    * 向量积
    */
    p.dotProd = function (v2) {
        return this._x * v2.x + this._y * v2.y;
    };
    /**
    * 判断两向量是否垂直
    */
    p.crossProd = function (v2) {
        return this._x * v2.y - this._y * v2.x;
    };
    /**
    * 返回两向量夹角的弦度值
    */
    Vector2D.angleBetween = function (v1, v2) {
        if (!v1.isNormalized())
            v1 = v1.clone().normalize();
        if (!v2.isNormalized())
            v2 = v2.clone().normalize();
        return Math.acos(v1.dotProd(v2));
    };
    /**
    * 返回向量的符号值
    */
    p.sign = function (v2) {
        return this.perp.dotProd(v2) < 0 ? -1 : 1;
    };
    d(p, "perp"
        /**
        * 返回坐标向量
        */
        ,function () {
            return new Vector2D(-this.y, this.x);
        }
    );
    /**
    * 返回当前向量与V2的距离
    */
    p.dist = function (v2) {
        return Math.sqrt(this.distSQ(v2));
    };
    /**
    * 返回当前向量与V2的距离的平方
    */
    p.distSQ = function (v2) {
        var dx = v2.x - this.x;
        var dy = v2.y - this.y;
        return dx * dx + dy * dy;
    };
    /**
    * 两向量相加
    */
    p.add = function (v2) {
        return new Vector2D(this._x + v2.x, this._y + v2.y);
    };
    /**
    * 两向量相减
    */
    p.subtract = function (v2) {
        return new Vector2D(this._x - v2.x, this._y - v2.y);
    };
    /**
    * 数与向量的乘积
    */
    p.multiply = function (value) {
        return new Vector2D(this._x * value, this._y * value);
    };
    /**
    * 数与向量的商
    */
    p.divide = function (value) {
        return new Vector2D(this._x / value, this._y / value);
    };
    /**
    * 判断两向量是否相等
    */
    p.equals = function (v2) {
        return this._x == v2.x && this._y == v2.y;
    };
    d(p, "x"
        ,function () {
            return this._x;
        }
        /**
        * Sets / gets the x value of this vector.
        */
        ,function (value) {
            this._x = value;
        }
    );
    d(p, "y"
        ,function () {
            return this._y;
        }
        /**
        * Sets / gets the y value of this vector.
        */
        ,function (value) {
            this._y = value;
        }
    );
    /**
    * Generates a string representation of this vector.
    * @return string A description of this vector.
    */
    p.tostring = function () {
        return "[Vector2D (x:" + this._x + ", y:" + this._y + ")]";
    };
    return Vector2D;
})();
egret.registerClass(Vector2D,'Vector2D');
//# sourceMappingURL=Vector2D.js.map