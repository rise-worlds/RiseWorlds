/**
 *
 * 法师01
 * @author
 *
 */
var MagicWizard010203 = (function (_super) {
    __extends(MagicWizard010203, _super);
    function MagicWizard010203() {
        _super.call(this);
        this.anchorOffsetX = 0.5;
        var data = RES.getRes("MagicWizard010203json");
        var texture = RES.getRes("MagicWizard010203png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.movieClipData = mcf.generateMovieClipData("MagicWizard010203");
        this.stateLabel = "idleDown";
        this.idleLabel = "idleDown";
    }
    var d = __define,c=MagicWizard010203,p=c.prototype;
    return MagicWizard010203;
})(MagicWizardBase);
egret.registerClass(MagicWizard010203,'MagicWizard010203');
//# sourceMappingURL=MagicWizard010203.js.map