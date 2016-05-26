<%--
  Abandoned order promotion email template. The template contains abandoned order promotional
  content with description.
  
  Required parameters:
    None. 
      
  Optional parameters:
    locale
      Locale that specifies in which language email should be rendered.
 --%>
<dsp:page>
	

	<dsp:importbean bean="/atg/dynamo/droplet/multisite/PairedSiteDroplet"/>
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/multisite/Site" />
	<dsp:importbean
		bean="/atg/registry/RepositoryTargeters/ProductCatalog/AbandonedOrderPromotion" />
	<dsp:importbean bean="/atg/targeting/TargetingFirst" />
	<dsp:importbean bean="/atg/dynamo/droplet/multisite/SiteLinkDroplet"/>
				 
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/commerce/promotion/GiftWithPurchaseSelectionsDroplet"/>
	<dsp:importbean bean="/atg/dynamo/droplet/multisite/CartSharingSitesDroplet" />

	<dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet" />
	<dsp:importbean bean="/atg/commerce/multisite/SiteIdForCatalogItem"/>
	<dsp:importbean bean="/atg/store/StoreConfiguration" />
	<dsp:importbean bean="/atg/dynamo/droplet/Cache"/>
	<dsp:importbean bean="/atg/core/i18n/LocaleTools"/>
	<dsp:importbean bean="/atg/store/droplet/SkuAvailabilityLookup"/>
	<dsp:importbean bean="/atg/commerce/pricing/UnitPriceDetailDroplet"/>
  	<dsp:importbean bean="/atg/commerce/promotion/PromotionLookup"/>
	
	<dsp:getvalueof var="commerceItemCount" bean="ShoppingCart.current.CommerceItemCount"/>
	<%-- Get sender email address for promotional emails from site configuration.  --%>
	<dsp:getvalueof var="promotionFromAddress"
		bean="Site.promotionEmailAddress" />

	<%-- Email subject --%>
	<fmt:message var="emailSubject"
		key="emailtemplates_abandonedOrderPromo.subject">
		<fmt:param>
			<dsp:valueof bean="Site.name" />
		</fmt:param>
	</fmt:message>

	<crs:emailPageContainer divId="atg_store_abandonedOrderPromoIntro"
		messageSubjectString="${emailSubject}"
		messageFromAddressString="${promotionFromAddress}">
		<jsp:body>
      <%-- Get URL prefix built by emailPageContainer tag--%>
      <dsp:getvalueof var="httpServer" param="httpServer" />

      <table border="0" cellpadding="0" cellspacing="0" width="609"
				style="font-size: 14px; margin-top: 0px; margin-bottom: 30px"
				summary="" role="presentation">
        <tr>
          <%-- Email content. --%>
          <td
						style="color: #666; font-family: Tahoma, Arial, sans-serif;">
            <fmt:message
						key="emailtemplates_abandonedOrderPromo.greeting">
              <fmt:param>
                <dsp:valueof bean="Profile.firstName" />
              </fmt:param>
            </fmt:message>
  
            <br /><br />
            <fmt:message
						key="emailtemplates_abandonedOrderPromo.discountOnNextOrder">
              <fmt:param>
                <dsp:valueof bean="Site.name" />
              </fmt:param>
            </fmt:message>
            <br /><br />
            <dsp:droplet name="TargetingFirst">
              <dsp:param name="fireViewItemEvent" value="false"/>
              <dsp:param name="targeter" bean="AbandonedOrderPromotion"/>
              <dsp:oparam name="output">
                <dsp:getvalueof var="promotionBanner" param="element.derivedImage"/>
                <dsp:getvalueof var="promotionDisplayName" param="element.displayName"/>
                
                  <dsp:param name="path" value="/index.jsp"/>
                  <dsp:param name="locale" param="locale"/>
                  <dsp:param name="httpServer" value="${httpServer}"/>
                  <dsp:param name="imageUrl" value="${httpServer}${promotionBanner}"/>
                  <dsp:param name="imageAltText" value="${promotionDisplayName}"/>
                <%-- start included /emailtemplates/gadgets/emailSiteLinkDisplay.jsp --%>
				<dsp:getvalueof var="linkStyle" param="linkStyle"/>
				  <dsp:getvalueof var="linkText" param="linkText"/>
				  <dsp:getvalueof var="linkTitle" param="linkTitle"/>
				  <dsp:getvalueof var="imageUrl" param="imageUrl"/>
				  <dsp:getvalueof var="imageTitle" param="imageTitle"/>
				  <dsp:getvalueof var="imageAltText" param="imageAltText"/>
				  
				  <%-- This gadget generate fully-qualified site-specific URL and stores it into 'siteLinkUrl' variable. --%>
				  
					<dsp:param name="path" param="path"/>
					<dsp:param name="locale" param="locale"/>
					<dsp:param name="httpServer" param="httpServer"/>
					<dsp:param name="queryParams" param="queryParams"/>
				 
				  <%-- start included /emailtemplates/gadgets/emailSiteLink.jsp --%>
				  

				  <dsp:getvalueof var="httpServer" param="httpServer"/>
				  <dsp:getvalueof var="locale" param="locale"/>

				  
					<dsp:param name="siteId" bean="Site.id"/>
					<dsp:param name="customUrl" param="path"/>
					<dsp:param name="queryParams" param="queryParams"/>
					<dsp:param name="forceFullSite" value="${true}"/>
				 
				  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>

				  <dsp:getvalueof var="product" param="product"/>
				  <dsp:getvalueof var="siteId" param="siteId"/>
				  <dsp:getvalueof var="customUrl" param="customUrl"/>
				  <dsp:getvalueof var="queryParams" param="queryParams"/>
				  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

				  <%-- Determine the URL to update --%>
				  <c:choose>
					<c:when test="${empty customUrl && empty product}">
					  <dsp:getvalueof var="urlToUpdate" value=""/>
					</c:when>
					<c:when test="${empty customUrl && !empty product}">
					  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
					</c:when>
					<c:otherwise>  
					  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
					</c:otherwise>
				  </c:choose>

				  <%-- If we have no siteId passed in determine the siteId from the product --%>
				  <c:if test="${empty siteId && !empty product}">
					<%--
					  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

					  Input Parameters:
						item
						  The item that the site selection is going to be based on.

					  Open Parameters:
						output
						  Rendered if no errors occur.

					  Output Parameters:
						siteId
						  The calculated siteId, which represents the best match for the given item.
					--%>
					<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
					  <dsp:oparam name="output">
						<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
					  </dsp:oparam>
					</dsp:droplet>
				  </c:if>

				  <c:if test="${!empty forceFullSite && !empty siteId}">
					<dsp:droplet name="GetSiteDroplet">
					  <dsp:param name="siteId" value="${siteId}"/>
					  <dsp:oparam name="output">
						<dsp:getvalueof var="site" param="site"/>
						<c:if test="${site.channel != 'desktop'}">
						  <%--
							"PairedSiteDroplet" gets a paired site ID for given site.

							Input Parameters:
							  siteId
								The site to get a paired site for.

							Open Parameters:
							  output
								Rendered if no errors occur.

							Output Parameters:
							  pairedSiteId
								Paired site ID.
						  --%>
						  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
							<dsp:oparam name="output">
							  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
							</dsp:oparam>
						  </dsp:droplet>
						</c:if>
					  </dsp:oparam>
					</dsp:droplet>
				  </c:if>

				  <%--
					"SiteLinkDroplet" gets the URL for a particular site.

					Input Parameters:
					  siteId
						The site to render the site link for.
					  path
						An optional path string that will be included in the returned URL.
					  queryParams
						Optional URL parameters.

					Open Parameters:
					  output
						Rendered if no errors occur.

					Output Parameters:
					  url
						The url for the site.
				  --%>
				  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
							   queryParams="${queryParams}" var="siteLink">
					<dsp:oparam name="output">
					  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/crossSiteLinkGenerator.jsp --%>

				  <%-- Build fully-qualified site-specific URL with locale parameter included --%>
				  <c:url var="siteLinkUrl" value="${httpServer}${siteLinkUrl}" scope="request">
					<c:if test="${not empty locale}">
					  <c:param name="locale">${locale}</c:param>
					</c:if>
				  </c:url>
				  <%-- end included /emailtemplates/gadgets/emailSiteLink.jsp --%>
				  
				  <dsp:a href="${siteLinkUrl}" style="${linkStyle}">
					<c:choose>
					  <c:when test="${not empty imageUrl}">
						<img src="${imageUrl}" border="0" title="${imageTitle}" alt="${imageAltText}" style="max-width:171px;max-height:68px;">
						<c:if test="${not empty linkText}" >
						  <span>${linkText}</span>
						</c:if>
					  </c:when>
					  <c:otherwise>
						${linkText}
					  </c:otherwise>
					</c:choose>
				  </dsp:a>
				<%-- end included /emailtemplates/gadgets/emailSiteLinkDisplay.jsp --%>
              </dsp:oparam>
            </dsp:droplet>
            
  
          </td>
        </tr>
      </table>
	  <dsp:form>
	  <dsp:droplet name="CartSharingSitesDroplet">
      <dsp:param name="excludeInputSite" value="true"/>
      <dsp:oparam name="output">
        <c:set var="currentSiteSharesCart" value="true"/>
      </dsp:oparam>
      <dsp:oparam name="empty">
        <c:set var="currentSiteSharesCart" value="false"/>
      </dsp:oparam>
    </dsp:droplet>
            <div id="atg_store_shoppingCart" class="atg_store_main"> 
			 <dsp:getvalueof var="items" vartype="java.lang.Object" bean="ShoppingCart.current.commerceItems"/> 
          <table summary="${cartItemsTableSummary}" id="atg_store_itemTable" cellspacing="0" cellpadding="0" border="1">
      <%-- Display the headers in the form of site, item, price, quantity, total for the items in the shopping cart --%>
      <thead>
        <tr>
          <%-- We will display site indicator only if current site shares the cart with some other site. --%>
          <c:if test="${currentSiteSharesCart == true}">
            <th class="site" scope="col"><fmt:message key="common.site"/></th>
          </c:if>
          <th class="item" colspan="2" scope="col"><fmt:message key="common.item"/></th>
          <th class="price" scope="col"><fmt:message key="common.price"/></th>
          <th class="quantity" scope="col"><fmt:message key="common.qty" /></th>
          <th class="total" scope="col"><fmt:message key="common.total"/></th>
        </tr>
      </thead>
      <tbody>
        <%-- Render each item in the shopping cart --%>
        <c:forEach var="currentItem" items="${items}" varStatus="status">
          <dsp:param name="currentItem" value="${currentItem}"/>
          <dsp:getvalueof id="count" value="${status.count}"/>
          <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType"/>
          <c:choose>
            <c:when test='${commerceItemClassType == "giftWrapCommerceItem"}'>
              <%-- 
                Filter out the giftWrapCommerceItem, but add as a hidden input so it doesn't
                get removed from the cart during Update process.
              --%>
            <input type="hidden" name="<dsp:valueof param='currentItem.id'/>" value="<dsp:valueof param='currentItem.quantity'/>">
            </c:when>
            <c:otherwise>
                <%-- 
                  Check if this item have been added as a gift. If yes, it will be associated selections
                  
                  Input Parameters:
                    order
                      current order from the cart
                    item
                      commerce item to check
                      
                  Output Parameters:
                    selections
                      collection of Selection beans with gift information   
                      
                  Open Parameters:
                    output
                      in case commerce item has been added as a gift or re-priced
                      
                    empty
                      regular commerce item      
                --%> 
                <dsp:droplet name="GiftWithPurchaseSelectionsDroplet">
                  <dsp:param name="order" bean="ShoppingCart.current"/>
                  <dsp:param name="item" param="currentItem" />

                  <%-- This commerce item have been added by GWP --%>
                  <!-- <dsp:oparam name="output">
                  
                    <dsp:getvalueof var="commerceItemQty" param='currentItem.quantity'/>
                    
                    <dsp:getvalueof var="selections" param="selections" />
                    
                    <c:forEach var="selection" items="${selections}">
                      <dsp:param name="selection" value="${selection}" />
                      <c:set var="gwpCount" value="0"/> -->
                      
                     <%-- 
                      Even in case this item has been added as a gift, there is also a possibility
                      the Shopper added the same item(s). Check selection quantity vs commerce item
                      quantity. If commerce item quantity is greater, that means we have gift items
                      and commerce items. Display additional row as we do for regular commerce items.
                     --%>
                      <!-- <dsp:getvalueof var="automaticQuantity" param="selection.automaticQuantity"/>
                      <dsp:getvalueof var="targetedQuantity" param="selection.targetedQuantity"/>
                      <dsp:getvalueof var="selectedQuantity" param="selection.selectedQuantity"/>
                     
                     
                     <dsp:getvalueof var="selectedQty" value="${automaticQuantity + targetedQuantity + selectedQuantity}"/>
                     
                     <c:if test="${commerceItemQty > selectedQty}">
                       <dsp:getvalueof var="missedQty" value="${commerceItemQty - selectedQty }"/>
                       <c:set var="gwpCount" value="${gwpCount + 1}"/>
                       
                       <tr class="<crs:listClass count="${count}" size="${fn:length(items)}" selected="false"/>"> -->
                          <%-- Display site indicator only if current site shares the cart with some other site. --%>
                          <!-- <c:if test="${currentSiteSharesCart == true}"> -->
                            <%-- Visual indication of the site that the product belongs to. --%>
                            <!-- <td class="site">
                              <dsp:include page="/global/gadgets/siteIndicator.jsp">
                                <dsp:param name="mode" value="icon"/>
                                <dsp:param name="siteId" param="currentItem.auxiliaryData.siteId"/>
                                <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
                              </dsp:include>
                            </td>
                          </c:if>
                          
                          <td class="image">
                            <dsp:include page="/cart/gadgets/cartItemImage.jsp">
                              <dsp:param name="commerceItem" param="currentItem"/>
                            </dsp:include>
                          </td>
                           
                          <dsp:getvalueof var="productDisplayName" param="currentItem.auxiliaryData.catalogRef.displayName"/>
                          <c:if test="${empty productDisplayName}">
                            <dsp:getvalueof var="productDisplayName" param="currentItem.auxiliaryData.productRef.displayName"/>
                            <c:if test="${empty productDisplayName}">
                              <fmt:message var="productDisplayName" key="common.noDisplayName" />
                            </c:if> 
                          </c:if>  
                           
                            
                          <td class="item" scope="row" abbr="${productDisplayName}"> -->
                            <%-- Link back to the product detail page. --%>
                           <!--  <dsp:getvalueof var="url" vartype="java.lang.Object" param="currentItem.auxiliaryData.productRef.template.url"/>
                            <c:choose>
                              <c:when test="${not empty url}">
                                <dsp:include page="/global/gadgets/crossSiteLink.jsp">
                                  <dsp:param name="item" param="currentItem"/>
                                  <dsp:param name="skuDisplayName" param="currentItem.auxiliaryData.catalogRef.displayName"/>
                                </dsp:include>
                              </c:when>
                              <c:otherwise>
                                <dsp:valueof value="${productDisplayName}"/>
                              </c:otherwise>
                            </c:choose> -->
          
                            <%-- Render all SKU-specific properties for the current item. --%>
                            <!-- <dsp:include page="/global/util/displaySkuProperties.jsp">
                              <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
                              <dsp:param name="sku" param="currentItem.auxiliaryData.catalogRef"/>
                              <dsp:param name="displayAvailabilityMessage" value="true"/>
                            </dsp:include>
                          </td> -->
          
                          <%-- Display all necessary buttons for the current item. --%>
                         <!--  <td class="cartActions">
                            
                          </td>
          
                          <td class="price">
                            <dsp:include page="/cart/gadgets/detailedItemPrice.jsp">
                              <dsp:param name="excludeModelId" param="selection.promotionId"/>
                            </dsp:include>
                          </td>
          
                          <td class="quantity">                                                
                            <%-- Don't allow user to modify samples or collateral in cart. --%>
                           <dsp:valueof value='${missedQty}'/>
                          </td>
          
                          <td class="total">
                            <dsp:getvalueof var="amount" vartype="java.lang.Double" param="currentItem.priceInfo.amount"/>
                            <dsp:getvalueof var="currencyCode" vartype="java.lang.String"
                                            bean="ShoppingCart.current.priceInfo.currencyCode"/>
                            <dsp:include page="/global/gadgets/formattedPrice.jsp">
                              <dsp:param name="price" value="${amount}"/>
                            </dsp:include>
                          </td>
                        </tr>
                       
                     </c:if> -->
                      
                      <%-- 
                        Process selections that have been added automatically, i.e.
                        items auto added as gifts and re-priced as free 
                       --%>
                      
                      <!-- <c:forEach begin="1" end="${automaticQuantity}">
                        <c:set var="gwpCount" value="${gwpCount + 1}"/>
                        <dsp:include page="/cart/gadgets/giftItem.jsp">
                          <dsp:param name="selection" param="selection"/>
                          <dsp:param name="currentItem" param="currentItem"/>
                          <dsp:param name="count" value="${count}"/>
                          <dsp:param name="gwpCount" value="${gwpCount}"/>
                          <dsp:param name="currentSiteSharesCart" value="${currentSiteSharesCart}"/>
                        </dsp:include>                        
                      </c:forEach> -->
                      
                      <%-- 
                        Process selections that have been targeted, i.e.
                        items added as regular commerce items but re-priced as free
                        gifts. 
                       --%>
                     <!--  <c:forEach begin="1" end="${targetedQuantity}">
                        <c:set var="gwpCount" value="${gwpCount + 1}"/>
                        <dsp:include page="/cart/gadgets/giftItem.jsp">
                          <dsp:param name="selection" param="selection"/>
                          <dsp:param name="currentItem" param="currentItem"/>
                          <dsp:param name="count" value="${count}"/>
                          <dsp:param name="gwpCount" value="${gwpCount}"/>
                          <dsp:param name="currentSiteSharesCart" value="${currentSiteSharesCart}"/>
                        </dsp:include>                        
                      </c:forEach> -->
                      
                      <%--
                        Selected quantity for the gift commerce item could be more than 1. This situation could occur if
                        the shopper selected several identical gifts. That means we'll have 1 commerce item with quantity > 1,
                        but we'd like to display one gift item per line, so we will display several identical gift items
                        in the shopping cart.
                      --%>   
                     <!--  <c:forEach begin="1" end="${selectedQuantity}">
                        <c:set var="gwpCount" value="${gwpCount + 1}"/>
                        <dsp:include page="/cart/gadgets/giftItem.jsp">
                          <dsp:param name="selection" param="selection"/>
                          <dsp:param name="currentItem" param="currentItem"/>
                          <dsp:param name="count" value="${count}"/>
                          <dsp:param name="gwpCount" value="${gwpCount}"/>
                          <dsp:param name="currentSiteSharesCart" value="${currentSiteSharesCart}"/>
                        </dsp:include>
                      </c:forEach>                    
  
                    </c:forEach>
                  </dsp:oparam> -->
                  
                  <%-- This is regular commerce item --%>
                  <dsp:oparam name="empty">
                  
                    <tr class="<crs:listClass count="${count}" size="${fn:length(items)}" selected="false"/>">
                      <%-- Display site indicator only if current site shares the cart with some other site. --%>
                      <c:if test="${currentSiteSharesCart == true}">
                        <%-- Visual indication of the site that the product belongs to. --%>
                        <td class="site">
                          
					
					  <%--
						Obtain the page parameter values, if necessary setting any default values
						for any optional parameters.
					  --%>
						<%-- included /global/gadgets/siteIndicator.jsp --%>
						  <dsp:getvalueof var="mode" value="icon"/>
						  <dsp:param name="siteId" param="currentItem.auxiliaryData.siteId"/>
						  <dsp:getvalueof var="product" param="currentItem.auxiliaryData.productRef"/>
						  <dsp:getvalueof var="path" param="path"/>
						  <dsp:getvalueof var="queryParams" param="queryParams"/>

						  <dsp:getvalueof var="asLink" param="asLink"/>
						  <c:if test="${empty asLink}">
							<dsp:getvalueof var="asLink" value="false"/>
						  </c:if>

						  <dsp:getvalueof var="absoluteResourcePath" param="absoluteResourcePath"/>
						  <c:if test="${empty absoluteResourcePath}">
							<dsp:getvalueof var="absoluteResourcePath" value="false"/>
						  </c:if>

						  <dsp:getvalueof var="displayCurrentSite" param="displayCurrentSite"/>
						  <c:if test="${empty displayCurrentSite}">
							<dsp:getvalueof var="displayCurrentSite" value="true"/>
						  </c:if>

						  <dsp:getvalueof var="currentSiteId" bean="Site.id"/>
						  
						  <%--
							Determine the appropriate site id to use.
							If there is no specified site id or product, the site id for the current site is used.
							If there is a product but no site id then find most appropriate site id for the product.
							Otherwise a site id has been specified and we use this in preference.
						  --%>
						  <c:choose>
							<c:when test="${empty siteId && empty product}">
							 <dsp:getvalueof var="siteId" value="${currentSiteId}"/>
							</c:when>
							<c:when test="${empty siteId && !empty product}">
							  <%--
								The SiteIdForItemDroplet will return the most appropriate site id for a given 
								repository item. In this instance we pass in the product repository item and
								obtain its siteId if there is no specified siteId and we have a product.
								
								Input Parameters:
								  item - The repository item used to obtain the site id
								  
								Open Parameters:
								  output - Rendered if there are no errors
								  
								Output Parameters:
								  siteId - The most appropriate siteId for the 'item' repository item
							  --%>
							  <dsp:droplet name="SiteIdForCatalogItem">
								<dsp:param name="item" value="${product}"/>
								<dsp:oparam name="output">
								  <dsp:getvalueof var="siteId" param="siteId"/>
								</dsp:oparam>
							  </dsp:droplet>
							</c:when>
							<c:otherwise>
							  <%-- A 'siteId' page parameter was received, so for clarity obtain this value again. --%>
							 <dsp:getvalueof var="siteId" param="siteId"/>
							</c:otherwise>
						  </c:choose>

						  <%--
							Only display the site indicator if the site id is not the current site or if 
							we are forcing this to be displayed.
						  --%>
						  <c:if test="${(siteId != currentSiteId) || displayCurrentSite}">
							<%-- 
							  GetSiteDroplet is used to get a Site object for a given siteId. In this instance
							  its used to retrieve the site details (name, icon) for the site with this site id.
							  
							  Input Parameters:
								siteId - A site id
								
							  Open Parameters:
								output - Rendered once if the site is found
								
							  Output Parameters:
								site - The Site object representing siteId
							--%>
							<dsp:droplet name="GetSiteDroplet">
							  <dsp:param name="siteId" value="${siteId}"/>
							  <dsp:oparam name="output">

								 <dsp:getvalueof var="siteName" param="site.name"/>
								<dsp:getvalueof var="siteIcon" param="site.siteIcon"/>
							  </dsp:oparam>
							</dsp:droplet>
						  
							<%--
							  Construct the appropriate cross site link if the site indicator is to be backed by
							  a link reference.
							--%>
							<!-- <dsp:getvalueof var="linkUrl" value=""/>
							<c:if test="${asLink}">
							  <c:choose>
								<c:when test="${!empty product}"> -->
								  <%--
									Obtain the cross site link for the site id and product.
									If a custom url has been supplied then use that as a basis for generating the link,
									otherwise generate the most appropriate link based on the site id and product. 
								  --%>
								 <!--  <c:choose>
									<c:when test="${!empty path}">
									  <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
										<dsp:param name="siteId" value="${siteId}"/>
										<dsp:param name="product" value="${product}"/>
										<dsp:param name="customUrl" value="${path}"/>
										<dsp:param name="queryParams" value="${queryParams}"/>
									  </dsp:include>

									  <dsp:getvalueof var="linkUrl" value="${siteLinkUrl}"/>
									</c:when>
									<c:otherwise>
									  <dsp:include page="/global/gadgets/productLinkGenerator.jsp">
										<dsp:param name="siteId" value="${siteId}"/>
										<dsp:param name="product" value="${product}"/>
									  </dsp:include>

									  <dsp:getvalueof var="linkUrl" value="${productUrl}"/>
								   </c:otherwise>
								  </c:choose>
								</c:when>
								<c:otherwise> -->
								  <%-- 
									Obtain the link to the site with the specified site id.
									Simply link to the site's home page if no custom url has been supplied.
								  --%>
								 <!--  <c:if test="${empty path}">
									<dsp:getvalueof var="path" value="/"/>
								  </c:if>

								  <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
									<dsp:param name="siteId" value="${siteId}"/>
									<dsp:param name="customUrl" value="${path}"/>
									<dsp:param name="queryParams" value="${queryParams}"/>
								  </dsp:include>

								  <dsp:getvalueof var="linkUrl" value="${siteLinkUrl}"/>
								</c:otherwise>
							  </c:choose>
							</c:if> -->

							<%--
							  If required construct the full absolute server path for resources.
							--%>
							<dsp:getvalueof var="httpServer" value=""/>
							<c:if test="${absoluteResourcePath}">
							  <dsp:getvalueof var="serverName" bean="StoreConfiguration.siteHttpServerName" />
							  <dsp:getvalueof var="serverPort" bean="StoreConfiguration.siteHttpServerPort" />
							  <dsp:getvalueof var="httpServer" value="http://${serverName}:${serverPort}" />
							</c:if>

							<%--
							  Display the site indicator either as the site icon or the site name according to the 'mode'
							  parameter value. The site indicator will be rendered backed with a link reference if 'asLink'
							  is true.
							--%>
							<c:choose>
							  <c:when test="${mode == 'icon'}">
								<%-- 
								  Display the icon configured on the site as the site indicator.
								  'httpServer' will be populated only if 'absoluteResourcePath' is true; otherwise it 
								  will be empty string. 
								--%>
								<c:choose>
								  <c:when test="${asLink}">
									<dsp:a href="${linkUrl}">
									  <dsp:img src="${httpServer}${siteIcon}"/>
									</dsp:a>
								  </c:when>
								  <c:otherwise>
									<dsp:img src="${httpServer}${siteIcon}" alt="${siteName}"/>
								  </c:otherwise>
								</c:choose>
							  </c:when>
							  <c:when test="${mode == 'name'}">
								<%-- Display the site name as the site indicator. --%>
								<fmt:message key="siteindicator.prefix" var="sitePrefix"/>
								<span class="siteIndicator">
								  <c:choose>
									<c:when test="${asLink}">
									  <dsp:a href="${linkUrl}">
										<dsp:valueof value="${sitePrefix}"/>
										<span><c:out value="${siteName}"/></span>
									  </dsp:a>
									</c:when>
									<c:otherwise>
									  <dsp:valueof value="${sitePrefix}"/>
									  <span> <c:out value="${siteName}"/></span>
									</c:otherwise>
								  </c:choose>
								</span>
							  </c:when>
							  <c:otherwise>
								<%-- Fail silently as we have an invalid display mode. --%>
							  </c:otherwise>
							</c:choose>
						  </c:if>
						   <%-- end included /global/gadgets/siteIndicator.jsp --%>
                        </td>
                      </c:if>
                      
                      <td class="image">
					   <dsp:param name="commerceItem" param="currentItem"/>
					  <dsp:getvalueof var="linkImage" vartype="java.lang.String" param="displayAsLink"/>
					  <c:if test="${empty linkImage}">
						<c:set var="linkImage" value="true"/>
					  </c:if>
					  <dsp:getvalueof var="imageUrl" param="commerceItem.auxiliaryData.catalogRef.smallImage.url"/>

					  <c:choose>
						<c:when test="${not empty imageUrl}">
						<dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
						<dsp:param name="alternateImage" param="commerceItem.auxiliaryData.catalogRef.smallImage"/>
						<%--  included /browse/gadgets/productImgCart.jsp --%>
						<dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/>
						  <dsp:getvalueof var="alternateImageId" vartype="java.lang.String" 
										  param="alternateImage.repositoryId"/>
						  <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
						  <dsp:getvalueof var="httpServer" vartype="java.lang.String" param="httpServer"/>
						  <dsp:getvalueof var="linkImage" vartype="java.lang.String" param="linkImage"/>
						  <dsp:getvalueof var="commerceItemId" vartype="java.lang.String" param="commerceItem.id"/>
						  <dsp:getvalueof var="productName" vartype="java.lang.String" param="product.displayName"/>
						  <dsp:getvalueof var="siteId" vartype="java.lang.String" param="siteId"/>

						  <%-- If the productName on the product is empty use the commerceItem --%>  
						  <c:if test="${empty productName}">
							<c:set var="productName">
							  <dsp:valueof param="commerceItem.productRef.displayName"/>
							</c:set>
						  </c:if>
						  
						  <%-- 
							Generate cache keys, the cache key will be the same for all users when the placeholders in the
							key are the same (for example if its the same product, with the same alternate image, on the 
							same site..etc). The cache is a global component so all users will be able to use the cached
							value even if they werent responsible for it being placed in the cache.  
						  --%>
						  <dsp:getvalueof var="cache_key" 
										  value="bp_fpti_cart_${productId}_${alternateImageId}_${linkImage}_${httpServer}_${siteId}"/>

						  <c:if test="${not empty commerceItemId}">
							<dsp:getvalueof var="cache_key" 
											value="bp_fpti_cart_${commerceItemId}_${productId}_${alternateImageId}_${linkImage}_${httpServer}_${siteId}"/>
						  </c:if>
						  
						  <%--
							Cache is used to cache the contents of its open parameter "output". It
							improves performance for pages that generate dynamic content which is
							the same for all users.
								 
							Input Parameters:
							  key - Contains a value that uniquely identifies the content
								 
							Open Parameters:
							  output - The serviced value is cached for use next time    
						  --%> 
						  <dsp:droplet name="Cache">
							<dsp:param name="key" value="${cache_key}"/>
							<dsp:oparam name="output">  
							  <dsp:getvalueof var="alternateImageUrl" param="alternateImage.url"/>
							  
							  <c:choose>
								<%-- No alternate image passed, use the products image --%>
								<c:when test="${empty alternateImageUrl}">
								  <dsp:getvalueof var="productThumbnailImageUrl" param="product.smallImage.url"/>
								  <c:choose>
									<%-- The products smallImage is set --%>
									<c:when test="${not empty productThumbnailImageUrl}">
									  <%-- Determine if we are to link the image --%>
									  <c:choose>
										<%-- If linkImage is false only display the image  --%>
										<c:when test="${linkImage == false}">
										  <img  src="<dsp:valueof param='httpServer'/><dsp:valueof param='product.smallImage.url'/>"
												alt="${productName}"/>
										</c:when>
										<%-- If linkImage is true link the image to the product details page --%>
										<c:otherwise> 
										  <dsp:getvalueof var="productTemplateUrl" param="product.template.url"/>
										  
										  <%-- Make sure we have a template --%>
										  <c:choose>
											<%-- The product has a template URL --%>
											<c:when test="${not empty productTemplateUrl}">
											  <dsp:getvalueof var="url_part1" param="httpServer"/>
											  <dsp:getvalueof var="url_part2" param="product.smallImage.url"/>
											  
											  <%-- Build the URL --%>
											  <c:set var="imgUrl" value="${url_part1}${url_part2}"/>
											  <c:if test="${empty url_part1}">
												<c:set var="imgUrl" value="${url_part2}"/>
											  </c:if> 

											  <%-- Generate the link --%>
											  
												<dsp:param name="item" param="commerceItem"/>
												<dsp:param name="imgUrl" value="${imgUrl}"/>
											  

											  <%-- start included /global/gadgets/crossSiteLink.jsp --%>
											  <dsp:getvalueof var="missingProductSkuId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetCatalogRefs.substituteDeletedSkuId"/>

											  <dsp:getvalueof var="imgUrl" param="imgUrl"/>
											  <dsp:getvalueof var="item" param="item"/>
											  <dsp:getvalueof var="includeTitle" param="includeTitle"/>

											  <%-- Check wheter commerce item or product is passed to the gadget --%>
											  <c:choose>
												<c:when test="${not empty item}">
												  <%-- Commerce item is passed, retrieve product and site ID from it. --%>
												 
												  <%-- 
													If sku.displayName is not empty and sku is not deleted, use it displayName 
													as product display name 
												  --%>
												  <c:if test="${missingProductSkuId != item.auxiliaryData.catalogRef.repositoryId}">  
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.catalogRef.displayName"/>
												  </c:if> 
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.productRef.displayName"/>
												  </c:if>
												  
												  <dsp:getvalueof var="productId" param="item.auxiliaryData.productId"/>
												  <dsp:getvalueof var="siteId" param="item.auxiliaryData.siteId"/>

												  
													<dsp:param name="product" param="item.auxiliaryData.productRef"/>
													<dsp:param name="siteId" value="${siteId}"/>
												  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:when>
												<c:otherwise>
												  <%-- Product is passed. --%>
												  <dsp:getvalueof var="displayName" param="skuDisplayName"/>
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="product.displayName"/>
												  </c:if>              
												  <dsp:getvalueof var="productId" param="product.repositoryId"/>

												  
													  <dsp:param name="product" param="product"/>
												  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:otherwise>
											  </c:choose>

											  <dsp:getvalueof var="siteLinkUrl" param="siteLinkUrl"/>
											  <dsp:getvalueof var="httpServer" param='httpServer'/>
											  <c:choose>
												<c:when test="${empty imgUrl}">
												  <%-- Image URL is not specified, just display link --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}" iclass="atg_store_productTitle">
													<dsp:valueof value="${displayName}">
													  <fmt:message key="common.noDisplayName"/>
													</dsp:valueof>
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:when>
												<c:otherwise>
												  <%-- Image URL is specified, display link as image --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}">      
													<c:choose>
													  <c:when test="${includeTitle}">
														<img src="${imgUrl}" alt="${displayName}" title="${displayName}"/>
													  </c:when>
													  <c:otherwise>
														<img src="${imgUrl}" alt="${displayName}"/>
													  </c:otherwise>
													</c:choose>       
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:otherwise>
											  </c:choose>
											  <%-- end included /global/gadgets/crossSiteLink.jsp --%>
											</c:when>
											<%-- The product does not have a template URL just display the image --%>
											<c:otherwise>
											  <%-- The product template.url is not set --%>
											  <img src="<dsp:valueof param='httpServer'/><dsp:valueof param='product.smallImage.url'/>"
												   alt="${productName}"/>
											</c:otherwise>
										  </c:choose>
										</c:otherwise>
									  </c:choose>
									</c:when>
									<%-- The products smallImage is not set --%>
									<c:otherwise>
									  <img  height="105" width="105" src="<dsp:valueof param='httpServer'/>/crsdocroot/content/images/products/small/MissingProduct_small.jpg"
											width="85" height="85" alt="${productName}">
									</c:otherwise>
								  </c:choose>
								</c:when>
								
								<%-- We have an alternate image to display --%>
								<c:otherwise>
								  <c:choose>
									<%-- Just display the alternate image without linking it --%>
									<c:when test="${linkImage == 'false'}">
									  <img src="<dsp:valueof param='httpServer'/><dsp:valueof param='alternateImage.url'/>"
										   alt="${productName}"/>
									</c:when>
									<%-- Link the alternate image to the product detail page--%>
									<c:otherwise> 
									  <dsp:getvalueof var="templateUrl" param="product.template.url"/>
									  <c:choose>
										<%-- Product template is set --%>
										<c:when test="${not empty templateUrl}">
										  <dsp:getvalueof var="alternateImageUrl" vartype="java.lang.String" 
														  param="alternateImage.url"/>
								  
										  <%-- Make sure the httpServer is set before making the image url --%>
										  <c:choose>
											<c:when test="${empty httpServer}">
											  <dsp:getvalueof var="imageurl" vartype="java.lang.String" 
															  value="${alternateImageUrl}"/>
											</c:when>
											<c:otherwise>
											  <dsp:getvalueof var="imageurl" vartype="java.lang.String" 
															  value="${httpServer}${alternateImageUrl}"/>
											</c:otherwise>
										  </c:choose>
										  
										  <%-- Generate the link --%>
										  
										  <dsp:param name="item" param="commerceItem"/>
												<dsp:param name="imgUrl" value="${imageurl}"/>
											  

											  <%-- start included /global/gadgets/crossSiteLink.jsp --%>
											  <dsp:getvalueof var="missingProductSkuId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetCatalogRefs.substituteDeletedSkuId"/>

											  <dsp:getvalueof var="imgUrl" param="imgUrl"/>
											  <dsp:getvalueof var="item" param="item"/>
											  <dsp:getvalueof var="includeTitle" param="includeTitle"/>

											  <%-- Check wheter commerce item or product is passed to the gadget --%>
											  <c:choose>
												<c:when test="${not empty item}">
												  <%-- Commerce item is passed, retrieve product and site ID from it. --%>
												 
												  <%-- 
													If sku.displayName is not empty and sku is not deleted, use it displayName 
													as product display name 
												  --%>
												  <c:if test="${missingProductSkuId != item.auxiliaryData.catalogRef.repositoryId}">  
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.catalogRef.displayName"/>
												  </c:if> 
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.productRef.displayName"/>
												  </c:if>
												  
												  <dsp:getvalueof var="productId" param="item.auxiliaryData.productId"/>
												  <dsp:getvalueof var="siteId" param="item.auxiliaryData.siteId"/>

												 
													<dsp:param name="product" param="item.auxiliaryData.productRef"/>
													<dsp:param name="siteId" value="${siteId}"/>
												
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:when>
												<c:otherwise>
												  <%-- Product is passed. --%>
												  <dsp:getvalueof var="displayName" param="skuDisplayName"/>
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="product.displayName"/>
												  </c:if>              
												  <dsp:getvalueof var="productId" param="product.repositoryId"/>

												  
													  <dsp:param name="product" param="product"/>
												  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:otherwise>
											  </c:choose>

											  <dsp:getvalueof var="siteLinkUrl" param="siteLinkUrl"/>
											  <dsp:getvalueof var="httpServer" param='httpServer'/>
											  <c:choose>
												<c:when test="${empty imgUrl}">
												  <%-- Image URL is not specified, just display link --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}" iclass="atg_store_productTitle">
													<dsp:valueof value="${displayName}">
													  <fmt:message key="common.noDisplayName"/>
													</dsp:valueof>
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:when>
												<c:otherwise>
												  <%-- Image URL is specified, display link as image --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}">      
													<c:choose>
													  <c:when test="${includeTitle}">
														<img src="${imgUrl}" alt="${displayName}" title="${displayName}"/>
													  </c:when>
													  <c:otherwise>
														<img src="${imgUrl}" alt="${displayName}"/>
													  </c:otherwise>
													</c:choose>       
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:otherwise>
											  </c:choose>
											  <%-- end included /global/gadgets/crossSiteLink.jsp --%>
										</c:when>
										<%-- Product template not set --%>
										<c:otherwise>
										  <img src="<dsp:valueof param='httpServer'/><dsp:valueof param='alternateImage.url'/>" 
											   alt="${productName}"/>
										</c:otherwise>
									  </c:choose>
									
									</c:otherwise>
								  </c:choose>
								</c:otherwise>
							  </c:choose>
							</dsp:oparam>
						  </dsp:droplet>
						<%-- end included /browse/gadgets/productImgCart.jsp --%>

						  
						</c:when>
						<c:otherwise>
						  <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
						<%--  included /browse/gadgets/productImgCart.jsp --%>
						<dsp:getvalueof var="productId" vartype="java.lang.String" param="product.repositoryId"/>
						  <dsp:getvalueof var="alternateImageId" vartype="java.lang.String" 
										  param="alternateImage.repositoryId"/>
						  <dsp:getvalueof var="pageurl" vartype="java.lang.String" param="product.template.url"/>
						  <dsp:getvalueof var="httpServer" vartype="java.lang.String" param="httpServer"/>
						  <dsp:getvalueof var="linkImage" vartype="java.lang.String" param="linkImage"/>
						  <dsp:getvalueof var="commerceItemId" vartype="java.lang.String" param="commerceItem.id"/>
						  <dsp:getvalueof var="productName" vartype="java.lang.String" param="product.displayName"/>
						  <dsp:getvalueof var="siteId" vartype="java.lang.String" param="siteId"/>

						  <%-- If the productName on the product is empty use the commerceItem --%>  
						  <c:if test="${empty productName}">
							<c:set var="productName">
							  <dsp:valueof param="commerceItem.productRef.displayName"/>
							</c:set>
						  </c:if>
						  
						  <%-- 
							Generate cache keys, the cache key will be the same for all users when the placeholders in the
							key are the same (for example if its the same product, with the same alternate image, on the 
							same site..etc). The cache is a global component so all users will be able to use the cached
							value even if they werent responsible for it being placed in the cache.  
						  --%>
						  <dsp:getvalueof var="cache_key" 
										  value="bp_fpti_cart_${productId}_${alternateImageId}_${linkImage}_${httpServer}_${siteId}"/>

						  <c:if test="${not empty commerceItemId}">
							<dsp:getvalueof var="cache_key" 
											value="bp_fpti_cart_${commerceItemId}_${productId}_${alternateImageId}_${linkImage}_${httpServer}_${siteId}"/>
						  </c:if>
						  
						  <%--
							Cache is used to cache the contents of its open parameter "output". It
							improves performance for pages that generate dynamic content which is
							the same for all users.
								 
							Input Parameters:
							  key - Contains a value that uniquely identifies the content
								 
							Open Parameters:
							  output - The serviced value is cached for use next time    
						  --%> 
						  <dsp:droplet name="Cache">
							<dsp:param name="key" value="${cache_key}"/>
							<dsp:oparam name="output">  
							  <dsp:getvalueof var="alternateImageUrl" param="alternateImage.url"/>
							  
							  <c:choose>
								<%-- No alternate image passed, use the products image --%>
								<c:when test="${empty alternateImageUrl}">
								  <dsp:getvalueof var="productThumbnailImageUrl" param="product.smallImage.url"/>
								  <c:choose>
									<%-- The products smallImage is set --%>
									<c:when test="${not empty productThumbnailImageUrl}">
									  <%-- Determine if we are to link the image --%>
									  <c:choose>
										<%-- If linkImage is false only display the image  --%>
										<c:when test="${linkImage == false}">
										  <img  src="<dsp:valueof param='httpServer'/><dsp:valueof param='product.smallImage.url'/>"
												alt="${productName}"/>
										</c:when>
										<%-- If linkImage is true link the image to the product details page --%>
										<c:otherwise> 
										  <dsp:getvalueof var="productTemplateUrl" param="product.template.url"/>
										  
										  <%-- Make sure we have a template --%>
										  <c:choose>
											<%-- The product has a template URL --%>
											<c:when test="${not empty productTemplateUrl}">
											  <dsp:getvalueof var="url_part1" param="httpServer"/>
											  <dsp:getvalueof var="url_part2" param="product.smallImage.url"/>
											  
											  <%-- Build the URL --%>
											  <c:set var="imgUrl" value="${url_part1}${url_part2}"/>
											  <c:if test="${empty url_part1}">
												<c:set var="imgUrl" value="${url_part2}"/>
											  </c:if> 

											  <%-- Generate the link --%>
											  <dsp:param name="item" param="commerceItem"/>
												<dsp:param name="imgUrl" value="${imgUrl}"/>
											  

											  <%-- start included /global/gadgets/crossSiteLink.jsp --%>
											  <dsp:getvalueof var="missingProductSkuId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetCatalogRefs.substituteDeletedSkuId"/>

											  <dsp:getvalueof var="imgUrl" param="imgUrl"/>
											  <dsp:getvalueof var="item" param="item"/>
											  <dsp:getvalueof var="includeTitle" param="includeTitle"/>

											  <%-- Check wheter commerce item or product is passed to the gadget --%>
											  <c:choose>
												<c:when test="${not empty item}">
												  <%-- Commerce item is passed, retrieve product and site ID from it. --%>
												 
												  <%-- 
													If sku.displayName is not empty and sku is not deleted, use it displayName 
													as product display name 
												  --%>
												  <c:if test="${missingProductSkuId != item.auxiliaryData.catalogRef.repositoryId}">  
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.catalogRef.displayName"/>
												  </c:if> 
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.productRef.displayName"/>
												  </c:if>
												  
												  <dsp:getvalueof var="productId" param="item.auxiliaryData.productId"/>
												  <dsp:getvalueof var="siteId" param="item.auxiliaryData.siteId"/>

												  
													<dsp:param name="product" param="item.auxiliaryData.productRef"/>
													<dsp:param name="siteId" value="${siteId}"/>
												  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:when>
												<c:otherwise>
												  <%-- Product is passed. --%>
												  <dsp:getvalueof var="displayName" param="skuDisplayName"/>
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="product.displayName"/>
												  </c:if>              
												  <dsp:getvalueof var="productId" param="product.repositoryId"/>

												  
													  <dsp:param name="product" param="product"/>
												  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:otherwise>
											  </c:choose>

											  <dsp:getvalueof var="siteLinkUrl" param="siteLinkUrl"/>
											  <dsp:getvalueof var="httpServer" param='httpServer'/>
											  <c:choose>
												<c:when test="${empty imgUrl}">
												  <%-- Image URL is not specified, just display link --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}" iclass="atg_store_productTitle">
													<dsp:valueof value="${displayName}">
													  <fmt:message key="common.noDisplayName"/>
													</dsp:valueof>
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:when>
												<c:otherwise>
												  <%-- Image URL is specified, display link as image --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}">      
													<c:choose>
													  <c:when test="${includeTitle}">
														<img src="${imgUrl}" alt="${displayName}" title="${displayName}"/>
													  </c:when>
													  <c:otherwise>
														<img src="${imgUrl}" alt="${displayName}"/>
													  </c:otherwise>
													</c:choose>       
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:otherwise>
											  </c:choose>
											  <%-- end included /global/gadgets/crossSiteLink.jsp --%>
											</c:when>
											<%-- The product does not have a template URL just display the image --%>
											<c:otherwise>
											  <%-- The product template.url is not set --%>
											  <img src="<dsp:valueof param='httpServer'/><dsp:valueof param='product.smallImage.url'/>"
												   alt="${productName}"/>
											</c:otherwise>
										  </c:choose>
										</c:otherwise>
									  </c:choose>
									</c:when>
									<%-- The products smallImage is not set --%>
									<c:otherwise>
									  <img  height="105" width="105" src="<dsp:valueof param='httpServer'/>/crsdocroot/content/images/products/small/MissingProduct_small.jpg"
											width="85" height="85" alt="${productName}">
									</c:otherwise>
								  </c:choose>
								</c:when>
								
								<%-- We have an alternate image to display --%>
								<c:otherwise>
								  <c:choose>
									<%-- Just display the alternate image without linking it --%>
									<c:when test="${linkImage == 'false'}">
									  <img src="<dsp:valueof param='httpServer'/><dsp:valueof param='alternateImage.url'/>"
										   alt="${productName}"/>
									</c:when>
									<%-- Link the alternate image to the product detail page--%>
									<c:otherwise> 
									  <dsp:getvalueof var="templateUrl" param="product.template.url"/>
									  <c:choose>
										<%-- Product template is set --%>
										<c:when test="${not empty templateUrl}">
										  <dsp:getvalueof var="alternateImageUrl" vartype="java.lang.String" 
														  param="alternateImage.url"/>
								  
										  <%-- Make sure the httpServer is set before making the image url --%>
										  <c:choose>
											<c:when test="${empty httpServer}">
											  <dsp:getvalueof var="imageurl" vartype="java.lang.String" 
															  value="${alternateImageUrl}"/>
											</c:when>
											<c:otherwise>
											  <dsp:getvalueof var="imageurl" vartype="java.lang.String" 
															  value="${httpServer}${alternateImageUrl}"/>
											</c:otherwise>
										  </c:choose>
										  
										  <%-- Generate the link --%>
										 
										  <dsp:param name="item" param="commerceItem"/>
												<dsp:param name="imgUrl" value="${imageurl}"/>
											  

											  <%-- start included /global/gadgets/crossSiteLink.jsp --%>
											  <dsp:getvalueof var="missingProductSkuId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetCatalogRefs.substituteDeletedSkuId"/>

											  <dsp:getvalueof var="imgUrl" param="imgUrl"/>
											  <dsp:getvalueof var="item" param="item"/>
											  <dsp:getvalueof var="includeTitle" param="includeTitle"/>

											  <%-- Check wheter commerce item or product is passed to the gadget --%>
											  <c:choose>
												<c:when test="${not empty item}">
												  <%-- Commerce item is passed, retrieve product and site ID from it. --%>
												 
												  <%-- 
													If sku.displayName is not empty and sku is not deleted, use it displayName 
													as product display name 
												  --%>
												  <c:if test="${missingProductSkuId != item.auxiliaryData.catalogRef.repositoryId}">  
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.catalogRef.displayName"/>
												  </c:if> 
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="item.auxiliaryData.productRef.displayName"/>
												  </c:if>
												  
												  <dsp:getvalueof var="productId" param="item.auxiliaryData.productId"/>
												  <dsp:getvalueof var="siteId" param="item.auxiliaryData.siteId"/>

												  
													<dsp:param name="product" param="item.auxiliaryData.productRef"/>
													<dsp:param name="siteId" value="${siteId}"/>
												  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:when>
												<c:otherwise>
												  <%-- Product is passed. --%>
												  <dsp:getvalueof var="displayName" param="skuDisplayName"/>
												  <c:if test="${empty displayName}">
													<dsp:getvalueof var="displayName" param="product.displayName"/>
												  </c:if>              
												  <dsp:getvalueof var="productId" param="product.repositoryId"/>

												  
													  <dsp:param name="product" param="product"/>
													  
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												  <dsp:getvalueof var="product" param="product"/>
												  <dsp:getvalueof var="siteId" param="siteId"/>
												  <dsp:getvalueof var="customUrl" param="customUrl"/>
												  <dsp:getvalueof var="queryParams" param="queryParams"/>
												  <dsp:getvalueof var="forceFullSite" param="forceFullSite"/>

												  <%-- Determine the URL to update --%>
												  <c:choose>
													<c:when test="${empty customUrl && empty product}">
													  <dsp:getvalueof var="urlToUpdate" value=""/>
													</c:when>
													<c:when test="${empty customUrl && !empty product}">
													  <dsp:getvalueof var="urlToUpdate" param="product.template.url"/>
													</c:when>
													<c:otherwise>  
													  <dsp:getvalueof var="urlToUpdate" value="${customUrl}"/>
													</c:otherwise>
												  </c:choose>

												  <%-- If we have no siteId passed in determine the siteId from the product --%>
												  <c:if test="${empty siteId && !empty product}">
													<%--
													  "SiteIdForCatalogItem" droplet returns the most appropriate site ID a given repository item.

													  Input Parameters:
														item
														  The item that the site selection is going to be based on.

													  Open Parameters:
														output
														  Rendered if no errors occur.

													  Output Parameters:
														siteId
														  The calculated siteId, which represents the best match for the given item.
													--%>
													<dsp:droplet name="SiteIdForCatalogItem" item="${product}" var="siteIdForCatalogItem">
													  <dsp:oparam name="output">
														<dsp:getvalueof var="siteId" value="${siteIdForCatalogItem.siteId}"/>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <c:if test="${!empty forceFullSite && !empty siteId}">
													<dsp:droplet name="GetSiteDroplet">
													  <dsp:param name="siteId" value="${siteId}"/>
													  <dsp:oparam name="output">
														<dsp:getvalueof var="site" param="site"/>
														<c:if test="${site.channel != 'desktop'}">
														  <%--
															"PairedSiteDroplet" gets a paired site ID for given site.

															Input Parameters:
															  siteId
																The site to get a paired site for.

															Open Parameters:
															  output
																Rendered if no errors occur.

															Output Parameters:
															  pairedSiteId
																Paired site ID.
														  --%>
														  <dsp:droplet name="PairedSiteDroplet" siteId="${siteId}">
															<dsp:oparam name="output">
															  <dsp:getvalueof var="siteId" param="pairedSiteId"/>
															</dsp:oparam>
														  </dsp:droplet>
														</c:if>
													  </dsp:oparam>
													</dsp:droplet>
												  </c:if>

												  <%--
													"SiteLinkDroplet" gets the URL for a particular site.

													Input Parameters:
													  siteId
														The site to render the site link for.
													  path
														An optional path string that will be included in the returned URL.
													  queryParams
														Optional URL parameters.

													Open Parameters:
													  output
														Rendered if no errors occur.

													Output Parameters:
													  url
														The url for the site.
												  --%>
												  <dsp:droplet name="SiteLinkDroplet" siteId="${siteId}" path="${urlToUpdate}"
															   queryParams="${queryParams}" var="siteLink">
													<dsp:oparam name="output">
													  <dsp:getvalueof var="siteLinkUrl" value="${siteLink.url}" scope="request"/>
													</dsp:oparam>
												  </dsp:droplet>
												  <%-- start included /global/gadgets/crossSiteLinkGenerator.jsp --%>
												</c:otherwise>
											  </c:choose>

											  <dsp:getvalueof var="siteLinkUrl" param="siteLinkUrl"/>
											  <dsp:getvalueof var="httpServer" param='httpServer'/>
											  <c:choose>
												<c:when test="${empty imgUrl}">
												  <%-- Image URL is not specified, just display link --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}" iclass="atg_store_productTitle">
													<dsp:valueof value="${displayName}">
													  <fmt:message key="common.noDisplayName"/>
													</dsp:valueof>
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:when>
												<c:otherwise>
												  <%-- Image URL is specified, display link as image --%>
												  <dsp:a href="${httpServer}${siteLinkUrl}" title="${displayName}">      
													<c:choose>
													  <c:when test="${includeTitle}">
														<img src="${imgUrl}" alt="${displayName}" title="${displayName}"/>
													  </c:when>
													  <c:otherwise>
														<img src="${imgUrl}" alt="${displayName}"/>
													  </c:otherwise>
													</c:choose>       
													<dsp:param name="productId" value="${productId}"/>
												  </dsp:a>
												</c:otherwise>
											  </c:choose>
											  <%-- end included /global/gadgets/crossSiteLink.jsp --%>
										</c:when>
										<%-- Product template not set --%>
										<c:otherwise>
										  <img src="<dsp:valueof param='httpServer'/><dsp:valueof param='alternateImage.url'/>" 
											   alt="${productName}"/>
										</c:otherwise>
									  </c:choose>
									
									</c:otherwise>
								  </c:choose>
								</c:otherwise>
							  </c:choose>
							</dsp:oparam>
						  </dsp:droplet>
						<%-- end included /browse/gadgets/productImgCart.jsp --%>
						</c:otherwise>
					  </c:choose>
                       <!--  <dsp:include page="/cart/gadgets/cartItemImage.jsp">
                          <dsp:param name="commerceItem" param="currentItem"/>
                        </dsp:include> -->
                      </td>
                      
                      <dsp:getvalueof var="productDisplayName" param="currentItem.auxiliaryData.catalogRef.displayName"/>
                      <c:if test="${empty productDisplayName}">
                        <dsp:getvalueof var="productDisplayName" param="currentItem.auxiliaryData.productRef.displayName"/>
                        <c:if test="${empty productDisplayName}">
                          <fmt:message var="productDisplayName" key="common.noDisplayName" />
                        </c:if>
                      </c:if>    
                        
                            
                      <td class="item" scope="row" abbr="${productDisplayName}">
                        <%-- Link back to the product detail page. --%>
                        
                            <dsp:valueof value="${productDisplayName}"/>
                         
      
                        <%-- Render all SKU-specific properties for the current item. --%>
                        
                          <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
                          <dsp:param name="sku" param="currentItem.auxiliaryData.catalogRef"/>
                          <dsp:param name="displayAvailabilityMessage" value="true"/>
                        <%-- start included /global/util/displaySkuProperties.jsp --%>
						<fmt:message var="tableSummary" key="common.SKUproperties_tableSummary"/>
						  <div class="propertyContainer">
							<dsp:getvalueof var="skuType" vartype="java.lang.String" param="sku.type"/>
							<c:choose>
							  <%-- 
								For the clothing-sku type display the following properties:
								  1. size
								  2. color
							  --%>
							  <c:when test="${skuType == 'clothing-sku'}">
								<dsp:getvalueof var="size" vartype="java.lang.String" param="sku.size"/>
								<dsp:getvalueof var="color" vartype="java.lang.String" param="sku.color"/>
								<c:if test="${not empty size}">
								  
								  <div class="itemProperty">
									<span class="propertyLabel">
									  <fmt:message key="common.size"/><fmt:message key="common.labelSeparator"/>
									</span>
									<span class="propertyValue">
									  <c:out value="${size}"/>
									</span>
								  </div>
								</c:if>
								<c:if test="${not empty color}">
								  <div class="itemProperty">
									<span class="propertyLabel">
									  <fmt:message key="common.color"/><fmt:message key="common.labelSeparator"/>
									</span>
									<span class="propertyValue">
									  <c:out value="${color}"/>
									</span>
								  </div>
								</c:if>
							  </c:when>
							  <%-- 
								For the furniture-sku type display the following properties:
								  1. woodFinish
							  --%>
							  <c:when test="${skuType == 'furniture-sku'}">
								<dsp:getvalueof var="woodFinish" vartype="java.lang.String" param="sku.woodFinish"/>
								<c:if test="${not empty woodFinish}">
								  <div class="itemProperty">
									 <span class="propertyLabel">
									  <fmt:message key="common.woodFinish"/><fmt:message key="common.labelSeparator"/>
									</span>
								   <span class="propertyValue">
									  <c:out value="${woodFinish}"/>
									</span>
								  </div>
								</c:if>
							  </c:when>
							</c:choose>
							
							<%-- For each SKU type display SKU ID and availability message --%>
							<dsp:getvalueof var="displayAvailabilityMessage" vartype="java.lang.Boolean" 
											param="displayAvailabilityMessage"/>
							<c:if test="${empty displayAvailabilityMessage}">
							  <c:set var="displayAvailabilityMessage" value="true"/>
							</c:if>
							<div class="itemProperty">
							  <c:choose>
								<c:when test="${displayAvailabilityMessage}">
								   <span class="propertyLabel">
									<dsp:valueof param="sku.repositoryId"/><fmt:message key="common.labelSeparator"/>
									</span>
								  <span class="propertyValue">
									
									  <dsp:param name="product" param="product"/>
									  <dsp:param name="skuId" param="sku.repositoryId"/>
									
									<%-- start included /global/gadgets/skuAvailabilityLookup.jsp --%>
									<dsp:droplet name="/atg/dynamo/transaction/droplet/Transaction">
									<dsp:param name="transAttribute" value="required"/>
									<dsp:oparam name="output">
									  <%--
										This droplet makes an inventory availability lookup for the product/SKU pair specified.

										Input parameters:
										  product
											Specifies a product to be checked.
										  skuId
											Specifies a SKU to be checked.

										Output parameters:
										  availabilityDate
											Specifies a date, when the product/SKU will be available.

										Open parameters:
										  available
											Rendered if product/SKU is available.
										  preorderable
											Rendered if product/SKU is available for preorder.
										  backorderable
											Rendered if product/SKU is available for backorder.
										  unavailable
											Rendered if product/SKU is not available.
									  --%>
									  <dsp:droplet name="SkuAvailabilityLookup">
										<dsp:param name="product" param="product"/>
										<dsp:param name="skuId" param="skuId"/>
										<dsp:oparam name="available">
										  <%-- SKU is available, set output variables. --%>
										  <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="available" scope="request"/>
										  <fmt:message var="addButtonText" key="common.button.addToCartText" scope="request"/>
										  <fmt:message var="addButtonTitle" key="common.button.addToCartTitle" scope="request"/>
										  <fmt:message var="availabilityMessage" key="common.available" scope="request"/>
										</dsp:oparam>
										<dsp:oparam name="preorderable">
										  <%-- SKU is available for preorder. Check its availability date and set output variables. --%>
										  <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="preorderable" scope="request"/>
										  <fmt:message var="addButtonText" key="common.button.preorderText" scope="request"/>
										  <fmt:message var="addButtonTitle" key="common.button.preorderTitle" scope="request"/>
										  <dsp:getvalueof var="availabilityDate" param="availabilityDate"/>
										  <c:choose>
											<c:when test="${not empty availabilityDate}">
											  <dsp:getvalueof id="availDateId" idtype="java.util.Date" param="availabilityDate"/>
											  
											  <dsp:getvalueof var="dateFormat" 
															  bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear" />
											  
											  <fmt:formatDate var="addToCartDate" value="${availDateId}" pattern="${dateFormat}"/>
											  <fmt:message var="availabilityMessage" key="common.preorderableUntil" scope="request">
												<fmt:param>
												  <span class="date numerical">${addToCartDate}</span>
												</fmt:param>
											  </fmt:message>
											</c:when>
											<c:otherwise>
											  <fmt:message var="availabilityMessage" key="common.preorderable" scope="request"/>
											</c:otherwise>
										  </c:choose>
										</dsp:oparam>
										<dsp:oparam name="backorderable">
										  <%-- SKU/product is available for backorder. Check its availability date and set output variables. --%>
										  <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="backorderable" scope="request"/>
										  <fmt:message var="addButtonText" key="common.button.backorderText" scope="request"/>
										  <fmt:message var="addButtonTitle" key="common.button.backorderTitle" scope="request"/>
										  <dsp:getvalueof var="availabilityDate" param="availabilityDate"/>
										  <c:choose>
											<c:when test="${not empty availabilityDate}">
											  <dsp:getvalueof id="availDateId" idtype="java.util.Date" param="availabilityDate" scope="request"/>
											  
											  <dsp:getvalueof var="dateFormat" 
															  bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear" />
																  
											  <fmt:formatDate var="addToCartDate" value="${availDateId}" pattern="${dateFormat}"/>
											  <fmt:message var="availabilityMessage" key="common.backorderableUntil" scope="request">
												<fmt:param>
												  <span class="date numerical">${addToCartDate}</span>
												</fmt:param>
											  </fmt:message>
											</c:when>
											<c:otherwise>
											  <fmt:message var="availabilityMessage" key="common.backorderable" scope="request"/>
											</c:otherwise>
										  </c:choose>
										</dsp:oparam>
										<dsp:oparam name="unavailable">
										  <%-- SKU is not available. Set output variables only if showUnavailable is true. --%>
										  <dsp:getvalueof id="availabilityType" idtype="java.lang.String" value="unavailable" scope="request"/>
										  <fmt:message var="availabilityMessage" key="common.temporarilyOutOfStock" scope="request"/>
										  <dsp:getvalueof id="showUnavailable" param="showUnavailable"/>
										  <c:choose>
											<c:when test="${!empty showUnavailable && showUnavailable == 'true'}">
											  <fmt:message var="addButtonText" key="common.button.emailMeInStockText" scope="request"/>
											  <fmt:message var="addButtonTitle" key="common.button.emailMeInStockTitle" scope="request"/>
											</c:when>
											<c:otherwise>
											  <dsp:getvalueof id="addButtonText" idtype="java.lang.String" value="" scope="request"/>
											  <dsp:getvalueof id="addButtonTitle" idtype="java.lang.String" value="" scope="request"/>
											</c:otherwise>
										  </c:choose>
										</dsp:oparam>
									  </dsp:droplet>
									</dsp:oparam>
								  </dsp:droplet>
									<%-- end included /global/gadgets/skuAvailabilityLookup.jsp --%>
									<c:if test="${not empty availabilityMessage}">
									  <c:out value="${availabilityMessage}"/>
									</c:if>
								  </span>
								</c:when>
								<c:otherwise>
								<div class="itemProperty">
								  <span class="propertyLabel">
									<dsp:valueof param="sku.repositoryId"/>
								  </span>
								  </div>
								</c:otherwise>
							  </c:choose>    
							</div>
							</div>
							<%-- end included /global/util/displaySkuProperties.jsp --%>
                      </td>
      
                      <%-- Display all necessary buttons for the current item. --%>
                      
      
                      <td class="price">
                        
						<dsp:getvalueof var="displayDiscountFirst" param="displayDiscountFirst"/>
  
						  <dsp:getvalueof var="excludeModelId" param="excludeModelId"/>
						  
						  <%-- The list price of the current item that will be processed by the UnitPriceDetailDroplet --%>
						  <dsp:getvalueof var="listPrice" param="currentItem.priceInfo.listPrice"/>

						  <%-- 
							Given a CommerceItem, UnitPriceDetailDroplet will return its unit price details in the
							format of a UnitPriceBean.
							
							Input Parameters:
							  item 
								The commerce item to be processed.
							
							Open Parameters:
							  output
								This is always rendered.
							
							Output Parameters:
							  unitPriceBeans
								A list of UnitPriceBeans.
						  --%>
						  <dsp:droplet name="UnitPriceDetailDroplet">
							<dsp:param name="item" param="currentItem"/>
							<dsp:oparam name="output">

							  <dsp:getvalueof var="unitPriceBeans" vartype="java.lang.Object" param="unitPriceBeans"/>
							  <c:set var="priceBeansNumber" value="${fn:length(unitPriceBeans)}"/>
							  
							  <c:forEach var="unitPriceBean" items="${unitPriceBeans}" varStatus="unitPriceBeanStatus">
								<c:set var="displayPrice" value="true"/>
								<dsp:getvalueof var="pricingModels" vartype="java.lang.Object" value="${unitPriceBean.pricingModels}"/>
								<c:if test="${displayDiscountFirst}">
								  <%-- promotions info --%>
								  <dsp:getvalueof var="excludeModelId" param="excludeModelId"/>
  
								  <%-- This will determine whether to indicate that an item is on sale or not --%>
								  <dsp:getvalueof var="currentItemOnSale" param="currentItem.priceInfo.onSale"/>
								  
								  
								  <dsp:getvalueof var="isGift" param="isGift"/>
								  
								  <c:if test="${currentItemOnSale or not empty pricingModels}">
									<span class="atg_store_discountNote">
									  <%-- Do not display 'On Sale' message if the item is gift. --%>
									  <c:if test="${currentItemOnSale && !isGift}">
										<fmt:message key="cart_detailedItemPrice.salePriceB"/>
									  </c:if>
									  
									  <c:forEach var="pricingModel" items="${pricingModels}" varStatus="status">
										<dsp:param name="pricingModel" value="${pricingModel}"/>
										<dsp:getvalueof var="modelId" param="pricingModel.id"/>
										<c:if test="${excludeModelId != modelId}">
										  <c:if test="${(currentItemOnSale && !isGift) or not status.first}">
											<fmt:message key="common.and"/>
										  </c:if>
										  
										  <dsp:valueof param="pricingModel.displayName" valueishtml="true">
										   <fmt:message key="common.promotionDescriptionDefault"/>
										  </dsp:valueof>
										</c:if>
									  </c:forEach><%-- End for each promotion used to create the unit price --%>
									</span>
								  </c:if>
								</c:if>
								
								<%-- 
								  Check if the given price bean contains GWP model. If yes,
								  just skip it - no need to display 0.0 price, it will be
								  handled in another item line.
								 --%>
								 
								 <c:if test="${not empty pricingModels}">
								  <c:forEach var="pricingModel" items="${pricingModels}" varStatus="status">
									<dsp:param name="pricingModel" value="${pricingModel}"/>
									<dsp:getvalueof var="modelId" param="pricingModel.id"/>
									<c:if test="${excludeModelId == modelId}">
									  <c:set var="displayPrice" value="false"/>
									</c:if>
								  </c:forEach>
								 </c:if>
								
								<c:if test="${displayPrice}">    
								 
								   <dsp:getvalueof var="displayQuantity" value="${priceBeansNumber > 1}"/>
									  <dsp:getvalueof var="quantity" value="${unitPriceBean.quantity}"/>
									  <dsp:getvalueof var="price" value="${unitPriceBean.unitPrice}"/>
									  <dsp:getvalueof var="oldPrice" value=""/>
									  
									  <p class="price">
										<c:if test="${displayQuantity}">
										  <fmt:formatNumber value="${quantity}" type="number"/>
										  <fmt:message key="common.atRateOf"/>
										 </c:if>
										 
										 <c:choose>
										   <c:when test="${empty oldPrice}">
											<%-- Only display the item's price --%>
											 <span>
											  
											  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

											  <%-- Set locale as the "Default price list locale", if not specified --%>
											  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
											  <c:if test="${empty locale}">
												<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
											  </c:if>

											  <%-- Format price --%>
											  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
												<dsp:param name="currency" value="${price}"/>
												<dsp:param name="locale" value="${locale}"/>
												<dsp:oparam name="output">
												  <c:choose>
													<c:when test="${saveFormattedPrice}">
													  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
													  <c:if test="${empty formattedPrice}">
														<c:set var="formattedPrice" scope="request" value="${price}"/>
													  </c:if>
													</c:when>
													<c:otherwise>
													  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
													</c:otherwise>
												  </c:choose>
												</dsp:oparam>
											  </dsp:droplet>
											 </span>
										   </c:when>
										   <c:otherwise>
										   <%-- Display the item's old price --%> 
											 <span class="atg_store_oldPrice">
											   <fmt:message key="common.price.old"/>
											   <del>
												 
												<dsp:getvalueof var="price" value="${oldPrice}"/>
												  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

												  <%-- Set locale as the "Default price list locale", if not specified --%>
												  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
												  <c:if test="${empty locale}">
													<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
												  </c:if>

												  <%-- Format price --%>
												  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
													<dsp:param name="currency" value="${price}"/>
													<dsp:param name="locale" value="${locale}"/>
													<dsp:oparam name="output">
													  <c:choose>
														<c:when test="${saveFormattedPrice}">
														  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
														  <c:if test="${empty formattedPrice}">
															<c:set var="formattedPrice" scope="request" value="${price}"/>
														  </c:if>
														</c:when>
														<c:otherwise>
														  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
														</c:otherwise>
													  </c:choose>
													</dsp:oparam>
												  </dsp:droplet>
											   </del>
											 </span>
										   </c:otherwise>
										 </c:choose>
									  </p>
								</c:if>
								  
								<c:if test="${not displayDiscountFirst}">
								 
								  <dsp:getvalueof var="excludeModelId" param="excludeModelId"/>
  
								  <%-- This will determine whether to indicate that an item is on sale or not --%>
								  <dsp:getvalueof var="currentItemOnSale" param="currentItem.priceInfo.onSale"/>
								  
								  
								  <dsp:getvalueof var="isGift" param="isGift"/>
								  
								  <c:if test="${currentItemOnSale or not empty pricingModels}">
									<span class="atg_store_discountNote">
									  <%-- Do not display 'On Sale' message if the item is gift. --%>
									  <c:if test="${currentItemOnSale && !isGift}">
										<fmt:message key="cart_detailedItemPrice.salePriceB"/>
									  </c:if>
									  
									  <c:forEach var="pricingModel" items="${pricingModels}" varStatus="status">
										<dsp:param name="pricingModel" value="${pricingModel}"/>
										<dsp:getvalueof var="modelId" param="pricingModel.id"/>
										<c:if test="${excludeModelId != modelId}">
										  <c:if test="${(currentItemOnSale && !isGift) or not status.first}">
											<fmt:message key="common.and"/>
										  </c:if>
										  
										  <dsp:valueof param="pricingModel.displayName" valueishtml="true">
										   <fmt:message key="common.promotionDescriptionDefault"/>
										  </dsp:valueof>
										</c:if>
									  </c:forEach><%-- End for each promotion used to create the unit price --%>
									</span>
								  </c:if>
								</c:if>

								<%--
								  Note that we never displayed old price for a price bean before. This is done to display prices in the following format:
									Current price
									All applied promotions
									Old price 
								 --%>
								<c:if test="${listPrice != unitPriceBean.unitPrice && displayPrice}">
								  <dsp:getvalueof var="displayQuantity" value="false"/>
									  
									  <dsp:getvalueof var="oldPrice" value="${listPrice}"/>
									  
									  <p class="price">
										<c:if test="${displayQuantity}">
										  <fmt:formatNumber value="${quantity}" type="number"/>
										  <fmt:message key="common.atRateOf"/>
										 </c:if>
										 
										 <c:choose>
										   <c:when test="${empty oldPrice}">
											<%-- Only display the item's price --%>
											 <span>
											   
											  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

											  <%-- Set locale as the "Default price list locale", if not specified --%>
											  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
											  <c:if test="${empty locale}">
												<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
											  </c:if>

											  <%-- Format price --%>
											  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
												<dsp:param name="currency" value="${price}"/>
												<dsp:param name="locale" value="${locale}"/>
												<dsp:oparam name="output">
												  <c:choose>
													<c:when test="${saveFormattedPrice}">
													  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
													  <c:if test="${empty formattedPrice}">
														<c:set var="formattedPrice" scope="request" value="${price}"/>
													  </c:if>
													</c:when>
													<c:otherwise>
													  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
													</c:otherwise>
												  </c:choose>
												</dsp:oparam>
											  </dsp:droplet>
											 </span>
										   </c:when>
										   <c:otherwise>
										   <%-- Display the item's old price --%> 
											 <span class="atg_store_oldPrice">
											   <fmt:message key="common.price.old"/>
											   <del>
												
												<dsp:getvalueof var="price" value="${oldPrice}"/>
												  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

												  <%-- Set locale as the "Default price list locale", if not specified --%>
												  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
												  <c:if test="${empty locale}">
													<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
												  </c:if>

												  <%-- Format price --%>
												  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
													<dsp:param name="currency" value="${price}"/>
													<dsp:param name="locale" value="${locale}"/>
													<dsp:oparam name="output">
													  <c:choose>
														<c:when test="${saveFormattedPrice}">
														  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
														  <c:if test="${empty formattedPrice}">
															<c:set var="formattedPrice" scope="request" value="${price}"/>
														  </c:if>
														</c:when>
														<c:otherwise>
														  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
														</c:otherwise>
													  </c:choose>
													</dsp:oparam>
												  </dsp:droplet>
											   </del>
											 </span>
										   </c:otherwise>
										 </c:choose>
									  </p>
								</c:if>
							  </c:forEach>
							</dsp:oparam>
						  </dsp:droplet><%-- End for unit price detail droplet --%>
                      </td>
      
                      <td class="quantity">
                        <%-- Don't allow user to modify samples or collateral in cart. --%>
                        
                              <dsp:valueof param='currentItem.quantity'/>
      
                      </td>
      
                      <td class="total">
                        <dsp:getvalueof var="amount" vartype="java.lang.Double" param="currentItem.priceInfo.amount"/>
                        <dsp:getvalueof var="currencyCode" vartype="java.lang.String"
                                        bean="ShoppingCart.current.priceInfo.currencyCode"/>
                        
						<dsp:getvalueof var="price" value="${amount}"/>
						  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

						  <%-- Set locale as the "Default price list locale", if not specified --%>
						  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
						  <c:if test="${empty locale}">
							<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
						  </c:if>

						  <%-- Format price --%>
						  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
							<dsp:param name="currency" value="${price}"/>
							<dsp:param name="locale" value="${locale}"/>
							<dsp:oparam name="output">
							  <c:choose>
								<c:when test="${saveFormattedPrice}">
								  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
								  <c:if test="${empty formattedPrice}">
									<c:set var="formattedPrice" scope="request" value="${price}"/>
								  </c:if>
								</c:when>
								<c:otherwise>
								  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
								</c:otherwise>
							  </c:choose>
							</dsp:oparam>
						  </dsp:droplet>
                      </td>
                    </tr>
                  </dsp:oparam>
                  
                </dsp:droplet>                
            </c:otherwise>
          </c:choose>
        </c:forEach>
        
        <%-- Include gift place holders offered by 'Gift With Purchase' promotions --%>
       
			  <dsp:getvalueof var="currentSiteSharesCart" value="${currentSiteSharesCart}"/>
			  
			  <c:set var="gwpRowCount" value="0"/>
			  
			  <%--
				This droplet retrieves all of the gift with purchase selection 
				on the current order.
				
				Input Parameters
				  order
					current order to process
					
				  onlyOutputAvailableSelections
					if true then only selections 
					where quantityAvaiableForSelection is > 0 will be output
				  
				Output Parameters
				  selections
					collection of Selections beans with gift information    
			   --%>
			  <dsp:droplet name="GiftWithPurchaseSelectionsDroplet">
				<dsp:param name="order" bean="ShoppingCart.current"/>
				<dsp:param name="onlyOutputAvailableSelections" value="true" />
				
				<dsp:oparam name="output">
				  <dsp:getvalueof var="selections" param="selections"/>
				  
				  <c:forEach var="selection" items="${selections}">
					<dsp:param name="selection" value="${selection}"/>
					
					<%-- For every available quantity render separate row --%>
					<dsp:getvalueof var="availableQuantity" param="selection.quantityAvailableForSelection"/>
					
					<%-- Split available quantity by 1 --%>
					<c:forEach var="i" begin="1" end="${availableQuantity}">
					  
					  <tr>
						
						<%-- Display empty site place holder --%>
						<c:if test="${currentSiteSharesCart == true}">
						  <td class="site">
						  </td>
						</c:if>

						<fmt:message key="common.freeGiftPlaceholder" var="giftPlaceholderTitle"/>
						
						<td class="image">
						  <%-- Gift place holder image --%>
						  <img alt="${giftPlaceholderTitle}" src="/crsdocroot/content/images/products/small/GWP_GiftWithPurchase_small.jpg">
						</td>

						<td class="item giftItemName" scope="row" abbr="<fmt:message key="common.freeGiftPlaceholder"/>">
						  <span class="itemName"><fmt:message key="common.freeGiftPlaceholder"/></span>

						  <%-- 
							Link to the non-JS gift selection page. 
							Pass gift selection info
							--%>
						  <noscript>  
							<dsp:a href="noJsGiftSelection.jsp" title="${selectButtonText}" iclass="atg_store_basicButton atg_store_gwpSelectButtonNoJs">
							  <dsp:param name="giftType" param="selection.giftType"/>
							  <dsp:param name="giftDetail" param="selection.giftDetail"/>
							  <dsp:param name="giftHashCode" param="selection.giftHashCode"/>
							  <dsp:param name="promotionId" param="selection.promotionId"/>
							  <span>
								<fmt:message key="common.select"/>
							  </span>
							</dsp:a>
						  </noscript>
						  
						  <%-- Construct an URL with gift selector information --%>
						  <c:url var="selectionUrl" value="gadgets/giftSelection.jsp">
							<c:param name="giftType" value="${selection.giftType}"/>
							<c:param name="giftDetail" value="${selection.giftDetail}"/>
							<c:param name="giftHashCode" value="${selection.giftHashCode}"/>
							<c:param name="promotionId" value="${selection.promotionId}"/>
						  </c:url>
						  
						  <%--
							Link to the JS-based pop over dialog.
							We need to initialize HREF with proper link onclick first.
						   --%>
						   
						   
						</td>

						

						<td class="price">
						  <%-- We offer gifts for free --%>
						  <fmt:message key="common.FREE"/>
						  
						  <%-- 
							Gift place holder doesn't provide any promotion notes but provide promotion ID instead.
							We will retrieve promotion repository item using PromotionLookup and first and then
							get promotion's display name.
							
							Input Parameters
							  id
								promotion ID
							  
							Output Parameters
							  element
								promotion repository item  
							--%>
						  <dsp:droplet name="PromotionLookup">
							<dsp:param name="id" param="selection.promotionId"/>
							
							<dsp:oparam name="output">
							  
							  <%-- display promotion name under 'FREE' price --%>
							  <span class="atg_store_discountNote">
								<dsp:valueof param="element.displayName" valueishtml="true"/>
							  </span>  
							</dsp:oparam>
						  </dsp:droplet>
						</td>

						<%-- Gift quantity is already constant --%>
						<td class="quantity">
						  <fmt:message key="common.singleItem"/>
						</td>
			  
						<%-- Total gift price is always free --%>
						<td class="total">
						  <fmt:message key="common.FREE"/>
						</td>
					  </tr>          
					</c:forEach>

				  </c:forEach>  
				  
				</dsp:oparam>
			  </dsp:droplet>

        <%-- Display div for pop over --%>
       

      </tbody>
    </table>
          
        </div>
        
        <%-- Order summary and action buttons --%> 
        <c:if test='${commerceItemCount != 0}'>
          
		  <dsp:param name="skipCouponFormDeclaration" value="true" />
            <dsp:param name="order" bean="ShoppingCart.current" />
            <dsp:param name="isShoppingCart" value="true" />
		  <%-- start included /checkout/gadgets/checkoutOrderSummary.jsp --%>
			
		  <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="order.priceInfo.currencyCode" />
		  <dsp:getvalueof var="shipping" vartype="java.lang.Double" param="order.priceInfo.shipping" />
		  <dsp:getvalueof var="order"  param="order" />
		  <dsp:getvalueof var="isShoppingCart" param="isShoppingCart"/>
		  <dsp:getvalueof var="currentStage" param="currentStage"/>
		  <dsp:getvalueof var="submittedOrder" param="submittedOrder"/>

		  <div class="atg_store_orderSummary aside">
			<%-- Display 'Order Details' header. --%>
			<h4>
			  <fmt:message key="checkout_orderSummary.orderSummary"/>
			</h4>
			<%-- And render order's details. --%>
			<ul class="atg_store_orderSubTotals">
			  <%-- Display order subtotal. --%>
			  <li class="subtotal">
				<span class="atg_store_orderSummaryLabel">
				  <fmt:message key="common.subTotal"/>
				</span>
				<span class="atg_store_orderSummaryItem">
				
				  <dsp:getvalueof var="rawSubtotal" vartype="java.lang.Double" param="order.priceInfo.rawSubtotal"/>
				  <dsp:param name="price" value="${rawSubtotal}"/>
				 
				   <%-- start included /global/gadgets/formattedPrice.jsp --%>
				 <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
				  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

				  <%-- Set locale as the "Default price list locale", if not specified --%>
				  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
				  <c:if test="${empty locale}">
					<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
				  </c:if>

				  <%-- Format price --%>
				  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
					<dsp:param name="currency" value="${price}"/>
					<dsp:param name="locale" value="${locale}"/>
					<dsp:oparam name="output">
					  <c:choose>
						<c:when test="${saveFormattedPrice}">
						  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
						  <c:if test="${empty formattedPrice}">
							<c:set var="formattedPrice" scope="request" value="${price}"/>
						  </c:if>
						</c:when>
						<c:otherwise>
						  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
						</c:otherwise>
					  </c:choose>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/formattedPrice.jsp --%>
				</span>
			  </li>

			  <%--
				Display applied discounts amount.
				First, check if there are applied discounts. If this is the case, display applied discounts amount.
			  --%>
			  <dsp:getvalueof var="discountAmount" vartype="java.lang.Double" param="order.priceInfo.discountAmount"/>
			  <c:if test="${discountAmount > 0}">
				<li>
				  <span class="atg_store_orderSummaryLabel">
					<fmt:message key="common.discount"/>*
				  </span>
				  <span class="atg_store_orderSummaryItem">
					-

					<dsp:param name="price" value="${discountAmount}"/>
					<%-- start included /global/gadgets/formattedPrice.jsp --%>
				 <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
				  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

				  <%-- Set locale as the "Default price list locale", if not specified --%>
				  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
				  <c:if test="${empty locale}">
					<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
				  </c:if>

				  <%-- Format price --%>
				  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
					<dsp:param name="currency" value="${price}"/>
					<dsp:param name="locale" value="${locale}"/>
					<dsp:oparam name="output">
					  <c:choose>
						<c:when test="${saveFormattedPrice}">
						  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
						  <c:if test="${empty formattedPrice}">
							<c:set var="formattedPrice" scope="request" value="${price}"/>
						  </c:if>
						</c:when>
						<c:otherwise>
						  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
						</c:otherwise>
					  </c:choose>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/formattedPrice.jsp --%>
				  </span>
				</li>
			  </c:if>

				<%-- Display shipping price. --%>
				<li>
				  <span class="atg_store_orderSummaryLabel">
					<fmt:message key="common.shipping"/>
				  </span>
				  <span class="atg_store_orderSummaryItem">
					
					<dsp:param name="price" value="${shipping}"/>
					<%-- start included /global/gadgets/formattedPrice.jsp --%>
				 <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
				  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

				  <%-- Set locale as the "Default price list locale", if not specified --%>
				  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
				  <c:if test="${empty locale}">
					<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
				  </c:if>

				  <%-- Format price --%>
				  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
					<dsp:param name="currency" value="${price}"/>
					<dsp:param name="locale" value="${locale}"/>
					<dsp:oparam name="output">
					  <c:choose>
						<c:when test="${saveFormattedPrice}">
						  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
						  <c:if test="${empty formattedPrice}">
							<c:set var="formattedPrice" scope="request" value="${price}"/>
						  </c:if>
						</c:when>
						<c:otherwise>
						  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
						</c:otherwise>
					  </c:choose>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/formattedPrice.jsp --%>
				  </span>
				</li>

				<%-- Display taxes amount. --%>
				<li>
				  <span class="atg_store_orderSummaryLabel">
					<fmt:message key="common.tax"/>
				  </span>
				  <span class="atg_store_orderSummaryItem">
					<dsp:getvalueof var="tax" vartype="java.lang.Double" param="order.priceInfo.tax" />
					
					<dsp:param name="price" value="${tax}"/>
					<%-- start included /global/gadgets/formattedPrice.jsp --%>
				 <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
				  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

				  <%-- Set locale as the "Default price list locale", if not specified --%>
				  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
				  <c:if test="${empty locale}">
					<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
				  </c:if>

				  <%-- Format price --%>
				  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
					<dsp:param name="currency" value="${price}"/>
					<dsp:param name="locale" value="${locale}"/>
					<dsp:oparam name="output">
					  <c:choose>
						<c:when test="${saveFormattedPrice}">
						  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
						  <c:if test="${empty formattedPrice}">
							<c:set var="formattedPrice" scope="request" value="${price}"/>
						  </c:if>
						</c:when>
						<c:otherwise>
						  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
						</c:otherwise>
					  </c:choose>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/formattedPrice.jsp --%>
				  </span>
				</li>
				
			   
				<%--
				  Calculate store credits for this order.
				  On the Order Details page, store credits should be calculated from the order itself.
				  On checkout pages, store credits should be calculated from the current profile.
				--%>
				<c:set var="storeCreditAmount" value=".0"/>
				<c:choose>
				  <c:when test="${empty submittedOrder}">
					<dsp:droplet name="/atg/commerce/claimable/AvailableStoreCredits">
					  <dsp:param name="profile" bean="/atg/userprofiling/Profile"/>
					  <dsp:oparam name="output">
						<dsp:getvalueof var="storeCreditAmount" vartype="java.lang.Double" param="overallAvailableAmount"/>
					  </dsp:oparam>
					</dsp:droplet>
				  </c:when>
				  <c:otherwise>
					<dsp:getvalueof var="storeCreditAmount" vartype="java.lang.Double" param="order.storeCreditsAppliedTotal"/>
				  </c:otherwise>
				</c:choose>
				<dsp:getvalueof var="total" vartype="java.lang.Double" param="order.priceInfo.total"/>

				<%-- Display calculated store credits amount only if there are credits to display. --%>
				<c:if test="${storeCreditAmount > .0}">
				  <li>
					<span class="atg_store_orderSummaryLabel">
					  <fmt:message key="checkout_onlineCredit.useOnlineCredit"/>
					</span>
					<span class="atg_store_orderSummaryItem">
					  -
					  
					  <dsp:param name="price" value="${empty submittedOrder ? (total > storeCreditAmount ? storeCreditAmount : total) : storeCreditAmount}"/>
					<%-- start included /global/gadgets/formattedPrice.jsp --%>
				 <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
				  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

				  <%-- Set locale as the "Default price list locale", if not specified --%>
				  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
				  <c:if test="${empty locale}">
					<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
				  </c:if>

				  <%-- Format price --%>
				  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
					<dsp:param name="currency" value="${price}"/>
					<dsp:param name="locale" value="${locale}"/>
					<dsp:oparam name="output">
					  <c:choose>
						<c:when test="${saveFormattedPrice}">
						  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
						  <c:if test="${empty formattedPrice}">
							<c:set var="formattedPrice" scope="request" value="${price}"/>
						  </c:if>
						</c:when>
						<c:otherwise>
						  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
						</c:otherwise>
					  </c:choose>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/formattedPrice.jsp --%>
					</span>
				  </li>
				</c:if>

				<%--
				  Display all available pricing adjustments (i.e. discounts) except the first one.
				  The first adjustment is always order's raw subtotal, and hence doesn't contain a discount.
				--%>
				<c:if test="${fn:length(order.priceInfo.adjustments) > 1}">
				  <li class="atg_store_appliedOrderDiscounts">
					<c:forEach var="priceAdjustment" varStatus="status" items="${order.priceInfo.adjustments}" begin="1">
					  <c:out value="*"/>
					  <dsp:tomap var="pricingModel" value="${priceAdjustment.pricingModel}"/>
					  <c:out value="${pricingModel.description}" escapeXml="false"/>
					  <br/>
					</c:forEach>
				  </li>
				</c:if>
				
				

			  <li class="atg_store_orderTotal">
				<%-- Display order's total. --%>
				  <span class="atg_store_orderSummaryLabel"><fmt:message key="common.total"/><fmt:message key="common.labelSeparator"/></span>
				  <span class="atg_store_orderSummaryItem">
					
					<dsp:param name="price" value="${total > storeCreditAmount ? total - storeCreditAmount : 0}"/>
					<%-- start included /global/gadgets/formattedPrice.jsp --%>
				 <dsp:getvalueof var="price" vartype="java.lang.Double" param="price"/>
				  <dsp:getvalueof var="saveFormattedPrice" param="saveFormattedPrice"/>

				  <%-- Set locale as the "Default price list locale", if not specified --%>
				  <dsp:getvalueof var="locale" vartype="java.lang.String" param="priceListLocale"/>
				  <c:if test="${empty locale}">
					<dsp:getvalueof var="locale" vartype="java.lang.String" bean="/atg/userprofiling/Profile.priceList.locale"/>
				  </c:if>

				  <%-- Format price --%>
				  <dsp:droplet name="/atg/dynamo/droplet/CurrencyFormatter">
					<dsp:param name="currency" value="${price}"/>
					<dsp:param name="locale" value="${locale}"/>
					<dsp:oparam name="output">
					  <c:choose>
						<c:when test="${saveFormattedPrice}">
						  <dsp:getvalueof var="formattedPrice" scope="request" vartype="java.lang.String" param="formattedCurrency"/>
						  <c:if test="${empty formattedPrice}">
							<c:set var="formattedPrice" scope="request" value="${price}"/>
						  </c:if>
						</c:when>
						<c:otherwise>
						  <dsp:valueof param="formattedCurrency">${price}</dsp:valueof>
						</c:otherwise>
					  </c:choose>
					</dsp:oparam>
				  </dsp:droplet>
				  <%-- end included /global/gadgets/formattedPrice.jsp --%>
				  </span>
			  </li>
			</ul>
			
		  </div>
		  <%-- end included /checkout/gadgets/checkoutOrderSummary.jsp --%>
        </c:if>
  </dsp:form>
    </jsp:body>

	</crs:emailPageContainer>

</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/emailtemplates/abandonedOrderPromo.jsp#1 $$Change: 713790 $--%>