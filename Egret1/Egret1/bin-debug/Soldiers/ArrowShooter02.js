/**
 *
 * 弓箭手02 动作资源类
 * @author
 *
 */
var ArrowShooter02 = (function (_super) {
    __extends(ArrowShooter02, _super);
    function ArrowShooter02() {
        _super.call(this);
        this.anchorOffsetX = 0.5 * this.width;
        var data = RES.getRes("ArrowShooter02json");
        var texture = RES.getRes("ArrowShooter02png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.movieClipData = mcf.generateMovieClipData("ArrowShooter02");
        this.startLabel = "";
        this.endLabel = "";
        this.idleLabel = "idleDown";
    }
    var d = __define,c=ArrowShooter02,p=c.prototype;
    return ArrowShooter02;
})(ArrowShooterBase);
egret.registerClass(ArrowShooter02,'ArrowShooter02');
//# sourceMappingURL=ArrowShooter02.js.map