

prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 168413046168897010
--     PLUGIN: 13235263798301758
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 34175298479606152
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_fos_notifications
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(13235263798301758)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.FOS.NOTIFICATIONS'
,p_display_name=>'FOS - Notifications'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/script#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  This plug-in lets you easily create notification messages in APEX using ',
'--  jQuery Toastr Notifications',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-notifications',
'--',
'-- =============================================================================',
'--',
'function render',
'  ( p_dynamic_action apex_plugin.t_dynamic_action',
'  , p_plugin         apex_plugin.t_plugin',
'  )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result                 apex_plugin.t_dynamic_action_render_result;',
'',
'    -- component settings / application level',
'    l_default_position       p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_01, ''top-right'');',
'    l_default_success_icon   p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_02, ''fa-check-circle'');',
'    l_default_info_icon      p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_03, ''fa-info-circle'');',
'    l_default_warning_icon   p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_04, ''fa-exclamation-triangle'');',
'    l_default_error_icon     p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_05, ''fa-times-circle'');',
'    l_default_options        p_dynamic_action.attribute_01%type := nvl(p_plugin.attribute_06, ''escape-html:newest-on-top:client-side-substitutions:dismiss-on-click:dismiss-on-button'');',
'    l_default_dismiss_after  pls_integer                        := p_plugin.attribute_07;',
'',
'    -- general attributes',
'    l_notification_type     p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_message_type          p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_static_title          p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'    l_static_message        p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    l_js_title_code         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    l_js_message_code       p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_override_defaults     boolean                            := nvl(p_dynamic_action.attribute_09,''N'') = ''Y'';',
'    l_options               p_dynamic_action.attribute_07%type := case when l_override_defaults then p_dynamic_action.attribute_07 else l_default_options end;',
'    ',
'    -- options',
'    l_escape                boolean                            := instr(l_options,''escape-html'') > 0;',
'    l_auto_dismiss          boolean                            := instr(l_options,''autodismiss'') > 0;',
'    l_client_substitutions  boolean                            := instr(l_options,''client-side-substitutions'') > 0;',
'    l_clear_all             boolean                            := instr(l_options,''remove-notifications'') > 0; ',
'    l_show_dismiss_button   boolean                            := instr(l_options,''dismiss-on-button'') > 0;',
'    l_dismiss_on_click      boolean                            := instr(l_options,''dismiss-on-click'') > 0;',
'    l_newest_on_top         boolean                            := instr(l_options,''newest-on-top'') > 0;',
'    l_prevent_duplicates    boolean                            := instr(l_options,''prevent-duplicates'') > 0;',
'    l_inline_item_error     boolean                            := p_dynamic_action.attribute_12 is not null;',
'    l_position              p_dynamic_action.attribute_08%type := case when l_override_defaults then p_dynamic_action.attribute_08 else l_default_position end;',
'    l_icon_override         p_dynamic_action.attribute_10%type := case when l_override_defaults then p_dynamic_action.attribute_10 else null end;',
'    l_icon                  p_dynamic_action.attribute_10%type;',
'    l_auto_dismiss_after    pls_integer                        := case when l_override_defaults then p_dynamic_action.attribute_11 else l_default_dismiss_after end;',
'    l_page_items            p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;',
'        ',
'    -- Javascript Initialization Code',
'    l_init_js_fn            varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), ''undefined'');',
'',
'begin',
'    ',
'    -- debug info',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_dynamic_action',
'          ( p_plugin         => p_plugin',
'          , p_dynamic_action => p_dynamic_action ',
'          );',
'    end if;',
'',
'    -- we add the files here since they are used across multiple plug-ins, so specifying a key will make sure only one file is added',
'    apex_css.add_file ',
'      ( p_name           => apex_plugin_util.replace_substitutions(''fostr#MIN#.css'')',
'      , p_directory      => p_plugin.file_prefix || ''css/''',
'      , p_skip_extension => true',
'      , p_key            => ''fostr''',
'      );    ',
'    apex_javascript.add_library ',
'      ( p_name           => apex_plugin_util.replace_substitutions(''fostr#MIN#.js'')',
'      , p_directory      => p_plugin.file_prefix || ''js/''',
'      , p_skip_extension => true',
'      , p_key            => ''fostr''',
'      );    ',
'',
'    -- define our JSON config',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    -- notification plugin settings',
'    apex_json.write(''type''             , l_notification_type);',
'',
'    if l_notification_type != ''clear-all'' ',
'    then',
'        apex_json.write(''substituteValues'' , l_client_substitutions);',
'        -- notification settings',
'        apex_json.open_object(''options'');',
'        apex_json.write(''position''         , l_position);',
'        apex_json.write(''autoDismiss''      , l_auto_dismiss);',
'        apex_json.write(''clearAll''         , l_clear_all);',
'        apex_json.open_array(''dismiss'');',
'        ',
'        if l_dismiss_on_click    then apex_json.write(''onClick'');  end if;',
'        if l_show_dismiss_button then apex_json.write(''onButton''); end if;',
'        ',
'        apex_json.close_array;',
'        ',
'        if l_auto_dismiss and l_auto_dismiss_after is not null ',
'        then',
'            apex_json.write(''dismissAfter'' , l_auto_dismiss_after*1000);',
'        end if;',
'        ',
'        apex_json.write(''newestOnTop''      , l_newest_on_top);',
'        apex_json.write(''preventDuplicates'', l_prevent_duplicates);',
'        apex_json.write(''escapeHtml''       , l_escape);',
'        ',
'        -- the icon either comes from component settings or is overridden in the action itself',
'        if l_icon_override is not null ',
'        then ',
'            l_icon := l_icon_override;',
'        else',
'            l_icon := ',
'                case l_notification_type',
'                    when ''success'' then',
'                        l_default_success_icon',
'                    when ''info'' then',
'                        l_default_info_icon',
'                    when ''warning'' then',
'                        l_default_warning_icon',
'                    when ''error'' then',
'                        l_default_error_icon',
'                 end;',
'',
'        end if;',
'        ',
'        apex_json.write(''iconClass''        , l_icon);',
'        apex_json.close_object;',
'',
'        -- additional error information for page items',
'        apex_json.write(''inlineItemErrors'' , l_inline_item_error);',
'        ',
'        if l_inline_item_error ',
'        then',
'            apex_json.write(''inlinePageItems'', trim(both '','' from trim(l_page_items)));',
'        end if;',
'',
'        -- notification message',
'        if l_message_type =  ''static'' ',
'        then',
'            apex_json.write(''title''        , case when l_client_substitutions then l_static_title   else apex_plugin_util.replace_substitutions(l_static_title)   end);',
'            apex_json.write(''message''      , case when l_client_substitutions then l_static_message else apex_plugin_util.replace_substitutions(l_static_message) end);',
'        else',
'            if l_js_title_code is not null ',
'            then',
'                apex_json.write_raw',
'                  ( p_name  => ''title''',
'                  , p_value => case l_message_type',
'                       when ''javascript-expression'' then',
'                          ''function(){return ('' || l_js_title_code || '');}''',
'                       when ''javascript-function-body'' then',
'                           l_js_title_code',
'                       end',
'                  );',
'            end if;',
'            ',
'            apex_json.write_raw',
'              ( p_name  => ''message''',
'              , p_value => case l_message_type',
'                   when ''javascript-expression'' then',
'                      ''function(){return ('' || l_js_message_code || '');}''',
'                   when ''javascript-function-body'' then',
'                       l_js_message_code',
'                   end',
'              );',
'        end if;',
'    end if;',
'',
'    apex_json.close_object;',
'    ',
'    l_result.javascript_function := ''function(){FOS.utils.notification(this, '' || apex_json.get_clob_output || '', ''|| l_init_js_fn || '');}'';',
'    ',
'    apex_json.free_output;',
'',
'    return l_result;',
'end render;'))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'    The <strong>FOS - Notifications</strong> dynamic action plug-in is built on top of a custom Javascript library and allows you to show success and error messages, as well as additional info and warning message types. It matches the look of native '
||'APEX success/error messages, and can be styled to your liking through Themeroller.',
'</p>',
'<p>',
'    With the "FOS - Notifications" dynamic action you can show multiple messages of each type, customize them by setting their icon, position, how they are dismissed, and more.',
'</p>',
'<p>',
'    You can derive the message using static text with substitution support or from a Javascript expression or function. You can use HTML in the message or escape HTML for tighter security.',
'</p>'))
,p_version_identifier=>'20.1.1'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>334
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41547467028031292)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'top-right'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the default position you would like your notifications to be displayed at. You can override this setting if needed within the notification dynamic action.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41568397768034376)
,p_plugin_attribute_id=>wwv_flow_api.id(41547467028031292)
,p_display_sequence=>10
,p_display_value=>'Top Right'
,p_return_value=>'top-right'
,p_is_quick_pick=>true
,p_help_text=>'<p>The message is shown in the top right corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41568734547036211)
,p_plugin_attribute_id=>wwv_flow_api.id(41547467028031292)
,p_display_sequence=>20
,p_display_value=>'Top Center'
,p_return_value=>'top-center'
,p_help_text=>'<p>The message is shown centered in the top of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41569177487038839)
,p_plugin_attribute_id=>wwv_flow_api.id(41547467028031292)
,p_display_sequence=>30
,p_display_value=>'Top Left'
,p_return_value=>'top-left'
,p_is_quick_pick=>true
,p_help_text=>'<p>The message is shown in the top left corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41569512564040035)
,p_plugin_attribute_id=>wwv_flow_api.id(41547467028031292)
,p_display_sequence=>40
,p_display_value=>'Bottom Right'
,p_return_value=>'bottom-right'
,p_help_text=>'<p>The message is shown in the bottom right corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41569947438041123)
,p_plugin_attribute_id=>wwv_flow_api.id(41547467028031292)
,p_display_sequence=>50
,p_display_value=>'Bottom Center'
,p_return_value=>'bottom-center'
,p_help_text=>'<p>The message is shown centered at the bottom of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41570342579042465)
,p_plugin_attribute_id=>wwv_flow_api.id(41547467028031292)
,p_display_sequence=>60
,p_display_value=>'Bottom Left'
,p_return_value=>'bottom-left'
,p_help_text=>'<p>The message is shown in the bottom left corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41580875262047532)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Icon Success'
,p_attribute_type=>'ICON'
,p_is_required=>true
,p_default_value=>'fa-check-circle'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This setting defines the icon shown in the success notification. Please provide the font-apex icon CSS Class e.g. </p>',
'<code>',
'fa-check-circle',
'</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41591338670049661)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Icon Info'
,p_attribute_type=>'ICON'
,p_is_required=>true
,p_default_value=>'fa-info-circle'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This setting defines the icon shown in the info notification. Please provide the font-apex icon CSS Class e.g. </p>',
'<code>',
'fa-info-circle',
'</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41601810268052126)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Icon Warning'
,p_attribute_type=>'ICON'
,p_is_required=>true
,p_default_value=>'fa-exclamation-triangle'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This setting defines the icon shown in the warning notification. Please provide the font-apex icon CSS Class e.g. </p>',
'<code>',
'fa-exclamation-triangle',
'</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41612359388054198)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Icon Error'
,p_attribute_type=>'ICON'
,p_is_required=>true
,p_default_value=>'fa-times-circle'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This setting defines the icon shown in the error notification. Please provide the font-apex icon CSS Class e.g. </p>',
'<code>',
'fa-times-circle',
'</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41622854556078463)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'escape-html:newest-on-top:client-side-substitutions:dismiss-on-click:dismiss-on-button'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Choose extra options/settings to apply to your notification</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41633355489080097)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>10
,p_display_value=>'Autodismiss Success Notifications'
,p_return_value=>'autodismiss-success'
,p_help_text=>'<p>Whether to autodismiss success notifications after a specific amount of time. Enabling this option will also add a visual timer below the notification. When the timer runs out, the notification is removed. If the user hovers over the notification,'
||' the timer will be stopped and removed. The user has to then manually dismiss the notification.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41633740698082190)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>20
,p_display_value=>'Autodismiss Info Notifications'
,p_return_value=>'autodismiss-info'
,p_help_text=>'<p>Whether to autodismiss info notifications after a specific amount of time. Enabling this option will also add a visual timer below the notification. When the timer runs out, the notification is removed. If the user hovers over the notification, th'
||'e timer will be stopped and removed. The user has to then manually dismiss the notification.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41634149995083709)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>30
,p_display_value=>'Autodismiss Warning Notifications'
,p_return_value=>'autodismiss-warning'
,p_help_text=>'<p>Whether to autodismiss warning notifications after a specific amount of time. Enabling this option will also add a visual timer below the notification. When the timer runs out, the notification is removed. If the user hovers over the notification,'
||' the timer will be stopped and removed. The user has to then manually dismiss the notification.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41634551923085514)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>40
,p_display_value=>'Autodismiss Error Notifications'
,p_return_value=>'autodismiss-error'
,p_help_text=>'<p>Whether to autodismiss error notifications after a specific amount of time. Enabling this option will also add a visual timer below the notification. When the timer runs out, the notification is removed. If the user hovers over the notification, t'
||'he timer will be stopped and removed. The user has to then manually dismiss the notification.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41634934175087109)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>50
,p_display_value=>'Prevent Duplicates'
,p_return_value=>'prevent-duplicates'
,p_help_text=>'<p>Ensures the notification will not be shown if it has the same title and message as the previous notification.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41635354303088806)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>60
,p_display_value=>'[External] Show Errors As Warnings'
,p_return_value=>'show-errors-as-warnings'
,p_help_text=>'<p>This attribute is not used in the current FOS version.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41635728904089872)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>70
,p_display_value=>'Escape HTML'
,p_return_value=>'escape-html'
,p_help_text=>'<p>Check this option to escape any HTML in the text to ensure tighter security.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41636169554090923)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>80
,p_display_value=>'Newest On Top'
,p_return_value=>'newest-on-top'
,p_help_text=>'<p>Check this option to show all new messages at the top, when existing messages are still being displayed. If you leave this unchecked they will be shown at the bottom.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41636558442092086)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>90
,p_display_value=>'Perform Client-side Substitutions'
,p_return_value=>'client-side-substitutions'
,p_help_text=>'<p>Check this option to perform page item substitutions in the browser at the time of execution of the notification.</p><p><b>Note: </b>when using this setting the page items you reference in the title/message must be from this page or defined on pag'
||'e zero</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41637111344094320)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>100
,p_display_value=>'Dismiss On Notification Click/Tap'
,p_return_value=>'dismiss-on-click'
,p_help_text=>'<p>Whether the notification is dismissed on click or tap.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41637543691097618)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>110
,p_display_value=>'Dismiss On Close Button Click'
,p_return_value=>'dismiss-on-button'
,p_help_text=>'<p>Whether to render an X button that dismisses the notification.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41648080657117359)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>7
,p_display_sequence=>110
,p_prompt=>'Autodismiss After'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_unit=>'seconds'
,p_is_translatable=>false
,p_help_text=>'<p>Enter the number of seconds to display the notification before it is automatically removed.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13261281157409464)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'success'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Select the notification type. Each type has a specific default colour assigned e.g.</p>',
'<ul>',
'<li>Success -&gt; Green</li>',
'<li>Info -&gt; Blue</li>',
'<li>Warning -&gt; Orange</li>',
'<li>Error -&gt; Red</li>',
'</ul><div><b>Note:</b> these colours can be changed using the themeroller (extra setup required) or using CSS overrides. Please refer to the demo application for more details.</div>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17113631303117519)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>10
,p_display_value=>'Show Success'
,p_return_value=>'success'
,p_help_text=>'<p>Use this option in the case you want to indicate something was successful e.g. record created. By default it will show a green message with a tick icon.</p><p><b>Note:</b>&nbsp;we have provided themeroller support for you to be able to change the '
||'background &amp; text colour of the message.<br></p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17114030773118097)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>20
,p_display_value=>'Show Info'
,p_return_value=>'info'
,p_help_text=>'<p>Use this option in the case you want to show some sort of informational message e.g. giving the user an informational tip. By default it will show a blue message with an information comment bubble icon.</p><p><b>Note:</b> we have provided themerol'
||'ler support for you to be able to change the background &amp; text colour of the message.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17114455343118765)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>30
,p_display_value=>'Show Warning'
,p_return_value=>'warning'
,p_help_text=>'<p>Use this option in the case you want to indicate something the user shouldn''t do e.g. navigate away when changes aren''t saved. By default it will show an orange message with a warning triangle icon.</p><p><b>Note:</b>&nbsp;we have provided themero'
||'ller support for you to be able to change the background &amp; text colour of the message.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17114844984119380)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>40
,p_display_value=>'Show Error'
,p_return_value=>'error'
,p_help_text=>'<p>Use this option in the case you want to indicate an error occurred e.g. you cannot delete a record. By default it will show a red message with an exclamation bade icon.</p><p><b>Note:</b>&nbsp;we have provided themeroller support for you to be abl'
||'e to change the background &amp; text colour of the message.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41668865634125026)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>50
,p_display_value=>'Clear All Notifications'
,p_return_value=>'clear-all'
,p_help_text=>'<p>Clear all notifications on the page, including error notifications associated with page items.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13261528233412148)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Message Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'clear-all'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the message type. You can choose a static message that supports client side page item substitutions i.e. &amp;ITEM_NAME. or alternatively for full control you can derive both the title and message from a Javascript expression or Function.</'
||'p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13261923683413153)
,p_plugin_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_display_sequence=>10
,p_display_value=>'Static Text'
,p_return_value=>'static'
,p_help_text=>'You can define notifications with static text with page item substitutions'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13262379327415101)
,p_plugin_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_display_sequence=>20
,p_display_value=>'Javascript Expression'
,p_return_value=>'javascript-expression'
,p_help_text=>'You can define the title &amp; message using a Javascript expression e.g. if you wanted more programatic control for your notification contents e.g. including the current timestamp in the notification.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13262741299416859)
,p_plugin_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_display_sequence=>30
,p_display_value=>'Javascript Function'
,p_return_value=>'javascript-function-body'
,p_help_text=>'You can define the title &amp; message using a Javascript function e.g. if you wanted more programatic control for your notification contents e.g. including the current timestamp in the notification.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13263478376433486)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Title'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>true
,p_depending_on_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_depending_on_has_to_exist=>true

