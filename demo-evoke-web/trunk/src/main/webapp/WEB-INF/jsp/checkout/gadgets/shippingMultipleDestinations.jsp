<%--
  This gadget displays list of items and allows to select shipping address and method per item.
  Form Condition:
    This gadget must be contained inside of a form.
    ShippingGroupFormHandler must be invoked on a form submit.

  Required parameters:
    None.

  Optional parameters:
    None.
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupContainerService"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/CartSharingSitesDroplet"/>
  <dsp:importbean bean="/atg/commerce/pricing/AvailableShippingMethods"/>
  <dsp:importbean bean="/atg/store/droplet/AvailableShippingGroups"/> 
  <dsp:importbean bean="/atg/store/profile/ProfileCheckoutPreferences"/>
  <dsp:importbean bean="/atg/commerce/promotion/GiftWithPurchaseSelectionsDroplet"/>
  <dsp:importbean bean="/atg/commerce/promotion/PromotionLookup"/>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/> 

  <%-- Display multiple shipping header --%>
  <div class="atg_store_multiShipHeader">
    <fmt:message var="shippingDestinationsTableSummary" key="checkout_shippingMultipleDestinations.tableSummary"/>

    <h3>
      <fmt:message key="checkout_shippingOptions.button.shipToMultipleText"/>
    </h3>
    
    <%-- Create new and Edit address links --%>
    <ul class="atg_store_multiShipAdderessLinks">
      <li>
        <fmt:message var="addShippingAddressTitle" key="checkout_shippingMultipleDestinations.createNewAddressTitle" />
        <fmt:message var="addShippingAddress" key="checkout_shippingMultipleDestinations.createNewAddress"/>
        <dsp:a href="${pageContext.request.contextPath}/checkout/shippingAddressAdd.jsp" title="${addShippingAddressTitle}">
          ${addShippingAddress}
        </dsp:a>
      </li>
      <li>
        <fmt:message var="editAddressesTitle" key="checkout_shippingMultipleDestinations.editAddressesTitle" />
        <fmt:message var="editAddresses" key="checkout_shippingMultipleDestinations.editAddresses"/>
        <dsp:a href="${pageContext.request.contextPath}/checkout/editShippingAddresses.jsp" title="${editAddressesTitle}">
          ${editAddresses}
        </dsp:a>
      </li>
    </ul>
  </div>

  <%--
    Main part of the page.
    Display all added to cart items. Display 'select' input for each of them to choose shipping address and method.
  --%>
  <table summary="${shippingDestinationsTableSummary}" cellspacing="0" cellpadding="0"
         class="atg_store_multiShipProducts" id="atg_store_itemTable">
    <tbody>
      <%-- Calculate number of available items to display. This will be used when rendering item's line. --%>
      <dsp:getvalueof var="allHardgoodCommerceItemShippingInfos" vartype="java.lang.Object"
                      bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos"/>
      <c:set var="itemsSize" value="${fn:length(allHardgoodCommerceItemShippingInfos)}"/>
      <%-- Add all items from gift shipping groups, we should display them too. --%>
      <dsp:getvalueof var="giftShippingGroups" vartype="java.lang.Object" bean="ShippingGroupFormHandler.giftShippingGroups"/>
      <c:forEach var="giftShippingGroup" items="${giftShippingGroups}" varStatus="giftShippingGroupsStatus">
        <dsp:param name="giftShippingGroup" value="${giftShippingGroup}"/>
        <dsp:getvalueof var="commerceItemRelationships" vartype="java.lang.Object" param="giftShippingGroup.commerceItemRelationships"/>
        <c:set var="itemsSize" value="${itemsSize + fn:length(commerceItemRelationships)}"/>
      </c:forEach>
      
      <%-- We're displaying items from the beginning. --%>
      <c:set var="itemsCount" value="0"/>
      
      <%-- 
        Get values for the shippingGroupMap and defaultShippingAddressNickname outside the loop as
        they wont change per iteration. If the profile dosnt have a default address use the first 
        non-gift address.
      --%>
      <dsp:getvalueof var="shippingGroupMap" vartype="java.lang.Object" bean="ShippingGroupContainerService.shippingGroupMapForDisplay"/>
      <dsp:getvalueof var="defaultShippingAddressNickname" bean="ProfileCheckoutPreferences.defaultShippingAddressNickname"/>
      <c:if test="${empty defaultShippingAddressNickname}">
        <dsp:getvalueof var="firstNonGiftShippingGroupName" bean="ShippingGroupContainerService.firstNonGiftShippingGroupName"/>
      </c:if>
      
      <%--
        Generate price beans for each product row on page. We will use them to display all applied
        discounts per cart item.
        
        Input Parameters:
          order - The order to generate the price beans for
          
        Open Parameters:
          output - Always rendered 
          
        Output Parameters:
          priceBeansMap - A map whose key is the commerce item id and whose value is a price bean
      --%> 
      <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
        <dsp:param name="order" bean="/atg/commerce/ShoppingCart.current"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="priceBeansMap" vartype="java.util.Map" param="priceBeansMap"/>
          <%-- For each hardgood CommerceItemInfo in the map (i.e. for all cart items) do the following: --%>
          <dsp:getvalueof var="allHardgoodCommerceItemShippingInfos" vartype="java.lang.Object"
                          bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos"/>
          <c:forEach var="cisiItem" items="${allHardgoodCommerceItemShippingInfos}" varStatus="status">
            <dsp:param name="cisiItem" value="${cisiItem}"/>
            <c:set var="index" value="${status.index}"/>

            <c:set var="itemsCount" value="${itemsCount + 1}"/>
            <tr class='<crs:listClass count="${itemsCount}" size="${itemsSize}" selected="false"/>'>
              <%-- Display commerce item details, only if it's not a gift wrap. --%>
              <dsp:getvalueof var="commerceItemClassType" param="cisiItem.commerceItem.commerceItemClassType"/>
              <c:if test='${commerceItemClassType != "giftWrapCommerceItem"}'>
              
                <%--
                  CartSharingSitesDroplet returns a collection of sites that share the shopping
	              cart shareable (atg.ShoppingCart) with the current site.
	              You may optionally exclude the current site from the result.

                  Input Parameters:
                    excludeInputSite - Should the returned sites include the current
   
                  Open Parameters:
                    output - This parameter is rendered once, if a collection of sites
                             is found.
   
                  Output Parameters:
                    sites - The list of sharing sites.
                --%>
                <dsp:droplet name="CartSharingSitesDroplet">
                  <dsp:param name="excludeInputSite" value="true"/>
                  <dsp:oparam name="output">
                    <td class="site">
                      <%-- Site indicator itself. --%>
                      <dsp:include page="/global/gadgets/siteIndicator.jsp">
                        <dsp:param name="mode" value="icon"/>
                        <dsp:param name="siteId" param="cisiItem.commerceItem.auxiliaryData.siteId"/>
                        <dsp:param name="product" param="cisiItem.commerceItem.auxiliaryData.productRef"/>
                      </dsp:include>
                    </td>
                  </dsp:oparam>
                </dsp:droplet>
                
                <%-- Display product's image, --%>
                <td class="image">
                  <dsp:include page="/cart/gadgets/cartItemImage.jsp">
                    <dsp:param name="commerceItem" param="cisiItem.commerceItem"/>
                    <dsp:param name="displayAsLink" value="false"/>
                  </dsp:include>
                </td>
                
                <dsp:getvalueof var="productDisplayName" param="cisiItem.commerceItem.auxiliaryData.catalogRef.displayName"/>
                <c:if test="${empty productDisplayName}">
                  <dsp:getvalueof var="productDisplayName" param="cisiItem.commerceItem.auxiliaryData.productRef.displayName"/>
                  <c:if test="${empty productDisplayName}">
                    <fmt:message var="productDisplayName" key="common.noDisplayName" />
                  </c:if>
                </c:if>
                
                <%-- Display product's parameters (like color/size/etc.), and name. --%>
                <td class="item" scope="row" abbr="${productDisplayName}">
                  <span class="itemName">
                    <dsp:valueof value="${productDisplayName}"/>
                  </span>
                  <dsp:include page="/global/util/displaySkuProperties.jsp">
                    <dsp:param name="product" param="cisiItem.commerceItem.auxiliaryData.productRef"/>
                    <dsp:param name="sku" param="cisiItem.commerceItem.auxiliaryData.catalogRef"/>
                    <dsp:param name="displayAvailabilityMessage" value="true"/>
                  </dsp:include>
                </td>
                <td class="atg_store_multishipOptions">
                
                  <c:set var="currentPriceBean" value="${priceBeansMap[cisiItem.commerceItem.id]}"/>
                   <%-- 
                    Check if this item have been added as a gift. If yes, it will be associated selections
                    
                    Input Parameters:
                      order
                        current order from the cart
                      item
                        commerce item to check
                        
                    Output Parameters:
                      selections
                        collection of Selection beans with gift information   
                        
                    Open Parameters:
                      output
                        in case commerce item has been added as a gift or re-priced
                        
                      empty
                        regular commerce item      
                    --%> 
                  <dsp:droplet name="GiftWithPurchaseSelectionsDroplet">
                    <dsp:param name="order" bean="ShoppingCart.current"/>
                    <dsp:param name="item" param="cisiItem.commerceItem" />
  
                    <dsp:oparam name="output">
                      <%-- This commerce item have been added by GWP, display edit link --%>
                      <dsp:getvalueof var="selections" param="selections" />
                      <c:forEach var="selection" items="${selections}">
                        <dsp:param name="selection" value="${selection}" />
                        
                        <div class="atg_store_itemizedPrice">
                          
                          <dsp:include page="/cart/gadgets/displayItemPricePromotions.jsp">
                            <dsp:param name="currentItem" value="${cisiItem.commerceItem}"/>
                            <dsp:param name="unitPriceBean" value="${currentPriceBean}"/>
                            <dsp:param name="isGift" value="true"/>
                          </dsp:include>
                          
                          <p class="price">
                            <dsp:valueof param="selection.selectedQuantity"/>
                            <fmt:message key="common.atRateOf"/>
                            <fmt:message key="common.FREE"/>
                          </p>
                        </div>
                        
                      </c:forEach>
                    </dsp:oparam>
                    
                    <dsp:oparam name="empty">
                      <%--
                        Display product's price with all applied discounts.
                        All discounts should be taken from price beans calculated by the outer droplet. 
                        These price beans are stored in form of a Map, key is commerce item's ID and value
                        is unit price bean itself.
                        Get price bean only once! When you take it, it's being removed from the map.
                      --%>
                      <div class="atg_store_itemizedPrice">
                        <dsp:include page="/cart/gadgets/displayItemPricePromotions.jsp">
                          <dsp:param name="currentItem" value="${cisiItem.commerceItem}"/>
                          <dsp:param name="unitPriceBean" value="${currentPriceBean}"/>
                        </dsp:include>
                        <dsp:include page="/cart/gadgets/displayItemPrice.jsp">
                          <dsp:param name="quantity" value="${currentPriceBean.quantity}"/>
                          <dsp:param name="displayQuantity" value="true"/>
                          <dsp:param name="price" value="${currentPriceBean.unitPrice}"/>
                          <%-- Display 'was $x.xx' snippet for discounted prices only. --%>
                          <dsp:param name="oldPrice" value="${currentPriceBean.unitPrice != cisiItem.commerceItem.priceInfo.listPrice ?
                                                            cisiItem.commerceItem.priceInfo.listPrice : ''}"/>                      
                        </dsp:include>
                      </div>
                    </dsp:oparam>  
                  </dsp:droplet>      
                  
                  <%-- Display dropdown boxes for shipping addresses and methods. --%>
                  <ul>
                    <li>
                      <%-- Display shipping address dropdown. --%>
                      <label for="atg_store_multiShippingAddressesSelect${index}">
                        <fmt:message key="checkout_confirmPaymentOptions.shipTo"/><fmt:message key="common.labelSeparator"/>
                      </label>
                      <dsp:select bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingGroupName"
                                  required="true" id="atg_store_multiShippingAddressesSelect${index}">

                        <%-- There are no shipping addresses? Display empty list then. --%>
                        <c:if test="${empty shippingGroupMap}">
                          <dsp:option value="">
                            <fmt:message key="checkout_shippingMultipleDestinations.noneAvailable"/>
                          </dsp:option>
                        </c:if>
                                        
                        <%-- 
                          Sorts shipping addresses so that the default address is first and returns
                          only permitted shipping addresses. (E.g Do we ship to this country?)
                           
                          Input parameters:
                            defaultKey
                              The parameter that defines the map key of the default item that should be
                              placed in the beginning of the array.   
                            sortByKeys
                              Boolean that specifies whether to sort map entries by keys or not.
                            map
                              The parameter that defines the map of items to convert to the sorted array.          
                           
                          Open parameters:
                            output
                              Rendered for permitted shipping address list, permittedAddresses
                              parameter contains the permitted shipping addresses.
                            empty
                              Rendered if there are no shipping addresses or there are no
                              permitted shipping addresses  
                  
                          Output parameters:
                            permittedAddresses 
                              contains the permitted shipping addresses    
                        --%> 
                        <dsp:droplet name="AvailableShippingGroups">
                          <dsp:param name="map" value="${shippingGroupMap}"/>
                          <dsp:param name="defaultKey" value="${defaultShippingAddressNickname}"/>
                          <dsp:param name="sortByKeys" value="true"/>
                          <dsp:oparam name="output">
                            <dsp:getvalueof var="permittedAddresses" param="permittedAddresses"/>
                            
                            <%-- Used to record the number of nongift shipping addresses --%>
                            <c:set var="nonGiftShippingAddressCount" value="0"/>
                            
                            <%-- Used to record whether we have a selected address for this group --%>
                            <c:set var="gotSelectedAddress" value="${false}"/>

                            <%-- 
                              Add the nick name of every shipping group in the container to the
                              dropdown list and automatically select the shipping group that the info
                              is currently pointing at.
                              --%>
                            <c:forEach var="shippingGroupEntry" items="${permittedAddresses}" varStatus="shippingGroupLoop">
                            
                              <%-- Get the name and shipping group from the map entry --%>
                              <dsp:getvalueof var="shippingGroup" value="${shippingGroupEntry.value}"/>
                              <dsp:getvalueof var="shippingGroupName" value="${shippingGroupEntry.key}"/>
                              
                              <dsp:getvalueof var="shippingGroupClassType" vartype="java.lang.String" value="${shippingGroup.shippingGroupClassType}"/>
                              <dsp:getvalueof var="cisiSGName" vartype="java.lang.String" param="cisiItem.shippingGroupName"/>
                              
                              <%-- Display hardgood shipping groups only. --%>
                              <c:if test="${shippingGroupClassType == 'hardgoodShippingGroup'}">
                                <dsp:getvalueof var="address" vartype="java.lang.String" value="${shippingGroup.shippingAddress.address1}"/>
                                
                                <%--
                                  If we haven't got a previously selected address or we haven't came
                                  across a non gift shipping address determine if this is a gift
                                  shipping address
                                --%>
                                <c:if test="${nonGiftShippingAddressCount == 0 }">
                                  <dsp:getvalueof var="description" value="${shippingGroup.description }"/>
                                  <dsp:getvalueof var="giftPrefix" bean="/atg/commerce/gifts/GiftlistManager.giftShippingGroupDescriptionPrefix"/>
                                  <c:if test="${!(fn:startsWith(description, giftPrefix))}">
                                    <c:set var="nonGiftShippingAddressCount" value="${nonGiftShippingAddressCount + 1}"/>
                                  </c:if>
                                </c:if>

                                <%-- 
                                  If this is the shipping group associated with this commerce item
                                  set make it selected, if there is no shipping group associated and
                                  this is the default shipping group make it selected
                                --%>                               
                                <c:set var="selected" value="${shippingGroupName == cisiSGName 
                                                               || (empty cisiSGName && shippingGroupName == defaultShippingAddressNickname)
                                                               || (empty cisiSGName && empty defaultShippingAddressNickname && shippingGroupName == firstNonGiftShippingGroupName)}"/>
                                  
                                <c:if test="${selected}">
                                  <c:set var="gotSelectedAddress" value="${true}"/>
                                </c:if>
                                 
                                <dsp:option value="${shippingGroupName}" selected="${selected}">
                                  <dsp:valueof value="${shippingGroupName}"/> - <dsp:valueof value="${address}"/>
                                </dsp:option>      
                              </c:if>
                            </c:forEach>  
                            
                            <%-- 
                              Display a select address message if theres at least one address, in case
                              we cant find a default address for this commerce item. 
                            --%>
                            <c:if test="${nonGiftShippingAddressCount == 0}">
                              <dsp:option value="" selected="${not gotSelectedAddress}">
                                <fmt:message key="checkout_shipping.selectAddress"/>
                              </dsp:option>
                            </c:if>
                                                      
                          </dsp:oparam>
                        </dsp:droplet>
                      </dsp:select> <%-- Dropdown list of addresses --%>
                    </li>

                    <%-- Display shipping method dropdown. --%>
                    <li>
                      <label for="atg_store_multiShippingMethodSelect${index}">
                        <fmt:message key="checkout_shippingOptions.shipVia"/><fmt:message key="common.labelSeparator"/>
                      </label>

                      <%-- We will get available shipping method from random shipping group. --%>
                      <dsp:getvalueof var="anyShippingGroup" bean="ShippingGroupFormHandler.firstNonGiftHardgoodShippingGroupWithRels"/>
                      <c:if test="${empty anyShippingGroup}">
                        <dsp:getvalueof var="giftShippingGroups" bean="ShippingGroupFormHandler.giftShippingGroups"/>
                        <c:if test="${not empty giftShippingGroups}">
                          <dsp:getvalueof var="anyShippingGroup" value="${giftShippingGroups[0]}"/>
                        </c:if>
                      </c:if>
                      <dsp:getvalueof var="currentMethod" bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingMethod"/>
                      <dsp:getvalueof var="defaultShippingMethod" bean="ProfileCheckoutPreferences.defaultShippingMethod"/>

                      <dsp:select bean="ShippingGroupFormHandler.allHardgoodCommerceItemShippingInfos[${index}].shippingMethod"
                                  required="true" id="atg_store_multiShippingMethodSelect${index}">
                        <%-- Calculate and display available methods. --%>
                        <dsp:droplet name="AvailableShippingMethods">
                          <dsp:param name="shippingGroup" value="${anyShippingGroup}"/>
                          <dsp:oparam name="output">
                            <dsp:getvalueof var="availableShippingMethods" vartype="java.lang.Object" param="availableShippingMethods"/>
                            <%-- 
                              Check if current shipping method defined in the shipping group is
                              the one from available shipping methods.
                              --%>
                            <c:if test="${not empty currentMethod}">
                              <c:set var="isCurrentInAvailableMethods" value="false"/>
                              <c:forEach var="method" items="${availableShippingMethods}" varStatus="status">
                                <c:if test="${currentMethod eq method}">
                                  <c:set var="isCurrentInAvailableMethods" value="true"/>
                                </c:if>
                              </c:forEach>
                            </c:if>

                            <%-- Heading option. --%>
                            <c:if test="${(empty availableShippingMethods or not isCurrentInAvailableMethods) and empty defaultShippingMethod}">
                              <dsp:option value="" selected="true">
                                <fmt:message key="checkout_shippingOptions.availableShippingMethods"/>
                              </dsp:option>
                            </c:if>

                            <%-- Display option per shipping method available. --%>
                            <c:forEach var="method" items="${availableShippingMethods}" varStatus="shippingMethodLoop">
                              <dsp:param name="method" value="${method}"/>
                              <c:set var="shippingMethod" value="${fn:replace(method, ' ', '')}"/>
                              <c:set var="shippingMethodResourceKey" value="checkout_shipping.delivery${shippingMethod}"/>
                              <c:set var="selected"
                                     value="${isCurrentInAvailableMethods && (currentMethod == method)
                                              || (empty currentMethod && method == defaultShippingMethod)}"/>
                              <dsp:option selected="${selected}" paramvalue="method">
                                <fmt:message key="${shippingMethodResourceKey}"/>
                              </dsp:option>
                            </c:forEach>
                          </dsp:oparam>
                        </dsp:droplet><%-- End Available Shipping Methods Droplet --%>
                      </dsp:select>
                    </li>
                  </ul>
                </td>
              </c:if>
            </tr>
          </c:forEach>
        </dsp:oparam>
      </dsp:droplet>
    </tbody>
  </table>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/checkout/gadgets/shippingMultipleDestinations.jsp#1 $$Change: 713790 $--%>
