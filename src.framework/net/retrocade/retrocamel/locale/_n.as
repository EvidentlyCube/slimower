

package net.retrocade.retrocamel.locale  {
    import net.retrocade.retrocamel.locale.RetrocamelLocale;

    /**
     * Retrieves the localization of text in the current language
     * @param key Key of the string
     * @param rest List of paramteres to supplement in the string
     */
    public function _n(key:String, ...rest):Number{
        var text:String = RetrocamelLocale.get(RetrocamelLocale.selected, key, rest);

        if (text == null || text == ""){
            trace(key+"=???");

            text = RetrocamelLocale.get('en', key, rest);
            if (text == null || text == "")
                return 0;
        }

        return parseFloat(text);
    }
}