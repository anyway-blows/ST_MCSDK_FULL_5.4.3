<#--
<#function _map_ctx ctx, f ys xs>
    <#if xs?size == 0>
        <#return ys>
    <#else >
        <#local head = xs?first
                tail = xs[1..]  >
        <#return _map_ctx(ctx, f, ys + [f(ctx, head)], tail) >
    </#if>
</#function>
<#function map_ctx ctx f xs>
    <#return _map_ctx(ctx, f, [], xs) >
</#function>
-->

<#function map_ctx ctx f xs>
    <#return foldl(_f_map_ctx_, [ctx, f], xs)[2..] >
</#function>
<#function _f_map_ctx_ acc, item>
    <#return  acc + [ acc[1]( acc[0], item ) ] >
</#function>

<#function map_ctx2 ctx f xs>
    <#return foldl(_f_map_ctx2_, { "ctx": ctx, "f": f, "acc": [] }, xs).acc >
</#function>
<#function _f_map_ctx2_ fake_acc, item>
    <#return  fake_acc + { "acc" : fake_acc.acc + [ fake_acc.f(fake_acc.ctx, item) ] } >
</#function>




<#function _map f ys xs>
    <#if xs?size == 0>
        <#return ys>
    <#else >
        <#local head=xs?first tail=xs[1..]>
        <#return _map(f, ys + [f(head)], tail) >
    </#if>
</#function>

<#function map f xs>
    <#return _map(f, [], xs) >
</#function>



<#function _filter p ys xs>
    <#if xs?size == 0>
        <#return ys>
    <#else >
        <#local head=xs?first tail=xs[1..]>
        <#if p(head)>
            <#return _filter(p, ys + [head], tail) >
        <#else>
            <#return _filter(p, ys         , tail) >
        </#if>
    </#if>
</#function>

<#function filter p xs>
    <#return _filter(p, [], xs) >
</#function>



<#function foldl f acc xs >
<#-- f is the reducer function
     xs is the souce sequence
     acc is the accumulator
    -->
    <#if xs?size == 0>
        <#return acc>
    <#else >
        <#local head=xs?first tail=xs[1..]>
        <#return foldl(f, f(acc,head), tail) >
    </#if>
</#function>


<#function foldl_ctx ctx f acc xs >
<#-- f is the reducer function
     xs is the souce sequence
     acc is the accumulator
    -->
    <#if xs?size == 0>
        <#return acc>
    <#else >
        <#local head = xs?first
                tail = xs[1..]  >

        <#return foldl_ctx(ctx, f, f(ctx,acc,head), tail) >
    </#if>
</#function>





<#function concat acc x>
    <#return acc + x>
</#function>
<#function flatten xs>
    <#-- concat(acc, x) = acc + x -->
    <#return foldl(concat, [], xs)>
</#function>
<#function flatMap f xs>
    <#return flatten( map(f, xs) )>
</#function>

<#function flatMap_ctx ctx f xs>
    <#return flatten( map_ctx(ctx, f, xs) )>
</#function>


<#function groupBy field xs>
    <#return fp.foldl(__groupBy1, {"field": field, "acc": {}}, xs).acc >
</#function>
<#function __groupBy1 ctx item>
    <#local key = item[ctx.field]!"" >
    <#local xs = (ctx.acc[key])![] >
    <#return ctx + {"acc": ctx.acc + { key : xs + [item] } }>
</#function>

<#function groupBy_ctx ctx f xs>
    <#local domain = {"ctx": ctx, "f": f, "acc": {}} >
    <#return fp.foldl(__groupBy2, domain, xs).acc >
</#function>
<#function __groupBy2 domain item>
    <#local ctx = domain.ctx >
    <#local f   = domain.f   >
    <#local acc = domain.acc >

    <#local key = f(ctx, item) >

    <#-- list of items that already belongs to the group of this item -->
    <#local itemGroup = ((acc[key])![]) + [item] >
    <#local newAcc = acc + {key: itemGroup} >

    <#-- now I change only the accumulated groups, ctx and f will remain unchanged -->
    <#return domain + { "acc": newAcc } >
</#function>




<#function f_identity x>
    <#return (x?is_number || x?is_boolean)?then(x?c, x) >
</#function>

<#macro identity x>${ fp.f_identity(x) }</#macro>

<#function and x y>
    <#return x && y>
</#function>
<#function or x y>
    <#return x || y>
</#function>
<#function not x >
    <#return !x >
</#function>

<#function keys hash>
    <#return hash?keys >
</#function>
<#function values hash>
    <#return hash?values >
</#function>


<#function hash_to_seq hash>
    <#local xs = []>

    <#list hash as k,v>
        <#local xs = xs + [ [k,v] ] >
    </#list>

    <#return xs>

</#function>