,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'<p>Enter the text you would like to display in the notification title. You can leave this setting blank if you do not want to include a title. You can use substitution strings in the title.&nbsp;</p><p><b>Note:</b> you have the ability in the "Extra '
||'Options" attribute to determine if these substitution occur at the time of page render (server-side) or at the time of execution in the browser (client-side)</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13263740517441135)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Message'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_is_translatable=>true
,p_depending_on_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'<p>The notification message you wish to display. You can use substitution strings in the message.&nbsp;</p><p><b>Note:</b>&nbsp;if you use a single substitution string for the message and when it is substituted it is blank/null then the notification '
||'will not be shown, even if you have a title defined. You could say that this is a method to make the notification conditional.</p><p>Also you have the ability in the "Extra Options" attribute to determine if these substitution occur at the time of pa'
||'ge render (server-side) or at the time of execution in the browser (client-side)<br></p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13264251030448850)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Title'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'<p>Enter the javascript expression/function that will return the notification title.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13264579929451895)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Message'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'<p>Enter the javascript expression/function that will return the notification message.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13264879889455301)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'escape-html:newest-on-top:client-side-substitutions:dismiss-on-click:dismiss-on-button'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(41841926141230118)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Choose extra options/settings to apply to your notification</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41736639297206675)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>10
,p_display_value=>'Autodismiss'
,p_return_value=>'autodismiss'
,p_help_text=>'<p>Whether to autodismiss the notification after a specific amount of time. Enabling this option will also add a visual timer below the notification. When the timer runs out, the notification is removed. If the user hovers over the notification, the '
||'timer will be stopped and removed. The user has to then manually dismiss the notification.</p>'
);
end;
/
begin
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13265970659461908)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>20
,p_display_value=>'Prevent Duplicates'
,p_return_value=>'prevent-duplicates'
,p_help_text=>'<p>Ensures the notification will not be shown if it has the same title and message as the previous notification.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17272813756021351)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>30
,p_display_value=>'Remove All Notifications First'
,p_return_value=>'remove-notifications'
,p_help_text=>'<p>Check this option to remove all existing notifications before showing this notification</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17174338575948618)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>40
,p_display_value=>'Escape HTML'
,p_return_value=>'escape-html'
,p_help_text=>'<p>Check this option to escape any HTML in the text to ensure tighter security.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13266707143512559)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>50
,p_display_value=>'Newest On Top'
,p_return_value=>'newest-on-top'
,p_help_text=>'<p>Check this option to show all new messages at the top, when existing messages are still being displayed. If you leave this unchecked they will be shown at the bottom.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17307430123727742)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>60
,p_display_value=>'Perform Client-side Substitutions'
,p_return_value=>'client-side-substitutions'
,p_help_text=>'<p>Check this option to perform page item substitutions in the browser at the time of execution of the notification.</p><p><b>Note: </b>when using this setting the page items you reference in the title/message must be from this page or defined on pag'
||'e zero</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41747147366210352)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>70
,p_display_value=>'Dismiss On Notification Click/Tap'
,p_return_value=>'dismiss-on-click'
,p_help_text=>'<p>Whether the notification is dismissed on click or tap.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41747562403212621)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>80
,p_display_value=>'Dismiss On Close Button Click'
,p_return_value=>'dismiss-on-button'
,p_help_text=>'<p>Whether to render an X button that dismisses the notification.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13272683616562939)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>100
,p_prompt=>'Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'top-right'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(41841926141230118)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the position where you would like the notification to be displayed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13272980849564354)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>10
,p_display_value=>'Top Right'
,p_return_value=>'top-right'
,p_help_text=>'<p>The message is shown in the top right corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13275332505571898)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>20
,p_display_value=>'Top Center'
,p_return_value=>'top-center'
,p_help_text=>'<p>The message is shown centered in the top of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13274198989567931)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>30
,p_display_value=>'Top Left'
,p_return_value=>'top-left'
,p_help_text=>'<p>The message is shown in the top left corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13273375140565600)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>50
,p_display_value=>'Bottom Right'
,p_return_value=>'bottom-right'
,p_help_text=>'<p>The message is shown in the bottom right corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13275775435573212)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>60
,p_display_value=>'Bottom Center'
,p_return_value=>'bottom-center'
,p_help_text=>'<p>The message is shown centered at the bottom of the browser window</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13273797237566746)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>70
,p_display_value=>'Bottom Left'
,p_return_value=>'bottom-left'
,p_help_text=>'<p>The message is shown in the bottom left corner of the browser window</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41841926141230118)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>65
,p_prompt=>'Override Defaults'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'clear-all'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enable this option to override the settings defined under "Shared Components" -> "Component Settings" -> "FOS - Notifications"</p>',
'<p><b>Note:</b> when you enable this setting all defaults are overridden</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41908074571407875)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(41841926141230118)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This setting defines the icon shown in this particular notification, it will override the application level setting. Please provide the font-apex icon CSS Class e.g. </p>',
'<code>',
'fa-info-circle',
'</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41961976501018791)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>75
,p_prompt=>'Autodismiss After'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'10'
,p_unit=>'seconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'autodismiss'
,p_help_text=>'<p>Enter the number of seconds to display the notification before it is automatically removed.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(26497677485554966)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>63
,p_prompt=>'Associated Item(s)	'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'error'
,p_help_text=>'<p>Associate the notification error messages with one or more page items. If you would like to clear these error messages using a dynamic action please use the "FOS - Message Actions" plug-in and the "Clear Errors" action.</p>'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(17184580661356883)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function(config){',
'    config.type = ''error'';',
'}',
'</pre>'))
,p_help_text=>'<p>This setting allows you to define a Javascript initialization function that allows you to override any settings right before the notification is shown. These are the values which you can override:</p>'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C7320617065782C666F7374722C24202A2F0A0A76617220464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E7574696C73203D20464F532E7574696C73207C7C207B7D3B0A0A464F532E7574696C732E69735254';
wwv_flow_api.g_varchar2_table(2) := '4C203D20464F532E7574696C732E697352544C207C7C2066756E6374696F6E202829207B2072657475726E20242827626F647927292E6174747228276469722729203D3D3D202272746C223B207D3B0A0A2F2A2A0A202A20412064796E616D6963206163';
wwv_flow_api.g_varchar2_table(3) := '74696F6E20746F20656173696C7920637265617465206E6F74696669636174696F6E206D6573736167657320696E20415045582E204974206973206261736564206F6E2074686520546F61737472206F70656E20736F75726365206A517565727920706C';
wwv_flow_api.g_varchar2_table(4) := '7567696E0A202A0A202A2040706172616D207B6F626A6563747D2020206461436F6E7465787420202020202044796E616D696320416374696F6E20636F6E746578742061732070617373656420696E20627920415045580A202A2040706172616D207B6F';
wwv_flow_api.g_varchar2_table(5) := '626A6563747D202020636F6E666967202020202020202020436F6E66696775726174696F6E206F626A65637420686F6C64696E6720746865206E6F74696669636174696F6E2073657474696E67730A202A2040706172616D207B737472696E677D202020';
wwv_flow_api.g_varchar2_table(6) := '636F6E6669672E7479706520202020546865206E6F74696669636174696F6E207479706520652E672E20737563636573732C206572726F722C207761726E696E672C20696E666F0A202A2040706172616D207B66756E6374696F6E7D205B696E6974466E';
wwv_flow_api.g_varchar2_table(7) := '5D202020202020204A5320696E697469616C697A6174696F6E2066756E6374696F6E2077686963682077696C6C20616C6C6F7720796F7520746F206F766572726964652073657474696E6773207269676874206265666F726520746865206E6F74696669';
wwv_flow_api.g_varchar2_table(8) := '6361746F6E2069732073656E740A202A2F0A464F532E7574696C732E6E6F74696669636174696F6E203D2066756E6374696F6E20286461436F6E746578742C20636F6E6669672C20696E6974466E29207B0A20202020766172206D6573736167652C2074';
wwv_flow_api.g_varchar2_table(9) := '69746C652C2064656661756C74732C20706F736974696F6E436C6173733B0A0A202020202F2F20706172616D6574657220636865636B730A202020206461436F6E74657874203D206461436F6E74657874207C7C20746869733B0A20202020636F6E6669';
wwv_flow_api.g_varchar2_table(10) := '67203D20636F6E666967207C7C207B7D3B0A20202020636F6E6669672E74797065203D20636F6E6669672E74797065207C7C2027696E666F273B0A0A20202020617065782E64656275672E696E666F2827464F53202D204E6F74696669636174696F6E73';
wwv_flow_api.g_varchar2_table(11) := '272C20636F6E666967293B0A0A202020202F2F206561726C79206578697420696620776520617265206A73757420636C656172696E6720746865206E6F74696669636174696F6E730A2020202069662028636F6E6669672E74797065203D3D3D2027636C';
wwv_flow_api.g_varchar2_table(12) := '6561722D616C6C2729207B0A2020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A202020202020202072657475726E20666F7374722E636C656172416C6C28293B0A202020207D0A0A202020202F2F20646566696E';
wwv_flow_api.g_varchar2_table(13) := '65206F7572206D6573736167652064657461696C73207768696368206D61792064796E616D6963616C6C7920636F6D652066726F6D2061204A6176617363726970742063616C6C0A2020202069662028636F6E6669672E6D65737361676520696E737461';
wwv_flow_api.g_varchar2_table(14) := '6E63656F662046756E6374696F6E29207B0A20202020202020206D657373616765203D20636F6E6669672E6D6573736167652E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D20656C7365207B0A20202020202020206D6573';
wwv_flow_api.g_varchar2_table(15) := '73616765203D20636F6E6669672E6D6573736167653B0A202020207D0A0A2020202069662028636F6E6669672E7469746C6520696E7374616E63656F662046756E6374696F6E29207B0A20202020202020207469746C65203D20636F6E6669672E746974';
wwv_flow_api.g_varchar2_table(16) := '6C652E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D20656C7365207B0A20202020202020207469746C65203D20636F6E6669672E7469746C653B0A202020207D0A0A202020202F2F2077652077696C6C206E6F7420706572';
wwv_flow_api.g_varchar2_table(17) := '666F726D2061206E6F74696669636174696F6E206966206F7572206D65737361676520626F6479206973206E756C6C2F656D70747920737472696E670A2020202069662028216D65737361676520262620217469746C65292072657475726E3B0A0A2020';
wwv_flow_api.g_varchar2_table(18) := '20202F2F20205265706C6163696E6720737562737469747574696F6E20737472696E67730A2020202069662028636F6E6669672E7375627374697475746556616C75657329207B0A20202020202020202F2F2020576520646F6E27742065736361706520';
wwv_flow_api.g_varchar2_table(19) := '746865206D6573736167652062792064656661756C742E205765206C65742074686520646576656C6F70657220646563696465207768657468657220746F206573636170650A20202020202020202F2F20207468652077686F6C65206D6573736167652C';
wwv_flow_api.g_varchar2_table(20) := '206F72206A75737420696E76696475616C2070616765206974656D73207669612026504147455F4954454D2148544D4C2E0A2020202020202020696620287469746C6529207B0A2020202020202020202020207469746C65203D20617065782E7574696C';
wwv_flow_api.g_varchar2_table(21) := '2E6170706C7954656D706C617465287469746C652C207B0A2020202020202020202020202020202064656661756C7445736361706546696C7465723A206E756C6C0A2020202020202020202020207D293B0A20202020202020207D0A2020202020202020';
wwv_flow_api.g_varchar2_table(22) := '6D657373616765203D20617065782E7574696C2E6170706C7954656D706C617465286D6573736167652C207B0A20202020202020202020202064656661756C7445736361706546696C7465723A206E756C6C0A20202020202020207D293B0A2020202020';
wwv_flow_api.g_varchar2_table(23) := '2020202F2F2077652077696C6C206E6F7420706572666F726D2061206E6F74696669636174696F6E206966206F7572206D65737361676520626F6479206973206E756C6C2F656D70747920737472696E67206166746572200A20202020202020202F2F20';
wwv_flow_api.g_varchar2_table(24) := '737562737469747574696F6E7320617265206D61646520616E6420746865206D65737361676520697320656D7074790A202020202020202069662028216D65737361676520262620217469746C65292072657475726E3B0A202020207D0A0A202020202F';
wwv_flow_api.g_varchar2_table(25) := '2F20446566696E65206F7572206E6F74696669636174696F6E2073657474696E67730A20202020666F7374722E6F7074696F6E73203D20242E657874656E64287B7D2C20636F6E6669672E6F7074696F6E73293B0A0A202020202F2F20416C6C6F772074';
wwv_flow_api.g_varchar2_table(26) := '686520646576656C6F70657220746F20706572666F726D20616E79206C617374202863656E7472616C697A656429206368616E676573207573696E67204A61766173637269707420496E697469616C697A6174696F6E20436F64652073657474696E670A';
wwv_flow_api.g_varchar2_table(27) := '2020202069662028696E6974466E20696E7374616E63656F662046756E6374696F6E29207B0A2020202020202020696E6974466E2E63616C6C286461436F6E746578742C20666F7374722E6F7074696F6E73293B0A202020207D0A0A202020202F2F2061';
wwv_flow_api.g_varchar2_table(28) := '7373636F6169746520616E7920696E6C696E652070616765206974656D206572726F72730A2020202069662028636F6E6669672E696E6C696E654974656D4572726F727320262620636F6E6669672E696E6C696E65506167654974656D7329207B0A2020';
wwv_flow_api.g_varchar2_table(29) := '202020202020636F6E6669672E696E6C696E65506167654974656D732E73706C697428272C27292E666F72456163682866756E6374696F6E28706167654974656D29207B0A2020202020202020202020202F2F2053686F77206F75722041504558206572';
wwv_flow_api.g_varchar2_table(30) := '726F72206D6573736167650A202020202020202020202020617065782E6D6573736167652E73686F774572726F7273287B0A20202020202020202020202020202020747970653A20276572726F72272C0A202020202020202020202020202020206C6F63';
wwv_flow_api.g_varchar2_table(31) := '6174696F6E3A2027696E6C696E65272C0A20202020202020202020202020202020706167654974656D3A20706167654974656D2C0A202020202020202020202020202020206D6573736167653A206D6573736167652C0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(32) := '2020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279206E6F770A20202020202020202020202020202020756E736166653A2066616C73650A2020202020202020202020207D293B0A';
wwv_flow_api.g_varchar2_table(33) := '20202020202020207D293B0A202020207D0A0A202020202F2F20506572666F726D207468652061637475616C206E6F74696669636174696F6E0A20202020666F7374725B636F6E6669672E747970655D286D6573736167652C207469746C65293B0A7D3B';
wwv_flow_api.g_varchar2_table(34) := '0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13244836320301787)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B22464F53222C2277696E646F77222C227574696C73222C22697352544C222C2224222C2261747472222C226E6F74696669636174696F';
wwv_flow_api.g_varchar2_table(2) := '6E222C226461436F6E74657874222C22636F6E666967222C22696E6974466E222C226D657373616765222C227469746C65222C2274686973222C2274797065222C2261706578222C226465627567222C22696E666F222C22636C6561724572726F727322';
wwv_flow_api.g_varchar2_table(3) := '2C22666F737472222C22636C656172416C6C222C2246756E6374696F6E222C2263616C6C222C227375627374697475746556616C756573222C227574696C222C226170706C7954656D706C617465222C2264656661756C7445736361706546696C746572';
wwv_flow_api.g_varchar2_table(4) := '222C226F7074696F6E73222C22657874656E64222C22696E6C696E654974656D4572726F7273222C22696E6C696E65506167654974656D73222C2273706C6974222C22666F7245616368222C22706167654974656D222C2273686F774572726F7273222C';
wwv_flow_api.g_varchar2_table(5) := '226C6F636174696F6E222C22756E73616665225D2C226D617070696E6773223A22414145412C49414149412C4941414D432C4F41414F442C4B41414F2C4741437842412C49414149452C4D414151462C49414149452C4F4141532C4741457A42462C4941';
wwv_flow_api.g_varchar2_table(6) := '4149452C4D41414D432C4D414151482C49414149452C4D41414D432C4F4141532C574141632C4D414169432C5141413142432C454141452C51414151432C4B41414B2C5141557A454C2C49414149452C4D41414D492C614141652C53414155432C454141';
wwv_flow_api.g_varchar2_table(7) := '57432C45414151432C4741436C442C49414149432C45414153432C454155622C474150414A2C45414159412C474141614B2C4D41437A424A2C45414153412C474141552C4941435A4B2C4B41414F4C2C4541414F4B2C4D4141512C4F41453742432C4B41';
wwv_flow_api.g_varchar2_table(8) := '414B432C4D41414D432C4B41414B2C734241417542522C4741476E422C6341416842412C4541414F4B2C4B4145502C4F414441432C4B41414B4A2C514141514F2C6341434E432C4D41414D432C57414B62542C45414441462C4541414F452C6D4241416D';
wwv_flow_api.g_varchar2_table(9) := '42552C53414368425A2C4541414F452C51414151572C4B41414B642C45414157432C4741452F42412C4541414F452C5141496A42432C45414441482C4541414F472C694241416942532C53414368425A2C4541414F472C4D41414D552C4B41414B642C45';
wwv_flow_api.g_varchar2_table(10) := '414157432C4741453742412C4541414F472C4F414964442C47414159432C4D414762482C4541414F632C6D42414748582C49414341412C45414151472C4B41414B532C4B41414B432C63414163622C4541414F2C4341436E43632C6F42414171422C5341';
wwv_flow_api.g_varchar2_table(11) := '473742662C45414155492C4B41414B532C4B41414B432C63414163642C454141532C4341437643652C6F42414171422C53414952642C4D414972424F2C4D41414D512C5141415574422C4541414575422C4F41414F2C474141496E422C4541414F6B422C';
wwv_flow_api.g_varchar2_table(12) := '53414768436A422C6141416B42572C5541436C42582C4541414F592C4B41414B642C45414157572C4D41414D512C53414937426C422C4541414F6F422C6B4241416F4270422C4541414F71422C694241436C4372422C4541414F71422C67424141674243';
wwv_flow_api.g_varchar2_table(13) := '2C4D41414D2C4B41414B432C534141512C53414153432C4741452F436C422C4B41414B4A2C5141415175422C574141572C434143704270422C4B41414D2C5141434E71422C534141552C53414356462C53414155412C4541435674422C51414153412C45';
wwv_flow_api.g_varchar2_table(14) := '41455479422C514141512C4F414D70426A422C4D41414D562C4541414F4B2C4D41414D482C4541415343222C2266696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13245221835301788)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220464F533D77696E646F772E464F537C7C7B7D3B464F532E7574696C733D464F532E7574696C737C7C7B7D2C464F532E7574696C732E697352544C3D464F532E7574696C732E697352544C7C7C66756E6374696F6E28297B72657475726E227274';
wwv_flow_api.g_varchar2_table(2) := '6C223D3D3D242822626F647922292E61747472282264697222297D2C464F532E7574696C732E6E6F74696669636174696F6E3D66756E6374696F6E28652C742C69297B76617220732C6C3B696628653D657C7C746869732C28743D747C7C7B7D292E7479';
wwv_flow_api.g_varchar2_table(3) := '70653D742E747970657C7C22696E666F222C617065782E64656275672E696E666F2822464F53202D204E6F74696669636174696F6E73222C74292C22636C6561722D616C6C223D3D3D742E747970652972657475726E20617065782E6D6573736167652E';
wwv_flow_api.g_varchar2_table(4) := '636C6561724572726F727328292C666F7374722E636C656172416C6C28293B733D742E6D65737361676520696E7374616E63656F662046756E6374696F6E3F742E6D6573736167652E63616C6C28652C74293A742E6D6573736167652C6C3D742E746974';
wwv_flow_api.g_varchar2_table(5) := '6C6520696E7374616E63656F662046756E6374696F6E3F742E7469746C652E63616C6C28652C74293A742E7469746C652C28737C7C6C2926262821742E7375627374697475746556616C7565737C7C286C2626286C3D617065782E7574696C2E6170706C';
wwv_flow_api.g_varchar2_table(6) := '7954656D706C617465286C2C7B64656661756C7445736361706546696C7465723A6E756C6C7D29292C28733D617065782E7574696C2E6170706C7954656D706C61746528732C7B64656661756C7445736361706546696C7465723A6E756C6C7D29297C7C';
wwv_flow_api.g_varchar2_table(7) := '6C2929262628666F7374722E6F7074696F6E733D242E657874656E64287B7D2C742E6F7074696F6E73292C6920696E7374616E63656F662046756E6374696F6E2626692E63616C6C28652C666F7374722E6F7074696F6E73292C742E696E6C696E654974';
wwv_flow_api.g_varchar2_table(8) := '656D4572726F72732626742E696E6C696E65506167654974656D732626742E696E6C696E65506167654974656D732E73706C697428222C22292E666F7245616368282866756E6374696F6E2865297B617065782E6D6573736167652E73686F774572726F';
wwv_flow_api.g_varchar2_table(9) := '7273287B747970653A226572726F72222C6C6F636174696F6E3A22696E6C696E65222C706167654974656D3A652C6D6573736167653A732C756E736166653A21317D297D29292C666F7374725B742E747970655D28732C6C29297D3B0A2F2F2320736F75';
wwv_flow_api.g_varchar2_table(10) := '7263654D617070696E6755524C3D7363726970742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13245693519301788)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202A2052544C20737570706F72742073686F756C6420626520646F6E6520696E20637373206F6E6C792E20636C61737320752D52544C20657869737473206F6E2074686520626F6479207768656E206170657820697320696E2052544C206D6F64';
wwv_flow_api.g_varchar2_table(2) := '652E0A202A204E6F7465207468617420746869732073686F756C64206F6E6C792061666665637420656C656D656E74732077697468696E20746865206E6F74696669636174696F6E2C206E6F742074686520706F736974696F6E696E67206F6620746865';
wwv_flow_api.g_varchar2_table(3) := '2061637475616C206E6F74696669636174696F6E2E0A202A20546869732069732074616B656E2063617265206F66206279206120706C75672D696E2073657474696E67732E0A202A0A202A2F0A0A2F2A0A202A20466F7374720A202A20436F7079726967';
wwv_flow_api.g_varchar2_table(4) := '687420323032300A202A20417574686F72733A2053746566616E20446F6272650A202A200A202A204372656469747320666F722074686520626173652076657273696F6E20676F20746F3A2068747470733A2F2F6769746875622E636F6D2F436F646553';
wwv_flow_api.g_varchar2_table(5) := '6576656E2F746F617374720A202A204F726967696E616C20417574686F72733A204A6F686E20506170612C2048616E7320466AC3A46C6C656D61726B2C20616E642054696D2046657272656C6C2E0A202A204152494120537570706F72743A2047726574';
wwv_flow_api.g_varchar2_table(6) := '61204B7261667369670A202A200A202A20416C6C205269676874732052657365727665642E0A202A205573652C20726570726F64756374696F6E2C20646973747269627574696F6E2C20616E64206D6F64696669636174696F6E206F6620746869732063';
wwv_flow_api.g_varchar2_table(7) := '6F6465206973207375626A65637420746F20746865207465726D7320616E640A202A20636F6E646974696F6E73206F6620746865204D4954206C6963656E73652C20617661696C61626C6520617420687474703A2F2F7777772E6F70656E736F75726365';
wwv_flow_api.g_varchar2_table(8) := '2E6F72672F6C6963656E7365732F6D69742D6C6963656E73652E7068700A202A0A202A2050726F6A6563743A2068747470733A2F2F6769746875622E636F6D2F666F65782D6F70656E2D736F757263652F666F7374720A202A2F0A77696E646F772E666F';
wwv_flow_api.g_varchar2_table(9) := '737472203D202866756E6374696F6E2829207B0A0A2020202076617220746F61737454797065203D207B0A2020202020202020737563636573733A202773756363657373272C0A2020202020202020696E666F3A2027696E666F272C0A20202020202020';

