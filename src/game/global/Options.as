package game.global {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	import game.standalone.VolumeBar;

	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;

	import net.retrocade.retrocamel.display.flash.RetrocamelButton;

	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.locale._;

	public class Options extends Sprite {
		[Embed(source='/../src.assets/global/music.png')]
		private var _gfx_music_:Class;
		[Embed(source='/../src.assets/global/sfx.png')]
		private var _gfx_sfx_:Class;

		private var _iconMusic:Bitmap;
		private var _iconSfx:Bitmap;

		private var _barMusic:VolumeBar;
		private var _barSfx:VolumeBar;

		private var _keyChangers:Array = [];
		private var _nowChanging:RetrocamelButton;

		public function Options() {
			_iconMusic = new _gfx_music_;
			_iconSfx = new _gfx_sfx_;
			_barMusic = new VolumeBar(changedMusic);
			_barSfx = new VolumeBar(changedSfx);

			_iconMusic.x = 65;
			_iconSfx.x = 65;
			_iconSfx.y = 40;

			_barMusic.gfx.x = 105;
			_barSfx.gfx.x = 105;
			_barSfx.gfx.y = 40;

			reset();

			addChild(_iconMusic);
			addChild(_iconSfx);
			addChild(_barMusic.gfx);
			addChild(_barSfx.gfx);

			for each(var s:String in Game.allKeys)
				addKeyChanger(s);
		}

		public function reset():void {
			_barMusic.value = RetrocamelSoundManager.musicVolume;
			_barSfx.value = RetrocamelSoundManager.soundVolume;
		}

		private function addKeyChanger(keyName:String):void {
			var wid:Number = 125;

			var button:RetrocamelButton = Make().buttonColor(onKeyChangeClick, _('key' + Game[keyName]), 120);
			var desc:RetrocamelBitmapText = Make().text(_(keyName + 'Desc') + ":");

			button.data.keyName = keyName;
			button.data.desc = desc;
			button.data.txt.positionToCenter();

			button.x = (_keyChangers.length % 3) * wid | 0;// + (wid - button.width) / 3 | 0;
			button.y = (_keyChangers.length / 3 | 0) * 60 + 90;

			desc.x = (_keyChangers.length % 3) * wid + (wid - desc.width) / 2 | 0;
			desc.y = button.y - 16;

			addChild(desc);
			addChild(button);
			_keyChangers.push(button);
		}

		private function onKeyChangeClick(button:RetrocamelButton):void {
			button.data.txt.text = "...";
			button.data.txt.positionToCenter();

			stage.mouseChildren = false;

			RetrocamelInputManager.addStageKeyDown(onKeyChangePress);

			_nowChanging = button;
		}

		private function onKeyChangePress(e:KeyboardEvent):void {
			RetrocamelInputManager.removeStageKeyDown(onKeyChangePress);

			stage.mouseChildren = true;

			Game[_nowChanging.data.keyName] = e.keyCode;
			_nowChanging.data.txt.text = _('key' + e.keyCode);
			_nowChanging.data.txt.positionToCenter();

			RetrocamelSimpleSave.write('opt' + _nowChanging.data.keyName, e.keyCode);
		}

		private function changedMusic(value:Number):void {
			RetrocamelSoundManager.musicVolume = value;
			RetrocamelSimpleSave.write('optVolumeMusic', value);
		}

		private function changedSfx(value:Number):void {
			RetrocamelSoundManager.soundVolume = value;
			RetrocamelSimpleSave.write('optVolumeSound', value);
		}
	}
}