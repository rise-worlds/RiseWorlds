/**
 *
 * 弓箭手02 动作资源类
 * @author
 *
 */
var ArrowShooter032 = (function (_super) {
    __extends(ArrowShooter032, _super);
    function ArrowShooter032() {
        _super.call(this);
        this.anchorOffsetX = 0.5;
        var data = RES.getRes("ArrowShooter032json");
        var texture = RES.getRes("ArrowShooter032png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.movieClipData = mcf.generateMovieClipData("ArrowShooter03_2");
        this.startLabel = "";
        this.endLabel = "";
        this.idleLabel = "idleDown";
    }
    var d = __define,c=ArrowShooter032,p=c.prototype;
    return ArrowShooter032;
})(ArrowShooterBase);
egret.registerClass(ArrowShooter032,'ArrowShooter032');
//# sourceMappingURL=ArrowShooter032.js.map