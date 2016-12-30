

package net.retrocade.retrocamel.particles {

    import flash.display.BitmapData;

    import net.retrocade.retrocamel.core.RetrocamelCore;
    import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
    import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
    import net.retrocade.utils.UtilsNumber;

    /**
     * ...
     * @author ...
     */
    public class RetrocamelParticlesFireworks extends RetrocamelUpdatableObject {
        protected var _blitLayer:RetrocamelLayerFlashBlit;
        protected var _fire:Vector.<Vector.<int>>;  //[x, y, color, life, xSpeed, ySpeed]
        protected var _particles:Vector.<Vector.<int>>;  //[x, y, color, life, xSpeed, ySpeed]
        protected var _aliveFires:uint = 0;
        protected var _aliveParticles:uint = 0;
        protected var _gravity:uint;
        protected var _colors:Array = [];

        public function RetrocamelParticlesFireworks(blitLayer:RetrocamelLayerFlashBlit, maxParticles:uint = 100, gravity:int = 2) {
            RetrocamelCore.groupAfter.add(this);

            _colors[3] = new BitmapData(2, 2, false, 0xFFFF0000);
            _colors[2] = new BitmapData(2, 2, false, 0xFFFFFF00);
            _colors[1] = new BitmapData(2, 2, false, 0xFF00FF00);
            _colors[0] = new BitmapData(2, 2, false, 0xFF0000FF);

            _gravity = gravity;
            _blitLayer = blitLayer;

            if (!_blitLayer) {
                throw new ArgumentError('blitLayer cannot be null!');
            }

            _particles = new <Vector.<int>>[];
            _fire = new <Vector.<int>>[];
            for (var i:int = 0; i < maxParticles; i++) {
                _particles[i] = new Vector.<int>();
                _fire     [i] = new Vector.<int>();
            }
        }

        override public function update():void {
            _blitLayer.clear();

            var i:int = _aliveParticles;
            while (i--) {
                if (--_particles[i][3] < 0) {
                    var temp:Vector.<int> = _particles[i];
                    _particles[i] = _particles[--_aliveParticles];
                    _particles[_aliveParticles] = temp;

                    continue;
                }

                _blitLayer.plot(_particles[i][0] / 100, _particles[i][1] / 100, _particles[i][2]);
                _particles[i][0] += _particles[i][4];
                _particles[i][1] += _particles[i][5] + _gravity;
            }

            i = _aliveFires;
            while (i--) {
                if (--_fire[i][3] < 0) {
                    temp = _fire[i];
                    _fire[i] = _fire[--_aliveFires];
                    _fire[_aliveFires] = temp;
                    continue;
                }

                _blitLayer.plot(_fire[i][0] / 100, _fire[i][1] / 100, _fire[i][2]);
                _fire[i][0] += _fire[i][4];
                _fire[i][1] += _fire[i][5] += _gravity;
            }
        }

        public function clear():void {
            _aliveParticles = 0;
        }

        public function explode(x:int, y:int, color:uint):void {
            var spd:Number, dir:Number, clr:Number, count:uint = Math.random() * 100 + 100;
            if (_aliveFires + count > _fire.length) {
                count = _fire.length - _aliveFires;
            }
            for (var i:int = 0; i < count; i++) {
                if (_aliveFires == _fire.length) {
                    return;
                }

                spd = UtilsNumber.randomWaved(200, 150);
                dir = UtilsNumber.randomWaved(360 * i / count, 3) * Math.PI / 180;
                clr = color;

                var rnd:Number = Math.random();

                var clr1:uint = (0xFF - (color >> 16 & 0xFF)) * rnd;
                var clr2:uint = (0xFF - (color >> 8 & 0xFF)) * rnd;
                var clr3:uint = (0xFF - (color & 0xFF)) * rnd;

                clr1 = ((color >> 16 & 0xFF) + clr1 & 0xFF) << 16;
                clr2 = ((color >> 8 & 0xFF) + clr2 & 0xFF) << 8;
                clr3 = ((color & 0xFF) + clr3 & 0xFF);

                _fire[_aliveFires]  [0] = x * 100;
                _fire[_aliveFires]  [1] = y * 100;
                _fire[_aliveFires]  [2] = clr1 | clr2 | clr3 | 0xFF000000;
                _fire[_aliveFires]  [3] = UtilsNumber.randomWaved(60, 40);
                _fire[_aliveFires]  [4] = Math.cos(dir) * spd;
                _fire[_aliveFires++][5] = Math.sin(dir) * spd;
            }
        }

        public function add(x:int, y:int, color:uint, life:int, xSpeed:int, ySpeed:int):void {
            if (_aliveFires == _fire.length || (color & 0xFF000000) == 0) {
                return;
            }

            _fire[_aliveFires]  [0] = x * 100;
            _fire[_aliveFires]  [1] = y * 100;
            _fire[_aliveFires]  [2] = color;
            _fire[_aliveFires]  [3] = life;
            _fire[_aliveFires]  [4] = xSpeed;
            _fire[_aliveFires++][5] = ySpeed;
        }
    }
}