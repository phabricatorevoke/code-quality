<%--
  This gadget displays hero image for the given category and promotional content for 
  this category.  
  
  Required parameters:       
    category
      Category repository item for which feature promotions are to be displayed
      
  Optional parameters:
    None.      
 --%>
<dsp:page>

  <%-- Display the category feature promotion if it exists --%>
  <dsp:getvalueof var="categoryFeature" param="category.feature" />
  <c:if test="${not empty categoryFeature}">
    <dsp:getvalueof var="templateUrl" param="category.feature.template.url" />
    
    <c:if test="${not empty templateUrl}">
      <dsp:getvalueof var="pageurl" vartype="java.lang.String"
                      param="category.feature.template.url">
        <dsp:include page="${pageurl}">
          <dsp:param name="promotionalContent" param="category.feature" />
          <dsp:param name="imageHeight" value="134" />
          <dsp:param name="imageWidth" value="752" />
        </dsp:include>
      </dsp:getvalueof>
    </c:if>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/browse/gadgets/categoryPromotions.jsp#1 $$Change: 713790 $--%>
