<%-- 
  This gadget renders the specified shipping group address and shipping method
  along with order contains shipped to this address.
  
  Required parameters:
    shippingGroup
      The shipping group to be rendered
    httpServer
      The URL prefix that is used to build fully-qualified absolute URLs
     
  Optional parameters:
    priceListLocale
      The locale to use for prices formatting.
    locale
      Locale to append to the URL as URL parameter so that the pages to which user navigates using the URL
      will be rendered in the same language as the email.
    excludeGiftWrap
      Boolean indicating whether to display gift wrap that is assigned to shipping group.
      It is needed for order confirmation email as there gift wrap is displayed in the separate
      block.
--%>
<dsp:page>
  <dsp:getvalueof var="shippingGroup" vartype="atg.commerce.order.ShippingGroup" param="shippingGroup"/>
  <dsp:getvalueof var="shippingGroupClassType" vartype="java.lang.String" param="shippingGroup.shippingGroupClassType"/>
  <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="priceListLocale"/>
  <dsp:getvalueof var="excludeGiftWrap" param="excludeGiftWrap"/>
  
  <%-- Get quantity of items in shipping group. --%>
  <c:set var="itemsSize" value="${fn:length(shippingGroup.commerceItemRelationships)}"/>
  <c:if test="${itemsSize > 0 and shippingGroupClassType == 'hardgoodShippingGroup'}">
    <%-- It's not empty hardgroup shipping group. Render its details. --%>
    <dsp:param name="shippingAddress" param="shippingGroup.shippingAddress"/>                    
    <dsp:getvalueof var="addressValue" param="shippingAddress.country"/>
    <%-- Check whether shipping address is not empty --%>
    <c:if test='${addressValue != ""}'>
      <%-- 
        If this shipping group is gift shipping group then 
        add title "Gift Shipping Destination" and hide "Edit" link
      --%>
      <c:set var="isGiftShippingGroup" value="false"/>
      <c:set var="shippingGroupClass" value="atg_store_confirmHardgoodItem"/>
      <%--
        This servlet bean accepts a shipping group as in input parameter and
        checks for gifts (gifthandlinginstructions) in the shipping group.  if
        it contains a gift, the servlet renders true, otherwise it renders false
        parameter.
        
        Input parameters:
          sg
            The shipping group to check.
        
        Open parameters:
          true
            The parameter is rendered if specified group is gift shipping group 
          false
            The parameter is rendered if specified group is gift shipping group
      --%>
      <dsp:droplet name="/atg/commerce/gifts/IsGiftShippingGroup">
        <dsp:param name="sg" param="shippingGroup"/>
        <dsp:oparam name="true">
          <c:set var="isGiftShippingGroup" value="true"/>
          <c:set var="shippingGroupClass" value="atg_store_confirmGiftListItem"/>
        </dsp:oparam>
      </dsp:droplet>

      <tr>
        <td valign="top" 
            style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:16px;font-weight:bold;">
          <%-- Ship To Label --%>
          <fmt:message key="emailtemplates_orderConfirmation.shipTo"/>
        </td>
        
        <td valign="top" style="color:#000;font-family:Tahoma,Arial,sans-serif;font-size:12px;">
          <%-- Gift Shipping Group --%>
          <c:if test="${isGiftShippingGroup}">
            <span style="font-weight:bold;">
              <fmt:message key="checkout_shippingGifts.giftShippingDestinations"/>
            </span>
          </c:if>
          
          <%-- Display shipping address. --%>
          
          <dsp:getvalueof var="shippingAddress" param="shippingAddress"/>
          <dsp:getvalueof var="shippingMethod" param="shippingGroup.shippingMethod"/>
          
          <%-- Display shipping address --%>
          <div style="padding-bottom:8px;font-size:20px;">
            <span><dsp:valueof value="${shippingAddress.firstName}"/></span>
            <span><dsp:valueof value="${shippingAddress.middleName}"/></span>
            <span><dsp:valueof value="${shippingAddress.lastName}"/></span>
          </div>
          <dsp:valueof value="${shippingAddress.address1}"/>
          <br />
          <c:if test="${not empty shippingAddress.address2}">
            <dsp:valueof value="${shippingAddress.address2}"/>
            <br />
          </c:if>
          <dsp:valueof value="${shippingAddress.city}"/><fmt:message key="common.comma"/>
          <c:if test="${not empty shippingAddress.state}">
            <dsp:valueof value="${shippingAddress.state}"/><fmt:message key="common.comma"/>
          </c:if>
          <dsp:valueof value="${shippingAddress.postalCode}"/>
          <br />
          
          <%-- This droplet is used here just to get display name for the given country code. --%>  
          <dsp:droplet name="/atg/store/droplet/CountryListDroplet">
            <dsp:param name="userLocale" bean="/atg/dynamo/servlet/RequestLocale.locale" />
            <dsp:param name="countryCode" value="${shippingAddress.country}"/>
            <dsp:oparam name="false">
              <dsp:valueof param="countryDetail.displayName" />
            </dsp:oparam>
          </dsp:droplet>
            
          <br /> 
          <dsp:valueof value="${shippingAddress.phoneNumber}"/>
        </td>
        
        <%-- Shipping method --%>
        <td colspan="3" valign="top" 
            style="color:#666;font-family:Tahoma,Arial,sans-serif;font-size:14px;">
          <%-- Via Label --%>
          <span style="font-size:16px;color:#666;font-weight:bold;">
            <fmt:message key="emailtemplates_orderConfirmation.via"/>
          </span>
          <c:if test="${not empty shippingMethod}">
            <span style="font-size:20px;color:#000;">
              <%--
                To get localized version of shipping method name build 
                resource key from original shipping method name by removing spaces
                and adding 'common.delivery' prefix.
               --%>
              <fmt:message key="common.delivery${fn:replace(shippingMethod, ' ', '')}"/>
            </span>
          </c:if>
        </td>
      </tr>      

      <%-- Display commerce items that go to this shipping destination --%>
      <dsp:getvalueof var="commerceItemRels" vartype="java.lang.Object" 
                      param="shippingGroup.commerceItemRelationships"/> 
      <dsp:getvalueof id="size" value="${fn:length(commerceItemRels)}"/>
      <c:if test="${not empty commerceItemRels}">
      
        <%-- Table header for items list --%>
        <fmt:message var="tableSummary" key="global_orderItemsHeader.tableSummary"/>
        <tr>
          <td colspan="5">
            <hr size="1">
          </td>
        </tr>
        <tr>
          <td colspan="5"> 
            <table summary="${tableSummary}" cellspacing="0"  cellpadding="2">
              <tr style="border-collapse: collapse;">
                <th scope="col" style="width:60px;color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold; border-bottom: 1px solid #666666;">
                  <fmt:message key="emailtemplates_orderConfirmation.itemSite"/>
                </th>  
                <th scope="col" style="color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold;width:237px; border-bottom: 1px solid #666666;">
                  <fmt:message key="emailtemplates_orderConfirmation.itemName"/>
                </th>
                <th scope="col" style="color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold; width: 65px; border-bottom: 1px solid #666666;">
                  <fmt:message key="emailtemplates_orderConfirmation.itemQuantity"/>
                </th>
                <th scope="col" align="left" style="text-align:left;color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold;width:150px; border-bottom: 1px solid #666666;">
                  <fmt:message key="emailtemplates_orderConfirmation.itemPrice"/>
                </th>
                <th scope="col" align="right" style="color:#0a3d56;font-family:Tahoma,Arial,sans-serif;font-size:14px;font-weight:bold; width: 170px; border-bottom: 1px solid #666666;">
                  <fmt:message key="emailtemplates_orderConfirmation.itemTotal"/>
                </th>
              </tr>       
        
              <%-- Loop through shipping group's commerce item relationships --%>
              <c:forEach var="currentItemRel" items="${commerceItemRels}" varStatus="status">
                <dsp:param name="currentItemRel" value="${currentItemRel}"/>              
                <dsp:getvalueof var="commItem" param="currentItemRel.commerceItem"/>
                <%--
                  Do not display gift wrap in the shipping group's commerce items list; 
                  we will display it later in 'order extras' section.
                 --%>
          
                <c:if test="${commItem.commerceItemClassType != 'giftWrapCommerceItem' or not excludeGiftWrap}">
            
                  <%-- Render commerce item details row --%>
                  <dsp:include page="/emailtemplates/gadgets/emailOrderItemRenderer.jsp">
                    <dsp:param name="order" param="order"/>
                    <dsp:param name="commerceItemRel" param="currentItemRel"/>
                    <dsp:param name="priceListLocale" value="${priceListLocale}"/> 
                    <dsp:param name="priceBeans" param="priceBeans"/>
                    <dsp:param name="locale" param="locale"/>
                    <dsp:param name="httpServer" param="httpServer"/>
                  </dsp:include>
           
                </c:if>
            
              </c:forEach>
            </table> 
          </td>
        </tr>
        <%-- Table footer for items list. --%>
        <tr>
          <td colspan="5"></td>
        </tr>       
      </c:if>


    </c:if>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/emailtemplates/gadgets/shippingGroupRenderer.jsp#1 $$Change: 713790 $--%>