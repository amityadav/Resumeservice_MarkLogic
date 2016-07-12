xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "lib/common-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "lib/candidate-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "lib/employer-lib.xqy";
declare option xdmp:mapping "false";

if ((clib:is-login())) then
		 (:Redirect to the Candidate Dashboard:)
		xdmp:redirect-response("/candidate")
else if ((elib:is-login())) then
		 (:Redirect to the Employer Dashboard:)
		xdmp:redirect-response("/employer/dashboard")
else if(xdmp:get-request-field("candidate")) then
		if(fn:normalize-space(xdmp:get-request-field("login")) and xdmp:get-request-field("password") and xdmp:get-request-field("validate")) then 
			if(normalize-space(xdmp:get-request-field("login")) = "") then
				xdmp:set-session-field("message", "Username missing!!!")
			else if(normalize-space(xdmp:get-request-field("password")) = "") then
				xdmp:set-session-field("message", "Password missing!!!")
			else if(clib:is-candidate-registered(fn:normalize-space(xdmp:get-request-field("login")), xdmp:get-request-field("password"))) then
				(:Redirect to the Candidate Home Page:)
				xdmp:redirect-response("/candidate") 
			else ()	
		else ()
else if(xdmp:get-request-field("employer")) then
		if(fn:normalize-space(xdmp:get-request-field("emp-login")) and xdmp:get-request-field("emp-password") and xdmp:get-request-field("validate")) then 
			if(normalize-space(xdmp:get-request-field("emp-login")) = "") then
				xdmp:set-session-field("message", "Username missing!!!")
			else if(normalize-space(xdmp:get-request-field("emp-password")) = "") then
				xdmp:set-session-field("message", "Password missing!!!")
			else if(elib:is-employer-registered(normalize-space(xdmp:get-request-field("emp-login")), xdmp:get-request-field("emp-password"))) then
				(:Redirect to the Employer Dashboard:)
				xdmp:redirect-response("/employer/dashboard") 
			else ()	
		else ()
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
	<!--[if lt IE 7]>
        <link rel="stylesheet" type="text/css" href="/css/ie6.css?{xdmp:random()}" />
	<![endif]-->
	<!--[if (gte IE 7)&(lt IE 8)]>
	<link rel="stylesheet" type="text/css" href="/css/ie7.css?{xdmp:random()}" />
	<![endif]-->
	<title>{glib:get-title()}</title>
</head>
	<script>
		<![CDATA[
			var show_hide = function(divId){
				if(divId == "candidate"){
					$('candidate').style.display = "block";
					$('employee').style.display = "none";
					$('tab_candidate').className = "item_active";
					$('tab_employee').className = "";
				}else{
					$('candidate').style.display = "none";
					$('employee').style.display = "block";
					$('tab_candidate').className = "";
					$('tab_employee').className = "item_active";
				}
			}
		]]>
	</script>



<body>
	<div id="container">
		{glib:display-header()}
		<div class="height15"></div>
		<div class="height15"></div>
		<div class="height15"></div>

		{
			if (xdmp:get-session-field("message")) then
				(
					xdmp:set-session-field("message", ""),
					<h3>{xdmp:get-session-field("message")}</h3>,
					<div class="height15"></div>
				)
			else ()
		}
		
		
		<div class="centercol" style="min-width:550px; min-height:380px;" id="central_content_div_pannel">
			<div id="sub_menulogin">
				<div class="subnav">
					<ul>
						<li id="tab_candidate" class="item_active">
          					<a href="javascript:void(0);" onclick="show_hide('candidate');">
          						<span>Candidate</span>
							</a>
						</li>
						
						<li id="tab_employee" class="">
          					<a href="javascript:void(0);" onclick="show_hide('employee');">
          						<span>Employee</span>
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
					<form action="/default.xqy" method="post" id="frmLogin" name="frmLogin">
						<div class="box">
							<div class="boxtop"></div>
							<div class="boxbg">
								<div class="textheading1">Username </div>
								<div class="formfield1">
									<input class="textfield" id="login" name="login" size="25" tabindex="1" type="text" value="" />
								</div>
								<script>
									<![CDATA[
										var login1 = new LiveValidation('login');
										login1.add( Validate.Presence, { failureMessage: "Provide a username!" } );
									]]>
								</script>
								<div class="height10"></div>
								<div class="textheading1">Password </div>
								<div class="formfield1">
									<input class="textfield" id="password" name="password" size="30" type="password" tabindex="2"/>
									<script>
										<![CDATA[
											var pwd = new LiveValidation('password');
											pwd.add( Validate.Presence, { failureMessage: "Provide a password!" } );
										]]>
									</script>
								</div>
								<div class="height7"></div>
								<div class="textheading1">&nbsp;</div>
								<div class="forgotpassword green11-normal"> <a href="/candidate/register">New Candidate?</a> </div>
								<div class="height3"></div>
								<input type="hidden" name="validate" value="1" />
								<input type="hidden" name="candidate" value="1" />
								<div class="height3"></div>
								<div class="textheading1">&nbsp; </div>
								<div class="formfield1">
									<input type="image" src="/images/login.gif" alt="Login"  tabindex="3" id="submit-candidate"/>
								</div>
								<div class="height3"></div>
								<div class="clearer"></div>
							</div>
							<div class="boxbottom"></div>
							<div class="clearer"></div>
						</div>
					</form>	
				</div>


				<div id="employee" style="display:none;">
					<form action="/default.xqy" method="post" id="frmEmpLogin" name="frmEmpLogin">
						<div class="box">
							<div class="boxtop"></div>
							<div class="boxbg">
								<div class="textheading1">Employer Name </div>
								<div class="formfield1">
									<input class="textfield" id="emp-login" name="emp-login" size="25" tabindex="1" type="text" value="" />
									<script>
										<![CDATA[
											var login2 = new LiveValidation('emp-login');
											login2.add( Validate.Presence, { failureMessage: "Provide a employer username!" } );
										]]>
									</script>
								</div>
								<div class="height10"></div>
								<div class="textheading1">Employer Password </div>
								<div class="formfield1">
									<input class="textfield" id="emp-password" name="emp-password" size="30" type="password" tabindex="2"/>
									<script>
										<![CDATA[
											var pwd2 = new LiveValidation('emp-password');
											pwd2.add( Validate.Presence, { failureMessage: "Provide a employer password!" } );
										]]>
									</script>
								</div>
				  
								<div class="height7"></div>
								<div class="textheading1">&nbsp;</div>
								<div class="forgotpassword green11-normal"> <a href="/employer/new">New Employee?</a> </div>
								<div class="green11-normal">  </div>
								<div class="height3"></div>
								<input type="hidden" name="validate" value="1" />
								<input type="hidden" name="employer" value="1" />
								<div class="height3"></div>
								<div class="textheading1">&nbsp; </div>
								<div class="formfield1">
									<input type="image" src="/images/login.gif" alt="Login"  tabindex="3" id="submit-candidate"/>
								</div>
								<div class="height3"></div>
								<div class="clearer"></div>
							</div>
							<div class="boxbottom"></div>
							<div class="clearer"></div>
						</div>
					</form>	
				</div>

				<div class="height15"></div>
			</div>
			<!--<div class="rightcol-login"><img src="/images/login-banner.jpg" alt="Banner" width="387" height="250" /> </div>-->
		</div>
		{glib:display-footer()}
	</div>	
</body>
</html>