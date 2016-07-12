xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "../lib/employer-lib.xqy";
import module namespace clib = "http://amityadav.name/candidate-lib" at "../lib/candidate-lib.xqy";
declare namespace cd="http://amityadav.name/candidates";
declare namespace emp="http://amityadav.name/employers";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(elib:is-login())) then
	(:Redirect to the login page if not logged in:)		
	xdmp:redirect-response("/default.xqy") 		
else if(xdmp:get-request-field("jid") and xdmp:get-request-field("edit")) then
		(:Edit the job:)
		(
			let $job := elib:get-job-details(xdmp:get-request-field("jid"))
			return

			elib:edit-job($job, fn:normalize-space(xdmp:get-request-field("title")),
								  xdmp:get-session-field("jid"),
								  xdmp:get-request-field("experience"),
								  fn:normalize-space(xdmp:get-request-field("skills")),
								  fn:normalize-space(xdmp:get-request-field("summary"))),
			xdmp:set-session-field("message", "Job updated successfully"),
			xdmp:redirect-response("/employer/jobs") 
		)
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
	{
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
		
		{
			if (xdmp:get-request-field("jid")) then 

		<div class="centercol" style="min-width:550px; min-height:450px;" id="central_content_div_pannel">
				<div class="leftcol1">
					<div class="topheading">
					<div class="floatleft bold"> 
						Edit Job
					</div>			
				</div>
				<div class="height11"></div>
				
				<div class="floatright">
					<div class="button1">
						<a href="javascript:void(0);" onclick="document.frmEditJob.submit();" title="Update Job" class="aero send_message">
							<span>Save</span>
						</a> 
						
						<a href="/employer/jobs" title="Cancel" class="aero cancel_btn">
							<span>Cancel</span>
						</a> 
					</div>
				</div>
				<div class="height3"></div>

				<div class="box">
					<div class="boxtop"></div>
					
						{
							let $job := elib:get-job-details(xdmp:get-request-field("jid"))
							return
							if($job) then
								<div class="profile">
									<form name="frmEditJob" id="frmEditJob" action="/employer/job/edit" method="post">
										<span class="green1">Job description</span>
										<div class="height5"/>
										<div class="textheading1">Job Title *</div>
										<div class="formfield2">
											<input class="textfield required validate-alpha" id="title" name="title" size="30" type="text" value="{$job/emp:title/text()}" />
										</div>
										
										<div class="height7"/>
										<div class="textheading1">Skills *</div>
										<div class="formfield2">
											<input class="textfield required validate-alpha" id="skills" name="skills" size="30" type="text" value="{
												for $skill in $job/emp:skills
												return elib:print-skill($skill)
											}" /><h5 class="green" style="margin-top:0px;">Use "," to separate different skills</h5>
										</div>

										<div class="clearer"/>
										<div class="textheading1">Experience (Years)*</div>
										<div class="formfield2">
											<input class="textfield required validate-alpha" id="experience" name="experience" size="30" type="text" value="{$job/emp:experience/text()}" />
										</div>

										<div class="height7"/>
										<div class="textheading1">Summary</div>
										<div class="formfield2">
											<textarea class="textarea" id="summary" name="summary" cols="30" rows="10">{$job/emp:summary/text()} </textarea>
										</div>

										<div class="height7"/>
										<div class="height20"/>
										<input type="hidden" name="jid" value="{xdmp:get-request-field('jid')}" />
										<input type="hidden" name="edit" value="1" />
									</form>
								</div>
							else () 
						}
					
					<div class="boxbottom"></div>
					<div class="clearer"></div>
				</div>
				
				<div class="height11"></div>
				<div class="floatright">
					<div class="button1">
						<a href="javascript:void(0);" onclick="document.frmEditJob.submit();" title="Update Job" class="aero send_message">
							<span>Save</span>
						</a> 
						
						<a href="/employer/jobs" title="Cancel" class="aero cancel_btn">
							<span>Cancel</span>
						</a> 
					</div>
				</div>
				<div class="height20"/>
			</div>
			
			<div class="rightcol1">
				<div class="box">
					<div class="boxtop"></div>
					<div class="boxbg">
						<div class="textheading1">
							<div class="green1">
								Company Profile 
								<a href="/employer/profile" title="View Company Profile" class="none">
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
									elib:get-employer-details(xdmp:get-session-field("emp-id"))/emp:login/text(),
									<br/>,
									elib:get-employer-details(xdmp:get-session-field("emp-id"))/emp:email/text()
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
			else ()
			}
			<div class="height20"/>
		{glib:display-footer()}
	</div>
	}
</body>
<script>
	//Live validation scripts for checking the form entry
	<![CDATA[
		var company = new LiveValidation('title');
		company.add( Validate.Presence, { failureMessage: "Provide jobs title!" } );
		
		var experience = new LiveValidation('experience');
		experience.add( Validate.Numericality );

		var skills = new LiveValidation('skills');
		skills.add( Validate.Presence, { failureMessage: "Provide skills required!" } );

	]]>
</script>
</html>