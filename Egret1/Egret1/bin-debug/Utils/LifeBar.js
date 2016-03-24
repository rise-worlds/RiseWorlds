/**
 *
 * 血条
 * @author
 *
 */
var LifeBar = (function (_super) {
    __extends(LifeBar, _super);
    function LifeBar() {
        _super.call(this);
        this.bg = Utils.createBitmapByName("lifeBarBg");
        this.addChild(this.bg);
        this.bar = Utils.createBitmapByName("lifeBar");
        this.addChild(this.bar);
        this.bar.x = this.bar.y = 1;
        this.cacheAsBitmap = true;
    }
    var d = __define,c=LifeBar,p=c.prototype;
    p.setProgress = function (hp, life) {
        var num = 18 * hp / life;
        var per = num < 0 ? 0 : num;
        this.bar.width = per;
    };
    p.reSet = function () {
        this.bar.width = 18;
    };
    return LifeBar;
})(egret.Sprite);
egret.registerClass(LifeBar,'LifeBar');
//# sourceMappingURL=LifeBar.js.map