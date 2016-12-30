package game.standalone{
    import game.global.Game;
    import game.global.Level;
    
    import net.retrocade.helpers.RetrocamelScrollAssist;
    import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
    import net.retrocade.retrocamel.particles.RetrocamelParticlesFireworks;

    public class ParticleFireworksExt extends RetrocamelParticlesFireworks{
        public function ParticleFireworksExt(blitLayer:RetrocamelLayerFlashBlit, maxParticles:uint = 100, gravity:int = 2) {
            super(blitLayer,maxParticles, gravity);
        }
        
        override public function update():void {
            var scrollX:Number = - RetrocamelScrollAssist.x;
            var scrollY:Number = - RetrocamelScrollAssist.y;
            
            _blitLayer.clear();
            
            var i:int = _aliveParticles;
            while (i--) {
                if (--_particles[i][3] < 0) {
                    var temp:Vector.<int>     = _particles[i];
                    _particles[i]               = _particles[--_aliveParticles];
                    _particles[_aliveParticles] = temp;
                    
                    continue;
                }
                
                _blitLayer.plot(_particles[i][0] / 100 + scrollX, _particles[i][1] / 100 + scrollY, _particles[i][2]);
                _particles[i][0] += _particles[i][4];
                _particles[i][1] += _particles[i][5] + _gravity;
            }
            
            i = _aliveFires;
            while (i--) {
                if (--_fire[i][3] < 0 || Level.level.get(_fire[i][0] / 100, _fire[i][1] / 100)) {
                    temp               = _fire[i];
                    _fire[i]           = _fire[--_aliveFires];
                    _fire[_aliveFires] = temp;
                    continue;
                }
                
                _blitLayer.plot(_fire[i][0] / 100 + scrollX, _fire[i][1] / 100 + scrollY, _fire[i][2]);
                _fire[i][0] += _fire[i][4];
                _fire[i][1] += _fire[i][5] +=  _gravity;
            }
        }
    }
}