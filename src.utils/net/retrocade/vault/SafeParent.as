
package net.retrocade.vault{
    
    /**
     * @private
     * Safe is a parent class for sub-safe classes which are used to store and obfuscate a sensitive data
     * for the Safe class.
     */
    internal class SafeParent{
        
        protected var unchanged:Number = 0;

        internal function get():Number {
            return NaN;
        }
        
        internal function set(newNum:Number):Number {
            return NaN;
        }
        
        internal function check():Boolean{
            return false;
        }
        
        internal function safeToString():String{
            return "";
        }
        
        internal function stringToSafe(string:String):Boolean{
            return false;
        }

        public function SafeParent() {}
    }
}