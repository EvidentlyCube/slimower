package game.global {
	import flash.events.KeyboardEvent;
	import flash.media.Sound;

	import game.standalone.ParticleFireworksExt;
	import game.states.TStateGame;
	import game.windows.TWinFocusPause;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.particles.RetrocamelParticlesPixel;

	public class Game {
		//[Embed(source = '/assets/sfx/music.mp3')]  private static var _music_:Class;
		//[Embed(source = '/assets/sfx/music2.mp3')] private static var _music2_:Class;

		[Embed(source="/../src.assets/sfx/blaster.mp3")]
		public static var _blaster_:Class;
		[Embed(source="/../src.assets/sfx/blob_hit.mp3")]
		public static var _blob_hit_:Class;
		[Embed(source="/../src.assets/sfx/blob_kill.mp3")]
		public static var _blob_kill_:Class;
		[Embed(source="/../src.assets/sfx/coin.mp3")]
		public static var _coin_:Class;
		[Embed(source="/../src.assets/sfx/dead.mp3")]
		public static var _dead_:Class;
		[Embed(source="/../src.assets/sfx/step_ground.mp3")]
		public static var _footstep_:Class;
		[Embed(source="/../src.assets/sfx/groan.mp3")]
		public static var _groan_:Class;
		[Embed(source="/../src.assets/sfx/jump.mp3")]
		public static var _jump_:Class;

		[Embed(source="/../src.music/synthmania11_wojciech_panufnik.mp3")]
		public static var _music_:Class;
		[Embed(source='/../src.assets/sfx/gameOver.mp3')]
		public static var _sfx_game_over_:Class;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Game Variables
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static var lMain:RetrocamelLayerFlashSprite;
		public static var lBG:RetrocamelLayerFlashBlit;
		public static var lGame:RetrocamelLayerFlashBlit;
		public static var lPartPix:RetrocamelLayerFlashBlit;
		public static var lPartFir:RetrocamelLayerFlashBlit;

		public static var gAll:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

		public static var partPixel:RetrocamelParticlesPixel;
		public static var partFirework:ParticleFireworksExt;

		public static var music:Sound;


		public static var paused:Boolean = false;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Keys
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static var keyLeft:uint;
		public static var keyRight:uint;
		public static var keyJump:uint;
		public static var keySound:uint;
		public static var keyMusic:uint;

		public static var allKeys:Array = ['keyLeft', 'keyRight', 'keyJump', 'keySound', 'keyMusic'];


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Init
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static function init():void {
			keyLeft = RetrocamelSimpleSave.read('optkeyLeft', KeyConst.LEFT);
			keyRight = RetrocamelSimpleSave.read('optkeyRight', KeyConst.RIGHT);
			keyJump = RetrocamelSimpleSave.read('optkeyJump', KeyConst.UP);
			keySound = RetrocamelSimpleSave.read('optkeySound', KeyConst.S);
			keyMusic = RetrocamelSimpleSave.read('optkeyMusic', KeyConst.M);

			Game.lBG = new RetrocamelLayerFlashBlit();
			Game.lGame = new RetrocamelLayerFlashBlit();
			Game.lPartPix = new RetrocamelLayerFlashBlit();
			Game.lPartFir = new RetrocamelLayerFlashBlit();
			Game.lMain = new RetrocamelLayerFlashSprite();

			Game.lGame.setScale(2, 2);
			Game.lBG.setScale(2, 2);
			Game.lPartPix.setScale(2, 2);
			Game.lPartFir.setScale(2, 2);

			Game.partPixel = new RetrocamelParticlesPixel(Game.lPartPix, 1000);
			Game.partFirework = new ParticleFireworksExt(Game.lPartFir, 1000, 5);

			paused = true;

			TWinFocusPause.hook();

			RetrocamelInputManager.addStageKeyDown(onKeyDown);

			music = new _music_;

			TStateGame.instance.setToMe();
			Level.startGame();
		}

		private static var oldSoundVolume:Number = 1;
		private static var oldMusicVolume:Number = 1;

		private static function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Game.keySound) {
				if (RetrocamelSoundManager.soundVolume == 0)
					RetrocamelSoundManager.soundVolume = oldSoundVolume;
				else {
					oldSoundVolume = RetrocamelSoundManager.soundVolume;
					RetrocamelSoundManager.soundVolume = 0;
				}

				RetrocamelSimpleSave.write('optVolumeSound', RetrocamelSoundManager.soundVolume);
			} else if (e.keyCode == Game.keyMusic) {
				if (RetrocamelSoundManager.musicVolume == 0)
					RetrocamelSoundManager.musicVolume = oldMusicVolume;
				else {
					oldMusicVolume = RetrocamelSoundManager.musicVolume;
					RetrocamelSoundManager.musicVolume = 0;
				}

				RetrocamelSimpleSave.write('optVolumeMusic', RetrocamelSoundManager.musicVolume);
			}
		}
	}
}