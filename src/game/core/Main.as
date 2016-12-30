package game.core{
	import flash.display.Sprite;
	import flash.events.Event;
    
	import game.global.Game;
    
	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	[Frame(factoryClass="game.preloader.Preloader")]

	public class Main extends Sprite{

        // ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Layers
		// ::::::::::::::::::::::::::::::::::::::::::::::
  
		public function Main():void{
            if (stage) 
                init();
			else 
                addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
            
            Game.init();
		}
	}
}