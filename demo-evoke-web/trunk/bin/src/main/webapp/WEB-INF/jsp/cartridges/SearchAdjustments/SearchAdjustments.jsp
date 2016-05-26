<%--
  ~ Copyright 2001, 2012, Oracle and/or its affiliates. All rights reserved.
  ~ Oracle and Java are registered trademarks of Oracle and/or its
  ~ affiliates. Other names may be trademarks of their respective owners.
  ~ UNIX is a registered trademark of The Open Group.

 
  This page lays out the elements that make up a two column page.
    
  Required Parameters:
    contentItem
      The two column page content item to render.
   
  Optional Parameters:

--%>
<dsp:page>

  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/> 

<c:if test="${not empty contentItem.originalTerms}">
    <div class="SearchAdjustments">
        <div>
             <c:forEach var="originalTerm" items="${contentItem.originalTerms}" varStatus="status">
                 <c:if test="${not empty contentItem.adjustedSearches[originalTerm]}">
                     Your search for <span style="font-weight: bold;">${originalTerm}</span> was adjusted to
                     <c:forEach var="adjustment" items="${contentItem.adjustedSearches[originalTerm]}" varStatus="status">
                         <span class="autoCorrect">${adjustment.adjustedTerms}</span>
                         <c:if test="${!status.last}">, </c:if>
                     </c:forEach>
                     <br>
                 </c:if>
                 <c:if test="${not empty contentItem.suggestedSearches[originalTerm]}">
                     Did you mean
                     <c:forEach var="suggestion" items="${contentItem.suggestedSearches[originalTerm]}" varStatus="status">
                         <c:set var="label">
                             ${suggestion.label}
                             <c:if test="${not empty suggestion.count}">
                                 (${suggestion.count} results)
                             </c:if>
                         </c:set>
                         <c:if test="${!status.last}">, </c:if>
                     </c:forEach>?
                     <br>
                 </c:if>
             </c:forEach>
        </div>
    </div>
</c:if>

</dsp:page>