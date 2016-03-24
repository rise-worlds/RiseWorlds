/**
 *
 * 弓箭手02 动作资源类
 * @author
 *
 */
var ArrowShooter031 = (function (_super) {
    __extends(ArrowShooter031, _super);
    function ArrowShooter031() {
        _super.call(this);
        this.anchorOffsetX = 0.5;
        var data = RES.getRes("ArrowShooter031json");
        var texture = RES.getRes("ArrowShooter031png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.movieClipData = mcf.generateMovieClipData("ArrowShooter03_1");
        this.startLabel = "";
        this.endLabel = "";
        this.idleLabel = "idleDown";
    }
    var d = __define,c=ArrowShooter031,p=c.prototype;
    return ArrowShooter031;
})(ArrowShooterBase);
egret.registerClass(ArrowShooter031,'ArrowShooter031');
//# sourceMappingURL=ArrowShooter031.js.map