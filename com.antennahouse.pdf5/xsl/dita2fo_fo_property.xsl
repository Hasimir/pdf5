<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    >

    <!-- 
         function:	Expand FO property into attribute()*
         param:		prmElem
         return:	Attribute node
         note:		XSL-FO attribute is authored in $prmElem/@fo in CSS notation.
                    2014-04-22 t.makita
    -->
    <xsl:function name="ahf:getFoProperty" as="attribute()*">
        <xsl:param name="prmElem" as="element()"/>
        
        <xsl:choose>
            <xsl:when test="$prmElem/@fo">
                <xsl:variable name="foAttr" as="xs:string" select="normalize-space(string($prmElem/@fo))"/>
                <xsl:for-each select="tokenize($foAttr, ';')">
                    <xsl:variable name="propDesc" select="normalize-space(string(.))"/>
                    <xsl:choose>
                        <xsl:when test="not(string($propDesc))"/>
                        <xsl:when test="contains($propDesc,':')">
                            <xsl:variable name="propName" as="xs:string">
                                <xsl:variable name="tempPropName" as="xs:string" select="normalize-space(substring-before($propDesc,':'))"/>
                                <xsl:variable name="axfExt" as="xs:string" select="'axf-'"/>
                                <xsl:choose>
                                    <xsl:when test="starts-with($tempPropName,$axfExt)">
                                        <xsl:sequence select="concat('axf:',substring-after($tempPropName,$axfExt))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:sequence select="$tempPropName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>                            
                            <xsl:variable name="propValue" as="xs:string" select="normalize-space(substring-after($propDesc,':'))"/>
                            <xsl:choose>
                                <!--"castable as xs:NAME" can be used only in Saxon PE or EE.
                                    If $propName does not satisfy above, xsl:attribute instruction will be faild!
                                    2014-04-22 t.makita
                                 -->
                                <!--xsl:when test="$propName castable as xs:NAME"-->
                                <xsl:when test="true()">
                                    <xsl:attribute name="{$propName}" select="$propValue"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message select="'[getFoAttribute 002F] Property value is invalid. Property=''',$propName,''' @xtrc=',string($prmElem/@xtrc),' @xtrf=',string($prmElem/@xtrf)"/>
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message select="'[getFoAttribute 001F] Missing '':'' in style description. @fo=''',$foAttr,''' @xtrc=',string($prmElem/@xtrc),' @xtrf=',string($prmElem/@xtrf)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
         function:	Expand FO property into attribute()*
                    Replacing text() with given parameters ($prmSrc, $prmDst).
         param:		prmElem,$prmSrc,$prmDst
         return:	Attribute node
         note:		XSL-FO attribute is authored in $prmElem/@fo in CSS notation.
                    2014-04-22 t.makita
    -->
    <xsl:function name="ahf:getFoPropertyReplacing" as="attribute()*">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:param name="prmSrc" as="xs:string+"/>
        <xsl:param name="prmDst" as="xs:string+"/>
        
        <xsl:choose>
            <xsl:when test="$prmElem/@fo">
                <xsl:variable name="foAttr" as="xs:string" select="normalize-space(string($prmElem/@fo))"/>
                <xsl:for-each select="tokenize($foAttr, ';')">
                    <xsl:variable name="propDesc" select="normalize-space(string(.))"/>
                    <xsl:choose>
                        <xsl:when test="not(string($propDesc))"/>
                        <xsl:when test="contains($propDesc,':')">
                            <xsl:variable name="propName" as="xs:string">
                                <xsl:variable name="tempPropName" as="xs:string" select="normalize-space(substring-before($propDesc,':'))"/>
                                <xsl:variable name="axfExt" as="xs:string" select="'axf-'"/>
                                <xsl:choose>
                                    <xsl:when test="starts-with($tempPropName,$axfExt)">
                                        <xsl:sequence select="concat('axf:',substring-after($tempPropName,$axfExt))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:sequence select="$tempPropName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>                            
                            <xsl:variable name="propValue" as="xs:string" select="normalize-space(substring-after($propDesc,':'))"/>
                            <xsl:choose>
                                <!--"castable as xs:NAME" can be used only in Saxon PE or EE.
                                    If $propName does not satisfy above, xsl:attribute instruction will be faild!
                                    2014-04-22 t.makita
                                 -->
                                <!--xsl:when test="$propName castable as xs:NAME"-->
                                <xsl:when test="true()">
                                    <xsl:variable name="propReplaceResult" as="xs:string" select="ahf:replace($propValue,$prmSrc,$prmDst)"/>
                                    <xsl:attribute name="{$propName}" select="$propReplaceResult"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message select="'[getFoPropertyReplacing 002F] Property value is invalid. Property=''',$propName,''' @xtrc=',string($prmElem/@xtrc),' @xtrf=',string($prmElem/@xtrf)"/>
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message select="'[getFoPropertyReplacing 001F] Missing '':'' in style description. @fo=''',$foAttr,''' @xtrc=',string($prmElem/@xtrc),' @xtrf=',string($prmElem/@xtrf)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>