package game.preloader {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	import game.global.Make;

	import game.global.Pre;
	import game.global.Sfx;
	import game.states.TStateLang;
	import game.states.TStatePreload;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class Preloader extends MovieClip {
		public static var loaderLayer:RetrocamelLayerFlashSprite;
		public static var loaderLayerBG:RetrocamelLayerFlashBlit;


		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		private var _afterLoad:Boolean = false;

		public static var percent:Number = 0;

		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		public function Preloader() {
			addEventListener(Event.ENTER_FRAME, init);
		}

		private function init(e:Event):void {
			if (!stage)
				return;

			removeEventListener(Event.ENTER_FRAME, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;

			Pre.preCoreInit();

			RetrocamelCore.initFlash(stage, this, S(), Make());
			Sfx.initialize();
			Sfx.startGenerating(soundMakeFinished);
			RetrocamelDisplayManager.setBackgroundColor(0x151224);

			Pre.init();

			loaderLayerBG = new RetrocamelLayerFlashBlit();
			loaderLayer = new RetrocamelLayerFlashSprite();

			RetrocamelCore.setState(new TStatePreload());

			addEventListener(Event.ENTER_FRAME, checkFrame);
		}

		private function checkFrame(e:Event):void {
			percent = stage.loaderInfo.bytesLoaded * 100 / stage.loaderInfo.bytesTotal;
			
			if (stage.loaderInfo.bytesLoaded >= stage.loaderInfo.bytesTotal) {
				gotoAndStop(2);
				removeEventListener(Event.ENTER_FRAME, checkFrame);

				_afterLoad = true;

				initLanguageSelection();
			}
		}

		private function initLanguageSelection():void {
			RetrocamelEffectFadeScreen.makeOut().duration(500).callback(loadLanguagesState).run();
		}

		private function loadLanguagesState():void {
			RetrocamelEffectFadeScreen.makeIn().duration(500).run();

			RetrocamelCore.setState(new TStateLang(startup));
		}

		private function soundMakeFinished():void {
			stage.frameRate = 60;
		}

		public function startup():void {
			loaderLayer.removeLayer();
			loaderLayerBG.removeLayer();

			stage.focus = stage;

			var mainClass:Class = Class(getDefinitionByName("game.core.Main"));
			addChild(new mainClass() as DisplayObject);
			stage.frameRate = 60;
		}
	}
}