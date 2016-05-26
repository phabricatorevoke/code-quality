<%--
  PageSlot
  
  Passes the contents of the PageSlot to a renderer JSP that knows how to
  handle the contents particular type.
--%>
<dsp:page>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/> 

  <endeca:includeSlot contentItem="${contentItem}">
    <c:forEach var="element" items="${contentItem.contents}">
      <dsp:renderContentItem contentItem="${element}"/>
    </c:forEach>
  </endeca:includeSlot>

</dsp:page>
