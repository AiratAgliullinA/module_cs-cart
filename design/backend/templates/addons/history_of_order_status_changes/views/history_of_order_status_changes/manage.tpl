{capture name="mainbox"}

{$page_title = __("orders_history.order_status_history")}
{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id=$smarty.request.content_id}
{$rev = $smarty.request.content_id|default:"pagination_contents"}

{$c_url = $config.current_url|fn_query_remove:"sort_by":"sort_order"}
{$c_icon = "<i class=\"icon-`$search.sort_order_rev`\"></i>"}
{$c_dummy = "<i class=\"icon-dummy\"></i>"}

{if $orders}
<div class="table-responsive-wrapper">
    <table width="100%" class="table table-middle table--relative table-responsive">
    <thead>
    <tr>
        <th width="17%"><a class="cm-ajax" href="{"`$c_url`&amp;sort_by=order_id&amp;sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("order_id")}{if $search.sort_by == "order_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="17%"><a class="cm-ajax" href="{"`$c_url`&amp;sort_by=old_status&amp;sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history.old_order_status")}{if $search.sort_by == "old_status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&amp;sort_by=status&amp;sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history.new_order_status")}{if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="20%"><a class="cm-ajax" href="{"`$c_url`&amp;sort_by=user_id&amp;sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history.user_name")}{if $search.sort_by == "user_id"}{$c_icon nofilter}{/if}</a></th>
        <th width="15%"><a class="cm-ajax" href="{"`$c_url`&amp;sort_by=date_changes&amp;sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history.date_changes")}{if $search.sort_by == "date_changes"}{$c_icon nofilter}{/if}</a></th>
    </tr>
    </thead>
    {foreach from=$orders item="o"}
    <tr>
        <td data-th="{__("order_id")}">
            <a href="{"orders.details?order_id=`$o.order_id`"|fn_url}" class="underlined">{__("order")}<bdi>#{$o.order_id}</bdi></a>
        </td>
        <td class="nowrap" data-th="{__("orders_history.old_order_status")}">{$o.old_status}</td>
        <td class="nowrap" data-th="{__("orders_history.new_order_status")}">{$o.status}</td>
        <td class="nowrap" data-th="{__("orders_history.user_name")}"><a href="{"profiles.update?user_id=`$o.user_id`"|fn_url}">{$o.user_name}</a></td>
        <td class="nowrap" data-th="{__("orders_history.date_changes")}">
            {$o.date_changes|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
        </td>
    </tr>
    {/foreach}
    </table>
</div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id=$smarty.request.content_id}

{/capture}

{include file="common/mainbox.tpl"
	title=$page_title
    content=$smarty.capture.mainbox
    content_id="manage_change_orders"
}