package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Level;
	import game.global.Make;
	import game.global.Score;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsString;

	/**
	 * ...
	 * @author
	 */
	public class THud extends RetrocamelUpdatableObject {
		[Embed(source="/../src.assets/bgs/hudHP.png")]
		public static var _hp_:Class;

		private static var _instance:THud = new THud;
		public static function get instance():THud {
			return _instance;
		}

		private var _layer:RetrocamelLayerFlashBlit;
		private var _livesIcon:BitmapData;
		private var _scoreText:RetrocamelBitmapText;
		private var _multiText:RetrocamelBitmapText;

		private var _timer:RetrocamelBitmapText;

		public function THud() {
			_livesIcon = RetrocamelBitmapManager.getBD(TPlayer._gfx_player_);

			_scoreText = Make().text("", 0xFFFFFF, 2);
			_scoreText.cache = true;
			_scoreText.addShadow();

			_timer = Make().text("", 0xFFFFFF, 2);
			_timer.cache = true;
			_timer.addShadow();

			_scoreText.x = S().gameWidth - 120;
			_scoreText.y = 1;

			_timer.y = 1;
			_timer.x = 0;
		}

		override public function update():void {
			if (Score.lives.get() == 1)
				_layer.draw(RetrocamelBitmapManager.getBDExt(_hp_, 0, 0, 4, 10), 5, 5);

			else if (Score.lives.get() == 2)
				_layer.draw(RetrocamelBitmapManager.getBDExt(_hp_, 0, 0, 11, 10), 5, 5);

			else if (Score.lives.get() == 3)
				_layer.draw(RetrocamelBitmapManager.getBDExt(_hp_, 0, 0, 20, 10), 5, 5);

			else if (Score.lives.get() == 4)
				_layer.draw(RetrocamelBitmapManager.getBDExt(_hp_, 0, 0, 31, 10), 5, 5);

			_scoreText.text = _("Points:") + " " + UtilsString.padLeft(Score.score.get().toString(), 10);

			if (Score.timer.get() < 0) {
				Level.gameOver();
				_timer.color = (-Score.timer.get() % 1000 < 500) ? 0xFF0000 : 0xFFFFFF;
				Score.playerStop = true;
			}
			_timer.text = _("Time:") + " " + UtilsString.styleTime(Math.max(0, Score.timer.get()), false, true, true, false);

			_timer.x = (S().gameWidth - _timer.width) / 2
			_scoreText.x = S().gameWidth - _scoreText.width - 8;
		}

		public function hookTo(layer:RetrocamelLayerFlashBlit):void {
			RetrocamelCore.groupAfter.add(this);
			_layer = layer;

			Game.lMain.add(_scoreText);
			Game.lMain.add(_timer);

			_timer.color = 0xFFFFFF;
		}

		public function unhook():void {
			RetrocamelCore.groupAfter.nullify(this);
			if (Game.lMain.contains(_scoreText))
				Game.lMain.remove(_scoreText);

			if (Game.lMain.contains(_timer))
				Game.lMain.remove(_timer);
		}
	}
}