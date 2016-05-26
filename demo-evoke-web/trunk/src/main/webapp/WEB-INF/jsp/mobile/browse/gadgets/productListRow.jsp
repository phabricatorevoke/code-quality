<%--
  This JSP renders single row in product search results pages.

  Page includes:
    /mobile/global/gadgets/productLinkGenerator.jsp - Product link generator
    /global/gadgets/formattedPrice.jsp - Price formatter

  Required parameters:
    product
      Product repository item whose details are displayed

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/pricing/priceLists/PriceDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>
  <dsp:importbean bean="/atg/commerce/multisite/SiteIdForCatalogItem"/>

  <dsp:getvalueof var="mobileStorePrefix" bean="/atg/store/StoreConfiguration.mobileStorePrefix"/>

  <dsp:getvalueof var="productSites" param="product.siteIds" />
  <dsp:getvalueof var="siteId" bean="Site.id" />
  <dsp:contains var="productFromCurrentSite" values="${productSites}" object="${siteId}"/>

  <dsp:include page="${mobileStorePrefix}/global/gadgets/productLinkGenerator.jsp">
    <dsp:param name="product" param="product"/>
  </dsp:include>
  
  <dsp:a href="${fn:escapeXml(productUrl)}" class="listRowLink">
    <span class="searchResult" >
      <dsp:getvalueof var="productName" param="product.displayName"/>
      <dsp:getvalueof var="productImageUrl" param="product.thumbnailImage.url"/>

      <c:if test="${empty productImageUrl}">
      	<c:set var="productImageUrl" value="/crsdocroot/content/images/products/thumb/MissingProduct_thumb.jpg"/>
      </c:if>

      <%-- "notLoaded" class will be removed once the image is loaded --%>
      <img onload="CRSMA.global.removeImgNotLoaded(this);" src="${productImageUrl}" alt="${productName}"/>

      <p class="searchResultProduct">
        <span class="productName"><c:out value="${productName}"/></span>

        <%--
          The 1-st call to price droplet is going to get the price from the profile price list
          or the default price list
        --%>
        <dsp:droplet name="PriceDroplet">
          <dsp:param name="product" param="product"/>
          <dsp:param name="sku" param="product.childSKUs[0]"/>
          <dsp:oparam name="output">
            <dsp:setvalue param="theListPrice" paramvalue="price"/>

            <%-- Is there a sale price? --%>
            <dsp:getvalueof var="profileSalePriceList" bean="Profile.salePriceList"/>
            <c:choose>
              <c:when test="${not empty profileSalePriceList}">
                <dsp:droplet name="PriceDroplet">
                  <dsp:param name="priceList" bean="Profile.salePriceList"/>
                  <dsp:oparam name="output">
                    <dsp:getvalueof var="listPrice" vartype="java.lang.Double" param="price.listPrice"/>
                    <dsp:getvalueof var="price" vartype="java.lang.Double" param="theListPrice.listPrice"/>
                    <span class="productPrice">
                      <dsp:include page="/global/gadgets/formattedPrice.jsp">
                        <dsp:param name="price" value="${listPrice}"/>
                      </dsp:include>
                    </span>
                    <span class="oldPrice">
                      <fmt:message key="mobile.price.old"/>
                      <dsp:include page="/global/gadgets/formattedPrice.jsp">
                        <dsp:param name="price" value="${price}"/>
                      </dsp:include>
                    </span>
                  </dsp:oparam>
                  <dsp:oparam name="empty">
                    <dsp:getvalueof var="price" vartype="java.lang.Double" param="theListPrice.listPrice"/>
                    <span class="productPrice">
                      <dsp:include page="/global/gadgets/formattedPrice.jsp">
                        <dsp:param name="price" value="${price}"/>
                      </dsp:include>
                    </span>
                  </dsp:oparam>
                </dsp:droplet><%-- End price droplet on sale price --%>
              </c:when>
              <c:otherwise>
                <c:out value="otherwise"/>
                <span class="productPrice">
                  <dsp:include page="/global/gadgets/formattedPrice.jsp">
                    <dsp:param name="price" value="${price}"/>
                  </dsp:include>
                </span>
              </c:otherwise>
            </c:choose> <%-- End Is Empty Check --%>
          </dsp:oparam>
        </dsp:droplet>
      </p>
      
      <c:if test="${not productFromCurrentSite}">   
        <dsp:getvalueof var="product" param="product"/>
           <dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
            <dsp:oparam name="output">
              <dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/> 
          </dsp:oparam>             
        </dsp:droplet>
        <dsp:include page="otherStoreProductLabel.jsp">
          <dsp:param name="siteId" value="${siteId}"/>
        </dsp:include>
      </c:if>
    </span>
    <div class="shadow">&nbsp;</div>
  </dsp:a>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/browse/gadgets/productListRow.jsp#8 $$Change: 728798 $--%>