wwv_flow_api.g_varchar2_table(10) := '207761726E696E673A20277761726E696E67272C0A20202020202020206572726F723A20276572726F72270A202020207D3B0A0A202020207661722069636F6E436C6173736573203D207B0A2020202020202020737563636573733A202266612D636865';
wwv_flow_api.g_varchar2_table(11) := '636B2D636972636C65222C0A2020202020202020696E666F3A202266612D696E666F2D636972636C65222C0A20202020202020207761726E696E673A202266612D6578636C616D6174696F6E2D747269616E676C65222C0A20202020202020206572726F';
wwv_flow_api.g_varchar2_table(12) := '723A202266612D74696D65732D636972636C65220A202020207D3B0A0A2020202076617220636F6E7461696E657273203D207B7D3B0A202020207661722070726576696F7573546F617374203D207B7D3B0A0A2020202066756E6374696F6E206E6F7469';
wwv_flow_api.g_varchar2_table(13) := '66795479706528747970652C206D6573736167652C207469746C6529207B0A202020202020202069662028747970656F66206D657373616765203D3D3D2027737472696E672729207B0A20202020202020202020202069662028217469746C6529207B0A';
wwv_flow_api.g_varchar2_table(14) := '202020202020202020202020202020207469746C65203D206D6573736167653B0A202020202020202020202020202020206D657373616765203D20756E646566696E65643B0A2020202020202020202020207D0A20202020202020202020202072657475';
wwv_flow_api.g_varchar2_table(15) := '726E206E6F74696679287B0A20202020202020202020202020202020747970653A20747970652C0A202020202020202020202020202020206D6573736167653A206D6573736167652C0A202020202020202020202020202020207469746C653A20746974';
wwv_flow_api.g_varchar2_table(16) := '6C650A2020202020202020202020207D293B0A20202020202020207D20656C73652069662028747970656F66206D657373616765203D3D3D20276F626A6563742729207B0A2020202020202020202020206D6573736167652E74797065203D2074797065';
wwv_flow_api.g_varchar2_table(17) := '3B0A20202020202020202020202072657475726E206E6F74696679286D657373616765293B0A20202020202020207D20656C7365207B0A202020202020202020202020636F6E736F6C652E6572726F722827666F737472206E6F74696669636174696F6E';
wwv_flow_api.g_varchar2_table(18) := '20226D6573736167652220706172616D657465722074797065206E6F7420737570706F727465642C206D757374206265206120737472696E67206F72206F626A65637427293B0A20202020202020207D0A202020207D0A0A2020202066756E6374696F6E';
wwv_flow_api.g_varchar2_table(19) := '2073756363657373286D6573736167652C207469746C6529207B0A20202020202020206E6F746966795479706528746F617374547970652E737563636573732C206D6573736167652C207469746C65293B0A202020207D0A0A2020202066756E6374696F';
wwv_flow_api.g_varchar2_table(20) := '6E207761726E696E67286D6573736167652C207469746C6529207B0A20202020202020206E6F746966795479706528746F617374547970652E7761726E696E672C206D6573736167652C207469746C65293B0A202020207D0A0A2020202066756E637469';
wwv_flow_api.g_varchar2_table(21) := '6F6E20696E666F286D6573736167652C207469746C6529207B0A20202020202020206E6F746966795479706528746F617374547970652E696E666F2C206D6573736167652C207469746C65293B0A202020207D0A0A2020202066756E6374696F6E206572';
wwv_flow_api.g_varchar2_table(22) := '726F72286D6573736167652C207469746C6529207B0A20202020202020206E6F746966795479706528746F617374547970652E6572726F722C206D6573736167652C207469746C65293B0A202020207D0A0A2020202066756E6374696F6E20636C656172';
wwv_flow_api.g_varchar2_table(23) := '416C6C2829207B0A20202020202020202428272E27202B20676574436F6E7461696E6572436C6173732829292E6368696C6472656E28292E72656D6F766528293B0A202020207D0A0A202020202F2F20696E7465726E616C2066756E6374696F6E730A0A';
wwv_flow_api.g_varchar2_table(24) := '2020202066756E6374696F6E20676574436F6E7461696E6572436C6173732829207B0A202020202020202072657475726E2027666F7374722D636F6E7461696E6572273B0A202020207D0A0A2020202066756E6374696F6E20676574436F6E7461696E65';
wwv_flow_api.g_varchar2_table(25) := '7228706F736974696F6E29207B0A0A202020202020202066756E6374696F6E20637265617465436F6E7461696E657228706F736974696F6E29207B0A2020202020202020202020207661722024636F6E7461696E6572203D202428273C6469762F3E2729';
wwv_flow_api.g_varchar2_table(26) := '2E616464436C6173732827666F7374722D27202B20706F736974696F6E292E616464436C61737328676574436F6E7461696E6572436C6173732829293B0A202020202020202020202020242827626F647927292E617070656E642824636F6E7461696E65';
wwv_flow_api.g_varchar2_table(27) := '72293B0A202020202020202020202020636F6E7461696E6572735B706F736974696F6E5D203D2024636F6E7461696E65723B0A20202020202020202020202072657475726E2024636F6E7461696E65723B0A20202020202020207D0A0A20202020202020';
wwv_flow_api.g_varchar2_table(28) := '2072657475726E20636F6E7461696E6572735B706F736974696F6E5D207C7C20637265617465436F6E7461696E657228706F736974696F6E293B0A202020207D0A0A2020202066756E6374696F6E2067657444656661756C74732829207B0A2020202020';
wwv_flow_api.g_varchar2_table(29) := '20202072657475726E207B0A2020202020202020202020206469736D6973733A205B276F6E436C69636B272C20276F6E427574746F6E275D2C202F2F207768656E20746F206469736D69737320746865206E6F74696669636174696F6E0A202020202020';
wwv_flow_api.g_varchar2_table(30) := '2020202020206469736D69737341667465723A206E756C6C2C202F2F2061206E756D62657220696E206D696C6C697365636F6E647320616674657220776869636820746865206E6F74696669636174696F6E2073686F756C64206265206175746F6D6174';
wwv_flow_api.g_varchar2_table(31) := '6963616C6C792072656D6F7665642E20686F766572696E67206F7220636C69636B696E6720746865206E6F74696669636174696F6E2073746F70732074686973206576656E740A2020202020202020202020206E65776573744F6E546F703A2074727565';
wwv_flow_api.g_varchar2_table(32) := '2C202F2F2061646420746F2074686520746F70206F6620746865206C6973740A20202020202020202020202070726576656E744475706C6963617465733A2066616C73652C202F2F20646F206E6F742073686F7720746865206E6F74696669636174696F';
wwv_flow_api.g_varchar2_table(33) := '6E20696620697420686173207468652073616D65207469746C6520616E64206D65737361676520617320746865206C617374206F6E6520616E6420696620746865206C617374206F6E65206973207374696C6C2076697369626C650A2020202020202020';
wwv_flow_api.g_varchar2_table(34) := '2020202065736361706548746D6C3A20747275652C202F2F207768657468657220746F2065736361706520746865207469746C6520616E64206D6573736167650A202020202020202020202020706F736974696F6E3A2027746F702D7269676874272C20';
wwv_flow_api.g_varchar2_table(35) := '2F2F206F6E65206F6620363A205B746F707C626F74746F6D5D2D5B72696768747C63656E7465727C6C6566745D0A20202020202020202020202069636F6E436C6173733A206E756C6C2C202F2F207768656E206C65667420746F206E756C6C2C20697420';
wwv_flow_api.g_varchar2_table(36) := '77696C6C2062652064656661756C74656420746F2074686520636F72726573706F6E64696E672069636F6E2066726F6D2069636F6E436C61737365730A202020202020202020202020636C656172416C6C3A2066616C7365202F2F207472756520746F20';
wwv_flow_api.g_varchar2_table(37) := '636C65617220616C6C206E6F74696669636174696F6E732066697273740A20202020202020207D3B0A202020207D0A0A2020202066756E6374696F6E206765744F7074696F6E732829207B0A202020202020202072657475726E20242E657874656E6428';
wwv_flow_api.g_varchar2_table(38) := '7B7D2C2067657444656661756C747328292C20666F7374722E6F7074696F6E73293B0A202020207D0A0A2020202066756E6374696F6E206E6F74696679286D617029207B0A0A2020202020202020766172206F7074696F6E73203D20242E657874656E64';
wwv_flow_api.g_varchar2_table(39) := '287B7D2C206765744F7074696F6E7328292C206D6170293B0A20202020202020207661722024636F6E7461696E6572203D20676574436F6E7461696E6572286F7074696F6E732E706F736974696F6E293B0A0A2020202020202020766172206469736D69';
wwv_flow_api.g_varchar2_table(40) := '73734F6E436C69636B203D206F7074696F6E732E6469736D6973732E696E636C7564657328276F6E436C69636B27293B0A2020202020202020766172206469736D6973734F6E427574746F6E203D206F7074696F6E732E6469736D6973732E696E636C75';
wwv_flow_api.g_varchar2_table(41) := '64657328276F6E427574746F6E27293B0A0A20202020202020202F2A0A20202020202020203C64697620636C6173733D22666F732D416C65727420666F732D416C6572742D2D686F72697A6F6E74616C20666F732D416C6572742D2D7061676520666F73';
wwv_flow_api.g_varchar2_table(42) := '2D416C6572742D2D737563636573732220726F6C653D22616C657274223E0A2020202020202020202020203C64697620636C6173733D22666F732D416C6572742D77726170223E0A202020202020202020202020202020203C64697620636C6173733D22';
wwv_flow_api.g_varchar2_table(43) := '666F732D416C6572742D69636F6E223E0A20202020202020202020202020202020202020203C7370616E20636C6173733D22742D49636F6E2066612066612D636865636B2D636972636C65223E3C2F7370616E3E0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(44) := '203C2F6469763E0A202020202020202020202020202020203C64697620636C6173733D22666F732D416C6572742D636F6E74656E74223E0A20202020202020202020202020202020202020203C683220636C6173733D22666F732D416C6572742D746974';
wwv_flow_api.g_varchar2_table(45) := '6C65223E3C2F68323E0A20202020202020202020202020202020202020203C64697620636C6173733D22666F732D416C6572742D626F6479223E3C2F6469763E0A202020202020202020202020202020203C2F6469763E0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(46) := '202020203C64697620636C6173733D22666F732D416C6572742D627574746F6E73223E0A20202020202020202020202020202020202020203C627574746F6E20636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F554920742D427574';
wwv_flow_api.g_varchar2_table(47) := '746F6E2D2D69636F6E20742D427574746F6E2D2D636C6F7365416C6572742220747970653D22627574746F6E22207469746C653D22436C6F7365204E6F74696669636174696F6E223E3C7370616E20636C6173733D22742D49636F6E2069636F6E2D636C';
wwv_flow_api.g_varchar2_table(48) := '6F7365223E3C2F7370616E3E3C2F627574746F6E3E0A202020202020202020202020202020203C2F6469763E0A2020202020202020202020203C2F6469763E0A20202020202020203C2F6469763E0A20202020202020202A2F0A0A202020202020202076';
wwv_flow_api.g_varchar2_table(49) := '61722074797065436C617373203D207B0A2020202020202020202020202273756363657373223A2022666F732D416C6572742D2D73756363657373222C0A202020202020202020202020226572726F72223A2022666F732D416C6572742D2D64616E6765';
wwv_flow_api.g_varchar2_table(50) := '72222C0A202020202020202020202020227761726E696E67223A2022666F732D416C6572742D2D7761726E696E67222C0A20202020202020202020202022696E666F223A2022666F732D416C6572742D2D696E666F220A20202020202020207D3B0A0A20';
wwv_flow_api.g_varchar2_table(51) := '202020202020207661722024746F617374456C656D656E74203D202428273C64697620636C6173733D22666F732D416C65727420666F732D416C6572742D2D686F72697A6F6E74616C20666F732D416C6572742D2D706167652027202B2074797065436C';
wwv_flow_api.g_varchar2_table(52) := '6173735B6F7074696F6E732E747970655D202B20272220726F6C653D22616C657274223E3C2F6469763E27293B0A20202020202020207661722024746F61737457726170203D202428273C64697620636C6173733D22666F732D416C6572742D77726170';
wwv_flow_api.g_varchar2_table(53) := '223E27293B0A2020202020202020766172202469636F6E57726170203D202428273C64697620636C6173733D22666F732D416C6572742D69636F6E223E3C2F6469763E27293B0A2020202020202020766172202469636F6E456C656D203D202428273C73';
wwv_flow_api.g_varchar2_table(54) := '70616E20636C6173733D22742D49636F6E2066612027202B20286F7074696F6E732E69636F6E436C617373207C7C2069636F6E436C61737365735B6F7074696F6E732E747970655D29202B2027223E3C2F7370616E3E27293B0A20202020202020207661';
wwv_flow_api.g_varchar2_table(55) := '722024636F6E74656E74456C656D203D202428273C64697620636C6173733D22666F732D416C6572742D636F6E74656E74223E3C2F6469763E27293B0A202020202020202076617220247469746C65456C656D656E74203D202428273C683220636C6173';
wwv_flow_api.g_varchar2_table(56) := '733D22666F732D416C6572742D7469746C65223E3C2F68323E27293B0A202020202020202076617220246D657373616765456C656D656E74203D202428273C64697620636C6173733D22666F732D416C6572742D626F6479223E3C2F6469763E27293B0A';
wwv_flow_api.g_varchar2_table(57) := '20202020202020207661722024627574746F6E57726170706572203D202428273C64697620636C6173733D22666F732D416C6572742D627574746F6E73223E3C2F6469763E27293B0A20202020202020207661722024636C6F7365456C656D656E743B0A';
wwv_flow_api.g_varchar2_table(58) := '0A2020202020202020696620286469736D6973734F6E427574746F6E29207B0A20202020202020202020202024636C6F7365456C656D656E74203D202428273C627574746F6E20636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F55';
wwv_flow_api.g_varchar2_table(59) := '4920742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D636C6F7365416C6572742220747970653D22627574746F6E22207469746C653D22436C6F7365204E6F74696669636174696F6E223E3C7370616E20636C6173733D22742D49636F6E20';
wwv_flow_api.g_varchar2_table(60) := '69636F6E2D636C6F7365223E3C2F7370616E3E3C2F627574746F6E3E27293B0A20202020202020207D0A0A202020202020202024746F617374456C656D656E742E617070656E642824746F61737457726170293B0A202020202020202024746F61737457';
wwv_flow_api.g_varchar2_table(61) := '7261702E617070656E64282469636F6E57726170293B0A20202020202020202469636F6E577261702E617070656E64282469636F6E456C656D293B0A202020202020202024746F617374577261702E617070656E642824636F6E74656E74456C656D293B';
wwv_flow_api.g_varchar2_table(62) := '0A202020202020202024636F6E74656E74456C656D2E617070656E6428247469746C65456C656D656E74293B0A202020202020202024636F6E74656E74456C656D2E617070656E6428246D657373616765456C656D656E74293B0A202020202020202024';
wwv_flow_api.g_varchar2_table(63) := '746F617374577261702E617070656E642824627574746F6E57726170706572293B0A0A2020202020202020696620286469736D6973734F6E427574746F6E29207B0A20202020202020202020202024627574746F6E577261707065722E617070656E6428';
wwv_flow_api.g_varchar2_table(64) := '24636C6F7365456C656D656E74293B0A20202020202020207D0A0A20202020202020202F2F2073657474696E6720746865207469746C650A2020202020202020766172207469746C65203D206F7074696F6E732E7469746C653B0A202020202020202069';
wwv_flow_api.g_varchar2_table(65) := '6620287469746C6529207B0A202020202020202020202020696620286F7074696F6E732E65736361706548746D6C29207B0A202020202020202020202020202020207469746C65203D20617065782E7574696C2E65736361706548544D4C287469746C65';
wwv_flow_api.g_varchar2_table(66) := '293B0A2020202020202020202020207D0A202020202020202020202020247469746C65456C656D656E742E617070656E64287469746C65293B0A20202020202020207D0A0A20202020202020202F2F73657474696E6720746865206D6573736167650A20';
wwv_flow_api.g_varchar2_table(67) := '20202020202020766172206D657373616765203D206F7074696F6E732E6D6573736167653B0A2020202020202020696620286D65737361676529207B0A202020202020202020202020696620286F7074696F6E732E65736361706548746D6C29207B0A20';
wwv_flow_api.g_varchar2_table(68) := '2020202020202020202020202020206D657373616765203D20617065782E7574696C2E65736361706548544D4C286D657373616765293B0A2020202020202020202020207D0A202020202020202020202020246D657373616765456C656D656E742E6170';
wwv_flow_api.g_varchar2_table(69) := '70656E64286D657373616765293B0A20202020202020207D0A0A20202020202020202F2F2061766F6964696E67206475706C6963617465732C20627574206F6E6C7920636F6E7365637574697665206F6E65730A2020202020202020696620286F707469';
wwv_flow_api.g_varchar2_table(70) := '6F6E732E70726576656E744475706C6963617465732026262070726576696F7573546F6173742026262070726576696F7573546F6173742E24656C656D2026262070726576696F7573546F6173742E24656C656D2E697328273A76697369626C65272929';
wwv_flow_api.g_varchar2_table(71) := '207B0A2020202020202020202020206966202870726576696F7573546F6173742E7469746C65203D3D207469746C652026262070726576696F7573546F6173742E6D657373616765203D3D206D65737361676529207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(72) := '20202072657475726E3B0A2020202020202020202020207D0A20202020202020207D0A0A202020202020202070726576696F7573546F617374203D207B0A20202020202020202020202024656C656D3A2024746F617374456C656D656E742C0A20202020';
wwv_flow_api.g_varchar2_table(73) := '20202020202020207469746C653A207469746C652C0A2020202020202020202020206D6573736167653A206D6573736167650A20202020202020207D3B0A0A20202020202020202F2F206F7074696F6E616C6C7920636C65617220616C6C206D65737361';
wwv_flow_api.g_varchar2_table(74) := '6765732066697273740A2020202020202020696620286F7074696F6E732E636C656172416C6C29207B0A202020202020202020202020636C656172416C6C28293B0A20202020202020207D0A20202020202020202F2F206164647320746865206E6F7469';
wwv_flow_api.g_varchar2_table(75) := '6669636174696F6E20746F2074686520636F6E7461696E65720A2020202020202020696620286F7074696F6E732E6E65776573744F6E546F7029207B0A20202020202020202020202024636F6E7461696E65722E70726570656E642824746F617374456C';
wwv_flow_api.g_varchar2_table(76) := '656D656E74293B0A20202020202020207D20656C7365207B0A20202020202020202020202024636F6E7461696E65722E617070656E642824746F617374456C656D656E74293B0A20202020202020207D0A0A20202020202020202F2F2073657474696E67';
wwv_flow_api.g_varchar2_table(77) := '2074686520636F727265637420415249412076616C75650A2020202020202020766172206172696156616C75653B0A202020202020202073776974636820286F7074696F6E732E7479706529207B0A202020202020202020202020636173652027737563';
wwv_flow_api.g_varchar2_table(78) := '63657373273A0A202020202020202020202020636173652027696E666F273A0A202020202020202020202020202020206172696156616C7565203D2027706F6C697465273B0A20202020202020202020202020202020627265616B3B0A20202020202020';
wwv_flow_api.g_varchar2_table(79) := '202020202064656661756C743A0A202020202020202020202020202020206172696156616C7565203D2027617373657274697665273B0A20202020202020207D0A202020202020202024746F617374456C656D656E742E617474722827617269612D6C69';
wwv_flow_api.g_varchar2_table(80) := '7665272C206172696156616C7565293B0A0A20202020202020202F2F73657474696E672074696D657220616E642070726F6772657373206261720A2020202020202020766172202470726F6772657373456C656D656E74203D202428273C6469762F3E27';
wwv_flow_api.g_varchar2_table(81) := '293B0A2020202020202020696620286F7074696F6E732E6469736D6973734166746572203E203029207B0A2020202020202020202020202470726F6772657373456C656D656E742E616464436C6173732827666F7374722D70726F677265737327293B0A';
wwv_flow_api.g_varchar2_table(82) := '20202020202020202020202024746F617374456C656D656E742E617070656E64282470726F6772657373456C656D656E74293B0A0A2020202020202020202020207661722074696D656F75744964203D2073657454696D656F75742866756E6374696F6E';
wwv_flow_api.g_varchar2_table(83) := '2829207B0A2020202020202020202020202020202024746F617374456C656D656E742E72656D6F766528293B0A2020202020202020202020207D2C206F7074696F6E732E6469736D6973734166746572293B0A2020202020202020202020207661722070';
wwv_flow_api.g_varchar2_table(84) := '726F67726573735374617274416E696D44656C6179203D203130303B0A0A2020202020202020202020202470726F6772657373456C656D656E742E637373287B0A20202020202020202020202020202020277769647468273A202731303025272C0A2020';
wwv_flow_api.g_varchar2_table(85) := '2020202020202020202020202020277472616E736974696F6E273A202777696474682027202B2028286F7074696F6E732E6469736D6973734166746572202D2070726F67726573735374617274416E696D44656C6179292F3130303029202B202773206C';
wwv_flow_api.g_varchar2_table(86) := '696E656172270A2020202020202020202020207D293B0A20202020202020202020202073657454696D656F75742866756E6374696F6E28297B0A202020202020202020202020202020202470726F6772657373456C656D656E742E637373282777696474';
wwv_flow_api.g_varchar2_table(87) := '68272C20273027293B0A2020202020202020202020207D2C2070726F67726573735374617274416E696D44656C6179293B0A0A2020202020202020202020202F2F206F6E20686F766572206F7220636C69636B2C2072656D6F7665207468652074696D65';
wwv_flow_api.g_varchar2_table(88) := '7220616E642070726F6772657373206261720A20202020202020202020202024746F617374456C656D656E742E6F6E28276D6F7573656F76657220636C69636B272C2066756E6374696F6E2829207B0A20202020202020202020202020202020636C6561';
wwv_flow_api.g_varchar2_table(89) := '7254696D656F75742874696D656F75744964293B0A202020202020202020202020202020202470726F6772657373456C656D656E742E72656D6F766528293B0A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F';
wwv_flow_api.g_varchar2_table(90) := '2F68616E646C696E6720616E79206576656E74730A2020202020202020696620286469736D6973734F6E436C69636B29207B0A20202020202020202020202024746F617374456C656D656E742E6F6E2827636C69636B272C2066756E6374696F6E282920';
wwv_flow_api.g_varchar2_table(91) := '7B0A202020202020202020202020202020202F2F206F6E6C792072656D6F766520696620697420636F6E7461696E73206E6F206163746976652073656C656374696F6E0A202020202020202020202020202020207661722073656C656374696F6E203D20';
wwv_flow_api.g_varchar2_table(92) := '77696E646F772E67657453656C656374696F6E28293B0A202020202020202020202020202020206966282073656C656374696F6E202626200A202020202020202020202020202020202020202073656C656374696F6E2E74797065203D3D202752616E67';
wwv_flow_api.g_varchar2_table(93) := '65272026260A202020202020202020202020202020202020202073656C656374696F6E2E616E63686F724E6F64652026260A2020202020202020202020202020202020202020242873656C656374696F6E2E616E63686F724E6F64652C2024746F617374';
wwv_flow_api.g_varchar2_table(94) := '456C656D656E74292E6C656E677468203E2030297B0A2020202020202020202020202020202020202020200A202020202020202020202020202020202020202072657475726E3B0A202020202020202020202020202020207D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(95) := '20202020202024746F617374456C656D656E742E72656D6F766528293B0A2020202020202020202020207D293B0A20202020202020207D0A0A2020202020202020696620286469736D6973734F6E427574746F6E29207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(96) := '24636C6F7365456C656D656E742E6F6E2827636C69636B272C2066756E6374696F6E2829207B0A2020202020202020202020202020202024746F617374456C656D656E742E72656D6F766528293B0A2020202020202020202020207D293B0A2020202020';
wwv_flow_api.g_varchar2_table(97) := '2020207D0A0A20202020202020202F2F20706572686170732074686520646576656C6F7065722077616E747320746F20646F20736F6D657468696E67206164646974696F6E616C6C79207768656E20746865206E6F74696669636174696F6E2069732063';
wwv_flow_api.g_varchar2_table(98) := '6C69636B65640A202020202020202069662028747970656F66206F7074696F6E732E6F6E636C69636B203D3D3D202766756E6374696F6E2729207B0A20202020202020202020202024746F617374456C656D656E742E6F6E2827636C69636B272C206F70';
wwv_flow_api.g_varchar2_table(99) := '74696F6E732E6F6E636C69636B293B0A202020202020202020202020696620286469736D6973734F6E427574746F6E292024636C6F7365456C656D656E742E6F6E2827636C69636B272C206F7074696F6E732E6F6E636C69636B293B0A20202020202020';
wwv_flow_api.g_varchar2_table(100) := '207D0A0A202020202020202072657475726E2024746F617374456C656D656E743B0A202020207D0A0A2020202072657475726E207B0A2020202020202020737563636573733A20737563636573732C0A2020202020202020696E666F3A20696E666F2C0A';
wwv_flow_api.g_varchar2_table(101) := '20202020202020207761726E696E673A207761726E696E672C0A20202020202020206572726F723A206572726F722C0A2020202020202020636C656172416C6C3A20636C656172416C6C2C0A202020202020202076657273696F6E3A202732302E312E31';
wwv_flow_api.g_varchar2_table(102) := '270A202020207D3B0A0A7D2928293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41470236943975706)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/fostr.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E666F7374723D66756E6374696F6E28297B76617220653D2273756363657373222C743D22696E666F222C733D227761726E696E67222C6E3D226572726F72222C6F3D7B737563636573733A2266612D636865636B2D636972636C65222C';
wwv_flow_api.g_varchar2_table(2) := '696E666F3A2266612D696E666F2D636972636C65222C7761726E696E673A2266612D6578636C616D6174696F6E2D747269616E676C65222C6572726F723A2266612D74696D65732D636972636C65227D2C693D7B7D2C723D7B7D3B66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(3) := '6328652C742C73297B72657475726E22737472696E67223D3D747970656F6620743F28737C7C28733D742C743D766F69642030292C6C287B747970653A652C6D6573736167653A742C7469746C653A737D29293A226F626A656374223D3D747970656F66';
wwv_flow_api.g_varchar2_table(4) := '20743F28742E747970653D652C6C287429293A766F696420636F6E736F6C652E6572726F722827666F737472206E6F74696669636174696F6E20226D6573736167652220706172616D657465722074797065206E6F7420737570706F727465642C206D75';
wwv_flow_api.g_varchar2_table(5) := '7374206265206120737472696E67206F72206F626A65637427297D66756E6374696F6E206128297B2428222E666F7374722D636F6E7461696E657222292E6368696C6472656E28292E72656D6F766528297D66756E6374696F6E206C2865297B76617220';
wwv_flow_api.g_varchar2_table(6) := '742C732C6E3D242E657874656E64287B7D2C242E657874656E64287B7D2C7B6469736D6973733A5B226F6E436C69636B222C226F6E427574746F6E225D2C6469736D69737341667465723A6E756C6C2C6E65776573744F6E546F703A21302C7072657665';
wwv_flow_api.g_varchar2_table(7) := '6E744475706C6963617465733A21312C65736361706548746D6C3A21302C706F736974696F6E3A22746F702D7269676874222C69636F6E436C6173733A6E756C6C2C636C656172416C6C3A21317D2C666F7374722E6F7074696F6E73292C65292C633D28';
wwv_flow_api.g_varchar2_table(8) := '743D6E2E706F736974696F6E2C695B745D7C7C66756E6374696F6E2865297B76617220743D2428223C6469762F3E22292E616464436C6173732822666F7374722D222B65292E616464436C6173732822666F7374722D636F6E7461696E657222293B7265';
wwv_flow_api.g_varchar2_table(9) := '7475726E20242822626F647922292E617070656E642874292C695B655D3D742C747D287429292C6C3D6E2E6469736D6973732E696E636C7564657328226F6E436C69636B22292C703D6E2E6469736D6973732E696E636C7564657328226F6E427574746F';
wwv_flow_api.g_varchar2_table(10) := '6E22292C643D2428273C64697620636C6173733D22666F732D416C65727420666F732D416C6572742D2D686F72697A6F6E74616C20666F732D416C6572742D2D7061676520272B7B737563636573733A22666F732D416C6572742D2D7375636365737322';
wwv_flow_api.g_varchar2_table(11) := '2C6572726F723A22666F732D416C6572742D2D64616E676572222C7761726E696E673A22666F732D416C6572742D2D7761726E696E67222C696E666F3A22666F732D416C6572742D2D696E666F227D5B6E2E747970655D2B272220726F6C653D22616C65';
wwv_flow_api.g_varchar2_table(12) := '7274223E3C2F6469763E27292C663D2428273C64697620636C6173733D22666F732D416C6572742D77726170223E27292C753D2428273C64697620636C6173733D22666F732D416C6572742D69636F6E223E3C2F6469763E27292C763D2428273C737061';
wwv_flow_api.g_varchar2_table(13) := '6E20636C6173733D22742D49636F6E20666120272B286E2E69636F6E436C6173737C7C6F5B6E2E747970655D292B27223E3C2F7370616E3E27292C6D3D2428273C64697620636C6173733D22666F732D416C6572742D636F6E74656E74223E3C2F646976';
wwv_flow_api.g_varchar2_table(14) := '3E27292C413D2428273C683220636C6173733D22666F732D416C6572742D7469746C65223E3C2F68323E27292C673D2428273C64697620636C6173733D22666F732D416C6572742D626F6479223E3C2F6469763E27292C773D2428273C64697620636C61';
wwv_flow_api.g_varchar2_table(15) := '73733D22666F732D416C6572742D627574746F6E73223E3C2F6469763E27293B70262628733D2428273C627574746F6E20636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F554920742D427574746F6E2D2D69636F6E20742D427574';
wwv_flow_api.g_varchar2_table(16) := '746F6E2D2D636C6F7365416C6572742220747970653D22627574746F6E22207469746C653D22436C6F7365204E6F74696669636174696F6E223E3C7370616E20636C6173733D22742D49636F6E2069636F6E2D636C6F7365223E3C2F7370616E3E3C2F62';
wwv_flow_api.g_varchar2_table(17) := '7574746F6E3E2729292C642E617070656E642866292C662E617070656E642875292C752E617070656E642876292C662E617070656E64286D292C6D2E617070656E642841292C6D2E617070656E642867292C662E617070656E642877292C702626772E61';
wwv_flow_api.g_varchar2_table(18) := '7070656E642873293B76617220683D6E2E7469746C653B682626286E2E65736361706548746D6C262628683D617065782E7574696C2E65736361706548544D4C286829292C412E617070656E64286829293B76617220793D6E2E6D6573736167653B6966';
wwv_flow_api.g_varchar2_table(19) := '28792626286E2E65736361706548746D6C262628793D617065782E7574696C2E65736361706548544D4C287929292C672E617070656E64287929292C21286E2E70726576656E744475706C6963617465732626722626722E24656C656D2626722E24656C';
wwv_flow_api.g_varchar2_table(20) := '656D2E697328223A76697369626C6522292626722E7469746C653D3D682626722E6D6573736167653D3D7929297B766172206B3B73776974636828723D7B24656C656D3A642C7469746C653A682C6D6573736167653A797D2C6E2E636C656172416C6C26';
wwv_flow_api.g_varchar2_table(21) := '266128292C6E2E6E65776573744F6E546F703F632E70726570656E642864293A632E617070656E642864292C6E2E74797065297B636173652273756363657373223A6361736522696E666F223A6B3D22706F6C697465223B627265616B3B64656661756C';
wwv_flow_api.g_varchar2_table(22) := '743A6B3D22617373657274697665227D642E617474722822617269612D6C697665222C6B293B76617220623D2428223C6469762F3E22293B6966286E2E6469736D69737341667465723E30297B622E616464436C6173732822666F7374722D70726F6772';
wwv_flow_api.g_varchar2_table(23) := '65737322292C642E617070656E642862293B76617220433D73657454696D656F7574282866756E6374696F6E28297B642E72656D6F766528297D292C6E2E6469736D6973734166746572293B622E637373287B77696474683A2231303025222C7472616E';
wwv_flow_api.g_varchar2_table(24) := '736974696F6E3A22776964746820222B286E2E6469736D69737341667465722D313030292F3165332B2273206C696E656172227D292C73657454696D656F7574282866756E6374696F6E28297B622E63737328227769647468222C223022297D292C3130';
wwv_flow_api.g_varchar2_table(25) := '30292C642E6F6E28226D6F7573656F76657220636C69636B222C2866756E6374696F6E28297B636C65617254696D656F75742843292C622E72656D6F766528297D29297D72657475726E206C2626642E6F6E2822636C69636B222C2866756E6374696F6E';
wwv_flow_api.g_varchar2_table(26) := '28297B76617220653D77696E646F772E67657453656C656374696F6E28293B6526262252616E6765223D3D652E747970652626652E616E63686F724E6F646526262428652E616E63686F724E6F64652C64292E6C656E6774683E307C7C642E72656D6F76';
wwv_flow_api.g_varchar2_table(27) := '6528297D29292C702626732E6F6E2822636C69636B222C2866756E6374696F6E28297B642E72656D6F766528297D29292C2266756E6374696F6E223D3D747970656F66206E2E6F6E636C69636B262628642E6F6E2822636C69636B222C6E2E6F6E636C69';
wwv_flow_api.g_varchar2_table(28) := '636B292C702626732E6F6E2822636C69636B222C6E2E6F6E636C69636B29292C647D7D72657475726E7B737563636573733A66756E6374696F6E28742C73297B6328652C742C73297D2C696E666F3A66756E6374696F6E28652C73297B6328742C652C73';
wwv_flow_api.g_varchar2_table(29) := '297D2C7761726E696E673A66756E6374696F6E28652C74297B6328732C652C74297D2C6572726F723A66756E6374696F6E28652C74297B63286E2C652C74297D2C636C656172416C6C3A612C76657273696F6E3A2232302E312E31227D7D28293B0A2F2F';
wwv_flow_api.g_varchar2_table(30) := '2320736F757263654D617070696E6755524C3D666F7374722E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41471015266977100)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/fostr.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin

wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22666F7374722E6A73225D2C226E616D6573223A5B2277696E646F77222C22666F737472222C22746F61737454797065222C2269636F6E436C6173736573222C2273756363657373222C2269';
wwv_flow_api.g_varchar2_table(2) := '6E666F222C227761726E696E67222C226572726F72222C22636F6E7461696E657273222C2270726576696F7573546F617374222C226E6F7469667954797065222C2274797065222C226D657373616765222C227469746C65222C22756E646566696E6564';
wwv_flow_api.g_varchar2_table(3) := '222C226E6F74696679222C22636F6E736F6C65222C22636C656172416C6C222C2224222C226368696C6472656E222C2272656D6F7665222C226D6170222C22706F736974696F6E222C2224636C6F7365456C656D656E74222C226F7074696F6E73222C22';
wwv_flow_api.g_varchar2_table(4) := '657874656E64222C226469736D697373222C226469736D6973734166746572222C226E65776573744F6E546F70222C2270726576656E744475706C696361746573222C2265736361706548746D6C222C2269636F6E436C617373222C2224636F6E746169';
wwv_flow_api.g_varchar2_table(5) := '6E6572222C22616464436C617373222C22617070656E64222C22637265617465436F6E7461696E6572222C226469736D6973734F6E436C69636B222C22696E636C75646573222C226469736D6973734F6E427574746F6E222C2224746F617374456C656D';
wwv_flow_api.g_varchar2_table(6) := '656E74222C2224746F61737457726170222C222469636F6E57726170222C222469636F6E456C656D222C2224636F6E74656E74456C656D222C22247469746C65456C656D656E74222C22246D657373616765456C656D656E74222C2224627574746F6E57';
wwv_flow_api.g_varchar2_table(7) := '726170706572222C2261706578222C227574696C222C2265736361706548544D4C222C2224656C656D222C226973222C226172696156616C7565222C2270726570656E64222C2261747472222C222470726F6772657373456C656D656E74222C2274696D';
wwv_flow_api.g_varchar2_table(8) := '656F75744964222C2273657454696D656F7574222C22637373222C227769647468222C227472616E736974696F6E222C226F6E222C22636C65617254696D656F7574222C2273656C656374696F6E222C2267657453656C656374696F6E222C22616E6368';
wwv_flow_api.g_varchar2_table(9) := '6F724E6F6465222C226C656E677468222C226F6E636C69636B222C2276657273696F6E225D2C226D617070696E6773223A224141734241412C4F41414F432C4D4141512C574145582C49414149432C454143532C55414454412C4541454D2C4F41464E41';
wwv_flow_api.g_varchar2_table(10) := '2C454147532C55414854412C4541494F2C51414750432C454141632C43414364432C514141532C6B42414354432C4B41414D2C694241434E432C514141532C3042414354432C4D41414F2C6D42414750432C454141612C47414362432C45414167422C47';
wwv_flow_api.g_varchar2_table(11) := '414570422C53414153432C45414157432C4541414D432C45414153432C4741432F422C4D414175422C694241415A442C47414346432C49414344412C45414151442C45414352412C4F414155452C47414550432C4541414F2C434143564A2C4B41414D41';
wwv_flow_api.g_varchar2_table(12) := '2C4541434E432C51414153412C45414354432C4D41414F412C4B4145652C694241415A442C47414364412C45414151442C4B41414F412C45414352492C4541414F482C53414564492C51414151542C4D41414D2C7946416F4274422C53414153552C4941';
wwv_flow_api.g_varchar2_table(13) := '434C432C454141452C6F4241413242432C57414157432C5341734335432C534141534C2C4541414F4D2C4741455A2C49412F426B42432C4541714564432C4541744341432C454141554E2C454141454F2C4F41414F2C47414C6842502C454141454F2C4F';
wwv_flow_api.g_varchar2_table(14) := '41414F2C474162542C43414348432C514141532C434141432C554141572C5941437242432C614141632C4B414364432C614141612C45414362432C6D4241416D422C4541436E42432C594141592C4541435A522C534141552C59414356532C554141572C';
wwv_flow_api.g_varchar2_table(15) := '4B414358642C554141552C47414B714268422C4D41414D75422C53414B41482C4741437243572C4741684363562C4541674359452C45414151462C534176422F42642C45414157632C4941506C422C5341417942412C47414372422C49414149552C4541';
wwv_flow_api.g_varchar2_table(16) := '4161642C454141452C55414155652C534141532C53414157582C47414155572C53414E78442C6D424153482C4F414641662C454141452C5141415167422C4F41414F462C4741436A4278422C45414157632C47414159552C4541436842412C4541476F42';
wwv_flow_api.g_varchar2_table(17) := '472C4341416742622C494179423343632C45414169425A2C45414151452C51414151572C534141532C5741433143432C4541416B42642C45414151452C51414151572C534141532C594130423343452C454141674272422C454141452C2B4441504E2C43';
wwv_flow_api.g_varchar2_table(18) := '41435A642C514141572C7142414358472C4D4141532C6F42414354442C514141572C7142414358442C4B4141512C6D42414771466D422C45414151622C4D4141512C79424143374736422C4541416174422C454141452C674341436675422C4541415976';
wwv_flow_api.g_varchar2_table(19) := '422C454141452C734341436477422C4541415978422C454141452C3242414136424D2C454141514F2C5741416135422C4541415971422C45414151622C4F4141532C614143374667432C454141657A422C454141452C794341436A4230422C4541416742';
wwv_flow_api.g_varchar2_table(20) := '31422C454141452C714341436C4232422C4541416B4233422C454141452C73434143704234422C454141694235422C454141452C794341476E426F422C49414341662C45414167424C2C454141452C304B4147744271422C454141634C2C4F41414F4D2C';
wwv_flow_api.g_varchar2_table(21) := '4741437242412C454141574E2C4F41414F4F2C4741436C42412C45414155502C4F41414F512C4741436A42462C454141574E2C4F41414F532C4741436C42412C45414161542C4F41414F552C4741437042442C45414161542C4F41414F572C4741437042';
wwv_flow_api.g_varchar2_table(22) := '4C2C454141574E2C4F41414F592C47414564522C47414341512C454141655A2C4F41414F582C47414931422C49414149562C45414151572C45414151582C4D41436842412C49414349572C454141514D2C614143526A422C454141516B432C4B41414B43';
wwv_flow_api.g_varchar2_table(23) := '2C4B41414B432C5741415770432C4941456A432B422C45414163562C4F41414F72422C4941497A422C49414149442C45414155592C454141515A2C51415374422C47415249412C49414349592C454141514D2C614143526C422C454141556D432C4B4141';
wwv_flow_api.g_varchar2_table(24) := '4B432C4B41414B432C5741415772432C4941456E4369432C4541416742582C4F41414F74422C4D41497642592C454141514B2C6D424141714270422C4741416942412C4541416379432C4F4141537A432C4541416379432C4D41414D432C474141472C61';
wwv_flow_api.g_varchar2_table(25) := '4143784631432C45414163492C4F414153412C474141534A2C45414163472C53414157412C4741446A452C43417742412C4941414977432C4541434A2C4F416E424133432C45414167422C4341435A79432C4D41414F582C4541435031422C4D41414F41';
wwv_flow_api.g_varchar2_table(26) := '2C45414350442C51414153412C47414954592C45414151502C55414352412C494147414F2C45414151492C59414352492C4541415771422C51414151642C4741456E42502C45414157452C4F41414F4B2C47414B64662C45414151622C4D41435A2C4941';
wwv_flow_api.g_varchar2_table(27) := '414B2C5541434C2C4941414B2C4F41434479432C454141592C5341435A2C4D41434A2C51414349412C454141592C5941457042622C45414163652C4B41414B2C59414161462C47414768432C49414149472C4541416D4272432C454141452C5541437A42';
wwv_flow_api.g_varchar2_table(28) := '2C474141494D2C45414151472C614141652C454141472C434143314234422C454141694274422C534141532C6B42414331424D2C454141634C2C4F41414F71422C47414572422C49414149432C45414159432C594141572C57414376426C422C45414163';
wwv_flow_api.g_varchar2_table(29) := '6E422C57414366492C45414151472C6341475834422C4541416942472C494141492C4341436A42432C4D4141532C4F414354432C574141632C5541416170432C45414151472C61414A562C4B414969442C494141512C614145744638422C594141572C57';
wwv_flow_api.g_varchar2_table(30) := '414350462C4541416942472C494141492C514141532C4F41504C2C4B415737426E422C4541416373422C474141472C6D4241416D422C5741436843432C614141614E2C47414362442C45414169426E432C594167437A422C4F4133424967422C47414341';
wwv_flow_api.g_varchar2_table(31) := '472C4541416373422C474141472C534141532C57414574422C49414149452C454141592F442C4F41414F67452C6541436E42442C4741436B422C5341416C42412C4541415570442C4D4143566F442C45414155452C594143562F432C4541414536432C45';
wwv_flow_api.g_varchar2_table(32) := '414155452C5741415931422C4741416532422C4F4141532C474149704433422C454141636E422C5941496C426B422C47414341662C4541416373432C474141472C534141532C574143744274422C454141636E422C59414B532C6D4241417042492C4541';
wwv_flow_api.g_varchar2_table(33) := '415132432C5541436635422C4541416373422C474141472C5141415372432C4541415132432C534143394237422C4741416942662C4541416373432C474141472C5141415372432C4541415132432C554147704435422C474147582C4D41414F2C434143';
wwv_flow_api.g_varchar2_table(34) := '486E432C51416A4F4A2C5341416942512C45414153432C4741437442482C45414157522C4541416D42552C45414153432C4941694F7643522C4B41314E4A2C534141634F2C45414153432C4741436E42482C45414157522C4541416742552C4541415343';
wwv_flow_api.g_varchar2_table(35) := '2C4941304E7043502C51412F4E4A2C53414169424D2C45414153432C4741437442482C45414157522C4541416D42552C45414153432C49412B4E76434E2C4D41784E4A2C534141654B2C45414153432C4741437042482C45414157522C4541416942552C';
wwv_flow_api.g_varchar2_table(36) := '45414153432C4941774E7243492C53414155412C454143566D442C514141532C5541355146222C2266696C65223A22666F7374722E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41471423266977101)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/fostr.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A0A094E6F7465730A09092A206162736F6C757465206C65667420616E642072696768742076616C7565732073686F756C64206E6F7720626520706C61636573206F6E2074686520636F6E7461696E657220656C656D656E742C206E6F7420746865';
wwv_flow_api.g_varchar2_table(2) := '20696E646976696475616C206E6F74696669636174696F6E730A0A2A2F0A0A40675F436F6E7461696E65722D426F726465725261646975733A203270783B0A40675F5761726E696E672D42473A20236662636634613B0A40675F537563636573732D4247';
wwv_flow_api.g_varchar2_table(3) := '3A20233342414132433B0A40675F44616E6765722D42473A20236634343333363B0A40675F496E666F2D42473A20233030373664663B0A0A40675F416363656E742D4F473A20234644464446443B0A40675F526567696F6E2D4865616465722D42473A20';
wwv_flow_api.g_varchar2_table(4) := '6C69676874656E2840675F416363656E742D4F472C203425293B0A40675F526567696F6E2D42473A206C69676874656E2840675F526567696F6E2D4865616465722D42472C20323025293B0A0A40675F526567696F6E2D46473A206661646528636F6E74';
wwv_flow_api.g_varchar2_table(5) := '726173742840675F526567696F6E2D42472C2064657361747572617465286461726B656E2840675F526567696F6E2D42472C2020383525292C2031303025292C2064657361747572617465286C69676874656E2840675F526567696F6E2D42472C202038';
wwv_flow_api.g_varchar2_table(6) := '3525292C2035302529292C2031303025293B0A0A40675F537563636573732D46473A20234646463B0A40675F44616E6765722D46473A20234646463B0A40675F496E666F2D46473A20234646463B0A40675F5761726E696E672D46473A20636F6E747261';
wwv_flow_api.g_varchar2_table(7) := '73742840675F5761726E696E672D42472C206461726B656E2840675F5761726E696E672D42472C202020353025292C206C69676874656E2840675F5761726E696E672D42472C202020353025292C2020343325293B0A2F2A2A0A202A20436F6C6F72697A';
wwv_flow_api.g_varchar2_table(8) := '6564204261636B67726F756E640A202A2F0A202E666F732D416C6572742D2D686F72697A6F6E74616C207B0A202020626F726465722D7261646975733A2040675F436F6E7461696E65722D426F726465725261646975730A207D0A200A202E666F732D41';
wwv_flow_api.g_varchar2_table(9) := '6C6572742D69636F6E202E742D49636F6E207B0A202020636F6C6F723A20234646463B0A207D0A200A200A202F2A2A0A20202A204D6F6469666965723A205761726E696E670A20202A2F0A202E666F732D416C6572742D2D7761726E696E677B0A202020';
wwv_flow_api.g_varchar2_table(10) := '2E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F5761726E696E672D42473B0A2020207D0A200A202020262E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E20';
wwv_flow_api.g_varchar2_table(11) := '7B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F5761726E696E672D42472C20383525293B0A2020207D0A207D0A200A200A202F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A202E666F73';
wwv_flow_api.g_varchar2_table(12) := '2D416C6572742D2D73756363657373207B0A2020202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F537563636573732D42473B0A2020207D0A200A202020262E666F732D416C6572742D2D686F72697A6F';
wwv_flow_api.g_varchar2_table(13) := '6E74616C202E666F732D416C6572742D69636F6E207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F537563636573732D42472C20383525293B0A2020207D0A207D0A200A202F2A2A0A20202A204D6F6469666965723A';
wwv_flow_api.g_varchar2_table(14) := '20496E666F726D6174696F6E0A20202A2F0A202E666F732D416C6572742D2D696E666F207B0A2020202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F496E666F2D42473B0A2020207D0A200A202020262E';
wwv_flow_api.g_varchar2_table(15) := '666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F496E666F2D42472C20383525293B0A2020207D0A207D0A200A202F2A2A';
wwv_flow_api.g_varchar2_table(16) := '0A20202A204D6F6469666965723A20537563636573730A20202A2F0A202E666F732D416C6572742D2D64616E6765727B0A2020202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F44616E6765722D42473B';
wwv_flow_api.g_varchar2_table(17) := '0A2020207D0A200A202020262E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F44616E6765722D42472C20383525293B';
wwv_flow_api.g_varchar2_table(18) := '0A2020207D0A207D0A200A202E666F732D416C6572742D2D686F72697A6F6E74616C7B0A2020206261636B67726F756E642D636F6C6F723A2040675F526567696F6E2D42473B0A202020636F6C6F723A2040675F526567696F6E2D46473B0A207D0A0A2F';
wwv_flow_api.g_varchar2_table(19) := '2A0A2E666F732D416C6572742D2D64616E6765727B0A094062673A206C69676874656E2840675F44616E6765722D42472C20343025293B0A096261636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661646528636F6E74726173';
wwv_flow_api.g_varchar2_table(20) := '74284062672C2064657361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B0A7D0A2E666F732D416C';
wwv_flow_api.g_varchar2_table(21) := '6572742D2D696E666F207B0A094062673A206C69676874656E2840675F496E666F2D42472C20353525293B0A096261636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661646528636F6E7472617374284062672C206465736174';
wwv_flow_api.g_varchar2_table(22) := '7572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B0A7D0A2A2F0A0A202E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(23) := '6765207B0A202020262E666F732D416C6572742D2D73756363657373207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F537563636573732D42472C20313025293B0A0920636F6C6F723A2040675F537563636573732D';
wwv_flow_api.g_varchar2_table(24) := '46473B0A200A09202E666F732D416C6572742D69636F6E207B0A092020206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A09202020636F6C6F723A2040675F537563636573732D46473B0A200A092020202E742D49636F6E';
wwv_flow_api.g_varchar2_table(25) := '207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A09207D0A200A09202E742D427574746F6E2D2D636C6F7365416C657274207B0A09202020636F6C6F723A2040675F537563636573732D46472021696D706F7274616E743B0A09207D';
wwv_flow_api.g_varchar2_table(26) := '0A2020207D0A2020262E666F732D416C6572742D2D7761726E696E67207B0A202020206261636B67726F756E642D636F6C6F723A2040675F5761726E696E672D42473B0A20202020636F6C6F723A2040675F5761726E696E672D46473B0A0A09202E666F';
wwv_flow_api.g_varchar2_table(27) := '732D416C6572742D69636F6E207B0A092020206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A09202020636F6C6F723A2040675F5761726E696E672D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F72';
wwv_flow_api.g_varchar2_table(28) := '3A20696E68657269743B0A092020207D0A09207D0A200A09202E742D427574746F6E2D2D636C6F7365416C657274207B0A09202020636F6C6F723A2040675F537563636573732D46472021696D706F7274616E743B0A09207D0A20207D0A2020262E666F';
wwv_flow_api.g_varchar2_table(29) := '732D416C6572742D2D696E666F207B0A202020206261636B67726F756E642D636F6C6F723A2040675F496E666F2D42473B0A20202020636F6C6F723A2040675F496E666F2D46473B0A0A09202E666F732D416C6572742D69636F6E207B0A092020206261';
wwv_flow_api.g_varchar2_table(30) := '636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A09202020636F6C6F723A2040675F496E666F2D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A09207D0A200A09';
wwv_flow_api.g_varchar2_table(31) := '202E742D427574746F6E2D2D636C6F7365416C657274207B0A09202020636F6C6F723A2040675F496E666F2D46472021696D706F7274616E743B0A09207D0A20207D0A202020262E666F732D416C6572742D2D64616E676572207B0A202020206261636B';
wwv_flow_api.g_varchar2_table(32) := '67726F756E642D636F6C6F723A2040675F44616E6765722D42473B0A20202020636F6C6F723A2040675F44616E6765722D46473B0A0A09202E666F732D416C6572742D69636F6E207B0A092020206261636B67726F756E642D636F6C6F723A207472616E';
wwv_flow_api.g_varchar2_table(33) := '73706172656E743B0A09202020636F6C6F723A2040675F44616E6765722D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A09207D0A200A09202E742D427574746F6E2D2D636C6F736541';
wwv_flow_api.g_varchar2_table(34) := '6C657274207B0A09202020636F6C6F723A2040675F44616E6765722D46472021696D706F7274616E743B0A09207D0A20207D0A7D0A0A2F2A20486F72697A6F6E74616C20416C657274203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(35) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B206D617267696E2D626F74746F6D3A20312E3672656D3B20';
wwv_flow_api.g_varchar2_table(36) := '706F736974696F6E3A2072656C61746976653B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D77726170207B20646973706C61793A20666C65783B20666C65782D646972656374696F6E3A20726F773B20';
wwv_flow_api.g_varchar2_table(37) := '7D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B2070616464696E673A203020313670783B20666C65782D736872696E6B3A20303B20646973706C61793A20666C65783B20616C69676E2D6974';
wwv_flow_api.g_varchar2_table(38) := '656D733A2063656E7465723B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D636F6E74656E74207B2070616464696E673A20313670783B20666C65783A203120303B20646973706C61793A20666C65783B';
wwv_flow_api.g_varchar2_table(39) := '20666C65782D646972656374696F6E3A20636F6C756D6E3B206A7573746966792D636F6E74656E743A2063656E7465723B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B20666C65';
wwv_flow_api.g_varchar2_table(40) := '782D736872696E6B3A20303B20746578742D616C69676E3A2072696768743B2077686974652D73706163653A206E6F777261703B2070616464696E672D72696768743A20312E3672656D3B20646973706C61793A20666C65783B20616C69676E2D697465';
wwv_flow_api.g_varchar2_table(41) := '6D733A2063656E7465723B207D0A0A2E752D52544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B2070616464696E672D72696768743A20303B2070616464696E672D6C6566743A20312E';
wwv_flow_api.g_varchar2_table(42) := '3672656D3B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D707479207B20646973706C61793A206E6F6E653B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C20';
wwv_flow_api.g_varchar2_table(43) := '2E666F732D416C6572742D7469746C65207B20666F6E742D73697A653A20322E3072656D3B206C696E652D6865696768743A20322E3472656D3B206D617267696E2D626F74746F6D3A20303B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74';
wwv_flow_api.g_varchar2_table(44) := '616C202E666F732D416C6572742D626F64793A656D707479207B20646973706C61793A206E6F6E653B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E202E742D49636F6E207B20666F6E742D73';
wwv_flow_api.g_varchar2_table(45) := '697A653A20333270783B2077696474683A20333270783B20746578742D616C69676E3A2063656E7465723B206865696768743A20333270783B206C696E652D6865696768743A20313B207D0A0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(46) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20436F6D6D6F6E2050726F70657274696573203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(47) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B20626F726465723A2031707820736F6C696420726762612830';
wwv_flow_api.g_varchar2_table(48) := '2C20302C20302C20302E31293B20626F782D736861646F773A20302032707820347078202D327078207267626128302C20302C20302C20302E303735293B207D0A0A2E666F732D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F7269';
wwv_flow_api.g_varchar2_table(49) := '7A6F6E74616C202E666F732D416C6572742D69636F6E207B20646973706C61793A206E6F6E652021696D706F7274616E743B207D0A0A2E666F732D416C6572742D2D6E6F49636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E207B2064';
wwv_flow_api.g_varchar2_table(50) := '6973706C61793A206E6F6E653B207D0A0A2E742D426F64792D616C657274207B206D617267696E3A20303B207D0A0A2E742D426F64792D616C657274202E666F732D416C657274207B206D617267696E2D626F74746F6D3A20303B207D0A0A2F2A205061';
wwv_flow_api.g_varchar2_table(51) := '6765204E6F74696669636174696F6E202853756363657373206F72204D65737361676529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(52) := '3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D70616765207B207472616E736974696F6E3A202E327320656173652D6F75743B206D61782D77696474683A2036343070783B206D696E2D77696474683A2033323070783B202F2A706F';
wwv_flow_api.g_varchar2_table(53) := '736974696F6E3A2066697865643B20746F703A20312E3672656D3B2072696768743A20312E3672656D3B2A2F207A2D696E6465783A20313030303B20626F726465722D77696474683A20303B20626F782D736861646F773A20302030203020302E317265';
wwv_flow_api.g_varchar2_table(54) := '6D207267626128302C20302C20302C20302E312920696E7365742C20302033707820397078202D327078207267626128302C20302C20302C20302E31293B202F2A20466F72207665727920736D616C6C2073637265656E732C2066697420746865206D65';
wwv_flow_api.g_varchar2_table(55) := '737361676520746F2074686520746F70206F66207468652073637265656E202A2F202F2A2053657420426F726465722052616469757320746F2030206173206D657373616765206578697374732077697468696E20636F6E74656E74202A2F202F2A2050';
wwv_flow_api.g_varchar2_table(56) := '616765204C6576656C205761726E696E6720616E64204572726F7273203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(57) := '3D3D3D202A2F202F2A205363726F6C6C62617273202A2F207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D627574746F6E73207B2070616464696E672D72696768743A20303B207D0A0A2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(58) := '6765202E666F732D416C6572742D69636F6E207B2070616464696E672D6C6566743A20312E3672656D3B2070616464696E672D72696768743A203870783B207D0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C657274';
wwv_flow_api.g_varchar2_table(59) := '2D69636F6E207B2070616464696E672D6C6566743A203870783B2070616464696E672D72696768743A20312E3672656D3B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E202E742D49636F6E207B20666F6E74';
wwv_flow_api.g_varchar2_table(60) := '2D73697A653A20323470783B2077696474683A20323470783B206865696768743A20323470783B206C696E652D6865696768743A20313B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B2070616464696E';
wwv_flow_api.g_varchar2_table(61) := '672D626F74746F6D3A203870783B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D636F6E74656E74207B2070616464696E673A203870783B207D0A0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D';
wwv_flow_api.g_varchar2_table(62) := '2D636C6F7365416C657274207B20706F736974696F6E3A206162736F6C7574653B2072696768743A202D3870783B20746F703A202D3870783B2070616464696E673A203470783B206D696E2D77696474683A20303B206261636B67726F756E642D636F6C';
wwv_flow_api.g_varchar2_table(63) := '6F723A20233030302021696D706F7274616E743B20636F6C6F723A20234646462021696D706F7274616E743B20626F782D736861646F773A203020302030203170782072676261283235352C203235352C203235352C20302E3235292021696D706F7274';
wwv_flow_api.g_varchar2_table(64) := '616E743B20626F726465722D7261646975733A20323470783B207472616E736974696F6E3A202D7765626B69742D7472616E73666F726D20302E3132357320656173653B207472616E736974696F6E3A207472616E73666F726D20302E31323573206561';
wwv_flow_api.g_varchar2_table(65) := '73653B207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173652C202D7765626B69742D7472616E73666F726D20302E3132357320656173653B207D0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E742D';
wwv_flow_api.g_varchar2_table(66) := '427574746F6E2D2D636C6F7365416C657274207B2072696768743A206175746F3B206C6566743A202D3870783B207D0A0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A686F766572207B202D776562';
wwv_flow_api.g_varchar2_table(67) := '6B69742D7472616E73666F726D3A207363616C6528312E3135293B207472616E73666F726D3A207363616C6528312E3135293B207D0A0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A616374697665';
wwv_flow_api.g_varchar2_table(68) := '207B202D7765626B69742D7472616E73666F726D3A207363616C6528302E3835293B207472616E73666F726D3A207363616C6528302E3835293B207D0A0A2F2A2E752D52544C202E666F732D416C6572742D2D70616765207B2072696768743A20617574';
wwv_flow_api.g_varchar2_table(69) := '6F3B206C6566743A20312E3672656D3B207D2A2F0A0A2E666F732D416C6572742D2D706167652E666F732D416C657274207B20626F726465722D7261646975733A20302E3472656D3B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D41';
wwv_flow_api.g_varchar2_table(70) := '6C6572742D7469746C65207B2070616464696E673A2038707820303B207D0A0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E207B206D617267696E2D72696768743A20';
wwv_flow_api.g_varchar2_table(71) := '3870783B207D0A0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C65207B20666F6E742D73697A653A20312E3472656D3B206C696E652D6865696768743A20';
wwv_flow_api.g_varchar2_table(72) := '3272656D3B20666F6E742D7765696768743A203730303B206D617267696E3A20303B207D0A0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D6C697374207B206D6178';
wwv_flow_api.g_varchar2_table(73) := '2D6865696768743A2031323870783B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B206D61782D6865696768743A20393670783B206F766572666C6F773A206175746F3B207D0A0A2E666F73';
wwv_flow_api.g_varchar2_table(74) := '2D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C696E6B3A686F766572207B20746578742D6465636F726174696F6E3A20756E6465726C696E653B207D0A0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D';
wwv_flow_api.g_varchar2_table(75) := '7363726F6C6C626172207B2077696474683A203870783B206865696768743A203870783B207D0A0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D7468756D62207B206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(76) := '723A207267626128302C20302C20302C20302E3235293B207D0A0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D747261636B207B206261636B67726F756E642D636F6C6F723A207267626128302C20302C';
wwv_flow_api.g_varchar2_table(77) := '20302C20302E3035293B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B20646973706C61793A20626C6F636B3B20666F6E742D7765696768743A203730303B20666F6E742D73697A653A20312E387265';
wwv_flow_api.g_varchar2_table(78) := '6D3B206D617267696E2D626F74746F6D3A20303B206D617267696E2D72696768743A20313670783B207D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F647920207B206D617267696E2D72696768743A20313670783B207D';
wwv_flow_api.g_varchar2_table(79) := '0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B206D617267696E2D72696768743A20303B206D617267696E2D6C6566743A20313670783B207D0A2E752D52544C202E666F732D416C657274';
wwv_flow_api.g_varchar2_table(80) := '2D2D70616765202E666F732D416C6572742D626F647920207B206D617267696E2D72696768743A20303B206D617267696E2D6C6566743A20313670783B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C69';
wwv_flow_api.g_varchar2_table(81) := '7374207B206D617267696E3A203470782030203020303B2070616464696E673A20303B206C6973742D7374796C653A206E6F6E653B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B20706164';
wwv_flow_api.g_varchar2_table(82) := '64696E672D6C6566743A20323070783B20706F736974696F6E3A2072656C61746976653B20666F6E742D73697A653A20313470783B206C696E652D6865696768743A20323070783B206D617267696E2D626F74746F6D3A203470783B202F2A2045787472';
wwv_flow_api.g_varchar2_table(83) := '6120536D616C6C2053637265656E73202A2F207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C64207B206D617267696E2D626F74746F6D3A20303B207D0A0A2E752D52544C';
wwv_flow_api.g_varchar2_table(84) := '202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B2070616464696E672D6C6566743A20303B2070616464696E672D72696768743A20323070783B207D0A0A2E666F732D416C6572742D2D70616765202E';
wwv_flow_api.g_varchar2_table(85) := '612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B20636F6E74656E743A2027273B20706F736974696F6E3A206162736F6C7574653B206D617267696E3A203870783B20746F703A20303B206C6566743A20303B2077696474683A2034';
wwv_flow_api.g_varchar2_table(86) := '70783B206865696768743A203470783B20626F726465722D7261646975733A20313030253B206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E35293B207D0A0A2F2A2E752D52544C202E666F732D416C6572742D2D';
wwv_flow_api.g_varchar2_table(87) := '70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B2072696768743A20303B206C6566743A206175746F3B207D2A2F0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D20';

