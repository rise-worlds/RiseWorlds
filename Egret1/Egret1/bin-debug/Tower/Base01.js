/**
 *
 * 地基01
 * @author
 *
 */
var Base01 = (function (_super) {
    __extends(Base01, _super);
    function Base01() {
        _super.call(this);
        this.cacheAsBitmap = true;
        var bm = Utils.createBitmapByName("empty01");
        this.anchorOffsetX = 0.5;
        this.anchorOffsetY = 1;
        this.addChild(bm);
    }
    var d = __define,c=Base01,p=c.prototype;
    p.onEnterFrame = function (advancedTime) {
    };
    return Base01;
})(Base);
egret.registerClass(Base01,'Base01');
//# sourceMappingURL=Base01.js.map