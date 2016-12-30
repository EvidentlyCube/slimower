package game.objects{
    import game.global.Game;
    import game.global.Level;
    import game.tiles.TTile;
    
    import net.retrocade.collision.RetrocamelSimpleCollider;
    import net.retrocade.retrocamel.interfaces.IRetrocamelSpatialHashElement;

    public class TPlayerBullet extends TGameObject implements IRetrocamelSpatialHashElement{
        public var dir:Number = 0;
        public var timer:uint = 35;
        
        public function TPlayerBullet(x:uint, y:uint, dir:Number){
            this.x   = x;
            this.y   = y;
            this.dir = dir;
            
            _width  = 3;
            _height = 3;
            
            addDefault();
            
            Level.enemies.add(this);
        }
        
        override public function update():void{
            Level.enemies.remove(this);
            x += Math.cos(dir) * 3;
            y += Math.sin(dir) * 3;
            Level.enemies.add(this);
            
            timer--;
            
            var tile:TTile = getTile(x, y);
            if (tile){
                if (getTile(center, middle)){
                    kill();
                    return;
                }
            } 
            if (timer <= 0){
                kill();
                return;
            }
                    
            var enemies:Array = Level.enemies.getOverlapping(this);
            for each(var enemy:* in enemies){
                if (!(enemy is TMonster)) continue;
                if (!RetrocamelSimpleCollider.rectRect(_x, _y, 3, 3, enemy.x, enemy.y, enemy.width, enemy.height)) continue;
                
                enemy.damage(1, this);
                kill();
                return;
            }

            Game.lGame.shapeRect(x + scrollX, y + scrollY, 3, 3, getColor());
        }
        
        override public function draw():void{
            Game.lGame.shapeRect(x + scrollX, y + scrollY, 3, 3, getColor());
        }
        
        private function kill():void{
            nullifyDefault();
            Level.enemies.remove(this);
        }
        
        private function getColor():uint{
            var color:uint = 0xFF * Math.random();
            return 0xFF0000FF | (color << 16) | (color << 8);
        }
    }
}