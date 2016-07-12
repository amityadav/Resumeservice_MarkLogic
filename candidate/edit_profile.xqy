xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "../lib/candidate-lib.xqy";
declare namespace cd="http://amityadav.name/candidates";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(clib:is-login())) then
	(:Redirect to the login page:)
	xdmp:redirect-response("/default.xqy") 		
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
<body>
	<div id="container">
		{
			let $candidate := clib:get-candidate-details(xdmp:get-session-field("user-id"))
			return
			
			clib:display-candidate-header(fn:upper-case($candidate/cd:login/text()))
		}
		<div class="height15"></div>
		{
			if (xdmp:get-session-field("message")) then
				(
					<h3>{xdmp:get-session-field("message")}</h3>,
					xdmp:set-session-field("message", ""),
					<div class="height15"></div>
				)
			else ()
		}
		
		
		<div class="centercol" style="min-width:550px; min-height:450px;" id="central_content_div_pannel">
			<div class="leftcol1">
				<div class="topheading">
					<div class="floatleft bold"> Messages </div>
					<div class="floatright1"></div>
				</div>
				
				<div class="height11"></div>
				<div class="floatleft1">
					<span class="green16">Edit Profile</span>
				</div>
				
				<div class="floatright">
					<div class="button1">
						<a href="javascript:void(0);" onclick="document.frmUpdateCandidate.submit();" title="Update Candidate Profile" class="aero send_message">
							<span>Save</span>
						</a> 
						
						<a href="/candidate/profile" title="Cancel" class="aero cancel_btn">
							<span>Cancel</span>
						</a> 
					</div>
				</div>
				<div class="height3"></div>

				<div class="box">
					<div class="boxtop"></div>
					<div class="profile"> 
						<div class="height5"></div>
						<div class="textheading1">
							<img alt="_mg_9074" height="77" src="/images/default_team.gif" width="86" />
						</div>
						<div class="formfield1">
							<div class="height20"></div>
							<div class="height13"></div>
							<div class="height20"></div>
						</div>
						<div class="height15"></div>
						<span class="green1">Profile Information</span>
						
						{
							let $candidate:=clib:get-candidate-details(xdmp:get-session-field("user-id"))
							return
							if($candidate) then
								<div>
									<form name="frmUpdateCandidate"  id="frmUpdateCandidate" method="post" action="/candidate/update">
										<div class="height5"></div>

										<div class="height7"></div>
										<div class="textheading1">Username </div>
										<div class="formfield1">
										  {fn:upper-case($candidate/cd:login/text())}
										</div>
										
										<div class="height7"></div>
										<div class="textheading1">First Name *</div>
										<div class="formfield1">
											<input class="textfield required validate-alpha" id="f_name" name="f_name" size="30" type="text" value="{$candidate/cd:fname/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Last Name *</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="l_name" name="l_name" size="30" type="text" value="{$candidate/cd:lname/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Email *</div>
										<div class="formfield1">
											<input class="textfield required validate-email" id="email" name="email" size="30" type="text" value="{$candidate/cd:email/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Resume Title </div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="resume_title" name="resume_title" size="30" type="text" value="{$candidate/cd:resume/cd:resume-title/text()}" />
										</div>


										<div class="height7"></div>
										<div class="textheading1">Experience (Years)*</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="experience" name="experience" size="30" type="text" value="{$candidate/cd:resume/cd:experience/text()}" />  
										</div>


										<div class="height7"></div>
										<div class="textheading1">Skills *</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="skills" name="skills" size="30" type="text" value="{$candidate/cd:resume/cd:skills/text()}" /><h5 class="green" style="margin-top:0px;">Use "," to separate different skills</h5>
										</div>


										<div class="height7"></div>
										<div class="textheading1">Summary</div>
										<div class="formfield1">
										  <textarea class="textarea" id="summary" name="summary" cols="30" rows="10"> {$candidate/cd:resume/cd:summary/text()}</textarea>
										</div>
									</form>
								</div>
							else ()
						}
						<div class="height7"></div>
						<div class="height15"></div>
						<div class="clearer"></div>
					</div>
					<div class="boxbottom"></div>
					<div class="clearer"></div>
				</div>

				<div class="height11"></div>
				<div class="floatright">
					<div class="button1">
						<a href="javascript:void(0);" onclick="document.frmUpdateCandidate.submit();" title="Update Candidate Profile" class="aero send_message">
							<span>Save</span>
						</a> 
						
						<a href="/candidate/profile" title="Cancel" class="aero cancel_btn">
							<span>Cancel</span>
						</a> 
					</div>
				</div>
				<div class="height3"></div>
			</div>
			
			<div class="rightcol1">
				
			</div>
			</div>
		{glib:display-footer()}
	</div>	
</body>

<script>
	//Live validation scripts for checking the form entry
	<![CDATA[
		var f_name = new LiveValidation('f_name');
		f_name.add( Validate.Presence, { failureMessage: "Provide First Name" } );

		var l_name = new LiveValidation('l_name');
		l_name.add( Validate.Presence, { failureMessage: "Provide Last Name!" } );

		var experience = new LiveValidation('experience');
		experience.add( Validate.Numericality );

		var skills = new LiveValidation('skills');
		skills.add( Validate.Presence, { failureMessage: "Provide your Skills!" } );
		
		var email = new LiveValidation('email');
		email.add( Validate.Presence, { failureMessage: "Email required!" } );
		email.add( Validate.Format, { pattern: /([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/i ,failureMessage: "Invalid email format!" } );
	]]>
</script>


</html>