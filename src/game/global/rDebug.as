package game.global{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    
    import net.retrocade.camel.core.RetrocamelCore;
    import net.retrocade.camel.core.rDisplay;
    import net.retrocade.camel.core.RetrocamelInputManager;
    import net.retrocade.camel.core.retrocamel_int;
    import net.retrocade.camel.objects.rObject;
    import net.retrocade.utils.Key;
    
    use namespace retrocamel_int;
    
    public class rDebug extends rObject{
        
        private var dragged:DisplayObject;
        private var point:Point = new Point();
        
        private var offsetX:Number = 0;
        private var offsetY:Number = 0;
        
        public function rDebug(){
            RetrocamelCore.groupBefore.add(this);
        }
        
        override public function update():void{
            if (RetrocamelInputManager.isKeyDown(Key.BACKQUOTE)){
                if (!dragged){
                    point.x = RetrocamelInputManager.mouseX;
                    point.y = RetrocamelInputManager.mouseY;
                    
                    var a:Array = rDisplay._stage.getObjectsUnderPoint(point);
                    if (a.length == 0)
                        return;
                    
                    dragged = a[a.length - 1];
                    
                    offsetX = RetrocamelInputManager.mouseX - dragged.x;
                    offsetY = RetrocamelInputManager.mouseY - dragged.y;
                }
                
                dragged.x = RetrocamelInputManager.mouseX - offsetX;
                dragged.y = RetrocamelInputManager.mouseY - offsetY;
            } else if (dragged){
                trace('DEBUG POSITION: ' + dragged.x + ":" + dragged.y);
                dragged = null;
            }
        }
    }
}