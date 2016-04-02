
var game_file_list = [
    //以下为自动修改，请勿修改
    //----auto game_file_list start----
	"libs/modules/egret/egret.js",
	"libs/modules/egret/egret.native.js",
	"libs/modules/game/game.js",
	"libs/modules/game/game.native.js",
	"libs/modules/tween/tween.js",
	"libs/modules/res/res.js",
	"libs/modules/greensock/greensock.js",
	"bin-debug/BuildTools/BuildIcon.js",
	"bin-debug/BuildTools/BuildTool.js",
	"bin-debug/BuildTools/BuildWait.js",
	"bin-debug/Config/GameSetting.js",
	"bin-debug/Config/GuanKaConfig.js",
	"bin-debug/Config/HeroConfig.js",
	"bin-debug/Config/StorageSetting.js",
	"bin-debug/Config/TowerLevel.js",
	"bin-debug/Elements.js",
	"bin-debug/VectorElements.js",
	"bin-debug/Enemy/MonsterBase.js",
	"bin-debug/Enemy/Monster01.js",
	"bin-debug/Events/LoadEvent.js",
	"bin-debug/Events/MainEvent.js",
	"bin-debug/Events/SoldEvent.js",
	"bin-debug/Events/ToolEvent.js",
	"bin-debug/Events/TowerEvent.js",
	"bin-debug/FSM/StateMachine.js",
	"bin-debug/Guanka/GuankaBase.js",
	"bin-debug/Guanka/Guanka01.js",
	"bin-debug/Guanka/Guanka02.js",
	"bin-debug/Guanka/Guanka03.js",
	"bin-debug/Guanka/Guanka04.js",
	"bin-debug/Guanka/Guanka05.js",
	"bin-debug/Guanka/Guanka06.js",
	"bin-debug/Guanka/GuanKaUI.js",
	"bin-debug/Guanka/SkillBase.js",
	"bin-debug/Guanka/Skill1.js",
	"bin-debug/Guanka/Skill2.js",
	"bin-debug/Index.js",
	"bin-debug/Loader/LoadBar.js",
	"bin-debug/Loader/Loader.js",
	"bin-debug/Loader/LoadingUI.js",
	"bin-debug/LoadingUI.js",
	"bin-debug/Main.js",
	"bin-debug/PreLoad.js",
	"bin-debug/Soldiers/ArrowShooterBase.js",
	"bin-debug/Soldiers/ArrowShooter01.js",
	"bin-debug/Soldiers/ArrowShooter02.js",
	"bin-debug/Soldiers/ArrowShooter031.js",
	"bin-debug/Soldiers/ArrowShooter032.js",
	"bin-debug/Soldiers/MagicWizardBase.js",
	"bin-debug/Soldiers/MagicWizard010203.js",
	"bin-debug/Soldiers/ShieldSoldierBase.js",
	"bin-debug/Soldiers/ShieldSoldier01.js",
	"bin-debug/Soldiers/ZenYuanBase.js",
	"bin-debug/Soldiers/ZenYuan1.js",
	"bin-debug/Soldiers/ZenYuan2.js",
	"bin-debug/Tower/Base.js",
	"bin-debug/Tower/TowerBase.js",
	"bin-debug/Tower/ArrowTowerBase.js",
	"bin-debug/Tower/ArrowTower01.js",
	"bin-debug/Tower/ArrowTower02.js",
	"bin-debug/Tower/ArrowTower03_1.js",
	"bin-debug/Tower/ArrowTower03_2.js",
	"bin-debug/Tower/Base01.js",
	"bin-debug/Tower/Base02.js",
	"bin-debug/Tower/Base03.js",
	"bin-debug/Tower/ExploTowerBase.js",
	"bin-debug/Tower/ExploTower01.js",
	"bin-debug/Tower/ExploTower02.js",
	"bin-debug/Tower/ExploTower03_1.js",
	"bin-debug/Tower/ExploTower03_2.js",
	"bin-debug/Tower/MagicTowerBase.js",
	"bin-debug/Tower/MagicTower01.js",
	"bin-debug/Tower/MagicTower02.js",
	"bin-debug/Tower/MagicTower03_1.js",
	"bin-debug/Tower/MagicTower03_2.js",
	"bin-debug/Tower/ShieldTowerBase.js",
	"bin-debug/Tower/ShieldTower01.js",
	"bin-debug/Tower/ShieldTower02.js",
	"bin-debug/Tower/ShieldTower03_1.js",
	"bin-debug/Tower/ShieldTower03_2.js",
	"bin-debug/Utils/Grid.js",
	"bin-debug/Utils/Group.js",
	"bin-debug/Utils/HitTest.js",
	"bin-debug/Utils/IGroupItem.js",
	"bin-debug/Utils/ILife.js",
	"bin-debug/Utils/LifeBar.js",
	"bin-debug/Utils/NodePoint.js",
	"bin-debug/Utils/ObjectPool.js",
	"bin-debug/Utils/SoundManager.js",
	"bin-debug/Utils/Utils.js",
	"bin-debug/Utils/Vector2D.js",
	"bin-debug/Weapon/ArrowBase.js",
	"bin-debug/Weapon/Arrow01.js",
	"bin-debug/Weapon/Arrow032.js",
	"bin-debug/Weapon/ExploBase.js",
	"bin-debug/Weapon/Explo01.js",
	"bin-debug/Weapon/Explo02.js",
	"bin-debug/Weapon/Explo031.js",
	"bin-debug/Weapon/FireBallBase.js",
	"bin-debug/Weapon/FireBall.js",
	"bin-debug/Weapon/MagicBulletBase.js",
	"bin-debug/Weapon/MagicBullet010203.js",
	"bin-debug/World.js",
	//----auto game_file_list end----
];

var window = this;

egret_native.setSearchPaths([""]);

egret_native.requireFiles = function () {
    for (var key in game_file_list) {
        var src = game_file_list[key];
        require(src);
    }
};

egret_native.egretInit = function () {
    egret_native.requireFiles();
    egret.TextField.default_fontFamily = "/system/fonts/DroidSansFallback.ttf";
    //egret.dom为空实现
    egret.dom = {};
    egret.dom.drawAsCanvas = function () {
    };
};

egret_native.egretStart = function () {
    var option = {
        //以下为自动修改，请勿修改
        //----auto option start----
		entryClassName: "Main",
		frameRate: 30,
		scaleMode: "auto",
		contentWidth: 480,
		contentHeight: 800,
		showPaintRect: false,
		showFPS: true,
		fpsStyles: "x:0,y:0,size:30,textColor:0x00c200,bgAlpha:0.9",
		showLog: true,
		logFilter: "",
		maxTouches: 2,
		textureScaleFactor: 1
		//----auto option end----
    };

    egret.native.NativePlayer.option = option;
    egret.runEgret();
    egret_native.Label.createLabel(egret.TextField.default_fontFamily, 20, "", 0);
    egret_native.EGTView.preSetOffScreenBufferEnable(true);
};