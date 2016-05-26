<%--
  This page renders content of not empty "Shopping Cart".

  Page includes:
    /mobile/global/gadgets/errorMessage.jsp - Displays all errors collected from FormHandler
    /mobile/cart/gadgets/cartItems.jsp - Renderer of cart items
    /mobile/global/gadgets/pricingSummary.jsp - Renderer of order summary (payment info, shipping address, etc)

  Required parameters:
    None

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>

  <dsp:getvalueof var="mobileStorePrefix" bean="/atg/store/StoreConfiguration.mobileStorePrefix"/>

  <div class="cartContainer">
    <%-- ========== Form ========== --%>
    <dsp:form action="${pageContext.request.requestURI}" method="post" name="cartContent" formid="cartContent">
      <%-- ========== Redirection URLs ========== --%>
      <dsp:input type="hidden" bean="CartFormHandler.moveToPurchaseInfoSuccessURL" value="${siteContextPath}/checkout/shipping.jsp"/>
      <dsp:input type="hidden" bean="CartFormHandler.moveToPurchaseInfoErrorURL" value="${pageContext.request.requestURI}"/>
      <dsp:input type="hidden" bean="CartFormHandler.updateSuccessURL" value="${pageContext.request.requestURI}"/>
      <dsp:input type="hidden" bean="CartFormHandler.updateErrorURL" value="${pageContext.request.requestURI}"/>
      <dsp:input type="hidden" bean="CartFormHandler.giftMessageUrl" value="${siteContextPath}/checkout/giftMessage.jsp"/>
      <dsp:input type="hidden" bean="CartFormHandler.shippingInfoURL" value="${siteContextPath}/checkout/shipping.jsp"/>
      <dsp:input type="hidden" bean="CartFormHandler.loginDuringCheckoutURL" value="${siteContextPath}/checkout/login.jsp"/>

      <dsp:input type="hidden" id="removeItemFromOrder" bean="CartFormHandler.removeItemFromOrder" value=""/>
      <dsp:input type="hidden" bean="CartFormHandler.removeItemFromOrderSuccessURL" value="${pageContext.request.requestURI}"/>
      <dsp:input type="hidden" bean="CartFormHandler.removeItemFromOrderErrorURL" value="${pageContext.request.requestURI}"/>

      <div class="cartData">
        <%-- Prepare formHandlers map --%>
        <dsp:getvalueof var="handlerBean1" bean="CartFormHandler"/>
        <dsp:getvalueof var="handlerBean2" bean="CouponFormHandler"/>
        
        <jsp:useBean id="formHandlers" class="java.util.HashMap"/>
        <c:set target="${formHandlers}" property="CartFormHandler" value="${handlerBean1}"/>
        <c:set target="${formHandlers}" property="CouponFormHandler" value="${handlerBean2}"/>
        
        <%-- Display "CartFormHandler" error messages, which were specified in "formException.message" --%>        
        <dsp:include page="${mobileStorePrefix}/global/gadgets/errorMessage.jsp">
          <dsp:param name="formHandlers" value="${formHandlers}"/>          
        </dsp:include>

        <%-- Shopping cart content --%>
        <div>
          <dsp:include page="gadgets/cartItems.jsp"/>
        </div>

        <%-- Order summary --%>
        <dsp:include page="${mobileStorePrefix}/global/gadgets/pricingSummary.jsp">
          <dsp:param name="order" bean="ShoppingCart.current"/>
          <dsp:param name="isCheckout" value="true"/>
          <dsp:param name="isOrderReview" value="false"/>
        </dsp:include>
      </div>

      <%-- "Submit" button --%>
      <div class="cartCheckout">
        <fmt:message var="checkoutText" key="mobile.common.button.checkoutText"/>
        <dsp:input class="mainActionButton" type="submit" bean="CartFormHandler.checkout" value="${checkoutText}"/>
      </div>
    </dsp:form>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/cart/cartContent.jsp#4 $$Change: 734360 $ --%>
