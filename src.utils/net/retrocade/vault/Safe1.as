

package net.retrocade.vault{
    
    /**
     * @private
     * Safe is a parent class for sub-safe classes which are used to store and obfuscate a sensitive data
     * for the Vault class.
     */
    internal class Safe1 extends SafeParent{
        
        public var module71           :Number;
        public var random100          :Number;
        public var module71squareFloor:Number;

        override internal function get():Number{
            check();
            return unchanged;
        } 
        
        override internal function set(newNum:Number):Number{
            unchanged           = newNum;
            module71            = unchanged % 71;
            random100           = unchanged + Math.random() * 100;
            module71squareFloor = Math.floor( Math.sqrt(unchanged % 71) )

            return newNum;
        }
        
        override internal function check():Boolean{
            if (module71           != unchanged % 71
            || random100            < unchanged
            || random100            > unchanged + 100
            || module71squareFloor != Math.floor( Math.sqrt(unchanged % 71) )){
                
                Vault.fakeValue();
                return false;
                
            } else {
                return true;
                
            }
        }
        
        override internal function safeToString():String{
            return "1" + unchanged.toString() + "`" + module71.toString() + "`" + random100.toString() + "`" + module71squareFloor.toString() + "`";
        }
        
        override internal function stringToSafe(string:String):Boolean{
            string = string.substr(1);
            
            var array:Array = string.split("`");
            
            if (array.length < 6)
                return false;
            
            unchanged           = array[0];
            module71            = array[1];
            random100           = array[2];
            module71squareFloor = array[4];

            return true;
        } 
    }
}