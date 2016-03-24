/**
 *
 * 关卡数据
 * @author
 *
 */
var GuanKaConfig = (function () {
    function GuanKaConfig() {
    }
    var d = __define,c=GuanKaConfig,p=c.prototype;
    /**获取关卡状态*/
    GuanKaConfig.getData = function () {
        return GuanKaConfig.data;
    };
    //使用localStorage存储关卡状态、解锁、金钱数据
    /**每个关卡的资源组名*/
    //public static guankaData: string[] = ["guanka01load","guanka02load","guanka03load","guanka04load","guanka05load","guanka06load","guanka07load","guanka08load","guanka09load","guanka10load","guanka11load","guanka12load"];
    GuanKaConfig.guankaData = ["guanka01load", "guanka02load", "guanka03load", "guanka04load", "guanka05load", "guanka06load", "guanka03load", "guanka04load", "guanka01load", "guanka02load", "guanka03load", "guanka04load"];
    /**所有关卡当前状态(小旗旗)  key:ispass0-ispass9   key:wujin0-wujin9*/
    GuanKaConfig.data = [
        { "xpos": 250, "ypos": 80, "ispass": false, "wujin": 0 },
        { "xpos": 325, "ypos": 102, "ispass": false, "wujin": 0 },
        { "xpos": 325, "ypos": 162, "ispass": false, "wujin": 0 },
        { "xpos": 250, "ypos": 188, "ispass": false, "wujin": 0 },
        { "xpos": 140, "ypos": 225, "ispass": false, "wujin": 0 },
        { "xpos": 270, "ypos": 344, "ispass": false, "wujin": 0 },
        { "xpos": 427, "ypos": 274, "ispass": false, "wujin": 0 },
        { "xpos": 505, "ypos": 370, "ispass": false, "wujin": 0 },
        { "xpos": 603, "ypos": 320, "ispass": false, "wujin": 0 },
        { "xpos": 550, "ypos": 238, "ispass": false, "wujin": 0 },
        { "xpos": 490, "ypos": 188, "ispass": false, "wujin": 0 },
        { "xpos": 480, "ypos": 96, "ispass": false, "wujin": 0 }
    ];
    return GuanKaConfig;
})();
egret.registerClass(GuanKaConfig,'GuanKaConfig');
//# sourceMappingURL=GuanKaConfig.js.map