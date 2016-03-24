/**
 *
 * 弓箭基类
 * @author
 *
 */
var MagicBulletBase = (function (_super) {
    __extends(MagicBulletBase, _super);
    function MagicBulletBase() {
        _super.call(this);
        /**是否运行过程中*/
        this.isTravel = false;
        /**是否击中目标*/
        this.isHit = false;
        /**是否跟踪目标*/
        this.follow = false;
        //申明状态机
        this.fsm = new StateMachine(this);
    }
    var d = __define,c=MagicBulletBase,p=c.prototype;
    /**刷新*/
    p.update = function () {
        if (this.follow) {
        }
    };
    /**闲置中*/
    p.idling = function () {
        if (!(this.curState == stateType.idleState)) {
            this.curState = stateType.idleState;
        }
    };
    /**移动中*/
    p.moving = function () {
        //移动角度判断
        //this.getMoveAngle(this._angle);
        if (!(this.curState == stateType.moveState)) {
            this.curState = stateType.moveState;
        }
        this.setPosArr();
    };
    /**移动完毕*/
    p.movingEnd = function () {
        if (!(this.curState == stateType.moveEndState)) {
            this.curState = stateType.moveEndState;
            this.fsm.changeState(stateType.idleState); //本方这句
            //console.log("arrive");
            this.hittest();
        }
    };
    /**闲置*/
    p.isIdle = function () {
        //console.log("isIdle");
        return true;
    };
    /**移动*/
    p.isMove = function () {
        //console.log("isMove");
        return true;
    };
    p.setPosArr = function () {
        this._pathIndex = 0;
        this.posArr.length = 0;
        var v2d = new Vector2D(this.target.x, this.target.y - this.target.offy);
        this.posArr.push(v2d);
        this.fsm.changeState(stateType.moveState);
    };
    /**移动
    public move() {
        var dx: number = this.target.x - this.x;
        var dy: number = this.target.y - this.offy - this.y;
        this.x += dx / 6;
        this.y += dy / 6;
        this.angel = Math.atan2(dy,dx);
        this.rotation = this.angel * 180 / Math.PI;
    }
     */
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
        this.rotation = this._angle;
        //状态刷新
        this.fsm.onEnterFrame(advancedTime);
        //刷新
        this.update();
        //旅行
        if (this.isTravel) {
            this.view.gotoAndPlay("travel");
            this.isTravel = false;
        }
        //击中
        if (this.isHit) {
            this.view.gotoAndPlay("hit");
            this.isHit = false;
        }
        //播放完成
        if (this.view.currentLabel == "hitEnd") {
            this.canClear = true;
        }
        if (this.view.currentLabel == "travelEnd") {
            this.view.gotoAndPlay("travel");
        }
        //销毁
        if (this.canClear) {
            ObjectPool.getInstance().destroyObject(this);
        }
    };
    /**碰撞检测*/
    //根据坐标差值检测？
    //设置一个小的rectangle 优先尝试
    p.hittest = function () {
        //允许攻击角度
        //if(this.angle >= 0 && this.angle <= 180)
        //return;
        //
        //var disx: number = this.x - this.target.x < 0 ? this.target.x - this.x : this.x - this.target.x;
        //var disy: number = this.y - this.target.y-this.target.offy < 0 ? this.target.y-this.target.offy - this.y : this.y - this.target.y-this.target.offy;
        // if(disx <= 4 && disy <= 4) {//精确到1个像素内
        if (HitTest.hitTestRect(this, this.target)) {
            this.target.hp -= this.damage;
            //console.log(this.target.hp);
            this.isHit = true; //击中敌人效
            this.follow = false;
        }
        // }
    };
    return MagicBulletBase;
})(VectorElements);
egret.registerClass(MagicBulletBase,'MagicBulletBase');
//# sourceMappingURL=MagicBulletBase.js.map