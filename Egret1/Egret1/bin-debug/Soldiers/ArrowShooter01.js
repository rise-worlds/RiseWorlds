/**
 *
 * 弓箭手01 动作资源类
 * @author
 *
 */
var ArrowShooter01 = (function (_super) {
    __extends(ArrowShooter01, _super);
    function ArrowShooter01() {
        _super.call(this);
        this.anchorOffsetX = 0.5 * this.width;
        var data = RES.getRes("ArrowShooter01json");
        var texture = RES.getRes("ArrowShooter01png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.movieClipData = mcf.generateMovieClipData("ArrowShooter01");
        this.startLabel = "";
        this.endLabel = "";
        this.idleLabel = "idleDown";
    }
    var d = __define,c=ArrowShooter01,p=c.prototype;
    return ArrowShooter01;
})(ArrowShooterBase);
egret.registerClass(ArrowShooter01,'ArrowShooter01');
//# sourceMappingURL=ArrowShooter01.js.map