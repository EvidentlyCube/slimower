

package net.retrocade.vault{
    
    /**
     * @private
     * Safe is a parent class for sub-safe classes which are used to store and obfuscate a sensitive data
     * for the Vault class.
     */
    internal class Safe2 extends SafeParent{
        
        public var floorSin25         :Number;
        public var ceilCos30          :Number;
        public var atan2plus1         :Number;
        public var module23           :Number;

        override internal function get():Number{
            check();
            return unchanged;
        } 
        
        override internal function set(newNum:Number):Number{
            unchanged           = newNum;
            floorSin25          = Math.floor( Math.sin  (unchanged)              * 25 );
            ceilCos30           = Math.ceil ( Math.cos  (unchanged)              * 30 );
            atan2plus1          = Math.floor( Math.atan2(unchanged, unchanged+1) * 50 );
            module23            = unchanged % 23;

            return newNum;
        }
        
        override internal function check():Boolean{
            if (floorSin25         != Math.floor( Math.sin  (unchanged)              * 25 )
                    || ceilCos30           != Math.ceil ( Math.cos  (unchanged)              * 30 )
                    || atan2plus1          != Math.floor( Math.atan2(unchanged, unchanged+1) * 50 )
                    || module23            != unchanged % 23
            ){
                
                Vault.fakeValue();
                return false;
                
            } else {
                return true;
                
            }
        }
        
        override internal function safeToString():String{
            return "2" + unchanged.toString() + "`" + floorSin25.toString() + "`" + ceilCos30.toString() + "`" + atan2plus1.toString() + "`" + module23.toString() + "`";
        }
        
        override internal function stringToSafe(string:String):Boolean{
            string = string.substr(1);
            
            var array:Array = string.split("`");
            
            if (array.length < 6)
                return false;
            
            unchanged           = array[0];
            floorSin25          = array[1];
            ceilCos30           = array[2];
            atan2plus1          = array[3];
            module23            = array[4];

            return true;
        } 
    }
}