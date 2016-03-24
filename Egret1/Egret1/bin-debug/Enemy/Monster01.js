/**
 *
 * 怪物编号01
 * @author
 *
 */
var Monster01 = (function (_super) {
    __extends(Monster01, _super);
    function Monster01() {
        _super.call(this);
        //this.addTexture();
        this.view = new egret.MovieClip();
        this.addChild(this.view);
    }
    var d = __define,c=Monster01,p=c.prototype;
    /**添加纹理 初始化数据*/
    p.addTexture = function (tietu) {
        //获取贴图
        var data = RES.getRes(tietu + "json");
        var texture = RES.getRes(tietu + "png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.view.movieClipData = mcf.generateMovieClipData(tietu);
        this.view.anchorOffsetX = 0.5;
        this.view.x = this.view.width / 2;
        //描点位置
        this.anchorOffsetX = 0.5;
        this.anchorOffsetY = 0.9;
        //血条位置
        this.lifeBar.x = (this.view.width - this.lifeBar.width) / 2;
        this.lifeBar.y = -5;
        //初始不会变化的数值数据
        this.offy = 10;
        this.fireDelay = 1000;
    };
    /**创建*/
    p.onCreate = function () {
        //数据初始化
        this.posArr = [];
        this._pathIndex = 0;
        //状态初始化
        this.timesum = 0;
        this.lifeBar.reSet();
        this.canClear = false;
        this.beKill = false;
        this.beAttack = false;
        this.target = null;
        this.fsm.changeState(stateType.idleState);
        this.curState = stateType.idleState;
    };
    /**初始化 运动路径点*/
    p.init = function (arr, life, speed, damage, value) {
        //属性
        this.hp = this.life = life;
        this._maxSpeed = speed;
        this.damage = damage;
        this.value = value;
        //路径
        this._position.x = this.x = arr[0][0];
        this._position.y = this.y = arr[0][1];
        var i = 1;
        var len = arr.length;
        var v2d;
        //X坐标随机错开
        var offy = Math.round(10 - Math.random() * 20); //Y坐标随机错开
        for (i; i < arr.length; i++) {
            v2d = new Vector2D(arr[i][0], arr[i][1] + offy);
            this.posArr.push(v2d);
        }
        this.fsm.changeState(stateType.moveState);
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
    };
    return Monster01;
})(MonsterBase);
egret.registerClass(Monster01,'Monster01');
//# sourceMappingURL=Monster01.js.map