module namespace glib = "http://amityadav.name/common-lib";
declare default function namespace "http://www.w3.org/2005/xpath-functions";



declare function glib:get-head-section()
{
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
		<title>{glib:get-title()}</title>
	</head>
};


declare function glib:get-title()
{
  (
    "Resume Service::For On-Demand People"
  )
};


(:Function for displaying the header of the page:)
declare function glib:display-header()
{
  (
	
	<div id="header">
		<div class="logo"><a href="#"><img src="/images/logo.gif" border="0" /><h2>Resume Service</h2></a></div>
		<div class="alliancelogo">&nbsp;</div>
		<div class="clearer"></div>
	</div>
  )
};


(:Function for displaying the footer of the page:)
declare function glib:display-footer()
{
  (
	
	<div id="footer">
		<div class="copyright"><a href="/privacy">Mark Logic Privacy Policy</a> <div class="height5"> </div>Copyright &copy;2009 Mark Logic</div>
	</div>
  )
};


(:Function for displaying the subheading of the page section:)
declare function glib:display-sub-header($sub-heading as xs:string)
{
	(
		<div class="topheading">
			<div class="floatleft bold"> {$sub-heading} </div>
			<div class="floatright1"></div>
		</div>
	)
};
