<%--
  This gadget renders payment info from paypal payment group. Payment group passed should be a PayPal.

  Required parameters:
    paymentGroup
      Payment group to be displayed.

  Optional parameters:
    isCurrent
      Flags, if payment group specified belongs to current shopping cart, or not.
    isExpressCheckout
      Flags, if this gadget is a part of express checkout Confirmation page.
--%>

<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CommitOrderFormHandler"/>

  <dsp:getvalueof var="contextroot" bean="/OriginatingRequest.contextPath"/>
  <dsp:getvalueof var="isCurrent" param="isCurrent"/>
  <dsp:getvalueof var="isExpressCheckout" param="isExpressCheckout"/>

  <dl class="atg_store_groupBillingAddress">
    <dt>
      <fmt:message key="checkout_confirmPaymentOptions.billTo"/><fmt:message key="common.labelSeparator"/>
    </dt>
    <dd>
      <%-- First, display billing address for the credit card specified. --%>
      <dsp:include page="/global/util/displayAddress.jsp">
        <dsp:param name="address" param="paymentGroup.billingAddress"/>
      </dsp:include>
      <%-- If it's a Confirmation page, display link to the 'Change Billing Details' page. --%>
      <c:if test="${isCurrent}">
        <dsp:a page="/checkout/billing.jsp" title="">
          <span><fmt:message key="common.button.editText"/></span>
        </dsp:a>
      </c:if>
    </dd>
  </dl>

  <%-- Now display Pay Pal specific parameters. --%>
  <dl class="atg_store_groupPayment">
    <dt>
      <fmt:message key="checkout_confirmPaymentOptions.payment"/><fmt:message key="common.labelSeparator"/>
    </dt>
    <%-- PayPal. --%>
    <dd class="atg_store_groupPaymentCardType">
	<b>PayPal Payment</b>
	<b>PayerId:</b><dsp:valueof param="paymentGroup.payerId"/>
	<b>Payer Status:</b><dsp:valueof param="paymentGroup.payerStatus"/>
    </dd>

  </dl>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/checkout/gadgets/paymentGroupRenderer.jsp#1 $$Change: 713790 $--%>