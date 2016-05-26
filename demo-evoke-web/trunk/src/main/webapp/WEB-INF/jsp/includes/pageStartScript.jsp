<%--
  Include all Javascript files that need to be loaded for the page. 
  All <script> blocks should be included on this page to perform any page initialization.
  
  Required Parameters:
    None
    
  Optional Parameters:
    None
--%>

<dsp:page>
  <dsp:getvalueof var="storeConfig" bean="/atg/store/StoreConfiguration"/>
  <fmt:message key="common.button.pleaseWaitText" var="pleaseWaitMessage"/>
  <c:set var="javascriptRoot" value="${pageContext.request.contextPath}/javascript"/>

  <%-- 
    Include dojo from WebUI module. 
    Context root for dojo version 1.6.1 is configured in WebUI module as '/dojo-1-6-1' 
  --%>
  <script type="text/javascript">
    <%-- 
      Dojo Configuration.

      Enable/Disable Dojo debugging - This will log any dojo.debug calls to the Firebug console if installed. 
      Enable debugging by setting component /atg/store/StoreConfiguration.dojoDebug=true 
    --%>
    var djConfig={
      disableFlashStorage: true,
      parseOnLoad: true,
      isDebug: ${storeConfig.dojoDebug}
    };
  </script> 
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dojo.js.uncompressed.js"></script>

  <script type="text/javascript">
  dojo.require = function(){}  
  </script>
  
  <script type="text/javascript" src="/dojo-1-6-1/dojo/window.js"></script> 
  <script type="text/javascript" src="/dojo-1-6-1/dojo/back.js"></script> 
  <script type="text/javascript" src="/dojo-1-6-1/dojo/fx.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/NodeList-traverse.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dnd/autoscroll.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dnd/common.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dnd/Mover.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dnd/Moveable.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dnd/move.js"></script>  
  <script type="text/javascript" src="/dojo-1-6-1/dojo/dnd/TimedMoveable.js"></script>  
  <script type="text/javascript" src="/dojo-1-6-1/dijit/nls/dijit-all_en-us.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/dijit.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dojox/fx/_base.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/i18n.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dojo/html.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/form/_FormMixin.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/layout/_ContentPaneResizeMixin.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/layout/ContentPane.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/DialogUnderlay.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/_DialogMixin.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dijit/Dialog.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojox/image/Lightbox.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/TooltipDialog.js"></script>
  <script type="text/javascript" src="/dojo-1-6-1/dojo/number.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/_Container.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/_HasDropDown.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/form/_FormWidget.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/form/Button.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/form/HorizontalSlider.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/form/VerticalSlider.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dojox/form/RangeSlider.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/_Widget.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/_Templated.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dijit/form/HorizontalRule.js"></script>
  <script type="text/javascript"src="/dojo-1-6-1/dojo-fixes.js"></script>
  
  <%-- 
    Include all Javascript files that need to be loaded for the page. 
    All <script> blocks should be included on this page to perform any page initialization. 
  --%>  
  <c:set var="javascriptRoot" value="${pageContext.request.contextPath}/javascript"/>
  
  
  
  <script type="text/javascript">
    <%-- Create global var with webapp context path - this can be used to build absolute urls--%>
    var contextPath="${pageContext.request.contextPath}";
    <%-- Define Store javascript modules path --%>
    dojo.registerModulePath('atg.store', contextPath+'/javascript');
    <%-- Define all required dojo modules. Any custom defined widgets should be listed here. --%>    
    
    <%-- Add any required page initialisation functions here. DO NOT use <body onload=...>  --%>

  </script>
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartTrigger.js"></script> 
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartSummary.js"></script>  
  <script type="text/javascript" src="${javascriptRoot}/widget/RichCartSummaryItem.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/richCartMessage.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/enterSubmit.js"></script>

  <script type="text/javascript" src="${javascriptRoot}/widget/FacetManager.js"></script>  
  <script type="text/javascript" src="${javascriptRoot}/widget/FacetGroup.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/FacetValue.js"></script>
  
  <script type="text/javascript" src="/WebUI/preview/preview_tagging.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/widget/ProductView.js"></script>
  
  
  <%-- Include other required external Javascript files --%>
  <script type="text/javascript" src="${javascriptRoot}/Lightbox.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/picker.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/dialog.js"></script>
  <script type="text/javascript" src="${javascriptRoot}/store.js"></script>

  <%-- 
    Include any store-specific Javascript files. These should be added to the jsp included
    here, and copied to the store-specific application directory  
  --%>
  <script type="text/javascript" charset="utf-8">
    var formIdArray = ["atg_store_preRegisterForm","atg_store_registerLoginForm","atg_store_checkoutLoginForm","searchForm","simpleSearch"];   
    dojo.addOnLoad(function(){
      atg.store.util.setUpPopupEnhance();
      atg.store.util.addNumericValidation();
      atg.store.util.addReturnHandling();
      atg.store.util.addTextAreaCounter();
      atg.store.util.initAddressHighlighter();
      atg.store.util.dropDownOpen();
      atg.store.util.richButtons("atg_store_basicButton");
      atg.store.util.searchFieldBehaviors(dojo.byId("atg_store_searchInput"), dojo.byId("atg_store_searchSubmit"));
      atg.store.util.giftListLinkBehaviors(dojo.byId("giftList"));
      if(dojo.isMac){ dojo.addClass(dojo.doc.documentElement,"dj_osx"); }
      
      // if(dojo.byId("atg_store_facets")){
      //         atg_facetManager = new atg.store.widget.facetManager({
      //           id:"atg_store_facetManager"
      //         });
      //       }
    });
  </script>
  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/includes/pageStartScript.jsp#5 $$Change: 721209 $--%>
