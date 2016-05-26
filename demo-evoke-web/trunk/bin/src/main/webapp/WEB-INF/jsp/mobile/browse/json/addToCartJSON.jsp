<%--
  Returns JSON for adding item to the "Shopping Cart".

  Optional Parameters:
    errorAddToCart
      If present, signifies that an error is occurred
--%>
<%@page contentType="application/json"%>
<%@page trimDirectiveWhitespaces="true"%>

<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>

  <json:object>
    <c:choose>
      <c:when test="${param.errorAddToCart}">
        <dsp:getvalueof var="formExceptions" bean="CartFormHandler.formExceptions"/>
        <json:property name="addToCartError" value="${formExceptions}"/>
      </c:when>
      <c:otherwise>
        <%@include file="/mobile/cart/gadgets/cartItemCount.jspf"%>
        <json:property name="cartItemCount" value="${itemsQuantity}"/>
      </c:otherwise>
    </c:choose>
  </json:object>
</dsp:page>
