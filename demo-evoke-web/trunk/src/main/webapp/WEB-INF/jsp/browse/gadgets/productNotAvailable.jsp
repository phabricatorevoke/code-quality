<%--
  This gadget renders a "Sorry, can't find a product" message.

  Required parameters:
    None.

  Optional parameters:
    productId
      Specifies a product we were unable to find by its ID.
    site
      Specifies a current site name.
--%>

<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />

  <dsp:getvalueof id="productId" param="productId"/>
  <dsp:getvalueof id="site" param="site"/>

  <crs:pageContainer bodyClass="atg_store_pageProductDetail atg_store_productNotAvailable">
    <jsp:body>
      <div id="atg_store_contentHeader">
      </div>

      <%-- Determines message to display. --%>
      <c:choose>
        <%-- If we have a site specific message display to display. --%>
        <c:when test="${not empty site && not empty productId}">
          <fmt:message var="errorMessage" key="common.productNotFoundForSite">
            <fmt:param value="${productId}"/>
            <fmt:param value="${site}"/>
          </fmt:message>
        </c:when>
        <%-- If we have a productId specified. --%>
        <c:when test="${not empty productId}">
          <fmt:message var="errorMessage" key="common.productNotFound">
            <fmt:param value="${productId}"/>
          </fmt:message>
        </c:when>
        <%-- Display a generic error message. --%>
        <c:otherwise>
          <fmt:message var="errorMessage" key="common.productIdNotFound"/>
        </c:otherwise>
      </c:choose>

      <%-- Render the message. --%>
      <crs:messageContainer titleText="${errorMessage}">
        <jsp:body>
          <%-- Continue shopping link. --%>
          <crs:continueShopping>
            <%-- Use the continueShoppingURL defined by crs:continueShopping tag. --%>
            <dsp:a href="${continueShoppingURL}" iclass="atg_store_basicButton">
              <span>
                <fmt:message key="common.button.continueShoppingText"/>
              </span>
            </dsp:a>
          </crs:continueShopping>
        </jsp:body>
      </crs:messageContainer>
    </jsp:body>
  </crs:pageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/browse/gadgets/productNotAvailable.jsp#1 $$Change: 713790 $ --%>