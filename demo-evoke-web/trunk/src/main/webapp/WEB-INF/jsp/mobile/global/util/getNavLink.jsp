<%--
  Returns Endeca-specific navigation links based on "NavigationAction" given.
  The result is returned in the "navLink" request-scoped variable.

  Required parameters:
    navAction
      Endeca "NavigationAction" instance.
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="navAction" vartype="com.endeca.infront.cartridge.model.NavigationAction" param="navAction"/>

  <c:set var="tmpNavLink">
    <c:choose>
      <c:when test="${not empty navAction.contentPath}">${siteBaseURL}${navAction.contentPath}${navAction.navigationState}</c:when>
      <c:otherwise>${siteBaseURL}${navAction.navigationState}</c:otherwise>
    </c:choose>
  </c:set>

  <%-- Return the result --%>
  <dsp:getvalueof var="navLink" value="${tmpNavLink}&nav=true" scope="request"/>
</dsp:page>
