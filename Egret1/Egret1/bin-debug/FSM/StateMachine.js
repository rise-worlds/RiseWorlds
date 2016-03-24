/**
 *
 * 状态机
 *
 */
//若有冲突考虑添加donothing状态
var stateType;
(function (stateType) {
    stateType[stateType["idleState"] = 0] = "idleState";
    stateType[stateType["moveState"] = 1] = "moveState";
    stateType[stateType["moveEndState"] = 2] = "moveEndState";
    stateType[stateType["fightState"] = 3] = "fightState";
    stateType[stateType["fightEndState"] = 4] = "fightEndState";
    stateType[stateType["deadState"] = 5] = "deadState";
    stateType[stateType["deadEndState"] = 6] = "deadEndState";
})(stateType || (stateType = {}));
;
var StateMachine = (function () {
    /**自身实例*/
    //private static instance: StateMachine;
    /**构造函数*/
    function StateMachine(obj) {
        this._obj = obj;
    }
    var d = __define,c=StateMachine,p=c.prototype;
    /**改变状态*/
    p.changeState = function (state) {
        this._curState = state;
    };
    /**实时刷新*/
    p.onEnterFrame = function (advancedTime) {
        switch (this._curState) {
            case stateType.idleState:
                if (this._obj.isIdle()) {
                    this._obj.idling();
                }
                break;
            case stateType.moveState:
                if (this._obj.isMove()) {
                    this._obj.moving();
                }
                break;
            case stateType.moveEndState:
                this._obj.movingEnd();
                break;
            case stateType.fightState:
                if (this._obj.isFighting()) {
                    this._obj.fighting();
                }
                break;
            case stateType.fightEndState:
                this._obj.fightingEnd();
                break;
            case stateType.deadState:
                if (this._obj.isDead()) {
                    this._obj.dying();
                }
                break;
            case stateType.deadEndState:
                this._obj.dyingEnd();
                break;
            default:
                break;
        }
    };
    d(p, "curState"
        /**当前状态读取器*/
        ,function () {
            return this._curState;
        }
    );
    return StateMachine;
})();
egret.registerClass(StateMachine,'StateMachine');
//# sourceMappingURL=StateMachine.js.map