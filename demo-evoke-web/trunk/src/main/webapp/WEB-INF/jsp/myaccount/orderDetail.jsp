<%-- 
  Outlay page which lookups the order on the bases of orderId
     
  Required parameters:
    orderId
      The order to be rendered
      
  Optional parameters:
    None
--%>

<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>

  <crs:pageContainer divId="atg_store_orderDetail" 
                     index="false" follow="false"
                     bodyClass="atg_store_orderDetails atg_store_myAccountPage atg_store_threeCol"
                     selpage="MY ORDERS" >
    <jsp:body>

      <%-- Page title --%>
      <div id="atg_store_contentHeader">
        <h2 class="title">
          <fmt:message key="myaccount_orderDetail.title"/><fmt:message key="common.labelSeparator"/><dsp:valueof param="orderId"/>
        </h2>
      </div>
      
      <%-- Left-hand menu --%>
      <dsp:include page="gadgets/myAccountMenu.jsp">
        <dsp:param name="selpage" value="MY ORDERS" />
      </dsp:include>

      <%--
        Retrieve Order object
        
        Input parameters:
          orderId
            orderID
        
        Output parameters:
          result
            Order object
       --%>
      <dsp:droplet name="OrderLookup">
        <dsp:param name="orderId" param="orderId"/>

        <dsp:oparam name="error">
          <div class="atg_store_main atg_store_myAccount atg_store_myOrderDetail">
            <dsp:valueof param="errorMsg"/>
          </div>
        </dsp:oparam>
        <dsp:oparam name="output">
        
          <%-- 
            Retrieve the price lists's locale used for order. It will be used to
            format prices correctly. 
            
            We can't use Profile's price list here as already submitted order can be priced 
            with price list different from current profile's price list.
          --%>
               
          <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="result.commerceItems"/>     
          <c:if test="${not empty commerceItems}">
            <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="result.commerceItems[0].priceInfo.priceList.locale"/>
          </c:if>
          
          <%-- Order summary --%>
          <dsp:include page="/checkout/gadgets/checkoutOrderSummary.jsp">
            <dsp:param name="order" param="result"/>
            <dsp:param name="submittedOrder" value="true"/>
            <dsp:param name="priceListLocale" value="${priceListLocale}"/>
          </dsp:include>
    
          <div class="atg_store_main atg_store_myAccount atg_store_myOrderDetail">
            <dsp:include page="/global/gadgets/orderSummary.jsp">
              <dsp:param name="order" param="result"/>
              <dsp:param name="hideSiteIndicator" value="false"/>
              <dsp:param name="displayProductAsLink" value="true"/>
              <dsp:param name="priceListLocale" value="${priceListLocale}"/>
            </dsp:include>
          </div>
          
        </dsp:oparam>
      </dsp:droplet>
      
    </jsp:body>
  </crs:pageContainer>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/myaccount/orderDetail.jsp#1 $$Change: 713790 $--%>