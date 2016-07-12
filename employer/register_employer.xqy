xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "/lib/common-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "/lib/employer-lib.xqy";
declare option xdmp:mapping "false";

if ((elib:is-login())) then
		 (:Redirect to the Candidate Home Page:)
		xdmp:redirect-response("/employer")
else if(xdmp:get-request-field("register") = "1") then
  let $login := xdmp:get-request-field("login")
  let $password	:= xdmp:get-request-field("password")
  let $re-password := xdmp:get-request-field("re-password")
  let $company := xdmp:get-request-field("company")
  let $email := xdmp:get-request-field("email")
  return

  if ($login = "") then 
	xdmp:set-session-field("message", "Provide an username")
  else if (normalize-space($login) = "") then
    xdmp:set-session-field("message", "Provide an username")
  else if (normalize-space($password) = "") then
    xdmp:set-session-field("message", "Provide an password")
  else if ($password != $re-password) then
    xdmp:set-session-field("message", "The two password and re-password are not same")
  else if (normalize-space($email) = "") then
    xdmp:set-session-field("message", "Provide an email")
  else 
	  let $add-employer := elib:add-employer(normalize-space($login), normalize-space($password), normalize-space($company), normalize-space($email))
	  return

	  if ($add-employer) then
		  (xdmp:set-session-field("message", "You have been successfully registered to the system"),
		  xdmp:redirect-response("/default.xqy") )
	  else  ()
else 
xdmp:set-response-content-type("text/html"),

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
	<meta name="web-author" content="Amit Yadav"/>
	<meta name="keywords" content="MarkLogic ResumeService" />
	<meta name="description" content="MarkLogic ResumeService" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="-1" />
	<link rel="stylesheet" type="text/css" href="/css/global.css?{xdmp:random()}" />
	<link rel="stylesheet" type="text/css" href="/css/create.css?{xdmp:random()}" />
	<script src="/js/prototype.js?{xdmp:random()}" type="text/javascript"/>
	<script src="/js/livevalidation.js?{xdmp:random()}" type="text/javascript"/>
	<script src="/js/livevalidation.js?{xdmp:random()}" type="text/javascript"/>
	<!--[if lt IE 7]>
        <link rel="stylesheet" type="text/css" href="/css/ie6.css?{xdmp:random()}" />
	<![endif]-->
	<!--[if (gte IE 7)&(lt IE 8)]>
	<link rel="stylesheet" type="text/css" href="/css/ie7.css?{xdmp:random()}" />
	<![endif]-->
	<title>{glib:get-title()}</title>
</head>

<body>
	<div id="container">
		{glib:display-header()}
		<div class="height15"></div>
		<div class="height15"></div>
		<div class="height15"></div>
		
		{
			if (xdmp:get-session-field("message")) then
				(
					<h3>{xdmp:get-session-field("message")}</h3>,
					<div class="height15"></div>
				)
			else ()
		}

		<div class="centercol" style="min-width:550px; min-height:450px;" id="central_content_div_pannel">
			<div id="sub_menulogin">
				<div class="subnav">
					<ul>
						<li id="tab_candidate" class="item_active">
          					<a href="javascript:void(0);">
          						<span>Register New Employee</span>
							</a>
						</li>
					</ul>
				</div>
				<div class="clearer"></div>
			</div>
			
			<div class="clearer"></div>

			<div class="leftcol-login">
				<div class="height15"></div>
				<div id="candidate">
					<form action="/employer/register_employer_do.xqy" method="post" id="frmLogin" name="frmLogin">
						<div class="box">
							<div class="boxtop"></div>
							<div class="boxbg">
								<div class="textheading1">Username </div>
								<div class="formfield1">
									<input class="textfield" id="login" name="login" size="25" tabindex="1" type="text" value="" />
								</div>
								<div class="height10"></div>

								<div class="textheading1">Password </div>
								<div class="formfield1">
									<input class="textfield" id="password" name="password" size="25" tabindex="2" type="password" value="" />
								</div>
								<div class="height10"></div>

								<div class="textheading1">Re-Password </div>
								<div class="formfield1">
									<input class="textfield" id="re-password" name="re-password" size="25" tabindex="3" type="password" value="" />
								</div>
								<div class="height10"></div>

								<div class="textheading1">Company </div>
								<div class="formfield1">
									<input class="textfield" id="company" name="company" size="25" tabindex="4" type="text" value="" />
								</div>
								<div class="height10"></div>

								<div class="textheading1">Email </div>
								<div class="formfield1">
									<input class="textfield" id="email" name="email" size="25" tabindex="5" type="text" value="" />
								</div>
								<div class="height10"></div>

								<div class="textheading1">&nbsp;</div>
								<div class="forgotpassword green11-normal"> <a href="/default.xqy">&lt;&lt;Login</a> </div>
								<div class="height3"></div>
								<input type="hidden" name="validate" value="1" />
								<div class="height3"></div>
								<div class="textheading1">&nbsp; </div>
								<div class="formfield1">
									<input type="image" src="/images/submit.gif" alt="Login" tabindex="6" />
								</div>
								<div class="height3"></div>
								<div class="clearer"></div>
							</div>
							<div class="boxbottom"></div>
							<div class="clearer"></div>
						</div>
						<input type="hidden" name="register" value="1"/>
					</form>	
				</div>
				<div class="height15"></div>
			</div>
			<!--<div class="rightcol-login"><img src="/images/login-banner.jpg" alt="Banner" width="387" height="250" /> </div>-->
		</div>
		{glib:display-footer()}
	</div>	
</body>

<script>
	//Live validation scripts for checking the form entry
	<![CDATA[
		var login1 = new LiveValidation('login');
		login1.add( Validate.Presence, { failureMessage: "Username required!" } );

		var pwd = new LiveValidation('password');
		pwd.add( Validate.Presence, { failureMessage: "Password is required!" } );
		pwd.add( Validate.Length, { minimum: 6 } );

		var pwd2 = new LiveValidation('re-password');
		pwd2.add( Validate.Presence, { failureMessage: "Re-Password is required!" } );
		pwd2.add( Validate.Confirmation, { match: 'Two password dose not match!' } );

		var email = new LiveValidation('email');
		email.add( Validate.Presence, { failureMessage: "Email required!" } );
		email.add( Validate.Format, { pattern: /([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/i ,failureMessage: "Invalid email format!" } );
	]]>
</script>

</html>