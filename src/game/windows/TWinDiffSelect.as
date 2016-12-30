package game.windows {
	import flash.display.Bitmap;

	import game.global.Game;
	import game.global.Level;
	import game.global.Make;
	import game.global.Score;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEasings;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectMove;
	import net.retrocade.retrocamel.effects.RetrocamelEffectSolidScreen;
	import net.retrocade.retrocamel.locale._;

	public class TWinDiffSelect extends RetrocamelWindowFlash {
		[Embed(source="/../src.assets/bgs/title.png")]
		public static var _title_:Class;

		private static var _instance:TWinDiffSelect = new TWinDiffSelect();

		public static function get instance():TWinDiffSelect {
			return _instance;
		}

		private var _easy:RetrocamelButton;
		private var _medium:RetrocamelButton;
		private var _hard:RetrocamelButton;
		private var _extreme:RetrocamelButton;
		private var _suicide:RetrocamelButton;

		private var _credits:RetrocamelButton;
		private var _options:RetrocamelButton;
		private var _instructions:RetrocamelBitmapText;

		private var _title:Bitmap;

		private var _bgShade:RetrocamelEffectSolidScreen;

		public function TWinDiffSelect() {
			_blockUnder = false;
			_pauseGame = false;

			_easy = Make().buttonColor(onDifficultySet, _("Easy"));
			_medium = Make().buttonColor(onDifficultySet, _("Medium"));
			_hard = Make().buttonColor(onDifficultySet, _("Hard"));
			_extreme = Make().buttonColor(onDifficultySet, _("Extreme"));
			_suicide = Make().buttonColor(onDifficultySet, _("Suicide"));

			_credits = Make().buttonColor(onCredits, _("Credits"));
			_options = Make().buttonColor(onOptions, _("Options"));

			_instructions = new RetrocamelBitmapText(_("hints"));
			_instructions.align = RetrocamelBitmapText.ALIGN_MIDDLE;
			_instructions.addShadow();
			_instructions.setScale(2);
			_instructions.lineSpace = -3;

			_title = RetrocamelBitmapManager.getB(_title_);

			RetrocamelTooltip.hook(_easy, _("easyInfo"));
			RetrocamelTooltip.hook(_medium, _("mediumInfo"));
			RetrocamelTooltip.hook(_hard, _("hardInfo"));
			RetrocamelTooltip.hook(_extreme, _("extremeInfo"));
			RetrocamelTooltip.hook(_suicide, _("suicideInfo"));

			var node:uint = S().gameWidth / 5;

			_easy.x = (node - _easy.width) / 2;
			_medium.x = (node - _medium.width) / 2 + node;
			_hard.x = (node - _hard.width) / 2 + node * 2;
			_extreme.x = (node - _extreme.width) / 2 + node * 3;
			_suicide.x = (node - _suicide.width) / 2 + node * 4;

			node = S().gameWidth / 3;

			_credits.x = (node - _credits.width) / 2;
			_options.x = (node - _options.width) / 2 + node;

			_easy.y = 200;
			_medium.y = _easy.y;
			_hard.y = _easy.y;
			_extreme.y = _easy.y;
			_suicide.y = _easy.y;

			_credits.y = 250;
			_options.y = _credits.y;

			_title.scaleX = _title.scaleY = 3;
			_title.x = (S().gameWidth - _title.width) / 2;

			_instructions.x = (S().gameWidth - _instructions.width) / 2;
			_instructions.y = 300;


			addChild(_easy);
			addChild(_medium);
			addChild(_hard);
			addChild(_extreme);
			addChild(_suicide);
			addChild(_title);

			addChild(_credits);
			addChild(_options);
			addChild(_instructions);
		}

		override public function show():void {
			super.show();

			mouseChildren = false;

			_bgShade = RetrocamelEffectSolidScreen.make().alpha(1).color(0);
			_bgShade.run();

			RetrocamelEffectFadeFlash.make(_bgShade.flashSpriteLayer.layer).alpha(1, 0.5).duration(400).callback(handleBackgroundFade).run();

			alpha = 0;

			_title.y = -100;
		}

		private function handleBackgroundFade():void {
			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(400).callback(handleWindowFade).run();
		}

		private function handleWindowFade():void {
			RetrocamelEffectMove.make(_title).targetY(50).duration(500).easing(RetrocamelEasings.exponentialOut).run();
			mouseChildren = true;
		}

		private function onCredits():void {
			TWinCredits.instance.show();
		}

		private function onOptions():void {
			new TWinOptions();
		}

		private function onDifficultySet(button:RetrocamelButton):void {
			switch (button) {
				case (_easy):
					Score.noChunkDamage = true;
					Score.noPushback = true;
					Score.doubleChunks = false;
					Score.speedMultiplier.set(0.75);
					Score.healthMultiplier.set(0.5);
					Score.scoreMultiplier.set(0.1);
					Score.diffSelected = 0;
					break;

				case (_medium):
					Score.noChunkDamage = false;
					Score.noPushback = true;
					Score.doubleChunks = false;
					Score.speedMultiplier.set(1);
					Score.healthMultiplier.set(1);
					Score.scoreMultiplier.set(0.25);
					Score.diffSelected = 1;
					break;

				case (_hard):
					Score.noChunkDamage = false;
					Score.noPushback = false;
					Score.doubleChunks = false;
					Score.speedMultiplier.set(1);
					Score.healthMultiplier.set(1);
					Score.scoreMultiplier.set(1);
					Score.diffSelected = 2;
					break;

				case (_extreme):
					Score.noChunkDamage = false;
					Score.noPushback = false;
					Score.doubleChunks = true;
					Score.speedMultiplier.set(1);
					Score.healthMultiplier.set(1.5);
					Score.scoreMultiplier.set(2);
					Score.diffSelected = 3;
					break;

				case (_suicide):
					Score.noChunkDamage = false;
					Score.noPushback = false;
					Score.doubleChunks = true;
					Score.speedMultiplier.set(1.5);
					Score.healthMultiplier.set(2);
					Score.scoreMultiplier.set(5);
					Score.diffSelected = 4;
					break;
			}

			RetrocamelEffectFadeFlash.make(_bgShade.flashSpriteLayer.layer).alphaTo(0).duration(500).callback(difficultySetFinishedEffectHandler).run();
			RetrocamelEffectFadeFlash.make(this).alphaTo(0).duration(500).run();
		}

		private function difficultySetFinishedEffectHandler():void {
			Level.startGame();
			Game.paused = false;
		}
	}
}