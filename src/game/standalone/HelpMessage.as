package game.standalone {
	import flash.display.Sprite;
	
	import game.global.Game;
	import game.global.Make;

	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.utils.UtilsGraphic;

	/**
     * ...
     * @author 
     */
    public class HelpMessage extends Sprite {        
        private var _txt:RetrocamelBitmapText;
        private var _icon:RetrocamelBitmapText;
        public function HelpMessage(text:String) {
            _icon = Make().text("?", 0xFFFFFF, 2);
            _icon.x = 5;
            
            _txt       = Make().text("");
            _txt.align = RetrocamelBitmapText.ALIGN_MIDDLE;
            _txt.text  = text;
            _txt.y     = S().gameHeight - _txt.height - 5;
            
            
            addChild(_txt);
            addChild(_icon);
            
            UtilsGraphic.draw(graphics).beginFill(0, 0.75).drawRect(0, _txt.y - 5, S().gameWidth, _txt.height + 10);
            
            _icon.y =  _txt.y - 5 + (10 + _txt.height - _icon.height) / 2;
            
            _txt.positionToCenter();
            
            Game.lMain.add(this);
        }
    }
}