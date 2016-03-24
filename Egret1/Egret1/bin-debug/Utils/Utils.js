/**
 *
 * 工具箱
 * @author
 *
 */
var Utils = (function () {
    function Utils() {
    }
    var d = __define,c=Utils,p=c.prototype;
    /**
    * 根据name关键字创建一个Bitmap对象。name属性请参考resources/resource.json配置文件的内容。
    */
    Utils.createBitmapByName = function (name) {
        var result = new egret.Bitmap();
        var texture = RES.getRes(name);
        result.texture = texture;
        return result;
    };
    /**
    * 检测是否进入椭圆范围
    * @param px             被检测点x坐标
    * @param py             被检测点y坐标
    * @param cx             椭圆圆心x坐标
    * @param cy             椭圆圆心y坐标
    * @param r              椭圆最大半径
    * @param sy             将圆沿y轴压扁变为椭圆时候的比例
    * @return               是否包含在椭圆中
    */
    Utils.containsXY = function (px, py, cx, cy, r, sy) {
        if (sy === void 0) { sy = 0.5; }
        var dx = px - cx;
        var dy = py - cy;
        dy /= sy;
        if (Math.sqrt(dx * dx + dy * dy) < r) {
            return true;
        }
        return false;
    };
    Utils.containsXY2 = function (px, py) {
        if (px > 40 && px < GameSetting.swid - 80 && py > 40 && py < GameSetting.shei - 80) {
            return true;
        }
        else {
            return false;
        }
    };
    /**
     * 画椭圆
     */
    Utils.drawEllipse = function (wid, hei, color, fill) {
        if (fill === void 0) { fill = false; }
        var sp = new egret.Shape();
        sp.graphics.lineStyle(1, color);
        /*
        if(fill){
            //sp.graphics.beginFill(color,0.05);
            //绘制放射状渐变填充
            var fillType:string = egret.GradientType.RADIAL;
            var colors:number[] = [color,color];
            var alphas:number[] = [0,0.5];
            var ratios:number[] = [200,255];
            var matr:egret.Matrix = new egret.Matrix();
            matr.createGradientBox(wid, hei, 0, 0, 0);
            sp.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr);
        }
        */
        sp.graphics.drawEllipse(0, 0, wid, hei);
        sp.graphics.endFill();
        return sp;
    };
    /*
    * 对象冒泡排序
    */
    Utils.sortarr = function (arr) {
        var tmp;
        for (var i = 0; i < arr.length; i++) {
            for (var j = arr.length - 1; j > i; j--) {
                if (arr[j].y < arr[j - 1].y) {
                    tmp = arr[j];
                    arr[j] = arr[j - 1];
                    arr[j - 1] = tmp;
                }
            }
        }
        return arr;
    };
    return Utils;
})();
egret.registerClass(Utils,'Utils');
//# sourceMappingURL=Utils.js.map