wwv_flow_api.g_varchar2_table(88) := '2E612D427574746F6E2D2D6E6F74696669636174696F6E207B2070616464696E673A203270783B206F7061636974793A202E37353B20766572746963616C2D616C69676E3A20746F703B207D0A0A2E666F732D416C6572742D2D70616765202E68746D6C';
wwv_flow_api.g_varchar2_table(89) := '64624F7261457272207B206D617267696E2D746F703A20302E3872656D3B20646973706C61793A20626C6F636B3B20666F6E742D73697A653A20312E3172656D3B206C696E652D6865696768743A20312E3672656D3B20666F6E742D66616D696C793A20';
wwv_flow_api.g_varchar2_table(90) := '274D656E6C6F272C2027436F6E736F6C6173272C206D6F6E6F73706163652C2073657269663B2077686974652D73706163653A207072652D6C696E653B207D0A0A2F2A2041636365737369626C652048656164696E67203D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(91) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D';
wwv_flow_api.g_varchar2_table(92) := '416C6572742D7469746C65207B20626F726465723A20303B20636C69703A20726563742830203020302030293B206865696768743A203170783B206D617267696E3A202D3170783B206F766572666C6F773A2068696464656E3B2070616464696E673A20';
wwv_flow_api.g_varchar2_table(93) := '303B20706F736974696F6E3A206162736F6C7574653B2077696474683A203170783B207D0A0A2F2A2048696464656E2048656164696E6720284E6F742041636365737369626C6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(94) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D72656D6F766548656164696E67202E666F732D416C6572742D7469746C65207B2064697370';
wwv_flow_api.g_varchar2_table(95) := '6C61793A206E6F6E653B207D0A0A406D6564696120286D61782D77696474683A20343830707829207B0A092E666F732D416C6572742D2D70616765207B0A09092F2A6C6566743A20312E3672656D3B2A2F0A09096D696E2D77696474683A20303B0A0909';
wwv_flow_api.g_varchar2_table(96) := '6D61782D77696474683A206E6F6E653B0A097D0A092E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A0909666F6E742D73697A653A20313270783B0A097D0A7D0A0A406D6564696120286D61782D7769';
wwv_flow_api.g_varchar2_table(97) := '6474683A20373638707829207B0A092E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B0A0909666F6E742D73697A653A20312E3872656D3B0A097D0A7D0A0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(98) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A2F2A2049636F6E2E637373202A2F0A0A2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(99) := '74202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B20666F6E742D66616D696C793A2022617065782D352D69636F6E2D666F6E74223B20646973706C61793A20696E6C696E652D626C6F636B3B20766572746963616C2D616C69676E';
wwv_flow_api.g_varchar2_table(100) := '3A20746F703B207D0A0A2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B206C696E652D6865696768743A20313670783B20666F6E742D73697A653A20313670783B20636F6E74656E743A20225C65306132';
wwv_flow_api.g_varchar2_table(101) := '223B207D0A0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A0A2F2F';
wwv_flow_api.g_varchar2_table(102) := '23656E64726567696F6E0A0A2E666F7374722D746F702D63656E746572207B0A09746F703A20312E3672656D3B0A0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A2E666F7374722D626F74746F6D2D63656E746572207B0A09626F';
wwv_flow_api.g_varchar2_table(103) := '74746F6D3A20312E3672656D3B0A0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A2E666F7374722D746F702D7269676874207B0A09746F703A20312E3672656D3B0A0972696768743A20312E3672656D3B0A7D0A0A2E666F737472';
wwv_flow_api.g_varchar2_table(104) := '2D746F702D6C656674207B0A09746F703A20312E3672656D3B0A096C6566743A20312E3672656D3B0A7D0A0A2E666F7374722D626F74746F6D2D7269676874207B0A0972696768743A20312E3672656D3B0A09626F74746F6D3A20312E3672656D3B0A7D';
wwv_flow_api.g_varchar2_table(105) := '0A0A2E666F7374722D626F74746F6D2D6C656674207B0A09626F74746F6D3A20312E3672656D3B0A096C6566743A20312E3672656D3B0A7D0A0A2E666F7374722D636F6E7461696E6572207B0A09706F736974696F6E3A2066697865643B0A097A2D696E';
wwv_flow_api.g_varchar2_table(106) := '6465783A203939393939393B0A0A092F2F64697361626C6520706F696E746572206576656E747320666F722074686520636F6E7461696E65720A09706F696E7465722D6576656E74733A206E6F6E653B0A092F2F62757420656E61626C65207468656D20';
wwv_flow_api.g_varchar2_table(107) := '666F7220746865206368696C6472656E0A093E20646976207B0A0909706F696E7465722D6576656E74733A206175746F3B0A097D200A0A092F2A6F76657272696465732A2F0A09262E666F7374722D746F702D63656E746572203E206469762C0A09262E';
wwv_flow_api.g_varchar2_table(108) := '666F7374722D626F74746F6D2D63656E746572203E20646976207B0A09092F2A77696474683A2033303070783B2A2F0A09096D617267696E2D6C6566743A206175746F3B0A09096D617267696E2D72696768743A206175746F3B0A097D0A7D0A0A2F2F20';
wwv_flow_api.g_varchar2_table(109) := '70726F677265737320626172207374796C696E670A2E666F7374722D70726F6772657373207B0A09706F736974696F6E3A206162736F6C7574653B0A09626F74746F6D3A20303B0A096865696768743A203470783B0A096261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(110) := '6C6F723A20626C61636B3B0A096F7061636974793A20302E343B0A7D0A0A68746D6C3A6E6F74282E752D52544C29202E666F7374722D70726F67726573737B0A096C6566743A20303B0A09626F726465722D626F74746F6D2D6C6566742D726164697573';
wwv_flow_api.g_varchar2_table(111) := '3A20302E3472656D3B0A7D0A0A68746D6C2E752D52544C202E666F7374722D70726F6772657373207B0A0972696768743A20303B0A09626F726465722D626F74746F6D2D72696768742D7261646975733A20302E3472656D3B0A7D0A0A406D6564696120';
wwv_flow_api.g_varchar2_table(112) := '286D61782D77696474683A20343830707829207B0A092E666F7374722D636F6E7461696E6572207B0A09096C6566743A20312E3672656D3B0A090972696768743A20312E3672656D3B0A097D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41471950077984307)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/fostr.less'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A0A094E6F7465730A09092A206162736F6C757465206C65667420616E642072696768742076616C7565732073686F756C64206E6F7720626520706C61636573206F6E2074686520636F6E7461696E657220656C656D656E742C206E6F7420746865';
wwv_flow_api.g_varchar2_table(2) := '20696E646976696475616C206E6F74696669636174696F6E730A0A2A2F0A2F2A2A0A202A20436F6C6F72697A6564204261636B67726F756E640A202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A2020626F726465722D72616469';
wwv_flow_api.g_varchar2_table(3) := '75733A203270783B0A7D0A2E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20234646463B0A7D0A2F2A2A0A20202A204D6F6469666965723A205761726E696E670A20202A2F0A2E666F732D416C6572742D2D776172';
wwv_flow_api.g_varchar2_table(4) := '6E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20236662636634613B0A7D0A2E666F732D416C6572742D2D7761726E696E672E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C';
wwv_flow_api.g_varchar2_table(5) := '6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A2072676261283235312C203230372C2037342C20302E3135293B0A7D0A2F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A2E666F732D416C657274';
wwv_flow_api.g_varchar2_table(6) := '2D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20233342414132433B0A7D0A2E666F732D416C6572742D2D737563636573732E666F732D416C6572742D2D686F72697A6F6E74616C202E66';
wwv_flow_api.g_varchar2_table(7) := '6F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C2034342C20302E3135293B0A7D0A2F2A2A0A20202A204D6F6469666965723A20496E666F726D6174696F6E0A20202A2F0A2E66';
wwv_flow_api.g_varchar2_table(8) := '6F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20233030373664663B0A7D0A2E666F732D416C6572742D2D696E666F2E666F732D416C6572742D2D686F72697A6F6E74616C20';
wwv_flow_api.g_varchar2_table(9) := '2E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C203131382C203232332C20302E3135293B0A7D0A2F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A2E666F73';
wwv_flow_api.g_varchar2_table(10) := '2D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20236634343333363B0A7D0A2E666F732D416C6572742D2D64616E6765722E666F732D416C6572742D2D686F72697A6F6E7461';
wwv_flow_api.g_varchar2_table(11) := '6C202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A2072676261283234342C2036372C2035342C20302E3135293B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A20206261636B6772';
wwv_flow_api.g_varchar2_table(12) := '6F756E642D636F6C6F723A20236666666666663B0A2020636F6C6F723A20233236323632363B0A7D0A2F2A0A2E666F732D416C6572742D2D64616E6765727B0A094062673A206C69676874656E2840675F44616E6765722D42472C20343025293B0A0962';
wwv_flow_api.g_varchar2_table(13) := '61636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661646528636F6E7472617374284062672C2064657361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69';
wwv_flow_api.g_varchar2_table(14) := '676874656E284062672C202031303025292C2035302529292C2031303025293B0A7D0A2E666F732D416C6572742D2D696E666F207B0A094062673A206C69676874656E2840675F496E666F2D42472C20353525293B0A096261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(15) := '6C6F723A204062673B0A09636F6C6F723A206661646528636F6E7472617374284062672C2064657361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C2020';
wwv_flow_api.g_varchar2_table(16) := '31303025292C2035302529292C2031303025293B0A7D0A2A2F0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373207B0A20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C203434';
wwv_flow_api.g_varchar2_table(17) := '2C20302E39293B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A2074';
wwv_flow_api.g_varchar2_table(18) := '72616E73706172656E743B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20';
wwv_flow_api.g_varchar2_table(19) := '696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2E';
wwv_flow_api.g_varchar2_table(20) := '666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67207B0A20206261636B67726F756E642D636F6C6F723A20236662636634613B0A2020636F6C6F723A20233434333430323B0A7D0A2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(21) := '67652E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F6C6F723A20233434333430323B0A7D0A2E666F732D416C';
wwv_flow_api.g_varchar2_table(22) := '6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572';
wwv_flow_api.g_varchar2_table(23) := '742D2D7761726E696E67202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F207B0A2020';
wwv_flow_api.g_varchar2_table(24) := '6261636B67726F756E642D636F6C6F723A20233030373664663B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E207B0A2020626163';
wwv_flow_api.g_varchar2_table(25) := '6B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F';
wwv_flow_api.g_varchar2_table(26) := '6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020636F6C6F723A20234646462021696D706F';
wwv_flow_api.g_varchar2_table(27) := '7274616E743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572207B0A20206261636B67726F756E642D636F6C6F723A20236634343333363B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C65';
wwv_flow_api.g_varchar2_table(28) := '72742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D';
wwv_flow_api.g_varchar2_table(29) := '416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C65';
wwv_flow_api.g_varchar2_table(30) := '72742D2D64616E676572202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2F2A20486F72697A6F6E74616C20416C657274203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(31) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A20206D617267696E2D626F74746F';
wwv_flow_api.g_varchar2_table(32) := '6D3A20312E3672656D3B0A2020706F736974696F6E3A2072656C61746976653B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D77726170207B0A2020646973706C61793A20666C65783B0A2020666C65782D';
wwv_flow_api.g_varchar2_table(33) := '646972656374696F6E3A20726F773B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A202070616464696E673A203020313670783B0A2020666C65782D736872696E6B3A20303B0A20206469';
wwv_flow_api.g_varchar2_table(34) := '73706C61793A20666C65783B0A2020616C69676E2D6974656D733A2063656E7465723B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D636F6E74656E74207B0A202070616464696E673A20313670783B0A20';
wwv_flow_api.g_varchar2_table(35) := '20666C65783A203120303B0A2020646973706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0A20206A7573746966792D636F6E74656E743A2063656E7465723B0A7D0A2E666F732D416C6572742D2D686F7269';
wwv_flow_api.g_varchar2_table(36) := '7A6F6E74616C202E666F732D416C6572742D627574746F6E73207B0A2020666C65782D736872696E6B3A20303B0A2020746578742D616C69676E3A2072696768743B0A202077686974652D73706163653A206E6F777261703B0A202070616464696E672D';
wwv_flow_api.g_varchar2_table(37) := '72696768743A20312E3672656D3B0A2020646973706C61793A20666C65783B0A2020616C69676E2D6974656D733A2063656E7465723B0A7D0A2E752D52544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D6275';
wwv_flow_api.g_varchar2_table(38) := '74746F6E73207B0A202070616464696E672D72696768743A20303B0A202070616464696E672D6C6566743A20312E3672656D3B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D7074';
wwv_flow_api.g_varchar2_table(39) := '79207B0A2020646973706C61793A206E6F6E653B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B0A2020666F6E742D73697A653A203272656D3B0A20206C696E652D6865696768743A2032';
wwv_flow_api.g_varchar2_table(40) := '2E3472656D3B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D626F64793A656D707479207B0A2020646973706C61793A206E6F6E653B0A7D0A2E666F732D';
wwv_flow_api.g_varchar2_table(41) := '416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020666F6E742D73697A653A20333270783B0A202077696474683A20333270783B0A2020746578742D616C69676E3A2063656E7465723B0A';
wwv_flow_api.g_varchar2_table(42) := '20206865696768743A20333270783B0A20206C696E652D6865696768743A20313B0A7D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(43) := '3D3D3D3D3D3D3D3D3D3D3D3D3D20436F6D6D6F6E2050726F70657274696573203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(44) := '3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E31293B0A2020626F782D736861646F773A20302032707820347078202D';
wwv_flow_api.g_varchar2_table(45) := '327078207267626128302C20302C20302C20302E303735293B0A7D0A2E666F732D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A2020646973706C61793A206E6F';
wwv_flow_api.g_varchar2_table(46) := '6E652021696D706F7274616E743B0A7D0A2E666F732D416C6572742D2D6E6F49636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020646973706C61793A206E6F6E653B0A7D0A2E742D426F64792D616C657274207B0A20206D';
wwv_flow_api.g_varchar2_table(47) := '617267696E3A20303B0A7D0A2E742D426F64792D616C657274202E666F732D416C657274207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A2F2A2050616765204E6F74696669636174696F6E202853756363657373206F72204D6573736167';
wwv_flow_api.g_varchar2_table(48) := '6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D70616765207B0A';
wwv_flow_api.g_varchar2_table(49) := '20207472616E736974696F6E3A20302E327320656173652D6F75743B0A20206D61782D77696474683A2036343070783B0A20206D696E2D77696474683A2033323070783B0A20202F2A706F736974696F6E3A2066697865643B20746F703A20312E367265';
wwv_flow_api.g_varchar2_table(50) := '6D3B2072696768743A20312E3672656D3B2A2F0A20207A2D696E6465783A20313030303B0A2020626F726465722D77696474683A20303B0A2020626F782D736861646F773A20302030203020302E3172656D207267626128302C20302C20302C20302E31';
wwv_flow_api.g_varchar2_table(51) := '2920696E7365742C20302033707820397078202D327078207267626128302C20302C20302C20302E31293B0A20202F2A20466F72207665727920736D616C6C2073637265656E732C2066697420746865206D65737361676520746F2074686520746F7020';
wwv_flow_api.g_varchar2_table(52) := '6F66207468652073637265656E202A2F0A20202F2A2053657420426F726465722052616469757320746F2030206173206D657373616765206578697374732077697468696E20636F6E74656E74202A2F0A20202F2A2050616765204C6576656C20576172';
wwv_flow_api.g_varchar2_table(53) := '6E696E6720616E64204572726F7273203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A20202F2A2053';
wwv_flow_api.g_varchar2_table(54) := '63726F6C6C62617273202A2F0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D627574746F6E73207B0A202070616464696E672D72696768743A20303B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C65';
wwv_flow_api.g_varchar2_table(55) := '72742D69636F6E207B0A202070616464696E672D6C6566743A20312E3672656D3B0A202070616464696E672D72696768743A203870783B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E207B0A';
wwv_flow_api.g_varchar2_table(56) := '202070616464696E672D6C6566743A203870783B0A202070616464696E672D72696768743A20312E3672656D3B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020666F6E742D7369';
wwv_flow_api.g_varchar2_table(57) := '7A653A20323470783B0A202077696474683A20323470783B0A20206865696768743A20323470783B0A20206C696E652D6865696768743A20313B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B0A20207061';
wwv_flow_api.g_varchar2_table(58) := '6464696E672D626F74746F6D3A203870783B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D636F6E74656E74207B0A202070616464696E673A203870783B0A7D0A2E666F732D416C6572742D2D70616765202E742D427574';
wwv_flow_api.g_varchar2_table(59) := '746F6E2D2D636C6F7365416C657274207B0A2020706F736974696F6E3A206162736F6C7574653B0A202072696768743A202D3870783B0A2020746F703A202D3870783B0A202070616464696E673A203470783B0A20206D696E2D77696474683A20303B0A';
wwv_flow_api.g_varchar2_table(60) := '20206261636B67726F756E642D636F6C6F723A20233030302021696D706F7274616E743B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A2020626F782D736861646F773A203020302030203170782072676261283235352C20323535';
wwv_flow_api.g_varchar2_table(61) := '2C203235352C20302E3235292021696D706F7274616E743B0A2020626F726465722D7261646975733A20323470783B0A20207472616E736974696F6E3A202D7765626B69742D7472616E73666F726D20302E3132357320656173653B0A20207472616E73';
wwv_flow_api.g_varchar2_table(62) := '6974696F6E3A207472616E73666F726D20302E3132357320656173653B0A20207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173652C202D7765626B69742D7472616E73666F726D20302E3132357320656173653B0A7D0A';
wwv_flow_api.g_varchar2_table(63) := '2E752D52544C202E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B0A202072696768743A206175746F3B0A20206C6566743A202D3870783B0A7D0A2E666F732D416C6572742D2D70616765202E742D42';
wwv_flow_api.g_varchar2_table(64) := '7574746F6E2D2D636C6F7365416C6572743A686F766572207B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528312E3135293B0A20207472616E73666F726D3A207363616C6528312E3135293B0A7D0A2E666F732D416C6572742D2D';
wwv_flow_api.g_varchar2_table(65) := '70616765202E742D427574746F6E2D2D636C6F7365416C6572743A616374697665207B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528302E3835293B0A20207472616E73666F726D3A207363616C6528302E3835293B0A7D0A2F2A';
wwv_flow_api.g_varchar2_table(66) := '2E752D52544C202E666F732D416C6572742D2D70616765207B2072696768743A206175746F3B206C6566743A20312E3672656D3B207D2A2F0A2E666F732D416C6572742D2D706167652E666F732D416C657274207B0A2020626F726465722D7261646975';
wwv_flow_api.g_varchar2_table(67) := '733A20302E3472656D3B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B0A202070616464696E673A2038707820303B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D776172';
wwv_flow_api.g_varchar2_table(68) := '6E696E67202E612D4E6F74696669636174696F6E207B0A20206D617267696E2D72696768743A203870783B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469';
wwv_flow_api.g_varchar2_table(69) := '746C65207B0A2020666F6E742D73697A653A20312E3472656D3B0A20206C696E652D6865696768743A203272656D3B0A2020666F6E742D7765696768743A203730303B0A20206D617267696E3A20303B0A7D0A2E666F732D416C6572742D2D706167652E';
wwv_flow_api.g_varchar2_table(70) := '666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D6C697374207B0A20206D61782D6865696768743A2031323870783B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C69';
wwv_flow_api.g_varchar2_table(71) := '7374207B0A20206D61782D6865696768743A20393670783B0A20206F766572666C6F773A206175746F3B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C696E6B3A686F766572207B0A2020746578742D6465';
wwv_flow_api.g_varchar2_table(72) := '636F726174696F6E3A20756E6465726C696E653B0A7D0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C626172207B0A202077696474683A203870783B0A20206865696768743A203870783B0A7D0A2E666F732D416C';
wwv_flow_api.g_varchar2_table(73) := '6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D7468756D62207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3235293B0A7D0A2E666F732D416C6572742D2D70616765203A3A';
wwv_flow_api.g_varchar2_table(74) := '2D7765626B69742D7363726F6C6C6261722D747261636B207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3035293B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D746974';
wwv_flow_api.g_varchar2_table(75) := '6C65207B0A2020646973706C61793A20626C6F636B3B0A2020666F6E742D7765696768743A203730303B0A2020666F6E742D73697A653A20312E3872656D3B0A20206D617267696E2D626F74746F6D3A20303B0A20206D617267696E2D72696768743A20';
wwv_flow_api.g_varchar2_table(76) := '313670783B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B0A20206D617267696E2D72696768743A20313670783B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572';
wwv_flow_api.g_varchar2_table(77) := '742D7469746C65207B0A20206D617267696E2D72696768743A20303B0A20206D617267696E2D6C6566743A20313670783B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B0A20206D617267';
wwv_flow_api.g_varchar2_table(78) := '696E2D72696768743A20303B0A20206D617267696E2D6C6566743A20313670783B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B0A20206D617267696E3A203470782030203020303B0A202070';
wwv_flow_api.g_varchar2_table(79) := '616464696E673A20303B0A20206C6973742D7374796C653A206E6F6E653B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A202070616464696E672D6C6566743A20323070783B0A2020706F73';
wwv_flow_api.g_varchar2_table(80) := '6974696F6E3A2072656C61746976653B0A2020666F6E742D73697A653A20313470783B0A20206C696E652D6865696768743A20323070783B0A20206D617267696E2D626F74746F6D3A203470783B0A20202F2A20457874726120536D616C6C2053637265';
wwv_flow_api.g_varchar2_table(81) := '656E73202A2F0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C64207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A2E752D52544C202E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(82) := '2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A202070616464696E672D6C6566743A20303B0A202070616464696E672D72696768743A20323070783B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F7469666963';
wwv_flow_api.g_varchar2_table(83) := '6174696F6E2D6974656D3A6265666F7265207B0A2020636F6E74656E743A2027273B0A2020706F736974696F6E3A206162736F6C7574653B0A20206D617267696E3A203870783B0A2020746F703A20303B0A20206C6566743A20303B0A20207769647468';
wwv_flow_api.g_varchar2_table(84) := '3A203470783B0A20206865696768743A203470783B0A2020626F726465722D7261646975733A20313030253B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E35293B0A7D0A2F2A2E752D52544C202E666F73';
wwv_flow_api.g_varchar2_table(85) := '2D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B2072696768743A20303B206C6566743A206175746F3B207D2A2F0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F';
wwv_flow_api.g_varchar2_table(86) := '6E2D6974656D202E612D427574746F6E2D2D6E6F74696669636174696F6E207B0A202070616464696E673A203270783B0A20206F7061636974793A20302E37353B0A2020766572746963616C2D616C69676E3A20746F703B0A7D0A2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(87) := '742D2D70616765202E68746D6C64624F7261457272207B0A20206D617267696E2D746F703A20302E3872656D3B0A2020646973706C61793A20626C6F636B3B0A2020666F6E742D73697A653A20312E3172656D3B0A20206C696E652D6865696768743A20';
wwv_flow_api.g_varchar2_table(88) := '312E3672656D3B0A2020666F6E742D66616D696C793A20274D656E6C6F272C2027436F6E736F6C6173272C206D6F6E6F73706163652C2073657269663B0A202077686974652D73706163653A207072652D6C696E653B0A7D0A2F2A204163636573736962';
wwv_flow_api.g_varchar2_table(89) := '6C652048656164696E67203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(90) := '2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469746C65207B0A2020626F726465723A20303B0A2020636C69703A20726563742830203020302030293B0A20206865696768743A203170783B0A20206D617267696E3A202D';
wwv_flow_api.g_varchar2_table(91) := '3170783B0A20206F766572666C6F773A2068696464656E3B0A202070616464696E673A20303B0A2020706F736974696F6E3A206162736F6C7574653B0A202077696474683A203170783B0A7D0A2F2A2048696464656E2048656164696E6720284E6F7420';
wwv_flow_api.g_varchar2_table(92) := '41636365737369626C6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C657274';
wwv_flow_api.g_varchar2_table(93) := '2D2D72656D6F766548656164696E67202E666F732D416C6572742D7469746C65207B0A2020646973706C61793A206E6F6E653B0A7D0A406D6564696120286D61782D77696474683A20343830707829207B0A20202E666F732D416C6572742D2D70616765';
wwv_flow_api.g_varchar2_table(94) := '207B0A202020202F2A6C6566743A20312E3672656D3B2A2F0A202020206D696E2D77696474683A20303B0A202020206D61782D77696474683A206E6F6E653B0A20207D0A20202E666F732D416C6572742D2D70616765202E612D4E6F7469666963617469';
wwv_flow_api.g_varchar2_table(95) := '6F6E2D6974656D207B0A20202020666F6E742D73697A653A20313270783B0A20207D0A7D0A406D6564696120286D61782D77696474683A20373638707829207B0A20202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C657274';
wwv_flow_api.g_varchar2_table(96) := '2D7469746C65207B0A20202020666F6E742D73697A653A20312E3872656D3B0A20207D0A7D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(97) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A2F2A2049636F6E2E637373202A2F0A2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B0A2020666F6E742D66616D696C793A202261';
wwv_flow_api.g_varchar2_table(98) := '7065782D352D69636F6E2D666F6E74223B0A2020646973706C61793A20696E6C696E652D626C6F636B3B0A2020766572746963616C2D616C69676E3A20746F703B0A7D0A2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265';

