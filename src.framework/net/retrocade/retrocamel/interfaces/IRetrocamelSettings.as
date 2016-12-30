

package net.retrocade.retrocamel.interfaces{

    public interface IRetrocamelSettings{
        function get languages():Array;
        
        function get gameWidth():uint;
        function get gameHeight():uint;

        function get swfWidth():uint;
        function get swfHeight():uint;
    }
}