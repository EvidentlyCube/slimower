package game.windows {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import game.global.Make;

	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsDisplay;

	/**
	 * ...
	 * @author ...
	 */
	public class TWinCredits extends RetrocamelWindowFlash {
		/****************************************************************************************************************/
		/**                                                                                                     STATIC  */
		/****************************************************************************************************************/

		private static var _instance:TWinCredits = new TWinCredits();

		public static function get instance():TWinCredits {
			return _instance;
		}


		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		public function TWinCredits() {
			_blockUnder = true;
			_pauseGame = false;

			var by:RetrocamelBitmapText = Make().text(_("Game by"), 0xFFFF00, 2);
			var by2:RetrocamelBitmapText = Make().text(_("RETROCADE.net"), 0x44FF44, 2);

			var prg:RetrocamelBitmapText = Make().text(_("Programming"), 0xFFFF00);
			var prg2:RetrocamelBitmapText = Make().text(_("Maurycy Zarzycki"), 0xFFFFFF);

			var gfx:RetrocamelBitmapText = Make().text(_("Graphics"), 0xFFFF00);
			var gfx2:RetrocamelBitmapText = Make().text(_("Maurycy Zarzycki"), 0xFFFFFF);

			var mus:RetrocamelBitmapText = Make().text(_("Music"), 0xFFFF00);
			var mus2:RetrocamelBitmapText = Make().text(_("MusicSrc"), 0xFFFFFF);

			var sfx:RetrocamelBitmapText = Make().text(_("Sound Effects"), 0xFFFF00);
			var sfx2:RetrocamelBitmapText = Make().text(_("SfxCredit"), 0xFFFFFF);

			var trn:RetrocamelBitmapText = Make().text(_("Translations"), 0xFFFF00);
			var trn2:Sprite = UtilsDisplay.wrapInSprite(Make().text(_("EN - Chris Allcock"), 0xFFFFFF));
			var trn3:Sprite = UtilsDisplay.wrapInSprite(Make().text(_("PL - Maurycy Zarzycki"), 0xFFFFFF));


			var closer:RetrocamelButton = Make().buttonColor(onClose, _("Close"));

			var all:Array = [by, by2, prg, prg2, gfx, gfx2, mus, mus2, sfx, sfx2,
				trn, trn2, trn3, closer];

			RetrocamelTooltip.hook(trn2, "http://zolyx.co.uk");
			RetrocamelTooltip.hook(trn3, "http://mauft.com");

			trn2.buttonMode = true;
			trn3.buttonMode = true;

			trn2.addEventListener(MouseEvent.MOUSE_DOWN, function ():void {
				navigateToURL(new URLRequest("http://zolyx.co.uk"), "_blank");
			});
			trn3.addEventListener(MouseEvent.MOUSE_DOWN, function ():void {
				navigateToURL(new URLRequest("http://mauft.com"), "_blank");
			});

			by2.y = 25;
			prg.y = 65;
			prg2.y = 80;
			gfx.y = 100;
			gfx2.y = 115;
			mus.y = 135;
			mus2.y = 150;
			sfx.y = 170;
			sfx2.y = 185;

			trn.y = 65;
			trn2.y = 80;
			trn3.y = 95;

			var wid:Number = Math.max(prg.width, prg2.width, gfx.width, gfx2.width, mus.width, mus2.width, sfx.width,
				sfx2.width, trn.width, trn2.width, trn3.width);

			by.x = (wid * 2 + 40 - by.width) / 2;
			by2.x = (wid * 2 + 40 - by2.width) / 2;
			closer.x = (wid * 2 + 40 - closer.width) / 2;

			prg.x = (wid + 20 - prg.width) / 2;
			prg2.x = (wid + 20 - prg2.width) / 2;
			gfx.x = (wid + 20 - gfx.width) / 2;
			gfx2.x = (wid + 20 - gfx2.width) / 2;
			mus.x = (wid + 20 - mus.width) / 2;
			mus2.x = (wid + 20 - mus2.width) / 2;
			sfx.x = (wid + 20 - sfx.width) / 2;
			sfx2.x = (wid + 20 - sfx2.width) / 2;

			trn.x = wid + 20 + (wid + 20 - trn.width) / 2;
			trn2.x = wid + 20 + (wid + 20 - trn2.width) / 2;
			trn3.x = wid + 20 + (wid + 20 - trn3.width) / 2;

			closer.y = Math.max(sfx2.y + sfx2.height, trn3.y + trn3.height) + 15;

			UtilsDisplay.addArray(this, all);

			var bg:RetrocamelPreciseGrid9 = RetrocamelPreciseGrid9.getGrid('tooltipBG');

			bg.innerY = 0;
			bg.width = wid * 2 + 40;
			bg.height = height + 10;

			addChildAt(bg, 0);

			centerWindow();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Overrides
		// ::::::::::::::::::::::::::::::::::::::::::::::

		override public function show():void {
			super.show();

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).run();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Callbacks
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private function onClose():void {
			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(hide).run();
		}
	}
}