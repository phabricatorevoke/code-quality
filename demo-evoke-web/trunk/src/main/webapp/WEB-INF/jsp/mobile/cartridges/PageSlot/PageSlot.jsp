<%--
  "PageSlot" cartridge renderer.
  Mobile version.

  Passes the contents of the "PageSlot" to a renderer JSP that knows how to
  handle the contents of particular type.
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/> 

  <c:forEach var="element" items="${contentItem.contents}">
    <dsp:renderContentItem contentItem="${element}"/>
  </c:forEach>
</dsp:page>
