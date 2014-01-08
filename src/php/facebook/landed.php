<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>New Graph api & Javascript Base FBConnect Tutorial | Thinkdiff.net</title>
    <style type="text/css">
    body,td,th {
	color: #FFF;
}
a:link {
	color: #FFF;
}
a:visited {
	color: #FFF;
}
a:hover {
	color: #FFF;
}
a:active {
	color: #FFF;
}
    </style>
    </head>
<body>
        <div id="fb-root"></div>
        <script type="text/javascript">
            window.fbAsyncInit = function() {
                FB.init({appId:'170716739801062', status: true, cookie: true, xfbml: true});
 
                /* All the events registered */
                FB.Event.subscribe('auth.login', function(response) {
                    login();
					FB.logout();
                });
                FB.Event.subscribe('auth.logout', function(response) {
                    // do something with response
                    logout();
                });
 
                FB.getLoginStatus(function(response) {
					FB.logout();
                    if (response.session) {
                        $('#AccessToken').val(response.session.access_token);

                        login();
                    }
                });
				
			FB.Event.subscribe('edge.create',
				function(response) {
					alert('You liked the URL: ' + response);
				}
			);

            };
            (function() {
                var e = document.createElement('script');
                e.type = 'text/javascript';
                e.src = document.location.protocol +
                    '//connect.facebook.net/en_US/all.js';
                e.async = true;
                document.getElementById('fb-root').appendChild(e);
            }());
 
            function login(){
                FB.api('/me', function(response) {
                    document.getElementById('login').style.display = "block";
                    document.getElementById('login').innerHTML = response.name + " succsessfully logged in!";
                });
            }
            function logout(){
                document.getElementById('login').style.display = "none";
            }
 
            //stream publish method
            function streamPublish(name, description, hrefTitle, hrefLink, userPrompt){
                FB.ui(
                {
                    method: 'stream.publish',
                    message: '',
                    attachment: {
                        name: name,
                        caption: '',
                        description: (description),
                        href: hrefLink
                    },
                    action_links: [
                        { text: hrefTitle, href: hrefLink }
                    ],
                    user_prompt_message: userPrompt
                },
                function(response) {
 
                });
 
            }
            function showStream(){
                FB.api('/me', function(response) {
                    //console.log(response.id);
                    streamPublish(response.name, 'Thinkdiff.net contains geeky stuff', 'hrefTitle', 'http://thinkdiff.net', "Share thinkdiff.net");
                });
            }
 
            function share(){
                var share = {
                    method: 'apprequests',
					message: 'condividi con me',
                    u: 'http://www.ignitionsecure.com/'
                };
 
                FB.ui(share, function(response) { console.log(response); });
            }
 
            function graphStreamPublish(){
                var body = 'Reading New Graph api & Javascript Base FBConnect Tutorial';
                FB.api('/me/feed', 'post', { message: body }, function(response) {
                    if (!response || response.error) {
                        alert('Error occured');
                    } else {
                        alert('Post ID: ' + response.id);
                    }
                });
            }

            function publishChehkin(){
                var body = 'I am at BTO!!!';
                FB.api('/me/checkins','post',{place:63764092994,picture:"http://www.ignitionsecure.co.uk/vcaltest/ATT21999.jpg",link:"http://www.google.com",description:"I just checked out here, follow the link for more amazing offers",coordinates:{latitude: '41.899347713385',longitude:'12.490232997972'}},function(response) {
                    if (!response || response.error) {
                        alert('Error occured'+dump(response));
                    } else {
                        alert('Post ID: ' + response.id);
                    }
                });
            }
			
            function readChehkin(){
                /*var body = 'Reading New Graph api & Javascript Base FBConnect Tutorial';
                FB.api('/me/checkins',{access_token:"AAAEM3TbSxh8BAP3untru2yuoek5wJTS0lsaW4wmdPXvIPRVa7eElFPTSCzcH30Au5EH88PbA8uGZCZAzF8XcFOI4Nxyi8ZD"},function(response) {
                    if (!response || response.error) {
                        alert('Error occured'+dump(response));
                    } else {
                        alert('Post ID: ' + dump(response));
                    }
                });*/
            }
 
            function fqlQuery(){
                FB.api('/me', function(response) {
                     var query = FB.Data.query('select name, hometown_location, sex, email, pic_square from user where uid={0}', response.id);
                     query.wait(function(rows) {
 
                       document.getElementById('name').innerHTML =
                         'Your name: ' + rows[0].name + "<br />" +
						 'Sex: ' + rows[0].sex + "<br />" +
						 'Email: ' + rows[0].email + "<br />" +
                         '<img src="' + rows[0].pic_square + '" alt="" />' + "<br />";
                     });
                });
            }
 
            function setStatus(){
                status1 = document.getElementById('status').value;
                FB.api(
                  {
                    method: 'status.set',
                    status: status1
                  },
                  function(response) {
                    if (response == 0){
                        alert('Your facebook status not updated. Give Status Update Permission.');
                    }
                    else{
                        alert('Your facebook status updated');
                    }
                  }
                );
            }
			
function logMeOut() {
	FB.logout(function(response) {
  // user is now logged out
});

}
			
function dump(arr,level) {
var dumped_text = "";
if(!level) level = 0;

//The padding given at the beginning of the line.
var level_padding = "";
for(var j=0;j<level+1;j++) level_padding += "    ";

if(typeof(arr) == 'object') { //Array/Hashes/Objects
 for(var item in arr) {
  var value = arr[item];
 
  if(typeof(value) == 'object') { //If it is an array,
   dumped_text += level_padding + "'" + item + "' ...\n";
   dumped_text += dump(value,level+1);
  } else {
   dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
  }
 }
} else { //Stings/Chars/Numbers etc.
 dumped_text = "===>"+arr+"<===("+typeof(arr)+")";
}
return dumped_text;
} 
        </script>
 
        <h3>New Graph api & Javascript Base FBConnect Tutorial | Thinkdiff.net</h3>
        <p><fb:login-button autologoutlink="true" scope="email,publish_checkins,user_photos,photos,publish_stream,publish_actions,offline_access"></fb:login-button></p>
 		//user_birthday,status_update,publish_stream,publish_checkins,user_checkins
        <p>
            <a href="#" onclick="showStream(); return false;">Publish Wall Post</a> |
            <a href="#" onclick="share(); return false;">Share With Your Friends</a> |
            <a href="#" onclick="graphStreamPublish(); return false;">Publish Stream Using Graph API</a> |
            <a href="#" onclick="fqlQuery(); return false;">FQL Query Example</a>
    | <a href="#" onclick="publishChehkin(); return false;">Checkin in a place</a> | <a href="#" onclick="readChehkin(); return false;">List of placec you checked in</a> | <a href="#" onClick="logMeOut()">logout</a></p>
 
        <textarea id="status" cols="50" rows="5" style="display:none;">Write your status here and click 'Status Set Using Legacy Api Call'</textarea>
        <br />
        <a href="#" onclick="setStatus(); return false;">Status Set Using Legacy Api Call</a>
 
        <br /><br />
        <div id="AccessToken">Content for  id "AccessToken" Goes Here</div>
        <br />
        <div id="login" style ="display:none"></div>
        <div id="name"></div>
 <div class="fb-like" data-href="http://www.facebook.com/#!/lovelycreative" data-send="true" data-width="300" data-show-faces="true"></div>
</body>
</html>