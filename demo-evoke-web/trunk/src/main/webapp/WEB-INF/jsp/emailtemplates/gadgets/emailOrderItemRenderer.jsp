<%--
  This page renders the specified commerce item relationship details for order confirmation and 
  order shipped email templates. It is considered to be included inside of table with commerce items 
  relationships list for each individual commerce item row.

  Required parameters:
    order
      The order that the commerce item belongs to 
    commerceItemRel
      The commerce item relationship to display details for
    httpServer
      The URL prefix that is used to build fully-qualified absolute URLs

  Optional parameters:
    priceListLocale
      The locale to use for prices formatting
    locale
      Locale to append to the URL as URL parameter so that the pages to which user navigates using the URL
      will be rendered in the same language as the email.
--%>
<dsp:page>

  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/store/droplet/StorePriceBeansDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>
  <dsp:importbean bean="/atg/commerce/promotion/GiftWithPurchaseSelectionsDroplet"/>
    
  <dsp:getvalueof id="httpServer" param="httpServer"/>
  <dsp:getvalueof id="locale" param="locale"/>
  
  <%-- Get commerce item from commerce item relationship --%>
  <dsp:param name="commerceItem" param="currentItemRel.commerceItem"/>
  <dsp:getvalueof var="commerceItemQty" param='currentItemRel.commerceItem.quantity'/>
  
  
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
    <dsp:param name="order" param="order"/>
    <dsp:param name="item" param="commerceItem" />
    
    <%-- Gift with purchase item --%>  
    <dsp:oparam name="output">
      <dsp:getvalueof var="selections" param="selections" />

      <c:forEach var="selection" items="${selections}">
        <dsp:param name="selection" value="${selection}" />
    
        <%-- Check if the given commerce item contains regular items except gifts --%>
        <dsp:getvalueof var="automaticQuantity" param="selection.automaticQuantity"/>
        <dsp:getvalueof var="targetedQuantity" param="selection.targetedQuantity"/>
        <dsp:getvalueof var="selectedQuantity" param="selection.selectedQuantity"/>
        <dsp:getvalueof var="selectedQty" value="${automaticQuantity + targetedQuantity + selectedQuantity}"/>
                   
        <%-- Split gift items and regular items --%>                   
        <c:if test="${commerceItemQty > selectedQty}">
        
          <tr>
            <%-- Site icon --%>
            <td style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:60px;height:60px; border-bottom: 1px solid #666666;">
              
              <dsp:include page="/global/gadgets/siteIndicator.jsp">
                <dsp:param name="mode" value="icon"/>              
                <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId"/>
                <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
                <dsp:param name="absoluteResourcePath" value="true"/>
              </dsp:include>
             
            </td>

            <dsp:getvalueof var="productDisplayName" param="commerceItem.auxiliaryData.catalogRef.displayName"/> 
            <c:if test="${empty productDisplayName}">
              <dsp:getvalueof var="productDisplayName" param="commerceItem.auxiliaryData.productRef.displayName"/>
              <c:if test="${empty productDisplayName}">
                <fmt:message var="productDisplayName" key="common.noDisplayName" />
              </c:if>  
            </c:if> 

            <%-- Item's display name as link to the product page. --%>
            <td scope="row" abbr="${productDisplayName}" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:170px;border-bottom: 1px solid #666666;" >
              <%-- Display name --%>              
              <span style="font-size:14px;color:#333;">
                <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
                  <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
                  <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId" />
                  <dsp:param name="forceFullSite" value="${true}"/>
                </dsp:include>

                <c:url var="productUrl" value="${httpServer}${productUrl}">
                  <c:if test="${not empty locale}">
                    <c:param name="locale">${locale}</c:param>
                  </c:if>
                </c:url>
        
                <%-- Check whether item is navigable, if so display its name as link to product page. --%>
                <dsp:getvalueof var="navigable" vartype="java.lang.Boolean" param="commerceItem.auxiliaryData.productRef.NavigableProducts"/>
                <c:choose>
                  <c:when test="${!navigable}">                   
                    <c:out value="${productDisplayName}"/>
                  </c:when>
                  <c:otherwise>
                    <dsp:a href="${productUrl}">
                      <c:out value="${productDisplayName}"/>                        
                    </dsp:a>
                  </c:otherwise>
                </c:choose>
              </span>
              
              <%-- Check the SKU type to display type-specific properties --%>
              <dsp:getvalueof var="skuType" vartype="java.lang.String" param="commerceItem.auxiliaryData.catalogRef.type"/>
              <c:choose>
                <%-- 
                  For 'clothing-sku' SKU type display the following properties:
                    1. size
                    2. color
                --%>
                <c:when test="${skuType == 'clothing-sku'}">
                  <dsp:getvalueof var="catalogRefSize" param="commerceItem.auxiliaryData.catalogRef.size"/>
                  <c:if test="${not empty catalogRefSize}">
                    <p>
                      <span style="font-size:12px;color:#666666;">
                        <fmt:message key="common.size"/><fmt:message key="common.labelSeparator"/>
                      </span>
                      <span style="font-size:12px;color:#000000;">${catalogRefSize}</span>
                    </p>
                  </c:if>
                
                  <dsp:getvalueof var="catalogRefColor"    param="commerceItem.auxiliaryData.catalogRef.color"/>
                  <c:if test="${not empty catalogRefColor}">
                    <p>
                      <span style="font-size:12px;color:#666666;">
                        <fmt:message key="common.color"/><fmt:message key="common.labelSeparator"/>
                      </span>
                      <span style="font-size:12px;color:#000000;">${catalogRefColor}</span>
                    </p>
                  </c:if>
                </c:when>
                <%-- 
                  For 'furniture-sku' SKU type display the following properties:
                    1. woodFinish
                --%>
                <c:when test="${skuType == 'furniture-sku'}">
                  <dsp:getvalueof var="catalogRefWoodFinish" param="commerceItem.auxiliaryData.catalogRef.woodFinish"/>
                  <c:if test="${not empty catalogRefWoodFinish}">
                    <p>
                      <span style="font-size:12px;color:#666666;">
                        <fmt:message key="common.woodFinish"/><fmt:message key="common.labelSeparator"/>
                      </span>
                      <span style="font-size:12px;color:#000000;">${catalogRefWoodFinish}</span>
                    </p>
                  </c:if>
                </c:when>
              </c:choose>
              
              <%-- SKU description --%>
              <dsp:getvalueof var="catalogRefDescription" 
                              param="commerceItem.auxiliaryData.catalogRef.description"/>
              <c:if test="${not empty catalogRefDescription}">
                <p>${catalogRefDescription}</p>
              </c:if>
             
            </td>      

            <%-- 
              Generates price beans for the specified shipping group to commerce item 
              relationship.
              
              Input parameters:
                relationship
                  shipping group to commerce item relationship for which price bean should
                  be generated. 
                
              Output parameters:
                priceBeans
                  price bean for the relationship specified.
                priceBeansQuantity
                  Total items quantity for the relationship specified.
                priceBeansAmount
                  The total amount for the relationship specified.
             --%>
            <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
              <dsp:param name="relationship" param="commerceItemRel"/>
              <dsp:oparam name="output">
                <td colspan="2" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color#666666;width:205px;border-buttom: 1px solid #666666;">
        
                  <%-- Get generated price beans --%>
                  <dsp:getvalueof var="unitPriceBeans" vartype="java.util.Collection" param="priceBeans"/>
                  
                  <dsp:getvalueof var="excludeModelId" param="selection.promotionId"/>
            
                  <%--
                    The commerce item was discounted, loop through all price details and
                    display each as separate line.
                   --%>
                  <table style="border-collapse: collapse; width: 215px;" summary="" role="presentation">
                    <c:forEach var="unitPriceBean" items="${unitPriceBeans}">
                      <c:set var="displayPrice" value="true"/>        
                      <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
                      
                      <%-- 
                        Check if the given price bean contains GWP model. If yes,
                        just skip it - no need to display 0.0 price, it will be
                        handled in another item line.
                       --%>
                       <dsp:getvalueof var="pricingModels" param="unitPriceBean.pricingModels"/>
              
                       <c:if test="${not empty pricingModels}">
                        <c:forEach var="pricingModel" items="${pricingModels}" varStatus="status">
                          <dsp:param name="pricingModel" value="${pricingModel}"/>
                          <dsp:getvalueof var="modelId" param="pricingModel.id"/>
                          <c:if test="${excludeModelId == modelId}">
                            <c:set var="displayPrice" value="false"/>
                          </c:if>
                        </c:forEach>
                       </c:if>
                      
                      <c:if test="${displayPrice}">
                        <tr>
                          <%-- Quantity --%>
                          <td style="width:65px;color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif; text-align: center;">
                            <dsp:getvalueof var="quantity" vartype="java.lang.Double" param="unitPriceBean.quantity"/>
                            <fmt:formatNumber value="${quantity}" type="number"/>
                            <fmt:message key="common.atRateOf"/>
                          </td>
                          <%-- Price --%>
                          <td style="color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif; width: 150px; ">
                            <dsp:getvalueof var="unitPrice" vartype="java.lang.Double" param="unitPriceBean.unitPrice"/>
                            <%-- Format price using the specified price list locale --%>
                            <dsp:include page="/global/gadgets/formattedPrice.jsp">
                              <dsp:param name="price" value="${unitPrice }"/>
                              <dsp:param name="priceListLocale" param="priceListLocale"/>
                            </dsp:include>
                  
                            <%-- Discount message --%>
                            <span style="display:block;font-size:12px;font-family:Tahoma,Arial,sans-serif;">
                              <dsp:getvalueof var="pricingModels" vartype="java.lang.Object" param="unitPriceBean.pricingModels"/> 
                              <c:choose>
                                <c:when test="${not empty pricingModels}">
                                  <c:forEach var="pricingModel" items="${pricingModels}">
                                    <dsp:param name="pricingModel" value="${pricingModel}"/>
                                    <dsp:valueof param="pricingModel.displayName" valueishtml="true">
                                      <fmt:message key="common.promotionDescriptionDefault"/>
                                    </dsp:valueof>
                                  </c:forEach>
                                  <%-- End for each promotion used to create the unit price --%>
                                </c:when>
                                <c:otherwise>
                                  <%-- There are no promotions for current price detail, check whether item is on sale --%>
                                  <dsp:getvalueof var="commerceItemOnSale" param="commerceItem.priceInfo.onSale"/> 
                                  <c:if test='${commerceItemOnSale == "true"}'>
                                   <fmt:message key="cart_detailedItemPrice.salePriceB"/>
                                  </c:if>
                                </c:otherwise>
                              </c:choose>
                            </span>
                          </td>
                        </tr>
                      </c:if>
                    </c:forEach>
                  </table>
                </td>
          
                <%-- Total commerce item's amount --%>
                <td align="right" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color:#000000; white-space:nowrap;border-buttom: 1px solid #666666;">
                  <fmt:message key="common.equals"/>
                  <span style="color:#000000">
                    <dsp:include page="/global/gadgets/formattedPrice.jsp">
                      <dsp:param name="price" param="priceBeansAmount"/>
                      <dsp:param name="priceListLocale" param="priceListLocale"/>
                    </dsp:include>     
                  </span>             
                </td>
              </dsp:oparam>
            </dsp:droplet>
            <%-- End for unit price detail droplet --%>
          </tr>          
        </c:if>

        <%-- 
          Display selections on separate rows with quantity 1. 
         --%>
        <c:forEach begin="1" end="${selectedQty}">
          <dsp:include page="/emailtemplates/gadgets/emailOrderGiftItem.jsp">
            <dsp:param name="selection" param="selection"/>
            <dsp:param name="commerceItem" param="commerceItem"/>
            <dsp:param name="httpServer" param="httpServer"/>
            <dsp:param name="locale" param="locale"/>
          </dsp:include>                        
        </c:forEach>
                
      </c:forEach>
    </dsp:oparam>

    <%-- Regular commerce item --%>      
    <dsp:oparam name="empty">
    
      <tr>

        <%-- Site icon --%>
        <td style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:60px;height:60px; border-bottom: 1px solid #666666;">
          
          <dsp:include page="/global/gadgets/siteIndicator.jsp">
            <dsp:param name="mode" value="icon"/>              
            <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId"/>
            <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
            <dsp:param name="absoluteResourcePath" value="true"/>
          </dsp:include>
         
        </td>
        
        <dsp:getvalueof var="productDisplayName" param="commerceItem.auxiliaryData.catalogRef.displayName"/> 
        <c:if test="${empty productDisplayName}">
          <dsp:getvalueof var="productDisplayName" param="commerceItem.auxiliaryData.productRef.displayName"/>
          <c:if test="${empty productDisplayName}">
            <fmt:message var="productDisplayName" key="common.noDisplayName" />
          </c:if>  
        </c:if> 

        <%-- Item's display name as link to the product page. --%>
        <td scope="row" abbr="${productDisplayName}" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;width:170px; border-bottom: 1px solid #666666;">
          <%-- Display name --%>
          <span style="font-size:14px;color:#333;">
            <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
              <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
              <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId"/>
              <dsp:param name="forceFullSite" value="${true}"/>
            </dsp:include>

            <c:url var="productUrl" value="${httpServer}${productUrl}">
              <c:if test="${not empty locale}">
                <c:param name="locale">${locale}</c:param>
              </c:if>
            </c:url>
    
            <%-- Check whether item is navigable, if so display its name as link to product page. --%>
            <dsp:getvalueof var="navigable" vartype="java.lang.Boolean" param="commerceItem.auxiliaryData.productRef.NavigableProducts"/>
            <c:choose>
              <c:when test="${!navigable}">
                <c:out value="${productDisplayName}"/>
              </c:when>
              <c:otherwise>
                <dsp:a href="${productUrl}">
                  <c:out value="${productDisplayName}"/>
                </dsp:a>
              </c:otherwise>
            </c:choose>
          </span>
          
          <%-- Check the SKU type to display type-specific properties --%>
          <dsp:getvalueof var="skuType" vartype="java.lang.String" param="commerceItem.auxiliaryData.catalogRef.type"/>
          <c:choose>
            <%-- 
              For 'clothing-sku' SKU type display the following properties:
                1. size
                2. color
            --%>
            <c:when test="${skuType == 'clothing-sku'}">
              <dsp:getvalueof var="catalogRefSize" param="commerceItem.auxiliaryData.catalogRef.size"/>
              <c:if test="${not empty catalogRefSize}">
                <p>
                  <span style="font-size:12px;color:#666666;">
                    <fmt:message key="common.size"/><fmt:message key="common.labelSeparator"/>
                  </span>
                  <span style="font-size:12px;color:#000000;">${catalogRefSize}</span>
                </p>
              </c:if>
            
              <dsp:getvalueof var="catalogRefColor"    param="commerceItem.auxiliaryData.catalogRef.color"/>
              <c:if test="${not empty catalogRefColor}">
                <p>
                  <span style="font-size:12px;color:#666666;">
                    <fmt:message key="common.color"/><fmt:message key="common.labelSeparator"/>
                  </span>
                  <span style="font-size:12px;color:#000000;">${catalogRefColor}</span>
                </p>
              </c:if>
            </c:when>
            <%-- 
              For 'furniture-sku' SKU type display the following properties:
                1. woodFinish
            --%>
            <c:when test="${skuType == 'furniture-sku'}">
              <dsp:getvalueof var="catalogRefWoodFinish" param="commerceItem.auxiliaryData.catalogRef.woodFinish"/>
              <c:if test="${not empty catalogRefWoodFinish}">
                <p>
                  <span style="font-size:12px;color:#666666;">
                    <fmt:message key="common.woodFinish"/><fmt:message key="common.labelSeparator"/>
                  </span>
                  <span style="font-size:12px;color:#000000;">${catalogRefWoodFinish}</span>
                </p>
              </c:if>
            </c:when>
          </c:choose>
          
          <%-- SKU description --%>
          <dsp:getvalueof var="catalogRefDescription" 
                          param="commerceItem.auxiliaryData.catalogRef.description"/>
          <c:if test="${not empty catalogRefDescription}">
            <p>${catalogRefDescription}</p>
          </c:if>
         
        </td>      

        <%-- 
          Generates price beans for the specified shipping group to commerce item 
          relationship.
          
          Input parameters:
            relationship
              shipping group to commerce item relationship for which price bean should
              be generated. 
            
          Output parameters:
            priceBeans
              price bean for the relationship specified.
            priceBeansQuantity
              Total items quantity for the relationship specified.
            priceBeansAmount
              The total amount for the relationship specified.
         --%>
        <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">
          <dsp:param name="relationship" param="commerceItemRel"/>
          <dsp:oparam name="output">
            <td colspan="2" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color#666666;width:205px; border-bottom: 1px solid #666666;">
    
              <%-- Get generated price beans --%>
              <dsp:getvalueof var="unitPriceBeans" vartype="java.util.Collection" param="priceBeans"/>
        
              <%--
                The commerce item was discounted, loop through all price details and
                display each as separate line.
               --%>
              <table style="border-collapse: collapse; width: 215px;"
                     summary="" role="presentation">
                <c:forEach var="unitPriceBean" items="${unitPriceBeans}">        
                  <dsp:param name="unitPriceBean" value="${unitPriceBean}"/>
                  <tr>
                    <%-- Quantity --%>
                    <td style="width:65px;color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif; text-align: center;">
                      <dsp:getvalueof var="quantity" vartype="java.lang.Double" param="unitPriceBean.quantity"/>
                      <fmt:formatNumber value="${quantity}" type="number"/>
                      <fmt:message key="common.atRateOf"/>
                    </td>
                    <%-- Price --%>
                    <td style="color:#666666;font-size:12px;font-family:Tahoma,Arial,sans-serif; width: 150px; ">
                      <dsp:getvalueof var="unitPrice" vartype="java.lang.Double" param="unitPriceBean.unitPrice"/>
                      <%-- Format price using the specified price list locale --%>
                      <dsp:include page="/global/gadgets/formattedPrice.jsp">
                        <dsp:param name="price" value="${unitPrice }"/>
                        <dsp:param name="priceListLocale" param="priceListLocale"/>
                      </dsp:include>
            
                      <%-- Discount message --%>
                      <span style="display:block;font-size:12px;font-family:Tahoma,Arial,sans-serif;">
                        <dsp:getvalueof var="pricingModels" vartype="java.lang.Object" param="unitPriceBean.pricingModels"/> 
                        <c:choose>
                          <c:when test="${not empty pricingModels}">
                            <c:forEach var="pricingModel" items="${pricingModels}">
                              <dsp:param name="pricingModel" value="${pricingModel}"/>
                              <dsp:valueof param="pricingModel.displayName" valueishtml="true">
                                <fmt:message key="common.promotionDescriptionDefault"/>
                              </dsp:valueof>
                            </c:forEach>
                            <%-- End for each promotion used to create the unit price --%>
                          </c:when>
                          <c:otherwise>
                            <%-- There are no promotions for current price detail, check whether item is on sale --%>
                            <dsp:getvalueof var="commerceItemOnSale" param="commerceItem.priceInfo.onSale"/> 
                            <c:if test='${commerceItemOnSale == "true"}'>
                             <fmt:message key="cart_detailedItemPrice.salePriceB"/>
                            </c:if>
                          </c:otherwise>
                        </c:choose>
                      </span>
                    </td>
                  </tr>
                </c:forEach>
              </table>
            </td>
      
            <%-- Total commerce item's amount --%>
            <td align="right" style="font-family:Tahoma,Arial,sans-serif;font-size:12px;color:#000000; white-space:nowrap; border-bottom: 1px solid #666666;">
              <fmt:message key="common.equals"/>
              <span style="color:#000000">
                <dsp:include page="/global/gadgets/formattedPrice.jsp">
                  <dsp:param name="price" param="priceBeansAmount"/>
                  <dsp:param name="priceListLocale" param="priceListLocale"/>
                </dsp:include>     
              </span>             
            </td>
          </dsp:oparam>
        </dsp:droplet>
        <%-- End for unit price detail droplet --%>
      </tr>    
    </dsp:oparam>
  </dsp:droplet>
  
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/emailtemplates/gadgets/emailOrderItemRenderer.jsp#2 $$Change: 732131 $--%>