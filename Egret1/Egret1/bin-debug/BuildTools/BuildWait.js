/**
 *
 * 建造等待动画
 * @author
 *
 */
var BuildWait = (function (_super) {
    __extends(BuildWait, _super);
    function BuildWait(name) {
        _super.call(this);
        this.buildType = { "ArrowTower01": "building1", "ShieldTower01": "building2", "MagicTower01": "building3", "ExploTower01": "building4" };
        this.anchorOffsetX = 0.5 * this.width;
        this.anchorOffsetY = 1 * this.height;
        var res = this.buildType[name];
        this.bm = Utils.createBitmapByName(res);
        this.addChild(this.bm);
        this.bm = Utils.createBitmapByName("buildbarbg");
        this.bm.x = 23;
        this.bm.y = 23;
        this.addChild(this.bm);
        this.bm = Utils.createBitmapByName("buildbartop");
        this.bm.x = 24;
        this.bm.y = 24;
        this.bm.width = 1; //37
        this.addChild(this.bm);
        this.building();
        //播放音效
        SoundManager.playEffect("building");
    }
    var d = __define,c=BuildWait,p=c.prototype;
    p.building = function () {
        var that = this;
        TweenLite.to(this.bm, 1.5, { width: 37, ease: Linear.easeNone, onComplete: function () {
                that.dispatchEvent(new ToolEvent(ToolEvent.BUILD_COMP));
            }
        });
    };
    return BuildWait;
})(egret.Sprite);
egret.registerClass(BuildWait,'BuildWait');
//# sourceMappingURL=BuildWait.js.map