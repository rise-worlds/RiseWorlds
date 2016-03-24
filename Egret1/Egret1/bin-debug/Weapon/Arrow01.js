/**
 *
 * 弓箭01
 * @author
 *
 */
var Arrow01 = (function (_super) {
    __extends(Arrow01, _super);
    function Arrow01() {
        _super.call(this);
        //获取纹理
        this.view = new egret.MovieClip();
        this.addChild(this.view);
        this.anchorOffsetY = 0.5;
        var data = RES.getRes("Arrow01json");
        var texture = RES.getRes("Arrow01png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.view.movieClipData = mcf.generateMovieClipData("Arrow01");
        //设置数据属性
        this.damage = 1;
    }
    var d = __define,c=Arrow01,p=c.prototype;
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
        this.offy = offy;
        this.setTarget(this.target.x, this.target.y - this.offy);
        this.follow = true;
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
    };
    return Arrow01;
})(ArrowBase);
egret.registerClass(Arrow01,'Arrow01');
//# sourceMappingURL=Arrow01.js.map