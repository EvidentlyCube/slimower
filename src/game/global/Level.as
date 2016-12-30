package game.global {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import game.objects.TCoin;
	import game.objects.TEscButton;
	import game.objects.THud;
	import game.objects.TMonsterSlimeBlue;
	import game.objects.TMonsterSlimeGreen;
	import game.objects.TMonsterSlimePink;
	import game.objects.TMonsterSlimeRed;
	import game.objects.TMonsterSlimeYellow;
	import game.objects.TPlayer;
	import game.tiles.TTileBG;
	import game.tiles.TTileWall;
	import game.windows.TWinDiffSelect;

	import net.retrocade.data.RetrocamelSpatialHash;
	import net.retrocade.data.RetrocamelTileGrid;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.locale._;

	public class Level {
		[Embed(source='/../src.levels/Level1.oel', mimeType="application/octet-stream")]
		private static var _level_1_:Class;
		[Embed(source='/../src.levels/Level2.oel', mimeType="application/octet-stream")]
		private static var _level_2_:Class;
		[Embed(source='/../src.levels/Level3.oel', mimeType="application/octet-stream")]
		private static var _level_3_:Class;
		[Embed(source='/../src.levels/Level4.oel', mimeType="application/octet-stream")]
		private static var _level_4_:Class;
		[Embed(source='/../src.levels/Level5.oel', mimeType="application/octet-stream")]
		private static var _level_5_:Class;

		[Embed(source='/../src.assets/bgs/bg.png')]
		public static var _bg_:Class;

		public static var enemies:RetrocamelSpatialHash = new RetrocamelSpatialHash(S().SPATIAL_HASH_CELL, S().SPATIAL_HASH_MAX_BUCKETS);
		public static var level:RetrocamelTileGrid = new RetrocamelTileGrid(S().TILE_GRID_WIDTH, S().TILE_GRID_HEIGHT, S().TILE_GRID_TILE_WIDTH, S().TILE_GRID_TILE_HEIGHT);
		public static var levelBG:RetrocamelTileGrid = new RetrocamelTileGrid(S().TILE_GRID_WIDTH, S().TILE_GRID_HEIGHT, S().TILE_GRID_TILE_WIDTH, S().TILE_GRID_TILE_HEIGHT);
		public static var player:TPlayer;

		private static var _levels:Dictionary = new Dictionary();

		public static function getLevel(id:uint):ByteArray {
			while (id > 5) id -= 5;
			if (!_levels[id])
				_levels[id] = new Level['_level_' + id + '_'];

			ByteArray(_levels[id]).position = 0;
			return _levels[id];
		}

		public static function startGame():void {
			Score.resetGameStart();
			playLevel(Score.level.get(), true);
			_gameOverText = null;

			RetrocamelTooltip.hide();
		}

		public static function restartLevel():void {
			Score.timer.add(-1000 * 60);
			if (Score.timer.get() < 0)
				gameOver();
			else
				playLevel(Score.level.get(), false);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Level Completed with Effect
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static function levelCompleted():void {
			if ((Score.level.get() - 1) % 5 == 4)
				Score.healthMultiplier.add(0.5);

			Score.timer.add(1000 * 30 * (Score.diffSelected == 3 ? 2 : Score.diffSelected == 4 ? 3 : 1));
			Score.level.add(1);

			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(onLevelCompleted).run();
		}

		private static function onLevelCompleted():void {
			playLevel(Score.level.get(), false);
		}

		private static function playLevel(id:uint, ignoreFade:Boolean):void {
			RetrocamelSimpleSave.write('bestLevel', Score.level.get());

			Level.enemies.clear();
			Level.level.clear();
			Level.levelBG.clear();
			Game.gAll.clear();
			Game.partPixel.clear();
			Game.lMain.clear();
			THud.instance.unhook();
			THud.instance.hookTo(Game.lGame);

			var levelData:ByteArray = getLevel(id);

			var level:XML = new XML(levelData.readUTFBytes(levelData.length));
			var item:XML;
			for each(item in level.background.children()) {
				new TTileBG(item.@x, item.@y, item.@tx, item.@ty);
			}

			for each(item in level.walls.children()) {
				new TTileWall(item.@x, item.@y, item.@tx, item.@ty);
			}

			for each(item in level.actors.children()) {
				parseSprite(item);
			}

			RetrocamelScrollAssist.instance.setCorners(0, 0, parseInt(level.width.text()), parseInt(level.height.text()));

			if (!ignoreFade) {
				RetrocamelEffectFadeScreen.makeIn().duration(250).run();
			}

			TEscButton.set();
		}

		private static var _gameOverText:RetrocamelBitmapText;

		public static function gameOver():void {
			if (_gameOverText)
				return;

			RetrocamelSoundManager.playSound(Game._sfx_game_over_);

			RetrocamelSoundManager.pauseMusic();

			RetrocamelEffectQuake.make().power(20, 20).duration(500);
			_gameOverText = Make().text(_("GAME OVER"), 0xFFFFFF, 6);
			_gameOverText.positionToCenterScreen();
			_gameOverText.y = (S().gameHeight - _gameOverText.height) / 2 | 0;
			_gameOverText.addShadow();

			Game.lMain.add(_gameOverText);

			setTimeout(onGameOverEnd, 5000);
		}



		private static function parseSprite(item:XML):void {
			if (item.localName() == "player") {
				new TPlayer(item.@x, item.@y);

			} else if (item.localName() == "slimeGreen") {
				makeSlime(0, item.@x, item.@y, parseFloat(item.@speed) / 10);

			} else if (item.localName() == "slimeBlue") {
				makeSlime(1, item.@x, item.@y, parseFloat(item.@speed) / 10);

			} else if (item.localName() == "slimeYellow") {
				makeSlime(2, item.@x, item.@y, parseFloat(item.@speed) / 10);

			} else if (item.localName() == "slimeRed") {
				makeSlime(3, item.@x, item.@y, parseFloat(item.@speed) / 10);

			} else if (item.localName() == "slimeViolet") {
				makeSlime(4, item.@x, item.@y, parseFloat(item.@speed) / 10);

			} else if (item.localName() == "coin") {
				new TCoin(item.@x, item.@y);
			}

		}

		private static function makeSlime(slimeType:uint, x:Number, y:Number, speed:Number):void {
			slimeType += ((Score.level.get() - 1) / 5) | 0;

			switch (slimeType) {
				case(0):
					new TMonsterSlimeGreen(x, y, speed);
					break;

				case(1):
					new TMonsterSlimeBlue(x, y, speed);
					break;

				case(2):
					new TMonsterSlimeYellow(x, y, speed);
					break;

				case(3):
					new TMonsterSlimeRed(x, y, speed);
					break;

				default:
					new TMonsterSlimePink(x, y, speed);
					break;
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Event Listeners & Callbacks
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private static function onGameOverEnd():void {
			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(onGameOverFadedOutHandler).run();
		}

		private static function onGameOverFadedOutHandler():void {
			startGame();
			Game.paused = true;
			TWinDiffSelect.instance.show();
		}
	}
}