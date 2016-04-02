/**
 *
 * 地基02
 * @author
 *
 */
var Base02 = (function (_super) {
    __extends(Base02, _super);
    function Base02() {
        _super.call(this);
        this.cacheAsBitmap = true;
        var bm = Utils.createBitmapByName("Base02");
        this.anchorOffsetX = 0.5 * this.width;
        this.anchorOffsetY = 1 * this.height;
        this.addChild(bm);
    }
    var d = __define,c=Base02,p=c.prototype;
    p.onEnterFrame = function (advancedTime) {
    };
    return Base02;
})(Base);
egret.registerClass(Base02,'Base02');
//# sourceMappingURL=Base02.js.map