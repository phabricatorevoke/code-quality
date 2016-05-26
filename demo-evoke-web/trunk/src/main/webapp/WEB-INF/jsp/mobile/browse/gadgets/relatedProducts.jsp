<%-- 
  Related items for "Product details".

  Page includes:
    /mobile/global/gadgets/productLinkGenerator.jsp - Product link generator

  Required parameters:
    relatedProducts
      Filtered collection of related items we want to display

  Optional parameters:
    None
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="relatedProducts" param="relatedProducts"/>

  <dsp:getvalueof var="mobileStorePrefix" bean="/atg/store/StoreConfiguration.mobileStorePrefix"/>

  <div id="relatedItemsContainer">
    <c:forEach var="relatedProduct" items="${relatedProducts}">
      <div class="cell">
        <dsp:param name="relatedProduct" value="${relatedProduct}"/>
        <dsp:getvalueof var="relatedImageUrl" param="relatedProduct.smallImage.url"/>
        <dsp:getvalueof var="relatedProductName" param="relatedProduct.displayName"/>
        <%--
          Generates URL for the product, the URL is stored in the "productUrl" request-scoped variable
        --%>
        <dsp:include page="${mobileStorePrefix}/global/gadgets/productLinkGenerator.jsp">
          <dsp:param name="product" param="relatedProduct"/>
        </dsp:include>

        <c:if test="${empty relatedImageUrl}">
          <c:set var="relatedImageUrl" value="/crsdocroot/content/images/products/small/MissingProduct_small.jpg"/>
        </c:if>
        <a href="${fn:escapeXml(productUrl)}"><img src="${relatedImageUrl}" alt="${relatedProductName}" class="cellImage"/></a>
      </div>
    </c:forEach>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/browse/gadgets/relatedProducts.jsp#4 $$Change: 731877 $--%>
