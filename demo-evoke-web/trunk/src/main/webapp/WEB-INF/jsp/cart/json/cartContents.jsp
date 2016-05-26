<%@ page contentType="application/json; charset=UTF-8"%>

<%--
  This page renders the contents of the cart as JSON data. 
  This is the top-level container page that just sets the appropriate mime type and includes
  the real data-generating page.
  
  Required Parameters:
    None.
--%>

<dsp:page>

  <dsp:getvalueof bean="/atg/commerce/ShoppingCart.current.CommerceItemCount" var="itemCount" />
  <dsp:importbean bean="/atg/store/profile/RequestBean"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>

  <c:choose>
    <c:when test="${itemCount==0}">
      <%-- Cart is empty --%>
      <json:object>
        <json:object name="itemsContainer">
          <json:property name="itemCount" value="${0}" />
          <json:property name="itemsQuantity" value="${0}" />
        </json:object>
      </json:object>
    </c:when>
    <c:otherwise>
      <json:object>
        
        <%-- 
        Reprice cart only if item has been added via JavaScript,
        check isAjaxRequest flag for it. We do this because JSON data is
        created every time regardless of JS availability. That's a problem
        because we invoke Targeting droplet on the rich cart and shopping cart
        and can lose GWP messages (Slot destruct messages by default) when JS is
        turned off and shopping cart is opened.
        --%>
        <dsp:getvalueof var="isAjaxRequest" bean="RequestBean.values.isAjaxRequest"/>
        <dsp:getvalueof var="priceInfo" bean="ShoppingCart.current.priceInfo"/>

        <c:if test="${isAjaxRequest || empty priceInfo}">
          <dsp:include page="/global/gadgets/orderReprice.jsp"/>
        </c:if>

        <%-- Cart is not empty - render contents of cart --%>
        <dsp:include page="cartItems.jsp" />

        <%-- Add messages--%>
        <dsp:include page="cartMessages.jsp" />
      </json:object>
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/cart/json/cartContents.jsp#1 $$Change: 713790 $--%>
