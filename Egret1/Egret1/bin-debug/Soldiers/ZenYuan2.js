/**
 *
 * 防御士兵01
 * @author
 *
 */
var ZenYuan2 = (function (_super) {
    __extends(ZenYuan2, _super);
    //每次点击生成长度为1的路径寻路点
    function ZenYuan2() {
        _super.call(this);
        //纹理
        this.addTexture();
    }
    var d = __define,c=ZenYuan2,p=c.prototype;
    /**添加纹理 初始化数据*/
    p.addTexture = function () {
        this.anchorOffsetX = 0.5 * this.width;
        this.anchorOffsetY = 1 * this.height;
        //获取纹理
        this.view = new egret.MovieClip();
        this.addChild(this.view);
        var data = RES.getRes("ZenYuan2json");
        var texture = RES.getRes("ZenYuan2png");
        var mcf = new egret.MovieClipDataFactory(data, texture);
        this.view.movieClipData = mcf.generateMovieClipData("ZenYuan2");
        this.view.anchorOffsetX = 0.5 * this.view.width;
        this.view.x = this.view.width / 2;
        //血条位置
        this.lifeBar.x = 27;
        this.lifeBar.y = 5;
        //初始不会变化的数据
        this._maxSpeed = 0.6;
        this.damage = 4;
        this.life = 400;
        this.fireDelay = 1000;
    };
    /**创建-初始化*/
    p.onCreate = function () {
        this.hp = 400;
        this.posArr = [];
        this._pathIndex = 0;
        this.sumTime = 0;
        this.timesum = 0;
        this.lifeBar.reSet();
        this.lifeBar.visible = true;
        this.canClear = false;
        this.atjijie = false;
        this.moveToTarget = false;
        this.fsm.changeState(stateType.idleState);
        this.curState = stateType.idleState;
        //this.view.touchEnabled = true;
        this.view.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.viewSelect, this);
    };
    /**初始化 运动路径点 并移动*/
    p.init = function (arr) {
        this.atjijie = true;
        this._position.x = this.x = arr[0][0];
        this._position.y = this.y = arr[0][1];
        var i = 1;
        var len = arr.length;
        for (i; i < arr.length; i++) {
            this.jijieDian = new Vector2D(arr[i][0] + this.xoffset, arr[i][1] + this.yoffset);
            this.posArr.push(this.jijieDian);
        }
        this.fsm.changeState(stateType.moveState);
    };
    /**设置新的集结点*/
    p.setPoint = function (arr) {
        this.dispatchEvent(new SoldEvent(SoldEvent.MOVE, this, arr));
    };
    /**设置新的路径点 并移动*/
    p.setPath = function (arr) {
        this.atjijie = true;
        this.posArr.length = 0;
        this.jijieDian = new Vector2D(arr[0] + this.xoffset, arr[1] + this.yoffset);
        this.posArr.push(this.jijieDian);
        this.fsm.changeState(stateType.moveState);
        if (this.target == null)
            return;
        if (this.target.target != null) {
            this.target.target = null;
        }
        this.target = null;
        //塔类侦听事件 这里发送消息
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
        this.sumTime += advancedTime;
        if (this.sumTime >= this.totalTime) {
            this.hp = 0;
            this.lifeBar.reSet();
            this.lifeBar.visible = false;
            this.getMoveAngle(90);
            this.sumTime = 0;
        }
    };
    /**鼠标选中对象*/
    p.viewSelect = function (e) {
        //Group.selectItem(this);
    };
    /**销毁*/
    p.onDestroy = function () {
        _super.prototype.onDestroy.call(this);
        this.view.touchEnabled = false;
        //this.view.removeEventListener(egret.TouchEvent.TOUCH_BEGIN,this.viewSelect,this);
    };
    return ZenYuan2;
})(ZenYuanBase);
egret.registerClass(ZenYuan2,'ZenYuan2');
//# sourceMappingURL=ZenYuan2.js.map