<%--
  This page renders empty "Shopping Cart".

  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter
    /mobile/cart/gadgets/getTargeterProduct.jsp - Return product from the targeter
    /mobile/global/gadgets/productLinkGenerator.jsp product - Product link generator
    /mobile/global/gadgets/recentlyViewed.jsp - "Recently Viewed Items" slider panel

  Required parameters:
    None

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>

  <div class="cartContainer">
    <div class="cartData">
      <div class="cartSummary">
        <div class="orderInfo">
          <dl class="orderTotal">
            <dt class="totalText"><fmt:message key="mobile.price.total"/><fmt:message key="mobile.common.labelSeparator"/></dt>
            <dd class="totalPrice">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="0"/>
              </dsp:include>
            </dd>
          </dl>
         </div>
      </div>
    </div>
  </div>

  <jsp:useBean id="featuredProducts" class="java.util.HashMap"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct1"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct1" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct2"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct2" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct3"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct3" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct4"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct4" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct5"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct5" value="${requestScope.product}"/>

  <%-- Display "Featured Items" slider panel, if any --%>
  <c:if test="${not empty featuredProducts}">
    <div class="itemsContainer">
      <div class="sliderTitle"><fmt:message key="mobile.browse_featuredProducts.featuredItemTitle"/></div>
      <div id="featuredItemsContainer">
        <c:forEach var="entry" items="${featuredProducts}">
          <div class="cell">
            <dsp:param name="product" value="${entry.value}"/>
            <dsp:getvalueof var="productImageUrl" param="product.smallImage.url"/>
            <dsp:getvalueof var="productName" param="product.displayName"/>
            <dsp:include page="${mobileStorePrefix}/global/gadgets/productLinkGenerator.jsp">
              <dsp:param name="product" param="product"/>
            </dsp:include>
            <a href="${fn:escapeXml(productUrl)}"><img src="${productImageUrl}" alt="${productName}" class="cellImage"/></a>
          </div>
        </c:forEach>
      </div>
    </div>
  </c:if>

  <%-- Display "Recently Viewed Items" slider panel, if any --%>
  <dsp:include page="${mobileStorePrefix}/global/gadgets/recentlyViewed.jsp"/>

  <script type="text/javascript">
    $(document).ready(function() {
      <c:if test="${not empty featuredProducts}">
        CRSMA.cart.initFeaturedItemsSliderPanel();
      </c:if>
      CRSMA.cart.initRecentlyViewedItemsSliderPanel();
    });
  </script>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/cart/emptyCart.jsp#5 $$Change: 733297 $ --%>
