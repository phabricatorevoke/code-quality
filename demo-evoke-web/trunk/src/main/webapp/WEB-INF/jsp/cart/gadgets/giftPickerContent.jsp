<%--
  This gadget renders a JavaScript-enabled version of color/size picker for the gift item.
  It displays a set of buttons to select appropriate color and size (that is appropriate SKU).
  
  Required parameters:
    productId
      Specifies a currently viewed product.
      
    gwpRadioId
      The radio button associated with the color/size picker.
--%>

<dsp:page>
  <dsp:getvalueof id="productId" param="productId"/>
  <dsp:getvalueof id="gwpRadioId" param="gwpRadioId"/>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet"/>
  <dsp:importbean bean="/atg/store/droplet/ColorSizeDroplet"/>
  <dsp:importbean bean="/atg/store/droplet/WoodFinishDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/userprofiling/PropertyManager"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>

  <dsp:getvalueof var="contextRoot" vartype="java.lang.String"  bean="/OriginatingRequest.contextPath"/>

  <%-- Because this page is called directly using ajax, it must look up the product. --%>
  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" param="productId"/>
    <dsp:param name="filterBySite" value="false"/>
    <dsp:param name="filterByCatalog" value="false"/>
    <dsp:oparam name="output">
      <dsp:setvalue param="product" paramvalue="element"/>

      <dsp:getvalueof var="productTemplateURL" vartype="java.lang.String" param="product.template.url"/>
      <dsp:getvalueof var="errorURL" vartype="java.lang.String"
                      value="${originatingRequest.contextPath}${productTemplateURL}?productId=${productId}&categoryId=${categoryId}"/>
      <dsp:getvalueof var="skus" param="product.childSKUs" />
      <dsp:getvalueof var="skulength" value="${fn:length(skus)}" />
      
      <%-- Determine type of picker to display proper selector --%>
      <dsp:getvalueof var="skuType" param="product.childSKUs[0].type"/>
      
      <c:choose>
      
        <%-- Clothing SKU, display color/size picker --%>
        <c:when test="${skuType == 'clothing-sku'}">
          <%--
            This droplet calculates available colors and sizes for a collection of SKUs specified.
            It also searches for a SKU specified by its color and size properties.

            Input parameters:
              product
                Specifies a product to be processed.
              skus
                Collection of child SKUs.
              selectedColor
                Currently selected color.
              selectedSize
                Currently selected size.

            Output parameters:
              selectedSku
                Specifies a selected SKU, if both color and size are specified.
              availableColors
                All available colors.
              availableSizes
                All available sizes.

            Open parameters:
              output
                Always rendered.
          --%>
          <dsp:droplet name="ColorSizeDroplet">
            <dsp:param name="skus" param="product.childSKUs"/>
            <dsp:param name="selectedColor" param="selectedColor"/>
            <dsp:param name="selectedSize" param="selectedSize"/>
            <dsp:param name="product" param="product"/>
            <dsp:oparam name="output">
              <%-- Signal, that we're displaying a clothing-sku. Will be used later. --%>
              <dsp:param name="skuType" value="clothing"/>
              
              <dsp:getvalueof var="colors" param="availableColors"/>
              <dsp:getvalueof var="sizes" param="availableSizes"/>     
                  
              <div id="gift_contents_${productId}">
                <dsp:form id="addToCart_${productId}" formid="selectGift_${productId}"
                          action="${originatingRequest.requestURI}" method="post"
                          name="selectGift">
                  <div id="atg_gift_picker_${productId}">
                    <div class="atg_store_pickerContainer">      
                      <%@ include file="/cart/gadgets/giftColorPicker.jspf" %>
                      <%@ include file="/cart/gadgets/giftSizePicker.jspf" %>
                    </div>
                  </div>
                </dsp:form>
              </div>
            
              <%-- Include invisible form, it's used for refreshing the picker. --%>
              <dsp:form formid="colorsizerefreshform_${productId}" id="colorsizerefreshform_${productId}" method="post"
                        action="${pageContext.request.contextPath}/cart/gadgets/giftPickerContent.jsp">
                <input name="skuId" type="hidden" value='<dsp:valueof param="selectedSku.repositoryId"/>'/>        
                <input name="productId" type="hidden" value='<dsp:valueof param="productId"/>'/>
                <input name="gwpRadioId" type="hidden" value='<dsp:valueof param="gwpRadioId"/>'/>
                <input name="skuType" type="hidden" value="clothing"/>
                                    
                <c:if test="${fn:length(colors) > 0}">
                 <dsp:getvalueof var="colorIsSelected" param="colorIsSelected"/>
                 <dsp:getvalueof var="selectedColorValue" value=""/>
                 <c:if test="${colorIsSelected}">
                   <dsp:getvalueof var="selectedColor" param="selectedColor"/>
                   <dsp:getvalueof var="selectedColorValue" value="${selectedColor}"/>
                 </c:if>
                 <input name="selectedColor" type="hidden" value='${selectedColorValue}'/>                       
                </c:if>  
                
                <c:if test="${fn:length(sizes) > 0}">
                  <dsp:getvalueof var="selectedSize" param="selectedSize"/>
                  <input name="selectedSize" type="hidden" value='${selectedSize}'/>
                </c:if>
                
              </dsp:form>
           </dsp:oparam>
        </dsp:droplet><%-- ColorSizeDroplet --%>
        
        </c:when>
        
        <%-- Furniture SKU, display wood finish picker --%>
        <c:when test="${skuType == 'furniture-sku'}">
        
          <%--
            This droplet calculates available wood finishes for a collection of SKUs specified.
            It also searches for a SKU specified by its wood finish.
                
            Input parameters:
              product
                Specifies a product to be processed.
              skus
                Collection of child SKUs.
              selectedColor
                Currently selected wood finish.

            Output parameters:
              selectedSku
                Specifies a selected SKU, if wood finish is specified.
              availableColors
                All available wood finishes.
                  
            Open parameters:
              output
                Always rendered.
          --%>
          <dsp:droplet name="WoodFinishDroplet">
            <dsp:param name="skus" param="product.childSKUs"/>
            <dsp:param name="selectedColor" param="selectedColor"/>
            <dsp:param name="product" param="product"/>

            <dsp:oparam name="output">
              <dsp:param name="skuType" value="furniture"/>
            
              <dsp:getvalueof var="colors" param="availableColors"/>
            
              <div id="gift_contents_${productId}">
                <dsp:form id="addToCart_${productId}" formid="selectGift_${productId}"
                          action="${originatingRequest.requestURI}" method="post"
                          name="selectGift">
                  <div id="atg_gift_picker_${productId}">
                    <div class="atg_store_pickerContainer">
                      <%@ include file="/cart/gadgets/giftColorPicker.jspf" %>
                    </div>
                  </div>
                </dsp:form>
              </div>
              
              <%-- Include invisible form, it's used for refreshing the picker. --%>
              <dsp:form formid="colorsizerefreshform_${productId}" id="colorsizerefreshform_${productId}" method="post"
                        action="${pageContext.request.contextPath}/cart/gadgets/giftPickerContent.jsp">
                <input name="skuId" type="hidden" value='<dsp:valueof param="selectedSku.repositoryId"/>'/>        
                <input name="productId" type="hidden" value='<dsp:valueof param="productId"/>'/>
                <input name="gwpRadioId" type="hidden" value='<dsp:valueof param="gwpRadioId"/>'/>
                <input name="skuType" type="hidden" value="furniture"/>
                
                <c:if test="${fn:length(colors) > 0}">
                 <dsp:getvalueof var="colorIsSelected" param="colorIsSelected"/>
                 <dsp:getvalueof var="selectedColorValue" value=""/>
                 <c:if test="${colorIsSelected}">
                   <dsp:getvalueof var="selectedColor" param="selectedColor"/>
                   <dsp:getvalueof var="selectedColorValue" value="${selectedColor}"/>
                 </c:if>
                 <input name="selectedColor" type="hidden" value='${selectedColorValue}'/>                       
                </c:if>
                
              </dsp:form>
            </dsp:oparam>
          </dsp:droplet>
        </c:when>
        
        <%-- Regular SKU without picker --%>
        <c:otherwise>
          
        </c:otherwise>
      </c:choose> 
    </dsp:oparam>
  </dsp:droplet><%-- ProductLookup --%>   
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/cart/gadgets/giftPickerContent.jsp#1 $$Change: 713790 $ --%>
