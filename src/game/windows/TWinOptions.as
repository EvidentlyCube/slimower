package game.windows {
	import game.global.Make;
	import game.global.Options;

	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TWinOptions extends RetrocamelWindowFlash {
		protected var options:Options;

		protected var closer:RetrocamelButton;

		public function TWinOptions() {
			this._blockUnder = true;
			this._pauseGame = false;

			var txt:RetrocamelBitmapText = Make().text(_("Options"), 0xFFFFFF, 3);

			options = new Options();
			closer = Make().buttonColor(onClose, _('Close'));

			addChild(txt);
			addChild(options);
			addChild(closer);


			var bg:RetrocamelPreciseGrid9 = RetrocamelPreciseGrid9.getGrid('tooltipBG');

			bg.innerY = 0;
			bg.width = width + 10;
			bg.height = options.height + closer.height + 75;

			addChildAt(bg, 0);

			options.x = (width - options.width) / 2 | 0;
			options.y = 55;

			txt.x = (width - txt.width) / 2 | 0;

			closer.x = (width - closer.width) / 2 | 0;
			closer.y = height - closer.height - 10;

			centerWindow();

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).run();

			show();
		}

		private function onClose():void {
			mouseEnabled = false;
			mouseChildren = false;
			RetrocamelEffectFadeFlash.make(this).alphaTo(1).duration(250).callback(hide).run();
		}
	}
}