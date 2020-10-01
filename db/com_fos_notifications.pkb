

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
--  GitHub: https://github.com/foex-open-source/fos-notifications
--
-- =============================================================================
--
function render
  ( p_dynamic_action apex_plugin.t_dynamic_action
  , p_plugin         apex_plugin.t_plugin
  )
return apex_plugin.t_dynamic_action_render_result
as
    l_result                 apex_plugin.t_dynamic_action_render_result;

    -- component settings / application level
    l_default_position       p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_01, 'top-right');
    l_default_success_icon   p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_02, 'fa-check-circle');
    l_default_info_icon      p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_03, 'fa-info-circle');
    l_default_warning_icon   p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_04, 'fa-exclamation-triangle');
    l_default_error_icon     p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_05, 'fa-times-circle');
    l_default_options        p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_06, 'escape-html:newest-on-top:client-side-substitutions:dismiss-on-click:dismiss-on-button');
    l_default_dismiss_after  pls_integer                        := p_plugin.attribute_07;

    -- general attributes
    l_notification_type     p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_message_type          p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    l_static_title          p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
    l_static_message        p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    l_js_title_code         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;
    l_js_message_code       p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    l_override_defaults     boolean                            := nvl(p_dynamic_action.attribute_09,'N') = 'Y';
    l_options               p_dynamic_action.attribute_07%type := case when l_override_defaults then p_dynamic_action.attribute_07 else l_default_options end;

    -- options
    l_escape                boolean                            := instr(l_options,'escape-html') > 0;
    l_auto_dismiss          boolean                            := instr(l_options,'autodismiss') > 0;
    l_client_substitutions  boolean                            := instr(l_options,'client-side-substitutions') > 0;
    l_clear_all             boolean                            := instr(l_options,'remove-notifications') > 0;
    l_show_dismiss_button   boolean                            := instr(l_options,'dismiss-on-button') > 0;
    l_dismiss_on_click      boolean                            := instr(l_options,'dismiss-on-click') > 0;
    l_newest_on_top         boolean                            := instr(l_options,'newest-on-top') > 0;
    l_prevent_duplicates    boolean                            := instr(l_options,'prevent-duplicates') > 0;
    l_inline_item_error     boolean                            := p_dynamic_action.attribute_12 is not null;
    l_position              p_dynamic_action.attribute_08%type := case when l_override_defaults then p_dynamic_action.attribute_08 else l_default_position end;
    l_icon_override         p_dynamic_action.attribute_10%type := case when l_override_defaults then p_dynamic_action.attribute_10 else null end;
    l_icon                  p_dynamic_action.attribute_10%type;
    l_auto_dismiss_after    pls_integer                        := case when l_override_defaults then p_dynamic_action.attribute_11 else l_default_dismiss_after end;
    l_page_items            p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;

    -- Javascript Initialization Code
    l_init_js_fn            varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), 'undefined');

begin

    -- debug info
    if apex_application.g_debug
    then
        apex_plugin_util.debug_dynamic_action
          ( p_plugin         => p_plugin
          , p_dynamic_action => p_dynamic_action
          );
    end if;

    -- we add the files here since they are used across multiple plug-ins, so specifying a key will make sure only one file is added
    apex_css.add_file
      ( p_name           => apex_plugin_util.replace_substitutions('fostr#MIN#.css')
      , p_directory      => p_plugin.file_prefix || 'css/'
      , p_skip_extension => true
      , p_key            => 'fostr'
      );
    apex_javascript.add_library
      ( p_name           => apex_plugin_util.replace_substitutions('fostr#MIN#.js')
      , p_directory      => p_plugin.file_prefix || 'js/'
      , p_skip_extension => true
      , p_key            => 'fostr'
      );

    -- define our JSON config
    apex_json.initialize_clob_output;
    apex_json.open_object;

    -- notification plugin settings
    apex_json.write('type'             , l_notification_type);

    if l_notification_type != 'clear-all'
    then
        apex_json.write('substituteValues' , l_client_substitutions);
        -- notification settings
        apex_json.open_object('options');
        apex_json.write('position'         , l_position);
        apex_json.write('autoDismiss'      , l_auto_dismiss);
        apex_json.write('clearAll'         , l_clear_all);
        apex_json.open_array('dismiss');

        if l_dismiss_on_click    then apex_json.write('onClick');  end if;
        if l_show_dismiss_button then apex_json.write('onButton'); end if;

        apex_json.close_array;

        if l_auto_dismiss and l_auto_dismiss_after is not null
        then
            apex_json.write('dismissAfter' , l_auto_dismiss_after*1000);
        end if;

        apex_json.write('newestOnTop'      , l_newest_on_top);
        apex_json.write('preventDuplicates', l_prevent_duplicates);
        apex_json.write('escapeHtml'       , l_escape);

        -- the icon either comes from component settings or is overridden in the action itself
        if l_icon_override is not null
        then
            l_icon := l_icon_override;
        else
            l_icon :=
                case l_notification_type
                    when 'success' then
                        l_default_success_icon
                    when 'info' then
                        l_default_info_icon
                    when 'warning' then
                        l_default_warning_icon
                    when 'error' then
                        l_default_error_icon
                 end;

        end if;

        apex_json.write('iconClass'        , l_icon);
        apex_json.close_object;

        -- additional error information for page items
        apex_json.write('inlineItemErrors' , l_inline_item_error);

        if l_inline_item_error
        then
            apex_json.write('inlinePageItems', trim(both ',' from trim(l_page_items)));
        end if;

        -- notification message
        if l_message_type =  'static'
        then
            apex_json.write('title'        , case when l_client_substitutions then l_static_title   else apex_plugin_util.replace_substitutions(l_static_title)   end);
            apex_json.write('message'      , case when l_client_substitutions then l_static_message else apex_plugin_util.replace_substitutions(l_static_message) end);
        else
            if l_js_title_code is not null
            then
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
    end if;

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.utils.notification(this, ' || apex_json.get_clob_output || ', '|| l_init_js_fn || ');}';

    apex_json.free_output;

    return l_result;
end render;

end;
/




