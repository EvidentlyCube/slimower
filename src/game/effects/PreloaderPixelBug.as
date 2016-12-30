package game.effects {
	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;

	public class PreloaderPixelBug extends RetrocamelUpdatableObject {

		private var _rightEdge:int = 0;
		private var _bottomEdge:int = 0;

		private var _layer:RetrocamelLayerFlashBlit;

		private var _dir:Number = 0;
		private var _spd:Number;

		private var _colorLight:uint;
		private var _colorPath:uint;

		private var x:Number;
		private var y:Number;

		public function PreloaderPixelBug(layerToDraw:RetrocamelLayerFlashBlit, edgeRight:int, edgeBottom:int, spd:Number, colorLight:uint = 0xFFAAAAAA, colorDark:uint = 0xFF222222) {
			_layer = layerToDraw;
			_rightEdge = edgeRight;
			_bottomEdge = edgeBottom;
			_spd = spd;
			_colorLight = colorLight;
			_colorPath = colorDark;

			x = Math.random() * _rightEdge;
			y = Math.random() * _bottomEdge;

			_dir = (Math.random() * 4 | 0) * Math.PI / 2;

			addDefault();
		}

		override public function update():void {

			var _spdStep:Number = _spd;
			var _spdMod:Number = _spdStep > 1 ? 1 : _spdStep;
			var dirX:Number = Math.cos(_dir);
			var dirY:Number = Math.sin(_dir);

			while (_spdStep > 0) {
				_layer.plot(x, y, _colorPath);

				x += dirX * _spdMod;
				y += dirY * _spdMod;

				_spdMod = _spdStep > 1 ? 1 : _spdStep
				_spdStep -= _spdMod;
			}

			if (Math.random() < 0.01) {
				_dir += (Math.random() * 3 | 0 - 1) * Math.PI / 2;
			}

			_layer.plot(x, y, _colorLight);

			if (x < 0) x += _rightEdge;
			if (y < 0) y += _bottomEdge;

			if (x > _rightEdge)  x -= _rightEdge;
			if (y > _bottomEdge) y -= _bottomEdge;
		}
	}
}