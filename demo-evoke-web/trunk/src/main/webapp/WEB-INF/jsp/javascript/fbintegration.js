	window.fbAsyncInit = function() {
		FB.init({
			appId : 533919933311690,
			cookie : true,
			status : true,
			xfbml : true,
			oauth : true
		});
	};
	
	function generate_password(length) {
	    var i = 0;
	    var numkey = "";
	    var randomNumber;
	    while( i < length) {
	        randomNumber = (Math.floor((Math.random() * 100)) % 94) + 33;
	        if ((randomNumber >=33) && (randomNumber <=47)) { continue; }
	        if ((randomNumber >=58) && (randomNumber <=90)) { continue; }
	        if ((randomNumber >=91) && (randomNumber <=122)) { continue; }
	        if ((randomNumber >=123) && (randomNumber <=126)) { continue; }
	        i++;
	        numkey += String.fromCharCode(randomNumber);
	    }
	    return numkey;
	}
	
	function populateFormFields(userInfo) {
		FB.getLoginStatus(function(response) {
			if (response.status === 'connected') {
				var uid = response.authResponse.userID;
				FB.api('/me/likes', function(response) {
					var user_likes_array = [];
		            for (i = 0; i < response.data.length; i++) {
		            	user_likes_array.push(response.data[i].name);
		            }
		            likes = user_likes_array.join(",");
		            $("#login").val(userInfo.email);
		            $("#email").val(userInfo.email);
		            $("#fname").val(userInfo.first_name);
		            $("#mname").val(userInfo.middle_name);
		            var password = generate_password(8);
		            $("#password").val(password);
		            $("#lname").val(userInfo.last_name);
		            $("#gender").val(userInfo.gender);
		            $("#birthDay").val(userInfo.birthday);
		            $("#fblikes").val(likes);
		            $("#loginSubmit").click();
				});
			} else if (response.status === 'not_authorized') {
				//Do something when unauthorized
			} else {
				//When not logged in
			}
		});
	}

	function fb_login() {
		FB.login(function(response) {
					if (response.authResponse) {
						//$("#fb_Connect").hide();
						FB.api('/me', function(response) {
							populateFormFields(response);
						});
					} else {
						console
								.log('user has cancelled login to facebook.');
					}
				},
				{
					scope : 'email,user_likes,user_birthday,status_update,publish_stream,read_friendlists'
				});
	}
	// Load the SDK Asynchronously
	(function() {
		var e = document.createElement('script');
		e.type = 'text/javascript';
		e.src = 'http://connect.facebook.net/en_US/all.js';
		e.async = true;
		document.getElementById('fb-root').appendChild(e);
	}());
