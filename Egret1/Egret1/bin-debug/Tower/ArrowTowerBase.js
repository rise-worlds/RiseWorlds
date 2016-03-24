/**
 *
 * 箭塔基类
 * @author
 *
 */
var ArrowTowerBase = (function (_super) {
    __extends(ArrowTowerBase, _super);
    function ArrowTowerBase() {
        _super.call(this);
        /**开火延迟*/
        this.fireDelay = 1000;
        /**时间累计*/
        this.timesum = 0;
        /**先左或先右*/
        this.firstst = "R";
        /**音效资源*/
        this.voiceArr = ["arrow_ready1", "arrow_ready2", "arrow_ready3"];
        //播放音效
        var idx = Math.floor(Math.random() * 3);
        SoundManager.playEffect(this.voiceArr[idx]);
    }
    var d = __define,c=ArrowTowerBase,p=c.prototype;
    /**播放射击音效*/
    p.playFireVoice = function () {
        if (Math.random() > 0.5)
            SoundManager.playEffect("arrow_fire1");
        else
            SoundManager.playEffect("arrow_fire2");
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        //筛选数组(进入范围)
        var i;
        this.atargets = [];
        for (i = 0; i < this.targets.length; i++) {
            var obj = this.targets[i];
            if (obj.target == null) {
                var isin = Utils.containsXY(obj.x, obj.y, this.sx, this.sy - 22, this.maxRadius, this.ratioY);
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
        }
        //排序、敌人的攻击对象不为null时则排到末尾
        for (i = 0; i < this.targets.length; i++) {
            var obj = this.targets[i];
            if (obj.target != null) {
                var isin = Utils.containsXY(obj.x, obj.y, this.sx, this.sy - 22, this.maxRadius, this.ratioY);
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
        }
    };
    return ArrowTowerBase;
})(TowerBase);
egret.registerClass(ArrowTowerBase,'ArrowTowerBase');
//# sourceMappingURL=ArrowTowerBase.js.map