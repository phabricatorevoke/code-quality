<%--
  Renders "Recently Viewed Items" slider panel based on "Profile.recentlyViewedProducts"
  user profile collection.
  It's also possible to exclude particular products from the list and
  limit the number of products that can be displayed.

  Page includes:
    /mobile/global/gadgets/productLinkGenerator.jsp - Product link generator

  Required Parameters:
    None

  Optional Parameters:
    exclude
      This can be a product ID, a list of product IDs or List of
      product "RepositoryItems" that are to be excluded from the
      "Recently Viewed Items" list.
    size
      The number of products that are to be displayed in the
      "Recently Viewed Items" list. A default size is defined in
      the "RecentlyViewedFilterDroplet" "filter" component.
      The default value (if this parameter is not specified) is 5.
--%>
<dsp:page>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
  <dsp:importbean bean="/atg/store/droplet/RecentlyViewedFilterDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <dsp:droplet name="RecentlyViewedFilterDroplet">
    <dsp:param name="collection" bean="Profile.recentlyViewedProducts"/>
    <dsp:param name="exclude" param="exclude"/>
    <dsp:param name="size" param="size"/>
    <dsp:oparam name="output">
      <%--
        Display each item of the "filteredCollection".
        Input Parameters:
          array:
            The filtered collection we wish to iterate over.
        Open Parameters:
          outputStart:
            Anything we want to output on the first iteration goes into this.
              - In this case we will output the title of the recently viewed
                items feature along with an HTML unordered list opening tag.
          output:
            Rendered for each element in the collection.
              - In this case each product in the "filteredCollection" will be displayed.
          outputEnd:
            Anything we want to output on the last iteration goes into this.
              - In this case we will close add an HTML unordered list tag.
      --%>
      <dsp:droplet name="ForEach">
        <dsp:param name="array" param="filteredCollection"/>
        <dsp:oparam name="outputStart">
          <div class="itemsContainer">
            <div class="sliderTitle"><fmt:message key="mobile.browse_recentlyViewedProducts.title"/></div>
            <div id="recentlyViewedItemsContainer">
        </dsp:oparam>
        <dsp:oparam name="output">
          <dsp:setvalue param="product" paramvalue="element.product"/>
          <dsp:getvalueof var="productName" param="product.displayName"/>
          <dsp:getvalueof var="productImageUrl" param="product.smallImage.url"/>
          <c:if test="${empty productImageUrl}">
            <c:set var="productImageUrl" value="/crsdocroot/content/images/products/small/MissingProduct_small.jpg"/>
          </c:if>
          <%-- Get URL for the product: the URL is stored in the "productUrl" request-scoped variable --%>
          <dsp:include page="${mobileStorePrefix}/global/gadgets/productLinkGenerator.jsp">
            <dsp:param name="product" param="product"/>
          </dsp:include>

          <div class="cell">
            <a href="${fn:escapeXml(productUrl)}"><img src="${productImageUrl}" alt="${productName}" class="cellImage"/></a>
          </div>
        </dsp:oparam>
        <dsp:oparam name="outputEnd">
            </div>
          </div>
        </dsp:oparam>
      </dsp:droplet>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
