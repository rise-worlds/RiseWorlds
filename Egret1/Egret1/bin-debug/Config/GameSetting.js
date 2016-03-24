/**
 *
 *配置类
 * @author
 *
 */
var GameSetting = (function () {
    function GameSetting() {
    }
    var d = __define,c=GameSetting,p=c.prototype;
    /**舞台宽高*/
    GameSetting.swid = 800;
    GameSetting.shei = 480;
    /**玩家获得金星 用于升级塔、解锁英雄、升级英雄属性*/
    GameSetting.goldStar = 0;
    return GameSetting;
})();
egret.registerClass(GameSetting,'GameSetting');
//# sourceMappingURL=GameSetting.js.map