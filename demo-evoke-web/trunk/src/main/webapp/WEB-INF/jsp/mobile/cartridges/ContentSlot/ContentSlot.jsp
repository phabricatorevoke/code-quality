<%--
  This renderer calls the "dsp:renderContentItem" for it's contents.
  Mobile version.

  Required Parameters:
    contentItem
      The page slot content item to render.
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>

  <c:forEach var="element" items="${contentItem.contents}">
    <dsp:renderContentItem contentItem="${element}"/>
  </c:forEach>
</dsp:page>
