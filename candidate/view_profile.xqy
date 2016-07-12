xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "../lib/candidate-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "../lib/employer-lib.xqy";
declare namespace cd="http://amityadav.name/candidates";
declare namespace emp="http://amityadav.name/employers";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(clib:is-login()) and fn:not(elib:is-login())) then
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
			if(xdmp:get-session-field("user-id")) then 
				let $candidate := clib:get-candidate-details(xdmp:get-session-field("user-id"))
				return
				clib:display-candidate-header(fn:upper-case(if ($candidate/cd:lname and $candidate/cd:lname) then  (fn:concat($candidate/cd:fname/text()," ", $candidate/cd:lname/text())) else $candidate/cd:login/text()))
			else 
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
				<div class="box">
					<div class="boxtop"></div>
					
						{
							let $candidate:=clib:get-candidate-details(if(xdmp:get-session-field("user-id")) then xdmp:get-session-field("user-id") else xdmp:get-request-field("cid"))
							return
							if($candidate) then
								<div class="profile">
									{
										if(xdmp:get-session-field("user-id")) then 									
											<div class="float-right">
												<a href="/candidate/edit" class="bold">
													Edit Profile
												</a>
											</div>
										else ()
									}
									<span class="green1">Profile Information</span>
									{
										if(xdmp:get-session-field("user-id")) then 
											(<div class="height5"/>,
											<div class="textheading1">Username</div>,
											<div class="formfield2">{$candidate/cd:login/text()}</div>
											)
										else ()
									}									
									<div class="height7"/>
									<div class="textheading1">Name</div>
									<div class="formfield2">{$candidate/cd:fname/text(), " ", $candidate/cd:lname/text()}</div>

									<div class="height7"/>
									<div class="textheading1">Email</div>
									<div class="formfield2">{$candidate/cd:email/text()}</div>

									<div class="height7"/>
									<div class="textheading1">Resume Title</div>
									<div class="formfield2">{$candidate/cd:resume/cd:resume-title/text()}</div>

									<div class="height7"/>
									<div class="textheading1">Skills</div>
									<div class="formfield2">{$candidate/cd:resume/cd:skills/text()}</div>

									<div class="height7"/>
									<div class="textheading1">Experience</div>
									<div class="formfield2">{$candidate/cd:resume/cd:experience/text()}</div>

									<div class="height7"/>
									<div class="textheading1">Summary</div>
									<div class="formfield2">{$candidate/cd:resume/cd:summary/text()}</div>
									
									<div class="height7"/>
									<div class="textheading1">Last Updated</div>
									<div class="formfield2">
										{fn:adjust-date-to-timezone(xs:date(fn:adjust-dateTime-to-timezone($candidate/cd:date/text())))}
									</div>
									<div class="height7"/>
									
									<div class="textheading1"></div>
									<div class="formfield2">
										<div class="button1">
											<a class="aero buttons" href="javascript:void(0);" onclick="history.back();">
												<span>Back</span>
											</a> 
										</div>
									</div>
									<div class="height7"/>
									<div class="height20"/>
								</div>
							else ()
						}
					
					<div class="boxbottom"></div>
					<div class="clearer"></div>
				</div>
			</div>
			
			{
			if(xdmp:get-session-field("user-id")) then
			<div class="rightcol1">
				<div class="box">
					<div class="boxtop"></div>
					<div class="boxbg">
						<div class="textheading1">
							<div class="green1">
								My Profile 
								<a href="/candidate/profile" title="View Your Profile" class="none">
									View
								</a>
							</div>
								<div class="height7"></div>
								<div class="float-left">
									<img alt="_mg_9074" height="81" src="/images/default_team.gif" width="86" />
								</div>
								
								<div class="float-left margin-left">
									<div class="height20"></div>
									<div class="height20"></div>
									<div class="height20"></div>
								<div>
							</div>
						</div>
						<div class="clearer"></div>
						<div class="height5"></div>
						<div>
								{
									clib:get-candidate-details(xdmp:get-session-field("user-id"))/cd:login/text(),
									<br/>,
									clib:get-candidate-details(xdmp:get-session-field("user-id"))/cd:email/text(),
									<br/>,
									clib:get-candidate-details(xdmp:get-session-field("user-id"))/cd:resume/cd:resume-title/text()
								}
						</div>
						<div class="clearer"></div>
					  </div>
					  <div class="clearer"></div>
					</div>
					<div class="boxbottom"></div>
				  </div>
				</div>
				else ()
				}
			</div>
		{glib:display-footer()}
	</div>	
</body>
</html>