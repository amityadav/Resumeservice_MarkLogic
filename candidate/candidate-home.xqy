xquery version "1.0-ml";
(:
 : This library contains common function related to the header, footer and other common HTML blocks
 : 
 : Author:
 : Amit Yadav <amit.y@glballogic.com>
 : Date: 04 NOV 2009
:)

import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "../lib/candidate-lib.xqy";
declare namespace cd="http://amityadav.name/candidates";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(clib:is-login())) then
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
		
		{
			let $candidate := clib:get-candidate-details(xdmp:get-session-field("user-id"))
			return

			let $jobs := clib:get-matching-jobs(if(xdmp:get-request-field("q")) then xdmp:get-request-field("q") else $candidate/cd:resume/cd:skills)
			return
		<div class="centercol" style="min-width:550px; min-height:450px;" id="central_content_div_pannel">
			<div class="leftcol1">
				<div style="min-height:550px;">
				  <!--div start for welcome section -->
					<div class="welcome1">
						<div class="topheading">
							<div class="floatleft bold"> 
								Jobs Matching Your Skills
							</div>			
						</div>
						<div class="height11"></div>
						<div class="floatleft1">
							<span class="navyblue">
								<span class="selected" id="recieved_count">
									Jobs Count ({fn:count($jobs)})
								</span>
							</span>
						</div>
						<div class="height15"></div>
						<div class="height5"></div>
						<!--div start for mailbox  -->
						<div class="mailbox">
							<div class="box">
								<div class="boxtop"></div>
									<div class="profile" xmlns="http://www.w3.org/1999/xhtml">
											{
												if(fn:empty($jobs)) then
													<span>There are no jobs matching your skills</span>
												else
													<div xmlns="http://www.w3.org/1999/xhtml">
														<span class="fromheading bold">
															Title
														</span>
														<span class="subjectheading bold">
															Skills
														</span>
														<span class="dateheading bold">
															Date Posted
														</span>
														<span class="actionsheading bold">
															Experience
														</span>
														<div class="height5"></div>
														<div class="hr3"></div>
														<div class="height3"></div>

														{
															for $job in $jobs
															return clib:display-matching-jobs($job)
														}
												</div>
											}					
										<div class="clearer"></div>
									</div>
									<div class="boxbottom"></div>
									<div class="clearer"></div>
								</div>
							</div>
							<!--div End for mailbox -->

						</div>
						<div class="height15"></div>
						<!--div End for welcome section -->
						<div class="clearer"></div>
					</div>
				<div class="height15"></div>
			</div>
			
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
			</div>
			}
		{glib:display-footer()}
	</div>	
</body>

</html>