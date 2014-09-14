<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Generate bookmark tree.
Copyright © 2009-2012 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf">
 
    <!-- 
     function:	Generate bookmark tree
     param:		none
     return:	fo:bookmark-tree
     note:		none
     -->
    <xsl:template name="genBookmarkTree">
    	<fo:bookmark-tree>
    		<xsl:apply-templates select="$map" mode="MAKE_BOOKMARK"/>
    	</fo:bookmark-tree>
    </xsl:template>
    
    <!-- 
     function:	General templates for bookmark
     param:		none
     return:	
     note:		none
     -->
    <xsl:template match="*" mode="MAKE_BOOKMARK">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="MAKE_BOOKMARK"/>
    
    <xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" mode="MAKE_BOOKMARK"/>
    
    <!-- 
     function:	Frontmatter
     param:		none
     return:	see below
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/frontmatter ')]" mode="MAKE_BOOKMARK" priority="2" >
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
        
    <!-- 
     function:	Frontmatter/bookabstract templates
     param:		none
     return:	see below
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/bookabstract ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/bookabstract ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <!-- 
     function:	Colophon templates
     param:		none
     return:	see below
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/colophon ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/colophon ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
        
    <!-- 
     function:	Booklists templates
     param:		none
     return:	see below
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/booklists ')]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
        
    <!-- 
     function:	Abbrevlist
     param:		none
     return:	see below
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/abbrevlist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/abbrevlist ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
        
    <!-- 
     function:	Bibliolist
     param:		none
     return:	see below
     note:		
     -->
     <xsl:template match="*[contains(@class,' bookmap/bibliolist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/bibliolist ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
        
    <!-- 
     function:	Booklist
     param:		none
     return:	see below
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/booklist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/booklist ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
        
    <!-- 
     function:	Figure list
     param:		none
     return:	Figurelist link
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/figurelist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/figurelist ')][empty(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
        <xsl:if test="$figureExists">
            <xsl:variable name="topicRef" as="element()" select="."/>
            <xsl:variable name="id" as="xs:string" select="string(ahf:getIdAtts($topicRef,$topicRef,true())[1])"/>
            <xsl:call-template name="genBookmark">
                <xsl:with-param name="prmTopicRef" select="$topicRef"/>
                <xsl:with-param name="prmDefaultTitle" select="$cFigureListTitle"/>
                <xsl:with-param name="prmInternalDest" select="$id"/>
                <xsl:with-param name="prmProcessChild" select="false()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
        
    <!-- 
     function:	Glossary list
     param:		none
     return:	glossary list contents
     note:		
    -->
    <xsl:template match="*[contains(@class,' bookmap/glossarylist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/glossarylist ')][empty(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
        <xsl:if test="child::*[contains(@class, ' map/topicref ')][exists(@href)]">
            <xsl:call-template name="genGlossaryListBookMark"/>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:	Index
     param:		none
     return:	Index contents
     note:		This template will not be executed because this plug-in treats index in frontmatter as error.
                2012-03-29 t.makita
     -->
    <xsl:template match="*[contains(@class,' bookmap/indexlist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/indexlist ')][empty(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:if test="$indextermSortedCount gt 0">
            <xsl:variable name="topicRef" as="element()" select="."/>
            <xsl:variable name="id" as="xs:string" select="string(ahf:getIdAtts($topicRef,$topicRef,true())[1])"/>
            <xsl:call-template name="genBookmark">
                <xsl:with-param name="prmTopicRef" select="$topicRef"/>
                <xsl:with-param name="prmDefaultTitle" select="$cIndexTitle"/>
                <xsl:with-param name="prmInternalDest" select="$id"/>
                <xsl:with-param name="prmProcessChild" select="false()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
        
    <!-- 
     function:	Table list
     param:		none
     return:	Table list content
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/tablelist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/tablelist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
        <xsl:if test="$tableExists">
            <xsl:variable name="topicRef" as="element()" select="."/>
            <xsl:variable name="id" as="xs:string" select="string(ahf:getIdAtts($topicRef,$topicRef,true())[1])"/>
            <xsl:call-template name="genBookmark">
                <xsl:with-param name="prmTopicRef" select="."/>
                <xsl:with-param name="prmDefaultTitle" select="$cTableListTitle"/>
                <xsl:with-param name="prmInternalDest" select="$id"/>
                <xsl:with-param name="prmProcessChild" select="false()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
        
    <!-- 
     function:	Trademark list
     param:		none
     return:	none
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/trademarklist ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/trademarklist ')][not(@href)]" mode="MAKE_BOOKMARK" priority="2" >
    </xsl:template>
        
    <!-- 
     function:	Table of content
     param:		none
     return:	toc contents
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/toc ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/toc ')][empty(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:variable name="topicRef" as="element()" select="."/>
        <xsl:variable name="id" as="xs:string" select="string(ahf:getIdAtts($topicRef,$topicRef,true())[1])"/>
        <xsl:call-template name="genBookmark">
            <xsl:with-param name="prmTopicRef" select="."/>
            <xsl:with-param name="prmDefaultTitle" select="$cTocTitle"/>
            <xsl:with-param name="prmInternalDest" select="$id"/>
            <xsl:with-param name="prmProcessChild" select="false()"/>
        </xsl:call-template>
    </xsl:template>
        
    <!-- 
     function:	Dedication templates
     param:		none
     return:	descendant topic contents
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/dedication ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/dedication ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
        
    <!-- 
     function:	Draftintro templates
     param:		none
     return:	descendant topic contents
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/draftintro ')]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
        
    <!-- 
     function:	Notices templates
     param:		none
     return:	descendant topic contents
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/notices ')]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match>
            <xsl:with-param name="prmDefaultTitle" select="$cNoticeTitle"/>
        </xsl:next-match>
    </xsl:template>
        
    
    <!-- 
     function:	Preface templates
     param:		none
     return:	descendant topic contents
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/preface ')]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match>
            <xsl:with-param name="prmDefaultTitle" select="$cPrefaceTitle"/>
        </xsl:next-match>
    </xsl:template>
        
    <!-- 
     function:	Frontmatter
     param:		none
     return:	descendant topic contents
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/backmatter ')]" mode="MAKE_BOOKMARK" priority="2" >
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <!-- 
     function:	Amendments templates
     param:		none
     return:	
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/amendments  ')][empty(@href)]" mode="MAKE_BOOKMARK" priority="2">
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/amendments ')][exists(@href)]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    <!-- backmatter/booklists: Same as frontmatter -->
    <!-- backmatter/colophon:  Same as frontmatter -->
    <!-- backmatter/dedication:Same as frontmatter -->
    <!-- backmatter/notices:   Same as frontmatter -->
    
    
    <!-- 
     function:	Part templates
     param:		none
     return:	
     note:		
     -->
    <xsl:template match="*[contains(@class,' bookmap/part ')]" mode="MAKE_BOOKMARK" priority="2">
        <xsl:next-match/>
    </xsl:template>
    
    
    <!-- Appendices
         Changed to generate no title because appendice is only a wrapper of appendix in bookmap.
         2014-09-14 t.makita
     -->
     <xsl:template match="*[contains(@class,' bookmap/appendices ')][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
         <xsl:apply-templates mode="#current"/>
         <!--xsl:variable name="topicRef" as="element()" select="."/>
         <xsl:call-template name="genBookmark">
             <xsl:with-param name="prmTopicRef" select="$topicRef"/>
             <xsl:with-param name="prmDefaultTitle" select="$cAppendicesTitle"/>
             <xsl:with-param name="prmInternalDest" select="''"/>
             <xsl:with-param name="prmProcessChild" select="true()"/>
         </xsl:call-template-->
     </xsl:template>
    
    <!-- Ignore reltable contents -->
    <xsl:template match="*[contains(@class,' map/reltable ')]" mode="MAKE_BOOKMARK" />
    
    <!-- 
     function:	General topiref template for bookmark
     param:		none
     return:	fo:bookmark
     note:		
     -->
    <xsl:template match="*[contains(@class,' map/topicref ')][not(ahf:isToc(.))]" mode="MAKE_BOOKMARK"/>
            
    <xsl:template match="*[contains(@class,' map/topicref ')][ahf:isToc(.)]" mode="MAKE_BOOKMARK">
        <xsl:param name="prmDefaultTitle" as="xs:string" required="no" select="''"/>
        
        <!--xsl:message>[topicref] href="<xsl:value-of select="@href"/>"</xsl:message-->
        <xsl:variable name="topicRef" select="."/>
        <xsl:variable name="id">
            <xsl:choose>
                <xsl:when test="@href">
                    <xsl:value-of select="substring-after(@href, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="linkContent" select="if (string($id)) then key('topicById',$id)[1] else ()"/>
        <xsl:variable name="oid" select="if (empty($linkContent)) then () else ahf:getIdAtts($linkContent,$topicRef,true())" as="attribute()*"/>
        <xsl:variable name="topicRefId" select="ahf:getIdAtts($topicRef,$topicRef,true())" as="attribute()*"/>
        <xsl:variable name="hasNavtitle" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="$topicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:when test="$topicRef/@navtitle">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    
        <xsl:variable name="nestedTopicCount">
            <xsl:choose>
                <!-- Frontmatter -->
                <xsl:when test="ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ')]">
                    <xsl:value-of select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                                   [not(contains(@class, ' bookmap/frontmatter '))]
                                                                   )"/>
                </xsl:when>
                <!-- backmatter -->
                <xsl:when test="ancestor-or-self::*[contains(@class, ' bookmap/backmatter ')]">
                    <xsl:value-of select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                                   [not(contains(@class, ' bookmap/backmatter '))]
                                                                   )"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                                   [not(contains(@class, ' mapgroup-d/topicgroup '))]
                                                                   )"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    
        <xsl:variable name="addBookmark">
            <xsl:choose>
                <xsl:when test="$nestedTopicCount &gt; $cBookmarkNestMax">
                    <!-- Max nesting level = 4 --> 
                    <xsl:value-of select="$false"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$true"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    
        <!--xsl:message>[topicref] $addBookmark="<xsl:value-of select="$addBookmark"/>"</xsl:message-->
        
        <xsl:choose>
            <xsl:when test="$addBookmark = $false">
                <!-- Ignore this element and descendant. -->
            </xsl:when>
            <xsl:when test="exists($linkContent) or $hasNavtitle or string($prmDefaultTitle)">
                <!--xsl:comment>id=<xsl:value-of select="if exists($oid) then string($oid[1]) else ''"/></xsl:comment-->
                <fo:bookmark starting-state="{$cStartingState}">
                	<xsl:choose>
    	                <xsl:when test="exists($oid)">
    	                    <xsl:attribute name="internal-destination">
    	                        <!-- id is fixed to index 1. -->
    	                        <xsl:value-of select="string($oid[1])"/>
    	                    </xsl:attribute>
    	                </xsl:when>
    	                <xsl:otherwise>
    	                    <xsl:attribute name="internal-destination">
    	                        <!-- id is fixed to index 1. -->
    	                        <xsl:value-of select="string($topicRefId[1])"/>
    	                    </xsl:attribute>
    	                </xsl:otherwise>
                    </xsl:choose>
                    <fo:bookmark-title>
                        <xsl:call-template name="genTitle">
                            <xsl:with-param name="prmTopicRef" select="$topicRef"/>
                            <xsl:with-param name="prmDefaultTitle" select="$prmDefaultTitle"/>
                        </xsl:call-template>
                    </fo:bookmark-title>
                    <!-- Navigate to lower level -->
                    <xsl:apply-templates mode="#current"/>
                </fo:bookmark>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="#current"/>
            </xsl:otherwise>
        </xsl:choose>
    
    </xsl:template>
    
    <!-- 
     function:	Generate title of bookmark
     param:		prmTopicRef, prmDefaultTitle
     return:	title string
     note:		
     -->
    <xsl:template name="genTitle" as="text()*">
        <xsl:param name="prmTopicRef" required="yes" as="element()"/>
        <xsl:param name="prmDefaultTitle" as="xs:string" required="no" select="''"/>
        
        <!-- Who is my ancestor? -->
        <xsl:choose>
            <xsl:when test="$isBookMap">
                <xsl:choose>
                    <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ')]">
                        <!-- frontmatter -->
                        <xsl:call-template name="genBookmarkTitle">
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                            <xsl:with-param name="prmDefaultTitle" select="$prmDefaultTitle"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/backmatter ')]">
                        <!-- backmatter -->
                        <xsl:call-template name="genBookmarkTitle">
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                            <xsl:with-param name="prmDefaultTitle" select="$prmDefaultTitle"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/part ')]">
                        <!-- part -->
                        <xsl:call-template name="genPartDescendantTitle">
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/chapter ')]">
                        <!-- chapter -->
                        <xsl:call-template name="genChapterDescendantTitle">
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/appendix ')]">
                        <!-- appendix -->
                        <xsl:call-template name="genAppendixDescendantTitle">
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$prmTopicRef[contains(@class, ' bookmap/appendices ')]">
                        <!-- appendices -->
                        <xsl:call-template name="genBookmarkTitle">
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                            <xsl:with-param name="prmDefaultTitle" select="$prmDefaultTitle"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="genMapDescendantTitle">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:	Generate title of topic descendant of part
     param:		prmTopicRef
     return:	title string
     note:		none
     -->
    <xsl:template name="genPartDescendantTitle" as="text()*">
        <xsl:param name="prmTopicRef" required="yes" as="element()"/>
        <xsl:call-template name="genChapterDescendantTitle">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- 
     function:	Generate title of topic descendant of chapter
     param:		prmTopicRef
     return:	title string
     note:		none
     -->
    <xsl:template name="genChapterDescendantTitle" as="text()*">
        <xsl:param name="prmTopicRef" required="yes" as="element()"/>
        
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after($prmTopicRef/@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent" select="if ($prmTopicRef/@href) then key('topicById', $id)[1] else ()" as="element()?"/>
        
        <!-- Title prefix -->
        <xsl:variable name="titlePrefix" as="xs:string">
            <xsl:call-template name="genTitlePrefix">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- Title body -->
        <xsl:variable name="title" as="text()*">
            <xsl:choose>
                <xsl:when test="exists($topicContent)">
                    <xsl:apply-templates select="$topicContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                </xsl:when>
                <xsl:when test="$prmTopicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                    <xsl:apply-templates select="$prmTopicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]" mode="TEXT_ONLY"/>
                </xsl:when>
                <xsl:when test="$prmTopicRef/@navtitle">
                    <xsl:value-of select="$prmTopicRef/@navtitle"/>        
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Generate title -->
        <xsl:if test="$pAddNumberingTitlePrefix">
            <xsl:value-of select="$titlePrefix"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:copy-of select="$title"/>
    </xsl:template>
    
    <!-- 
     function:	Generate title of appendix ( and their descendant topic)
     param:		prmTopicRef
     return:	title text nodes
     note:		none
     -->
    <xsl:template name="genAppendixDescendantTitle" as="text()*">
        <xsl:param name="prmTopicRef" required="yes" as="element()"/>
        <xsl:call-template name="genChapterDescendantTitle">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- 
     function:	Generate title of topic descendant of map
     param:		prmTopicRef
     return:	title string
     note:		none
     -->
    <xsl:template name="genMapDescendantTitle" as="text()*">
        <xsl:param name="prmTopicRef" required="yes" as="element()"/>
        
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after($prmTopicRef/@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent" select="if ($prmTopicRef/@href) then key('topicById', $id)[1] else ()" as="element()?"/>

        <xsl:variable name="title" as="text()*">
            <xsl:call-template name="genBookmarkTitle">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmDefaultTitle" select="''"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="titlePrefix" as="xs:string">
            <xsl:call-template name="genTitlePrefix">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- Generate title -->
        <xsl:if test="$pAddNumberingTitlePrefix">
            <xsl:value-of select="$titlePrefix"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:copy-of select="$title"/>
    </xsl:template>
    
    <!-- 
     function:	Generate glossarylist bookmark
     param:		none
     return:	fo:bookmark
     note:		Current is booklists/glossarylist
    -->
    <xsl:template name="genGlossaryListBookMark">
        <xsl:variable name="topicRef" as="element()" select="."/>
        <xsl:variable name="id" as="xs:string" select="string(ahf:getIdAtts($topicRef,$topicRef,true())[1])"/>
        <fo:bookmark starting-state="{$cStartingState}">
            <xsl:attribute name="internal-destination" select="$id"/>
            <fo:bookmark-title>
                <xsl:call-template name="genBookmarkTitle">
                    <xsl:with-param name="prmTopicRef" select="."/>
                    <xsl:with-param name="prmDefaultTitle" select="$cGlossaryListTitle"/>
                </xsl:call-template>
            </fo:bookmark-title>
            <!-- Process child topicref -->
            <xsl:choose>
                <xsl:when test="$pSortGlossEntry">
                    <!-- Original glossentry nodeset -->
                    <xsl:variable name="glossEntries" as="document-node()">
                        <xsl:document>
                            <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="MAKE_BOOKMARK_TOPICREF_IN_TEMPORARY_TREE">
                            </xsl:apply-templates>
                        </xsl:document>
                    </xsl:variable>
                    <!-- Sorted glossentry nodeset -->
                    <xsl:variable name="glossEntrySorted" as="document-node()">
                        <xsl:document>
                            <xsl:for-each select="$glossEntries/*[contains(@class, ' glossentry/glossentry ')]">
                                <xsl:sort lang="{$documentLang}" select="@sortkey"/>
                                <xsl:element name="{name()}">
                                    <xsl:copy-of select="@*"/>
                                    <xsl:attribute name="label" select="upper-case(substring(string(@sortkey),1,1))"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:document>
                    </xsl:variable>
                    <!-- Format the sorted glossentry -->
                    <xsl:for-each select="$glossEntrySorted/*[contains(@class,' glossentry/glossentry ')]">
                        <xsl:variable name="glossEntry" select="."/>
                        <xsl:variable name="topicRefId" select="string($glossEntry/@topicRefId)" as="xs:string"/>
                        <!--xsl:variable name="topicRef" select="key('topicrefByGenerateId',$topicRefId)" as="element()*"/-->
                        <xsl:variable name="topicRef" select="$map//*[contains(@class, 'map/topicref')][ahf:generateId(.,()) eq $topicRefId][1]" as="element()?"/>
                        <!--xsl:message select="'$editStatus=',$editStatus,'$topicRefId=',$topicRefId,'class=',@class"/-->
                        <xsl:choose>
                            <xsl:when test="exists($topicRef)">
                                <xsl:variable name="oid" select="ahf:getIdAtts($glossEntry,$topicRef,true())" as="attribute()*"/>
                                <fo:bookmark starting-state="{$cStartingState}">
                                    <xsl:choose>
                                        <xsl:when test="exists($oid)">
                                            <xsl:attribute name="internal-destination">
                                                <!-- id is fixed to index 1. -->
                                                <xsl:value-of select="string($oid[1])"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                    <fo:bookmark-title>
                                        <xsl:value-of select="$glossEntry/@glossterm"/>
                                    </fo:bookmark-title>
                                </fo:bookmark>
                            </xsl:when>
                            <xsl:otherwise> 
                                <xsl:call-template name="errorExit">
                                    <xsl:with-param name="prmMes" 
                                        select="ahf:replace($stMes079,('%id','%file'),(string($topicRefId),string(@xtrf)))"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="MAKE_BOOKMARK"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:bookmark>
    </xsl:template>
    
    <!-- 
        function:	Process topicref of the glossary list for sorting
        param:		none
        return:	    glossentry topic
        note:		none
    -->
    <xsl:template match="*[contains(@class,' map/topicref ')][@href]" mode="MAKE_BOOKMARK_TOPICREF_IN_TEMPORARY_TREE">
        
        <xsl:variable name="topicRef" select="." as="element()"/>
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent" select="if (string($id)) then key('topicById', $id)[1] else ()" as="element()?"/>
        
        <xsl:choose>
            <xsl:when test="exists($topicContent)">
                <!-- Copy contents -->
                <xsl:apply-templates select="$topicContent" mode="MAKE_BOOKMARK_GLOSSENTRY_IN_TEMPORARY_TREE">
                    <xsl:with-param name="prmTopicRef" select="$topicRef"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes" 
                        select="ahf:replace($stMes070,('%href','%file'),(string(@href),string(@xtrf)))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" mode="MAKE_BOOKMARK_TOPICREF_IN_TEMPORARY_TREE">
        <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="#current"/>
    </xsl:template>
    
    <!-- Templates for sorting -->
    <xsl:template match="*[contains(@class,' glossentry/glossentry ')]" mode="MAKE_BOOKMARK_GLOSSENTRY_IN_TEMPORARY_TREE">
        <xsl:param name="prmTopicRef" as="element()" required="yes"/>
        
        <xsl:variable name="glossterm" as="xs:string">
            <xsl:variable name="tempGlossterm" as="xs:string*">
                <xsl:apply-templates select="*[contains(@class,' glossentry/glossterm ')]" mode="TEXT_ONLY"/>
            </xsl:variable>
            <xsl:sequence select="string-join($tempGlossterm,'')"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="topicRefId" select="ahf:generateId($prmTopicRef,())"/>
            <xsl:attribute name="sortkey">
                <xsl:sequence select="$glossterm"/>
            </xsl:attribute>
            <xsl:attribute name="glossterm">
                <xsl:sequence select="$glossterm"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' glossgroup/glossgroup ')]" mode="MAKE_BOOKMARK_GLOSSENTRY_IN_TEMPORARY_TREE">
        <xsl:param name="prmTopicRef" as="element()" required="yes"/>
        
        <!-- glossgroup or glossentry -->
        <xsl:apply-templates select="*[contains(@class, ' glossgroup/glossgroup ')] | *[contains(@class, ' glossentry/glossentry ')]" mode="#current">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- 
     function:	Generate bookmark title for tablelist, glossarylist, figurelist, etc...
     param:		$prmTopicRef, $prmDefaultTitle
     return:	Text nodes
     note:		
    -->
    <xsl:template name="genBookmarkTitle" as="text()*">
        <xsl:param name="prmTopicRef" as="element()" required="yes"/>
        <xsl:param name="prmDefaultTitle" as="xs:string" required="yes"/>
    
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after($prmTopicRef/@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent" select="if ($prmTopicRef/@href) then key('topicById', $id)[1] else ()" as="element()?"/>
        
        <xsl:choose>
            <xsl:when test="exists($topicContent)">
                <xsl:apply-templates select="$topicContent/*[contains(@class,' topic/title ')]" mode="TEXT_ONLY"/>
            </xsl:when>
            <xsl:when test="$prmTopicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                <xsl:apply-templates select="$prmTopicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]" mode="TEXT_ONLY"/>
            </xsl:when>
            <xsl:when test="$prmTopicRef/@navtitle">
                <xsl:value-of select="string($prmTopicRef/@navtitle)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$prmDefaultTitle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
        function:	Generate bookmark for tablelist, glossarylist, figurelist, etc...
        param:		$prmTopicRef, $prmDefaultTitle, $prmInternalDest, $prmStartingState
        return:	    fo:bookmark
        note:		
    -->
    <xsl:template name="genBookmark">
        <xsl:param name="prmTopicRef" as="element()" required="yes"/>
        <xsl:param name="prmDefaultTitle" as="xs:string" required="yes"/>
        <xsl:param name="prmInternalDest" as="xs:string" required="yes"/>
        <xsl:param name="prmProcessChild" as="xs:boolean" required="no" select="false()"/>
        <xsl:param name="prmStartingState" as="xs:string" required="no" select="$cStartingState"/>
    
        <xsl:variable name="id" select="if ($prmTopicRef/@href) then substring-after($prmTopicRef/@href, '#') else ''" as="xs:string"/>
        <xsl:variable name="topicContent" select="if ($prmTopicRef/@href) then key('topicById', $id)[1] else ()" as="element()?"/>
        <xsl:variable name="oid" select="if (empty($topicContent)) then () else ahf:getIdAtts($topicContent,$prmTopicRef,true())" as="attribute()*"/>
        
        <xsl:variable name="title" as="node()">
            <xsl:choose>
                <xsl:when test="exists($topicContent)">
                    <xsl:apply-templates select="$topicContent/*[contains(@class,' topic/title ')]" mode="TEXT_ONLY"/>
                </xsl:when>
                <xsl:when test="$prmTopicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                    <xsl:apply-templates select="$prmTopicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]" mode="TEXT_ONLY"/>
                </xsl:when>
                <xsl:when test="$prmTopicRef/@navtitle">
                    <xsl:value-of select="string($prmTopicRef/@navtitle)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$prmDefaultTitle"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <fo:bookmark>
            <xsl:attribute name="starting-state" select="$prmStartingState"/>
            <xsl:choose>
                <xsl:when test="string($prmInternalDest)">
                    <xsl:attribute name="internal-destination" select="$prmInternalDest"/>
                </xsl:when>
                <xsl:when test="exists($oid) and exists($topicContent/*[contains(@class,' topic/body ')])">
                    <xsl:attribute name="internal-destination" select="string($oid[1])"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>    
            <fo:bookmark-title>
                <xsl:value-of select="$title"/>
            </fo:bookmark-title>
            <xsl:if test="$prmProcessChild">
                <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="MAKE_BOOKMARK"/>
            </xsl:if>        
        </fo:bookmark>
    </xsl:template>    

</xsl:stylesheet>