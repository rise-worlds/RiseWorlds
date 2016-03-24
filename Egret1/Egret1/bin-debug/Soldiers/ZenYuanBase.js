/**
 *
 * 怪物基类
 * @author
 *
 */
var ZenYuanBase = (function (_super) {
    __extends(ZenYuanBase, _super);
    function ZenYuanBase() {
        _super.call(this);
        /**是否移动到目标*/
        this.moveToTarget = false;
        /**开火延迟*/
        this.fireDelay = 0;
        /**时间累计*/
        this.timesum = 0;
        //相对于集结点的偏移量
        this.xoffset = 0;
        this.yoffset = 0;
        /**是否在集结点*/
        this.atjijie = false;
        /**攻击范围最大半径*/
        this.maxSoldRadius = 60;
        /**攻击范围最小半径*/
        this.minSoldRadius = 40;
        /**存在时间*/
        this.sumTime = 0;
        this.totalTime = 30000;
        /**攻击音效数组*/
        this.voiceArr = ["shield_fire1", "shield_fire2", "shield_fire3"];
        this.ratioSoldY = this.minSoldRadius / this.maxSoldRadius;
        //申明状态机
        this.fsm = new StateMachine(this);
        //血条
        this.lifeBar = new LifeBar();
        this.addChild(this.lifeBar);
    }
    var d = __define,c=ZenYuanBase,p=c.prototype;
    /**设置新的路径点 并移动*/
    p.setPath2 = function (v2d) {
        this.posArr.length = 0;
        this.posArr.push(v2d);
        this.fsm.changeState(stateType.moveState);
        //塔类侦听事件 这里发送消息
    };
    /**检测生命*/
    p.live = function () {
        if (this._hp <= 0) {
            this.fsm.changeState(stateType.deadState);
        }
        if (this._hp > this.life) {
            this._hp = this.life;
        }
    };
    d(p, "hp"
        ,function () {
            return this._hp;
        }
        /**生命值变动*/
        ,function (value) {
            this._hp = value;
            this.live();
            this.lifeBar.setProgress(this._hp, this.life);
        }
    );
    /**销毁*/
    p.onDestroy = function () {
        _super.prototype.onDestroy.call(this);
        if (this.target != null) {
            this.target.target = null;
            this.target = null;
        }
    };
    /**碰撞检测*/
    p.hittest = function () {
        if (this.target != null) {
            this.target.hp -= this.damage;
            if (this.target.hp <= 0) {
                var idx = this.targets.indexOf(this.target);
                if (idx != -1)
                    this.targets.splice(idx, 1);
                idx = this.atargets.indexOf(this.target);
                if (idx != -1)
                    this.atargets.splice(idx, 1);
                this.target.target = null;
                this.target = null;
            }
        }
    };
    /**-----------------------------------------------------------------帧事件----------------------------------------------------------------------*/
    p.onEnterFrame = function (advancedTime) {
        //攻击间隔
        this.timesum += advancedTime;
        //状态刷新
        this.fsm.onEnterFrame(advancedTime);
        //向量刷新(移动)
        _super.prototype.onEnterFrame.call(this, advancedTime);
        //clear
        if (this.canClear) {
            ObjectPool.getInstance().destroyObject(this);
        }
    };
    /**移动方向判断*/
    p.getMoveAngle = function (_angle) {
        //设置起始标签
        if (_angle >= 0 && _angle <= 90 || _angle >= 270 && _angle <= 360) {
            this.stateLabel = "running";
            this.view.scaleX = 1;
        }
        else if (_angle > 90 && _angle < 270) {
            this.stateLabel = "running";
            this.view.scaleX = -1;
        }
    };
    ////////////////////////////////状态执行
    /**闲置中*/
    p.idling = function () {
        if (!(this.curState == stateType.idleState)) {
            this.curState = stateType.idleState;
            this.view.gotoAndStop(this.stateLabel);
        }
        //闲置中判断敌人!=null 若进入攻击范围则切换到攻击状态 否则切换到移动状态移动到能攻击敌人的范围 若敌人==null 则回到集结点
        this.moveOrFight();
    };
    /**移动中*/
    p.moving = function () {
        //移动角度判断
        this.getMoveAngle(this._angle);
        if (!(this.curState == stateType.moveState)) {
            this.curState = stateType.moveState;
            this.view.gotoAndPlay(this.stateLabel);
        }
        this.checkLast(this.stateLabel);
    };
    /**移动完毕*/
    p.movingEnd = function () {
        if (!(this.curState == stateType.moveEndState)) {
            this.curState = stateType.moveEndState;
            this.fsm.changeState(stateType.idleState); //本方这句
        }
    };
    /**攻击中*/
    p.fighting = function () {
        if (!(this.curState == stateType.fightState)) {
            this.curState = stateType.fightState;
            this.view.gotoAndPlay(this.stateLabel);
            //攻击方向
            if (this.target != null) {
                if (this.x <= this.target.x) {
                    this.view.scaleX = 1;
                }
                else {
                    this.view.scaleX = -1;
                }
            }
            //播放攻击音效
            var idx = Math.floor(Math.random() * 3);
            SoundManager.playEffect(this.voiceArr[idx]);
        }
        this.checkLastEnd(this.stateLabel);
    };
    /**攻击完毕-碰撞检测*/
    p.fightingEnd = function () {
        if (!(this.curState == stateType.fightEndState)) {
            this.curState = stateType.fightEndState;
            //console.log("hittest");
            this.hittest();
            this.timesum = 0;
        }
        //攻击完毕敌人若死亡切换到闲置状态
        if (this.target == null) {
            //若敌人数组为[]则回到集结点
            //if(this.targets.length == 0) {
            //this.setPath2(this.jijieDian);
            //} else {
            this.fsm.changeState(stateType.idleState);
        }
        else {
            //循环攻击
            if (this.timesum >= this.fireDelay) {
                this.fsm.changeState(stateType.fightState);
                this.timesum = 0;
            }
        }
    };
    /**死亡中*/
    p.dying = function () {
        if (!(this.curState == stateType.deadState)) {
            this.curState = stateType.deadState;
            this.view.gotoAndPlay(this.stateLabel);
        }
        this.checkLastEnd(this.stateLabel);
    };
    /**死亡完毕-可以消除*/
    p.dyingEnd = function () {
        if (!(this.curState == stateType.deadEndState)) {
            this.curState = stateType.deadEndState;
            //console.log("士兵canClear");
            this.canClear = true;
        }
    };
    /**循环播放检查*/
    p.checkLast = function (str) {
        var nextFrameNum = this.view.currentFrame + 1;
        //var mz: string = this.view.getFrameLabelByFrame(nextFrameNum).name;
        var mz = this.view.movieClipData.frames[nextFrameNum].name;
        if (mz != str) {
            this.view.gotoAndPlay(str);
        }
    };
    /**播放结束检查*/
    p.checkLastEnd = function (str) {
        var nextFrameNum = this.view.currentFrame + 1;
        //var mz: string = this.view.getFrameLabelByFrame(nextFrameNum).name;
        var mz = this.view.movieClipData.frames[nextFrameNum].name;
        if (mz != str || this.view.currentFrame >= this.view.totalFrames) {
            this.view.stop();
            if (this.curState == stateType.fightState) {
                this.fsm.changeState(stateType.fightEndState);
            }
            else if (this.curState == stateType.deadState) {
                this.fsm.changeState(stateType.deadEndState);
            }
        }
    };
    ////////////////////////////////状态切换
    /**闲置*/
    p.isIdle = function () {
        this.stateLabel = "idle";
        return true;
    };
    /**移动*/
    p.isMove = function () {
        //this.stateLabel = "walking";
        return true;
    };
    /**攻击*/
    p.isFighting = function () {
        this.stateLabel = "fighting";
        return true;
    };
    /**死亡*/
    p.isDead = function () {
        this.stateLabel = "dead";
        return true;
    };
    ////////////////////////////////状态判断
    /**闲置中判断敌人!=null 且若进入攻击范围则切换到攻击状态 否则切换到移动状态移动到能攻击敌人的范围 若敌人==null 则回到集结点*/
    p.moveOrFight = function () {
        //获取目标敌人 互设目标
        this.getTarget();
        //移动到和攻击目标
        if (this.target != null) {
            //移动到目标地点
            if (!this.moveToTarget) {
                this.moveToTarget = true;
                this.target.beAttack = false;
                //判断x,y距离
                var tx;
                var ty;
                if (this.target.x < this.x)
                    tx = this.target.x + 16;
                else
                    tx = this.target.x - 16;
                ty = this.target.y;
                this.atjijie = false;
                this.setPath2(new Vector2D(tx, ty));
            }
            else {
                this.moveToTarget = false;
                //移动完毕后攻击
                this.fsm.changeState(stateType.fightState);
                this.target.beAttack = true;
            }
        }
        else {
            this.moveToTarget = false;
            //若敌人数组为0且没在集结点则回到集结点
            //是否移动中判断
            if (this.atargets.length == 0) {
                if (!this.atjijie) {
                    this.atjijie = true;
                    this.setPath2(this.jijieDian);
                }
            }
        }
    };
    //寻找敌人
    p.getTarget = function () {
        //筛选数组(进入士兵攻击的范围)
        var i;
        this.atargets = [];
        for (i = 0; i < this.targets.length; i++) {
            var obj = this.targets[i];
            var isin = Utils.containsXY(obj.x, obj.y, this.x, this.y, this.maxSoldRadius, this.ratioSoldY);
            var index = this.atargets.indexOf(obj);
            if (isin) {
                if (index == -1)
                    this.atargets.push(obj);
            }
            else {
                if (index != -1)
                    this.atargets.splice(index, 1);
            }
        }
        //互设目标
        var j;
        var tarlen = this.atargets.length;
        if (tarlen > 0) {
            if (this.target == null) {
                for (j = 0; j < tarlen; j++) {
                    var tar = this.atargets[j];
                    if (tar.target == null) {
                        tar.target = this;
                        this.target = tar;
                        break;
                    }
                }
            }
        }
    };
    return ZenYuanBase;
})(VectorElements);
egret.registerClass(ZenYuanBase,'ZenYuanBase',["ILife"]);
//# sourceMappingURL=ZenYuanBase.js.map