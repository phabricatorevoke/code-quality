<%--
  This gadget renders a JavaScript-enabled version of wood finish picker for the product details page.
  It displays a set of buttons to select appropriate color and size (that is appropriate SKU).
  It also displays the 'Add to Cart' button and 'Add to gift/wish List' or 'Email a Friend' buttons.

  Required parameters:
    productId
      Specifies a currently viewed product.

  Optional parameters:
    categoryId
      Specifies a currently viewed category.
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/store/droplet/CatalogItemFilterDroplet"/>
  <dsp:importbean bean="/atg/store/droplet/WoodFinishDroplet"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/commerce/catalog/comparison/ProductListHandler"/>

  <dsp:droplet name="ProductLookup">
    <dsp:param name="id" param="productId"/>
    <dsp:oparam name="output">
      <dsp:setvalue param="product" paramvalue="element"/>

      <dsp:getvalueof var="productTemplateURL" vartype="java.lang.String" param="product.template.url"/>
      <dsp:getvalueof var="productId" vartype="java.lang.String" param="productId"/>
      <dsp:getvalueof var="categoryId" vartype="java.lang.String" param="categoryId"/>
      <c:url var="errorURL" value="${productTemplateURL}">
        <c:param name="productId" value="${productId}"/>
        <c:param name="categoryId" value="${categoryId}"/>
      </c:url>

    <dsp:droplet name="CatalogItemFilterDroplet">
      <dsp:param name="collection" param="product.childSKUs"/>
      <dsp:oparam name="output">
        <dsp:droplet name="WoodFinishDroplet">
          <dsp:param name="skus" param="filteredCollection"/>
          <dsp:param name="selectedColor" param="selectedColor"/>
          <dsp:param name="product" param="product"/>
          <dsp:oparam name="output">
            <dsp:param name="skuType" value="furniture"/>
            <div id="picker_contents">
              <dsp:form id="addToCart" formid="addToCart"
                        action="${pageContext.request.requestURI}" method="post"
                        name="addToCart">
                <div id="atg_store_picker">
                  <div class="atg_store_selectAttributes">
                    <%@include file="pickerPriceAttribute.jspf"%>
                    <%@include file="pickerCartFormParams.jspf"%>
                    <div class="atg_store_pickerContainer">
                      <%@include file="pickerColorPicker.jspf" %>
                    </div>
                    <div class="atg_store_addQty">
                      <div class="atg_store_quantity">
                        <%@include file="pickerQuantityAttribute.jspf" %>
                        <%@include file="pickerItemId.jspf" %>
                      </div>
                      <div class="atg_store_productAvailability">
                        <%@include file="pickerAvailabilityMessage.jspf" %>
                        <%@include file="pickerAddToCart.jspf" %>
                      </div>
                    </div>

                  </div>
                </div>

                <div class="atg_store_pickerActions">
                  <dsp:input type="hidden" bean="GiftlistFormHandler.woodfinishPicker" value="true"/>
                  <dsp:include page="pickerActions.jsp">
                    <dsp:param name="comparisonsContainsProduct" param="comparisonsContainsProduct"/>
                    <dsp:param name="showEmailAFriend" param="showEmailAFriend"/>
                    <dsp:param name="showGiftlists" param="showGiftlists"/>
                    <dsp:param name="wishlistContainsSku" param="wishlistContainsSku"/>
                    <dsp:param name="giftlists" param="giftlists"/>
                  </dsp:include>
                </div>
              </dsp:form>
              <%@include file="pickerRefreshForm.jspf" %>
            </div>
          </dsp:oparam>
        </dsp:droplet>
      </dsp:oparam>
    </dsp:droplet>
  </dsp:oparam>
</dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/browse/gadgets/pickerWoodFinishContents.jsp#1 $$Change: 713790 $--%>
