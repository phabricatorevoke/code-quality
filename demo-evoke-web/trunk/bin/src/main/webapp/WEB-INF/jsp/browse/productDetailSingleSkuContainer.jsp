<%--
  The container page to display product details for products with single
  SKU. 

  Required parameters:
    product
      The product object whose details to show.

  Optional parameters:
    categoryId
      The ID of the category the product is viewed from.
    tabname
      The name of a more details tab to display.
    initialQuantity
      Specifies the initial quantity to preset in the form.
--%>
<dsp:page>

  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />

  <crs:pageContainer bodyClass="atg_store_pageProductDetail">
    <jsp:attribute name="SEOTagRenderer">
      <%--
        Include SEO meta data and pass product item to metaDetails.jsp gadget
        to include product's description and keywords into meta details.
      --%>
      <dsp:include page="/global/gadgets/metaDetails.jsp">
        <dsp:param name="catalogItem" param="product"/>     
      </dsp:include>
    </jsp:attribute>
    
    <jsp:attribute name="formErrorsRenderer">
       <%-- Display error messages if any above the accessibility navigation --%>  
      <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
        <dsp:param name="formHandler" bean="CartFormHandler"/>
      </dsp:include>
      <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
        <dsp:param name="formHandler" bean="GiftlistFormHandler"/>
      </dsp:include>
    </jsp:attribute>
    
    <jsp:body>
      <dsp:getvalueof var="item" param="product"/>
      <preview:repositoryItem item="${item}">
        <%--
          Display header with product's name, category upper banner and promotion,
          bread crumbs.
        --%>
        <dsp:include page="/browse/gadgets/itemHeader.jsp">
          <dsp:param name="displayName" param="product.displayName"/>
          <dsp:param name="category" param="navCategory"/>
          <dsp:param name="categoryNavIds" param="categoryNavIds"/> 
        </dsp:include>

        <%-- Display error messages for CartFormHandler if there are any. --%>
        <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
          <dsp:param name="formHandler" bean="CartFormHandler"/>
        </dsp:include>
        <%-- Display error messages for GiftlistFormHandler if there are any. --%>
        <dsp:include page="/global/gadgets/displayErrorMessage.jsp">
          <dsp:param name="formHandler" bean="GiftlistFormHandler"/>
        </dsp:include>

        <div id="atg_store_productCore" class="atg_store_productSingleSkuWide">

         
            <%-- As we are working with single SKU product just take the first SKU
                 from child SKUs list.  --%>              
            <dsp:param name="selectedSku" param="product.childSKUs[0]" />                

            <%-- Display product image --%>
            <div class="atg_store_productImage">
              <%-- Product image will not change so cache it. --%>
              <dsp:include page="gadgets/cacheProductDisplay.jsp">
                <dsp:param name="product" param="product"/>
                <dsp:param name="container" value="/browse/gadgets/productImage.jsp"/>
                <dsp:param name="categoryId" param="categoryId"/>
                <dsp:param name="keySuffix" value="image"/>
              </dsp:include>
            </div>

            <dsp:droplet name="/atg/store/droplet/ProductDetailsDroplet">
              <dsp:param name="product" param="product"/>
              <dsp:param name="selectedSku" param="selectedSku"/>
              <dsp:oparam name="output">
                <div id="productInfoContainer">

                  <div class="atg_store_productSummary">
                     <dsp:form id="addToCart" formid="atg_store_addToCart"
                                action="${originatingRequest.requestURI}" method="post" name="addToCart">
                    <%-- Product's price --%>
                    <%@include file="/browse/gadgets/pickerPriceAttribute.jspf" %>

                    <div class="atg_store_productAvailability">

                      <dsp:getvalueof var="contextRoot" vartype="java.lang.String"
                                      bean="/OriginatingRequest.contextPath" />
                      <dsp:getvalueof var="productId" param="productId" />
                      <dsp:getvalueof var="categoryId" param="categoryId" />
                      <%-- Get product's template --%>
                      <dsp:getvalueof var="productTemplateURL" vartype="java.lang.String"
                                      param="product.template.url" />
                      <%-- Build Error URL for Add to cart action --%>
                      <dsp:getvalueof var="errorURL" vartype="java.lang.String"
                                      value="${originatingRequest.contextPath}${productTemplateURL}?productId=${productId}&categoryId=${categoryId}" />

                      <%-- Hidden form's input parameters --%>
                      <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden"
                                 value="${errorURL}" />
                      <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden"
                                 value="${originatingRequest.contextPath}/cart/cart.jsp" />
                      <dsp:input bean="CartFormHandler.sessionExpirationURL" type="hidden"
                                 value="${originatingRequest.contextPath}/global/sessionExpired.jsp" />

                      <%-- URLs for the RichCart AJAX response. Renders cart contents as JSON --%>
                      <dsp:input bean="CartFormHandler.ajaxAddItemToOrderSuccessUrl" type="hidden" value="${originatingRequest.contextPath}/cart/json/cartContents.jsp" />
                      <dsp:input bean="CartFormHandler.ajaxAddItemToOrderErrorUrl" type="hidden" value="${originatingRequest.contextPath}/cart/json/errors.jsp" />

                      <%-- Number of elements to allocate in the items array of CartFormHandler --%>
                      <dsp:input bean="CartFormHandler.addItemCount" value="1" type="hidden" />

                      <dsp:input bean="CartFormHandler.items[0].catalogRefId" paramvalue="product.childSKUs[0].repositoryId" type="hidden" />
                      <dsp:input bean="CartFormHandler.items[0].productId" paramvalue="product.repositoryId" type="hidden" />

                    </div>

                    <div class="atg_store_addQty">
                      <%-- Quantity --%>
                      <div class="atg_store_quantity">
                        <%-- Quantity Field --%>
                        <%@include file="/browse/gadgets/pickerQuantityAttribute.jspf" %>
                        <%-- SKU id--%>
                        <%@include file="/browse/gadgets/pickerItemId.jspf" %>
                      </div><%-- atg_store_quantity --%>
                      <div class="atg_store_productAvailability">
                        <%-- SKU availability message --%>
                        <%@include file="/browse/gadgets/pickerAvailabilityMessage.jspf"%>
                        <%-- Add to cart button --%>
                        <%@include file="/browse/gadgets/pickerAddToCart.jspf" %>
                      </div>
                    </div><%-- atg_store_addQty --%>

                    <div class="atg_store_pickerActions">
                      <%-- Display other action buttons: add to gift list/wish list, email a friend. --%>
                      <dsp:include page="gadgets/pickerActions.jsp">
                        <dsp:param name="comparisonsContainsProduct" param="comparisonsContainsProduct"/>
                        <dsp:param name="showEmailAFriend" param="showEmailAFriend"/>
                        <dsp:param name="showGiftlists" param="showGiftlists"/>
                        <dsp:param name="wishlistContainsSku" param="wishlistContainsSku"/>
                        <dsp:param name="giftlists" param="giftlists"/>
                      </dsp:include>
                    </div>
                    </dsp:form>
                  </div>
              </dsp:oparam>
            </dsp:droplet>
     

          <%--
            Display product attributes like description, as seen in, etc.
            Cache this part of page as it will not change for the given product.
          --%>
          <dsp:include page="gadgets/cacheProductDisplay.jsp">
            <dsp:param name="product" param="product"/>
            <dsp:param name="container" value="/browse/gadgets/productAttributes.jsp"/>
            <dsp:param name="categoryId" param="categoryId"/>
            <dsp:param name="keySuffix" value="details"/>
            <dsp:param name="initialQuantity" param="initialQuantity" />
          </dsp:include>
        </div>
      
        <%-- Include recommendations container --%>
        <dsp:include page="gadgets/productRecommendationsContainer.jsp">
          <dsp:param name="productId" param="productId"/>
        </dsp:include> 

            
        </div>
      </preview:repositoryItem>
      <%-- Display recently viewed products --%>
      <dsp:include page="/browse/gadgets/recentlyViewed.jsp">
        <dsp:param name="exclude" param="product.id"/>
      </dsp:include>

    </jsp:body>
  </crs:pageContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/browse/productDetailSingleSkuContainer.jsp#1 $$Change: 713790 $--%>
