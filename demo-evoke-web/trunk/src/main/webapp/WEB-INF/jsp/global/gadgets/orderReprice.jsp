<%--
  This gadget reprices an order. It calculates an order subtotal only, i.e. taxes and shipping prices remain the same.

  Required parameters:
    None.

  Optional parameters:
    None.
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/RepriceOrderDroplet"/>
  <%--
    This droplet executes 'repriceAndUpdateOrder' chain. It uses current cart as input order parameter
    for the chain in question.

    Input parameters:
      pricingOp
        Pricing operation to be executed.

    Output parameters:
      pipelineResult
        Result returned from the pipeline, if execution is successfull.
      exception
        Exception thrown by the pipeline, if any.

    Open parameters:
      failure
        Rendered, if the pipeline has thrown an exception.
      successWithErrors
        Rendered, if pipeline successfully finished, but returned error.
      success
        Rendered, if pipeline successfully finished without errors returned.
  --%>
  <dsp:droplet name="RepriceOrderDroplet">
    <dsp:param name="pricingOp" value="ORDER_SUBTOTAL"/>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/global/gadgets/orderReprice.jsp#1 $$Change: 713790 $--%>