wwv_flow_api.g_varchar2_table(99) := '666F7265207B0A20206C696E652D6865696768743A20313670783B0A2020666F6E742D73697A653A20313670783B0A2020636F6E74656E743A20225C65306132223B0A7D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(100) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A2E666F7374722D746F702D63656E746572207B0A2020746F703A20312E3672656D3B0A2020726967';
wwv_flow_api.g_varchar2_table(101) := '68743A20303B0A202077696474683A20313030253B0A7D0A2E666F7374722D626F74746F6D2D63656E746572207B0A2020626F74746F6D3A20312E3672656D3B0A202072696768743A20303B0A202077696474683A20313030253B0A7D0A2E666F737472';
wwv_flow_api.g_varchar2_table(102) := '2D746F702D7269676874207B0A2020746F703A20312E3672656D3B0A202072696768743A20312E3672656D3B0A7D0A2E666F7374722D746F702D6C656674207B0A2020746F703A20312E3672656D3B0A20206C6566743A20312E3672656D3B0A7D0A2E66';
wwv_flow_api.g_varchar2_table(103) := '6F7374722D626F74746F6D2D7269676874207B0A202072696768743A20312E3672656D3B0A2020626F74746F6D3A20312E3672656D3B0A7D0A2E666F7374722D626F74746F6D2D6C656674207B0A2020626F74746F6D3A20312E3672656D3B0A20206C65';
wwv_flow_api.g_varchar2_table(104) := '66743A20312E3672656D3B0A7D0A2E666F7374722D636F6E7461696E6572207B0A2020706F736974696F6E3A2066697865643B0A20207A2D696E6465783A203939393939393B0A2020706F696E7465722D6576656E74733A206E6F6E653B0A20202F2A6F';
wwv_flow_api.g_varchar2_table(105) := '76657272696465732A2F0A7D0A2E666F7374722D636F6E7461696E6572203E20646976207B0A2020706F696E7465722D6576656E74733A206175746F3B0A7D0A2E666F7374722D636F6E7461696E65722E666F7374722D746F702D63656E746572203E20';
wwv_flow_api.g_varchar2_table(106) := '6469762C0A2E666F7374722D636F6E7461696E65722E666F7374722D626F74746F6D2D63656E746572203E20646976207B0A20202F2A77696474683A2033303070783B2A2F0A20206D617267696E2D6C6566743A206175746F3B0A20206D617267696E2D';
wwv_flow_api.g_varchar2_table(107) := '72696768743A206175746F3B0A7D0A2E666F7374722D70726F6772657373207B0A2020706F736974696F6E3A206162736F6C7574653B0A2020626F74746F6D3A20303B0A20206865696768743A203470783B0A20206261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(108) := '723A20626C61636B3B0A20206F7061636974793A20302E343B0A7D0A68746D6C3A6E6F74282E752D52544C29202E666F7374722D70726F6772657373207B0A20206C6566743A20303B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975';
wwv_flow_api.g_varchar2_table(109) := '733A20302E3472656D3B0A7D0A68746D6C2E752D52544C202E666F7374722D70726F6772657373207B0A202072696768743A20303B0A2020626F726465722D626F74746F6D2D72696768742D7261646975733A20302E3472656D3B0A7D0A406D65646961';
wwv_flow_api.g_varchar2_table(110) := '20286D61782D77696474683A20343830707829207B0A20202E666F7374722D636F6E7461696E6572207B0A202020206C6566743A20312E3672656D3B0A2020202072696768743A20312E3672656D3B0A20207D0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41472892385994732)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/fostr.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E666F732D416C6572742D2D686F72697A6F6E74616C7B626F726465722D7261646975733A3270783B6261636B67726F756E642D636F6C6F723A236666663B636F6C6F723A233236323632363B6D617267696E2D626F74746F6D3A312E3672656D3B706F';
wwv_flow_api.g_varchar2_table(2) := '736974696F6E3A72656C61746976653B626F726465723A31707820736F6C6964207267626128302C302C302C2E31293B626F782D736861646F773A302032707820347078202D327078207267626128302C302C302C2E303735297D2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(3) := '742D69636F6E202E742D49636F6E7B636F6C6F723A236666667D2E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A236662636634617D2E666F732D416C6572742D2D7761726E';
wwv_flow_api.g_varchar2_table(4) := '696E672E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A72676261283235312C3230372C37342C2E3135297D2E666F732D416C6572742D2D7375636365737320';
wwv_flow_api.g_varchar2_table(5) := '2E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A233362616132637D2E666F732D416C6572742D2D737563636573732E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B6261636B';
wwv_flow_api.g_varchar2_table(6) := '67726F756E642D636F6C6F723A726762612835392C3137302C34342C2E3135297D2E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A233030373664667D2E666F732D416C6572742D2D';
wwv_flow_api.g_varchar2_table(7) := '696E666F2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7267626128302C3131382C3232332C2E3135297D2E666F732D416C6572742D2D64616E676572202E';
wwv_flow_api.g_varchar2_table(8) := '666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A236634343333367D2E666F732D416C6572742D2D64616E6765722E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B6261636B6772';
wwv_flow_api.g_varchar2_table(9) := '6F756E642D636F6C6F723A72676261283234342C36372C35342C2E3135297D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D737563636573737B6261636B67726F756E642D636F6C6F723A726762612835392C3137302C34342C2E';
wwv_flow_api.g_varchar2_table(10) := '39293B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B636F6C6F72';
wwv_flow_api.g_varchar2_table(11) := '3A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E2C2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E66';
wwv_flow_api.g_varchar2_table(12) := '6F732D416C6572742D69636F6E202E742D49636F6E2C2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E2C2E666F732D416C6572742D2D706167652E66';
wwv_flow_api.g_varchar2_table(13) := '6F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A696E68657269747D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E742D427574746F';
wwv_flow_api.g_varchar2_table(14) := '6E2D2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E677B6261636B67726F756E642D636F6C6F723A236662636634613B636F6C6F';
wwv_flow_api.g_varchar2_table(15) := '723A233434333430327D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B636F6C6F723A233434';
wwv_flow_api.g_varchar2_table(16) := '333430327D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E742D427574746F6E2D2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D70616765';
wwv_flow_api.g_varchar2_table(17) := '2E666F732D416C6572742D2D696E666F7B6261636B67726F756E642D636F6C6F723A233030373664663B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F';
wwv_flow_api.g_varchar2_table(18) := '6E7B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E742D427574746F6E2D2D636C6F7365416C6572747B636F6C';
wwv_flow_api.g_varchar2_table(19) := '6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E6765727B6261636B67726F756E642D636F6C6F723A236634343333363B636F6C6F723A236666667D2E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(20) := '2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F73';
wwv_flow_api.g_varchar2_table(21) := '2D416C6572742D2D64616E676572202E742D427574746F6E2D2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D777261707B646973';
wwv_flow_api.g_varchar2_table(22) := '706C61793A666C65783B666C65782D646972656374696F6E3A726F777D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B70616464696E673A3020313670783B666C65782D736872696E6B3A303B646973';
wwv_flow_api.g_varchar2_table(23) := '706C61793A666C65783B616C69676E2D6974656D733A63656E7465727D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D636F6E74656E747B70616464696E673A313670783B666C65783A3120303B646973706C6179';
wwv_flow_api.g_varchar2_table(24) := '3A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B6A7573746966792D636F6E74656E743A63656E7465727D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E737B666C65782D7368';
wwv_flow_api.g_varchar2_table(25) := '72696E6B3A303B746578742D616C69676E3A72696768743B77686974652D73706163653A6E6F777261703B70616464696E672D72696768743A312E3672656D3B646973706C61793A666C65783B616C69676E2D6974656D733A63656E7465727D2E752D52';
wwv_flow_api.g_varchar2_table(26) := '544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E737B70616464696E672D72696768743A303B70616464696E672D6C6566743A312E3672656D7D2E666F732D416C6572742D2D686F72697A6F6E';
wwv_flow_api.g_varchar2_table(27) := '74616C202E666F732D416C6572742D626F64793A656D7074792C2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D7074797B646973706C61793A6E6F6E657D2E666F732D416C6572742D2D68';
wwv_flow_api.g_varchar2_table(28) := '6F72697A6F6E74616C202E666F732D416C6572742D7469746C657B666F6E742D73697A653A3272656D3B6C696E652D6865696768743A322E3472656D3B6D617267696E2D626F74746F6D3A307D2E666F732D416C6572742D2D686F72697A6F6E74616C20';
wwv_flow_api.g_varchar2_table(29) := '2E666F732D416C6572742D69636F6E202E742D49636F6E7B666F6E742D73697A653A333270783B77696474683A333270783B746578742D616C69676E3A63656E7465723B6865696768743A333270783B6C696E652D6865696768743A317D2E666F732D41';
wwv_flow_api.g_varchar2_table(30) := '6C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B646973706C61793A6E6F6E6521696D706F7274616E747D2E666F732D416C6572742D2D6E6F49636F6E202E666F732D416C';
wwv_flow_api.g_varchar2_table(31) := '6572742D69636F6E202E742D49636F6E7B646973706C61793A6E6F6E657D2E742D426F64792D616C6572747B6D617267696E3A307D2E742D426F64792D616C657274202E666F732D416C6572747B6D617267696E2D626F74746F6D3A307D2E666F732D41';
wwv_flow_api.g_varchar2_table(32) := '6C6572742D2D706167657B7472616E736974696F6E3A2E327320656173652D6F75743B6D61782D77696474683A36343070783B6D696E2D77696474683A33323070783B7A2D696E6465783A313030303B626F726465722D77696474683A303B626F782D73';
wwv_flow_api.g_varchar2_table(33) := '6861646F773A3020302030202E3172656D207267626128302C302C302C2E312920696E7365742C302033707820397078202D327078207267626128302C302C302C2E31297D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D627574';
wwv_flow_api.g_varchar2_table(34) := '746F6E737B70616464696E672D72696768743A307D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E7B70616464696E672D6C6566743A312E3672656D3B70616464696E672D72696768743A3870787D2E752D52544C202E';
wwv_flow_api.g_varchar2_table(35) := '666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E7B70616464696E672D6C6566743A3870783B70616464696E672D72696768743A312E3672656D7D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D6963';
wwv_flow_api.g_varchar2_table(36) := '6F6E202E742D49636F6E7B666F6E742D73697A653A323470783B77696474683A323470783B6865696768743A323470783B6C696E652D6865696768743A317D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F64797B70616464';
wwv_flow_api.g_varchar2_table(37) := '696E672D626F74746F6D3A3870787D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D636F6E74656E747B70616464696E673A3870787D2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572';
wwv_flow_api.g_varchar2_table(38) := '747B706F736974696F6E3A6162736F6C7574653B72696768743A2D3870783B746F703A2D3870783B70616464696E673A3470783B6D696E2D77696474683A303B6261636B67726F756E642D636F6C6F723A2330303021696D706F7274616E743B636F6C6F';
wwv_flow_api.g_varchar2_table(39) := '723A2366666621696D706F7274616E743B626F782D736861646F773A3020302030203170782072676261283235352C3235352C3235352C2E32352921696D706F7274616E743B626F726465722D7261646975733A323470783B7472616E736974696F6E3A';
wwv_flow_api.g_varchar2_table(40) := '7472616E73666F726D202E3132357320656173653B7472616E736974696F6E3A7472616E73666F726D202E3132357320656173652C2D7765626B69742D7472616E73666F726D202E3132357320656173657D2E752D52544C202E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(41) := '2D70616765202E742D427574746F6E2D2D636C6F7365416C6572747B72696768743A6175746F3B6C6566743A2D3870787D2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A686F7665727B2D7765626B69';
wwv_flow_api.g_varchar2_table(42) := '742D7472616E73666F726D3A7363616C6528312E3135293B7472616E73666F726D3A7363616C6528312E3135297D2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A6163746976657B2D7765626B69742D';
wwv_flow_api.g_varchar2_table(43) := '7472616E73666F726D3A7363616C65282E3835293B7472616E73666F726D3A7363616C65282E3835297D2E666F732D416C6572742D2D706167652E666F732D416C6572747B626F726465722D7261646975733A2E3472656D7D2E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(44) := '2D70616765202E666F732D416C6572742D7469746C657B70616464696E673A38707820307D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E7B6D617267696E2D72696768';
wwv_flow_api.g_varchar2_table(45) := '743A3870787D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C657B666F6E742D73697A653A312E3472656D3B6C696E652D6865696768743A3272656D3B666F';
wwv_flow_api.g_varchar2_table(46) := '6E742D7765696768743A3730303B6D617267696E3A307D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D6C6973747B6D61782D6865696768743A31323870787D2E666F';
wwv_flow_api.g_varchar2_table(47) := '732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C6973747B6D61782D6865696768743A393670783B6F766572666C6F773A6175746F7D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C69';
wwv_flow_api.g_varchar2_table(48) := '6E6B3A686F7665727B746578742D6465636F726174696F6E3A756E6465726C696E657D2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261727B77696474683A3870783B6865696768743A3870787D2E666F732D416C';
wwv_flow_api.g_varchar2_table(49) := '6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D7468756D627B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E3235297D2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F';
wwv_flow_api.g_varchar2_table(50) := '6C6C6261722D747261636B7B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E3035297D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C657B646973706C61793A626C6F636B3B666F6E742D7765';
wwv_flow_api.g_varchar2_table(51) := '696768743A3730303B666F6E742D73697A653A312E3872656D3B6D617267696E2D626F74746F6D3A303B6D617267696E2D72696768743A313670787D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F64797B6D617267696E2D';
wwv_flow_api.g_varchar2_table(52) := '72696768743A313670787D2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F64792C2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C657B6D617267696E2D72';
wwv_flow_api.g_varchar2_table(53) := '696768743A303B6D617267696E2D6C6566743A313670787D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C6973747B6D617267696E3A347078203020303B70616464696E673A303B6C6973742D7374796C653A6E6F';
wwv_flow_api.g_varchar2_table(54) := '6E657D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D7B70616464696E672D6C6566743A323070783B706F736974696F6E3A72656C61746976653B666F6E742D73697A653A313470783B6C696E652D686569';
wwv_flow_api.g_varchar2_table(55) := '6768743A323070783B6D617267696E2D626F74746F6D3A3470787D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C647B6D617267696E2D626F74746F6D3A307D2E752D52544C202E';
wwv_flow_api.g_varchar2_table(56) := '666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D7B70616464696E672D6C6566743A303B70616464696E672D72696768743A323070787D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174';
wwv_flow_api.g_varchar2_table(57) := '696F6E2D6974656D3A6265666F72657B636F6E74656E743A27273B706F736974696F6E3A6162736F6C7574653B6D617267696E3A3870783B746F703A303B6C6566743A303B77696474683A3470783B6865696768743A3470783B626F726465722D726164';
wwv_flow_api.g_varchar2_table(58) := '6975733A313030253B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E35297D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D202E612D427574746F6E2D2D6E6F7469666963617469';
wwv_flow_api.g_varchar2_table(59) := '6F6E7B70616464696E673A3270783B6F7061636974793A2E37353B766572746963616C2D616C69676E3A746F707D2E666F732D416C6572742D2D70616765202E68746D6C64624F72614572727B6D617267696E2D746F703A2E3872656D3B646973706C61';
wwv_flow_api.g_varchar2_table(60) := '793A626C6F636B3B666F6E742D73697A653A312E3172656D3B6C696E652D6865696768743A312E3672656D3B666F6E742D66616D696C793A274D656E6C6F272C27436F6E736F6C6173272C6D6F6E6F73706163652C73657269663B77686974652D737061';
wwv_flow_api.g_varchar2_table(61) := '63653A7072652D6C696E657D2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469746C657B626F726465723A303B636C69703A726563742830203020302030293B6865696768743A3170783B6D61';
wwv_flow_api.g_varchar2_table(62) := '7267696E3A2D3170783B6F766572666C6F773A68696464656E3B70616464696E673A303B706F736974696F6E3A6162736F6C7574653B77696474683A3170787D2E666F732D416C6572742D2D72656D6F766548656164696E67202E666F732D416C657274';
wwv_flow_api.g_varchar2_table(63) := '2D7469746C657B646973706C61793A6E6F6E657D406D6564696120286D61782D77696474683A3438307078297B2E666F732D416C6572742D2D706167657B6D696E2D77696474683A303B6D61782D77696474683A6E6F6E657D2E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(64) := '2D70616765202E612D4E6F74696669636174696F6E2D6974656D7B666F6E742D73697A653A313270787D7D406D6564696120286D61782D77696474683A3736387078297B2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572';
wwv_flow_api.g_varchar2_table(65) := '742D7469746C657B666F6E742D73697A653A312E3872656D7D7D2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F72657B666F6E742D66616D696C793A22617065782D352D69636F6E2D666F6E74223B646973706C61';
wwv_flow_api.g_varchar2_table(66) := '793A696E6C696E652D626C6F636B3B766572746963616C2D616C69676E3A746F703B6C696E652D6865696768743A313670783B666F6E742D73697A653A313670783B636F6E74656E743A225C65306132227D2E666F7374722D746F702D63656E7465727B';
wwv_flow_api.g_varchar2_table(67) := '746F703A312E3672656D3B72696768743A303B77696474683A313030257D2E666F7374722D626F74746F6D2D63656E7465727B626F74746F6D3A312E3672656D3B72696768743A303B77696474683A313030257D2E666F7374722D746F702D7269676874';
wwv_flow_api.g_varchar2_table(68) := '7B746F703A312E3672656D3B72696768743A312E3672656D7D2E666F7374722D746F702D6C6566747B746F703A312E3672656D3B6C6566743A312E3672656D7D2E666F7374722D626F74746F6D2D72696768747B72696768743A312E3672656D3B626F74';
wwv_flow_api.g_varchar2_table(69) := '746F6D3A312E3672656D7D2E666F7374722D626F74746F6D2D6C6566747B626F74746F6D3A312E3672656D3B6C6566743A312E3672656D7D2E666F7374722D636F6E7461696E65727B706F736974696F6E3A66697865643B7A2D696E6465783A39393939';
wwv_flow_api.g_varchar2_table(70) := '39393B706F696E7465722D6576656E74733A6E6F6E657D2E666F7374722D636F6E7461696E65723E6469767B706F696E7465722D6576656E74733A6175746F7D2E666F7374722D636F6E7461696E65722E666F7374722D626F74746F6D2D63656E746572';
wwv_flow_api.g_varchar2_table(71) := '3E6469762C2E666F7374722D636F6E7461696E65722E666F7374722D746F702D63656E7465723E6469767B6D617267696E2D6C6566743A6175746F3B6D617267696E2D72696768743A6175746F7D2E666F7374722D70726F67726573737B706F73697469';
wwv_flow_api.g_varchar2_table(72) := '6F6E3A6162736F6C7574653B626F74746F6D3A303B6865696768743A3470783B6261636B67726F756E642D636F6C6F723A233030303B6F7061636974793A2E347D68746D6C3A6E6F74282E752D52544C29202E666F7374722D70726F67726573737B6C65';
wwv_flow_api.g_varchar2_table(73) := '66743A303B626F726465722D626F74746F6D2D6C6566742D7261646975733A2E3472656D7D68746D6C2E752D52544C202E666F7374722D70726F67726573737B72696768743A303B626F726465722D626F74746F6D2D72696768742D7261646975733A2E';
wwv_flow_api.g_varchar2_table(74) := '3472656D7D406D6564696120286D61782D77696474683A3438307078297B2E666F7374722D636F6E7461696E65727B6C6566743A312E3672656D3B72696768743A312E3672656D7D7D0A2F2A2320736F757263654D617070696E6755524C3D666F737472';
wwv_flow_api.g_varchar2_table(75) := '2E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41473243038994734)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/fostr.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22666F7374722E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414153412C73422C434143452C69422C43413043412C71422C434143412C612C43417745412C6F42';
wwv_flow_api.g_varchar2_table(2) := '2C434143412C69422C43416D44412C2B422C434143412C30432C4341744B462C75422C434143452C552C43414B462C32432C434143452C612C434145462C79442C434143452C71432C43414B462C32432C434143452C612C434145462C79442C43414345';
wwv_flow_api.g_varchar2_table(3) := '2C6F432C43414B462C77432C434143452C612C434145462C73442C434143452C6F432C43414B462C30432C434143452C612C434145462C77442C434143452C6F432C43416B42462C6D432C434143452C6D432C434143412C552C434145462C6D442C4341';
wwv_flow_api.g_varchar2_table(4) := '43452C34422C434143412C552C43413443462C30442C434164412C77442C43413542412C32442C434163412C32442C434162452C612C434145462C79442C434143452C6F422C434145462C6D432C434143452C77422C434143412C612C434145462C6D44';
wwv_flow_api.g_varchar2_table(5) := '2C434143452C34422C434143412C612C43414B462C79442C434143452C6F422C434145462C67432C434143452C77422C434143412C552C434145462C67442C434143452C34422C434143412C552C43414B462C73442C434143452C6F422C434145462C6B';
wwv_flow_api.g_varchar2_table(6) := '432C434143452C77422C434143412C552C434145462C6B442C434143452C34422C434143412C552C43414B462C77442C434143452C6F422C43414F462C73432C434143452C592C434143412C6B422C434145462C73432C434143452C632C434143412C61';
wwv_flow_api.g_varchar2_table(7) := '2C434143412C592C434143412C6B422C434145462C79432C434143452C592C434143412C512C434143412C592C434143412C71422C434143412C73422C434145462C79432C434143452C612C434143412C67422C434143412C6B422C434143412C6F422C';
wwv_flow_api.g_varchar2_table(8) := '434143412C592C434143412C6B422C434145462C67442C434143452C652C434143412C6D422C434155462C34432C434152412C2B432C434143452C592C434145462C75432C434143452C632C434143412C6B422C434143412C652C43414B462C38432C43';
wwv_flow_api.g_varchar2_table(9) := '4143452C632C434143412C552C434143412C69422C434143412C572C434143412C612C43414F462C77442C434143452C73422C434145462C30432C434143452C592C434145462C612C434143452C512C434145462C77422C434143452C652C434147462C';
wwv_flow_api.g_varchar2_table(10) := '67422C434143452C75422C434143412C652C434143412C652C434145412C592C434143412C632C434143412C79452C43414D462C6D432C434143452C652C434145462C67432C434143452C6D422C434143412C69422C434145462C75432C434143452C67';
wwv_flow_api.g_varchar2_table(11) := '422C434143412C6F422C434145462C77432C434143452C632C434143412C552C434143412C572C434143412C612C434145462C67432C434143452C6B422C434145462C6D432C434143452C572C434145462C73432C434143452C69422C434143412C552C';
wwv_flow_api.g_varchar2_table(12) := '434143412C512C434143412C572C434143412C572C434143412C2B422C434143412C6F422C434143412C6F442C434143412C6B422C434145412C2B422C434143412C34442C434145462C36432C434143452C552C434143412C532C434145462C34432C43';
wwv_flow_api.g_varchar2_table(13) := '4143452C36422C434143412C71422C434145462C36432C434143452C34422C434143412C6F422C434147462C30422C434143452C6D422C434145462C69432C434143452C612C434145462C6D442C434143452C67422C434145462C79442C434143452C67';
wwv_flow_api.g_varchar2_table(14) := '422C434143412C67422C434143412C652C434143412C512C434145462C77442C434143452C67422C434145462C71432C434143452C652C434143412C612C434145462C32432C434143452C79422C434145462C6F432C434143452C532C434143412C552C';
wwv_flow_api.g_varchar2_table(15) := '434145462C30432C434143452C67432C434145462C30432C434143452C67432C434145462C69432C434143452C612C434143412C652C434143412C67422C434143412C652C434143412C69422C434145462C67432C434143452C69422C43414D462C7543';
wwv_flow_api.g_varchar2_table(16) := '2C43414A412C77432C434143452C632C434143412C67422C43414D462C71432C434143452C632C434143412C532C434143412C652C434145462C71432C434143452C69422C434143412C69422C434143412C632C434143412C67422C434143412C69422C';
wwv_flow_api.g_varchar2_table(17) := '434147462C67442C434143452C652C434145462C34432C434143452C632C434143412C6B422C434145462C34432C434143452C552C434143412C69422C434143412C552C434143412C4B2C434143412C4D2C434143412C532C434143412C552C43414341';
wwv_flow_api.g_varchar2_table(18) := '2C6B422C434143412C2B422C434147462C36442C434143452C572C434143412C572C434143412C6B422C434145462C38422C434143452C67422C434143412C612C434143412C67422C434143412C6B422C434143412C38432C434143412C6F422C434147';
wwv_flow_api.g_varchar2_table(19) := '462C38432C434143452C512C434143412C6B422C434143412C552C434143412C572C434143412C652C434143412C532C434143412C69422C434143412C532C434147462C30432C434143452C592C434145462C79424143452C67422C434145452C572C43';
wwv_flow_api.g_varchar2_table(20) := '4143412C632C434145462C71432C434143452C674241474A2C412C79424143452C75432C434143452C6B42414B4A2C6F432C434143452C38422C434143412C6F422C434143412C6B422C434147412C67422C434143412C632C434143412C652C43414746';
wwv_flow_api.g_varchar2_table(21) := '2C69422C434143452C552C434143412C4F2C434143412C552C434145462C6F422C434143452C612C434143412C4F2C434143412C552C434145462C67422C434143452C552C434143412C592C434145462C652C434143452C552C434143412C572C434145';
wwv_flow_api.g_varchar2_table(22) := '462C6D422C434143452C592C434143412C612C434145462C6B422C434143452C612C434143412C572C434145462C67422C434143452C632C434143412C632C434143412C6D422C434147462C6F422C434143452C6D422C434147462C77432C434144412C';
wwv_flow_api.g_varchar2_table(23) := '71432C434147452C67422C434143412C69422C434145462C652C434143452C69422C434143412C512C434143412C552C434143412C71422C434143412C552C434145462C534141532C75422C434143502C4D2C434143412C2B422C434145462C30422C43';
wwv_flow_api.g_varchar2_table(24) := '4143452C4F2C434143412C67432C434145462C79424143452C67422C434143452C572C434143412C63222C2266696C65223A22666F7374722E637373222C22736F7572636573436F6E74656E74223A5B222F2A5C6E5C6E5C744E6F7465735C6E5C745C74';
wwv_flow_api.g_varchar2_table(25) := '2A206162736F6C757465206C65667420616E642072696768742076616C7565732073686F756C64206E6F7720626520706C61636573206F6E2074686520636F6E7461696E657220656C656D656E742C206E6F742074686520696E646976696475616C206E';
wwv_flow_api.g_varchar2_table(26) := '6F74696669636174696F6E735C6E5C6E2A2F5C6E2F2A2A5C6E202A20436F6C6F72697A6564204261636B67726F756E645C6E202A2F5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C207B5C6E2020626F726465722D7261646975733A203270';
wwv_flow_api.g_varchar2_table(27) := '783B5C6E7D5C6E2E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2F2A2A5C6E20202A204D6F6469666965723A205761726E696E675C6E20202A2F5C6E2E666F732D416C6572742D2D77';
wwv_flow_api.g_varchar2_table(28) := '61726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20236662636634613B5C6E7D5C6E2E666F732D416C6572742D2D7761726E696E672E666F732D416C6572742D2D686F72697A6F6E74616C202E66';
wwv_flow_api.g_varchar2_table(29) := '6F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A2072676261283235312C203230372C2037342C20302E3135293B5C6E7D5C6E2F2A2A5C6E20202A204D6F6469666965723A20537563636573735C6E20202A2F5C';
wwv_flow_api.g_varchar2_table(30) := '6E2E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20233342414132433B5C6E7D5C6E2E666F732D416C6572742D2D737563636573732E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(31) := '2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C2034342C20302E3135293B5C6E7D5C6E2F2A2A5C6E20202A204D6F6469666965723A2049';
wwv_flow_api.g_varchar2_table(32) := '6E666F726D6174696F6E5C6E20202A2F5C6E2E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20233030373664663B5C6E7D5C6E2E666F732D416C6572742D2D696E666F';
wwv_flow_api.g_varchar2_table(33) := '2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C203131382C203232332C20302E3135293B5C6E7D5C6E2F2A2A5C6E20202A20';
wwv_flow_api.g_varchar2_table(34) := '4D6F6469666965723A20537563636573735C6E20202A2F5C6E2E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20236634343333363B5C6E7D5C6E2E666F732D416C';
wwv_flow_api.g_varchar2_table(35) := '6572742D2D64616E6765722E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A2072676261283234342C2036372C2035342C20302E3135293B5C6E7D';

