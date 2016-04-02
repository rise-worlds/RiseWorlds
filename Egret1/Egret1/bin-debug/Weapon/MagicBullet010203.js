/**
 *
 * @author
 *
 */
var MagicBullet010203 = (function (_super) {
    __extends(MagicBullet010203, _super);
    function MagicBullet010203() {
        _super.call(this);
        //获取纹理
        this.view = new egret.MovieClip();
        this.addChild(this.view);
        this.anchorOffsetX = this.anchorOffsetY = 0.5 * this.width;
        var data = RES.getRes("MagicBullet010203json");
        var texture = RES.getRes("MagicBullet010203png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.view.movieClipData = mcf.generateMovieClipData("MagicBullet010203");
        //设置数据属性
        //this.damage = 100;
    }
    var d = __define,c=MagicBullet010203,p=c.prototype;
    /**创建-初始化*/
    p.onCreate = function () {
        this.canClear = false;
        this.isHit = false;
        this.follow = false;
        this.isTravel = true;
        this.target = null;
        this._maxSpeed = 2;
        this.fsm.changeState(stateType.idleState);
        this.curState = stateType.idleState;
    };
    /**初始化 运动路径点 并移动*/
    p.init = function (p1, tar) {
        this.target = tar;
        this._position.x = this.x = p1.x;
        this._position.y = this.y = p1.y;
        this.setPosArr();
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
    };
    return MagicBullet010203;
})(MagicBulletBase);
egret.registerClass(MagicBullet010203,'MagicBullet010203');
//# sourceMappingURL=MagicBullet010203.js.map