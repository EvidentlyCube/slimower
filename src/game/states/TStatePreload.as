package game.states {
	import flash.display.Sprite;

	import game.global.Make;
	import game.preloader.Preloader;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.locale._;

	public class TStatePreload extends RetrocamelStateBase {
		private var txt:RetrocamelBitmapText;
		private var desc:RetrocamelBitmapText;
		private var load:RetrocamelBitmapText;
		private var parent:Sprite = new Sprite;

		private var loadWaver:Number = 0;

		public function TStatePreload() {
			txt = Make().text(_("preloadTitle"), 0xFFFFFF, 8);
			desc = Make().text(_("preloadDesc"));
			load = Make().text(_("loading") + " " + Preloader.percent.toFixed(1) + "%");

			txt.x = (S().gameWidth - txt.width) / 2;
			txt.y = 145;

			desc.x = (S().gameWidth - desc.width) / 2;
			desc.y = 255;

			parent.addChild(txt);
			parent.addChild(desc);
			parent.addChild(load);
		}

		override public function update():void {
			super.update();
			Preloader.loaderLayerBG.clear();

			load.text = _("loading") + " " + Preloader.percent.toFixed(1) + "%";
			load.x = (S().gameWidth - load.width) / 2;
			load.y = 290 + Math.cos(loadWaver += Math.PI / 110) * 5;
		}

		override public function create():void {
			Preloader.loaderLayer.add(parent);
			RetrocamelEffectFadeScreen.makeIn().duration(500).run();
		}

		override public function destroy():void {
			Preloader.loaderLayer.remove(parent);
		}
	}
}