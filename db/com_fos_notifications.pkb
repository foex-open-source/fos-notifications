create or replace package body com_fos_notifications
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  This plug-in lets you easily create notification messages in APEX using
--  jQuery Toastr Notifications
--
--  License: MIT
--
--  Github: https://github.com/foex-open-source/fos-notifications
--
-- =============================================================================
--
function render
    ( p_dynamic_action apex_plugin.t_dynamic_action
    , p_plugin         apex_plugin.t_plugin
    )
return apex_plugin.t_dynamic_action_render_result
as
    l_result apex_plugin.t_dynamic_action_render_result;

    -- general attributes
    l_notification_type     p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_message_type          p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    l_static_title          p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
    l_static_message        p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    l_js_title_code         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;
    l_js_message_code       p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    l_options               p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;
    l_escape                boolean                            := instr(p_dynamic_action.attribute_07,'escape-html') > 0;
    l_client_substitutions  boolean                            := instr(p_dynamic_action.attribute_07,'substitutions-clientside') > 0;
    l_advanced_setup        boolean                            := instr(p_dynamic_action.attribute_07,'advanced-setup') > 0;
    l_auto_dismiss          boolean                            := instr(p_dynamic_action.attribute_07,'auto-dismiss') > 0;
    l_inline_item_error     boolean                            := instr(p_dynamic_action.attribute_07,'page-item-inline-error') > 0;
    l_method                apex_t_varchar2                    := apex_string.split(case when l_advanced_setup then p_dynamic_action.attribute_14 else p_plugin.attribute_04 end, '-');
    l_show_method           p_dynamic_action.attribute_14%type := case when l_method.count = 2 then l_method(1) else 'fadeIn' end;
    l_hide_method           p_dynamic_action.attribute_14%type := case when l_method.count = 2 then l_method(2) else 'fadeOut' end;
    l_easing                apex_t_varchar2                    := apex_string.split(case when l_advanced_setup then p_dynamic_action.attribute_15 else p_plugin.attribute_05 end, '-');
    l_show_easing           p_dynamic_action.attribute_15%type := case when l_easing.count = 2 then l_easing(1) else 'swing' end;
    l_hide_easing           p_dynamic_action.attribute_15%type := case when l_easing.count = 2 then l_easing(2) else 'linear' end;
    l_show_duration         pls_integer                        := nvl(case when l_advanced_setup then p_dynamic_action.attribute_09 else p_plugin.attribute_06 end, '500');
    l_hide_duration         pls_integer                        := nvl(case when l_advanced_setup then p_dynamic_action.attribute_10 else p_plugin.attribute_07 end, '1000');
    l_timeout               pls_integer                        := case l_auto_dismiss when true then nvl(case when l_advanced_setup then p_dynamic_action.attribute_11 else p_plugin.attribute_02 end, '5000') else '0' end;
    l_extend_timeout        pls_integer                        := case l_auto_dismiss when true then nvl(case when l_advanced_setup then p_dynamic_action.attribute_13 else p_plugin.attribute_03 end, '5000') else '0' end;
    l_position_class        p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;
    l_page_items            p_dynamic_action.attribute_08%type := case when p_dynamic_action.attribute_12 != 'Y' then p_dynamic_action.attribute_12 end;
    l_init_js_fn            varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), 'undefined');

begin

    -- debug info
    if apex_application.g_debug then
        apex_plugin_util.debug_dynamic_action
            ( p_plugin         => p_plugin
            , p_dynamic_action => p_dynamic_action
            );
    end if;

    -- define our JSON config
    apex_json.initialize_clob_output;
    apex_json.open_object;

    -- notification plugin settings
    apex_json.write('type'             , l_notification_type);
    apex_json.write('substituteValues' , l_client_substitutions);
    apex_json.write('autoDismiss'      , l_auto_dismiss);
    apex_json.write('removeToasts'     , instr(l_options, 'remove-notifications') > 0);

    -- notification toastr settings
    apex_json.open_object('options');
    apex_json.write('debug'            , v('DEBUG') != 'NO');
    apex_json.write('showEasing'       , l_show_easing);
    apex_json.write('hideEasing'       , l_hide_easing);
    apex_json.write('showMethod'       , l_show_method);
    apex_json.write('hideMethod'       , l_hide_method);
    apex_json.write('showDuration'     , l_show_duration);
    apex_json.write('hideDuration'     , l_hide_duration);
    apex_json.write('timeOut'          , l_timeout);
    apex_json.write('extendedTimeOut'  , l_extend_timeout);
    apex_json.write('positionClass'    , l_position_class);
    apex_json.write('tapToDismiss'     , instr(l_options, 'tap-to-dismiss') > 0);
    apex_json.write('closeButton'      , instr(l_options, 'close-button') > 0);
    apex_json.write('newestOnTop'      , instr(l_options, 'newest-on-top') > 0);
    apex_json.write('progressBar'      , instr(l_options, 'progress-bar') > 0);
    apex_json.write('preventDuplicates', instr(l_options, 'prevent-duplicates') > 0);
    apex_json.write('escapeHtml'       , l_escape);
    apex_json.close_object;

    -- additional error information for page items
    apex_json.write('inlineItemErrors' , l_inline_item_error);
    if l_inline_item_error then
        apex_json.write('inlinePageItems', trim(both ',' from trim(l_page_items)));
    end if;

    -- notification message
    if l_message_type =  'static' then
        apex_json.write('title'        , case when l_client_substitutions then l_static_title   else apex_plugin_util.replace_substitutions(l_static_title)   end);
        apex_json.write('message'      , case when l_client_substitutions then l_static_message else apex_plugin_util.replace_substitutions(l_static_message) end);
    else
        if l_js_title_code is not null then
            apex_json.write_raw
                ( p_name  => 'title'
                , p_value => case l_message_type
                     when 'javascript-expression' then
                        'function(){return (' || l_js_title_code || ');}'
                     when 'javascript-function-body' then
                         l_js_title_code
                     end
                );
        end if;
        apex_json.write_raw
            ( p_name  => 'message'
            , p_value => case l_message_type
                 when 'javascript-expression' then
                    'function(){return (' || l_js_message_code || ');}'
                 when 'javascript-function-body' then
                     l_js_message_code
                 end
            );
    end if;

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.utils.notification(this, ' || apex_json.get_clob_output || ', '|| l_init_js_fn || ');}';

    apex_json.free_output;

    return l_result;
end;

end;
/


