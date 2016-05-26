<%--  This page renders Facebook login form for returned customers. --%>
<%@ page import="atg.servlet.*"%>
<dsp:page>
	<dsp:importbean bean="/atg/userprofiling/ProfileFormHandler" />
	<dsp:getvalueof var="contextPath" bean="/OriginatingRequest.contextPath" />
	<html>
	<head>
	<title>Login with facebook</title>
	<script src="../javascript/jquery-1.6.4.js" type="text/javascript"></script>
	</head>
	<body>
	<input alt="facebook" value="facebook" type="button" id="fb_Connect" onClick="fb_login();" />
	</body>
	<div id="fb-root"></div>
	<script src="../javascript/fbintegration.js" type="text/javascript"></script>
	<div style="display: none;">
	<dsp:form id="login_form" action="fbIntegration.jsp" method="post">
		<dsp:input id="login" bean="ProfileFormHandler.value.login"	type="hidden" />
		<dsp:input bean="ProfileFormHandler.loginSuccessURL" type="hidden" value="../myaccount/profile.jsp" />
		<dsp:input bean="ProfileFormHandler.loginErrorURL" type="hidden" value="../myaccount/login.jsp" />
		<dsp:input id="email" bean="ProfileFormHandler.value.email"	type="hidden" />
		<dsp:input id="password" bean="ProfileFormHandler.value.password" type="password" />
		<dsp:input id="fname" bean="ProfileFormHandler.value.firstName"	type="hidden" />
		<dsp:input id="mname" bean="ProfileFormHandler.value.middleName"	type="hidden" />
		<dsp:input id="lname" bean="ProfileFormHandler.value.lastName" type="hidden" />
		<dsp:input id="gender" bean="ProfileFormHandler.value.gender" type="hidden" />
		<dsp:input id="birthDay" bean="ProfileFormHandler.value.dateOfBirth" type="hidden"/>
		<dsp:input bean="ProfileFormHandler.value.isFacebookProfile" type="text" value="true" />
		<dsp:input id="fblikes" bean="ProfileFormHandler.value.userLikes" type="hidden" />
		<dsp:input id="loginSubmit" bean="ProfileFormHandler.facebookLogin" type="submit" value="Submit" />
	</dsp:form>
	</div>
	</html>
</dsp:page>