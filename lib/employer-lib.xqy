xquery version "1.0-ml";
(:
 : This library contains functions that are used to manipulation at candidate side
 : 
 : Author:
 : Amit Yadav <amit.y@glballogic.com>
 : Date: 05 NOV 2009
:)

module namespace elib = "http://amityadav.name/employer-lib";
declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare namespace emp="http://amityadav.name/employers";
declare namespace cd="http://amityadav.name/candidates";
declare option xdmp:mapping "false";

declare variable $employer-dir := ( "/employers-data/" );
declare variable $employer-base :=( "/employers-data/employer" );
declare variable $emp-id  := ( "/employers-data/emp-ids.xml" );

declare variable $jobs-id  := ( "/jobs-data/jobs-ids.xml" );
declare variable $jobs-base :=( "/jobs-data/jobs" );

declare variable $candidate-base :=( "/candidates-data/candidates" );
declare variable $candidate-dir :=( "/candidates-data/" );

(:
	Check whether the employer is logged in to the system or not
:)
declare function elib:is-login()
{
	if(xdmp:get-session-field("employer")) then
		true()
	else
		false()
};



(:
	Function to display employer header
:)
declare function elib:display-employer-header($username)
{
	let $home :=
		if(xdmp:get-request-path() eq "/employer/dashboard.xqy") then 
		 "item_active"
		else ""
	return

	let $profile :=
		if((xdmp:get-request-path() eq "/employer/view_profile.xqy") or (xdmp:get-request-path() eq "/employer/edit_profile.xqy")) then 
		 "item_active"
		else ""
	return

	let $jobs := 
		if((xdmp:get-request-path() eq "/employer/jobs.xqy") or (xdmp:get-request-path() eq "/employer/view_job.xqy") or (xdmp:get-request-path() eq "/employer/create_job.xqy") or (xdmp:get-request-path() eq "/employer/edit_job.xqy")) then 
		 "item_active"
		else ""
	return
	
	<div id="header">
		<div class="logo">
			<a href="#">
				<img src="/images/logo.gif" border="0" />
				<h2>Resume Service</h2>
			</a>Welcome 
		</div>

		<div class="alliancelogo">
			<div class="floatright">
				<span class="bold">Search Candidates on Skills</span>
				<form action="/candidate/search.xqy" id="job_search" method="post">
					<input type="text" value="{xdmp:get-request-field('q')}" name="q" id="q" class="searchtextfield"/>
						<a onclick="$('job_search').submit();" href="javascript:void(0);">
							<img width="27" height="24" align="left" src="/images/icon-search.gif" alt="Search"/>
						</a>
						<br/>
						<script>
							<![CDATA[
								var search1 = new LiveValidation('q');
								search1.add( Validate.Presence, {faliureMessage: ""});
							]]>
						</script>
					<h5 style="margin-top:-10px;" class="green">Use "," to separate different skills</h5>
				</form>
			</div>
		</div>

		<div class="clearer"></div>
		<div id="tab">
			<ul>
				<li class="{$home}" ><a href="/employer/dashboard"><span class="tab-coach">Dashboard</span></a></li>
				<li class="{$profile}" ><a href="/employer/profile"><span class="tab-coach">Profile</span></a></li>
				<li class="{$jobs}" ><a href="/employer/jobs"><span class="tab-coach">Jobs</span></a></li>				
				<li><span class="tab-image-link"></span></li>	
			</ul>
		</div>
		<div class="floatright">
			<span class="green1">Welcome </span> <span class="blue">{$username}</span> &nbsp;| &nbsp;<a href="/employer/logout"><span class="black bold">Logout</span></a>
		</div>
		<div class="clearer"></div>
	</div>
};



(:
	Function to authenticate employer
:)
declare function elib:is-employer-registered($username as xs:string, $password)
{
  for $employer in xdmp:directory($employer-dir)//emp:employer[emp:login=$username and emp:password=$password]
  return

  if($employer/@id) then
  (
	(:Set the Employer in the session:)
		xdmp:set-session-field("employer", "1") ,
		xdmp:set-session-field("emp-id", $employer/@id),
	    true()
  )
  else
    false()
};