wwv_flow_api.g_varchar2_table(36) := '5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C207B5C6E20206261636B67726F756E642D636F6C6F723A20236666666666663B5C6E2020636F6C6F723A20233236323632363B5C6E7D5C6E2F2A5C6E2E666F732D416C6572742D2D64616E67';
wwv_flow_api.g_varchar2_table(37) := '65727B5C6E5C744062673A206C69676874656E2840675F44616E6765722D42472C20343025293B5C6E5C746261636B67726F756E642D636F6C6F723A204062673B5C6E5C74636F6C6F723A206661646528636F6E7472617374284062672C206465736174';
wwv_flow_api.g_varchar2_table(38) := '7572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B5C6E7D5C6E2E666F732D416C6572742D2D696E666F20';
wwv_flow_api.g_varchar2_table(39) := '7B5C6E5C744062673A206C69676874656E2840675F496E666F2D42472C20353525293B5C6E5C746261636B67726F756E642D636F6C6F723A204062673B5C6E5C74636F6C6F723A206661646528636F6E7472617374284062672C20646573617475726174';
wwv_flow_api.g_varchar2_table(40) := '65286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B5C6E7D5C6E2A2F5C6E2E666F732D416C6572742D2D706167652E';
wwv_flow_api.g_varchar2_table(41) := '666F732D416C6572742D2D73756363657373207B5C6E20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C2034342C20302E39293B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(42) := '67652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D41';
wwv_flow_api.g_varchar2_table(43) := '6C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D';
wwv_flow_api.g_varchar2_table(44) := '416C6572742D2D73756363657373202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761';
wwv_flow_api.g_varchar2_table(45) := '726E696E67207B5C6E20206261636B67726F756E642D636F6C6F723A20236662636634613B5C6E2020636F6C6F723A20233434333430323B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F';
wwv_flow_api.g_varchar2_table(46) := '732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20233434333430323B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D';
wwv_flow_api.g_varchar2_table(47) := '7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E742D42757474';
wwv_flow_api.g_varchar2_table(48) := '6F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F207B5C6E20206261636B67726F756E642D636F6C';
wwv_flow_api.g_varchar2_table(49) := '6F723A20233030373664663B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(50) := '6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020';
wwv_flow_api.g_varchar2_table(51) := '636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F727461';
wwv_flow_api.g_varchar2_table(52) := '6E743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572207B5C6E20206261636B67726F756E642D636F6C6F723A20236634343333363B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D';
wwv_flow_api.g_varchar2_table(53) := '416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20234646463B5C6E7D';
wwv_flow_api.g_varchar2_table(54) := '5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(55) := '67652E666F732D416C6572742D2D64616E676572202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E7D5C6E2F2A20486F72697A6F6E74616C20416C657274203D3D3D3D';
wwv_flow_api.g_varchar2_table(56) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C207B5C';
wwv_flow_api.g_varchar2_table(57) := '6E20206D617267696E2D626F74746F6D3A20312E3672656D3B5C6E2020706F736974696F6E3A2072656C61746976653B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D77726170207B5C6E2020646973';
wwv_flow_api.g_varchar2_table(58) := '706C61793A20666C65783B5C6E2020666C65782D646972656374696F6E3A20726F773B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E202070616464696E673A203020313670783B';
wwv_flow_api.g_varchar2_table(59) := '5C6E2020666C65782D736872696E6B3A20303B5C6E2020646973706C61793A20666C65783B5C6E2020616C69676E2D6974656D733A2063656E7465723B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(60) := '636F6E74656E74207B5C6E202070616464696E673A20313670783B5C6E2020666C65783A203120303B5C6E2020646973706C61793A20666C65783B5C6E2020666C65782D646972656374696F6E3A20636F6C756D6E3B5C6E20206A7573746966792D636F';
wwv_flow_api.g_varchar2_table(61) := '6E74656E743A2063656E7465723B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B5C6E2020666C65782D736872696E6B3A20303B5C6E2020746578742D616C69676E3A20726967';
wwv_flow_api.g_varchar2_table(62) := '68743B5C6E202077686974652D73706163653A206E6F777261703B5C6E202070616464696E672D72696768743A20312E3672656D3B5C6E2020646973706C61793A20666C65783B5C6E2020616C69676E2D6974656D733A2063656E7465723B5C6E7D5C6E';
wwv_flow_api.g_varchar2_table(63) := '2E752D52544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B5C6E202070616464696E672D72696768743A20303B5C6E202070616464696E672D6C6566743A20312E3672656D3B5C6E7D5C';
wwv_flow_api.g_varchar2_table(64) := '6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D707479207B5C6E2020646973706C61793A206E6F6E653B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F73';
wwv_flow_api.g_varchar2_table(65) := '2D416C6572742D7469746C65207B5C6E2020666F6E742D73697A653A203272656D3B5C6E20206C696E652D6865696768743A20322E3472656D3B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E7D5C6E2E666F732D416C6572742D2D686F7269';
wwv_flow_api.g_varchar2_table(66) := '7A6F6E74616C202E666F732D416C6572742D626F64793A656D707479207B5C6E2020646973706C61793A206E6F6E653B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E202E742D49636F6E20';
wwv_flow_api.g_varchar2_table(67) := '7B5C6E2020666F6E742D73697A653A20333270783B5C6E202077696474683A20333270783B5C6E2020746578742D616C69676E3A2063656E7465723B5C6E20206865696768743A20333270783B5C6E20206C696E652D6865696768743A20313B5C6E7D5C';
wwv_flow_api.g_varchar2_table(68) := '6E2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20436F6D6D6F6E2050726F70657274696573203D3D3D';
wwv_flow_api.g_varchar2_table(69) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C207B';
wwv_flow_api.g_varchar2_table(70) := '5C6E2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E31293B5C6E2020626F782D736861646F773A20302032707820347078202D327078207267626128302C20302C20302C20302E303735293B5C6E7D5C6E2E66';
wwv_flow_api.g_varchar2_table(71) := '6F732D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E2020646973706C61793A206E6F6E652021696D706F7274616E743B5C6E7D5C6E2E666F732D416C657274';
wwv_flow_api.g_varchar2_table(72) := '2D2D6E6F49636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020646973706C61793A206E6F6E653B5C6E7D5C6E2E742D426F64792D616C657274207B5C6E20206D617267696E3A20303B5C6E7D5C6E2E742D426F64792D61';
wwv_flow_api.g_varchar2_table(73) := '6C657274202E666F732D416C657274207B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E7D5C6E2F2A2050616765204E6F74696669636174696F6E202853756363657373206F72204D65737361676529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(74) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D70616765207B5C6E20207472616E736974696F6E3A20302E';
wwv_flow_api.g_varchar2_table(75) := '327320656173652D6F75743B5C6E20206D61782D77696474683A2036343070783B5C6E20206D696E2D77696474683A2033323070783B5C6E20202F2A706F736974696F6E3A2066697865643B20746F703A20312E3672656D3B2072696768743A20312E36';
wwv_flow_api.g_varchar2_table(76) := '72656D3B2A2F5C6E20207A2D696E6465783A20313030303B5C6E2020626F726465722D77696474683A20303B5C6E2020626F782D736861646F773A20302030203020302E3172656D207267626128302C20302C20302C20302E312920696E7365742C2030';
wwv_flow_api.g_varchar2_table(77) := '2033707820397078202D327078207267626128302C20302C20302C20302E31293B5C6E20202F2A20466F72207665727920736D616C6C2073637265656E732C2066697420746865206D65737361676520746F2074686520746F70206F6620746865207363';
wwv_flow_api.g_varchar2_table(78) := '7265656E202A2F5C6E20202F2A2053657420426F726465722052616469757320746F2030206173206D657373616765206578697374732077697468696E20636F6E74656E74202A2F5C6E20202F2A2050616765204C6576656C205761726E696E6720616E';
wwv_flow_api.g_varchar2_table(79) := '64204572726F7273203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E20202F2A205363726F6C6C62';
wwv_flow_api.g_varchar2_table(80) := '617273202A2F5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D627574746F6E73207B5C6E202070616464696E672D72696768743A20303B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572';
wwv_flow_api.g_varchar2_table(81) := '742D69636F6E207B5C6E202070616464696E672D6C6566743A20312E3672656D3B5C6E202070616464696E672D72696768743A203870783B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E';
wwv_flow_api.g_varchar2_table(82) := '207B5C6E202070616464696E672D6C6566743A203870783B5C6E202070616464696E672D72696768743A20312E3672656D3B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E20';
wwv_flow_api.g_varchar2_table(83) := '20666F6E742D73697A653A20323470783B5C6E202077696474683A20323470783B5C6E20206865696768743A20323470783B5C6E20206C696E652D6865696768743A20313B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572';
wwv_flow_api.g_varchar2_table(84) := '742D626F6479207B5C6E202070616464696E672D626F74746F6D3A203870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D636F6E74656E74207B5C6E202070616464696E673A203870783B5C6E7D5C6E2E666F73';
wwv_flow_api.g_varchar2_table(85) := '2D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E202072696768743A202D3870783B5C6E2020746F703A202D3870783B5C6E202070616464696E67';
wwv_flow_api.g_varchar2_table(86) := '3A203470783B5C6E20206D696E2D77696474683A20303B5C6E20206261636B67726F756E642D636F6C6F723A20233030302021696D706F7274616E743B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E2020626F782D73686164';
wwv_flow_api.g_varchar2_table(87) := '6F773A203020302030203170782072676261283235352C203235352C203235352C20302E3235292021696D706F7274616E743B5C6E2020626F726465722D7261646975733A20323470783B5C6E20207472616E736974696F6E3A202D7765626B69742D74';
wwv_flow_api.g_varchar2_table(88) := '72616E73666F726D20302E3132357320656173653B5C6E20207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173653B5C6E20207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173652C202D77';
wwv_flow_api.g_varchar2_table(89) := '65626B69742D7472616E73666F726D20302E3132357320656173653B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E202072696768743A206175746F3B5C6E2020';
wwv_flow_api.g_varchar2_table(90) := '6C6566743A202D3870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A686F766572207B5C6E20202D7765626B69742D7472616E73666F726D3A207363616C6528312E3135293B5C6E20';
wwv_flow_api.g_varchar2_table(91) := '207472616E73666F726D3A207363616C6528312E3135293B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A616374697665207B5C6E20202D7765626B69742D7472616E73666F726D3A2073';
wwv_flow_api.g_varchar2_table(92) := '63616C6528302E3835293B5C6E20207472616E73666F726D3A207363616C6528302E3835293B5C6E7D5C6E2F2A2E752D52544C202E666F732D416C6572742D2D70616765207B2072696768743A206175746F3B206C6566743A20312E3672656D3B207D2A';
wwv_flow_api.g_varchar2_table(93) := '2F5C6E2E666F732D416C6572742D2D706167652E666F732D416C657274207B5C6E2020626F726465722D7261646975733A20302E3472656D3B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B5C6E20';
wwv_flow_api.g_varchar2_table(94) := '2070616464696E673A2038707820303B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E207B5C6E20206D617267696E2D72696768743A203870783B5C6E7D5C';
wwv_flow_api.g_varchar2_table(95) := '6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C65207B5C6E2020666F6E742D73697A653A20312E3472656D3B5C6E20206C696E652D6865696768743A2032';
wwv_flow_api.g_varchar2_table(96) := '72656D3B5C6E2020666F6E742D7765696768743A203730303B5C6E20206D617267696E3A20303B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D6C697374';
wwv_flow_api.g_varchar2_table(97) := '207B5C6E20206D61782D6865696768743A2031323870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B5C6E20206D61782D6865696768743A20393670783B5C6E20206F766572666C6F';
wwv_flow_api.g_varchar2_table(98) := '773A206175746F3B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C696E6B3A686F766572207B5C6E2020746578742D6465636F726174696F6E3A20756E6465726C696E653B5C6E7D5C6E2E666F732D41';
wwv_flow_api.g_varchar2_table(99) := '6C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C626172207B5C6E202077696474683A203870783B5C6E20206865696768743A203870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C';
wwv_flow_api.g_varchar2_table(100) := '6C6261722D7468756D62207B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3235293B5C6E7D5C6E2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D74726163';
wwv_flow_api.g_varchar2_table(101) := '6B207B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3035293B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B5C6E2020646973706C61793A20626C';
wwv_flow_api.g_varchar2_table(102) := '6F636B3B5C6E2020666F6E742D7765696768743A203730303B5C6E2020666F6E742D73697A653A20312E3872656D3B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E20206D617267696E2D72696768743A20313670783B5C6E7D5C6E2E666F73';
wwv_flow_api.g_varchar2_table(103) := '2D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B5C6E20206D617267696E2D72696768743A20313670783B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B';
wwv_flow_api.g_varchar2_table(104) := '5C6E20206D617267696E2D72696768743A20303B5C6E20206D617267696E2D6C6566743A20313670783B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B5C6E20206D617267696E2D72';
wwv_flow_api.g_varchar2_table(105) := '696768743A20303B5C6E20206D617267696E2D6C6566743A20313670783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B5C6E20206D617267696E3A203470782030203020303B5C6E2020';
wwv_flow_api.g_varchar2_table(106) := '70616464696E673A20303B5C6E20206C6973742D7374796C653A206E6F6E653B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B5C6E202070616464696E672D6C6566743A20323070783B5C';
wwv_flow_api.g_varchar2_table(107) := '6E2020706F736974696F6E3A2072656C61746976653B5C6E2020666F6E742D73697A653A20313470783B5C6E20206C696E652D6865696768743A20323070783B5C6E20206D617267696E2D626F74746F6D3A203470783B5C6E20202F2A20457874726120';
wwv_flow_api.g_varchar2_table(108) := '536D616C6C2053637265656E73202A2F5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C64207B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E7D5C6E2E752D';
wwv_flow_api.g_varchar2_table(109) := '52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B5C6E202070616464696E672D6C6566743A20303B5C6E202070616464696E672D72696768743A20323070783B5C6E7D5C6E2E666F732D416C65';
wwv_flow_api.g_varchar2_table(110) := '72742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B5C6E2020636F6E74656E743A2027273B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E20206D617267696E3A203870783B5C6E2020746F70';
wwv_flow_api.g_varchar2_table(111) := '3A20303B5C6E20206C6566743A20303B5C6E202077696474683A203470783B5C6E20206865696768743A203470783B5C6E2020626F726465722D7261646975733A20313030253B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C';
wwv_flow_api.g_varchar2_table(112) := '20302C20302C20302E35293B5C6E7D5C6E2F2A2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B2072696768743A20303B206C6566743A206175746F3B207D2A2F5C6E';
wwv_flow_api.g_varchar2_table(113) := '2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D202E612D427574746F6E2D2D6E6F74696669636174696F6E207B5C6E202070616464696E673A203270783B5C6E20206F7061636974793A20302E37353B5C6E';
wwv_flow_api.g_varchar2_table(114) := '2020766572746963616C2D616C69676E3A20746F703B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E68746D6C64624F7261457272207B5C6E20206D617267696E2D746F703A20302E3872656D3B5C6E2020646973706C61793A20626C6F636B';
wwv_flow_api.g_varchar2_table(115) := '3B5C6E2020666F6E742D73697A653A20312E3172656D3B5C6E20206C696E652D6865696768743A20312E3672656D3B5C6E2020666F6E742D66616D696C793A20274D656E6C6F272C2027436F6E736F6C6173272C206D6F6E6F73706163652C2073657269';
wwv_flow_api.g_varchar2_table(116) := '663B5C6E202077686974652D73706163653A207072652D6C696E653B5C6E7D5C6E2F2A2041636365737369626C652048656164696E67203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(117) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469746C65207B5C6E2020626F726465723A20303B5C6E2020';
wwv_flow_api.g_varchar2_table(118) := '636C69703A20726563742830203020302030293B5C6E20206865696768743A203170783B5C6E20206D617267696E3A202D3170783B5C6E20206F766572666C6F773A2068696464656E3B5C6E202070616464696E673A20303B5C6E2020706F736974696F';
wwv_flow_api.g_varchar2_table(119) := '6E3A206162736F6C7574653B5C6E202077696474683A203170783B5C6E7D5C6E2F2A2048696464656E2048656164696E6720284E6F742041636365737369626C6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(120) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D72656D6F766548656164696E67202E666F732D416C6572742D7469746C65207B5C6E2020646973706C61';
wwv_flow_api.g_varchar2_table(121) := '793A206E6F6E653B5C6E7D5C6E406D6564696120286D61782D77696474683A20343830707829207B5C6E20202E666F732D416C6572742D2D70616765207B5C6E202020202F2A6C6566743A20312E3672656D3B2A2F5C6E202020206D696E2D7769647468';
wwv_flow_api.g_varchar2_table(122) := '3A20303B5C6E202020206D61782D77696474683A206E6F6E653B5C6E20207D5C6E20202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B5C6E20202020666F6E742D73697A653A20313270783B5C6E2020';
wwv_flow_api.g_varchar2_table(123) := '7D5C6E7D5C6E406D6564696120286D61782D77696474683A20373638707829207B5C6E20202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B5C6E20202020666F6E742D73697A653A20312E387265';
wwv_flow_api.g_varchar2_table(124) := '6D3B5C6E20207D5C6E7D5C6E2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D20';
wwv_flow_api.g_varchar2_table(125) := '2A2F5C6E2F2A2049636F6E2E637373202A2F5C6E2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B5C6E2020666F6E742D66616D696C793A205C22617065782D352D69636F6E2D666F6E745C223B5C6E2020';
wwv_flow_api.g_varchar2_table(126) := '646973706C61793A20696E6C696E652D626C6F636B3B5C6E2020766572746963616C2D616C69676E3A20746F703B5C6E7D5C6E2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B5C6E20206C696E652D6865';
wwv_flow_api.g_varchar2_table(127) := '696768743A20313670783B5C6E2020666F6E742D73697A653A20313670783B5C6E2020636F6E74656E743A205C225C5C653061325C223B5C6E7D5C6E2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(128) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F5C6E2E666F7374722D746F702D63656E746572207B5C6E2020746F703A20312E3672656D3B5C6E202072696768743A20303B';
wwv_flow_api.g_varchar2_table(129) := '5C6E202077696474683A20313030253B5C6E7D5C6E2E666F7374722D626F74746F6D2D63656E746572207B5C6E2020626F74746F6D3A20312E3672656D3B5C6E202072696768743A20303B5C6E202077696474683A20313030253B5C6E7D5C6E2E666F73';
wwv_flow_api.g_varchar2_table(130) := '74722D746F702D7269676874207B5C6E2020746F703A20312E3672656D3B5C6E202072696768743A20312E3672656D3B5C6E7D5C6E2E666F7374722D746F702D6C656674207B5C6E2020746F703A20312E3672656D3B5C6E20206C6566743A20312E3672';
wwv_flow_api.g_varchar2_table(131) := '656D3B5C6E7D5C6E2E666F7374722D626F74746F6D2D7269676874207B5C6E202072696768743A20312E3672656D3B5C6E2020626F74746F6D3A20312E3672656D3B5C6E7D5C6E2E666F7374722D626F74746F6D2D6C656674207B5C6E2020626F74746F';
wwv_flow_api.g_varchar2_table(132) := '6D3A20312E3672656D3B5C6E20206C6566743A20312E3672656D3B5C6E7D5C6E2E666F7374722D636F6E7461696E6572207B5C6E2020706F736974696F6E3A2066697865643B5C6E20207A2D696E6465783A203939393939393B5C6E2020706F696E7465';
wwv_flow_api.g_varchar2_table(133) := '722D6576656E74733A206E6F6E653B5C6E20202F2A6F76657272696465732A2F5C6E7D5C6E2E666F7374722D636F6E7461696E6572203E20646976207B5C6E2020706F696E7465722D6576656E74733A206175746F3B5C6E7D5C6E2E666F7374722D636F';
wwv_flow_api.g_varchar2_table(134) := '6E7461696E65722E666F7374722D746F702D63656E746572203E206469762C5C6E2E666F7374722D636F6E7461696E65722E666F7374722D626F74746F6D2D63656E746572203E20646976207B5C6E20202F2A77696474683A2033303070783B2A2F5C6E';
wwv_flow_api.g_varchar2_table(135) := '20206D617267696E2D6C6566743A206175746F3B5C6E20206D617267696E2D72696768743A206175746F3B5C6E7D5C6E2E666F7374722D70726F6772657373207B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E2020626F74746F6D3A20';
wwv_flow_api.g_varchar2_table(136) := '303B5C6E20206865696768743A203470783B5C6E20206261636B67726F756E642D636F6C6F723A20626C61636B3B5C6E20206F7061636974793A20302E343B5C6E7D5C6E68746D6C3A6E6F74282E752D52544C29202E666F7374722D70726F6772657373';
wwv_flow_api.g_varchar2_table(137) := '207B5C6E20206C6566743A20303B5C6E2020626F726465722D626F74746F6D2D6C6566742D7261646975733A20302E3472656D3B5C6E7D5C6E68746D6C2E752D52544C202E666F7374722D70726F6772657373207B5C6E202072696768743A20303B5C6E';
wwv_flow_api.g_varchar2_table(138) := '2020626F726465722D626F74746F6D2D72696768742D7261646975733A20302E3472656D3B5C6E7D5C6E406D6564696120286D61782D77696474683A20343830707829207B5C6E20202E666F7374722D636F6E7461696E6572207B5C6E202020206C6566';
wwv_flow_api.g_varchar2_table(139) := '743A20312E3672656D3B5C6E2020202072696768743A20312E3672656D3B5C6E20207D5C6E7D5C6E225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(41473691628994736)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/fostr.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A205468656D65726F6C6C65722047726F7570202A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A0A7B0A20202020227472616E736C617465223A20747275652C0A';
wwv_flow_api.g_varchar2_table(2) := '202020202267726F757073223A5B0A20202020202020207B0A202020202020202020202020226E616D65223A2022464F53202D204E6F74696669636174696F6E73222C0A20202020202020202020202022636F6D6D6F6E223A2066616C73652C0A202020';
wwv_flow_api.g_varchar2_table(3) := '2020202020202020202273657175656E6365223A203230303530300A20202020202020207D0A202020205D0A7D0A2A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A205661726961626C6573202A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A0A';
wwv_flow_api.g_varchar2_table(4) := '7B0A2020227661722220202020203A202240666F732D6E6F7469662D7469746C652D666F6E742D73697A65222C0A2020226E616D6522202020203A20225469746C6520466F6E742053697A65222C0A2020227479706522202020203A20226E756D626572';
wwv_flow_api.g_varchar2_table(5) := '222C0A202022756E697473222020203A202272656D222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A20312C0A20202020226D617822202020202020203A20332C0A2020202022696E6372656D656E7422203A20';
wwv_flow_api.g_varchar2_table(6) := '302E310A20207D2C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F7469662D7469746C652D666F6E742D73697A653A20312E3872656D3B0A2F2A0A7B0A202022766172222020';
wwv_flow_api.g_varchar2_table(7) := '2020203A202240666F732D6E6F7469662D7469746C652D666F6E742D776569676874222C0A2020226E616D6522202020203A20225469746C6520466F6E7420576569676874222C0A2020227479706522202020203A20226E756D626572222C0A20202272';
wwv_flow_api.g_varchar2_table(8) := '616E6765222020203A207B0A20202020226D696E22202020202020203A203130302C0A20202020226D617822202020202020203A203930302C0A2020202022696E6372656D656E7422203A203130300A20207D2C0A20202267726F7570222020203A2022';
wwv_flow_api.g_varchar2_table(9) := '464F53202D204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F7469662D7469746C652D666F6E742D7765696768743A203730303B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D6D6573736167652D';
wwv_flow_api.g_varchar2_table(10) := '666F6E742D73697A65222C0A2020226E616D6522202020203A20224D65737361676520466F6E742053697A65222C0A2020227479706522202020203A20226E756D626572222C0A202022756E697473222020203A202272656D222C0A20202272616E6765';
wwv_flow_api.g_varchar2_table(11) := '222020203A207B0A20202020226D696E22202020202020203A20312C0A20202020226D617822202020202020203A20332C0A2020202022696E6372656D656E7422203A20302E310A20207D2C0A20202267726F7570222020203A2022464F53202D204E6F';
wwv_flow_api.g_varchar2_table(12) := '74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F7469662D6D6573736167652D666F6E742D73697A653A20312E3472656D3B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D6D6573736167652D666F6E742D';
wwv_flow_api.g_varchar2_table(13) := '776569676874222C0A2020226E616D6522202020203A20224D65737361676520466F6E7420576569676874222C0A2020227479706522202020203A20226E756D626572222C0A20202272616E6765222020203A207B0A20202020226D696E222020202020';
wwv_flow_api.g_varchar2_table(14) := '20203A203130302C0A20202020226D617822202020202020203A203930302C0A2020202022696E6372656D656E7422203A203130300A20207D2C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73220A7D0A2A2F0A';
wwv_flow_api.g_varchar2_table(15) := '40666F732D6E6F7469662D6D6573736167652D666F6E742D7765696768743A203530303B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D6D696E2D7769647468222C0A2020226E616D6522202020203A20224D696E2057';
wwv_flow_api.g_varchar2_table(16) := '69647468222C0A2020227479706522202020203A20226E756D626572222C0A202022756E697473222020203A20227078222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A203130302C0A20202020226D61782220';
wwv_flow_api.g_varchar2_table(17) := '2020202020203A20323030302C0A2020202022696E6372656D656E7422203A2032300A20207D2C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F7469662D6D696E2D77696474';
wwv_flow_api.g_varchar2_table(18) := '683A2033323070783B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D6D61782D7769647468222C0A2020226E616D6522202020203A20224D6178205769647468222C0A2020227479706522202020203A20226E756D6265';
wwv_flow_api.g_varchar2_table(19) := '72222C0A202022756E697473222020203A20227078222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A203130302C0A20202020226D617822202020202020203A20323030302C0A2020202022696E6372656D656E';

