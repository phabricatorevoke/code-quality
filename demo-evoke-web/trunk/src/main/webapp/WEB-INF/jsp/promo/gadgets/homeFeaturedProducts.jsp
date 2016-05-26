<%--
  This page displays home featured products using TargetingRandom droplet.
  
  Required Parameters:
    None
    
  Optional Parameters:
    None  
 --%>
 
<dsp:page>
  
  <%-- Render medium images for the featured products --%>
  <c:set var="imagesize" value="medium"/>

  <div class="atg_store_homepage_products">
    <ul class="atg_store_product">
      <li>
        <%-- The first featured product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp">
          <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct1"/>
          <dsp:param name="renderer" value="/global/gadgets/promotedProductRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
          <dsp:param name="imagesize" value="${imagesize}"/>
        </dsp:include>
      </li>          
      <li>
        <%-- The second featured product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp">
          <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct2"/>
          <dsp:param name="renderer" value="/global/gadgets/promotedProductRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
          <dsp:param name="imagesize" value="${imagesize}"/>
        </dsp:include>
      </li>      
      <li>
        <%-- The third featured product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp">
          <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct3"/>
          <dsp:param name="renderer" value="/global/gadgets/promotedProductRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
          <dsp:param name="imagesize" value="${imagesize}"/>
        </dsp:include>
      </li>      
      <li>
        <%-- The forth featured product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp">
          <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct4"/>
          <dsp:param name="renderer" value="/global/gadgets/promotedProductRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
          <dsp:param name="imagesize" value="${imagesize}"/>
        </dsp:include>
      </li>      
      <li>
        <%-- The fifth featured product --%>
        <dsp:include page="/global/gadgets/targetingRandom.jsp">
          <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct5"/>
          <dsp:param name="renderer" value="/global/gadgets/promotedProductRenderer.jsp"/>
          <dsp:param name="elementName" value="product"/>
          <dsp:param name="showAddToCart" value="false"/>
          <dsp:param name="imagesize" value="${imagesize}"/>
        </dsp:include>
      </li>      
    </ul>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/promo/gadgets/homeFeaturedProducts.jsp#1 $$Change: 713790 $--%>
