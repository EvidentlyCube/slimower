

package net.retrocade.retrocamel.interfaces
{
    import net.retrocade.retrocamel.display.flash.RetrocamelSprite;
    import net.retrocade.retrocamel.display.flash.RetrocamelButton;

    public interface IRetrocamelMake{
        function button(onClick:Function, text:String, width:Number = NaN):*;
    }
}