package game.states {
	import flash.display.Sprite;

	import game.effects.PreloaderPixelBug;
	import game.global.Make;
	import game.preloader.Preloader;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.locale.RetrocamelLocale;

	use namespace retrocamel_int;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TStateLang extends RetrocamelStateBase {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		private var _parent:Sprite;

		private var _flags:Array = [];
		private var _flagsGroup:Sprite;

		private var _langText:RetrocamelBitmapText;

		private var _startupFunction:Function;


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Creation
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function TStateLang(startupFunction:Function) {
			_startupFunction = startupFunction;

			_parent = Sprite(Preloader.loaderLayer.layer);
			_flagsGroup = new Sprite();

			var flag:RetrocamelButton;
			var lastFlag:RetrocamelButton;
			var tempFlag:RetrocamelButton;
			var slide:Number;

			for each(var s:String in S().LANGUAGES) {
				//flag = new RetrocamelButton(onButtonClick, onButtonOver, onButtonOut, true);
				flag = Make().buttonColor(onButtonClick, S().LANGUAGES_NAMES[S().LANGUAGES.indexOf(s)]);
				flag.rollOutCallback = onButtonOut;
				flag.rollOverCallback = onButtonOver;
				flag.data.lang = s;

				RetrocamelTooltip.hook(flag, S().LANGUAGES_NAMES[S().LANGUAGES.indexOf(s)]);

				//flag.data.txt.text = S().LANGUAGES_NAMES[S().LANGUAGES.indexOf(s)];
				//flag.data.grid9.width = flag.width;

				_flags.push(flag);

				if (lastFlag) {
					flag.x = lastFlag.x + lastFlag.width + 8;
					flag.y = lastFlag.y;

					if (flag.x + flag.width > S().gameWidth - 100) {
						slide = (S().gameWidth - 100 - lastFlag.x - lastFlag.width) / 2 | 0;
						for each (tempFlag in _flags) {
							if (tempFlag.y == flag.y)
								tempFlag.x += slide;
						}

						flag.x = 0;
						flag.y += 44;
					}
				}

				lastFlag = flag;

				_flagsGroup.addChild(flag);
			}


			slide = (S().gameWidth - 100 - lastFlag.x - lastFlag.width) / 2 | 0;
			for each (tempFlag in _flags) {
				if (tempFlag.y == flag.y)
					tempFlag.x += slide;
			}

			_flagsGroup.x = 50;
			_flagsGroup.y = S().gameHeight - 50 - _flagsGroup.height;

			_langText = Make().text('asd', 0xFFFFFF, 2, 0, 60);
			_langText.text = RetrocamelLocale.get(null, 'choseLanguage');

			_parent.addChild(_flagsGroup);
			_parent.addChild(_langText);

			centerizeMessage();
		}

		override public function create():void {
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAA0000, 0xFF220000);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF00AA00, 0xFF002200);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF0000AA, 0xFF000022);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAAAA00, 0xFF222200);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAA00AA, 0xFF220022);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF00AAAA, 0xFF002222);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAA0000, 0xFF220000);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF00AA00, 0xFF002200);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF0000AA, 0xFF000022);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAAAA00, 0xFF222200);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAA00AA, 0xFF220022);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF00AAAA, 0xFF002222);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAA0000, 0xFF220000);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF00AA00, 0xFF002200);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF0000AA, 0xFF000022);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAAAA00, 0xFF222200);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFFAA00AA, 0xFF220022);
			new PreloaderPixelBug(Preloader.loaderLayerBG, S().gameWidth, S().gameHeight, 1 + Math.random() * 5, 0xFF00AAAA, 0xFF002222);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Helpers
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private function centerizeMessage():void {
			_langText.positionToCenterScreen();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Events
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private function onFaded():void {
			_parent.removeChild(_flagsGroup);
			_parent.removeChild(_langText);

			_startupFunction();
		}

		private function onButtonClick(data:RetrocamelButton):void {
			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(onFaded).run();

			_flagsGroup.mouseChildren = false;

			RetrocamelLocale.selected = data.data.lang;
		}

		private function onButtonOver(data:RetrocamelButton):void {
			_langText.text = RetrocamelLocale.get(data.data.lang as String, 'choseLanguage');
			centerizeMessage();
		}

		private function onButtonOut(data:RetrocamelButton):void {
			_langText.text = RetrocamelLocale.get(null, 'choseLanguage');
			centerizeMessage();
		}

	}

}