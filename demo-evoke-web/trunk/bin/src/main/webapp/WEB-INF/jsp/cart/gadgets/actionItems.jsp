<%--  
  This gadget renders the "Checkout", "Express Checkout" and "Continue Shopping"
  buttons on the Shopping Cart page.
  This gadget should be rendered inside of a <dsp:form> tag.
  Checkout success/error URLs should be set on some other page rendered within the same <dsp:form> tag.

  Required parameters:
    None.

  Optional parameters:
    None.
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/ExpressCheckoutOk"/>
  <dsp:importbean bean="/atg/store/order/purchase/CartFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <div class="atg_store_cartActions">
    <span class="atg_store_basicButton">
      <fmt:message var="checkoutText" key="common.button.checkoutText"/>
      <dsp:input id="atg_store_checkout" type="submit" bean="CartFormHandler.checkout" value="${checkoutText}"/>
    </span>

    <%-- 
      Display the express checkout button if: 
        user is logged in,
        user profile is not transient,
        user has saved valid address and billing details.

      Input Parameters:
        profile
          The current user's profile component.

      Open Parameters:
        true
          If displaying the express checkout button is valid.
        false.
          If displaying the express checkout button is invalid.
    --%>
    <dsp:droplet name="ExpressCheckoutOk">
      <dsp:param name="profile" bean="Profile"/>
      <dsp:oparam name="true">
        <span class="atg_store_basicButton tertiary">
          <fmt:message var="expressCheckoutText" key="common.button.expressCheckoutText"/>
          <dsp:input id="atg_store_express_checkout" type="submit" bean="CartFormHandler.expressCheckout" value="${expressCheckoutText}"/>
        </span>
      </dsp:oparam>
    </dsp:droplet>
	
    <%-- 
      This 'continueShopping' tag generates a URL for the 'Continue Shopping' link and stores this 
      in the 'continueShoppingURL' page scope variable. The resulting 'Continue Shopping' link will 
      be to the users last browsed category, or to '/index.jsp' if this doesn't exist or is not valid 
      for the users current context.
    --%>
    <dsp:input bean="CartFormHandler.continueShoppingErrorURL" type="hidden" beanvalue="/OriginatingRequest.requestURI"/>
    <crs:continueShopping>
      <dsp:input type="hidden" bean="CartFormHandler.continueShoppingSuccessURL" value="${continueShoppingURL}"/>
    </crs:continueShopping>

    <fmt:message var="continueShoppingText" key="common.button.continueShoppingText"/>
    <dsp:input id="atg_store_continue" iclass="atg_store_textButton" type="submit"
               bean="CartFormHandler.continueShopping" value="${continueShoppingText}"/> 
    
    <!-- Express checkout with Payapl account {START} --> 
     <br><div style="margin-top: 10px"><b>OR</b></div>
	<div style="padding-left:10px; margin-top: 20px">
			<dsp:input id="atg_store_paypal_checkout" type="image" bean="CartFormHandler.checkoutWithPayPal"
				value="PayPal Express Checkout" src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif" />
	</div>
	<!-- Express checkout with Payapl account {END} -->
  </div>  
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/cart/gadgets/actionItems.jsp#1 $$Change: 713790 $--%>
