<%-- 
  Gadget for showing user related promotional content as well as global promotional content.
  
  Includes pricePromos.jsp for rendering User specific promotional content.
  Includes linkedImageText.jsp for rendering Global promotional content.

  Required Parameters:
   divId
    The divId to be used.
  
  Optional Parameters:
    headerKey
      The key to the resource used for the header.
  --%>
<dsp:page>

  <dsp:importbean bean="/atg/store/pricing/PromotionFilter"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/targeting/TargetingArray"/>
  <dsp:importbean bean="/atg/targeting/TargetingForEach"/>

  <dsp:getvalueof var="divId" vartype="java.lang.String" param="divId"/>
  <dsp:getvalueof var="headerKey" vartype="java.lang.String" param="headerKey"/>
  
  <c:set var="counterloop" value="0" />
  <c:set var="numberOfColumns" value="2" />
  
  <div id="${divId}">
  
    <dsp:getvalueof var="allPromotions" vartype="java.lang.Object" bean="PromotionFilter.siteGroupPromotions"/>
    
    <c:choose>
      <c:when test="${empty allPromotions}">
        <dsp:getvalueof var="size" vartype="java.lang.Integer" value="0"/>
      </c:when>
      <c:otherwise>
        <dsp:getvalueof var="size" vartype="java.lang.Integer" value="${fn:length(allPromotions)}"/>
        
        <c:if test="${!empty headerKey}">
          <h3>
            <fmt:message key="${headerKey}"/>
          </h3>
        </c:if>
        
        <ul>
        
        <c:forEach var="allPromotion" items="${allPromotions}" varStatus="allPromotionStatus">
          <c:set var="counterloop" value="${counterloop+1}" />
          
          <dsp:getvalueof id="count" value="${allPromotionStatus.count}"/>
          <dsp:param name="allPromotion" value="${allPromotion}"/>
          
          <c:if test="${counterloop % numberOfColumns == 0}">
            <li class="atg_store_promo lastCol">
          </c:if>
          
          <c:if test="${counterloop % numberOfColumns != 0}">
            <li class="atg_store_promo">
          </c:if>

          <dsp:getvalueof var="media" param="allPromotion.media"/>
          
          <c:if test="${not empty media}">
            <dsp:getvalueof id="promotionDisplayName" idtype="java.lang.String" param="allPromotion.displayName" />
            
            <c:set var="promotionDisplayName">
              <c:out value="${promotionDisplayName}" escapeXml="true"/>
            </c:set>
             
            <%-- Image URL --%>
            <dsp:getvalueof var="imageURL" vartype="String" param="allPromotion.media.large.url"/>
           
            <%-- Current site base URL --%>
            <dsp:getvalueof var="currentSiteId" bean="Site.id" />
           
            <%-- Current site Target Link URL --%>
            <dsp:getvalueof var="targetLinkURL" 
                            vartype="String" 
                            param="allPromotion.media.${currentSiteId}.url"/>
           
            <c:choose>
              <c:when test="${empty targetLinkURL}">
                <%-- default Target Link URL --%>
                <dsp:getvalueof var="targetLinkURL" 
                                vartype="String" 
                                param="allPromotion.media.targetLink.url"/>
              </c:when>
            </c:choose>
                         
          </c:if>
              
          <c:choose>
            <c:when test="${not empty targetLinkURL}">
              <dsp:a href="${targetLinkURL}">
                <c:if test="${not empty imageURL}">                
                  <img src="${imageURL}" alt="${promotionDisplayName}" />
                </c:if>

                <dsp:getvalueof id="description" param="allPromotion.description"/>
                
                <c:if test="${not empty description}">              
                  <span class="atg_store_promoCopy">
                    <dsp:valueof value="${description}" valueishtml="true"/>
                  </span>
                </c:if>
              
              </dsp:a>
            </c:when>
            <c:otherwise>
              
              <c:if test="${not empty imageURL}">                
                <img src="${imageURL}" alt="${promotionDisplayName}" />
              </c:if>
            
              <dsp:getvalueof id="description" param="allPromotion.description"/>
              
              <c:if test="${not empty description}">
                <span class="atg_store_promoCopy">
                  <dsp:valueof value="${description}" valueishtml="true"/>
                </span>
              </c:if>
            
            </c:otherwise>
          </c:choose>
          
          </li>
          
          <c:if test="${counterloop % numberOfColumns == 0 && count != size}">
            <c:set var="counterloop" value="0" />
          </c:if>
        
        </c:forEach>
      </c:otherwise>
    </c:choose>

  </div>
 
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/global/gadgets/promotions.jsp#1 $$Change: 713790 $--%>