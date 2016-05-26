<%--
  Page renders promotional item.
  This page expects the following parameters
  
  Required Parameters:
    product
      the product repository item to display
    imagesize (optional)
      the size of image to render (thumbnail, promo or medium)
      default is promo.

  Optional Parameters:
    None   
--%>

<dsp:page>
  
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/dynamo/droplet/Compare"/>  
  
  <dsp:getvalueof var="categoryId" param="product.parentCategory.id"/>
     
  <%-- Generate the siteLinkURL link to the product --%>
  <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
    <dsp:param name="product" param="product"/>
    <dsp:param name="categoryId" value="${categoryId}"/>
  </dsp:include>
   
  <dsp:getvalueof var="pageUrl" value="${siteLinkUrl}"/>
  <dsp:getvalueof var="siteId" param="siteId"/>
  
  <dsp:getvalueof var="item" param="product"/> 
  <preview:repositoryItem item="${item}">
    <%-- Select image to display --%>
    <dsp:a href="${pageUrl}">
        <span class="atg_store_productImage">      
        <dsp:getvalueof var="imagesize" param="imagesize"/>
        <c:choose>
          <c:when test="${imagesize == 'thumbnail'}">
            <dsp:include page="/browse/gadgets/productImg.jsp">
              <dsp:param name="image" param="product.smallImage"/>
              <dsp:param name="product" param="product"/>
              <dsp:param name="showAsLink" value="false"/>
              <dsp:param name="defaultImageSize" value="small"/>     
            </dsp:include>
          </c:when>
          <c:when test="${imagesize == 'medium'}">
            <dsp:include page="/browse/gadgets/productImg.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="image" param="product.mediumImage"/>
              <dsp:param name="showAsLink" value="false"/>
              <dsp:param name="defaultImageSize" value="medium"/>     
            </dsp:include>
          </c:when>
        </c:choose>    
      </span>
 
      <%-- Display name --%>
      <span class="atg_store_productTitle">      
        <dsp:include page="/browse/gadgets/productName.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="categoryId" value="${categoryId }"/>
          <dsp:param name="showAsLink" value="false"/>
        </dsp:include>      
      </span>
  
      <%-- Check the size of the sku array to see how we handle things --%>
      <dsp:getvalueof var="childSKUs" param="product.childSKUs"/>
      <c:set var="totalSKUs" value="${fn:length(childSKUs)}"/>
       
      <%-- 
        Droplet for testing if the product has a single SKU
      
        Input parameters:
          obj1
            number of SKUs for the product
          obj2
            1 - minimal number of SKU for the product
          
        Open parameters:
          equal
            product has the only one SKU
          default
            product has more than one SKU           
        --%>
      <dsp:droplet name="Compare">
        <dsp:param name="obj1" value="${totalSKUs}" converter="number"/>
        <dsp:param name="obj2" value="1" converter="number"/>
        <dsp:oparam name="equal">  
          <%-- Display Price --%>
          <span class="atg_store_productPrice">            
            <dsp:include page="/global/gadgets/priceLookup.jsp">
              <dsp:param name="product" param="product"/>
              <dsp:param name="sku" param="product.childSKUs[0]"/>
            </dsp:include>            
          </span>                         
        </dsp:oparam>            
        <dsp:oparam name="default">          
          <%-- Display Price Range (and Get Details link)--%>          
          <span class="atg_store_productPrice">            
            <dsp:include page="/global/gadgets/priceRange.jsp">
              <dsp:param name="product" param="product"/>
            </dsp:include>            
          </span>            
        </dsp:oparam>
      </dsp:droplet> 
                   
      <dsp:include page="/global/gadgets/siteIndicator.jsp">
        <dsp:param name="mode" value="name"/>              
        <dsp:param name="product" param="product"/>
        <dsp:param name="displayCurrentSite" value="false"/>
        <dsp:param name="siteId" value="${siteId}"/>
      </dsp:include>
    </dsp:a>
  </preview:repositoryItem> 
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/global/gadgets/promotedProductRenderer.jsp#1 $$Change: 713790 $--%>
