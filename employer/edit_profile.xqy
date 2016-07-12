xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "../lib/employer-lib.xqy";
declare namespace emp="http://amityadav.name/employers";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(elib:is-login())) then
	(:Redirect to the login page if not logged in:)		
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
			let $employer := elib:get-employer-details(xdmp:get-session-field("emp-id"))
			return
			
			elib:display-employer-header(fn:upper-case(if ($employer/emp:company) then  ($employer/emp:company/text()) else $employer/emp:login/text()))
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
					<div class="floatleft bold"> Edit Company Profile </div>
					<div class="floatright1"></div>
				</div>
				
				<div class="height11"></div>
				
				<div class="floatright">
					<div class="button1">
						<a href="javascript:void(0);" onclick="document.frmUpdateEmployer.submit();" title="Update Employer Profile" class="aero send_message">
							<span>Save</span>
						</a> 
						
						<a href="/employer/profile" title="Cancel" class="aero cancel_btn">
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
							let $employer := elib:get-employer-details(xdmp:get-session-field("emp-id"))
							return
							if($employer) then
								<div>
									<form name="frmUpdateEmployer"  id="frmUpdateEmployer" method="post" action="/employer/update">
										<div class="height5"></div>

										<div class="height7"></div>
										<div class="textheading1">Username </div>
										<div class="formfield1">
											{$employer/emp:login/text()}
										</div>
										
										<div class="height7"></div>
										<div class="textheading1">Company Name </div>
										<div class="formfield1">
											<input class="textfield required validate-alpha" id="company" name="company" size="30" type="text" value="{$employer/emp:company/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Email </div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="email" name="email" size="30" type="text" value="{$employer/emp:email/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Website </div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="website" name="website" size="30" type="text" value="{$employer/emp:website/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Address 1</div>
										<div class="formfield1">
											<input class="textfield required validate-email" id="address1" name="address1" size="30" type="text" value="{$employer/emp:address/emp:address1/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Address 2</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="address2" name="address2" size="30" type="text" value="{$employer/emp:address/emp:address2/text()}" />
										</div>


										<div class="height7"></div>
										<div class="textheading1">Street</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="street" name="street" size="30" type="text" value="{$employer/emp:address/emp:street/text()}" /> 
										</div>


										<div class="height7"></div>
										<div class="textheading1">State </div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="state" name="state" size="30" type="text" value="{$employer/emp:address/emp:state/text()}" />
										</div>


										<div class="height7"></div>
										<div class="textheading1">Country</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="country" name="country" size="30" type="text" value="{$employer/emp:address/emp:country/text()}" />
										</div>

										<div class="height7"></div>
										<div class="textheading1">Pin</div>
										<div class="formfield1">
										  <input class="textfield required validate-alpha" id="pin" name="pin" size="30" type="text" value="{$employer/emp:address/emp:pin/text()}" />
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
						<a href="javascript:void(0);" onclick="document.frmUpdateEmployer.submit();" title="Update Employer Profile" class="aero send_message">
							<span>Save</span>
						</a> 
						
						<a href="/employer/profile" title="Cancel" class="aero cancel_btn">
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
		var company = new LiveValidation('company');
		company.add( Validate.Presence, { failureMessage: "Company required!" } );

		var email = new LiveValidation('email');
		email.add( Validate.Presence, { failureMessage: "Email required!" } );
		email.add( Validate.Format, { pattern: /([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/i ,failureMessage: "Invalid email format!" } );
	]]>
</script>


</html>