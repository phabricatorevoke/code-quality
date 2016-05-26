/**
 *  Rich Cart Message Widget
 *
 *  Created by ATG 
 *
 *  Widget for the display of a single message and it's state.
 *
 */
dojo.provide("atg.store.widget.RichCartMessage");


dojo.declare(
  "atg.store.widget.RichCartMessage", 
  [dijit._Widget, dijit._Templated],
  {
    debugOn: true,
    templateString: dojo.cache("dijit", contextPath + "/javascript/widget/template/richCartMessage.html"),
    parentWidget: "",
    data: null,
    
    startup: function() {
    console.debug("Cart message startup");
  }
})