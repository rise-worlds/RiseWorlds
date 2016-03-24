/**
 *
 * 火球类
 * @author
 *
 */
var FireBallBase = (function (_super) {
    __extends(FireBallBase, _super);
    function FireBallBase() {
        _super.call(this);
        /**是否运行过程中*/
        this.isTravel = false;
        /**是否击中目标*/
        this.isHit = false;
        /**是否跟踪目标*/
        this.follow = false;
        /**攻击范围最大半径*/
        this.maxSoldRadius = 40;
        /**攻击范围最小半径*/
        this.minSoldRadius = 30;
        //申明状态机
        this.fsm = new StateMachine(this);
    }
    var d = __define,c=FireBallBase,p=c.prototype;
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
        var v2d = new Vector2D(this.p1.x, this.p1.y);
        this.posArr.push(v2d);
        this.fsm.changeState(stateType.moveState);
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
        //this.rotation = this._angle;
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
    p.hittest = function () {
        //允许攻击角度
        var disx = this.x - this.p1.x < 0 ? this.p1.x - this.x : this.x - this.p1.x;
        var disy = this.y - this.p1.y < 0 ? this.p1.y - this.y : this.y - this.p1.y;
        if (disx <= 1 && disy <= 1) {
            //在椭圆范围内的允许碰撞筛选数组(进入炮弹攻击的范围)
            var i;
            this.atargets = [];
            for (i = 0; i < this.targets.length; i++) {
                var obj = this.targets[i];
                var isin = Utils.containsXY(obj.x, obj.y, this.x, this.y, this.maxSoldRadius, this.ratioSoldY);
                var index = this.atargets.indexOf(obj);
                if (isin && obj.hp > 0) {
                    if (index == -1)
                        this.atargets.push(obj);
                }
                else {
                    if (index != -1)
                        this.atargets.splice(index, 1);
                }
            }
            //范围内敌人扣血
            for (i = 0; i < this.atargets.length; i++) {
                var obj = this.atargets[i];
                obj.hp -= this.damage;
            }
            //击中敌人效果
            this.isHit = true;
        }
    };
    return FireBallBase;
})(VectorElements);
egret.registerClass(FireBallBase,'FireBallBase');
//# sourceMappingURL=FireBallBase.js.map