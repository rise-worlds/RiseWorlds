/**
 *
 * 炮弹01
 * @author
 *
 */
var Explo031 = (function (_super) {
    __extends(Explo031, _super);
    function Explo031() {
        _super.call(this);
        this.ratioSoldY = this.minSoldRadius / this.maxSoldRadius;
        //获取纹理
        this.view = new egret.MovieClip();
        this.addChild(this.view);
        this.anchorOffsetX = 0.5 * this.width;
        this.anchorOffsetY = 1 * this.height;
        var data = RES.getRes("Explo031json");
        var texture = RES.getRes("Explo031png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.view.movieClipData = mcf.generateMovieClipData("Explo03_1");
        this.view.anchorOffsetX = 0.5 * this.view.width;
        this.view.x = this.view.width / 2;
        this.view.anchorOffsetY = 1 * this.view.height;
        this.view.y = this.view.height;
        //设置数据属性
        this.damage = 1;
    }
    var d = __define,c=Explo031,p=c.prototype;
    /**创建-初始化*/
    p.onCreate = function () {
        this.canClear = false;
        this.isHit = false;
        this.follow = false;
        this.isMiss = false;
        this.target = null;
        this.view.gotoAndStop(1);
        this.t0 = 0;
        this.xSpeed = 0;
        this.ySpeed = 0;
        this.pos = null;
    };
    /**数据初始化 起始坐标 目标对象*/
    p.init = function (p1, tar, offy) {
        //设置目标状态
        this.x = p1.x;
        this.y = p1.y;
        this.p1 = p1;
        this.target = tar;
        this.offy = 0;
        this.setTarget(this.target.x, this.target.y - this.offy);
        this.follow = true;
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
    };
    return Explo031;
})(ExploBase);
egret.registerClass(Explo031,'Explo031');
//# sourceMappingURL=Explo031.js.map