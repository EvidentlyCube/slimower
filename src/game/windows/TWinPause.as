package game.windows {
	import game.global.Make;
	import game.global.Options;
	import game.global.Score;
	import game.objects.TEscButton;

	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsGraphic;

	public class TWinPause extends RetrocamelWindowFlash {
		private static var _instance:TWinPause = new TWinPause();

		public static function get instance():TWinPause {
			return _instance;
		}


		protected var options:Options;

		protected var surrender:RetrocamelButton;
		protected var closer:RetrocamelButton;

		public function TWinPause() {
			this._blockUnder = true;
			this._pauseGame = true;

			var txt:RetrocamelBitmapText = Make().text(_("Game is Paused"), 0xFFFFFF, 2);

			options = new Options();
			closer = Make().buttonColor(onClose, _('Return to Game'));
			surrender = Make().buttonColor(onRestart, _('Surrender'));

			addChild(txt);
			addChild(options);
			addChild(closer);
			addChild(surrender);
			//addChild(toMenu);

			options.y = 25;
			closer.y = options.y + options.height + 5;
			surrender.y = closer.y + closer.height + 5;

			graphics.beginFill(0);
			graphics.drawRect(0, 0, 300, options.height + closer.height + 75);

			txt.x = (width - txt.width) / 2 + 5 | 0;
			closer.x = (width - closer.width) / 2 + 5 | 0;
			options.x = (width - options.width) / 2 + 5 | 0;
			surrender.x = (width - surrender.width) / 2 + 5 | 0;

			centerWindow();

			UtilsGraphic.clear(this).beginFill(0, 0.5).drawRect(-x, -y, S().gameWidth, S().gameHeight);

			var bg:RetrocamelPreciseGrid9 = RetrocamelPreciseGrid9.getGrid('tooltipBG');

			bg.innerY = 0;
			bg.width = options.width + 10;
			bg.height = surrender.y + surrender.height + 10;

			addChildAt(bg, 0);

			RetrocamelTooltip.hook(surrender, _('surrenderTooltip'));
		}

		override public function show():void {
			super.show();
			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).run();
			mouseEnabled = true;
			mouseChildren = true;

			TEscButton.unset();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: RetrocamelButton Callbacks
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private function onClose():void {
			mouseEnabled = false;
			mouseChildren = false;
			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(efFinClose).run();
		}

		private function onRestart():void {
			mouseEnabled = false;
			mouseChildren = false;
			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(efFinRestart).run();
		}


		private function efFinClose():void {
			hide();
		}

		private function efFinRestart():void {
			hide();
			Score.timer.set(0);
		}
	}
}