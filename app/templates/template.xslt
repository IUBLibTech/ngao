<?xml version="1.0" encoding="UTF-8"?>
<!--  This EAD stylesheet is reworked from the EAD Cookbook Style 6 and dsc1                 -->
<!--  an original copy can be found here:                                                    -->
<!--  https://github.com/saa-ead-roundtable/ead-stylesheets/tree/master/print-friendly-html  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<!-- Creates the body of the finding aid.-->
	<xsl:template match="/ead">
		<html>
			<!-- ****************************************************************** -->
			<!-- Outputs header information for the HTML document 			-->
			<!-- ****************************************************************** -->
			<head>
				<link rel="stylesheet" href="/assets/print.scss"/>
				<link rel="shortcut icon" type="image/x-icon" href="/assets/favicon.ico"/>
				<title>
					<xsl:apply-templates select="eadheader/filedesc/titlestmt/titleproper"/>
				</title>
			</head>


			<body class="ead-print">

				<div class="title-block">
					<h1 class="finding-aid-title">
						<xsl:apply-templates select="eadheader/filedesc/titlestmt/titleproper"/>
					</h1>

					<h2 class="finding-aid-subtitle">
						<xsl:apply-templates select="/ead/eadheader/filedesc/titlestmt/subtitle"/>
					</h2>

					<p class="finding-aid-author">
						<xsl:apply-templates select="eadheader/filedesc/titlestmt/author"/>
					</p>
				</div>

				<!--To change the order of display, adjust the sequence of
				the following apply-template statements which invoke the various
				templates that populate the finding aid. In several cases where
				multiple elements are displayed together in the output, a call-template
				statement is used -->

				<div class="archdesc-overview">
					<xsl:apply-templates select="archdesc/did"/>
				</div>

				<div class="archdesk-main">
					<xsl:apply-templates select="archdesc/bioghist"/>
					<xsl:apply-templates select="archdesc/scopecontent"/>
					<xsl:apply-templates select="archdesc/arrangement"/>
					<xsl:apply-templates select="archdesc/otherfindaid"/>
					<xsl:call-template name="archdesc-restrict"/>
					<xsl:apply-templates select="archdesc/separatedmaterial"/>
					<xsl:apply-templates select="archdesc/relatedmaterial"/>
					<xsl:apply-templates select="archdesc/controlaccess"/>
					<xsl:apply-templates select="archdesc/odd"/>
					<xsl:apply-templates select="archdesc/originalsloc"/>
					<xsl:apply-templates select="archdesc/phystech"/>
					<xsl:call-template name="archdesc-admininfo"/>
					<xsl:apply-templates select="archdesc/fileplan | archdesc/*/fileplan"/>
					<xsl:apply-templates select="archdesc/bibliography"/>
					<xsl:apply-templates select="archdesc/dsc"/>
					<xsl:apply-templates select="archdesc/index | archdesc/*/index"/>
				</div>
			</body>
		</html>
	</xsl:template>


	<!-- ************************************************************** -->
	<!-- DID processing:                                                -->
	<!-- This template creates a table for the top-level did, followed  -->
	<!-- by each of the did elements.  To change the order of 	        -->
	<!-- appearance of these elements, change the sequence here.		-->
	<!-- ************************************************************** -->

	<xsl:template match="archdesc/did">
		<div class="archdesc did">
			<table class="overview">
				<xsl:apply-templates select="origination"/>
				<xsl:apply-templates select="unittitle"/>
				<xsl:apply-templates select="unitid"/>
				<xsl:apply-templates select="unitdate[1]"/>
				<xsl:apply-templates select="physdesc"/>
				<xsl:apply-templates select="abstract"/>
				<xsl:apply-templates select="physloc"/>
				<xsl:apply-templates select="langmaterial"/>
				<xsl:apply-templates select="repository"/>
				<xsl:apply-templates select="materialspec"/>
				<xsl:apply-templates select="note"/>
			</table>
		</div>
	</xsl:template>


	<!-- ******************************************************************	-->
	<!-- Formats variety of text properties (bold, italic) from @RENDER     -->
	<!-- Also BLOCKQUOTE handling                                           -->
	<!-- ****************************************************************** -->

	<xsl:template match="p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="lb">
		<br/>
	</xsl:template>

	<!-- add whitespace between any two adjacent text() elements -->
	<!-- except for <head> elements which often get a colon added directly after -->
	<xsl:variable name="space" select="'&#x20;'"/>
	<xsl:template match="//*[name!='head']/text()">
		<xsl:value-of select="."/>
		<xsl:value-of select="$space"/>
	</xsl:template>

	<xsl:template match="blockquote">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

	<xsl:template match="blockquote/p">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

	<xsl:template match="emph[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="emph[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="emph[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<xsl:template match="emph[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match="emph[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>

	<xsl:template match="emph[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>

	<xsl:template match="title">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- LIST                                                               -->
	<!-- Formats a list anywhere except in ARRANGEMENT or REVISIONDESC.     -->
	<!-- Two values for attribute TYPE are implemented: "simple" gives      -->
	<!-- an indented list with no marker, "marked" gives an indented list   -->
	<!-- with each item bulleted, "ordered" gives a numbered list.          -->
	<!-- ****************************************************************** -->


	<xsl:template match="list[@type='ordered']">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match="list[@type='simple']">
		<ol class="no-bullets">
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match="list">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="list/item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="bibref">
		<li class="bibliography">
			<xsl:apply-templates select="node()"/>
		</li>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- TABLE                                                              -->
	<!-- Implements a very basic crosswalk of EAD <table> to HTML <table>   -->
	<!-- as of 2022/06/28, IU has only one collection that uses <table>,    -->
	<!-- see InU-Ar-VAA1616                                                 -->
	<!-- ****************************************************************** -->

	<xsl:template match="table">
		<table>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="thead">
		<thead>
			<xsl:apply-templates/>
		</thead>
	</xsl:template>

	<xsl:template match="tbody">
		<tbody>
			<xsl:apply-templates/>
		</tbody>
	</xsl:template>

	<xsl:template match="thead/row | tbody|row">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="entry">
		<td>
			<xsl:apply-templates/>
		</td>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- CHRONLIST                                                          -->
	<!-- Formats a chronology list with items                               -->
	<!-- ****************************************************************** -->

	<xsl:template match="chronlist">
		<table class="chronlist">
			<tbody>
				<xsl:apply-templates/>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="chronlist/head">
		<tr>
			<td colspan="2">
				<h4>
					<xsl:apply-templates/>
				</h4>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronlist/listhead">
		<tr>
			<td class="date">
				<b>
					<xsl:apply-templates select="head01"/>
				</b>
			</td>
			<td class="event">
				<b>
					<xsl:apply-templates select="head02"/>
				</b>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronitem">
		<tr>
			<td class="date">
				<xsl:apply-templates select="date"/>
			</td>
			<td class="event">
				<xsl:apply-templates select="event | eventgrp"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronitem/eventgrp">
		<xsl:for-each select="*">
			<xsl:apply-templates/>
			<br/>
		</xsl:for-each>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- TITLEPROPER and SUBTITLE are output                                -->
	<!-- ****************************************************************** -->

	<!-- suppress <num> nodes from titles -->
	<xsl:template match="eadheader/filedesc/titlestmt/titleproper">
		<xsl:apply-templates select="node()[name() != 'num']"/>
	</xsl:template>

	<!-- suppress other <titleproper> nodes if there is a filing node -->
	<xsl:template match="titleproper[count(//titleproper[@type='filing']) >= 1 and not(@type='filing')]"/>

	<!-- suppress all but the first <titleproper> if there is not a filing node -->
	<xsl:template match="titleproper[count(//titleproper[@type='filing']) = 0 and position() > 1]"/>

	<xsl:template match="eadheader/filedesc/titlestmt/author">
		<xsl:if test="not(contains(text(), 'Finding'))">
			Finding aid created by
		</xsl:if>
		<xsl:apply-templates select="node()"/>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- COLLECTION INFO:                                                   -->
	<!-- This handles repository, origination, physdesc, abstract,unitid,   -->
	<!-- physloc and materialspec elements of archdesc/did which share a    -->
	<!-- common appearance.  Labels are also generated; to change the label -->
	<!-- generated for these sections, modify the text below.               -->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/did/repository
	| archdesc/did/origination
	| archdesc/did/unittitle
	| archdesc/did/unitdate
	| archdesc/did/physdesc
	| archdesc/did/unitid
	| archdesc/did/physloc
	| archdesc/did/abstract
	| archdesc/did/langmaterial
	| archdesc/did/materialspec">

		<!-- ****************************************************************** -->
		<!-- Tests for @LABEL.  If @LABEL is present it is used, otherwise      -->
		<!-- a label is supplied (to alter supplied text, make change below).   -->
		<!-- ****************************************************************** -->

		<tr>
			<td class="did-label">
				<xsl:choose>
					<!-- Use @label if it exists -->
					<xsl:when test="@label">
						<xsl:value-of select="@label"/>
						<xsl:text>:</xsl:text>
					</xsl:when>

					<!--Otherwise, use default label based on the node type  -->
					<xsl:when test="self::unittitle">
						<xsl:text>Title:</xsl:text>
					</xsl:when>
					<xsl:when test="self::repository">
						<xsl:text>Repository:</xsl:text>
					</xsl:when>
					<xsl:when test="self::origination">
						<xsl:text>Creator:</xsl:text>
					</xsl:when>
					<xsl:when test="self::physdesc">
						<xsl:text>Quantity:</xsl:text>
					</xsl:when>
					<xsl:when test="self::physloc">
						<xsl:text>Location:</xsl:text>
					</xsl:when>
					<xsl:when test="self::unitid">
						<xsl:text>Collection No.:</xsl:text>
					</xsl:when>
					<xsl:when test="self::unitdate">
						<xsl:text>Dates:</xsl:text>
					</xsl:when>
					<xsl:when test="self::abstract">
						<xsl:text>Abstract:</xsl:text>
					</xsl:when>
					<xsl:when test="self::langmaterial">
						<xsl:text>Language:</xsl:text>
					</xsl:when>
					<xsl:when test="self::materialspec">
						<xsl:text>Technical:</xsl:text>
					</xsl:when>

					<!-- Include an easily searchable fail-over label in case we missed any node types -->
					<xsl:otherwise>
						<xsl:text>ID Section:</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="did-value">
				<xsl:apply-templates/>
			</td>
		</tr>
	</xsl:template>

	<!-- ****************************************************************** -->
	<!-- UNITDATE                                                           -->
	<!-- Concatenate all <unitdate> sibling nodes & display @type           -->
	<!-- ****************************************************************** -->

	<xsl:template match="unitdate/child::text()">
		<xsl:for-each select="parent::node()/../unitdate">
			<!-- display type if there are additional unitdate nodes -->
			<xsl:if test="position() != 1 and @type!='inclusive'">
				<xsl:value-of select="@type"/>
				<xsl:value-of select="$space"/>
			</xsl:if>

			<!-- display the unitdate -->
			<xsl:value-of select="."/>

			<!-- separate multiple entries with a comma -->
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$space"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- ARCHDESC Processing                                                -->
	<!-- Formats the top-level bioghist, scopecontent, phystech, odd, and   -->
	<!-- arrangement elements and creates a link back to the top of the     -->
	<!-- page after the display of the element.  Each HEAD element is also  -->
	<!-- given a generated ID so it can be linked to from the TOC.          -->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/bioghist |
		archdesc/scopecontent |
		archdesc/phystech |
		archdesc/odd   |
		archdesc/arrangement |
		archdesc/separatedmaterial |
		archdesc/relatedmaterial |
		archdesc/controlaccess |
		archdesc/otherfindaid |
		archdesc/originalsloc |
		archdesc/fileplan |
		archdesc/dsc |
		archdesc/index">
		<div>
			<xsl:attribute name="class">archdesc-section
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="archdesc/bibliography">
		<div>
			<xsl:attribute name="class">archdesc-section
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<xsl:apply-templates select="head"/>
			<ul class="bibliography">
				<xsl:apply-templates select="*[name()!='head']"/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="archdesc/*/head">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<!-- ****************************************************************** -->
	<!-- Controlled Access headings                                         -->
	<!-- Formats controlled access headings.  Does NOT handle recursive 	-->
	<!-- controlaccess elements. Does NOT require HEAD elements (makes for	-->
	<!-- easier tagging), instead captions are generated.  Subelements      -->
	<!-- (genreform, etc) do not need to be alphabetized or sorted by type, -->
	<!-- the style sheet handles this.                                      -->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/controlaccess">
		<div class="archdesc-section controlaccess">
			<h3>Subject Headings</h3>
			<ul class="subject-headings">
				<xsl:for-each select=".">
					<xsl:if test="persname | famname">
						<li class="subj-label">
							<h5>Persons</h5>
							<ul class="subj-values">
								<xsl:for-each select="famname | persname">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
					<xsl:if test="corpname">
						<li class="subj-label">
							<h5>Corporate Bodies</h5>
							<ul class="subj-values">
								<xsl:for-each select="corpname">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
					<xsl:if test="title">
						<li class="subj-label">
							<h5>Associated Titles</h5>
							<ul class="subj-values">
								<xsl:for-each select="title">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
					<xsl:if test="subject">
						<li class="subj-label">
							<h5>Subjects</h5>
							<ul class="subj-values">
								<xsl:for-each select="subject">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
					<xsl:if test="geogname">
						<li class="subj-label">
							<h5>Places</h5>
							<ul class="subj-values">
								<xsl:for-each select="geogname">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
					<xsl:if test="genreform">
						<li class="subj-label">
							<h5>Genres and Forms</h5>
							<ul class="subj-values">
								<xsl:for-each select="genreform">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
					<xsl:if test="occupation | function">
						<li class="subj-label">
							<h5>Occupationss</h5>
							<ul class="subj-values">
								<xsl:for-each select="occupation | function">
									<xsl:sort select="." data-type="text" order="ascending"/>
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:for-each>
							</ul>
						</li>
					</xsl:if>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- Access and Use Restriction processing                              -->
	<!-- Inclused processing of any NOTE child elements.                    -->
	<!-- ****************************************************************** -->

	<xsl:template name="archdesc-restrict">
		<xsl:if test="string(archdesc/userestrict/*)
		or string(archdesc/accessrestrict/*)">
			<div class="archdesc-section restrict">
				<h3>
					<xsl:text>Restrictions</xsl:text>
				</h3>

				<div class="accessrestrict">
					<xsl:apply-templates select="archdesc/accessrestrict"/>
				</div>

				<div class="userrestrict">
					<xsl:apply-templates select="archdesc/userestrict"/>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="archdesc//accessrestrict/head |
			     archdesc//userestrict/head">
		<h4><xsl:apply-templates/>:
		</h4>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- Other Admin Info processing                                        -->
	<!-- Inclused processing of any other administrative information        -->
	<!-- elements and consolidates them into one block under a common       -->
	<!-- heading, "Administrative Information."  If child elements contain  -->
	<!-- a HEAD element it is retained and used as the section title.       -->
	<!-- ****************************************************************** -->

	<xsl:template name="archdesc-admininfo">
		<xsl:if test="string(archdesc/admininfo/custodhist/*)
		or string(archdesc/altformavail/*)
		or string(archdesc/prefercite/*)
		or string(archdesc/acqinfo/*)
		or string(archdesc/processinfo/*)
		or string(archdesc/appraisal/*)
		or string(archdesc/accruals/*)
		or string(archdesc/*/custodhist/*)
		or string(archdesc/*/altformavail/*)
		or string(archdesc/*/prefercite/*)
		or string(archdesc/*/acqinfo/*)
		or string(archdesc/*/processinfo/*)
		or string(archdesc/*/appraisal/*)
		or string(archdesc/*/accruals/*)">
			<div class="archdesc-section admininfo">
				<h3>
					<xsl:text>Administrative Information</xsl:text>
				</h3>

				<xsl:apply-templates select="archdesc/custodhist
				| archdesc/*/custodhist"/>
				<xsl:apply-templates select="archdesc/altformavail
				| archdesc/*/altformavail"/>
				<xsl:apply-templates select="archdesc/prefercite
				| archdesc/*/prefercite"/>
				<xsl:apply-templates select="archdesc/acqinfo
				| archdesc/*/acqinfo"/>
				<xsl:apply-templates select="archdesc/processinfo
				| archdesc/*/processinfo"/>
				<xsl:apply-templates select="archdesc/admininfo/appraisal
				| archdesc/*/appraisal"/>
				<xsl:apply-templates select="archdesc/admininfo/accruals
				| archdesc/*/accruals"/>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//eadheader/revisiondesc/list/item">
		<xsl:choose>
			<xsl:when test="not(position()=last())">
				<xsl:apply-templates/>;
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="custodhist/head
		| archdesc/altformavail/head
		| archdesc/prefercite/head
		| archdesc/acqinfo/head
		| archdesc/processinfo/head
		| archdesc/appraisal/head
		| archdesc/accruals/head
		| archdesc/*/custodhist/head
		| archdesc/*/altformavail/head
		| archdesc/*/prefercite/head
		| archdesc/*/acqinfo/head
		| archdesc/*/processinfo/head
		| archdesc/*/appraisal/head
		| archdesc/*/accruals/head">
		<p class="subhead-1">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- INVENTORY LIST PROCESSING	<dsc> & <cxx>                           -->
	<!-- Now we get into the actual box/folder listings			            -->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/dsc">
		<div class="archdesc-section dsc">
			<h3>
				<xsl:choose>
					<xsl:when test="dsc/head">
						<xsl:value-of select="head"/>
					</xsl:when>
					<xsl:otherwise>
						Collection Inventory
					</xsl:otherwise>
				</xsl:choose>
			</h3>
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- This section of the stylesheet contains named templates that are	-->
	<!-- used generically throughout the stylesheet.			-->
	<!-- ****************************************************************** -->

	<!-- This template formats the unitid, origination, unittitle, unitdate,-->
	<!-- and physdesc elements of components at all levels.  They appear on -->
	<!-- a separate line from other did elements. It is generic to all 	-->
	<!-- component levels.							-->

	<xsl:template name="component-did">
		<xsl:if test="unitid">
			<xsl:apply-templates select="unitid"/>
			<xsl:text>&#x20;</xsl:text>
		</xsl:if>


		<!-- Handles cases where unitdate is a child of unittitle or separate child of did.-->
		<xsl:choose>
			<!-- unitdate is a child of unittitle -->
			<xsl:when test="unittitle/unitdate">
				<xsl:apply-templates select="unittitle/text()| unittitle/*"/>
			</xsl:when>

			<!-- unitdate is not a child of untititle, date and title are processed
            IN THE ORDER THEY OCCUR IN THE ORIGINAL, so we can have some series
            that are organized by date. -->
			<xsl:otherwise>
				<xsl:for-each select="unitdate|unittitle">
					<xsl:apply-templates/>
					<xsl:text>&#x20;</xsl:text>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

		<!--Inserts abstract, on same line as date/title, separated with dash.-->
		<xsl:if test="abstract">
			-
			<xsl:apply-templates select="abstract"/>
			<xsl:text>&#x20;</xsl:text>
		</xsl:if>


		<!--Inserts origination and a space if it exists in the markup.-->
		<xsl:if test="origination">
			<xsl:if test="origination/@label">
				<br/>
				<xsl:value-of select="origination/@label"/>
			</xsl:if>
			<xsl:apply-templates select="origination"/>
			<xsl:text></xsl:text>
		</xsl:if>

		<xsl:if test="../phystech">
			(<xsl:value-of select="../phystech"/>)
		</xsl:if>

		<xsl:apply-templates select="physdesc"/>

		<xsl:if test="physloc">
			<br/>
			<xsl:apply-templates select="physloc"/>
		</xsl:if>

	</xsl:template>


	<!-- These templates handle notes and tables within other elements.
                 Can be called from anywhere -->

	<xsl:template name="special-handling">
		<xsl:choose>
			<xsl:when test="self::head">
				<b>
					<xsl:apply-templates/>
				</b>
			</xsl:when>
			<xsl:when test="parent::note | self::note">
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="special-handling-did">
		<xsl:choose>
			<xsl:when test="parent::note">
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- Adds parens around extent elements except for the first entry in archdesc/did -->
	<xsl:template match="extent | physfacet">
		<xsl:choose>
			<xsl:when test="ancestor::did and position() = 1">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				(<xsl:apply-templates/>)
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- This template handles the labeling of containers.  Note limitations on @type. -->

		<xsl:template name="container-label">
	
			<!--The next two variables define the set of container types that
			may appear in the first column of a two column container list.
			Add or subtract container types to fix institutional practice.-->
	
			<xsl:variable name="first" select="container[@type='Box' or 'Package' or 'SC' or @type='Oversize' or @type='Volume' or @type='Carton' or @type='Map-Case']"/>  
			<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or 'Package' or 'SC' or @type='Oversize' or @type='Volume' or @type='Carton' or @type='Map-Case']"/>
	
			<!--This variable defines the set of container types that
			may appear in the second column of a two column container list.
			Add or subtract container types to fix institutional practice.-->
	
			<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Tape' or @type='Page' or @type='Drawer']"/>
			<tr>
				<td valign="top">
					<b><font face="arial" size="-1"> 
						<xsl:if test="$first">
						   <xsl:value-of select="$first/@type"/>
						   <xsl:text> </xsl:text> 
						</xsl:if>
						<xsl:value-of select="$first"/>
						<xsl:if test="$second">
							<xsl:if test="$first">
								<xsl:text>, </xsl:text>
							</xsl:if>
						   <xsl:value-of select="$second/@type"/> 
						   <xsl:text> </xsl:text> 
						</xsl:if>
						<xsl:value-of select="$second"/>
					</font></b>
				</td>
				<xsl:variable name="c0parent" select="name(..)"/>
				<xsl:choose>
					<xsl:when test="$c0parent='c02'">
						<td></td>
						<td valign="top" colspan="10"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c03'">
						<td></td><td></td>
						<td valign="top" colspan="9"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c04'">
						<td></td><td></td><td></td>
						<td valign="top" colspan="8"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c05'">
						<td></td><td></td><td></td><td></td>
						<td valign="top" colspan="7"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c06'">
						<td></td><td></td><td></td><td></td><td></td>
						<td valign="top" colspan="6"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c07'">
						<td></td><td></td><td></td><td></td><td></td><td></td>
						<td valign="top" colspan="5"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c08'">
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td valign="top" colspan="4"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c10'">
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td valign="top" colspan="3"><xsl:call-template name="component-did"/></td>
					</xsl:when>
					<xsl:when test="$c0parent='c9'">
						<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td valign="top" colspan="2"><xsl:call-template name="component-did"/></td>
					</xsl:when>
				</xsl:choose>
			</tr>
		</xsl:template>

		<!-- ****************************************************************** -->
		<!-- This section of the stylesheet creates an HTML table for each c01.	-->
		<!-- It then recursively processes each child component of the c01 by	-->
		<!-- calling a named template (next section) for that component level.	-->
		<!-- ****************************************************************** -->

	<xsl:template match="c01">
		<table class="dcs-components">
			<tr>
				<td class="container-id"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td width="4%"></td>
				<td></td>
			</tr>
			<!-- If there should be miscellaneous c01 components that are
			actually file descriptions with associated container data,
			process them in the same way as a c02 is done.   This assumes
			that in these situations there is no c03.-->
			<xsl:choose>
				<xsl:when test="@level='file'">
					<xsl:call-template name="c02-level-container"/>	
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="c01-level"/>	
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:for-each select="c02">
				
				<xsl:choose>
					<xsl:when test="@level='subseries' or @level='series'">
						<xsl:call-template name="c02-level-subseries"/>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="c02-level-container"/>	
					</xsl:otherwise>	
				</xsl:choose>

				<xsl:for-each select="c03">
					<xsl:call-template name="c03-level"/>

					<xsl:for-each select="c04">
						<xsl:call-template name="c04-level"/>	

						<xsl:for-each select="c05">
							<xsl:call-template name="c05-level"/>	

							<xsl:for-each select="c06">
								<xsl:call-template name="c06-level"/>	

								<xsl:for-each select="c07">
									<xsl:call-template name="c07-level"/>	

									<xsl:for-each select="c08">
										<xsl:call-template name="c08-level"/>	

										<xsl:for-each select="c09">
											<xsl:call-template name="c09-level"/>	

											<xsl:for-each select="c10">
												<xsl:call-template name="c10-level"/>	
											</xsl:for-each><!--Closes c10-->
										</xsl:for-each><!--Closes c09-->
									</xsl:for-each><!--Closes c08-->
								</xsl:for-each><!--Closes c07-->
							</xsl:for-each><!--Closes c06-->
						</xsl:for-each><!--Closes c05-->
					</xsl:for-each><!--Closes c04-->
				</xsl:for-each><!--Closes c03-->
			</xsl:for-each><!--Closes c02-->
		</table>
	</xsl:template>

		<!-- ****************************************************************** -->
		<!-- This section of the stylesheet contains a separate named template	-->
		<!-- for each component level.  The contents of each is identical	-->
		<!-- except for the spacing that is inserted to create the proper 	-->
		<!-- column display in HTML for each level. 				-->
		<!-- ****************************************************************** -->

	<xsl:template name="c01-level">
		<xsl:for-each select="did">
			<tr>
				<td></td>
				<td colspan="11" class="c01-head">	
					<xsl:call-template name="component-did"/>
				</td>
			</tr>
			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td colspan="10" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<!--This template creates a separate row for each child of
		the listed elements.-->
		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan
			| userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note
			| descgrp/*">

			<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td> </td>
					<td colspan="10">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c02 elements that have associated containers, for
	example when c02 is a file.-->
	<xsl:template name="c02-level-container">
		<xsl:for-each select="did">

		<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="9" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">

			<xsl:for-each select="*">
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="9">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c02 level components that do not have
	associated containers, for example if the c02 is a subseries.  The
	various subelements are all indented one column to the right of c01.-->
	<xsl:template name="c02-level-subseries">
		<xsl:for-each select="did">
			<tr>
				<td valign="top"></td><td></td>
				<td valign="top" colspan="10" class="c02-head">
					<xsl:call-template name="component-did"/>
				</td>
			</tr>
			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="9" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
			
			<xsl:for-each select="*">
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="9">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c03-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="8" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note |
			descgrp/*">

			<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="8">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c04 level components.-->
	<xsl:template name="c04-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="7" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
	
				<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="7">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c05-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="6" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">

				<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="6">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c06 components.-->
	<xsl:template name="c06-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="5" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note |
			descgrp/*">
			
			<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="5">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c07-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>


			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="4" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each> <!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">

			<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="4">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c08-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="3" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
			
			<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="3">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c09-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

			<xsl:for-each select="note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="2" valign="top">
						<xsl:call-template name="special-handling-did"/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement | fileplan |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
			
			<xsl:for-each select="*">
				<tr>
					<td> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="2">
						<xsl:call-template name="special-handling"/>
					</td>
				</tr>
			</xsl:for-each>			
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c10-level">
		<xsl:for-each select="did">

			<xsl:call-template name="container-label"/>

		</xsl:for-each>	<!--Closes the did.-->
	</xsl:template>

</xsl:stylesheet>