wwv_flow_api.g_varchar2_table(20) := '7422203A2032300A20207D2C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F7469662D6D61782D77696474683A2036343070783B0A2F2A0A7B0A202022766172222020202020';
wwv_flow_api.g_varchar2_table(21) := '3A202240666F732D6E6F7469662D6F706163697479222C0A2020226E616D6522202020203A20224E6F74696669636174696F6E204F706163697479222C0A2020227479706522202020203A20226E756D626572222C0A20202272616E6765222020203A20';
wwv_flow_api.g_varchar2_table(22) := '7B0A20202020226D696E22202020202020203A20302E312C0A20202020226D617822202020202020203A20312C0A2020202022696E6372656D656E7422203A20302E310A20207D2C0A20202267726F7570222020203A2022464F53202D204E6F74696669';
wwv_flow_api.g_varchar2_table(23) := '636174696F6E73220A7D0A2A2F0A40666F732D6E6F7469662D6F7061636974793A20302E393B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D737563636573732D6267222C0A2020226E616D6522202020203A20224261';
wwv_flow_api.g_varchar2_table(24) := '636B67726F756E64222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A202253756363657373220A7D0A2A2F0A';
wwv_flow_api.g_varchar2_table(25) := '40666F732D6E6F7469662D737563636573732D62673A2040675F537563636573732D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D737563636573732D636F6C6F72222C0A2020226E616D6522202020203A2022';
wwv_flow_api.g_varchar2_table(26) := '436F6C6F72222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A202253756363657373220A7D0A2A2F0A40666F';
wwv_flow_api.g_varchar2_table(27) := '732D6E6F7469662D737563636573732D636F6C6F723A2040675F537563636573732D46473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D6572726F722D6267222C0A2020226E616D6522202020203A20224261636B67';
wwv_flow_api.g_varchar2_table(28) := '726F756E64222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20224572726F72220A7D0A2A2F0A40666F732D';
wwv_flow_api.g_varchar2_table(29) := '6E6F7469662D6572726F722D62673A2040675F44616E6765722D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D6572726F722D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A2020';
wwv_flow_api.g_varchar2_table(30) := '227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20224572726F72220A7D0A2A2F0A40666F732D6E6F7469662D6572726F';
wwv_flow_api.g_varchar2_table(31) := '722D636F6C6F723A2040675F44616E6765722D46473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D7761726E696E672D6267222C0A2020226E616D6522202020203A20224261636B67726F756E64222C0A2020227479';
wwv_flow_api.g_varchar2_table(32) := '706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20225761726E696E67220A7D0A2A2F0A40666F732D6E6F7469662D7761726E69';
wwv_flow_api.g_varchar2_table(33) := '6E672D62673A2040675F5761726E696E672D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D7761726E696E672D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A2020227479706522';
wwv_flow_api.g_varchar2_table(34) := '202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20225761726E696E67220A7D0A2A2F0A40666F732D6E6F7469662D7761726E696E672D';
wwv_flow_api.g_varchar2_table(35) := '636F6C6F723A2040675F5761726E696E672D46473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D696E666F2D6267222C0A2020226E616D6522202020203A20224261636B67726F756E64222C0A202022747970652220';
wwv_flow_api.g_varchar2_table(36) := '2020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A2022496E666F220A7D0A2A2F0A40666F732D6E6F7469662D696E666F2D62673A2040675F';
wwv_flow_api.g_varchar2_table(37) := '496E666F2D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F7469662D696E666F2D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A2020227479706522202020203A2022636F6C6F72222C0A20';
wwv_flow_api.g_varchar2_table(38) := '202267726F7570222020203A2022464F53202D204E6F74696669636174696F6E73222C0A20202273756267726F7570223A2022496E666F220A7D0A2A2F0A40666F732D6E6F7469662D696E666F2D636F6C6F723A2040675F496E666F2D46473B0A2F2A2A';
wwv_flow_api.g_varchar2_table(39) := '2A2A2A2A2A2A2A2A2A2F0A2F2A2043535320202020202A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2F0A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D70616765207B0A202020206D696E2D77696474683A2040666F732D6E6F746966';
wwv_flow_api.g_varchar2_table(40) := '2D6D696E2D77696474682021696D706F7274616E743B0A202020206D61782D77696474683A2040666F732D6E6F7469662D6D61782D77696474682021696D706F7274616E743B0A20202020666F6E742D73697A653A2040666F732D6E6F7469662D6D6573';
wwv_flow_api.g_varchar2_table(41) := '736167652D666F6E742D73697A652021696D706F7274616E743B0A7D0A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B0A20202020666F6E742D7765696768743A2040';
wwv_flow_api.g_varchar2_table(42) := '666F732D6E6F7469662D7469746C652D666F6E742D7765696768742021696D706F7274616E743B0A20202020666F6E742D73697A653A2040666F732D6E6F7469662D7469746C652D666F6E742D73697A652021696D706F7274616E743B0A7D0A2E666F73';
wwv_flow_api.g_varchar2_table(43) := '74722D636F6E7461696E6572202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B0A20202020666F6E742D7765696768743A2040666F732D6E6F7469662D6D6573736167652D666F6E742D7765696768742021696D70';
wwv_flow_api.g_varchar2_table(44) := '6F7274616E743B0A7D0A2F2F20737563636573730A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373207B0A202020206261636B67726F756E642D636F6C6F723A207267';
wwv_flow_api.g_varchar2_table(45) := '6261287265642840666F732D6E6F7469662D737563636573732D6267292C20677265656E2840666F732D6E6F7469662D737563636573732D6267292C20626C75652840666F732D6E6F7469662D737563636573732D6267292C2040666F732D6E6F746966';
wwv_flow_api.g_varchar2_table(46) := '2D6F706163697479292021696D706F7274616E743B0A20202020636F6C6F723A2040666F732D6E6F7469662D737563636573732D636F6C6F722021696D706F7274616E743B0A7D0A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(47) := '2D706167652E666F732D416C6572742D2D737563636573733A686F766572207B0A202020206261636B67726F756E642D636F6C6F723A2040666F732D6E6F7469662D737563636573732D62672021696D706F7274616E743B0A7D0A2F2F696E666F0A2E66';
wwv_flow_api.g_varchar2_table(48) := '6F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F207B0A20206261636B67726F756E642D636F6C6F723A2072676261287265642840666F732D6E6F7469662D696E666F2D6267292C20';
wwv_flow_api.g_varchar2_table(49) := '677265656E2840666F732D6E6F7469662D696E666F2D6267292C20626C75652840666F732D6E6F7469662D696E666F2D6267292C2040666F732D6E6F7469662D6F706163697479292021696D706F7274616E743B0A2020636F6C6F723A2040666F732D6E';
wwv_flow_api.g_varchar2_table(50) := '6F7469662D696E666F2D636F6C6F722021696D706F7274616E743B0A7D0A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F3A686F766572207B0A20206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(51) := '2D636F6C6F723A2040666F732D6E6F7469662D696E666F2D62672021696D706F7274616E743B0A7D0A2F2F207761726E696E670A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F732D416C6572742D2D776172';
wwv_flow_api.g_varchar2_table(52) := '6E696E67207B0A20206261636B67726F756E642D636F6C6F723A2072676261287265642840666F732D6E6F7469662D7761726E696E672D6267292C20677265656E2840666F732D6E6F7469662D7761726E696E672D6267292C20626C75652840666F732D';
wwv_flow_api.g_varchar2_table(53) := '6E6F7469662D7761726E696E672D6267292C2040666F732D6E6F7469662D6F706163697479292021696D706F7274616E743B0A2020636F6C6F723A2040666F732D6E6F7469662D7761726E696E672D636F6C6F722021696D706F7274616E743B0A7D0A2E';
wwv_flow_api.g_varchar2_table(54) := '666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E673A686F766572207B0A20206261636B67726F756E642D636F6C6F723A2040666F732D6E6F7469662D7761726E696E672D62';
wwv_flow_api.g_varchar2_table(55) := '672021696D706F7274616E743B0A7D0A2F2F206572726F720A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572207B0A20206261636B67726F756E642D636F6C6F723A2072';
wwv_flow_api.g_varchar2_table(56) := '676261287265642840666F732D6E6F7469662D6572726F722D6267292C20677265656E2840666F732D6E6F7469662D6572726F722D6267292C20626C75652840666F732D6E6F7469662D6572726F722D6267292C2040666F732D6E6F7469662D6F706163';
wwv_flow_api.g_varchar2_table(57) := '697479292021696D706F7274616E743B0A2020636F6C6F723A2040666F732D6E6F7469662D6572726F722D636F6C6F722021696D706F7274616E743B0A7D0A2E666F7374722D636F6E7461696E6572202E666F732D416C6572742D2D706167652E666F73';
wwv_flow_api.g_varchar2_table(58) := '2D416C6572742D2D64616E6765723A686F766572207B0A20206261636B67726F756E642D636F6C6F723A2040666F732D6E6F7469662D6572726F722D62672021696D706F7274616E743B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(43199243737195998)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'less/fos-notification-themeroller.less'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done




