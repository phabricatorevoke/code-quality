<%--
  This gadget displays price details for a commerce item specified. It displays price per quantity with discounts applied.

  Required parameters:
    currentItem
      Specifies a commerce item, whose price details should be displayed.

  Optional parameters:
    priceBeans
      Price beans to be used when displaying applied discounts.
    priceBeansQuantity
      Quantity to be displayed.
    excludeModelId
      The promotion ID which should be excluded from prices information. This parameter is used to
      exclude the item's quantity and corresponding price produced with the use of specified promotion ID
      from prices information. This is needed to display regular
      item's quantity and free gift quantity of the same commerce item as separate line items.      
--%>

<dsp:page>
  <dsp:importbean bean="/atg/commerce/pricing/UnitPriceDetailDroplet"/>

  <dsp:getvalueof var="excludeModelId" param="excludeModelId"/>
  <dsp:getvalueof var="rawPrice" param="currentItem.priceInfo.rawTotalPrice"/>
  <dsp:getvalueof var="actualPrice" param="currentItem.priceInfo.amount"/>
  <dsp:getvalueof var="listPrice" param="currentItem.priceInfo.listPrice"/>
  <dsp:getvalueof var="priceBeans" vartype="java.util.Collection" param="priceBeans"/>

  <%-- First check to see if the item was discounted. --%>
  <c:choose>
    <c:when test="${rawPrice == actualPrice}">
      <%-- They match, no discounts applied. --%>
      <c:choose>
        <%-- Price beans already found with StorePriceBeansDroplet, use their quantities. --%>
        <c:when test="${not empty priceBeans}">
          <dsp:include page="confirmItemPrice.jsp">
            <dsp:param name="quantity" param="priceBeansQuantity"/>
            <dsp:param name="price" param="currentItem.priceInfo.listPrice"/>
          </dsp:include>
        </c:when>
        <c:otherwise>
          <%-- No price beans, just get quantity from commerce item. --%>
          <dsp:include page="confirmItemPrice.jsp">
            <dsp:param name="quantity" param="currentItem.quantity"/>
            <dsp:param name="price" param="currentItem.priceInfo.listPrice"/>
          </dsp:include>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <%-- There's some discounting going on. Generate price beans for current commerce item. --%>
      <dsp:droplet name="UnitPriceDetailDroplet">
        <dsp:param name="item" param="currentItem"/>
        <dsp:oparam name="output">
          <%-- Always use price beans got from outer droplet, if any; otherwise use price beans generated for commerce item. --%>
          <c:set var="unitPriceBeans" value="${priceBeans}"/>
          <c:if test="${empty unitPriceBeans}">
            <dsp:getvalueof var="unitPriceBeans" vartype="java.lang.Object" param="unitPriceBeans"/>
          </c:if>
          <c:set var="priceBeansNumber" value="${fn:length(unitPriceBeans)}"/>
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
              <dsp:getvalueof var="unitPrice" param="unitPriceBean.unitPrice"/>
              <dsp:include page="confirmItemPrice.jsp">
                <dsp:param name="currentItem" param="currentItem"/>
                <dsp:param name="unitPriceBean" param="unitPriceBean"/>
                <dsp:param name="quantity" param="unitPriceBean.quantity"/>
                <dsp:param name="price" value="${unitPrice}"/>
                <dsp:param name="oldPrice" value="${unitPrice == listPrice ? '' : listPrice}"/>
              </dsp:include>
            </c:if>
          </c:forEach>
        </dsp:oparam>
      </dsp:droplet><%-- End for unit price detail droplet --%>
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/checkout/gadgets/confirmDetailedItemPrice.jsp#1 $$Change: 713790 $--%>
