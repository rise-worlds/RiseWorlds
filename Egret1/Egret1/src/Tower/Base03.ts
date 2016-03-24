/**
 *
 * 地基02
 * @author 
 *
 */
class Base03 extends Base{
    
	public constructor() {
        super();
        this.cacheAsBitmap = true;
        var bm: egret.Bitmap = Utils.createBitmapByName("Base03");
        this.anchorOffsetX = 0.5;
        this.anchorOffsetY = 1;
        this.addChild(bm);
	}
	
    public onEnterFrame(advancedTime:number){
        
    }
    
    
}
