<#macro header file>
<#local nested_brief><#nested ></#local>
#/******************************************************************************
  # @file    ${ toFileName(file) }
  # @author  Motor Control SDK Team, STMicroelectronics
  # @brief   ${ toBrief(nested_brief) }
  #
  #*****************************************************************************
  # @attention
  #
  # Copyright (c) 2019 STMicroelectronics International N.V.
  # All rights reserved.
  #
  # Redistribution and use in source and binary forms, with or without
  # modification, are permitted, provided that the following conditions are met:
  #
  # 1. Redistribution of source code must retain the above copyright notice,
  #    this list of conditions and the following disclaimer.
  # 2. Redistributions in binary form must reproduce the above copyright notice,
  #    this list of conditions and the following disclaimer in the documentation
  #    and/or other materials provided with the distribution.
  # 3. Neither the name of STMicroelectronics nor the names of other
  #    contributors to this software may be used to endorse or promote products
  #    derived from this software without specific written permission.
  # 4. This software, including modifications and/or derivative works of this
  #    software, must execute solely and exclusively on microcontroller or
  #    microprocessor devices manufactured by or for STMicroelectronics.
  # 5. Redistribution and use of this software other than as permitted under
  #    this license is void and will automatically terminate your rights under
  #    this license.
  #
  # THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS"
  # AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT
  # LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  # PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
  # RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT
  # SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  # INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  # LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
  # OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  # LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  # EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  #
  #*****************************************************************************
  #/
</#macro>

<#function toFileName txt>
    <#return txt[0..*txt?length-4]>
</#function>
<#function toBrief txt>
    <#return split_it(67, txt)?join("\n  #          ")>
</#function>

<#import "support/fp.ftl" as fp >
<#function _join xs>
    <#return xs?join("")>
</#function>
<#function _chunk w str>
    <#return fp.map( _join , _str2seq( str )?chunk( w ) )>
</#function>
<#function _str2seq txt>
    <#local sep="-äêïõú-">
    <#local xs=txt?replace("", sep)?split(sep)>
    <#return xs[1..*(xs?size-2)]>
</#function>

<#function _splitter(ctx, acc, p)>
    <#local   w = ctx.w
    sep = ctx.sep>

    <#local l  = acc.l!"" >
    <#local ls = acc.ls![] >

    <#if ( l?length + sep?length + p?length ) lte w >
        <#return acc + { "l" : l?has_content?then([l,p]?join(sep), p) }>
    <#else>
        <#return {"ls": ls + [l], "l": p  } >
    </#if>
</#function>
<#function split_it(w, str, strict=false)>
    <#local ps = str?word_list >

    <#local ctx = {"w": w,  "sep": " "}>
    <#local acc = {"l": "",  "ls": [] }>

    <#local spl = fp.foldl_ctx(ctx, _splitter
    , acc
    , strict?then(fp.flatMap_ctx(w, _chunk, ps), ps)
    )>
    <#return spl.ls + [spl.l]>
</#function>