(:
	Function to calculate the next incremental id for the new employer record
:)
declare function elib:next-id() as xs:integer
{
  let $id := doc($emp-id)/id
  let $next-val :=
    if ($id castable as xs:integer) then xs:integer($id) + 1
    else 1
  let $next-node := <id>{$next-val}</id>
  let $insert :=
    if ($id) then xdmp:node-replace($id, $next-node)
    else xdmp:document-insert($emp-id, $next-node)
  return $next-val
};



(:
	Function to add the new employer details to the DB
:)
declare function elib:add-employer($login as xs:string,
                        $password as xs:string,
                        $company as xs:string,
                        $email as xs:string)
{
  if ($login = "") then error("Username missing") else
  if ($password = "") then error("Password cannot be blank") else
  if ($email = "") then error("Email cannot be blank") else

  let $employer-id := elib:next-id()
  let $new-employer := 
    <emp:employer id="{$employer-id}">
		<emp:login>{$login}</emp:login>
		<emp:password>{$password}</emp:password>
		<emp:email>{$email}</emp:email>
		<emp:company></emp:company>
		<emp:website></emp:website>
		<emp:address>
			<emp:address1></emp:address1>
			<emp:address2></emp:address2>
			<emp:street></emp:street>
			<emp:state></emp:state>
			<emp:country></emp:country>
			<emp:pin></emp:pin>
		</emp:address>
		<emp:date>{current-dateTime()}</emp:date>
    </emp:employer>

  let $insert := xdmp:document-insert($employer-base, <employers xmlns:emp="http://amityadav.name/employers">{doc($employer-base)//emp:employer, $new-employer}</employers>)
  return $new-employer
};



(: 
 :	Update a node with the specified elements 
 :  This function matches the old and the changed value
 :  and returns the modified node
 :)
declare function elib:update-node($root, $changes) {

  element { node-name($root) }
  { 
    $root/@*,

    for $ele in $root/*
      let $new := $changes[node-name(.) = node-name($ele)]
      return if (empty($new)) then $ele else $new
  }
};



(: 
	Function to update the employer profile data 
:)
declare function elib:update-employer-node($old-employer as element(emp:employer), 
						$company as xs:string,
						$emp_id as xs:string,
                        $email as xs:string,
                        $website as xs:string,
                        $address1 as xs:string,
                        $address2 as xs:string,
                        $street as xs:string,
                        $state as xs:string,
                        $country as xs:string,
                        $pin as xs:string) as element(emp:employer)
{
	let $updated-employer-node := elib:update-node($old-employer, (
			<emp:email>{$email}</emp:email>,
			<emp:company>{$company}</emp:company>,
			<emp:website>{$website}</emp:website>,
			(<emp:address>
				<emp:address1>{$address1}</emp:address1>
				<emp:address2>{$address2}</emp:address2>
				<emp:street>{$street}</emp:street>
				<emp:state>{$state}</emp:state>
				<emp:country>{$country}</emp:country>
				<emp:pin>{$pin}</emp:pin>
			</emp:address>),
			<emp:date>{current-dateTime()}</emp:date>
    ))

  let $replace := xdmp:node-replace($old-employer, $updated-employer-node)
  return $updated-employer-node

};



(: 
	Function returns the details for an employer given the id of the employer
:)
declare function elib:get-employer-details($id)
{
	if(fn:not(fn:empty($id))) then
	  for $employer in xdmp:directory($employer-dir)//emp:employer[@id=$id]
	  return $employer
	else ()
};




(:
	---------------------------------------------
			FUNCTION FOR MANAGING JOBS
	---------------------------------------------
:)

(: 
	Function returns the details of the job provided the id 
:)
declare function elib:get-job-details($id)
{
	if(fn:not(fn:empty($id))) then
		for $job in doc($jobs-base)//emp:job[@id=$id]
		return $job
	else ()
};



(:
	Function to calculate the next incremental id for the new job record
:)
declare function elib:next-job-id() as xs:integer
{
  let $id := doc($jobs-id)/id
  let $next-val :=
    if ($id castable as xs:integer) then xs:integer($id) + 1
    else 1
  let $next-node := <id>{$next-val}</id>
  let $insert :=
    if ($id) then xdmp:node-replace($id, $next-node)
    else xdmp:document-insert($jobs-id, $next-node)
  return $next-val
};



(: 
	Function adds new job to the application
:)
declare function elib:add-job($title as xs:string,
							  $employer-id as xs:string,
							  $experience as xs:string,
							  $skills as xs:string,
							  $summary as xs:string) as element (emp:job)
{
  if ($title = "") then error("Title Missing") else
  if ($experience = "") then error("Experience missing") else
  if ($skills = "") then error("Sillks missing") else

  let $job-id := elib:next-job-id()
  let $new-job := 
    <emp:job id="{$job-id}" comp-id="{$employer-id}">
		<emp:title>{$title}</emp:title>
		<emp:experience>{$experience}</emp:experience>
		<emp:skills>{for $skill in fn:tokenize($skills, ",")
		     return elib:skill-tag($skill)}</emp:skills>
		<emp:summary>{$summary}</emp:summary>
		<emp:date>{current-dateTime()}</emp:date>
    </emp:job>

  let $insert := xdmp:document-insert($jobs-base, <jobs xmlns:emp="http://amityadav.name/employers">{doc($jobs-base)//emp:job, $new-job}</jobs>)
  return $new-job
};


(: 
	Function to edit job details
:)
declare function elib:edit-job($old-job as element(emp:job), $title as xs:string,
							  $job-id,
							  $experience,
							  $skills as xs:string,
							  $summary as xs:string) as element (emp:job)
{
  if ($title = "") then error("Title Missing") else
  if ($experience = "") then error("Experience missing") else
  if ($skills = "") then error("Sillks missing") else

  let $updated-job-node := elib:update-node($old-job, (
		<emp:title>{$title}</emp:title>,
		<emp:experience>{$experience}</emp:experience>,
		<emp:skills>{for $skill in fn:tokenize($skills, ",")
		     return elib:skill-tag($skill)}</emp:skills>,
		<emp:summary>{$summary}</emp:summary>,
		<emp:date>{current-dateTime()}</emp:date>
    ))

  let $replace := xdmp:node-replace($old-job, $updated-job-node)
  return $updated-job-node

};



(:
	Function to create nods from the skills tag
:)
declare function elib:skill-tag($skill as xs:string) as element()
{
	<emp:skill>{fn:lower-case(fn:normalize-space($skill))}</emp:skill>
};



(:
	Function to update the job details
:)
declare function elib:update-job-node($old-job as element(emp:employer), 
								$title as xs:string,
								$experience as xs:string,
								$skills as xs:string,
								$summary as xs:string) as element(emp:employer)
{
	let $updated-job-node := elib:update-node($old-job, (
		<emp:title>{$title}</emp:title>,
		<emp:experience>{$experience}</emp:experience>,
		<emp:skills>{for $skill in fn:tokenize($skills, ",")
		return elib:skill-tag($skill)}</emp:skills>,
		<emp:summary>{$summary}</emp:summary>,
		<emp:date>{current-dateTime()}</emp:date>
    ))

  let $replace := xdmp:node-replace($old-job, $updated-job-node)
  return $updated-job-node

};



(: 
	Function to dialpay all the jobs listing
:)

declare function elib:display-employer-jobs($jobs as element(emp:job)) as element()* {
	<div class="" id="job-{$jobs/@id}"  xmlns="http://www.w3.org/1999/xhtml">
		<span class="fromheading navyblue-normal">
			<a href="/employer/job/{$jobs/@id}">
				{$jobs/emp:title/text()}
			</a>
		</span>
					
		<span class="subjectheading navyblue-normal">
				{
					for $skill in $jobs/emp:skills
					return elib:print-skill($skill)
				}
		</span> 
					
		<span class="dateheading black11">
			{fn:adjust-date-to-timezone(xs:date(fn:adjust-dateTime-to-timezone($jobs/emp:date/text())))}
		</span> 
					
		<span class="actionsheading">
			{$jobs/emp:experience/text()} Years
		</span>
		<div class="height5"></div>
		<div class="hr3"></div>
		<div class="height3"></div>
	</div>
};


(: 
	Function to dialpay candidate list
:)

declare function elib:display-candidates($candidate as element(cd:candidate)) as element()* {
	<div class="" id="candidate-{$candidate/@id}"  xmlns="http://www.w3.org/1999/xhtml">
		<span class="fromheading navyblue-normal">
			<a href="/candidate/profile/{$candidate/@id}">
				{$candidate/cd:fname/text()} {$candidate/cd:lname/text()}
			</a>
		</span>
					
		<span class="subjectheading navyblue-normal">
				{
					for $skill in fn:tokenize($candidate/cd:resume/cd:skills, ",")
					return (
								<a href="/candidate/search.xqy?q={$skill}">{fn:normalize-space($skill)}</a>,
								text {"  "}
							)
				}
		</span> 
					
		<span class="dateheading black11">
			{$candidate/cd:email/text()}
		</span> 
					
		<span class="actionsheading">
			{$candidate/cd:resume/cd:experience/text()} Years
		</span>
		<div class="height5"></div>
		<div class="hr3"></div>
		<div class="height3"></div>
	</div>
};



(: 
	Function to pint comma separated skills 
:)
declare function elib:print-skill($skills)
{
	for $skill  in $skills/emp:skill
    return 
        (
			<a href="/candidate/search.xqy?q={$skill/text()}">{fn:normalize-space($skill/text())}</a>,
			if (fn:not($skill/text() eq $skills/emp:skill[last()]/text())) then 
				text {', '}
			else 
				text { }
		)
};



(: 
	Function to pint comma separated skills without any link
:)
declare function elib:print-skill-plain($job)
{
    let $test :=( for $skill in $job/emp:skills/emp:skill return fn:normalize-space($skill/text()) )

    let $comma_sep_skills := 
	    <tt>
		{
			for $a at $index in $test
			return fn:concat( $a , if($index eq fn:count($test)) then () else ",")
		}
		</tt>/text()

	return $comma_sep_skills
};



(:
	Function to get the count of all the jobs for an employer
:)
declare function elib:get-employer-job-count($employer-id) as xs:integer {

   let $result:= doc($jobs-base)//emp:job[@comp-id = $employer-id]
   return fn:count($result)
};


(: 
	Function to get all the jobs by the company  
:)
declare function elib:get-employer-all-jobs() as element(emp:job)* {
	for $jobs in doc($jobs-base)//emp:job[@comp-id = xdmp:get-session-field("emp-id")]
	order by xs:dateTime($jobs/emp:job/emp:date)
	return $jobs
};




(:
	---------------------------------------------
	Function for jobs matching criteria
	---------------------------------------------
:)

(: 
	Function to get the matched candidate for a job 
:)

declare function elib:match-candidate-to-job($phrase) as element()* 
{

	
	cts:search(
		xdmp:directory($candidate-dir)//cd:candidate,
        cts:or-query((
				for $token in fn:tokenize($phrase, ",")
				return (
							cts:element-word-query(xs:QName("cd:resume-title"), fn:normalize-space($token)), 
							cts:element-word-query(xs:QName("cd:skills"), fn:normalize-space($token)), 
							cts:element-word-query(xs:QName("cd:summary"), fn:normalize-space($token))
						)
		))
	)
};