<%--
  Renders Endeca-specific navigation links based on "NavigationAction" given.

  Page includes:
    /mobile/global/util/getNavLink.jsp - Endeca-specific navigation link generator

  Required parameters:
    navAction
      Endeca "NavigationAction" instance.
    text
      Anchor text.
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="navAction" vartype="com.endeca.infront.cartridge.model.NavigationAction" param="navAction"/> 
  <dsp:getvalueof var="text" param="text"/> 

  <dsp:getvalueof var="mobileStorePrefix" bean="/atg/store/StoreConfiguration.mobileStorePrefix"/>
  <dsp:include page="${mobileStorePrefix}/global/util/getNavLink.jsp">
    <dsp:param name="navAction" value="${navAction}"/>
  </dsp:include>

  <a href="javascript:void(0)" onclick="CRSMA.search.disableSubCategoryCrumbs(this, '${navLink}')">
    <c:out value="${text}" escapeXml="false"/>
  </a>
</dsp:page>
