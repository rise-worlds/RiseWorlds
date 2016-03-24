/**
 *
 * 地基01
 * @author 
 *
 */
class Base01 extends Base{
    
	public constructor() {
        super();
        this.cacheAsBitmap = true;
        var bm: egret.Bitmap = Utils.createBitmapByName("empty01");
        this.anchorOffsetX = 0.5;
        this.anchorOffsetY = 1;
        this.addChild(bm);
	}
	
    public onEnterFrame(advancedTime:number){
        
    }
    
    
}
