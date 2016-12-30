package game.states {
	import game.global.Game;
	import game.global.Level;
	import game.global.Score;
	import game.objects.TGameObject;
	import game.objects.THud;
	import game.tiles.TTile;
	import game.windows.TWinDiffSelect;
	import game.windows.TWinPause;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.helpers.RetrocamelScrollAssist;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;

	public class TStateGame extends RetrocamelStateBase {
		private static var _instance:TStateGame = new TStateGame();
		public static function get instance():TStateGame {
			return _instance;
		}

		override public function create():void {
			_defaultGroup = Game.gAll;

			Game.paused = true;

			TWinDiffSelect.instance.show();

			RetrocamelSoundManager.playMusic(Game.music, 1000);
		}

		override public function destroy():void {
			_defaultGroup.clear();
			THud.instance.unhook();
			Game.lGame.clear();
			Game.lBG.clear();
			Game.lMain.clear();
		}

		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE) && Level.player && Score.timer.get() > 0) {
				TWinPause.instance.show();
				return;
			}

			Game.lBG.clear();
			Game.lGame.clear();

			if (!Game.paused) {
				Score.timer.add(-50 / 3);

				if (Level.player)
					Level.player.update();

				Game.gAll.update();
			} else {
				if (Level.player)
					Level.player.draw();

				for each(var o:TGameObject in Game.gAll.getAllOriginal()) {
					o.draw();
				}
			}

			var scrollX:int = -RetrocamelScrollAssist.x;
			var scrollY:int = -RetrocamelScrollAssist.y;

			var i:int = Math.floor(-scrollX / 16);
			var j:int = Math.floor(-scrollY / 16);

			var l:int = i + 17;
			var k:int = j + 15;

			var tile:TTile;

			for (i = l - 17; i < l; i++) {
				for (j = k - 15; j < k; j++) {
					if ((tile = Level.levelBG.get(i * 16, j * 16))) tile.drawMe(scrollX, scrollY);
					if ((tile = Level.level.get(i * 16, j * 16))) tile.drawMe(scrollX, scrollY);
				}
			}
		}
	}
}