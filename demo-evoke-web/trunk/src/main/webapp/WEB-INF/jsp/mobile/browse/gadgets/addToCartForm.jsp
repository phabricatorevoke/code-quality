<%--
  Hidden form for adding items to the cart.

  Required Parameters:
    productId
      ID of the product to add to the cart

  Optional Parameters:
    selectedSkuId
      SKU being added to shopping cart
    selectedQty
      Number of items being added
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <%-- ========== Form ========== --%>
  <dsp:form id="addToCartForm" formid="addToCartForm" action="${pageContext.request.requestURI}" method="post">
    <dsp:input bean="CartFormHandler.addItemCount" type="hidden" value="1"/>

    <dsp:input id="addToCart_skuId" bean="CartFormHandler.items[0].catalogRefId" type="hidden" paramvalue="selectedSkuId"/>
    <dsp:input id="addToCart_qty" bean="CartFormHandler.items[0].quantity" type="hidden" paramvalue="selectedQty"/>

    <dsp:input bean="CartFormHandler.items[0].productId" type="hidden" paramvalue="productId"/>
    <%-- Set "originOfOrder" to "mobile" on the shopping cart, qualifying the user for mobile promotions on "UIOnly" --%>
    <dsp:input bean="CartFormHandler.originOfOrder" type="hidden" value="mobile"/>

    <dsp:input bean="CartFormHandler.addItemToOrderSuccessURL" type="hidden"
               value="${siteContextPath}/browse/json/addToCartJSON.jsp"/>
    <dsp:input bean="CartFormHandler.addItemToOrderErrorURL" type="hidden"
               value="${siteContextPath}/browse/json/addToCartJSON.jsp?errorAddToCart=true"/>
    <dsp:input bean="CartFormHandler.addItemToOrder" type="hidden" value="Add to cart"/>
  </dsp:form>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/browse/gadgets/addToCartForm.jsp#3 $$Change: 713898 $--%>
