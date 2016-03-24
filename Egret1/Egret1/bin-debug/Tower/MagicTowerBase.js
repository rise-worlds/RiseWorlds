/**
 *
 * @author
 *
 */
var MagicTowerBase = (function (_super) {
    __extends(MagicTowerBase, _super);
    function MagicTowerBase() {
        _super.call(this);
        /**开火延迟*/
        this.fireDelay = 1000;
        /**时间累计*/
        this.timesum = 0;
        /**是否开火*/
        this.isfire = false;
        /**音效资源*/
        this.voiceArr = ["magic_ready1", "magic_ready2", "magic_ready3"];
        //播放音效
        var idx = Math.floor(Math.random() * 3);
        SoundManager.playEffect(this.voiceArr[idx]);
    }
    var d = __define,c=MagicTowerBase,p=c.prototype;
    /**播放射击音效*/
    p.playFireVoice = function () {
        //if(Math.random() > 0.5)
        SoundManager.playEffect("magic_fire1");
        //else
        //SoundManager.playEffect("magic_fire2");
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
                if (isin) {
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
                if (isin) {
                    if (index == -1)
                        this.atargets.push(obj);
                }
                else {
                    if (index != -1)
                        this.atargets.splice(index, 1);
                }
            }
        }
        //进入范围敌人数组为空则直接返回
        //if(this.atargets.length == 0) {
        //this.timesum = this.fireDelay;
        //return;
        //}    
        //取进入范围数组第一个
        //this.target = this.atargets[0];
        //确定敌人方向
        //if(this.target.y <= this.sy - 22) {
        //this.direct = "up";
        //}
        //if(this.target.y > this.sy - 22) {
        //this.direct = "down";
        //}
    };
    return MagicTowerBase;
})(TowerBase);
egret.registerClass(MagicTowerBase,'MagicTowerBase');
//# sourceMappingURL=MagicTowerBase.js.map