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
--     PLUGIN: 17207678382595881
--     PLUGIN: 13235263798301758
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 34175298479606152
--     PLUGIN: 35822631205839510
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
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
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#js/toastr#MIN#.js',
'#PLUGIN_FILES#js/script#MIN#.js'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#css/toastr#MIN#.css',
''))
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
'--  Github: https://github.com/foex-open-source/fos-notifications',
'--',
'-- =============================================================================',
'--',
'function render',
'    ( p_dynamic_action apex_plugin.t_dynamic_action',
'    , p_plugin         apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'    ',
'    -- general attributes',
'    l_notification_type     p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_message_type          p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_static_title          p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'    l_static_message        p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    l_js_title_code         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    l_js_message_code       p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_options               p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;',
'    l_escape                boolean                            := instr(p_dynamic_action.attribute_07,''escape-html'') > 0;',
'    l_client_substitutions  boolean                            := instr(p_dynamic_action.attribute_07,''substitutions-clientside'') > 0;',
'    l_advanced_setup        boolean                            := instr(p_dynamic_action.attribute_07,''advanced-setup'') > 0; ',
'    l_auto_dismiss          boolean                            := instr(p_dynamic_action.attribute_07,''auto-dismiss'') > 0;',
'    l_inline_item_error     boolean                            := instr(p_dynamic_action.attribute_07,''page-item-inline-error'') > 0;',
'    l_method                apex_t_varchar2                    := apex_string.split(case when l_advanced_setup then p_dynamic_action.attribute_14 else p_plugin.attribute_04 end, ''-'');',
'    l_show_method           p_dynamic_action.attribute_14%type := case when l_method.count = 2 then l_method(1) else ''fadeIn'' end;',
'    l_hide_method           p_dynamic_action.attribute_14%type := case when l_method.count = 2 then l_method(2) else ''fadeOut'' end;',
'    l_easing                apex_t_varchar2                    := apex_string.split(case when l_advanced_setup then p_dynamic_action.attribute_15 else p_plugin.attribute_05 end, ''-'');',
'    l_show_easing           p_dynamic_action.attribute_15%type := case when l_easing.count = 2 then l_easing(1) else ''swing'' end;',
'    l_hide_easing           p_dynamic_action.attribute_15%type := case when l_easing.count = 2 then l_easing(2) else ''linear'' end;',
'    l_show_duration         pls_integer                        := nvl(case when l_advanced_setup then p_dynamic_action.attribute_09 else p_plugin.attribute_06 end, ''500'');',
'    l_hide_duration         pls_integer                        := nvl(case when l_advanced_setup then p_dynamic_action.attribute_10 else p_plugin.attribute_07 end, ''1000'');',
'    l_timeout               pls_integer                        := case l_auto_dismiss when true then nvl(case when l_advanced_setup then p_dynamic_action.attribute_11 else p_plugin.attribute_02 end, ''5000'') else ''0'' end;',
'    l_extend_timeout        pls_integer                        := case l_auto_dismiss when true then nvl(case when l_advanced_setup then p_dynamic_action.attribute_13 else p_plugin.attribute_03 end, ''5000'') else ''0'' end;',
'    l_position_class        p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;',
'    l_page_items            p_dynamic_action.attribute_08%type := case when p_dynamic_action.attribute_12 != ''Y'' then p_dynamic_action.attribute_12 end;',
'    l_init_js_fn            varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), ''undefined'');',
'',
'begin',
'    ',
'    -- debug info',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action',
'            ( p_plugin         => p_plugin',
'            , p_dynamic_action => p_dynamic_action ',
'            );',
'    end if;',
'    ',
'    -- define our JSON config',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    -- notification plugin settings',
'    apex_json.write(''type''             , l_notification_type);',
'    apex_json.write(''substituteValues'' , l_client_substitutions);',
'    apex_json.write(''autoDismiss''      , l_auto_dismiss);',
'    apex_json.write(''removeToasts''     , instr(l_options, ''remove-notifications'') > 0);',
'',
'    -- notification toastr settings',
'    apex_json.open_object(''options'');',
'    apex_json.write(''debug''            , v(''DEBUG'') != ''NO'');',
'    apex_json.write(''showEasing''       , l_show_easing);',
'    apex_json.write(''hideEasing''       , l_hide_easing);',
'    apex_json.write(''showMethod''       , l_show_method);',
'    apex_json.write(''hideMethod''       , l_hide_method);',
'    apex_json.write(''showDuration''     , l_show_duration);',
'    apex_json.write(''hideDuration''     , l_hide_duration);',
'    apex_json.write(''timeOut''          , l_timeout);',
'    apex_json.write(''extendedTimeOut''  , l_extend_timeout);',
'    apex_json.write(''positionClass''    , l_position_class);',
'    apex_json.write(''tapToDismiss''     , instr(l_options, ''tap-to-dismiss'') > 0);',
'    apex_json.write(''closeButton''      , instr(l_options, ''close-button'') > 0);',
'    apex_json.write(''newestOnTop''      , instr(l_options, ''newest-on-top'') > 0);',
'    apex_json.write(''progressBar''      , instr(l_options, ''progress-bar'') > 0);',
'    apex_json.write(''preventDuplicates'', instr(l_options, ''prevent-duplicates'') > 0);',
'    apex_json.write(''escapeHtml''       , l_escape);',
'    apex_json.close_object;',
'    ',
'    -- additional error information for page items',
'    apex_json.write(''inlineItemErrors'' , l_inline_item_error);',
'    if l_inline_item_error then',
'        apex_json.write(''inlinePageItems'', trim(both '','' from trim(l_page_items)));',
'    end if;',
'    ',
'    -- notification message',
'    if l_message_type =  ''static'' then',
'        apex_json.write(''title''        , case when l_client_substitutions then l_static_title   else apex_plugin_util.replace_substitutions(l_static_title)   end);',
'        apex_json.write(''message''      , case when l_client_substitutions then l_static_message else apex_plugin_util.replace_substitutions(l_static_message) end);',
'    else',
'        if l_js_title_code is not null then',
'            apex_json.write_raw',
'                ( p_name  => ''title''',
'                , p_value => case l_message_type',
'                     when ''javascript-expression'' then',
'                        ''function(){return ('' || l_js_title_code || '');}''',
'                     when ''javascript-function-body'' then',
'                         l_js_title_code',
'                     end',
'                );',
'        end if;',
'        apex_json.write_raw',
'            ( p_name  => ''message''',
'            , p_value => case l_message_type',
'                 when ''javascript-expression'' then',
'                    ''function(){return ('' || l_js_message_code || '');}''',
'                 when ''javascript-function-body'' then',
'                     l_js_message_code',
'                 end',
'            );',
'    end if;',
'',
'    apex_json.close_object;',
'    ',
'    l_result.javascript_function := ''function(){FOS.utils.notification(this, '' || apex_json.get_clob_output || '', ''|| l_init_js_fn || '');}'';',
'    ',
'    apex_json.free_output;',
'',
'    return l_result;',
'end;'))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>The FOS Notification dynamic action plug-in is the perfect solution for showing notification messages in your application(s). It allows you to perform distinct colour notifications according to the message type e.g. success, warning, error, info. '
||'You can derive the message using static text with substitution support or from a Javascript expression or function. You can use HTML in the message or escape HTML for tighter security.&nbsp;</p><p>This plugin is based on the Toastr opensource library'
||': https://codeseven.github.io/toastr/</p>'
,p_version_identifier=>'20.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>190
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17454185301798172)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Auto Dismiss'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'Toggle this option to automatically remove notifications after X many seconds.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17613102081804415)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Remove After'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'5000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(17454185301798172)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Remove the notification after X many milliseconds without any user interaction'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17624477849809403)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Extend time on hover'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'5000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(17454185301798172)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'How long the notification will display after a user hovers over it'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17635753366817944)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Show/Hide Animation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'fadeIn-fadeOut'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select the show/hide notification animation type'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17960349065990911)
,p_plugin_attribute_id=>wwv_flow_api.id(17635753366817944)
,p_display_sequence=>10
,p_display_value=>'fadeIn/fadeOut'
,p_return_value=>'fadeIn-fadeOut'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17961144920993028)
,p_plugin_attribute_id=>wwv_flow_api.id(17635753366817944)
,p_display_sequence=>20
,p_display_value=>'show/hide'
,p_return_value=>'show-hide'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17960769896992036)
,p_plugin_attribute_id=>wwv_flow_api.id(17635753366817944)
,p_display_sequence=>30
,p_display_value=>'slideDown/slideUp'
,p_return_value=>'slideDown-slideUp'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17641478221821806)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Show/Hide Easing'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'swing-linear'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select the show/hide notification animation easing type. An easing function just defines a transition speed between the animation start and end'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17971665736999071)
,p_plugin_attribute_id=>wwv_flow_api.id(17641478221821806)
,p_display_sequence=>10
,p_display_value=>'linear/linear'
,p_return_value=>'linear-linear'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17971284464998217)
,p_plugin_attribute_id=>wwv_flow_api.id(17641478221821806)
,p_display_sequence=>20
,p_display_value=>'linear/swing'
,p_return_value=>'linear-swing'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17970419911995695)
,p_plugin_attribute_id=>wwv_flow_api.id(17641478221821806)
,p_display_sequence=>30
,p_display_value=>'swing/linear'
,p_return_value=>'swing-linear'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17970815816997263)
,p_plugin_attribute_id=>wwv_flow_api.id(17641478221821806)
,p_display_sequence=>40
,p_display_value=>'swing/swing'
,p_return_value=>'swing-swing'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17658488391876709)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Show Animation Duration'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'500'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_help_text=>'<p>Choose how long you would like the "Show" animation to last i.e. when fading or sliding the message in</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17664166530880360)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Hide Animation Duration'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'1000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_help_text=>'Choose how long you would like the "Hide" animation to last i.e. when fading or sliding the message out'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13261281157409464)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Notification Type'
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
,p_display_value=>'Success'
,p_return_value=>'success'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17114030773118097)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>20
,p_display_value=>'Info'
,p_return_value=>'info'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17114455343118765)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>30
,p_display_value=>'Warning'
,p_return_value=>'warning'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17114844984119380)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>40
,p_display_value=>'Error'
,p_return_value=>'error'
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
,p_help_text=>'<p>The notification title. Leave this blank if you do not want to include a title</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13263740517441135)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Message'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>true
,p_depending_on_attribute_id=>wwv_flow_api.id(13261528233412148)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'<p>The notification message you wish to display.</p>'
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
,p_is_required=>true
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
,p_default_value=>'auto-dismiss:close-button:newest-on-top:escape-html:progress-bar:tap-to-dismiss'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Choose extra options to apply to your toast notification</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(26449111919463898)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>5
,p_display_value=>'Auto Dismiss'
,p_return_value=>'auto-dismiss'
,p_help_text=>'<p>Toggle this option to automatically remove notifications after X many seconds.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17174338575948618)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>10
,p_display_value=>'Escape HTML'
,p_return_value=>'escape-html'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13266707143512559)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>20
,p_display_value=>'Newest On Top'
,p_return_value=>'newest-on-top'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17307430123727742)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>30
,p_display_value=>'Perform Substitutions Client-side'
,p_return_value=>'substitutions-clientside'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13265970659461908)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>40
,p_display_value=>'Prevent Duplicates'
,p_return_value=>'prevent-duplicates'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17272813756021351)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>50
,p_display_value=>'Remove All Notifications First'
,p_return_value=>'remove-notifications'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13265166416458361)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>60
,p_display_value=>'Show Close Button'
,p_return_value=>'close-button'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13266364177509814)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>70
,p_display_value=>'Show Force Close Button'
,p_return_value=>'force-close-btn'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(26478086677542504)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>75
,p_display_value=>'Show Inline Error with Page Item'
,p_return_value=>'page-item-inline-error'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13265542309459895)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>80
,p_display_value=>'Show Progress Bar'
,p_return_value=>'progress-bar'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17383101625660605)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>90
,p_display_value=>'Tap/Click Notification to Dismiss'
,p_return_value=>'tap-to-dismiss'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17192572286516417)
,p_plugin_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_display_sequence=>100
,p_display_value=>'Advanced Configuration'
,p_return_value=>'advanced-setup'
,p_help_text=>'<p>Choose this option to control animation, timeout duration etc.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(13272683616562939)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>25
,p_prompt=>'Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'toast-top-right'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the position where you would like the notification to be displayed.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13272980849564354)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>10
,p_display_value=>'Top Right'
,p_return_value=>'toast-top-right'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13275332505571898)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>20
,p_display_value=>'Top Center'
,p_return_value=>'toast-top-center'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13274198989567931)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>30
,p_display_value=>'Top Left'
,p_return_value=>'toast-top-left'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13274555393569192)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>40
,p_display_value=>'Top Full Width'
,p_return_value=>'toast-top-full-width'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13273375140565600)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>50
,p_display_value=>'Bottom Right'
,p_return_value=>'toast-bottom-right'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13275775435573212)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>60
,p_display_value=>'Bottom Center'
,p_return_value=>'toast-bottom-center'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13273797237566746)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>70
,p_display_value=>'Bottom Left'
,p_return_value=>'toast-bottom-left'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(13274954558570286)
,p_plugin_attribute_id=>wwv_flow_api.id(13272683616562939)
,p_display_sequence=>80
,p_display_value=>'Bottom Full Width'
,p_return_value=>'toast-bottom-full-width'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17115284810138447)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>160
,p_prompt=>'Show Animation Duration'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'500'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'advanced-setup'
,p_help_text=>'<p>Choose how long you would like the "Show" animation to last i.e. when fading or sliding the message in<br></p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17115552886141847)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>170
,p_prompt=>'Hide Animation Duration'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'1000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'advanced-setup'
,p_help_text=>'Choose how long you would like the "Hide" animation to last i.e. when fading or sliding the message out'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17116040711153044)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Remove After'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'5000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'auto-dismiss'
,p_help_text=>'<p>Remove the notification after X many milliseconds without any user interaction</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(26497677485554966)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>72
,p_prompt=>'Page Item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'page-item-inline-error'
,p_help_text=>'<p>Associate error messages with one or more page items. If you would like to clear these error messages please use the "FOS - Message Actions" and the "Clear Errors" action.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17175613229001043)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Extend time on hover'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'5000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'auto-dismiss'
,p_help_text=>'<p>How long the notification will display after a user hovers over it</p>'
);
wwv_flow
_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17177124593048986)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Show/Hide Animation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'fadeIn-fadeOut'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'advanced-setup'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the show/hide notification animation type</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17177495527050026)
,p_plugin_attribute_id=>wwv_flow_api.id(17177124593048986)
,p_display_sequence=>10
,p_display_value=>'fadeIn/fadeOut'
,p_return_value=>'fadeIn-fadeOut'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17178242052052440)
,p_plugin_attribute_id=>wwv_flow_api.id(17177124593048986)
,p_display_sequence=>20
,p_display_value=>'show/hide'
,p_return_value=>'show-hide'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17177870732051334)
,p_plugin_attribute_id=>wwv_flow_api.id(17177124593048986)
,p_display_sequence=>30
,p_display_value=>'slideDown/slideUp'
,p_return_value=>'slideDown-slideUp'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17178699882061811)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Show/Hide Easing'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'swing-linear'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13264879889455301)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'advanced-setup'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Select the show/hide notification animation easing type. An easing function just defines a transition speed between the animation start and end.</p><p></p><ul><li>swing - the animation is slow at the start and end and speeds up in the middle&nbsp;'
||' (default on show)</li><li>linear - the animation progresses at a constant pace (default on hide)</li></ul><p></p>'
);
end;
/
begin
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17180169737068102)
,p_plugin_attribute_id=>wwv_flow_api.id(17178699882061811)
,p_display_sequence=>10
,p_display_value=>'linear/linear'
,p_return_value=>'linear-linear'
,p_help_text=>'<p><b>linear/linear</b> - the animation progresses at a constant pace&nbsp;on show and hide</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17179734020066238)
,p_plugin_attribute_id=>wwv_flow_api.id(17178699882061811)
,p_display_sequence=>20
,p_display_value=>'linear/swing'
,p_return_value=>'linear-swing'
,p_help_text=>'<div><b>linear/swing</b><br></div><ul><li>linear - the animation progresses at a constant pace on show<br></li><li>swing - the animation is slow at the start and end and speeds up in the middle on hide</li></ul>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17178999312063893)
,p_plugin_attribute_id=>wwv_flow_api.id(17178699882061811)
,p_display_sequence=>30
,p_display_value=>'swing/linear'
,p_return_value=>'swing-linear'
,p_help_text=>'<div><b>swing/linear</b><br></div><ul><li>swing - the animation is slow at the start and end and speeds up in the middle on show</li><li>linear - the animation progresses at a constant pace on hide</li></ul>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(17179391598065052)
,p_plugin_attribute_id=>wwv_flow_api.id(17178699882061811)
,p_display_sequence=>40
,p_display_value=>'swing/swing'
,p_return_value=>'swing-swing'
,p_help_text=>'<p><b>swing/swing</b> the animation is slow at the start and end and speeds up in the middle on show and hide</p>'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(17184580661356883)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F204E616D6573706163652053657475700A77696E646F772E464F53203D2077696E646F772E464F53207C7C207B7D3B0A77696E646F772E464F532E7574696C73203D2077696E646F772E464F532E7574696C73207C7C207B7D3B0A77696E646F772E';
wwv_flow_api.g_varchar2_table(2) := '464F532E7574696C732E697352544C203D2077696E646F772E464F532E7574696C732E697352544C207C7C2066756E6374696F6E202829207B2072657475726E20242827626F647927292E6174747228276469722729203D3D3D202272746C22207D3B0A';
wwv_flow_api.g_varchar2_table(3) := '0A2F2A2A0A202A20412064796E616D696320616374696F6E20746F20656173696C7920637265617465206E6F74696669636174696F6E206D6573736167657320696E20415045582E204974206973206261736564206F6E2074686520546F61737472206F';
wwv_flow_api.g_varchar2_table(4) := '70656E20736F75726365206A517565727920706C7567696E0A202A0A202A2040706172616D207B4F626A6563747D2020206461436F6E746578742020202020202020202020202020202020202020202044796E616D696320416374696F6E20636F6E7465';
wwv_flow_api.g_varchar2_table(5) := '78742061732070617373656420696E20627920415045580A202A2040706172616D207B4F626A6563747D202020636F6E66696720202020202020202020202020202020202020202020202020436F6E66696775726174696F6E206F626A65637420686F6C';
wwv_flow_api.g_varchar2_table(6) := '64696E6720746865206E6F74696669636174696F6E2073657474696E67730A202A2040706172616D207B737472696E677D202020636F6E6669672E747970652020202020202020202020202020202020202020546865206E6F74696669636174696F6E20';
wwv_flow_api.g_varchar2_table(7) := '7479706520652E672E20737563636573732C206572726F722C207761726E696E672C20696E666F0A202A2040706172616D207B66756E6374696F6E7D20696E6974466E202020202020202020202020202020202020202020202020204A5320696E697469';
wwv_flow_api.g_varchar2_table(8) := '616C697A6174696F6E2066756E6374696F6E2077686963682077696C6C20616C6C6F7720796F7520746F206F766572726964652073657474696E6773207269676874206265666F726520746865206E6F746966696361746F6E2069732073656E740A202A';
wwv_flow_api.g_varchar2_table(9) := '2F0A464F532E7574696C732E6E6F74696669636174696F6E203D2066756E6374696F6E20286461436F6E746578742C20636F6E6669672C20696E6974466E29207B0A20202020766172206D6573736167652C207469746C652C2064656661756C74732C20';
wwv_flow_api.g_varchar2_table(10) := '706F736974696F6E436C6173733B0A0A202020202F2F20706172616D6574657220636865636B730A202020206461436F6E74657874203D206461436F6E74657874207C7C20746869733B0A20202020636F6E666967203D20636F6E666967207C7C207B7D';
wwv_flow_api.g_varchar2_table(11) := '3B0A20202020636F6E6669672E74797065203D20636F6E6669672E74797065207C7C2027696E666F273B0A0A20202020617065782E64656275672E696E666F2827464F53202D204E6F74696669636174696F6E73272C20636F6E666967293B0A0A202020';
wwv_flow_api.g_varchar2_table(12) := '202F2F2064656661756C74206F7074696F6E732069662077652063616C6C20746869732066756E6374696F6E206469726563746C7920696E204A61766173637269707420636F64650A2020202064656661756C7473203D207B0A2020202020202020636C';
wwv_flow_api.g_varchar2_table(13) := '6F7365427574746F6E3A20747275652C0A202020202020202064656275673A2066616C73652C0A20202020202020206E65776573744F6E546F703A20747275652C0A202020202020202070726F67726573734261723A20747275652C0A20202020202020';
wwv_flow_api.g_varchar2_table(14) := '20706F736974696F6E436C6173733A2027746F6173742D746F702D7269676874272C0A202020202020202070726576656E744475706C6963617465733A2066616C73652C0A202020202020202065736361706548746D6C3A20747275652C0A2020202020';
wwv_flow_api.g_varchar2_table(15) := '20202073686F774475726174696F6E3A203530302C0A2020202020202020686964654475726174696F6E3A20313030302C0A202020202020202074696D654F75743A20353030302C0A2020202020202020657874656E64656454696D654F75743A203530';
wwv_flow_api.g_varchar2_table(16) := '30302C0A202020202020202072746C3A20464F532E7574696C732E697352544C28290A202020207D0A0A202020202F2F20646566696E65206F7572206D6573736167652064657461696C73207768696368206D61792064796E616D6963616C6C7920636F';
wwv_flow_api.g_varchar2_table(17) := '6D652066726F6D2061204A6176617363726970742063616C6C0A2020202069662028636F6E6669672E6D65737361676520696E7374616E63656F662046756E6374696F6E29207B0A20202020202020206D657373616765203D20636F6E6669672E6D6573';
wwv_flow_api.g_varchar2_table(18) := '736167652E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D20656C7365207B0A20202020202020206D657373616765203D20636F6E6669672E6D6573736167653B0A202020207D0A0A2020202069662028636F6E6669672E74';
wwv_flow_api.g_varchar2_table(19) := '69746C6520696E7374616E63656F662046756E6374696F6E29207B0A20202020202020207469746C65203D20636F6E6669672E7469746C652E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(20) := '2020207469746C65203D20636F6E6669672E7469746C653B0A202020207D0A0A202020202F2F2077652077696C6C206E6F7420706572666F726D2061206E6F74696669636174696F6E206966206F7572206D65737361676520626F6479206973206E756C';
wwv_flow_api.g_varchar2_table(21) := '6C2F656D70747920737472696E670A2020202069662028216D657373616765292072657475726E3B0A0A202020202F2F20205265706C6163696E6720737562737469747574696F6E20737472696E67730A2020202069662028636F6E6669672E73756273';
wwv_flow_api.g_varchar2_table(22) := '74697475746556616C75657329207B0A20202020202020202F2F2020576520646F6E27742065736361706520746865206D6573736167652062792064656661756C742E205765206C65742074686520646576656C6F706572206465636964652077686574';
wwv_flow_api.g_varchar2_table(23) := '68657220746F206573636170650A20202020202020202F2F20207468652077686F6C65206D6573736167652C206F72206A75737420696E76696475616C2070616765206974656D73207669612026504147455F4954454D2148544D4C2E0A202020202020';
wwv_flow_api.g_varchar2_table(24) := '2020696620287469746C6529207B0A2020202020202020202020207469746C65203D20617065782E7574696C2E6170706C7954656D706C617465287469746C652C207B0A2020202020202020202020202020202064656661756C7445736361706546696C';
wwv_flow_api.g_varchar2_table(25) := '7465723A206E756C6C0A2020202020202020202020207D293B0A20202020202020207D0A20202020202020206D657373616765203D20617065782E7574696C2E6170706C7954656D706C617465286D6573736167652C207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '2064656661756C7445736361706546696C7465723A206E756C6C0A20202020202020207D293B0A20202020202020202F2F2077652077696C6C206E6F7420706572666F726D2061206E6F74696669636174696F6E206966206F7572206D65737361676520';
wwv_flow_api.g_varchar2_table(27) := '626F6479206973206E756C6C2F656D70747920737472696E670A202020202020202069662028216D657373616765292072657475726E3B0A202020207D0A0A202020202F2F2077652077696C6C206E6F7420706572666F726D2061206E6F746966696361';
wwv_flow_api.g_varchar2_table(28) := '74696F6E206966206F7572206D65737361676520626F6479206973206E756C6C2F656D70747920737472696E670A2020202069662028216D657373616765292072657475726E3B0A0A202020202F2F20446566696E65206F7572206E6F74696669636174';
wwv_flow_api.g_varchar2_table(29) := '696F6E2073657474696E67730A20202020746F617374722E6F7074696F6E73203D20242E657874656E642864656661756C74732C20636F6E6669672E6F7074696F6E73293B0A0A202020202F2F20416C6C6F772074686520646576656C6F70657220746F';
wwv_flow_api.g_varchar2_table(30) := '20706572666F726D20616E79206C617374202863656E7472616C697A656429206368616E676573207573696E67204A61766173637269707420496E697469616C697A6174696F6E20436F64652073657474696E670A2020202069662028696E6974466E20';
wwv_flow_api.g_varchar2_table(31) := '696E7374616E63656F662046756E6374696F6E29207B0A2020202020202020696E6974466E2E63616C6C286461436F6E746578742C20746F617374722E6F7074696F6E73293B0A202020207D0A0A202020202F2F207765206E65656420746F206D616E75';
wwv_flow_api.g_varchar2_table(32) := '616C6C792073776170206F757220706F736974696F6E20636C61737320696E2052544C206D6F64652061732074686520646576656C6F706572206D6179206861766520656E61626C65642069740A2020202069662028746F617374722E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(33) := '2E72746C29207B0A2020202020202020706F736974696F6E436C617373203D20746F617374722E6F7074696F6E732E706F736974696F6E436C6173733B0A202020202020202069662028706F736974696F6E436C6173732E696E6465784F662827726967';
wwv_flow_api.g_varchar2_table(34) := '68742729203E202D3129207B0A202020202020202020202020746F617374722E6F7074696F6E732E706F736974696F6E436C617373203D20706F736974696F6E436C6173732E7265706C616365282F72696768742F2C20276C65667427293B0A20202020';
wwv_flow_api.g_varchar2_table(35) := '202020207D20656C73652069662028706F736974696F6E436C6173732E696E6465784F6628276C6566742729203E202D3129207B0A202020202020202020202020746F617374722E6F7074696F6E732E706F736974696F6E436C617373203D20706F7369';
wwv_flow_api.g_varchar2_table(36) := '74696F6E436C6173732E7265706C616365282F6C6566742F2C2027726967687427293B0A20202020202020207D0A202020207D0A0A202020202F2F204F7074696F6E616C6C792072656D6F766520616C6C206E6F74696669636174696F6E732066697273';
wwv_flow_api.g_varchar2_table(37) := '740A2020202069662028636F6E6669672E72656D6F7665546F6173747329207B0A2020202020202020746F617374722E72656D6F766528293B202F2F20776974686F757420616E696D6174696F6E0A20202020202020202F2F746F617374722E636C6561';
wwv_flow_api.g_varchar2_table(38) := '7228293B202F2F207769746820616E696D6174696F6E0A202020207D0A0A202020202F2F20617373636F6169746520616E7920696E6C696E652070616765206974656D206572726F72730A2020202069662028636F6E6669672E696E6C696E654974656D';
wwv_flow_api.g_varchar2_table(39) := '4572726F727320262620636F6E6669672E696E6C696E65506167654974656D7329207B0A2020202020202020636F6E6669672E696E6C696E65506167654974656D732E73706C697428272C27292E666F72456163682866756E6374696F6E287061676549';
wwv_flow_api.g_varchar2_table(40) := '74656D29207B0A2020202020202020202020202F2F2053686F77206F75722041504558206572726F72206D6573736167650A202020202020202020202020617065782E6D6573736167652E73686F774572726F7273287B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(41) := '20202020747970653A20276572726F72272C0A202020202020202020202020202020206C6F636174696F6E3A2027696E6C696E65272C0A20202020202020202020202020202020706167654974656D3A20706167654974656D2C0A202020202020202020';
wwv_flow_api.g_varchar2_table(42) := '202020202020206D6573736167653A206D6573736167652C0A202020202020202020202020202020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279206E6F770A2020202020202020';
wwv_flow_api.g_varchar2_table(43) := '2020202020202020756E736166653A2066616C73650A2020202020202020202020207D293B0A20202020202020207D293B0A202020207D0A0A202020202F2F20506572666F726D207468652061637475616C206E6F74696669636174696F6E0A20202020';
wwv_flow_api.g_varchar2_table(44) := '746F617374725B636F6E6669672E747970655D286D6573736167652C207469746C65293B0A0A7D3B0A';
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
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B2277696E646F77222C22464F53222C227574696C73222C22697352544C222C2224222C2261747472222C226E6F74696669636174696F';
wwv_flow_api.g_varchar2_table(2) := '6E222C226461436F6E74657874222C22636F6E666967222C22696E6974466E222C226D657373616765222C227469746C65222C2264656661756C7473222C22706F736974696F6E436C617373222C2274686973222C2274797065222C2261706578222C22';
wwv_flow_api.g_varchar2_table(3) := '6465627567222C22696E666F222C22636C6F7365427574746F6E222C226E65776573744F6E546F70222C2270726F6772657373426172222C2270726576656E744475706C696361746573222C2265736361706548746D6C222C2273686F77447572617469';
wwv_flow_api.g_varchar2_table(4) := '6F6E222C22686964654475726174696F6E222C2274696D654F7574222C22657874656E64656454696D654F7574222C2272746C222C2246756E6374696F6E222C2263616C6C222C227375627374697475746556616C756573222C227574696C222C226170';
wwv_flow_api.g_varchar2_table(5) := '706C7954656D706C617465222C2264656661756C7445736361706546696C746572222C22746F61737472222C226F7074696F6E73222C22657874656E64222C22696E6465784F66222C227265706C616365222C2272656D6F7665546F61737473222C2272';
wwv_flow_api.g_varchar2_table(6) := '656D6F7665222C22696E6C696E654974656D4572726F7273222C22696E6C696E65506167654974656D73222C2273706C6974222C22666F7245616368222C22706167654974656D222C2273686F774572726F7273222C226C6F636174696F6E222C22756E';
wwv_flow_api.g_varchar2_table(7) := '73616665225D2C226D617070696E6773223A2241414341412C4F41414F432C4941414D442C4F41414F432C4B41414F2C4741433342442C4F41414F432C49414149432C4D414151462C4F41414F432C49414149432C4F4141532C4741437643462C4F4141';
wwv_flow_api.g_varchar2_table(8) := '4F432C49414149432C4D41414D432C4D414151482C4F41414F432C49414149432C4D41414D432C4F4141532C574141632C4D414169432C5141413142432C454141452C51414151432C4B41414B2C51415576464A2C49414149432C4D41414D492C614141';
wwv_flow_api.g_varchar2_table(9) := '652C53414155432C45414157432C45414151432C4741436C442C49414149432C45414153432C4541414F432C45414155432C45414739424E2C45414159412C474141614F2C4D41437A424E2C45414153412C474141552C4941435A4F2C4B41414F502C45';
wwv_flow_api.g_varchar2_table(10) := '41414F4F2C4D4141512C4F41453742432C4B41414B432C4D41414D432C4B41414B2C734241417542562C4741477643492C454141572C434143504F2C614141612C45414362462C4F41414F2C45414350472C614141612C45414362432C614141612C4541';
wwv_flow_api.g_varchar2_table(11) := '4362522C634141652C6B42414366532C6D4241416D422C4541436E42432C594141592C4541435A432C614141632C49414364432C614141632C49414364432C514141532C49414354432C6742414169422C4941436A42432C4941414B33422C4941414943';
wwv_flow_api.g_varchar2_table(12) := '2C4D41414D432C53414B664F2C45414441462C4541414F452C6D4241416D426D422C534143684272422C4541414F452C514141516F422C4B41414B76422C45414157432C4741452F42412C4541414F452C5141496A42432C45414441482C4541414F472C';
wwv_flow_api.g_varchar2_table(13) := '6942414169426B422C534143684272422C4541414F472C4D41414D6D422C4B41414B76422C45414157432C4741453742412C4541414F472C4D414964442C4B414744462C4541414F75422C6D4241474870422C49414341412C454141514B2C4B41414B67';
wwv_flow_api.g_varchar2_table(14) := '422C4B41414B432C6341416374422C4541414F2C4341436E4375422C6F42414171422C514147374278422C454141554D2C4B41414B67422C4B41414B432C6341416376422C454141532C434143764377422C6F42414171422C55414F784278422C494147';
wwv_flow_api.g_varchar2_table(15) := '4C79422C4F41414F432C5141415568432C4541414569432C4F41414F7A422C454141554A2C4541414F34422C534147764333422C6141416B426F422C5541436C4270422C4541414F71422C4B41414B76422C4541415734422C4F41414F432C5341493942';
wwv_flow_api.g_varchar2_table(16) := '442C4F41414F432C51414151522C4F414366662C454141674273422C4F41414F432C5141415176422C6541436279422C514141512C554141592C4541436C43482C4F41414F432C5141415176422C6341416742412C4541416330422C514141512C514141';
wwv_flow_api.g_varchar2_table(17) := '532C514143764431422C4541416379422C514141512C534141572C4941437843482C4F41414F432C5141415176422C6341416742412C4541416330422C514141512C4F4141512C57414B6A452F422C4541414F67432C634143504C2C4F41414F4D2C5341';
wwv_flow_api.g_varchar2_table(18) := '4B506A432C4541414F6B432C6B4241416F426C432C4541414F6D432C694241436C436E432C4541414F6D432C674241416742432C4D41414D2C4B41414B432C534141512C53414153432C4741452F4339422C4B41414B4E2C5141415171432C574141572C';
wwv_flow_api.g_varchar2_table(19) := '434143704268432C4B41414D2C5141434E69432C534141552C53414356462C53414155412C4541435670432C51414153412C4541455475432C514141512C4F414D7042642C4F41414F33422C4541414F4F2C4D41414D4C2C4541415343222C2266696C65';
wwv_flow_api.g_varchar2_table(20) := '223A227363726970742E6A73227D';
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
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F533D77696E646F772E464F537C7C7B7D2C77696E646F772E464F532E7574696C733D77696E646F772E464F532E7574696C737C7C7B7D2C77696E646F772E464F532E7574696C732E697352544C3D77696E646F772E464F532E7574';
wwv_flow_api.g_varchar2_table(2) := '696C732E697352544C7C7C66756E6374696F6E28297B72657475726E2272746C223D3D3D242822626F647922292E61747472282264697222297D2C464F532E7574696C732E6E6F74696669636174696F6E3D66756E6374696F6E28742C652C69297B7661';
wwv_flow_api.g_varchar2_table(3) := '7220732C6F2C6E2C613B743D747C7C746869732C28653D657C7C7B7D292E747970653D652E747970657C7C22696E666F222C617065782E64656275672E696E666F2822464F53202D204E6F74696669636174696F6E73222C65292C6E3D7B636C6F736542';
wwv_flow_api.g_varchar2_table(4) := '7574746F6E3A21302C64656275673A21312C6E65776573744F6E546F703A21302C70726F67726573734261723A21302C706F736974696F6E436C6173733A22746F6173742D746F702D7269676874222C70726576656E744475706C6963617465733A2131';
wwv_flow_api.g_varchar2_table(5) := '2C65736361706548746D6C3A21302C73686F774475726174696F6E3A3530302C686964654475726174696F6E3A3165332C74696D654F75743A3565332C657874656E64656454696D654F75743A3565332C72746C3A464F532E7574696C732E697352544C';
wwv_flow_api.g_varchar2_table(6) := '28297D2C733D652E6D65737361676520696E7374616E63656F662046756E6374696F6E3F652E6D6573736167652E63616C6C28742C65293A652E6D6573736167652C6F3D652E7469746C6520696E7374616E63656F662046756E6374696F6E3F652E7469';
wwv_flow_api.g_varchar2_table(7) := '746C652E63616C6C28742C65293A652E7469746C652C7326262821652E7375627374697475746556616C7565737C7C286F2626286F3D617065782E7574696C2E6170706C7954656D706C617465286F2C7B64656661756C7445736361706546696C746572';
wwv_flow_api.g_varchar2_table(8) := '3A6E756C6C7D29292C733D617065782E7574696C2E6170706C7954656D706C61746528732C7B64656661756C7445736361706546696C7465723A6E756C6C7D292929262673262628746F617374722E6F7074696F6E733D242E657874656E64286E2C652E';
wwv_flow_api.g_varchar2_table(9) := '6F7074696F6E73292C6920696E7374616E63656F662046756E6374696F6E2626692E63616C6C28742C746F617374722E6F7074696F6E73292C746F617374722E6F7074696F6E732E72746C26262828613D746F617374722E6F7074696F6E732E706F7369';
wwv_flow_api.g_varchar2_table(10) := '74696F6E436C617373292E696E6465784F662822726967687422293E2D313F746F617374722E6F7074696F6E732E706F736974696F6E436C6173733D612E7265706C616365282F72696768742F2C226C65667422293A612E696E6465784F6628226C6566';
wwv_flow_api.g_varchar2_table(11) := '7422293E2D31262628746F617374722E6F7074696F6E732E706F736974696F6E436C6173733D612E7265706C616365282F6C6566742F2C227269676874222929292C652E72656D6F7665546F617374732626746F617374722E72656D6F766528292C652E';
wwv_flow_api.g_varchar2_table(12) := '696E6C696E654974656D4572726F72732626652E696E6C696E65506167654974656D732626652E696E6C696E65506167654974656D732E73706C697428222C22292E666F7245616368282866756E6374696F6E2874297B617065782E6D6573736167652E';
wwv_flow_api.g_varchar2_table(13) := '73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A22696E6C696E65222C706167654974656D3A742C6D6573736167653A732C756E736166653A21317D297D29292C746F617374725B652E747970655D28732C6F29297D';
wwv_flow_api.g_varchar2_table(14) := '3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
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
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E2865297B65285B226A7175657279225D2C2866756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B76617220742C6E2C732C6F3D302C693D226572726F72222C613D22696E666F222C723D2273756363657373';
wwv_flow_api.g_varchar2_table(2) := '222C6C3D227761726E696E67222C633D7B636C6561723A66756E6374696F6E286E2C73297B766172206F3D6628293B747C7C64286F293B75286E2C6F2C73297C7C66756E6374696F6E286E297B666F722876617220733D742E6368696C6472656E28292C';
wwv_flow_api.g_varchar2_table(3) := '6F3D732E6C656E6774682D313B6F3E3D303B6F2D2D2975286528735B6F5D292C6E297D286F297D2C72656D6F76653A66756E6374696F6E286E297B76617220733D6628293B747C7C642873293B6966286E2626303D3D3D6528223A666F637573222C6E29';
wwv_flow_api.g_varchar2_table(4) := '2E6C656E6774682972657475726E20766F69642067286E293B742E6368696C6472656E28292E6C656E6774682626742E72656D6F766528297D2C6572726F723A66756E6374696F6E28652C742C6E297B72657475726E206D287B747970653A692C69636F';
wwv_flow_api.g_varchar2_table(5) := '6E436C6173733A6628292E69636F6E436C61737365732E6572726F722C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D2C676574436F6E7461696E65723A642C696E666F3A66756E6374696F6E28652C74';
wwv_flow_api.g_varchar2_table(6) := '2C6E297B72657475726E206D287B747970653A612C69636F6E436C6173733A6628292E69636F6E436C61737365732E696E666F2C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D2C6F7074696F6E733A7B';
wwv_flow_api.g_varchar2_table(7) := '7D2C7375627363726962653A66756E6374696F6E2865297B6E3D657D2C737563636573733A66756E6374696F6E28652C742C6E297B72657475726E206D287B747970653A722C69636F6E436C6173733A6628292E69636F6E436C61737365732E73756363';
wwv_flow_api.g_varchar2_table(8) := '6573732C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D2C76657273696F6E3A22322E312E34222C7761726E696E673A66756E6374696F6E28652C742C6E297B72657475726E206D287B747970653A6C2C';
wwv_flow_api.g_varchar2_table(9) := '69636F6E436C6173733A6628292E69636F6E436C61737365732E7761726E696E672C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D7D3B72657475726E20633B66756E6374696F6E2064286E2C73297B72';
wwv_flow_api.g_varchar2_table(10) := '657475726E206E7C7C286E3D662829292C28743D65282223222B6E2E636F6E7461696E657249642B222E222B6E2E706F736974696F6E436C61737329292E6C656E6774687C7C73262628743D66756E6374696F6E286E297B72657475726E28743D652822';
wwv_flow_api.g_varchar2_table(11) := '3C6469762F3E22292E6174747228226964222C6E2E636F6E7461696E65724964292E616464436C617373286E2E706F736974696F6E436C61737329292E617070656E64546F2865286E2E74617267657429292C747D286E29292C747D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(12) := '207528742C6E2C73297B766172206F3D212821737C7C21732E666F726365292626732E666F7263653B72657475726E212821747C7C216F262630213D3D6528223A666F637573222C74292E6C656E67746829262628745B6E2E686964654D6574686F645D';
wwv_flow_api.g_varchar2_table(13) := '287B6475726174696F6E3A6E2E686964654475726174696F6E2C656173696E673A6E2E68696465456173696E672C636F6D706C6574653A66756E6374696F6E28297B672874297D7D292C2130297D66756E6374696F6E20702865297B6E26266E2865297D';
wwv_flow_api.g_varchar2_table(14) := '66756E6374696F6E206D286E297B76617220693D6628292C613D6E2E69636F6E436C6173737C7C692E69636F6E436C6173733B696628766F69642030213D3D6E2E6F7074696F6E734F76657272696465262628693D652E657874656E6428692C6E2E6F70';
wwv_flow_api.g_varchar2_table(15) := '74696F6E734F76657272696465292C613D6E2E6F7074696F6E734F766572726964652E69636F6E436C6173737C7C61292C2166756E6374696F6E28652C74297B696628652E70726576656E744475706C696361746573297B696628742E6D657373616765';
wwv_flow_api.g_varchar2_table(16) := '3D3D3D732972657475726E21303B733D742E6D6573736167657D72657475726E21317D28692C6E29297B6F2B2B2C743D6428692C2130293B76617220723D6E756C6C2C6C3D6528223C6469762F3E22292C633D6528223C6469762F3E22292C753D652822';
wwv_flow_api.g_varchar2_table(17) := '3C6469762F3E22292C6D3D6528223C6469762F3E22292C683D6528692E636C6F736548746D6C292C763D7B696E74657276616C49643A6E756C6C2C686964654574613A6E756C6C2C6D61784869646554696D653A6E756C6C7D2C433D7B746F6173744964';
wwv_flow_api.g_varchar2_table(18) := '3A6F2C73746174653A2276697369626C65222C737461727454696D653A6E657720446174652C6F7074696F6E733A692C6D61703A6E7D3B72657475726E206E2E69636F6E436C61737326266C2E616464436C61737328692E746F617374436C617373292E';
wwv_flow_api.g_varchar2_table(19) := '616464436C6173732861292C66756E6374696F6E28297B6966286E2E7469746C65297B76617220653D6E2E7469746C653B692E65736361706548746D6C262628653D77286E2E7469746C6529292C632E617070656E642865292E616464436C6173732869';
wwv_flow_api.g_varchar2_table(20) := '2E7469746C65436C617373292C6C2E617070656E642863297D7D28292C66756E6374696F6E28297B6966286E2E6D657373616765297B76617220653D6E2E6D6573736167653B692E65736361706548746D6C262628653D77286E2E6D6573736167652929';
wwv_flow_api.g_varchar2_table(21) := '2C752E617070656E642865292E616464436C61737328692E6D657373616765436C617373292C6C2E617070656E642875297D7D28292C692E636C6F7365427574746F6E262628682E616464436C61737328692E636C6F7365436C617373292E6174747228';
wwv_flow_api.g_varchar2_table(22) := '22726F6C65222C22627574746F6E22292C6C2E70726570656E64286829292C692E70726F67726573734261722626286D2E616464436C61737328692E70726F6772657373436C617373292C6C2E70726570656E64286D29292C692E72746C26266C2E6164';
wwv_flow_api.g_varchar2_table(23) := '64436C617373282272746C22292C692E6E65776573744F6E546F703F742E70726570656E64286C293A742E617070656E64286C292C66756E6374696F6E28297B76617220653D22223B737769746368286E2E69636F6E436C617373297B6361736522746F';
wwv_flow_api.g_varchar2_table(24) := '6173742D73756363657373223A6361736522746F6173742D696E666F223A653D22706F6C697465223B627265616B3B64656661756C743A653D22617373657274697665227D6C2E617474722822617269612D6C697665222C65297D28292C6C2E68696465';
wwv_flow_api.g_varchar2_table(25) := '28292C6C5B692E73686F774D6574686F645D287B6475726174696F6E3A692E73686F774475726174696F6E2C656173696E673A692E73686F77456173696E672C636F6D706C6574653A692E6F6E53686F776E7D292C692E74696D654F75743E3026262872';
wwv_flow_api.g_varchar2_table(26) := '3D73657454696D656F757428542C692E74696D654F7574292C762E6D61784869646554696D653D7061727365466C6F617428692E74696D654F7574292C762E686964654574613D286E65772044617465292E67657454696D6528292B762E6D6178486964';
wwv_flow_api.g_varchar2_table(27) := '6554696D652C692E70726F6772657373426172262628762E696E74657276616C49643D736574496E74657276616C28442C31302929292C66756E6374696F6E28297B692E636C6F73654F6E486F76657226266C2E686F76657228622C4F293B21692E6F6E';
wwv_flow_api.g_varchar2_table(28) := '636C69636B2626692E746170546F4469736D69737326266C2E636C69636B2854293B692E636C6F7365427574746F6E2626682626682E636C69636B282866756E6374696F6E2865297B652E73746F7050726F7061676174696F6E3F652E73746F7050726F';
wwv_flow_api.g_varchar2_table(29) := '7061676174696F6E28293A766F69642030213D3D652E63616E63656C427562626C6526262130213D3D652E63616E63656C427562626C65262628652E63616E63656C427562626C653D2130292C692E6F6E436C6F7365436C69636B2626692E6F6E436C6F';
wwv_flow_api.g_varchar2_table(30) := '7365436C69636B2865292C54282130297D29293B692E6F6E636C69636B26266C2E636C69636B282866756E6374696F6E2865297B692E6F6E636C69636B2865292C5428297D29297D28292C702843292C692E64656275672626636F6E736F6C652626636F';
wwv_flow_api.g_varchar2_table(31) := '6E736F6C652E6C6F672843292C6C7D66756E6374696F6E20772865297B72657475726E206E756C6C3D3D65262628653D2222292C652E7265706C616365282F262F672C2226616D703B22292E7265706C616365282F222F672C222671756F743B22292E72';
wwv_flow_api.g_varchar2_table(32) := '65706C616365282F272F672C22262333393B22292E7265706C616365282F3C2F672C22266C743B22292E7265706C616365282F3E2F672C222667743B22297D66756E6374696F6E20542874297B766172206E3D7426262131213D3D692E636C6F73654D65';
wwv_flow_api.g_varchar2_table(33) := '74686F643F692E636C6F73654D6574686F643A692E686964654D6574686F642C733D7426262131213D3D692E636C6F73654475726174696F6E3F692E636C6F73654475726174696F6E3A692E686964654475726174696F6E2C6F3D7426262131213D3D69';
wwv_flow_api.g_varchar2_table(34) := '2E636C6F7365456173696E673F692E636C6F7365456173696E673A692E68696465456173696E673B696628216528223A666F637573222C6C292E6C656E6774687C7C742972657475726E20636C65617254696D656F757428762E696E74657276616C4964';
wwv_flow_api.g_varchar2_table(35) := '292C6C5B6E5D287B6475726174696
F6E3A732C656173696E673A6F2C636F6D706C6574653A66756E6374696F6E28297B67286C292C636C65617254696D656F75742872292C692E6F6E48696464656E26262268696464656E22213D3D432E737461746526';
wwv_flow_api.g_varchar2_table(36) := '26692E6F6E48696464656E28292C432E73746174653D2268696464656E222C432E656E6454696D653D6E657720446174652C702843297D7D297D66756E6374696F6E204F28297B28692E74696D654F75743E307C7C692E657874656E64656454696D654F';
wwv_flow_api.g_varchar2_table(37) := '75743E3029262628723D73657454696D656F757428542C692E657874656E64656454696D654F7574292C762E6D61784869646554696D653D7061727365466C6F617428692E657874656E64656454696D654F7574292C762E686964654574613D286E6577';
wwv_flow_api.g_varchar2_table(38) := '2044617465292E67657454696D6528292B762E6D61784869646554696D65297D66756E6374696F6E206228297B636C65617254696D656F75742872292C762E686964654574613D302C6C2E73746F702821302C2130295B692E73686F774D6574686F645D';
wwv_flow_api.g_varchar2_table(39) := '287B6475726174696F6E3A692E73686F774475726174696F6E2C656173696E673A692E73686F77456173696E677D297D66756E6374696F6E204428297B76617220653D28762E686964654574612D286E65772044617465292E67657454696D652829292F';
wwv_flow_api.g_varchar2_table(40) := '762E6D61784869646554696D652A3130303B6D2E776964746828652B222522297D7D66756E6374696F6E206628297B72657475726E20652E657874656E64287B7D2C7B746170546F4469736D6973733A21302C746F617374436C6173733A22746F617374';
wwv_flow_api.g_varchar2_table(41) := '222C636F6E7461696E657249643A22746F6173742D636F6E7461696E6572222C64656275673A21312C73686F774D6574686F643A2266616465496E222C73686F774475726174696F6E3A3330302C73686F77456173696E673A227377696E67222C6F6E53';
wwv_flow_api.g_varchar2_table(42) := '686F776E3A766F696420302C686964654D6574686F643A22666164654F7574222C686964654475726174696F6E3A3165332C68696465456173696E673A227377696E67222C6F6E48696464656E3A766F696420302C636C6F73654D6574686F643A21312C';
wwv_flow_api.g_varchar2_table(43) := '636C6F73654475726174696F6E3A21312C636C6F7365456173696E673A21312C636C6F73654F6E486F7665723A21302C657874656E64656454696D654F75743A3165332C69636F6E436C61737365733A7B6572726F723A22746F6173742D6572726F7222';
wwv_flow_api.g_varchar2_table(44) := '2C696E666F3A22746F6173742D696E666F222C737563636573733A22746F6173742D73756363657373222C7761726E696E673A22746F6173742D7761726E696E67227D2C69636F6E436C6173733A22746F6173742D696E666F222C706F736974696F6E43';
wwv_flow_api.g_varchar2_table(45) := '6C6173733A22746F6173742D746F702D7269676874222C74696D654F75743A3565332C7469746C65436C6173733A22746F6173742D7469746C65222C6D657373616765436C6173733A22746F6173742D6D657373616765222C65736361706548746D6C3A';
wwv_flow_api.g_varchar2_table(46) := '21312C7461726765743A22626F6479222C636C6F736548746D6C3A273C627574746F6E20747970653D22627574746F6E223E2674696D65733B3C2F627574746F6E3E272C636C6F7365436C6173733A22746F6173742D636C6F73652D627574746F6E222C';
wwv_flow_api.g_varchar2_table(47) := '6E65776573744F6E546F703A21302C70726576656E744475706C6963617465733A21312C70726F67726573734261723A21312C70726F6772657373436C6173733A22746F6173742D70726F6772657373222C72746C3A21317D2C632E6F7074696F6E7329';
wwv_flow_api.g_varchar2_table(48) := '7D66756E6374696F6E20672865297B747C7C28743D642829292C652E697328223A76697369626C6522297C7C28652E72656D6F766528292C653D6E756C6C2C303D3D3D742E6368696C6472656E28292E6C656E677468262628742E72656D6F766528292C';
wwv_flow_api.g_varchar2_table(49) := '733D766F6964203029297D7D28297D29297D282266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E653A66756E6374696F6E28652C74297B22756E646566696E656422213D747970656F66206D6F';
wwv_flow_api.g_varchar2_table(50) := '64756C6526266D6F64756C652E6578706F7274733F6D6F64756C652E6578706F7274733D74287265717569726528226A71756572792229293A77696E646F772E746F617374723D742877696E646F772E6A5175657279297D293B0A2F2F2320736F757263';
wwv_flow_api.g_varchar2_table(51) := '654D617070696E6755524C3D746F617374722E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13246454430315456)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/toastr.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E746F6173742D7469746C65207B0A2020666F6E742D7765696768743A20626F6C643B0A7D0A2E746F6173742D6D657373616765207B0A20202D6D732D776F72642D777261703A20627265616B2D776F72643B0A2020776F72642D777261703A20627265';
wwv_flow_api.g_varchar2_table(2) := '616B2D776F72643B0A7D0A2E746F6173742D6D65737361676520612C0A2E746F6173742D6D657373616765206C6162656C207B0A2020636F6C6F723A20234646464646463B0A7D0A2E746F6173742D6D65737361676520613A686F766572207B0A202063';
wwv_flow_api.g_varchar2_table(3) := '6F6C6F723A20234343434343433B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A7D0A2E746F6173742D636C6F73652D627574746F6E207B0A2020706F736974696F6E3A2072656C61746976653B0A202072696768743A202D302E3365';
wwv_flow_api.g_varchar2_table(4) := '6D3B0A2020746F703A202D302E33656D3B0A2020666C6F61743A2072696768743B0A2020666F6E742D73697A653A20323070783B0A2020666F6E742D7765696768743A20626F6C643B0A2020636F6C6F723A20234646464646463B0A20202D7765626B69';
wwv_flow_api.g_varchar2_table(5) := '742D746578742D736861646F773A203020317078203020236666666666663B0A2020746578742D736861646F773A203020317078203020236666666666663B0A20206F7061636974793A20302E393B0A20202D6D732D66696C7465723A2070726F676964';
wwv_flow_api.g_varchar2_table(6) := '3A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3930293B0A202066696C7465723A20616C706861286F7061636974793D3930293B0A20206C696E652D6865696768743A20313B0A7D0A2E746F61';
wwv_flow_api.g_varchar2_table(7) := '73742D636C6F73652D627574746F6E3A686F7665722C0A2E746F6173742D636C6F73652D627574746F6E3A666F637573207B0A2020636F6C6F723A20233030303030303B0A2020746578742D6465636F726174696F6E3A206E6F6E653B0A202063757273';
wwv_flow_api.g_varchar2_table(8) := '6F723A20706F696E7465723B0A20206F7061636974793A20302E343B0A20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3430293B0A20206669';
wwv_flow_api.g_varchar2_table(9) := '6C7465723A20616C706861286F7061636974793D3430293B0A7D0A2E72746C202E746F6173742D636C6F73652D627574746F6E207B0A20206C6566743A202D302E33656D3B0A2020666C6F61743A206C6566743B0A202072696768743A20302E33656D3B';
wwv_flow_api.g_varchar2_table(10) := '0A7D0A2F2A4164646974696F6E616C2070726F7065727469657320666F7220627574746F6E2076657273696F6E0A20694F532072657175697265732074686520627574746F6E20656C656D656E7420696E7374656164206F6620616E20616E63686F7220';
wwv_flow_api.g_varchar2_table(11) := '7461672E0A20496620796F752077616E742074686520616E63686F722076657273696F6E2C2069742072657175697265732060687265663D222322602E2A2F0A627574746F6E2E746F6173742D636C6F73652D627574746F6E207B0A202070616464696E';
wwv_flow_api.g_varchar2_table(12) := '673A20303B0A2020637572736F723A20706F696E7465723B0A20206261636B67726F756E643A207472616E73706172656E743B0A2020626F726465723A20303B0A20202D7765626B69742D617070656172616E63653A206E6F6E653B0A7D0A2E746F6173';
wwv_flow_api.g_varchar2_table(13) := '742D746F702D63656E746572207B0A2020746F703A20303B0A202072696768743A20303B0A202077696474683A20313030253B0A7D0A2E746F6173742D626F74746F6D2D63656E746572207B0A2020626F74746F6D3A20303B0A202072696768743A2030';
wwv_flow_api.g_varchar2_table(14) := '3B0A202077696474683A20313030253B0A7D0A2E746F6173742D746F702D66756C6C2D7769647468207B0A2020746F703A20303B0A202072696768743A20303B0A202077696474683A20313030253B0A7D0A2E746F6173742D626F74746F6D2D66756C6C';
wwv_flow_api.g_varchar2_table(15) := '2D7769647468207B0A2020626F74746F6D3A20303B0A202072696768743A20303B0A202077696474683A20313030253B0A7D0A2E746F6173742D746F702D6C656674207B0A2020746F703A20313270783B0A20206C6566743A20313270783B0A7D0A2E74';
wwv_flow_api.g_varchar2_table(16) := '6F6173742D746F702D7269676874207B0A2020746F703A20313270783B0A202072696768743A20313270783B0A7D0A2E746F6173742D626F74746F6D2D7269676874207B0A202072696768743A20313270783B0A2020626F74746F6D3A20313270783B0A';
wwv_flow_api.g_varchar2_table(17) := '7D0A2E746F6173742D626F74746F6D2D6C656674207B0A2020626F74746F6D3A20313270783B0A20206C6566743A20313270783B0A7D0A23746F6173742D636F6E7461696E6572207B0A2020706F736974696F6E3A2066697865643B0A20207A2D696E64';
wwv_flow_api.g_varchar2_table(18) := '65783A203939393939393B0A2020706F696E7465722D6576656E74733A206E6F6E653B0A20202F2A6F76657272696465732A2F0A7D0A23746F6173742D636F6E7461696E6572202A207B0A20202D6D6F7A2D626F782D73697A696E673A20626F72646572';
wwv_flow_api.g_varchar2_table(19) := '2D626F783B0A20202D7765626B69742D626F782D73697A696E673A20626F726465722D626F783B0A2020626F782D73697A696E673A20626F726465722D626F783B0A7D0A23746F6173742D636F6E7461696E6572203E20646976207B0A2020706F736974';
wwv_flow_api.g_varchar2_table(20) := '696F6E3A2072656C61746976653B0A2020706F696E7465722D6576656E74733A206175746F3B0A20206F766572666C6F773A2068696464656E3B0A20206D617267696E3A20302030203670783B0A202070616464696E673A203135707820313570782031';
wwv_flow_api.g_varchar2_table(21) := '35707820353070783B0A202077696474683A2034353070783B0A20202D6D6F7A2D626F726465722D7261646975733A203370782033707820337078203370783B0A20202D7765626B69742D626F726465722D7261646975733A2033707820337078203370';
wwv_flow_api.g_varchar2_table(22) := '78203370783B0A2020626F726465722D7261646975733A203370782033707820337078203370783B0A20206261636B67726F756E642D706F736974696F6E3A20313570782063656E7465723B0A20206261636B67726F756E642D7265706561743A206E6F';
wwv_flow_api.g_varchar2_table(23) := '2D7265706561743B0A20202D6D6F7A2D626F782D736861646F773A20302030203132707820233939393939393B0A20202D7765626B69742D626F782D736861646F773A20302030203132707820233939393939393B0A2020626F782D736861646F773A20';
wwv_flow_api.g_varchar2_table(24) := '302030203132707820233939393939393B0A2020636F6C6F723A20234646464646463B0A20206F7061636974793A20302E383B0A20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E';
wwv_flow_api.g_varchar2_table(25) := '416C706861284F7061636974793D3830293B0A202066696C7465723A20616C706861286F7061636974793D3830293B0A2020666F6E742D73697A653A20312E3672656D2021696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E';
wwv_flow_api.g_varchar2_table(26) := '206469762E72746C207B0A2020646972656374696F6E3A2072746C3B0A202070616464696E673A20313570782035307078203135707820313570783B0A20206261636B67726F756E642D706F736974696F6E3A20726967687420313570782063656E7465';
wwv_flow_api.g_varchar2_table(27) := '723B0A7D0A23746F6173742D636F6E7461696E6572203E206469763A686F766572207B0A20202D6D6F7A2D626F782D736861646F773A20302030203132707820233030303030303B0A20202D7765626B69742D626F782D736861646F773A203020302031';
wwv_flow_api.g_varchar2_table(28) := '32707820233030303030303B0A2020626F782D736861646F773A20302030203132707820233030303030303B0A20206F7061636974793A20313B0A20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963';
wwv_flow_api.g_varchar2_table(29) := '726F736F66742E416C706861284F7061636974793D313030293B0A202066696C7465723A20616C706861286F7061636974793D313030293B0A2020637572736F723A20706F696E7465723B0A7D0A23746F6173742D636F6E7461696E6572203E202E746F';
wwv_flow_api.g_varchar2_table(30) := '6173742D696E666F207B0A20206261636B67726F756E642D696D6167653A2075726C2822646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A';
wwv_flow_api.g_varchar2_table(31) := '33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414777535552425645684C745A613953674E42454D6339735578785263';
wwv_flow_api.g_varchar2_table(32) := '6F554B537A535749685870464D68685957466861426734795059695743585A78424C4552734C52533345516B456677434B646A574A4177534B43676F4B4363756476344F35594C727437457A6758686955332F342B6232636B6D77566A4A53704B6B5136';
wwv_flow_api.g_varchar2_table(33) := '77416934677768542B7A3377524263457A30796A53736555547263527966734873586D4430416D62484F433949693856496D6E75584250676C48705135777753564D37734E6E5447375A61344A774464436A7879416948336E7941326D7461544A756669';
wwv_flow_api.g_varchar2_table(34) := '445A35644361716C4974494C68314E486174664E35736B766A78395A33386D363943677A75586D5A675672504947453736334A7839714B73526F7A57597736784F486445522B6E6E324B6B4F2B42622B55563543424E36574336517442676252566F7A72';
wwv_flow_api.g_varchar2_table(35) := '616841626D6D364874557367745043313974466478585A59424F666B626D464A3156614841315641486A6430707037306F545A7A76522B455672783259676664737136657535354248595238686C636B692B6E2B6B4552554647384272413042776A6541';
wwv_flow_api.g_varchar2_table(36) := '76324D38574C51427463792B534436664E736D6E4233416C424C726754745657316332514E346256574C415461495336304A32447535793154694A676A53427646565A67546D7743552B64415A466F507847454573386E79484339427765324776454A76';
wwv_flow_api.g_varchar2_table(37) := '3257585A6230766A647946543443786B33652F6B49716C4F476F564C7777506576705948542B3030542B68577758446634414A414F557157634468627741414141415355564F524B35435949493D22292021696D706F7274616E743B0A7D0A23746F6173';
wwv_flow_api.g_varchar2_table(38) := '742D636F6E7461696E6572203E202E746F6173742D6572726F72207B0A20206261636B67726F756E642D696D6167653A2075726C2822646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E5355684555674141';
wwv_flow_api.g_varchar2_table(39) := '41426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D414141374441636476714751414141484F535552425645684C';
wwv_flow_api.g_varchar2_table(40) := '725A612F53674E42454D5A7A6830574B43436C53434B6149594F45442B41414B6551514C473848577A744C43496D4272596164674964592B67494B4E596B42465377753743416F7143676B6B6F4742492F4532385064624C5A6D65444C677A5A7A637838';
wwv_flow_api.g_varchar2_table(41) := '332F7A5A3253535843316A3966722B49314871393367327978483469774D31766B6F4257416478436D707A5478666B4E325263795A4E614846496B536F31302B386B67786B584955525635484778546D467563373542325266516B707848473861416761';
wwv_flow_api.g_varchar2_table(42) := '414661307441487159466651374977653279684F446B382B4A34433779416F5254574933772F346B6C47526752346C4F3752706E392B67764D7957702B75784668382B482B41526C674E316E4A754A75514159764E6B456E774746636B31384572347133';
wwv_flow_api.g_varchar2_table(43) := '656745632F6F4F2B6D684C644B67527968644E466961634330726C4F4362684E567A344839466E41596744427655335149696F5A6C4A464C4A74736F4859524466695A6F557949787143745270566C414E71304555346441706A727467657A5046616435';
wwv_flow_api.g_varchar2_table(44) := '53313957676A6B6330684E566E754634486A56413643375172534962796C422B6F5A65336148674273716C4E714B594834386A58794A4B4D7541626979564A384B7A61423365526330706739567751346E6946727949363871694F693341626A77647366';
wwv_flow_api.g_varchar2_table(45) := '6E41746B3062436A544C4A4B72366D724439673869712F532F4238316867754F4D6C51546E56794734307741636A6E6D6773434E455344726A6D653777666674503450375350344E33434A5A64767A6F4E79477132632F48574F584A47737656672B5241';
wwv_flow_api.g_varchar2_table(46) := '2F6B324D432F774E364932594132507438476B41414141415355564F524B35435949493D22292021696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E202E746F6173742D73756363657373207B0A20206261636B67726F756E';
wwv_flow_api.g_varchar2_table(47) := '642D696D6167653A2075726C2822646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E53523049417273346336514141';
wwv_flow_api.g_varchar2_table(48) := '4141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414473535552425645684C593241594266514D67662F2F2F3350382B2F657641496776412F467349462B426176594444574D42';
wwv_flow_api.g_varchar2_table(49) := '47726F61534D4D42694538564337415A44724946614D466E696933415A546A556773555557554441384F644148366951625145687734487947735045634B425842494334415268657834473442736A6D77655531736F49466147672F57746F465A52495A';
wwv_flow_api.g_varchar2_table(50) := '644576494D68786B43436A5849567341545636674647414373345273773045476749494833514A594A6748534152515A44725741422B6A61777A67732B5132554F343944376A6E525352476F454652494C63646D454D57474930636D304A4A3251705941';
wwv_flow_api.g_varchar2_table(51) := '31524476636D7A4A455768414268442F7071724C30533043577541424B676E526B69396C4C736553376732416C7177485751534B48346F4B4C72494C7052476845514377324C6952554961346C7741414141424A52553545726B4A6767673D3D22292021';
wwv_flow_api.g_varchar2_table(52) := '696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E202E746F6173742D7761726E696E67207B0A20206261636B67726F756E642D696D6167653A2075726C2822646174613A696D6167652F706E673B6261736536342C6956424F';
wwv_flow_api.g_varchar2_table(53) := '5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744';
wwv_flow_api.g_varchar2_table(54) := '416364767147514141414759535552425645684C355A537654734E51464D62585A4749434D5947596D4A684151494A41494359515041414369534442384169494351514A54344371514577674A76594153415143695A69596D4A6841494241544341524A';
wwv_flow_api.g_varchar2_table(55) := '792B397254736C646438734B75314D302B644C6230353776362F6C62712F32724B306D532F54524E6A3963574E414B5059494A494937674978436351353163767149442B4749455838415347344231624B3567495A466551666F4A6445584F6667583451';
wwv_flow_api.g_varchar2_table(56) := '415167376B4832413635795138376C79786232377367676B417A41754668626267314B326B67436B4231625677794952396D324C37505250496844554958674774794B77353735797A336C544E733658344A586E6A562B4C4B4D2F6D334D79646E546274';
wwv_flow_api.g_varchar2_table(57) := '4F4B496A747A3656684342713476536D336E63647244326C6B305667555853564B6A56444A584A7A696A57315251647355374637374865387536386B6F4E5A547A384F7A35794761364A3348336C5A3078596758424B3251796D6C5757412B52576E5968';
wwv_flow_api.g_varchar2_table(58) := '736B4C427632766D452B68424D43746241374B58356472577952542F324A73715A32497666423959346257444E4D46624A52466D4339453734536F53304371756C776A6B43302B356270635631435A384E4D656A34706A7930552B646F44517347796F31';
wwv_flow_api.g_varchar2_table(59) := '687A564A7474496A685137476E427452464E31556172556C48384633786963742B4859303772457A6F5547506C57636A52465272342F6743685A6763335A4C3264386F41414141415355564F524B35435949493D22292021696D706F7274616E743B0A7D';
wwv_flow_api.g_varchar2_table(60) := '0A23746F6173742D636F6E7461696E6572202E746F6173742D7469746C65207B0A2020666F6E742D7765696768743A203730303B0A2020666F6E742D73697A653A20312E3972656D3B0A202070616464696E672D626F74746F6D3A203870783B0A7D0A23';
wwv_flow_api.g_varchar2_table(61) := '746F6173742D636F6E7461696E65722E746F6173742D746F702D63656E746572203E206469762C0A23746F6173742D636F6E7461696E65722E746F6173742D626F74746F6D2D63656E746572203E20646976207B0A202077696474683A2033303070783B';
wwv_flow_api.g_varchar2_table(62) := '0A20206D617267696E2D6C6566743A206175746F3B0A20206D617267696E2D72696768743A206175746F3B0A7D0A23746F6173742D636F6E7461696E65722E746F6173742D746F702D66756C6C2D7769647468203E206469762C0A23746F6173742D636F';
wwv_flow_api.g_varchar2_table(63) := '6E7461696E65722E746F6173742D626F74746F6D2D66756C6C2D7769647468203E20646976207B0A202077696474683A203936253B0A20206D617267696E2D6C6566743A206175746F3B0A20206D617267696E2D72696768743A206175746F3B0A7D0A2E';
wwv_flow_api.g_varchar2_table(64) := '746F617374207B0A20206261636B67726F756E642D636F6C6F723A20233033303330333B0A7D0A2E746F6173742D73756363657373207B0A20206261636B67726F756E642D636F6C6F723A20233342414132433B0A7D0A2E746F6173742D6572726F7220';
wwv_flow_api.g_varchar2_table(65) := '7B0A20206261636B67726F756E642D636F6C6F723A20234634343333363B0A7D0A2E746F6173742D696E666F207B0A20206261636B67726F756E642D636F6C6F723A20233030373664663B0A7D0A2E746F6173742D7761726E696E67207B0A2020626163';
wwv_flow_api.g_varchar2_table(66) := '6B67726F756E642D636F6C6F723A20234638393430363B0A7D0A2E746F6173742D70726F6772657373207B0A2020706F736974696F6E3A206162736F6C7574653B0A20206C6566743A20303B0A2020626F74746F6D3A20303B0A20206865696768743A20';
wwv_flow_api.g_varchar2_table(67) := '3470783B0A20206261636B67726F756E642D636F6C6F723A20233030303030303B0A20206F7061636974793A20302E343B0A20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C';
wwv_flow_api.g_varchar2_table(68) := '706861284F7061636974793D3430293B0A202066696C7465723A20616C706861286F7061636974793D3430293B0A7D0A2F2A526573706F6E736976652044657369676E2A2F0A406D6564696120616C6C20616E6420286D61782D77696474683A20323430';
wwv_flow_api.g_varchar2_table(69) := '707829207B0A202023746F6173742D636F6E7461696E6572203E20646976207B0A2020202070616464696E673A20387078203870782038707820353070783B0A2020202077696474683A203131656D3B0A202020206D61782D77696474683A203131656D';
wwv_flow_api.g_varchar2_table(70) := '3B0A20207D0A202023746F6173742D636F6E7461696E6572203E206469762E72746C207B0A2020202070616464696E673A20387078203530707820387078203870783B0A20207D0A202023746F6173742D636F6E7461696E6572202E746F6173742D636C';
wwv_flow_api.g_varchar2_table(71) := '6F73652D627574746F6E207B0A2020202072696768743A202D302E32656D3B0A20202020746F703A202D302E32656D3B0A20207D0A202023746F6173742D636F6E7461696E6572202E72746C202E746F6173742D636C6F73652D627574746F6E207B0A20';
wwv_flow_api.g_varchar2_table(72) := '2020206C6566743A202D302E32656D3B0A2020202072696768743A20302E32656D3B0A20207D0A7D0A406D6564696120616C6C20616E6420286D696E2D77696474683A2032343170782920616E6420286D61782D77696474683A20343830707829207B0A';
wwv_flow_api.g_varchar2_table(73) := '202023746F6173742D636F6E7461696E6572203E20646976207B0A2020202070616464696E673A20387078203870782038707820353070783B0A2020202077696474683A203138656D3B0A202020206D61782D77696474683A203138656D3B0A20207D0A';
wwv_flow_api.g_varchar2_table(74) := '202023746F6173742D636F6E7461696E6572203E206469762E72746C207B0A2020202070616464696E673A20387078203530707820387078203870783B0A20207D0A202023746F6173742D636F6E7461696E6572202E746F6173742D636C6F73652D6275';
wwv_flow_api.g_varchar2_table(75) := '74746F6E207B0A2020202072696768743A202D302E32656D3B0A20202020746F703A202D302E32656D3B0A20207D0A202023746F6173742D636F6E7461696E6572202E72746C202E746F6173742D636C6F73652D627574746F6E207B0A202020206C6566';
wwv_flow_api.g_varchar2_table(76) := '743A202D302E32656D3B0A2020202072696768743A20302E32656D3B0A20207D0A7D0A406D6564696120616C6C20616E6420286D696E2D77696474683A2034383170782920616E6420286D61782D77696474683A20373638707829207B0A202023746F61';
wwv_flow_api.g_varchar2_table(77) := '73742D636F6E7461696E6572203E20646976207B0A2020202070616464696E673A20313570782031357078203135707820353070783B0A2020202077696474683A203235656D3B0A202020206D61782D77696474683A203235656D3B0A20207D0A202023';
wwv_flow_api.g_varchar2_table(78) := '746F6173742D636F6E7461696E6572203E206469762E72746C207B0A2020202070616464696E673A20313570782035307078203135707820313570783B0A20207D0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13248014311317051)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/toastr.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202A20546F617374720A202A20436F7079726967687420323031322D323031350A202A20417574686F72733A204A6F686E20506170612C2048616E7320466AC3A46C6C656D61726B2C20616E642054696D2046657272656C6C2E0A202A20416C6C';
wwv_flow_api.g_varchar2_table(2) := '205269676874732052657365727665642E0A202A205573652C20726570726F64756374696F6E2C20646973747269627574696F6E2C20616E64206D6F64696669636174696F6E206F66207468697320636F6465206973207375626A65637420746F207468';
wwv_flow_api.g_varchar2_table(3) := '65207465726D7320616E640A202A20636F6E646974696F6E73206F6620746865204D4954206C6963656E73652C20617661696C61626C6520617420687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F6D69742D6C69';
wwv_flow_api.g_varchar2_table(4) := '63656E73652E7068700A202A0A202A204152494120537570706F72743A204772657461204B7261667369670A202A0A202A2050726F6A6563743A2068747470733A2F2F6769746875622E636F6D2F436F6465536576656E2F746F617374720A202A2F0A2F';
wwv_flow_api.g_varchar2_table(5) := '2A20676C6F62616C20646566696E65202A2F0A2866756E6374696F6E2028646566696E6529207B0A20202020646566696E65285B276A7175657279275D2C2066756E6374696F6E20282429207B0A202020202020202072657475726E202866756E637469';
wwv_flow_api.g_varchar2_table(6) := '6F6E202829207B0A2020202020202020202020207661722024636F6E7461696E65723B0A202020202020202020202020766172206C697374656E65723B0A20202020202020202020202076617220746F6173744964203D20303B0A202020202020202020';
wwv_flow_api.g_varchar2_table(7) := '20202076617220746F61737454797065203D207B0A202020202020202020202020202020206572726F723A20276572726F72272C0A20202020202020202020202020202020696E666F3A2027696E666F272C0A2020202020202020202020202020202073';
wwv_flow_api.g_varchar2_table(8) := '7563636573733A202773756363657373272C0A202020202020202020202020202020207761726E696E673A20277761726E696E67270A2020202020202020202020207D3B0A0A20202020202020202020202076617220746F61737472203D207B0A202020';
wwv_flow_api.g_varchar2_table(9) := '20202020202020202020202020636C6561723A20636C6561722C0A2020202020202020202020202020202072656D6F76653A2072656D6F76652C0A202020202020202020202020202020206572726F723A206572726F722C0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(10) := '2020202020676574436F6E7461696E65723A20676574436F6E7461696E65722C0A20202020202020202020202020202020696E666F3A20696E666F2C0A202020202020202020202020202020206F7074696F6E733A207B7D2C0A20202020202020202020';
wwv_flow_api.g_varchar2_table(11) := '2020202020207375627363726962653A207375627363726962652C0A20202020202020202020202020202020737563636573733A20737563636573732C0A2020202020202020202020202020202076657273696F6E3A2027322E312E34272C0A20202020';
wwv_flow_api.g_varchar2_table(12) := '2020202020202020202020207761726E696E673A207761726E696E670A2020202020202020202020207D3B0A0A2020202020202020202020207661722070726576696F7573546F6173743B0A0A20202020202020202020202072657475726E20746F6173';
wwv_flow_api.g_varchar2_table(13) := '74723B0A0A2020202020202020202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A0A20202020202020202020202066756E6374696F6E206572726F72286D6573736167652C207469746C652C206F7074696F6E734F7665727269646529207B0A202020';
wwv_flow_api.g_varchar2_table(14) := '2020202020202020202020202072657475726E206E6F74696679287B0A2020202020202020202020202020202020202020747970653A20746F617374547970652E6572726F722C0A202020202020202020202020202020202020202069636F6E436C6173';
wwv_flow_api.g_varchar2_table(15) := '733A206765744F7074696F6E7328292E69636F6E436C61737365732E6572726F722C0A20202020202020202020202020202020202020206D6573736167653A206D6573736167652C0A20202020202020202020202020202020202020206F7074696F6E73';
wwv_flow_api.g_varchar2_table(16) := '4F766572726964653A206F7074696F6E734F766572726964652C0A20202020202020202020202020202020202020207469746C653A207469746C650A202020202020202020202020202020207D293B0A2020202020202020202020207D0A0A2020202020';
wwv_flow_api.g_varchar2_table(17) := '2020202020202066756E6374696F6E20676574436F6E7461696E6572286F7074696F6E732C2063726561746529207B0A2020202020202020202020202020202069662028216F7074696F6E7329207B206F7074696F6E73203D206765744F7074696F6E73';
wwv_flow_api.g_varchar2_table(18) := '28293B207D0A2020202020202020202020202020202024636F6E7461696E6572203D202428272327202B206F7074696F6E732E636F6E7461696E65724964202B20272E27202B206F7074696F6E732E706F736974696F6E436C617373293B0A2020202020';
wwv_flow_api.g_varchar2_table(19) := '20202020202020202020206966202824636F6E7461696E65722E6C656E67746829207B0A202020202020202020202020202020202020202072657475726E2024636F6E7461696E65723B0A202020202020202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(20) := '2020202020202020206966202863726561746529207B0A202020202020202020202020202020202020202024636F6E7461696E6572203D20637265617465436F6E7461696E6572286F7074696F6E73293B0A202020202020202020202020202020207D0A';
wwv_flow_api.g_varchar2_table(21) := '2020202020202020202020202020202072657475726E2024636F6E7461696E65723B0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E20696E666F286D6573736167652C207469746C652C206F7074696F6E734F';
wwv_flow_api.g_varchar2_table(22) := '7665727269646529207B0A2020202020202020202020202020202072657475726E206E6F74696679287B0A2020202020202020202020202020202020202020747970653A20746F617374547970652E696E666F2C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(23) := '202020202069636F6E436C6173733A206765744F7074696F6E7328292E69636F6E436C61737365732E696E666F2C0A20202020202020202020202020202020202020206D6573736167653A206D6573736167652C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(24) := '20202020206F7074696F6E734F766572726964653A206F7074696F6E734F766572726964652C0A20202020202020202020202020202020202020207469746C653A207469746C650A202020202020202020202020202020207D293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(25) := '202020207D0A0A20202020202020202020202066756E6374696F6E207375627363726962652863616C6C6261636B29207B0A202020202020202020202020202020206C697374656E6572203D2063616C6C6261636B3B0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(26) := '0A0A20202020202020202020202066756E6374696F6E2073756363657373286D6573736167652C207469746C652C206F7074696F6E734F7665727269646529207B0A2020202020202020202020202020202072657475726E206E6F74696679287B0A2020';
wwv_flow_api.g_varchar2_table(27) := '202020202020202020202020202020202020747970653A20746F617374547970652E737563636573732C0A202020202020202020202020202020202020202069636F6E436C6173733A206765744F7074696F6E7328292E69636F6E436C61737365732E73';
wwv_flow_api.g_varchar2_table(28) := '7563636573732C0A20202020202020202020202020202020202020206D6573736167653A206D6573736167652C0A20202020202020202020202020202020202020206F7074696F6E734F766572726964653A206F7074696F6E734F766572726964652C0A';
wwv_flow_api.g_varchar2_table(29) := '20202020202020202020202020202020202020207469746C653A207469746C650A202020202020202020202020202020207D293B0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E207761726E696E67286D6573';
wwv_flow_api.g_varchar2_table(30) := '736167652C207469746C652C206F7074696F6E734F7665727269646529207B0A2020202020202020202020202020202072657475726E206E6F74696679287B0A2020202020202020202020202020202020202020747970653A20746F617374547970652E';
wwv_flow_api.g_varchar2_table(31) := '7761726E696E672C0A202020202020202020202020202020202020202069636F6E436C6173733A206765744F7074696F6E7328292E69636F6E436C61737365732E7761726E696E672C0A20202020202020202020202020202020202020206D6573736167';
wwv_flow_api.g_varchar2_table(32) := '653A206D6573736167652C0A20202020202020202020202020202020202020206F7074696F6E734F766572726964653A206F7074696F6E734F766572726964652C0A20202020202020202020202020202020202020207469746C653A207469746C650A20';
wwv_flow_api.g_varchar2_table(33) := '2020202020202020202020202020207D293B0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E20636C6561722824746F617374456C656D656E742C20636C6561724F7074696F6E7329207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(34) := '2020202020202020766172206F7074696F6E73203D206765744F7074696F6E7328293B0A20202020202020202020202020202020696620282124636F6E7461696E657229207B20676574436F6E7461696E6572286F7074696F6E73293B207D0A20202020';
wwv_flow_api.g_varchar2_table(35) := '2020202020202020202020206966202821636C656172546F6173742824746F617374456C656D656E742C206F7074696F6E732C20636C6561724F7074696F6E732929207B0A2020202020202020202020202020202020202020636C656172436F6E746169';
wwv_flow_api.g_varchar2_table(36) := '6E6572286F7074696F6E73293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E2072656D6
F76652824746F617374456C656D656E7429207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(37) := '2020202020202020766172206F7074696F6E73203D206765744F7074696F6E7328293B0A20202020202020202020202020202020696620282124636F6E7461696E657229207B20676574436F6E7461696E6572286F7074696F6E73293B207D0A20202020';
wwv_flow_api.g_varchar2_table(38) := '2020202020202020202020206966202824746F617374456C656D656E74202626202428273A666F637573272C2024746F617374456C656D656E74292E6C656E677468203D3D3D203029207B0A202020202020202020202020202020202020202072656D6F';
wwv_flow_api.g_varchar2_table(39) := '7665546F6173742824746F617374456C656D656E74293B0A202020202020202020202020202020202020202072657475726E3B0A202020202020202020202020202020207D0A202020202020202020202020202020206966202824636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(40) := '2E6368696C6472656E28292E6C656E67746829207B0A202020202020202020202020202020202020202024636F6E7461696E65722E72656D6F766528293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(41) := '20202020202020202F2F20696E7465726E616C2066756E6374696F6E730A0A20202020202020202020202066756E6374696F6E20636C656172436F6E7461696E657220286F7074696F6E7329207B0A202020202020202020202020202020207661722074';
wwv_flow_api.g_varchar2_table(42) := '6F61737473546F436C656172203D2024636F6E7461696E65722E6368696C6472656E28293B0A20202020202020202020202020202020666F7220287661722069203D20746F61737473546F436C6561722E6C656E677468202D20313B2069203E3D20303B';
wwv_flow_api.g_varchar2_table(43) := '20692D2D29207B0A2020202020202020202020202020202020202020636C656172546F617374282428746F61737473546F436C6561725B695D292C206F7074696F6E73293B0A202020202020202020202020202020207D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(44) := '7D0A0A20202020202020202020202066756E6374696F6E20636C656172546F617374202824746F617374456C656D656E742C206F7074696F6E732C20636C6561724F7074696F6E7329207B0A2020202020202020202020202020202076617220666F7263';
wwv_flow_api.g_varchar2_table(45) := '65203D20636C6561724F7074696F6E7320262620636C6561724F7074696F6E732E666F726365203F20636C6561724F7074696F6E732E666F726365203A2066616C73653B0A202020202020202020202020202020206966202824746F617374456C656D65';
wwv_flow_api.g_varchar2_table(46) := '6E742026262028666F726365207C7C202428273A666F637573272C2024746F617374456C656D656E74292E6C656E677468203D3D3D20302929207B0A202020202020202020202020202020202020202024746F617374456C656D656E745B6F7074696F6E';
wwv_flow_api.g_varchar2_table(47) := '732E686964654D6574686F645D287B0A2020202020202020202020202020202020202020202020206475726174696F6E3A206F7074696F6E732E686964654475726174696F6E2C0A20202020202020202020202020202020202020202020202065617369';
wwv_flow_api.g_varchar2_table(48) := '6E673A206F7074696F6E732E68696465456173696E672C0A202020202020202020202020202020202020202020202020636F6D706C6574653A2066756E6374696F6E202829207B2072656D6F7665546F6173742824746F617374456C656D656E74293B20';
wwv_flow_api.g_varchar2_table(49) := '7D0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020202020202072657475726E20747275653B0A202020202020202020202020202020207D0A2020202020202020202020202020202072657475726E20';
wwv_flow_api.g_varchar2_table(50) := '66616C73653B0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E20637265617465436F6E7461696E6572286F7074696F6E7329207B0A2020202020202020202020202020202024636F6E7461696E6572203D2024';
wwv_flow_api.g_varchar2_table(51) := '28273C6469762F3E27290A20202020202020202020202020202020202020202E6174747228276964272C206F7074696F6E732E636F6E7461696E65724964290A20202020202020202020202020202020202020202E616464436C617373286F7074696F6E';
wwv_flow_api.g_varchar2_table(52) := '732E706F736974696F6E436C617373293B0A0A2020202020202020202020202020202024636F6E7461696E65722E617070656E64546F2824286F7074696F6E732E74617267657429293B0A2020202020202020202020202020202072657475726E202463';
wwv_flow_api.g_varchar2_table(53) := '6F6E7461696E65723B0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E2067657444656661756C74732829207B0A2020202020202020202020202020202072657475726E207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '20202020202020746170546F4469736D6973733A20747275652C0A2020202020202020202020202020202020202020746F617374436C6173733A2027746F617374272C0A2020202020202020202020202020202020202020636F6E7461696E657249643A';
wwv_flow_api.g_varchar2_table(55) := '2027746F6173742D636F6E7461696E6572272C0A202020202020202020202020202020202020202064656275673A2066616C73652C0A0A202020202020202020202020202020202020202073686F774D6574686F643A202766616465496E272C202F2F66';
wwv_flow_api.g_varchar2_table(56) := '616465496E2C20736C696465446F776E2C20616E642073686F7720617265206275696C7420696E746F206A51756572790A202020202020202020202020202020202020202073686F774475726174696F6E3A203330302C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(57) := '202020202020202073686F77456173696E673A20277377696E67272C202F2F7377696E6720616E64206C696E65617220617265206275696C7420696E746F206A51756572790A20202020202020202020202020202020202020206F6E53686F776E3A2075';
wwv_flow_api.g_varchar2_table(58) := '6E646566696E65642C0A2020202020202020202020202020202020202020686964654D6574686F643A2027666164654F7574272C0A2020202020202020202020202020202020202020686964654475726174696F6E3A20313030302C0A20202020202020';
wwv_flow_api.g_varchar2_table(59) := '2020202020202020202020202068696465456173696E673A20277377696E67272C0A20202020202020202020202020202020202020206F6E48696464656E3A20756E646566696E65642C0A2020202020202020202020202020202020202020636C6F7365';
wwv_flow_api.g_varchar2_table(60) := '4D6574686F643A2066616C73652C0A2020202020202020202020202020202020202020636C6F73654475726174696F6E3A2066616C73652C0A2020202020202020202020202020202020202020636C6F7365456173696E673A2066616C73652C0A202020';
wwv_flow_api.g_varchar2_table(61) := '2020202020202020202020202020202020636C6F73654F6E486F7665723A20747275652C0A0A2020202020202020202020202020202020202020657874656E64656454696D654F75743A20313030302C0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '2069636F6E436C61737365733A207B0A2020202020202020202020202020202020202020202020206572726F723A2027746F6173742D6572726F72272C0A202020202020202020202020202020202020202020202020696E666F3A2027746F6173742D69';
wwv_flow_api.g_varchar2_table(63) := '6E666F272C0A202020202020202020202020202020202020202020202020737563636573733A2027746F6173742D73756363657373272C0A2020202020202020202020202020202020202020202020207761726E696E673A2027746F6173742D7761726E';
wwv_flow_api.g_varchar2_table(64) := '696E67270A20202020202020202020202020202020202020207D2C0A202020202020202020202020202020202020202069636F6E436C6173733A2027746F6173742D696E666F272C0A2020202020202020202020202020202020202020706F736974696F';
wwv_flow_api.g_varchar2_table(65) := '6E436C6173733A2027746F6173742D746F702D7269676874272C0A202020202020202020202020202020202020202074696D654F75743A20353030302C202F2F205365742074696D654F757420616E6420657874656E64656454696D654F757420746F20';
wwv_flow_api.g_varchar2_table(66) := '3020746F206D616B6520697420737469636B790A20202020202020202020202020202020202020207469746C65436C6173733A2027746F6173742D7469746C65272C0A20202020202020202020202020202020202020206D657373616765436C6173733A';
wwv_flow_api.g_varchar2_table(67) := '2027746F6173742D6D657373616765272C0A202020202020202020202020202020202020202065736361706548746D6C3A2066616C73652C0A20202020202020202020202020202020202020207461726765743A2027626F6479272C0A20202020202020';
wwv_flow_api.g_varchar2_table(68) := '20202020202020202020202020636C6F736548746D6C3A20273C627574746F6E20747970653D22627574746F6E223E2674696D65733B3C2F627574746F6E3E272C0A2020202020202020202020202020202020202020636C6F7365436C6173733A202774';
wwv_flow_api.g_varchar2_table(69) := '6F6173742D636C6F73652D627574746F6E272C0A20202020202020202020202020202020202020206E65776573744F6E546F703A20747275652C0A202020202020202020202020202020202020202070726576656E744475706C6963617465733A206661';
wwv_flow_api.g_varchar2_table(70) := '6C73652C0A202020202020202020202020202020202020202070726F67726573734261723A2066616C73652C0A202020202020202020202020202020202020202070726F6772657373436C6173733A2027746F6173742D70726F6772657373272C0A2020';
wwv_flow_api.g_varchar2_table(71) := '20202020202020202020202020202020202072746C3A2066616C73650A202020202020202020202020202020207D3B0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E207075626C697368286172677329207B0A';
wwv_flow_api.g_varchar2_table(72) := '2020202020202020202020202020202069662028216C697374656E657229207B2072657475726E3B207D0A202020202020202020202020202020206C697374656E65722861726773293B0A2020202020202020202020207D0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(73) := '202066756E6374696F6E206E6F74696679286D617029207B0A20202020202020202020202020202020766172206F7074696F6E73203D206765744F7074696F6E7328293B0A202020202020202020202020202020207661722069636F6E436C617373203D';
wwv_flow_api.g_varchar2_table(74) := '206D61702E69636F6E436C617373207C7C206F7074696F6E732E69636F6E436C6173733B0A0A2020202020202020202020202020202069662028747970656F6620286D61702E6F7074696F6E734F766572726964652920213D3D2027756E646566696E65';
wwv_flow_api.g_varchar2_table(75) := '642729207B0A20202020202020202020202020202020202020206F7074696F6E73203D20242E657874656E64286F7074696F6E732C206D61702E6F7074696F6E734F76657272696465293B0A202020202020202020202020202020202020202069636F6E';
wwv_flow_api.g_varchar2_table(76) := '436C617373203D206D61702E6F7074696F6E734F766572726964652E69636F6E436C617373207C7C2069636F6E436C6173733B0A202020202020202020202020202020207D0A0A202020202020202020202020202020206966202873686F756C64457869';
wwv_flow_api.g_varchar2_table(77) := '74286F7074696F6E732C206D61702929207B2072657475726E3B207D0A0A20202020202020202020202020202020746F61737449642B2B3B0A0A2020202020202020202020202020202024636F6E7461696E6572203D20676574436F6E7461696E657228';
wwv_flow_api.g_varchar2_table(78) := '6F7074696F6E732C2074727565293B0A0A2020202020202020202020202020202076617220696E74657276616C4964203D206E756C6C3B0A202020202020202020202020202020207661722024746F617374456C656D656E74203D202428273C6469762F';
wwv_flow_api.g_varchar2_table(79) := '3E27293B0A2020202020202020202020202020202076617220247469746C65456C656D656E74203D202428273C6469762F3E27293B0A2020202020202020202020202020202076617220246D657373616765456C656D656E74203D202428273C6469762F';
wwv_flow_api.g_varchar2_table(80) := '3E27293B0A20202020202020202020202020202020766172202470726F6772657373456C656D656E74203D202428273C6469762F3E27293B0A202020202020202020202020202020207661722024636C6F7365456C656D656E74203D2024286F7074696F';
wwv_flow_api.g_varchar2_table(81) := '6E732E636C6F736548746D6C293B0A202020202020202020202020202020207661722070726F6772657373426172203D207B0A2020202020202020202020202020202020202020696E74657276616C49643A206E756C6C2C0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(82) := '202020202020202020686964654574613A206E756C6C2C0A20202020202020202020202020202020202020206D61784869646554696D653A206E756C6C0A202020202020202020202020202020207D3B0A20202020202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(83) := '20726573706F6E7365203D207B0A2020202020202020202020202020202020202020746F61737449643A20746F61737449642C0A202020202020202020202020202020202020202073746174653A202776697369626C65272C0A20202020202020202020';
wwv_flow_api.g_varchar2_table(84) := '20202020202020202020737461727454696D653A206E6577204461746528292C0A20202020202020202020202020202020202020206F7074696F6E733A206F7074696F6E732C0A20202020202020202020202020202020202020206D61703A206D61700A';
wwv_flow_api.g_varchar2_table(85) := '202020202020202020202020202020207D3B0A0A20202020202020202020202020202020706572736F6E616C697A65546F61737428293B0A0A20202020202020202020202020202020646973706C6179546F61737428293B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(86) := '20202020202068616E646C654576656E747328293B0A0A202020202020202020202020202020207075626C69736828726573706F6E7365293B0A0A20202020202020202020202020202020696620286F7074696F6E732E646562756720262620636F6E73';
wwv_flow_api.g_varchar2_table(87) := '6F6C6529207B0A2020202020202020202020202020202020202020636F6E736F6C652E6C6F6728726573706F6E7365293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202072657475726E2024746F617374456C';
wwv_flow_api.g_varchar2_table(88) := '656D656E743B0A0A2020202020202020202020202020202066756E6374696F6E2065736361706548746D6C28736F7572636529207B0A202020202020202020202020202020202020202069662028736F75726365203D3D206E756C6C29207B0A20202020';
wwv_flow_api.g_varchar2_table(89) := '2020202020202020202020202020202020202020736F75726365203D2027273B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020202020202020202072657475726E20736F757263650A20202020202020202020';
wwv_flow_api.g_varchar2_table(90) := '20202020202020202020202020202E7265706C616365282F262F672C202726616D703B27290A2020202020202020202020202020202020202020202020202E7265706C616365282F222F672C20272671756F743B27290A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(91) := '20202020202020202020202E7265706C616365282F272F672C2027262333393B27290A2020202020202020202020202020202020202020202020202E7265706C616365282F3C2F672C2027266C743B27290A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(92) := '2020202020202E7265706C616365282F3E2F672C20272667743B27293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E20706572736F6E616C697A65546F6173742829207B0A2020202020';
wwv_flow_api.g_varchar2_table(93) := '20202020202020202020202020202073657449636F6E28293B0A20202020202020202020202020202020202020207365745469746C6528293B0A20202020202020202020202020202020202020207365744D65737361676528293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(94) := '202020202020202020202020736574436C6F7365427574746F6E28293B0A202020202020202020202020202020202020202073657450726F677265737342617228293B0A202020202020202020202020202020202020202073657452544C28293B0A2020';
wwv_flow_api.g_varchar2_table(95) := '20202020202020202020202020202020202073657453657175656E636528293B0A20202020202020202020202020202020202020207365744172696128293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066';
wwv_flow_api.g_varchar2_table(96) := '756E6374696F6E20736574417269612829207B0A2020202020202020202020202020202020202020766172206172696156616C7565203D2027273B0A202020202020202020202020202020202020202073776974636820286D61702E69636F6E436C6173';
wwv_flow_api.g_varchar2_table(97) := '7329207B0A202020202020202020202020202020202020202020202020636173652027746F6173742D73756363657373273A0A202020202020202020202020202020202020202020202020636173652027746F6173742D696E666F273A0A202020202020';
wwv_flow_api.g_varchar2_table(98) := '202020202020202020202020202020202020202020206172696156616C7565203D202027706F6C697465273B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(99) := '2020202064656661756C743A0A202020202020202020202020202020202020202020202020202020206172696156616C7565203D2027617373657274697665273B0A20202020202020202020202020202020202020207D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(100) := '202020202020202024746F617374456C656D656E742E617474722827617269612D6C697665272C206172696156616C7565293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2068616E64';
wwv_flow_api.g_varchar2_table(101) := '6C654576656E74732829207B0A2020202020202020202020202020202020202020696620286F7074696F6E732E636C6F73654F6E486F76657229207B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E68';
wwv_flow_api.g_varchar2_table(102) := '6F76657228737469636B41726F756E642C2064656C6179656448696465546F617374293B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020202020202020202069662028216F7074696F6E732E6F6E636C69636B';
wwv_flow_api.g_varchar2_table(103) := '202626206F7074696F6E732E746170546F4469736D69737329207B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E636C69636B2868696465546F617374293B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(104) := '202020207D0A0A2020202020202020202020202020202020202020696620286F7074696F6E732E636C6F7365427574746F6E2026262024636C6F7365456C656D656E7429207B0A20202020202020202020202020202020202020202020202024636C6F73';
wwv_flow_api.g_varchar2_table(105) := '65456C656D656E742E636C69636B2866756E6374696F6E20286576656E7429207B0A20202020202020202020202020202020202020202020202020202020696620286576656E742E73746F7050726F7061676174696F6E29207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(106) := '20202020202020202020202020202020202020202020206576656E742E73746F7050726F7061676174696F6E28293B0A202020202020202020202020202020202020202020202020202020207D20656C736520696620286576656E742E63616E63656C42';
wwv_flow_api.g_varchar2_table(107) := '7562626C6520213D3D20756E646566696E6564202626206576656E742E63616E63656C427562626C6520213D3D207472756529207B0A20202020202020202020202020202020202020202020202020202020202020206576656E742E63616E63656C4275';
wwv_flow_api.g_varchar2_table(108) := '62626C65203D20747275653B0A202020202020202020202020202020202020202020202020202020207D0A0A20202020202020202020202020202020202020202020202020202020696620286F7074696F6E732E6F6E436C6F7365436C69636B29207B0A';
wwv_flow_api.g_varchar2_table(109) := '20202020202020202020202020202020202020202020202020202020202020206F7074696F6E732E6F6E436C6F7365436C69636B286576656E74293B0A202020202020202020202020202020202020202020202020202020207D0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(110) := '202020202020202020202020202020202020202068696465546F6173742874727565293B0A2020202020202020202020202020202020202020202020207D293B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(111) := '2020202020202020696620286F7074696F6E732E6F6E636C69636B29207B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E636C69636B2866756E6374696F6E20286576656E7429207B0A202020202020';
wwv_flow_api.g_varchar2_table(112) := '202020202020202020202020202020202020202020206F7074696F6E732E6F6E636C69636B286576656E74293B0A2020202020202020202020202020202020202020202020202020202068696465546F61737428293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(113) := '20202020202020202020207D293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E20646973706C6179546F6173742829207B0A2020';
wwv_flow_api.g_varchar2_table(114) := '20202020202020202020202020202020202024746F617374456C656D656E742E6869646528293B0A0A202020202020202020202020202020202020202024746F617374456C656D656E745B6F7074696F6E732E73686F774D6574686F645D280A20202020';
wwv_flow_api.g_varchar2_table(115) := '20202020202020202020202020202020202020207B6475726174696F6E3A206F7074696F6E732E73686F774475726174696F6E2C20656173696E673A206F7074696F6E732E73686F77456173696E672C20636F6D706C6574653A206F7074696F6E732E6F';
wwv_flow_api.g_varchar2_table(116) := '6E53686F776E7D0A2020202020202020202020202020202020202020293B0A0A2020202020202020202020202020202020202020696620286F7074696F6E732E74696D654F7574203E203029207B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(117) := '202020696E74657276616C4964203D2073657454696D656F75742868696465546F6173742C206F7074696F6E732E74696D654F7574293B0A20202020202020202020202020202020202020202020202070726F67726573734261722E6D61784869646554';
wwv_flow_api.g_varchar2_table(118) := '696D65203D207061727365466C6F6174286F7074696F6E732E74696D654F7574293B0A20202020202020202020202020202020202020202020202070726F67726573734261722E68696465457461203D206E6577204461746528292E67657454696D6528';
wwv_flow_api.g_varchar2_table(119) := '29202B2070726F67726573734261722E6D61784869646554696D653B0A202020202020202020202020202020202020202020202020696620286F7074696F6E732E70726F677265737342617229207B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(120) := '202020202020202070726F67726573734261722E696E74657276616C4964203D20736574496E74657276616C2875706461746550726F67726573732C203130293B0A2020202020202020202020202020202020202020202020207D0A2020202020202020';
wwv_flow_api.g_varchar2_table(121) := '2020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2073657449636F6E2829207B0A2020202020202020202020202020202020202020696620286D61702E6963';
wwv_flow_api.g_varchar2_table(122) := '6F6E436C61737329207B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E616464436C617373286F7074696F6E732E746F617374436C617373292E616464436C6173732869636F6E436C617373293B0A20';
wwv_flow_api.g_varchar2_table(123) := '202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2073657453657175656E63652829207B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(124) := '20696620286F7074696F6E732E6E65776573744F6E546F7029207B0A20202020202020202020202020202020202020202020202024636F6E7461696E65722E70726570656E642824746F617374456C656D656E74293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(125) := '202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020202024636F6E7461696E65722E617070656E642824746F617374456C656D656E74293B0A20202020202020202020202020202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(126) := '2020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E207365745469746C652829207B0A2020202020202020202020202020202020202020696620286D61702E7469746C6529207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(127) := '202020202020202020202020202076617220737566666978203D206D61702E7469746C653B0A202020202020202020202020202020202020202020202020696620286F7074696F6E732E65736361706548746D6C29207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(128) := '20202020202020202020202020202020737566666978203D2065736361706548746D6C286D61702E7469746C65293B0A2020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202474';
wwv_flow_api.g_varchar2_table(129) := '69746C65456C656D656E742E617070656E6428737566666978292E616464436C617373286F7074696F6E732E7469746C65436C617373293B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E617070656E';
wwv_flow_api.g_varchar2_table(130) := '6428247469746C65456C656D656E74293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E207365744D6573736167652829207B0A20';
wwv_flow_api.g_varchar2_table(131) := '20202020202020202020202020202020202020696620286D61702E6D65737361676529207B0A20202020202020202020202020202020202020202020202076617220737566666978203D206D61702E6D6573736167653B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(132) := '202020202020202020202020696620286F7074696F6E732E65736361706548746D6C29207B0A20202020202020202020202020202020202020202020202020202020737566666978203D2065736361706548746D6C286D61702E6D657373616765293B0A';
wwv_flow_api.g_varchar2_table(133) := '2020202020202020202020202020202020202020202020207D0A202020202020202020202020202020202020202020202020246D657373616765456C656D656E742E617070656E6428737566666978292E616464436C617373286F7074696F6E732E6D65';
wwv_flow_api.g_varchar2_table(134) := '7373616765436C617373293B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E617070656E6428246D657373616765456C656D656E74293B0A20202020202020202020202020202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(135) := '20202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E20736574436C6F7365427574746F6E2829207B0A2020202020202020202020202020202020202020696620286F7074696F6E732E636C6F73654275';
wwv_flow_api.g_varchar2_table(136) := '74746F6E29207B0A20202020202020202020202020202020202020202020202024636C6F7365456C656D656E742E616464436C617373286F7074696F6E732E636C6F7365436C617373292E617474722827726F6C65272C2027627574746F6E27293B0A20';
wwv_flow_api.g_varchar2_table(137) := '202020202020202020202020202020202020202020202024746F617374456C656D656E742E70726570656E642824636C6F7365456C656D656E74293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(138) := '0A0A2020202020202020202020202020202066756E6374696F6E2073657450726F67726573734261722829207B0A2020202020202020202020202020202020202020696620286F7074696F6E732E70726F677265737342617229207B0A20202020202020';
wwv_flow_api.g_varchar2_table(139) := '20202020202020202020202020202020202470726F6772657373456C656D656E742E616464436C617373286F7074696F6E732E70726F6772657373436C617373293B0A20202020202020202020202020202020202020202020202024746F617374456C65';
wwv_flow_api.g_varchar2_table(140) := '6D656E742E70726570656E64282470726F6772657373456C656D656E74293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E207365';
wwv_flow_api.g_varchar2_table(141) := '7452544C2829207B0A2020202020202020202020202020202020202020696620286F7074696F6E732E72746C29207B0A20202020202020202020202020202020202020202020202024746F617374456C656D656E742E616464436C617373282772746C27';
wwv_flow_api.g_varchar2_table(142) := '293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2073686F756C6445786974286F7074696F6E732C206D617029207B0A20202020';
wwv_flow_api.g_varchar2_table(143) := '20202020202020202020202020202020696620286F7074696F6E732E70726576656E744475706C69636174657329207B0A202020202020202020202020202020202020202020202020696620286D61702E6D657373616765203D3D3D2070726576696F75';
wwv_flow_api.g_varchar2_table(144) := '73546F61737429207B0A2020202020202020202020202020202020202020202020202020202072657475726E20747275653B0A2020202020202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(145) := '20202020202020202020202070726576696F7573546F617374203D206D61702E6D6573736167653B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(146) := '20202020202020202072657475726E2066616C73653B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2068696465546F617374286F7665727269646529207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(147) := '202020202020202020766172206D6574686F64203D206F76657272696465202626206F7074696F6E732E636C6F73654D6574686F6420213D3D2066616C7365203F206F7074696F6E732E636C6F73654D6574686F64203A206F7074696F6E732E68696465';
wwv_flow_api.g_varchar2_table(148) := '4D6574686F643B0A2020202020202020202020202020202020202020766172206475726174696F6E203D206F76657272696465202626206F7074696F6E732E636C6F73654475726174696F6E20213D3D2066616C7365203F0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(149) := '202020202020202020202020206F7074696F6E732E636C6F73654475726174696F6E203A206F7074696F6E732E686964654475726174696F6E3B0A202020202020202020202020202020202020202076617220656173696E67203D206F76657272696465';
wwv_flow_api.g_varchar2_table(150) := '202626206F7074696F6E732E636C6F7365456173696E6720213D3D2066616C7365203F206F7074696F6E732E636C6F7365456173696E67203A206F7074696F6E732E68696465456173696E673B0A20202020202020202020202020202020202020206966';
wwv_flow_api.g_varchar2_table(151) := '20282428273A666F637573272C2024746F617374456C656D656E74292E6C656E67746820262620216F7665727269646529207B0A20202020202020202020202020202020202020202020202072657475726E3B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(152) := '202020207D0A2020202020202020202020202020202020202020636C65617254696D656F75742870726F67726573734261722E696E74657276616C4964293B0A202020202020202020202020202020202020202072657475726E2024746F617374456C65';
wwv_flow_api.g_varchar2_table(153) := '6D656E745B6D6574686F645D287B0A2020202020202020202020202020202020202020202020206475726174696F6E3A206475726174696F6E2C0A202020202020202020202020202020202020202020202020656173696E673A20656173696E672C0A20';
wwv_flow_api.g_varchar2_table(154) := '2020202020202020202020202020202020202020202020636F6D706C6574653A2066756E6374696F6E202829207B0A2020202020202020202020202020202020202020202020202020202072656D6F7665546F6173742824746F617374456C656D656E74';
wwv_flow_api.g_varchar2_table(155) := '293B0A20202020202020202020202020202020202020202020202020202020636C65617254696D656F757428696E74657276616C4964293B0A20202020202020202020202020202020202020202020202020202020696620286F7074696F6E732E6F6E48';
wwv_flow_api.g_varchar2_table(156) := '696464656E20262620726573706F6E73652E737461746520213D3D202768696464656E2729207B0A20202020202020202020202020202020202020202020202020202020202020206F7074696F6E732E6F6E48696464656E28293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(157) := '20202020202020202020202020202020202020207D0A20202020202020202020202020202020202020202020202020202020726573706F6E73652E7374617465203D202768696464656E273B0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(158) := '2020202020726573706F6E73652E656E6454696D65203D206E6577204461746528293B0A202020202020202020202020202020202020202020202020202020207075626C69736828726573706F6E7365293B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(159) := '202020202020207D0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2064656C6179656448696465546F6173742829207B0A2020';
wwv_flow_api.g_varchar2_table(160) := '202020202020202020202020202020202020696620286F7074696F6E732E74696D654F7574203E2030207C7C206F7074696F6E732E657874656E64656454696D654F7574203E203029207B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(161) := '696E74657276616C4964203D2073657454696D656F75742868696465546F6173742C206F7074696F6E732E657874656E64656454696D654F7574293B0A20202020202020202020202020202020202020202020202070726F67726573734261722E6D6178';
wwv_flow_api.g_varchar2_table(162) := '4869646554696D65203D207061727365466C6F6174286F7074696F6E732E657874656E64656454696D654F7574293B0A20202020202020202020202020202020202020202020202070726F67726573734261722E68696465457461203D206E6577204461';
wwv_flow_api.g_varchar2_table(163) := '746528292E67657454696D652829202B2070726F67726573734261722E6D61784869646554696D653B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202066';
wwv_flow_api.g_varchar2_table(164) := '756E6374696F6E20737469636B41726F756E642829207B0A2020202020202020202020202020202020202020636C65617254696D656F757428696E74657276616C4964293B0A202020202020202020202020202020202020202070726F67726573734261';
wwv_flow_api.g_varchar2_table(165) := '722E68696465457461203D20303B0A202020202020202020202020202020202020202024746F617374456C656D656E742E73746F7028747275652C2074727565295B6F7074696F6E732E73686F774D6574686F645D280A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(166) := '20202020202020202020207B6475726174696F6E3A206F7074696F6E732E73686F774475726174696F6E2C20656173696E673A206F7074696F6E732E73686F77456173696E677D0A2020202020202020202020202020202020202020293B0A2020202020';
wwv_flow_api.g_varchar2_table(167) := '20202020202020202020207D0A0A2020202020202020202020202020202066756E6374696F6E2075706461746550726F67726573732829207B0A20202020202020202020202020202020202020207661722070657263656E74616765203D20282870726F';
wwv_flow_api.g_varchar2_table(168) := '67726573734261722E68696465457461202D20286E6577204461746528292E67657454696D6528292929202F2070726F67726573734261722E6D61784869646554696D6529202A203130303B0A2020202020202020202020202020202020202020247072';
wwv_flow_api.g_varchar2_table(169) := '6F6772657373456C656D
656E742E77696474682870657263656E74616765202B20272527293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020202066756E6374696F6E206765744F707469';
wwv_flow_api.g_varchar2_table(170) := '6F6E732829207B0A2020202020202020202020202020202072657475726E20242E657874656E64287B7D2C2067657444656661756C747328292C20746F617374722E6F7074696F6E73293B0A2020202020202020202020207D0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(171) := '20202066756E6374696F6E2072656D6F7665546F6173742824746F617374456C656D656E7429207B0A20202020202020202020202020202020696620282124636F6E7461696E657229207B2024636F6E7461696E6572203D20676574436F6E7461696E65';
wwv_flow_api.g_varchar2_table(172) := '7228293B207D0A202020202020202020202020202020206966202824746F617374456C656D656E742E697328273A76697369626C65272929207B0A202020202020202020202020202020202020202072657475726E3B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(173) := '2020207D0A2020202020202020202020202020202024746F617374456C656D656E742E72656D6F766528293B0A2020202020202020202020202020202024746F617374456C656D656E74203D206E756C6C3B0A2020202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(174) := '66202824636F6E7461696E65722E6368696C6472656E28292E6C656E677468203D3D3D203029207B0A202020202020202020202020202020202020202024636F6E7461696E65722E72656D6F766528293B0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(175) := '202070726576696F7573546F617374203D20756E646566696E65643B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020207D2928293B0A202020207D293B0A7D28747970656F6620646566696E6520';
wwv_flow_api.g_varchar2_table(176) := '3D3D3D202766756E6374696F6E2720262620646566696E652E616D64203F20646566696E65203A2066756E6374696F6E2028646570732C20666163746F727929207B0A2020202069662028747970656F66206D6F64756C6520213D3D2027756E64656669';
wwv_flow_api.g_varchar2_table(177) := '6E656427202626206D6F64756C652E6578706F72747329207B202F2F4E6F64650A20202020202020206D6F64756C652E6578706F727473203D20666163746F7279287265717569726528276A71756572792729293B0A202020207D20656C7365207B0A20';
wwv_flow_api.g_varchar2_table(178) := '2020202020202077696E646F772E746F61737472203D20666163746F72792877696E646F772E6A5175657279293B0A202020207D0A7D29293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13249463283321415)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/toastr.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F204D69782D696E730A2E626F72646572526164697573284072616469757329207B0A092D6D6F7A2D626F726465722D7261646975733A20407261646975733B0A092D7765626B69742D626F726465722D7261646975733A20407261646975733B0A09';
wwv_flow_api.g_varchar2_table(2) := '626F726465722D7261646975733A20407261646975733B0A7D0A0A2E626F78536861646F772840626F78536861646F7729207B0A092D6D6F7A2D626F782D736861646F773A2040626F78536861646F773B0A092D7765626B69742D626F782D736861646F';
wwv_flow_api.g_varchar2_table(3) := '773A2040626F78536861646F773B0A09626F782D736861646F773A2040626F78536861646F773B0A7D0A0A2E6F70616369747928406F70616369747929207B0A09406F70616369747950657263656E743A2028406F706163697479202A20313030293B0A';
wwv_flow_api.g_varchar2_table(4) := '096F7061636974793A20406F7061636974793B0A092D6D732D66696C7465723A207E2270726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D407B6F70616369747950657263656E747D';
wwv_flow_api.g_varchar2_table(5) := '29223B0A0966696C7465723A207E22616C706861286F7061636974793D407B6F70616369747950657263656E747D29223B0A7D0A0A2E776F7264577261702840776F7264577261703A20627265616B2D776F726429207B0A092D6D732D776F72642D7772';
wwv_flow_api.g_varchar2_table(6) := '61703A2040776F7264577261703B0A09776F72642D777261703A2040776F7264577261703B0A7D0A0A2F2F205661726961626C65730A40626C61636B3A20233030303030303B0A40677265793A20233939393939393B0A406C696768742D677265793A20';
wwv_flow_api.g_varchar2_table(7) := '234343434343433B0A4077686974653A20234646464646463B0A406E6561722D626C61636B3A20233033303330333B0A40677265656E3A20233342414132433B0A407265643A20234634343333363B0A40626C75653A20233030373664663B0A406F7261';
wwv_flow_api.g_varchar2_table(8) := '6E67653A20234638393430363B0A4064656661756C742D636F6E7461696E65722D6F7061636974793A202E383B0A0A2F2F205374796C65730A2E746F6173742D7469746C65207B0A09666F6E742D7765696768743A20626F6C643B0A7D0A0A2E746F6173';
wwv_flow_api.g_varchar2_table(9) := '742D6D657373616765207B0A092E776F72645772617028293B0A0A09612C0A096C6162656C207B0A0909636F6C6F723A204077686974653B0A097D0A0A0909613A686F766572207B0A090909636F6C6F723A20406C696768742D677265793B0A09090974';
wwv_flow_api.g_varchar2_table(10) := '6578742D6465636F726174696F6E3A206E6F6E653B0A09097D0A7D0A0A2E746F6173742D636C6F73652D627574746F6E207B0A09706F736974696F6E3A2072656C61746976653B0A0972696768743A202D302E33656D3B0A09746F703A202D302E33656D';
wwv_flow_api.g_varchar2_table(11) := '3B0A09666C6F61743A2072696768743B0A09666F6E742D73697A653A20323070783B0A09666F6E742D7765696768743A20626F6C643B0A09636F6C6F723A204077686974653B0A092D7765626B69742D746578742D736861646F773A2030203170782030';
wwv_flow_api.g_varchar2_table(12) := '2072676261283235352C3235352C3235352C31293B0A09746578742D736861646F773A20302031707820302072676261283235352C3235352C3235352C31293B0A092E6F70616369747928302E39293B0A096C696E652D6865696768743A20313B0A0A09';
wwv_flow_api.g_varchar2_table(13) := '263A686F7665722C0A09263A666F637573207B0A0909636F6C6F723A2040626C61636B3B0A0909746578742D6465636F726174696F6E3A206E6F6E653B0A0909637572736F723A20706F696E7465723B0A09092E6F70616369747928302E34293B0A097D';
wwv_flow_api.g_varchar2_table(14) := '0A7D0A0A2E72746C202E746F6173742D636C6F73652D627574746F6E207B0A096C6566743A202D302E33656D3B0A09666C6F61743A206C6566743B0A0972696768743A20302E33656D3B0A7D0A0A2F2A4164646974696F6E616C2070726F706572746965';
wwv_flow_api.g_varchar2_table(15) := '7320666F7220627574746F6E2076657273696F6E0A20694F532072657175697265732074686520627574746F6E20656C656D656E7420696E7374656164206F6620616E20616E63686F72207461672E0A20496620796F752077616E742074686520616E63';
wwv_flow_api.g_varchar2_table(16) := '686F722076657273696F6E2C2069742072657175697265732060687265663D222322602E2A2F0A627574746F6E2E746F6173742D636C6F73652D627574746F6E207B0A0970616464696E673A20303B0A09637572736F723A20706F696E7465723B0A0962';
wwv_flow_api.g_varchar2_table(17) := '61636B67726F756E643A207472616E73706172656E743B0A09626F726465723A20303B0A092D7765626B69742D617070656172616E63653A206E6F6E653B0A7D0A0A2F2F23656E64726567696F6E0A0A2E746F6173742D746F702D63656E746572207B0A';
wwv_flow_api.g_varchar2_table(18) := '09746F703A20303B0A0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A2E746F6173742D626F74746F6D2D63656E746572207B0A09626F74746F6D3A20303B0A0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A';
wwv_flow_api.g_varchar2_table(19) := '2E746F6173742D746F702D66756C6C2D7769647468207B0A09746F703A20303B0A0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A2E746F6173742D626F74746F6D2D66756C6C2D7769647468207B0A09626F74746F6D3A20303B0A';
wwv_flow_api.g_varchar2_table(20) := '0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A2E746F6173742D746F702D6C656674207B0A09746F703A20313270783B0A096C6566743A20313270783B0A7D0A0A2E746F6173742D746F702D7269676874207B0A09746F703A2031';
wwv_flow_api.g_varchar2_table(21) := '3270783B0A0972696768743A20313270783B0A7D0A0A2E746F6173742D626F74746F6D2D7269676874207B0A0972696768743A20313270783B0A09626F74746F6D3A20313270783B0A7D0A0A2E746F6173742D626F74746F6D2D6C656674207B0A09626F';
wwv_flow_api.g_varchar2_table(22) := '74746F6D3A20313270783B0A096C6566743A20313270783B0A7D0A0A23746F6173742D636F6E7461696E6572207B0A09706F736974696F6E3A2066697865643B0A097A2D696E6465783A203939393939393B0A092F2F2054686520636F6E7461696E6572';
wwv_flow_api.g_varchar2_table(23) := '2073686F756C64206E6F7420626520636C69636B61626C652E0A09706F696E7465722D6576656E74733A206E6F6E653B0A092A207B0A09092D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0A09092D7765626B69742D626F782D73';
wwv_flow_api.g_varchar2_table(24) := '697A696E673A20626F726465722D626F783B0A0909626F782D73697A696E673A20626F726465722D626F783B0A097D0A0A093E20646976207B0A0909706F736974696F6E3A2072656C61746976653B0A09092F2F2054686520746F61737420697473656C';
wwv_flow_api.g_varchar2_table(25) := '662073686F756C6420626520636C69636B61626C652E0A0909706F696E7465722D6576656E74733A206175746F3B0A09096F766572666C6F773A2068696464656E3B0A09096D617267696E3A20302030203670783B0A090970616464696E673A20313570';
wwv_flow_api.g_varchar2_table(26) := '782031357078203135707820353070783B0A090977696474683A2034353070783B0A09092E626F7264657252616469757328337078203370782033707820337078293B0A09096261636B67726F756E642D706F736974696F6E3A20313570782063656E74';
wwv_flow_api.g_varchar2_table(27) := '65723B0A09096261636B67726F756E642D7265706561743A206E6F2D7265706561743B0A09092E626F78536861646F77283020302031327078204067726579293B0A0909636F6C6F723A204077686974653B0A09092E6F70616369747928406465666175';
wwv_flow_api.g_varchar2_table(28) := '6C742D636F6E7461696E65722D6F706163697479293B0A0909666F6E742D73697A653A20312E3672656D2021696D706F7274616E743B0A097D0A0A093E206469762E72746C207B0A0909646972656374696F6E3A2072746C3B0A090970616464696E673A';
wwv_flow_api.g_varchar2_table(29) := '20313570782035307078203135707820313570783B0A09096261636B67726F756E642D706F736974696F6E3A20726967687420313570782063656E7465723B0A097D0A0A093E206469763A686F766572207B0A09092E626F78536861646F772830203020';
wwv_flow_api.g_varchar2_table(30) := '313270782040626C61636B293B0A09092E6F7061636974792831293B0A0909637572736F723A20706F696E7465723B0A097D0A0A093E202E746F6173742D696E666F207B0A09096261636B67726F756E642D696D6167653A2075726C2822646174613A69';
wwv_flow_api.g_varchar2_table(31) := '6D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A77763859515541';
wwv_flow_api.g_varchar2_table(32) := '4141414A6345685A6377414144734D4141413744416364767147514141414777535552425645684C745A613953674E42454D63397355787852636F554B537A535749685870464D68685957466861426734795059695743585A78424C4552734C52533345';
wwv_flow_api.g_varchar2_table(33) := '516B456677434B646A574A4177534B43676F4B4363756476344F35594C727437457A6758686955332F342B6232636B6D77566A4A53704B6B513677416934677768542B7A3377524263457A30796A53736555547263527966734873586D4430416D62484F';
wwv_flow_api.g_varchar2_table(34) := '433949693856496D6E75584250676C48705135777753564D37734E6E5447375A61344A774464436A7879416948336E7941326D7461544A756669445A35644361716C4974494C68314E486174664E35736B766A78395A33386D363943677A75586D5A6756';
wwv_flow_api.g_varchar2_table(35) := '72504947453736334A7839714B73526F7A57597736784F486445522B6E6E324B6B4F2B42622B55563543424E36574336517442676252566F7A72616841626D6D364874557367745043313974466478585A59424F666B626D464A3156614841315641486A';
wwv_flow_api.g_varchar2_table(36) := '6430707037306F545A7A76522B455672783259676664737136657535354248595238686C636B692B6E2B6B4552554647384272413042776A654176324D38574C51427463792B534436664E736D6E4233416C424C726754745657316332514E346256574C';
wwv_flow_api.g_varchar2_table(37) := '415461495336304A32447535793154694A676A53427646565A67546D7743552B64415A466F507847454573386E79484339427765324776454A763257585A6230766A647946543443786B33652F6B49716C4F476F564C7777506576705948542B3030542B';
wwv_flow_api.g_varchar2_table(38) := '68577758446634414A414F557157634468627741414141415355564F524B35435949493D22292021696D706F7274616E743B0A097D0A0A093E202E746F6173742D6572726F72207B0A09096261636B67726F756E642D696D6167653A2075726C28226461';
wwv_flow_api.g_varchar2_table(39) := '74613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638';
wwv_flow_api.g_varchar2_table(40) := '595155414141414A6345685A6377414144734D414141374441636476714751414141484F535552425645684C725A612F53674E42454D5A7A6830574B43436C53434B6149594F45442B41414B6551514C473848577A744C43496D4272596164674964592B';
wwv_flow_api.g_varchar2_table(41) := '67494B4E596B42465377753743416F7143676B6B6F4742492F4532385064624C5A6D65444C677A5A7A637838332F7A5A3253535843316A3966722B49314871393367327978483469774D31766B6F4257416478436D707A5478666B4E325263795A4E6148';
wwv_flow_api.g_varchar2_table(42) := '46496B536F31302B386B67786B584955525635484778546D467563373542325266516B707848473861416761414661307441487159466651374977653279684F446B382B4A34433779416F5254574933772F346B6C47526752346C4F3752706E392B6776';
wwv_flow_api.g_varchar2_table(43) := '4D7957702B75784668382B482B41526C674E316E4A754A75514159764E6B456E774746636B31384572347133656745632F6F4F2B6D684C644B67527968644E466961634330726C4F4362684E567A344839466E41596744427655335149696F5A6C4A464C';
wwv_flow_api.g_varchar2_table(44) := '4A74736F4859524466695A6F557949787143745270566C414E71304555346441706A727467657A504661643553313957676A6B6330684E566E754634486A56413643375172534962796C422B6F5A65336148674273716C4E714B594834386A58794A4B4D';
wwv_flow_api.g_varchar2_table(45) := '7541626979564A384B7A61423365526330706739567751346E6946727949363871694F693341626A776473666E41746B3062436A544C4A4B72366D724439673869712F532F4238316867754F4D6C51546E56794734307741636A6E6D6773434E45534472';
wwv_flow_api.g_varchar2_table(46) := '6A6D653777666674503450375350344E33434A5A64767A6F4E79477132632F48574F584A47737656672B52412F6B324D432F774E364932594132507438476B41414141415355564F524B35435949493D22292021696D706F7274616E743B0A097D0A0A09';
wwv_flow_api.g_varchar2_table(47) := '3E202E746F6173742D73756363657373207B0A09096261636B67726F756E642D696D6167653A2075726C2822646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341';
wwv_flow_api.g_varchar2_table(48) := '594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414473535552425645684C593241594266514D6766';
wwv_flow_api.g_varchar2_table(49) := '2F2F2F3350382B2F657641496776412F467349462B426176594444574D4247726F61534D4D42694538564337415A44724946614D466E696933415A546A556773555557554441384F644148366951625145687734487947735045634B4258424943344152';
wwv_flow_api.g_varchar2_table(50) := '68657834473442736A6D77655531736F49466147672F57746F465A52495A644576494D68786B43436A5849567341545636674647414373345273773045476749494833514A594A6748534152515A44725741422B6A61777A67732B5132554F343944376A';
wwv_flow_api.g_varchar2_table(51) := '6E525352476F454652494C63646D454D57474930636D304A4A325170594131524476636D7A4A455768414268442F7071724C30533043577541424B676E526B69396C4C736553376732416C7177485751534B48346F4B4C72494C7052476845514377324C';
wwv_flow_api.g_varchar2_table(52) := '6952554961346C7741414141424A52553545726B4A6767673D3D22292021696D706F7274616E743B0A097D0A0A093E202E746F6173742D7761726E696E67207B0A09096261636B67726F756E642D696D6167653A2075726C2822646174613A696D616765';
wwv_flow_api.g_varchar2_table(53) := '2F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A';
wwv_flow_api.g_varchar2_table(54) := '6345685A6377414144734D4141413744416364767147514141414759535552425645684C355A537654734E51464D62585A4749434D5947596D4A684151494A41494359515041414369534442384169494351514A54344371514577674A76594153415143';
wwv_flow_api.g_varchar2_table(55) := '695A69596D4A6841494241544341524A792B397254736C646438734B75314D302B644C6230353776362F6C62712F32724B306D532F54524E6A3963574E414B5059494A494937674978436351353163767149442B4749455838415347344231624B356749';
wwv_flow_api.g_varchar2_table(56) := '5A466551666F4A6445584F6667583451415167376B4832413635795138376C79786232377367676B417A41754668626267314B326B67436B4231625677794952396D324C37505250496844554958674774794B77353735797A336C544E733658344A586E';
wwv_flow_api.g_varchar2_table(57) := '6A562B4C4B4D2F6D334D79646E5462744F4B496A747A3656684342713476536D336E63647244326C6B305667555853564B6A56444A584A7A696A57315251647355374637374865387536386B6F4E5A547A384F7A35794761364A3348336C5A3078596758';
wwv_flow_api.g_varchar2_table(58) := '424B3251796D6C5757412B52576E5968736B4C427632766D452B68424D43746241374B58356472577952542F324A73715A32497666423959346257444E4D46624A52466D4339453734536F53304371756C776A6B43302B356270635631435A384E4D656A';
wwv_flow_api.g_varchar2_table(59) := '34706A7930552B646F44517347796F31687A564A7474496A685137476E427452464E31556172556C48384633786963742B4859303772457A6F5547506C57636A52465272342F6743685A6763335A4C3264386F41414141415355564F524B35435949493D';
wwv_flow_api.g_varchar2_table(60) := '22292021696D706F7274616E743B0A097D0A0A092E746F6173742D7469746C65207B0A0909666F6E742D7765696768743A203730303B0A0909666F6E742D73697A653A20312E3972656D3B0A090970616464696E672D626F74746F6D3A203870783B0A09';
wwv_flow_api.g_varchar2_table(61) := '7D0A0A092F2A6F76657272696465732A2F0A09262E746F6173742D746F702D63656E746572203E206469762C0A09262E746F6173742D626F74746F6D2D63656E746572203E20646976207B0A090977696474683A2033303070783B0A09096D617267696E';
wwv_flow_api.g_varchar2_table(62) := '2D6C6566743A206175746F3B0A09096D617267696E2D72696768743A206175746F3B0A097D0A0A09262E746F6173742D746F702D66756C6C2D7769647468203E206469762C0A09262E746F6173742D626F74746F6D2D66756C6C2D7769647468203E2064';
wwv_flow_api.g_varchar2_table(63) := '6976207B0A090977696474683A203936253B0A09096D617267696E2D6C6566743A206175746F3B0A09096D617267696E2D72696768743A206175746F3B0A097D0A7D0A0A2E746F617374207B0A096261636B67726F756E642D636F6C6F723A20406E6561';
wwv_flow_api.g_varchar2_table(64) := '722D626C61636B3B0A7D0A0A2E746F6173742D73756363657373207B0A096261636B67726F756E642D636F6C6F723A2040677265656E3B0A7D0A0A2E746F6173742D6572726F72207B0A096261636B67726F756E642D636F6C6F723A20407265643B0A7D';
wwv_flow_api.g_varchar2_table(65) := '0A0A2E746F6173742D696E666F207B0A096261636B67726F756E642D636F6C6F723A2040626C75653B0A7D0A0A2E746F6173742D7761726E696E67207B0A096261636B67726F756E642D636F6C6F723A20406F72616E67653B0A7D0A0A2E746F6173742D';
wwv_flow_api.g_varchar2_table(66) := '70726F6772657373207B0A09706F736974696F6E3A206162736F6C7574653B0A096C6566743A20303B0A09626F74746F6D3A20303B0A096865696768743A203470783B0A096261636B67726F756E642D636F6C6F723A2040626C61636B3B0A092E6F7061';
wwv_flow_api.g_varchar2_table(67) := '6369747928302E34293B0A7D0A0A2F2A526573706F6E736976652044657369676E2A2F0A0A406D6564696120616C6C20616E6420286D61782D77696474683A20323430707829207B0A0923746F6173742D636F6E7461696E6572207B0A0A09093E206469';
wwv_flow_api.g_varchar2_table(68) := '76207B0A09090970616464696E673A20387078203870782038707820353070783B0A09090977696474683A203131656D3B0A0909096D61782D77696474683A203131656D3B0A09097D0A0A09093E206469762E72746C207B0A09090970616464696E673A';
wwv_flow_api.g_varchar2_table(69) := '20387078203530707820387078203870783B0A09097D0A0A090926202E746F6173742D636C6F73652D627574746F6E207B0A09090972696768743A202D302E32656D3B0A090909746F703A202D302E32656D3B0A09097D0A0A090926202E72746C202E74';
wwv_flow_api.g_varchar2_table(70) := '6F6173742D636C6F73652D627574746F6E207B0A0909096C6566743A202D302E32656D3B0A09090972696768743A20302E32656D3B0A09097D0A097D0A7D0A0A406D6564696120616C6C20616E6420286D696E2D77696474683A2032343170782920616E';
wwv_flow_api.g_varchar2_table(71) := '6420286D61782D77696474683A20343830707829207B0A0923746F6173742D636F6E7461696E6572207B0A09093E20646976207B0A09090970616464696E673A20387078203870782038707820353070783B0A09090977696474683A203138656D3B0A09';
wwv_flow_api.g_varchar2_table(72) := '09096D61782D77696474683A203138656D3B0A09097D0A0A09093E206469762E72746C207B0A09090970616464696E673A20387078203530707820387078203870783B0A09097D0A0A090926202E746F6173742D636C6F73652D627574746F6E207B0A09';
wwv_flow_api.g_varchar2_table(73) := '090972696768743A202D302E32656D3B0A090909746F703A202D302E32656D3B0A09097D0A0A090926202E72746C202E746F6173742D636C6F73652D627574746F6E207B0A0909096C6566743A202D302E32656D3B0A09090972696768743A20302E3265';
wwv_flow_api.g_varchar2_table(74) := '6D3B0A09097D0A097D0A7D0A0A406D6564696120616C6C20616E6420286D696E2D77696474683A2034383170782920616E6420286D61782D77696474683A20373638707829207B0A0923746F6173742D636F6E7461696E6572207B0A09093E2064697620';
wwv_flow_api.g_varchar2_table(75) := '7B0A09090970616464696E673A20313570782031357078203135707820353070783B0A09090977696474683A203235656D3B0A0909096D61782D77696474683A203235656D3B0A09097D0A0A09093E206469762E72746C207B0A09090970616464696E67';
wwv_flow_api.g_varchar2_table(76) := '3A20313570782035307078203135707820313570783B0A09097D0A097D0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(13249844449323551)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/toastr.less'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22746F617374722E6A73225D2C226E616D6573223A5B22646566696E65222C2224222C2224636F6E7461696E6572222C226C697374656E6572222C2270726576696F7573546F617374222C22';
wwv_flow_api.g_varchar2_table(2) := '746F6173744964222C22746F61737454797065222C22746F61737472222C22636C656172222C2224746F617374456C656D656E74222C22636C6561724F7074696F6E73222C226F7074696F6E73222C226765744F7074696F6E73222C22676574436F6E74';
wwv_flow_api.g_varchar2_table(3) := '61696E6572222C22636C656172546F617374222C22746F61737473546F436C656172222C226368696C6472656E222C2269222C226C656E677468222C22636C656172436F6E7461696E6572222C2272656D6F7665222C2272656D6F7665546F617374222C';
wwv_flow_api.g_varchar2_table(4) := '226572726F72222C226D657373616765222C227469746C65222C226F7074696F6E734F76657272696465222C226E6F74696679222C2274797065222C2269636F6E436C617373222C2269636F6E436C6173736573222C22696E666F222C22737562736372';
wwv_flow_api.g_varchar2_table(5) := '696265222C2263616C6C6261636B222C2273756363657373222C2276657273696F6E222C227761726E696E67222C22637265617465222C22636F6E7461696E65724964222C22706F736974696F6E436C617373222C2261747472222C22616464436C6173';
wwv_flow_api.g_varchar2_table(6) := '73222C22617070656E64546F222C22746172676574222C22637265617465436F6E7461696E6572222C22666F726365222C22686964654D6574686F64222C226475726174696F6E222C22686964654475726174696F6E222C22656173696E67222C226869';
wwv_flow_api.g_varchar2_table(7) := '6465456173696E67222C22636F6D706C657465222C227075626C697368222C2261726773222C226D6170222C22657874656E64222C2270726576656E744475706C696361746573222C2273686F756C6445786974222C22696E74657276616C4964222C22';
wwv_flow_api.g_varchar2_table(8) := '247469746C65456C656D656E74222C22246D657373616765456C656D656E74222C222470726F6772657373456C656D656E74222C2224636C6F7365456C656D656E74222C22636C6F736548746D6C222C2270726F6772657373426172222C226869646545';
wwv_flow_api.g_varchar2_table(9) := '7461222C226D61784869646554696D65222C22726573706F6E7365222C227374617465222C22737461727454696D65222C2244617465222C22746F617374436C617373222C22737566666978222C2265736361706548746D6C222C22617070656E64222C';
wwv_flow_api.g_varchar2_table(10) := '227469746C65436C617373222C227365745469746C65222C226D657373616765436C617373222C227365744D657373616765222C22636C6F7365427574746F6E222C22636C6F7365436C617373222C2270726570656E64222C2270726F6772657373436C';
wwv_flow_api.g_varchar2_table(11) := '617373222C2272746C222C226E65776573744F6E546F70222C226172696156616C7565222C2273657441726961222C2268696465222C2273686F774D6574686F64222C2273686F774475726174696F6E222C2273686F77456173696E67222C226F6E5368';
wwv_flow_api.g_varchar2_table(12) := '6F776E222C2274696D654F7574222C2273657454696D656F7574222C2268696465546F617374222C227061727365466C6F6174222C2267657454696D65222C22736574496E74657276616C222C2275706461746550726F6772657373222C22636C6F7365';
wwv_flow_api.g_varchar2_table(13) := '4F6E486F766572222C22686F766572222C22737469636B41726F756E64222C2264656C6179656448696465546F617374222C226F6E636C69636B222C22746170546F4469736D697373222C22636C69636B222C226576656E74222C2273746F7050726F70';
wwv_flow_api.g_varchar2_table(14) := '61676174696F6E222C22756E646566696E6564222C2263616E63656C427562626C65222C226F6E436C6F7365436C69636B222C2268616E646C654576656E7473222C226465627567222C22636F6E736F6C65222C226C6F67222C22736F75726365222C22';
wwv_flow_api.g_varchar2_table(15) := '7265706C616365222C226F76657272696465222C226D6574686F64222C22636C6F73654D6574686F64222C22636C6F73654475726174696F6E222C22636C6F7365456173696E67222C22636C65617254696D656F7574222C226F6E48696464656E222C22';
wwv_flow_api.g_varchar2_table(16) := '656E6454696D65222C22657874656E64656454696D654F7574222C2273746F70222C2270657263656E74616765222C227769647468222C226973222C22616D64222C2264657073222C22666163746F7279222C226D6F64756C65222C226578706F727473';
wwv_flow_api.g_varchar2_table(17) := '222C2272657175697265222C2277696E646F77222C226A5175657279225D2C226D617070696E6773223A22434161432C53414155412C47414350412C4541414F2C434141432C574141572C53414155432C4741437A422C4F41414F2C574143482C494141';
wwv_flow_api.g_varchar2_table(18) := '49432C45414341432C4541734241432C4541724241432C454141552C45414356432C4541434F2C51414450412C4541454D2C4F41464E412C454147532C55414854412C454149532C55414754432C454141532C43414354432C4D4130454A2C5341416543';
wwv_flow_api.g_varchar2_table(19) := '2C45414165432C47414331422C49414149432C45414155432C49414354562C47414163572C45414161462C4741433342472C454141574C2C45414165452C45414153442C49416D4235432C5341417942432C47414572422C494144412C49414149492C45';
wwv_flow_api.g_varchar2_table(20) := '41416742622C45414157632C5741437442432C45414149462C45414163472C4F4141532C45414147442C4741414B2C45414147412C4941433343482C45414157622C45414145632C45414163452C4941414B4E2C474172426843512C43414165522C4941';
wwv_flow_api.g_varchar2_table(21) := '37456E42532C4F4169464A2C5341416742582C4741435A2C49414149452C45414155432C49414354562C47414163572C45414161462C47414368432C47414149462C47414175442C4941417443522C454141452C53414155512C47414165532C4F414535';
wwv_flow_api.g_varchar2_table(22) := '432C59414441472C454141595A2C4741475A502C45414157632C57414157452C514143744268422C454141576B422C5541784666452C4D4167424A2C53414165432C45414153432C4541414F432C47414333422C4F41414F432C4541414F2C4341435643';
wwv_flow_api.g_varchar2_table(23) := '2C4B41414D72422C4541434E73422C5541415768422C4941416169422C59414159502C4D41437043432C51414153412C45414354452C674241416942412C4541436A42442C4D41414F412C4B41724258582C61414163412C4541436469422C4B416F434A';
wwv_flow_api.g_varchar2_table(24) := '2C53414163502C45414153432C4541414F432C47414331422C4F41414F432C4541414F2C43414356432C4B41414D72422C4541434E73422C5541415768422C4941416169422C59414159432C4B41437043502C51414153412C45414354452C6742414169';
wwv_flow_api.g_varchar2_table(25) := '42412C4541436A42442C4D41414F412C4B417A4358622C514141532C474143546F422C554134434A2C5341416D42432C4741436637422C4541415736422C4741354358432C51412B434A2C5341416942562C45414153432C4541414F432C47414337422C';
wwv_flow_api.g_varchar2_table(26) := '4F41414F432C4541414F2C43414356432C4B41414D72422C4541434E73422C5541415768422C4941416169422C59414159492C5141437043562C51414153412C45414354452C674241416942412C4541436A42442C4D41414F412C4B41704458552C5141';
wwv_flow_api.g_varchar2_table(27) := '41532C51414354432C514175444A2C53414169425A2C45414153432C4541414F432C47414337422C4F41414F432C4541414F2C43414356432C4B41414D72422C4541434E73422C5541415768422C4941416169422C594141594D2C51414370435A2C5141';
wwv_flow_api.g_varchar2_table(28) := '4153412C45414354452C674241416942412C4541436A42442C4D41414F412C4D417844662C4F41414F6A422C454163502C534141534D2C45414161462C4541415379422C47414733422C4F41464B7A422C49414157412C45414155432C4D41433142562C';
wwv_flow_api.g_varchar2_table(29) := '45414161442C454141452C4941414D552C4541415130422C594141632C4941414D31422C4541415132422C67424143314370422C514147586B422C494143416C432C45416946522C5341417942532C47414D72422C4F414C41542C45414161442C454141';
wwv_flow_api.g_varchar2_table(30) := '452C5541435673432C4B41414B2C4B41414D35422C4541415130422C6141436E42472C5341415337422C4541415132422C6742414558472C5341415378432C45414145552C454141512B422C534143764278432C454176465579432C434141674268432C';
wwv_flow_api.g_varchar2_table(31) := '4941487442542C45417545662C53414153592C454141594C2C45414165452C45414153442C4741437A432C494141496B432C4B4141516C432C4941416742412C454141616B432C514141516C432C454141616B432C4D414339442C534141496E432C4941';
wwv_flow_api.g_varchar2_table(32) := '416B426D432C4741412B432C494141744333432C454141452C53414155512C47414165532C5541437444542C45414163452C454141516B432C594141592C4341433942432C534141556E432C454141516F432C6141436C42432C4F41415172432C454141';
wwv_flow_api.g_varchar2_table(33) := '5173432C5741436842432C534141552C5741416337422C454141595A2C4F41456A432C47413044662C5341415330432C45414151432C474143526A442C4741434C412C4541415369442C474147622C5341415331422C4541414F32422C4741435A2C4941';
wwv_flow_api.g_varchar2_table(34) := '414931432C45414155432C4941435667422C4541415979422C454141497A422C574141616A422C4541415169422C55414F7A432C51414C71432C4941417A4279422C4541416D422C6B424143334231432C45414155562C4541414571442C4F41414F3343';
wwv_flow_api.g_varchar2_table(35) := '2C4541415330432C4541414935422C694241436843472C4541415979422C4541414935422C674241416742472C57414161412C4941794C6A442C5341416F426A422C4541415330432C4741437A422C4741414931432C4541415134432C6B4241416D422C';
wwv_flow_api.g_varchar2_table(36) := '43414333422C47414149462C4541414939422C554141596E422C45414368422C4F41414F2C45414550412C454141674269442C4541414939422C51414735422C4F41414F2C4541394C5069432C4341415737432C4541415330432C47414178422C434145';
wwv_flow_api.g_varchar2_table(37) := '4168442C49414541482C45414161572C45414161462C474141532C4741456E432C4941414938432C454141612C4B41436268442C4541416742522C454141452C5541436C4279442C45414167427A442C454141452C5541436C4230442C4541416B423144';
wwv_flow_api.g_varchar2_table(38) := '2C454141452C554143704232442C4541416D4233442C454141452C554143724234442C454141674235442C45414145552C454141516D442C5741433142432C454141632C434143644E2C574141592C4B41435A4F2C514141532C4B414354432C59414161';
wwv_flow_api.g_varchar2_table(39) := '2C4D414562432C454141572C4341435837442C51414153412C4541435438442C4D41414F2C55414350432C554141572C49414149432C4B41436631442C51414153412C4541435430432C4941414B412C474165542C4F41304651412C454141497A422C57';
wwv_flow_api.g_varchar2_table(40) := '41434A6E422C454141632B422C5341415337422C4541415132442C5941415939422C534141535A2C47415935442C574143492C4741414979422C4541414937422C4D41414F2C434143582C494141492B432C454141536C422C4541414937422C4D414362';
wwv_flow_api.g_varchar2_table(41) := '622C4541415136442C61414352442C45414153432C454141576E422C4541414937422C51414535426B432C45414163652C4F41414F462C474141512F422C5341415337422C454141512B442C59414339436A452C4541416367452C4F41414F662C494137';
wwv_flow_api.g_varchar2_table(42) := '467A4269422C474169474A2C574143492C4741414974422C4541414939422C514141532C434143622C4941414967442C454141536C422C4541414939422C514143625A2C4541415136442C61414352442C45414153432C454141576E422C454141493942';
wwv_flow_api.g_varchar2_table(43) := '2C55414535426F432C4541416742632C4F41414F462C474141512F422C5341415337422C4541415169452C63414368446E452C4541416367452C4F41414F642C494176477A426B422C47413447496C452C454141516D452C634143526A422C4541416372';
wwv_flow_api.g_varchar2_table(44) := '422C5341415337422C454141516F452C5941415978432C4B41414B2C4F4141512C554143784439422C4541416375452C514141516E422C49414B74426C442C454141516F442C63414352482C454141694270422C5341415337422C4541415173452C6541';
wwv_flow_api.g_varchar2_table(45) := '436C4378452C4541416375452C5141415170422C49414B74426A442C4541415175452C4B4143527A452C454141632B422C534141532C4F41374376
4237422C4541415177452C594143526A462C4541415738452C5141415176452C4741456E42502C4541';
wwv_flow_api.g_varchar2_table(46) := '415775452C4F41414F68452C47417A4531422C574143492C4941414932452C454141592C47414368422C4F4141512F422C454141497A422C574143522C4941414B2C674241434C2C4941414B2C6141434477442C454141612C534143622C4D41434A2C51';
wwv_flow_api.g_varchar2_table(47) := '414349412C454141592C594145704233452C4541416338422C4B41414B2C5941416136432C4741626843432C47416B444135452C4541416336452C4F41456437452C45414163452C4541415134452C5941436C422C434141437A432C534141556E432C45';
wwv_flow_api.g_varchar2_table(48) := '41415136452C6141416378432C4F41415172432C4541415138452C5741415976432C5341415576432C454141512B452C5541472F452F452C4541415167462C514141552C4941436C426C432C454141616D432C57414157432C454141576C462C45414151';
wwv_flow_api.g_varchar2_table(49) := '67462C534143334335422C45414159452C5941416336422C574141576E462C4541415167462C534143374335422C45414159432C534141552C494141494B2C4D41414F30422C5541415968432C45414159452C594143724474442C454141516F442C6341';
wwv_flow_api.g_varchar2_table(50) := '4352412C454141594E2C5741416175432C59414159432C45414167422C4D4137436A452C5741435174462C4541415175462C634143527A462C4541416330462C4D41414D432C45414161432C494147684331462C4541415132462C5341415733462C4541';
wwv_flow_api.g_varchar2_table(51) := '415134462C634143354239462C454141632B462C4D41414D582C47414770426C462C454141516D452C614141656A422C4741437642412C4541416332432C4F41414D2C53414155432C4741437442412C4541414D432C674241434E442C4541414D432C75';
wwv_flow_api.g_varchar2_table(52) := '4241437742432C4941417642462C4541414D472C65414171442C4941417642482C4541414D472C6541436A44482C4541414D472C634141652C47414772426A472C454141516B472C634143526C472C454141516B472C614141614A2C4741477A425A2C47';
wwv_flow_api.g_varchar2_table(53) := '4141552C4D4149646C462C4541415132462C5341435237462C454141632B462C4F41414D2C53414155432C474143314239462C4541415132462C51414151472C47414368425A2C4F4133455A69422C4741454133442C45414151652C4741454A76442C45';
wwv_flow_api.g_varchar2_table(54) := '4141516F472C4F414153432C5341436A42412C51414151432C494141492F432C474147547A442C454145502C534141532B442C4541415730432C47414B68422C4F414A632C4D414156412C49414341412C454141532C4941474E412C45414346432C5141';
wwv_flow_api.g_varchar2_table(55) := '41512C4B41414D2C53414364412C514141512C4B41414D2C55414364412C514141512C4B41414D2C53414364412C514141512C4B41414D2C51414364412C514141512C4B41414D2C5141674A76422C5341415374422C4541415575422C474143662C4941';
wwv_flow_api.g_varchar2_table(56) := '4149432C45414153442C4941416F432C49414178427A472C4541415132472C594141774233472C4541415132472C5941416333472C454141516B432C5741436E46432C4541415773452C49414173432C49414131427A472C4541415134472C6341432F42';
wwv_flow_api.g_varchar2_table(57) := '35472C4541415134472C634141674235472C454141516F432C6141436843432C454141536F452C4941416F432C49414178427A472C4541415136472C594141774237472C4541415136472C5941416337472C4541415173432C57414376462C4941414968';
wwv_flow_api.g_varchar2_table(58) := '442C454141452C53414155512C47414165532C514141576B472C45414931432C4F4144414B2C6141416131442C454141594E2C5941436C4268442C4541416334472C474141512C4341437A4276452C53414155412C45414356452C4F414151412C454143';
wwv_flow_api.g_varchar2_table(59) := '52452C534141552C5741434E37422C454141595A2C4741435A67482C6141416168452C4741435439432C454141512B472C5541412B422C5741416E4278442C45414153432C4F4143374278442C454141512B472C5741455A78442C45414153432C4D4141';
wwv_flow_api.g_varchar2_table(60) := '512C5341436A42442C4541415379442C514141552C4941414974442C4B414376426C422C45414151652C4D414B70422C534141536D432C4B41434431462C4541415167462C514141552C4741414B68462C4541415169482C674241416B422C4B41436A44';
wwv_flow_api.g_varchar2_table(61) := '6E452C454141616D432C57414157432C454141576C462C4541415169482C69424143334337442C45414159452C5941416336422C574141576E462C4541415169482C69424143374337442C45414159432C534141552C494141494B2C4D41414F30422C55';
wwv_flow_api.g_varchar2_table(62) := '41415968432C45414159452C6141496A452C534141536D432C4941434C71422C6141416168452C474143624D2C45414159432C514141552C454143744276442C454141636F482C4D41414B2C4741414D2C4741414D6C482C4541415134452C5941436E43';
wwv_flow_api.g_varchar2_table(63) := '2C434141437A432C534141556E432C4541415136452C6141416378432C4F41415172432C4541415138452C6141497A442C53414153512C4941434C2C4941414936422C474141652F442C45414159432C534141572C494141494B2C4D41414F30422C5741';
wwv_flow_api.g_varchar2_table(64) := '416368432C45414159452C594141652C49414339464C2C45414169426D452C4D41414D442C454141612C4D414935432C534141536C482C4941434C2C4F41414F582C4541414571442C4F41414F2C47413153542C4341434869442C634141632C45414364';
wwv_flow_api.g_varchar2_table(65) := '6A432C574141592C5141435A6A432C594141612C6B4241436230452C4F41414F2C4541455078422C574141592C5341435A432C614141632C49414364432C574141592C5141435A432C6141415369422C4541435439442C574141592C5541435A452C6141';
wwv_flow_api.g_varchar2_table(66) := '41632C49414364452C574141592C5141435A79452C63414155662C45414356572C614141612C45414362432C654141652C45414366432C614141612C4541436274422C634141632C4541456430422C6742414169422C4941436A422F462C594141612C43';
wwv_flow_api.g_varchar2_table(67) := '414354502C4D41414F2C63414350512C4B41414D2C6141434E472C514141532C6742414354452C514141532C6942414562502C554141572C61414358552C634141652C6B4241436671442C514141532C494143546A422C574141592C6341435A452C6141';
wwv_flow_api.g_varchar2_table(68) := '41632C67424143644A2C594141592C4541435A39422C4F4141512C4F4143526F422C554141572C794341435869422C574141592C714241435A492C614141612C4541436235422C6D4241416D422C4541436E42512C614141612C454143626B422C634141';
wwv_flow_api.g_varchar2_table(69) := '652C6942414366432C4B41414B2C47416D51304233452C4541414F492C53414739432C53414153552C454141595A2C4741435A502C49414163412C45414161572C4B414335424A2C4541416375482C474141472C634147724276482C45414163572C5341';
wwv_flow_api.g_varchar2_table(70) := '4364582C45414167422C4B414371422C4941416A43502C45414157632C57414157452C534143744268422C454141576B422C5341435868422C4F4141674275472C4B41686372422C4D4146662C434177636F422C6D4241415833472C5141417942412C4F';
wwv_flow_api.g_varchar2_table(71) := '41414F69492C4941414D6A492C4F4141532C534141556B492C4541414D432C47414339432C6F42414158432C5141413042412C4F41414F432C5141437843442C4F41414F432C51414155462C45414151472C514141512C5741456A43432C4F41414F6849';
wwv_flow_api.g_varchar2_table(72) := '2C4F41415334482C45414151492C4F41414F43222C2266696C65223A22746F617374722E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(17299370388686929)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'js/toastr.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A205468656D65726F6C6C65722047726F7570202A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A0A7B0A20202020227472616E736C617465223A20747275652C0A';
wwv_flow_api.g_varchar2_table(2) := '202020202267726F757073223A5B0A20202020202020207B0A202020202020202020202020226E616D65223A2022464F53204E6F74696669636174696F6E73222C0A20202020202020202020202022636F6D6D6F6E223A2066616C73652C0A2020202020';
wwv_flow_api.g_varchar2_table(3) := '202020202020202273657175656E6365223A203230303530300A20202020202020207D0A202020205D0A7D0A2A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A205661726961626C6573202A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A0A7B0A';
wwv_flow_api.g_varchar2_table(4) := '2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D7469746C652D666F6E742D73697A65222C0A2020226E616D6522202020203A20225469746C6520466F6E742053697A65222C0A2020227479706522202020203A20226E';
wwv_flow_api.g_varchar2_table(5) := '756D626572222C0A202022756E697473222020203A202272656D222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A20312C0A20202020226D617822202020202020203A20332C0A2020202022696E6372656D656E';
wwv_flow_api.g_varchar2_table(6) := '7422203A20302E310A20207D2C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D7469746C652D666F6E742D73697A653A20312E3472656D3B0A2F2A0A7B';
wwv_flow_api.g_varchar2_table(7) := '0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D7469746C652D666F6E742D776569676874222C0A2020226E616D6522202020203A20225469746C6520466F6E7420576569676874222C0A2020227479706522202020';
wwv_flow_api.g_varchar2_table(8) := '203A20226E756D626572222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A203130302C0A20202020226D617822202020202020203A203930302C0A2020202022696E6372656D656E7422203A203130300A20207D';
wwv_flow_api.g_varchar2_table(9) := '2C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D7469746C652D666F6E742D7765696768743A203630303B0A2F2A0A7B0A202022766172222020202020';
wwv_flow_api.g_varchar2_table(10) := '3A202240666F732D6E6F74696669636174696F6E2D7469746C652D626F74746F6D2D70616464696E67222C0A2020226E616D6522202020203A20225469746C652050616464696E6720E28695222C0A2020227479706522202020203A20226E756D626572';
wwv_flow_api.g_varchar2_table(11) := '222C0A202022756E697473222020203A20227078222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A20312C0A20202020226D617822202020202020203A2033302C0A2020202022696E6372656D656E7422203A20';
wwv_flow_api.g_varchar2_table(12) := '310A20207D2C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D7469746C652D626F74746F6D2D70616464696E673A20303B0A2F2A0A7B0A202022766172';
wwv_flow_api.g_varchar2_table(13) := '2220202020203A202240666F732D6E6F74696669636174696F6E2D6D6573736167652D666F6E742D73697A65222C0A2020226E616D6522202020203A20224D65737361676520466F6E742053697A65222C0A2020227479706522202020203A20226E756D';
wwv_flow_api.g_varchar2_table(14) := '626572222C0A202022756E697473222020203A202272656D222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A20312C0A20202020226D617822202020202020203A20332C0A2020202022696E6372656D656E7422';
wwv_flow_api.g_varchar2_table(15) := '203A20302E310A20207D2C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D6D6573736167652D666F6E742D73697A653A20312E3472656D3B0A2F2A0A7B';
wwv_flow_api.g_varchar2_table(16) := '0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D6D6573736167652D666F6E742D776569676874222C0A2020226E616D6522202020203A20224D65737361676520466F6E7420576569676874222C0A20202274797065';
wwv_flow_api.g_varchar2_table(17) := '22202020203A20226E756D626572222C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A203130302C0A20202020226D617822202020202020203A203930302C0A2020202022696E6372656D656E7422203A20313030';
wwv_flow_api.g_varchar2_table(18) := '0A20207D2C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D6D6573736167652D666F6E742D7765696768743A203430303B0A2F2A0A7B0A202022766172';
wwv_flow_api.g_varchar2_table(19) := '2220202020203A202240666F732D6E6F74696669636174696F6E2D7769647468222C0A2020226E616D6522202020203A20225769647468222C0A2020227479706522202020203A20226E756D626572222C0A202022756E697473222020203A2022707822';
wwv_flow_api.g_varchar2_table(20) := '2C0A20202272616E6765222020203A207B0A20202020226D696E22202020202020203A203130302C0A20202020226D617822202020202020203A20323030302C0A2020202022696E6372656D656E7422203A2032350A20207D2C0A20202267726F757022';
wwv_flow_api.g_varchar2_table(21) := '2020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D77696474683A2034303070783B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D';
wwv_flow_api.g_varchar2_table(22) := '6F706163697479222C0A2020226E616D6522202020203A20224E6F74696669636174696F6E204F706163697479222C0A2020227479706522202020203A20226E756D626572222C0A20202272616E6765222020203A207B0A20202020226D696E22202020';
wwv_flow_api.g_varchar2_table(23) := '202020203A20302E312C0A20202020226D617822202020202020203A20312C0A2020202022696E6372656D656E7422203A20302E310A20207D2C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73220A7D0A2A2F0A4066';
wwv_flow_api.g_varchar2_table(24) := '6F732D6E6F74696669636174696F6E2D6F7061636974793A20302E383B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D737563636573732D6261636B67726F756E642D636F6C6F72222C0A2020226E61';
wwv_flow_api.g_varchar2_table(25) := '6D6522202020203A20224261636B67726F756E64222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73222C0A20202273756267726F7570223A202253756363';
wwv_flow_api.g_varchar2_table(26) := '657373220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D737563636573732D6261636B67726F756E642D636F6C6F723A2040675F537563636573732D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669';
wwv_flow_api.g_varchar2_table(27) := '636174696F6E2D737563636573732D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E';
wwv_flow_api.g_varchar2_table(28) := '73222C0A20202273756267726F7570223A202253756363657373220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D737563636573732D636F6C6F723A2040675F537563636573732D46473B0A2F2A0A7B0A2020227661722220202020203A20';
wwv_flow_api.g_varchar2_table(29) := '2240666F732D6E6F74696669636174696F6E2D6572726F722D6261636B67726F756E642D636F6C6F72222C0A2020226E616D6522202020203A20224261636B67726F756E64222C0A2020227479706522202020203A2022636F6C6F72222C0A2020226772';
wwv_flow_api.g_varchar2_table(30) := '6F7570222020203A2022464F53204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20224572726F72220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D6572726F722D6261636B67726F756E642D636F6C6F723A2040';
wwv_flow_api.g_varchar2_table(31) := '675F44616E6765722D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D6572726F722D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A202022747970652220202020';
wwv_flow_api.g_varchar2_table(32) := '3A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20224572726F72220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D6572726F722D636F6C';
wwv_flow_api.g_varchar2_table(33) := '6F723A2040675F44616E6765722D46473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D7761726E696E672D6261636B67726F756E642D636F6C6F72222C0A2020226E616D6522202020203A20224261';
wwv_flow_api.g_varchar2_table(34) := '636B67726F756E64222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73222C0A20202273756267726F7570223A20225761726E696E67220A7D0A2A2F0A4066';
wwv_flow_api.g_varchar2_table(35) := '6F732D6E6F74696669636174696F6E2D7761726E696E672D6261636B67726F756E642D636F6C6F723A2040675F5761726E696E672D42473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D7761726E69';
wwv_flow_api.g_varchar2_table(36) := '6E672D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53204E6F74696669636174696F6E73222C0A2020227375626772';
wwv_flow_api.g_varchar2_table(37) := '6F7570223A20225761726E696E67220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D7761726E696E672D636F6C6F723A2040675F5761726E696E672D46473B0A2F2A0A7B0A2020227661722220202020203A202240666F732D6E6F74696669';
wwv_flow_api.g_varchar2_table(38) := '636174696F6E2D696E666F2D6261636B67726F756E642D636F6C6F72222C0A2020226E616D6522202020203A20224261636B67726F756E64222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F7570222020203A2022464F53';
wwv_flow_api.g_varchar2_table(39) := '204E6F74696669636174696F6E73222C0A20202273756267726F7570223A2022496E666F220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D696E666F2D6261636B67726F756E642D636F6C6F723A2040675F496E666F2D42473B0A2F2A0A7B';
wwv_flow_api.g_varchar2_table(40) := '0A2020227661722220202020203A202240666F732D6E6F74696669636174696F6E2D696E666F2D636F6C6F72222C0A2020226E616D6522202020203A2022436F6C6F72222C0A2020227479706522202020203A2022636F6C6F72222C0A20202267726F75';
wwv_flow_api.g_varchar2_table(41) := '70222020203A2022464F53204E6F74696669636174696F6E73222C0A20202273756267726F7570223A2022496E666F220A7D0A2A2F0A40666F732D6E6F74696669636174696F6E2D696E666F2D636F6C6F723A2040675F496E666F2D46473B0A2F2A2A2A';
wwv_flow_api.g_varchar2_table(42) := '2A2A2A2A2A2A2A2A2F0A2F2A2043535320202020202A2F0A2F2A2A2A2A2A2A2A2A2A2A2A2F0A23746F6173742D636F6E7461696E6572203E20646976207B0A2020202077696474683A2040666F732D6E6F74696669636174696F6E2D7769647468202169';
wwv_flow_api.g_varchar2_table(43) := '6D706F7274616E743B0A202020206F7061636974793A2040666F732D6E6F74696669636174696F6E2D6F7061636974792021696D706F7274616E743B0A20202020666F6E742D73697A653A2040666F732D6E6F74696669636174696F6E2D6D6573736167';
wwv_flow_api.g_varchar2_table(44) := '652D666F6E742D73697A652021696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E206469763A686F766572207B0A202020206F7061636974793A20312021696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E';
wwv_flow_api.g_varchar2_table(45) := '6572202E746F6173742D7469746C65207B0A20202020666F6E742D7765696768743A2040666F732D6E6F74696669636174696F6E2D7469746C652D666F6E742D7765696768742021696D706F7274616E743B0A20202020666F6E742D73697A653A204066';
wwv_flow_api.g_varchar2_table(46) := '6F732D6E6F74696669636174696F6E2D7469746C652D666F6E742D73697A652021696D706F7274616E743B0A2020202070616464696E672D626F74746F6D3A2040666F732D6E6F74696669636174696F6E2D7469746C652D626F74746F6D2D7061646469';
wwv_flow_api.g_varchar2_table(47) := '6E673B0A7D0A23746F6173742D636F6E7461696E6572202E746F6173742D6D657373616765207B0A20202020666F6E742D7765696768743A2040666F732D6E6F74696669636174696F6E2D6D6573736167652D666F6E742D7765696768742021696D706F';
wwv_flow_api.g_varchar2_table(48) := '7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E202E746F6173742D73756363657373207B0A202020206261636B67726F756E642D636F6C6F723A2040666F732D6E6F74696669636174696F6E2D737563636573732D6261636B67726F';
wwv_flow_api.g_varchar2_table(49) := '756E642D636F6C6F722021696D706F7274616E743B0A20202020636F6C6F723A2040666F732D6E6F74696669636174696F6E2D737563636573732D636F6C6F722021696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E202E74';
wwv_flow_api.g_varchar2_table(50) := '6F6173742D6572726F72207B0A202020206261636B67726F756E642D636F6C6F723A2040666F732D6E6F74696669636174696F6E2D6572726F722D6261636B67726F756E642D636F6C6F722021696D706F7274616E743B0A20202020636F6C6F723A2040';
wwv_flow_api.g_varchar2_table(51) := '666F732D6E6F74696669636174696F6E2D6572726F722D636F6C6F722021696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E202E746F6173742D7761726E696E67207B0A202020206261636B67726F756E642D636F6C6F723A';
wwv_flow_api.g_varchar2_table(52) := '2040666F732D6E6F74696669636174696F6E2D7761726E696E672D6261636B67726F756E642D636F6C6F722021696D706F7274616E743B0A20202020636F6C6F723A2040666F732D6E6F74696669636174696F6E2D7761726E696E672D636F6C6F722021';
wwv_flow_api.g_varchar2_table(53) := '696D706F7274616E743B0A7D0A23746F6173742D636F6E7461696E6572203E202E746F6173742D696E666F207B0A202020206261636B67726F756E642D636F6C6F723A2040666F732D6E6F74696669636174696F6E2D696E666F2D6261636B67726F756E';
wwv_flow_api.g_varchar2_table(54) := '642D636F6C6F722021696D706F7274616E743B0A20202020636F6C6F723A2040666F732D6E6F74696669636174696F6E2D696E666F2D636F6C6F722021696D706F7274616E743B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18839234358208730)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'less/fos-notification-themeroller.less'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E746F6173742D7469746C657B666F6E742D7765696768743A3730307D2E746F6173742D6D6573736167657B2D6D732D776F72642D777261703A627265616B2D776F72643B776F72642D777261703A627265616B2D776F72647D2E746F6173742D6D6573';
wwv_flow_api.g_varchar2_table(2) := '7361676520612C2E746F6173742D6D657373616765206C6162656C7B636F6C6F723A236666667D2E746F6173742D6D65737361676520613A686F7665727B636F6C6F723A236363633B746578742D6465636F726174696F6E3A6E6F6E657D2E746F617374';
wwv_flow_api.g_varchar2_table(3) := '2D636C6F73652D627574746F6E7B706F736974696F6E3A72656C61746976653B72696768743A2D2E33656D3B746F703A2D2E33656D3B666C6F61743A72696768743B666F6E742D73697A653A323070783B666F6E742D7765696768743A3730303B636F6C';
wwv_flow_api.g_varchar2_table(4) := '6F723A236666663B2D7765626B69742D746578742D736861646F773A3020317078203020236666663B746578742D736861646F773A3020317078203020236666663B6F7061636974793A2E393B2D6D732D66696C7465723A70726F6769643A4458496D61';
wwv_flow_api.g_varchar2_table(5) := '67655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3930293B66696C7465723A616C706861286F7061636974793D3930293B6C696E652D6865696768743A317D2E746F6173742D636C6F73652D627574746F6E3A66';
wwv_flow_api.g_varchar2_table(6) := '6F6375732C2E746F6173742D636C6F73652D627574746F6E3A686F7665727B636F6C6F723A233030303B746578742D6465636F726174696F6E3A6E6F6E653B637572736F723A706F696E7465723B6F7061636974793A2E343B2D6D732D66696C7465723A';
wwv_flow_api.g_varchar2_table(7) := '70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3430293B66696C7465723A616C706861286F7061636974793D3430297D2E72746C202E746F6173742D636C6F73652D627574746F';
wwv_flow_api.g_varchar2_table(8) := '6E7B6C6566743A2D2E33656D3B666C6F61743A6C6566743B72696768743A2E33656D7D627574746F6E2E746F6173742D636C6F73652D627574746F6E7B70616464696E673A303B637572736F723A706F696E7465723B6261636B67726F756E643A302030';
wwv_flow_api.g_varchar2_table(9) := '3B626F726465723A303B2D7765626B69742D617070656172616E63653A6E6F6E657D2E746F6173742D746F702D63656E7465727B746F703A303B72696768743A303B77696474683A313030257D2E746F6173742D626F74746F6D2D63656E7465727B626F';
wwv_flow_api.g_varchar2_table(10) := '74746F6D3A303B72696768743A303B77696474683A313030257D2E746F6173742D746F702D66756C6C2D77696474687B746F703A303B72696768743A303B77696474683A313030257D2E746F6173742D626F74746F6D2D66756C6C2D77696474687B626F';
wwv_flow_api.g_varchar2_table(11) := '74746F6D3A303B72696768743A303B77696474683A313030257D2E746F6173742D746F702D6C6566747B746F703A313270783B6C6566743A313270787D2E746F6173742D746F702D72696768747B746F703A313270783B72696768743A313270787D2E74';
wwv_flow_api.g_varchar2_table(12) := '6F6173742D626F74746F6D2D72696768747B72696768743A313270783B626F74746F6D3A313270787D2E746F6173742D626F74746F6D2D6C6566747B626F74746F6D3A313270783B6C6566743A313270787D23746F6173742D636F6E7461696E65727B70';
wwv_flow_api.g_varchar2_table(13) := '6F736974696F6E3A66697865643B7A2D696E6465783A3939393939393B706F696E7465722D6576656E74733A6E6F6E657D23746F6173742D636F6E7461696E6572202A7B2D6D6F7A2D626F782D73697A696E673A626F726465722D626F783B2D7765626B';
wwv_flow_api.g_varchar2_table(14) := '69742D626F782D73697A696E673A626F726465722D626F783B626F782D73697A696E673A626F726465722D626F787D23746F6173742D636F6E7461696E65723E6469767B706F736974696F6E3A72656C61746976653B706F696E7465722D6576656E7473';
wwv_flow_api.g_varchar2_table(15) := '3A6175746F3B6F766572666C6F773A68696464656E3B6D617267696E3A302030203670783B70616464696E673A313570782031357078203135707820353070783B77696474683A34353070783B2D6D6F7A2D626F726465722D7261646975733A33707820';
wwv_flow_api.g_varchar2_table(16) := '33707820337078203370783B2D7765626B69742D626F726465722D7261646975733A3370782033707820337078203370783B626F726465722D7261646975733A3370782033707820337078203370783B6261636B67726F756E642D706F736974696F6E3A';
wwv_flow_api.g_varchar2_table(17) := '313570782063656E7465723B6261636B67726F756E642D7265706561743A6E6F2D7265706561743B2D6D6F7A2D626F782D736861646F773A302030203132707820233939393B2D7765626B69742D626F782D736861646F773A3020302031327078202339';
wwv_flow_api.g_varchar2_table(18) := '39393B626F782D736861646F773A302030203132707820233939393B636F6C6F723A236666663B6F7061636974793A2E383B2D6D732D66696C7465723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861';
wwv_flow_api.g_varchar2_table(19) := '284F7061636974793D3830293B66696C7465723A616C706861286F7061636974793D3830293B666F6E742D73697A653A312E3672656D21696D706F7274616E747D23746F6173742D636F6E7461696E65723E6469762E72746C7B646972656374696F6E3A';
wwv_flow_api.g_varchar2_table(20) := '72746C3B70616464696E673A313570782035307078203135707820313570783B6261636B67726F756E642D706F736974696F6E3A726967687420313570782063656E7465727D23746F6173742D636F6E7461696E65723E6469763A686F7665727B2D6D6F';
wwv_flow_api.g_varchar2_table(21) := '7A2D626F782D736861646F773A302030203132707820233030303B2D7765626B69742D626F782D736861646F773A302030203132707820233030303B626F782D736861646F773A302030203132707820233030303B6F7061636974793A313B2D6D732D66';
wwv_flow_api.g_varchar2_table(22) := '696C7465723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D313030293B66696C7465723A616C706861286F7061636974793D313030293B637572736F723A706F696E7465727D';
wwv_flow_api.g_varchar2_table(23) := '23746F6173742D636F6E7461696E65723E2E746F6173742D696E666F7B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741';
wwv_flow_api.g_varchar2_table(24) := '414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414777535552425645684C745A6139';
wwv_flow_api.g_varchar2_table(25) := '53674E42454D63397355787852636F554B537A535749685870464D68685957466861426734795059695743585A78424C4552734C52533345516B456677434B646A574A4177534B43676F4B4363756476344F35594C727437457A6758686955332F342B62';
wwv_flow_api.g_varchar2_table(26) := '32636B6D77566A4A53704B6B513677416934677768542B7A3377524263457A30796A53736555547263527966734873586D4430416D62484F433949693856496D6E75584250676C48705135777753564D37734E6E5447375A61344A774464436A78794169';
wwv_flow_api.g_varchar2_table(27) := '48336E7941326D7461544A756669445A35644361716C4974494C68314E486174664E35736B766A78395A33386D363943677A75586D5A675672504947453736334A7839714B73526F7A57597736784F486445522B6E6E324B6B4F2B42622B55563543424E';
wwv_flow_api.g_varchar2_table(28) := '36574336517442676252566F7A72616841626D6D364874557367745043313974466478585A59424F666B626D464A3156614841315641486A6430707037306F545A7A76522B455672783259676664737136657535354248595238686C636B692B6E2B6B45';
wwv_flow_api.g_varchar2_table(29) := '52554647384272413042776A654176324D38574C51427463792B534436664E736D6E4233416C424C726754745657316332514E346256574C415461495336304A32447535793154694A676A53427646565A67546D7743552B64415A466F50784745457338';
wwv_flow_api.g_varchar2_table(30) := '6E79484339427765324776454A763257585A6230766A647946543443786B33652F6B49716C4F476F564C7777506576705948542B3030542B68577758446634414A414F557157634468627741414141415355564F524B35435949493D2921696D706F7274';
wwv_flow_api.g_varchar2_table(31) := '616E747D23746F6173742D636F6E7461696E65723E2E746F6173742D6572726F727B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E53556845556741';
wwv_flow_api.g_varchar2_table(32) := '4141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D414141374441636476714751414141484F53555242564568';
wwv_flow_api.g_varchar2_table(33) := '4C725A612F53674E42454D5A7A6830574B43436C53434B6149594F45442B41414B6551514C473848577A744C43496D4272596164674964592B67494B4E596B42465377753743416F7143676B6B6F4742492F4532385064624C5A6D65444C677A5A7A6378';
wwv_flow_api.g_varchar2_table(34) := '38332F7A5A3253535843316A3966722B49314871393367327978483469774D31766B6F4257416478436D707A5478666B4E325263795A4E614846496B536F31302B386B67786B584955525635484778546D467563373542325266516B7078484738614167';
wwv_flow_api.g_varchar2_table(35) := '61414661307441487159466651374977653279684F446B382B4A34433779416F5254574933772F346B6C47526752346C4F3752706E392B67764D7957702B75784668382B482B41526C674E316E4A754A75514159764E6B456E774746636B313845723471';
wwv_flow_api.g_varchar2_table(36) := '33656745632F6F4F2B6D684C644B67527968644E466961634330726C4F4362684E567A344839466E41596744427655335149696F5A6C4A464C4A74736F4859524466695A6F557949787143745270566C414E71304555346441706A727467657A50466164';
wwv_flow_api.g_varchar2_table(37) := '3553313957676A6B6330684E566E754634486A56413643375172534962796C422B6F5A65336148674273716C4E714B594834386A58794A4B4D7541626979564A384B7A61423365526330706739567751346E6946727949363871694F693341626A776473';
wwv_flow_api.g_varchar2_table(38) := '666E41746B3062436A544C4A4B72366D724439673869712F532F4238316867754F4D6C51546E56794734307741636A6E6D6773434E455344726A6D653777666674503450375350344E33434A5A64767A6F4E79477132632F48574F584A47737656672B52';
wwv_flow_api.g_varchar2_table(39) := '412F6B324D432F774E364932594132507438476B41414141415355564F524B35435949493D2921696D706F7274616E747D23746F6173742D636F6E7461696E65723E2E746F6173742D737563636573737B6261636B67726F756E642D696D6167653A7572';
wwv_flow_api.g_varchar2_table(40) := '6C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E5155314241414378';
wwv_flow_api.g_varchar2_table(41) := '6A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414473535552425645684C593241594266514D67662F2F2F3350382B2F657641496776412F467349462B426176594444574D4247726F61534D4D4269453856';
wwv_flow_api.g_varchar2_table(42) := '4337415A44724946614D466E696933415A546A556773555557554441384F644148366951625145687734487947735045634B425842494334415268657834473442736A6D77655531736F49466147672F57746F465A52495A644576494D68786B43436A58';
wwv_flow_api.g_varchar2_table(43) := '49567341545636674647414373345273773045476749494833514A594A6748534152515A44725741422B6A61777A67732B5132554F343944376A6E525352476F454652494C63646D454D57474930636D304A4A325170594131524476636D7A4A45576841';
wwv_flow_api.g_varchar2_table(44) := '4268442F7071724C30533043577541424B676E526B69396C4C736553376732416C7177485751534B48346F4B4C72494C7052476845514377324C6952554961346C7741414141424A52553545726B4A6767673D3D2921696D706F7274616E747D23746F61';
wwv_flow_api.g_varchar2_table(45) := '73742D636F6E7461696E65723E2E746F6173742D7761726E696E677B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E53556845556741414142674141';
wwv_flow_api.g_varchar2_table(46) := '4141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414759535552425645684C355A537654';
wwv_flow_api.g_varchar2_table(47) := '734E51464D62585A4749434D5947596D4A684151494A41494359515041414369534442384169494351514A54344371514577674A76594153415143695A69596D4A6841494241544341524A792B397254736C646438734B75314D302B644C623035377636';
wwv_flow_api.g_varchar2_table(48) := '2F6C62712F32724B306D532F54524E6A3963574E414B5059494A494937674978436351353163767149442B4749455838415347344231624B3567495A466551666F4A6445584F6667583451415167376B4832413635795138376C79786232377367676B41';
wwv_flow_api.g_varchar2_table(49) := '7A41754668626267314B326B67436B4231625677794952396D324C37505250496844554958674774794B77353735797A336C544E733658344A586E6A562B4C4B4D2F6D334D79646E5462744F4B496A
747A3656684342713476536D336E63647244326C6B';
wwv_flow_api.g_varchar2_table(50) := '305667555853564B6A56444A584A7A696A57315251647355374637374865387536386B6F4E5A547A384F7A35794761364A3348336C5A3078596758424B3251796D6C5757412B52576E5968736B4C427632766D452B68424D43746241374B583564725779';
wwv_flow_api.g_varchar2_table(51) := '52542F324A73715A32497666423959346257444E4D46624A52466D4339453734536F53304371756C776A6B43302B356270635631435A384E4D656A34706A7930552B646F44517347796F31687A564A7474496A685137476E427452464E31556172556C48';
wwv_flow_api.g_varchar2_table(52) := '384633786963742B4859303772457A6F5547506C57636A52465272342F6743685A6763335A4C3264386F41414141415355564F524B35435949493D2921696D706F7274616E747D23746F6173742D636F6E7461696E6572202E746F6173742D7469746C65';
wwv_flow_api.g_varchar2_table(53) := '7B666F6E742D7765696768743A3730303B666F6E742D73697A653A312E3972656D3B70616464696E672D626F74746F6D3A3870787D23746F6173742D636F6E7461696E65722E746F6173742D626F74746F6D2D63656E7465723E6469762C23746F617374';
wwv_flow_api.g_varchar2_table(54) := '2D636F6E7461696E65722E746F6173742D746F702D63656E7465723E6469767B77696474683A33303070783B6D617267696E2D6C6566743A6175746F3B6D617267696E2D72696768743A6175746F7D23746F6173742D636F6E7461696E65722E746F6173';
wwv_flow_api.g_varchar2_table(55) := '742D626F74746F6D2D66756C6C2D77696474683E6469762C23746F6173742D636F6E7461696E65722E746F6173742D746F702D66756C6C2D77696474683E6469767B77696474683A3936253B6D617267696E2D6C6566743A6175746F3B6D617267696E2D';
wwv_flow_api.g_varchar2_table(56) := '72696768743A6175746F7D2E746F6173747B6261636B67726F756E642D636F6C6F723A233033303330337D2E746F6173742D737563636573737B6261636B67726F756E642D636F6C6F723A233362616132637D2E746F6173742D6572726F727B6261636B';
wwv_flow_api.g_varchar2_table(57) := '67726F756E642D636F6C6F723A236634343333367D2E746F6173742D696E666F7B6261636B67726F756E642D636F6C6F723A233030373664667D2E746F6173742D7761726E696E677B6261636B67726F756E642D636F6C6F723A236638393430367D2E74';
wwv_flow_api.g_varchar2_table(58) := '6F6173742D70726F67726573737B706F736974696F6E3A6162736F6C7574653B6C6566743A303B626F74746F6D3A303B6865696768743A3470783B6261636B67726F756E642D636F6C6F723A233030303B6F7061636974793A2E343B2D6D732D66696C74';
wwv_flow_api.g_varchar2_table(59) := '65723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3430293B66696C7465723A616C706861286F7061636974793D3430297D406D6564696120616C6C20616E6420286D61782D';
wwv_flow_api.g_varchar2_table(60) := '77696474683A3234307078297B23746F6173742D636F6E7461696E65723E6469767B70616464696E673A387078203870782038707820353070783B77696474683A3131656D3B6D61782D77696474683A3131656D7D23746F6173742D636F6E7461696E65';
wwv_flow_api.g_varchar2_table(61) := '723E6469762E72746C7B70616464696E673A387078203530707820387078203870787D23746F6173742D636F6E7461696E6572202E746F6173742D636C6F73652D627574746F6E7B72696768743A2D2E32656D3B746F703A2D2E32656D7D23746F617374';
wwv_flow_api.g_varchar2_table(62) := '2D636F6E7461696E6572202E72746C202E746F6173742D636C6F73652D627574746F6E7B6C6566743A2D2E32656D3B72696768743A2E32656D7D7D406D6564696120616C6C20616E6420286D696E2D77696474683A32343170782920616E6420286D6178';
wwv_flow_api.g_varchar2_table(63) := '2D77696474683A3438307078297B23746F6173742D636F6E7461696E65723E6469767B70616464696E673A387078203870782038707820353070783B77696474683A3138656D3B6D61782D77696474683A3138656D7D23746F6173742D636F6E7461696E';
wwv_flow_api.g_varchar2_table(64) := '65723E6469762E72746C7B70616464696E673A387078203530707820387078203870787D23746F6173742D636F6E7461696E6572202E746F6173742D636C6F73652D627574746F6E7B72696768743A2D2E32656D3B746F703A2D2E32656D7D23746F6173';
wwv_flow_api.g_varchar2_table(65) := '742D636F6E7461696E6572202E72746C202E746F6173742D636C6F73652D627574746F6E7B6C6566743A2D2E32656D3B72696768743A2E32656D7D7D406D6564696120616C6C20616E6420286D696E2D77696474683A34383170782920616E6420286D61';
wwv_flow_api.g_varchar2_table(66) := '782D77696474683A3736387078297B23746F6173742D636F6E7461696E65723E6469767B70616464696E673A313570782031357078203135707820353070783B77696474683A3235656D3B6D61782D77696474683A3235656D7D23746F6173742D636F6E';
wwv_flow_api.g_varchar2_table(67) := '7461696E65723E6469762E72746C7B70616464696E673A313570782035307078203135707820313570787D7D0A2F2A2320736F757263654D617070696E6755524C3D746F617374722E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18896666519284290)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/toastr.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22746F617374722E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C592C434143452C652C434145462C632C434143452C77422C434143412C6F422C4341';
wwv_flow_api.g_varchar2_table(2) := '45462C67422C434143412C6F422C434143452C552C434145462C73422C434143452C552C434143412C6F422C434145462C6D422C434143452C69422C434143412C572C434143412C532C434143412C572C434143412C632C434143412C652C434143412C';
wwv_flow_api.g_varchar2_table(3) := '552C434143412C67432C434143412C77422C434143412C552C434143412C38442C434143412C77422C434143412C612C434147462C79422C434144412C79422C434145452C552C434143412C6F422C434143412C632C434143412C552C434143412C3844';
wwv_flow_api.g_varchar2_table(4) := '2C434143412C77422C434145462C77422C434143452C552C434143412C552C434143412C552C43414B462C79422C434143452C532C434143412C632C434143412C632C434143412C512C434143412C75422C434145462C69422C434143452C4B2C434143';
wwv_flow_api.g_varchar2_table(5) := '412C4F2C434143412C552C434145462C6F422C434143452C512C434143412C4F2C434143412C552C434145462C71422C434143452C4B2C434143412C4F2C434143412C552C434145462C77422C434143452C512C434143412C4F2C434143412C552C4341';
wwv_flow_api.g_varchar2_table(6) := '45462C652C434143452C512C434143412C532C434145462C67422C434143452C512C434143412C552C434145462C6D422C434143452C552C434143412C572C434145462C6B422C434143452C572C434143412C532C434145462C67422C434143452C632C';
wwv_flow_api.g_varchar2_table(7) := '434143412C632C434143412C6D422C434147462C6B422C434143452C30422C434143412C36422C434143412C71422C434145462C6F422C434143452C69422C434143412C6D422C434143412C652C434143412C632C434143412C32422C434143412C572C';
wwv_flow_api.g_varchar2_table(8) := '434143412C6B432C434143412C71432C434143412C36422C434143412C2B422C434143412C32422C434143412C36422C434143412C67432C434143412C77422C434143412C552C434143412C552C434143412C38442C434143412C77422C434143412C30';
wwv_flow_api.g_varchar2_table(9) := '422C434145462C77422C434143452C612C434143412C32422C434143412C71432C434145462C30422C434143452C36422C434143412C67432C434143412C77422C434143412C532C434143412C2B442C434143412C79422C434143412C632C434145462C';
wwv_flow_api.g_varchar2_table(10) := '34422C434143452C7377422C434145462C36422C434143452C3879422C434145462C2B422C434143452C6B67422C434145462C2B422C434143452C7375422C434145462C36422C434143452C652C434143412C67422C434143412C6B422C434147462C77';
wwv_flow_api.g_varchar2_table(11) := '432C434144412C71432C434145452C572C434143412C67422C434143412C69422C434147462C34432C434144412C79432C434145452C532C434143412C67422C434143412C69422C434145462C4D2C434143452C77422C434145462C632C434143452C77';
wwv_flow_api.g_varchar2_table(12) := '422C434145462C592C434143452C77422C434145462C572C434143452C77422C434145462C632C434143452C77422C434145462C652C434143452C69422C434143412C4D2C434143412C512C434143412C552C434143412C71422C434143412C552C4341';
wwv_flow_api.g_varchar2_table(13) := '43412C38442C434143412C77422C434147462C69434143452C6F422C434143452C77422C434143412C552C434143412C632C434145462C77422C434143452C77422C434145462C6F432C434143452C572C434143412C532C434145462C79432C43414345';
wwv_flow_api.g_varchar2_table(14) := '2C552C434143412C5941474A2C412C75444143452C6F422C434143452C77422C434143412C552C434143412C632C434145462C77422C434143452C77422C434145462C6F432C434143452C572C434143412C532C434145462C79432C434143452C552C43';
wwv_flow_api.g_varchar2_table(15) := '4143412C5941474A2C412C75444143452C6F422C434143452C32422C434143412C552C434143412C632C434145462C77422C434143452C3642222C2266696C65223A22746F617374722E637373222C22736F7572636573436F6E74656E74223A5B222E74';
wwv_flow_api.g_varchar2_table(16) := '6F6173742D7469746C65207B5C6E2020666F6E742D7765696768743A20626F6C643B5C6E7D5C6E2E746F6173742D6D657373616765207B5C6E20202D6D732D776F72642D777261703A20627265616B2D776F72643B5C6E2020776F72642D777261703A20';
wwv_flow_api.g_varchar2_table(17) := '627265616B2D776F72643B5C6E7D5C6E2E746F6173742D6D65737361676520612C5C6E2E746F6173742D6D657373616765206C6162656C207B5C6E2020636F6C6F723A20234646464646463B5C6E7D5C6E2E746F6173742D6D65737361676520613A686F';
wwv_flow_api.g_varchar2_table(18) := '766572207B5C6E2020636F6C6F723A20234343434343433B5C6E2020746578742D6465636F726174696F6E3A206E6F6E653B5C6E7D5C6E2E746F6173742D636C6F73652D627574746F6E207B5C6E2020706F736974696F6E3A2072656C61746976653B5C';
wwv_flow_api.g_varchar2_table(19) := '6E202072696768743A202D302E33656D3B5C6E2020746F703A202D302E33656D3B5C6E2020666C6F61743A2072696768743B5C6E2020666F6E742D73697A653A20323070783B5C6E2020666F6E742D7765696768743A20626F6C643B5C6E2020636F6C6F';
wwv_flow_api.g_varchar2_table(20) := '723A20234646464646463B5C6E20202D7765626B69742D746578742D736861646F773A203020317078203020236666666666663B5C6E2020746578742D736861646F773A203020317078203020236666666666663B5C6E20206F7061636974793A20302E';
wwv_flow_api.g_varchar2_table(21) := '393B5C6E20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3930293B5C6E202066696C7465723A20616C706861286F7061636974793D3930293B';
wwv_flow_api.g_varchar2_table(22) := '5C6E20206C696E652D6865696768743A20313B5C6E7D5C6E2E746F6173742D636C6F73652D627574746F6E3A686F7665722C5C6E2E746F6173742D636C6F73652D627574746F6E3A666F637573207B5C6E2020636F6C6F723A20233030303030303B5C6E';
wwv_flow_api.g_varchar2_table(23) := '2020746578742D6465636F726174696F6E3A206E6F6E653B5C6E2020637572736F723A20706F696E7465723B5C6E20206F7061636974793A20302E343B5C6E20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D';
wwv_flow_api.g_varchar2_table(24) := '2E4D6963726F736F66742E416C706861284F7061636974793D3430293B5C6E202066696C7465723A20616C706861286F7061636974793D3430293B5C6E7D5C6E2E72746C202E746F6173742D636C6F73652D627574746F6E207B5C6E20206C6566743A20';
wwv_flow_api.g_varchar2_table(25) := '2D302E33656D3B5C6E2020666C6F61743A206C6566743B5C6E202072696768743A20302E33656D3B5C6E7D5C6E2F2A4164646974696F6E616C2070726F7065727469657320666F7220627574746F6E2076657273696F6E5C6E20694F5320726571756972';
wwv_flow_api.g_varchar2_table(26) := '65732074686520627574746F6E20656C656D656E7420696E7374656164206F6620616E20616E63686F72207461672E5C6E20496620796F752077616E742074686520616E63686F722076657273696F6E2C2069742072657175697265732060687265663D';
wwv_flow_api.g_varchar2_table(27) := '5C22235C22602E2A2F5C6E627574746F6E2E746F6173742D636C6F73652D627574746F6E207B5C6E202070616464696E673A20303B5C6E2020637572736F723A20706F696E7465723B5C6E20206261636B67726F756E643A207472616E73706172656E74';
wwv_flow_api.g_varchar2_table(28) := '3B5C6E2020626F726465723A20303B5C6E20202D7765626B69742D617070656172616E63653A206E6F6E653B5C6E7D5C6E2E746F6173742D746F702D63656E746572207B5C6E2020746F703A20303B5C6E202072696768743A20303B5C6E202077696474';
wwv_flow_api.g_varchar2_table(29) := '683A20313030253B5C6E7D5C6E2E746F6173742D626F74746F6D2D63656E746572207B5C6E2020626F74746F6D3A20303B5C6E202072696768743A20303B5C6E202077696474683A20313030253B5C6E7D5C6E2E746F6173742D746F702D66756C6C2D77';
wwv_flow_api.g_varchar2_table(30) := '69647468207B5C6E2020746F703A20303B5C6E202072696768743A20303B5C6E202077696474683A20313030253B5C6E7D5C6E2E746F6173742D626F74746F6D2D66756C6C2D7769647468207B5C6E2020626F74746F6D3A20303B5C6E20207269676874';
wwv_flow_api.g_varchar2_table(31) := '3A20303B5C6E202077696474683A20313030253B5C6E7D5C6E2E746F6173742D746F702D6C656674207B5C6E2020746F703A20313270783B5C6E20206C6566743A20313270783B5C6E7D5C6E2E746F6173742D746F702D7269676874207B5C6E2020746F';
wwv_flow_api.g_varchar2_table(32) := '703A20313270783B5C6E202072696768743A20313270783B5C6E7D5C6E2E746F6173742D626F74746F6D2D7269676874207B5C6E202072696768743A20313270783B5C6E2020626F74746F6D3A20313270783B5C6E7D5C6E2E746F6173742D626F74746F';
wwv_flow_api.g_varchar2_table(33) := '6D2D6C656674207B5C6E2020626F74746F6D3A20313270783B5C6E20206C6566743A20313270783B5C6E7D5C6E23746F6173742D636F6E7461696E6572207B5C6E2020706F736974696F6E3A2066697865643B5C6E20207A2D696E6465783A2039393939';
wwv_flow_api.g_varchar2_table(34) := '39393B5C6E2020706F696E7465722D6576656E74733A206E6F6E653B5C6E20202F2A6F76657272696465732A2F5C6E7D5C6E23746F6173742D636F6E7461696E6572202A207B5C6E20202D6D6F7A2D626F782D73697A696E673A20626F726465722D626F';
wwv_flow_api.g_varchar2_table(35) := '783B5C6E20202D7765626B69742D626F782D73697A696E673A20626F726465722D626F783B5C6E2020626F782D73697A696E673A20626F726465722D626F783B5C6E7D5C6E23746F6173742D636F6E7461696E6572203E20646976207B5C6E2020706F73';
wwv_flow_api.g_varchar2_table(36) := '6974696F6E3A2072656C61746976653B5C6E2020706F696E7465722D6576656E74733A206175746F3B5C6E20206F766572666C6F773A2068696464656E3B5C6E20206D617267696E3A20302030203670783B5C6E202070616464696E673A203135707820';
wwv_flow_api.g_varchar2_table(37) := '31357078203135707820353070783B5C6E202077696474683A2034353070783B5C6E20202D6D6F7A2D626F726465722D7261646975733A203370782033707820337078203370783B5C6E20202D7765626B69742D626F726465722D7261646975733A2033';
wwv_flow_api.g_varchar2_table(38) := '70782033707820337078203370783B5C6E2020626F726465722D7261646975733A203370782033707820337078203370783B5C6E20206261636B67726F756E642D706F736974696F6E3A20313570782063656E7465723B5C6E20206261636B67726F756E';
wwv_flow_api.g_varchar2_table(39) := '642D7265706561743A206E6F2D7265706561743B5C6E20202D6D6F7A2D626F782D736861646F773A20302030203132707820233939393939393B5C6E20202D7765626B69742D626F782D736861646F773A20302030203132707820233939393939393B5C';
wwv_flow_api.g_varchar2_table(40) := '6E2020626F782D736861646F773A20302030203132707820233939393939393B5C6E2020636F6C6F723A20234646464646463B5C6E20206F7061636974793A20302E383B5C6E20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472';
wwv_flow_api.g_varchar2_table(41) := '616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D3830293B5C6E202066696C7465723A20616C706861286F7061636974793D3830293B5C6E2020666F6E742D73697A653A20312E3672656D2021696D706F7274616E743B5C';
wwv_flow_api.g_varchar2_table(42) := '6E7D5C6E23746F6173742D636F6E7461696E6572203E206469762E72746C207B5C6E2020646972656374696F6E3A2072746C3B5C6E202070616464696E673A20313570782035307078203135707820313570783B5C6E20206261636B67726F756E642D70';
wwv_flow_api.g_varchar2_table(43) := '6F736974696F6E3A20726967687420313570782063656E7465723B5C6E7D5C6E23746F6173742D636F6E7461696E6572203E206469763A686F766572207B5C6E20202D6D6F7A2D626F782D736861646F773A20302030203132707820233030303030303B';
wwv_flow_api.g_varchar2_table(44) := '5C6E20202D7765626B69742D626F782D736861646F773A20302030203132707820233030303030303B5C6E2020626F782D736861646F773A20302030203132707820233030303030303B5C6E20206F7061636974793A20313B5C6E20202D6D732D66696C';
wwv_flow_api.g_varchar2_table(45) := '7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F7061636974793D313030293B5C6E202066696C7465723A20616C706861286F7061636974793D313030293B5C6E2020637572736F723A';
wwv_flow_api.g_varchar2_table(46) := '20706F696E7465723B5C6E7D5C6E23746F6173742D636F6E7461696E6572203E202E746F6173742D696E666F207B5C6E20206261636B67726F756E642D696D6167653A2075726C285C22646174613A696D6167652F706E673B6261736536342C6956424F';
wwv_flow_api.g_varchar2_table(47) := '5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744';
wwv_flow_api.g_varchar2_table(48) := '416364767147514141414777535552425645684C745A613953674E42454D63397355787852636F554B537A535749685870464D68685957466861426734795059695743585A78424C4552734C52533345516B456677434B646A574A4177534B43676F4B43';
wwv_flow_api.g_varchar2_table(49) := '63756476344F35594C727437457A6758686955332F342B6232636B6D77566A4A53704B6B513677416934677768542B7A3377524263457A30796A53736555547263527966734873586D4430416D62484F433949693856496D6E75584250676C4870513577';
wwv_flow_api.g_varchar2_table(50) := '7753564D37734E6E5447375A61344A774464436A7879416948336E7941326D7461544A756669445A35644361716C4974494C68314E486174664E35736B766A78395A33386D363943677A75586D5A675672504947453736334A7839714B73526F7A575977';
wwv_flow_api.g_varchar2_table(51) := '36784F486445522B6E6E324B6B4F2B42622B55563543424E36574336517442676252566F7A72616841626D6D364874557367745043313974466478585A59424F666B626D464A3156614841315641486A6430707037306F545A7A76522B45567278325967';
wwv_flow_api.g_varchar2_table(52) := '6664737136657535354248595238686C636B692B6E2B6B4552554647384272413042776A654176324D38574C51427463792B534436664E736D6E4233416C424C726754745657316332514E346256574C415461495336304A32447535793154694A676A53';
wwv_flow_api.g_varchar2_table(53) := '427646565A67546D7743552B64415A466F507847454573386E79484339427765324776454A763257585A6230766A647946543443786B33652F6B49716C4F476F564C7777506576705948542B3030542B68577758446634414A414F557157634468627741';
wwv_flow_api.g_varchar2_table(54) := '414141415355564F524B35435949493D5C22292021696D706F7274616E743B5C6E7D5C6E23746F6173742D636F6E7461696E6572203E202E746F6173742D6572726F72207B5C6E20206261636B67726F756E642D696D6167653A2075726C285C22646174';
wwv_flow_api.g_varchar2_table(55) := '613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A77763859';
wwv_flow_api.g_varchar2_table(56) := '5155414141414A6345685A6377414144734D414141374441636476714751414141484F535552425645684C725A612F53674E42454D5A7A6830574B43436C53434B6149594F45442B41414B6551514C473848577A744C43496D4272596164674964592B67';
wwv_flow_api.g_varchar2_table(57) := '494B4E596B42465377753743416F7143676B6B6F4742492F4532385064624C5A6D65444C677A5A7A637838332F7A5A3253535843316A3966722B49314871393367327978483469774D31766B6F4257416478436D707A5478666B4E325263795A4E614846';
wwv_flow_api.g_varchar2_table(58) := '496B536F31302B386B67786B584955525635484778546D467563373542325266516B707848473861416761414661307441487159466651374977653279684F446B382B4A34433779416F5254574933772F346B6C47526752346C4F3752706E392B67764D';
wwv_flow_api.g_varchar2_table(59) := '7957702B75784668382B482B41526C674E316E4A754A75514159764E6B456E774746636B31384572347133656745632F6F4F2B6D684C644B67527968644E466961634330726C4F4362684E567A344839466E41596744427655335149696F5A6C4A464C4A';
wwv_flow_api.g_varchar2_table(60) := '74736F4859524466695A6F557949787143745270566C414E71304555346441706A727467657A504661643553313957676A6B6330684E566E754634486A56413643375172534962796C422B6F5A65336148674273716C4E714B594834386A58794A4B4D75';
wwv_flow_api.g_varchar2_table(61) := '41626979564A384B7A61423365526330706739567751346E6946727949363871694F693341626A776473666E41746B3062436A544C4A4B72366D724439673869712F532F4238316867754F4D6C51546E56794734307741636A6E6D6773434E455344726A';
wwv_flow_api.g_varchar2_table(62) := '6D653777666674503450375350344E33434A5A64767A6F4E79477132632F48574F584A47737656672B52412F6B324D432F774E364932594132507438476B41414141415355564F524B35435949493D5C22292021696D706F7274616E743B5C6E7D5C6E23';
wwv_flow_api.g_varchar2_table(63) := '746F6173742D636F6E7461696E6572203E202E746F6173742D73756363657373207B5C6E20206261636B67726F756E642D696D6167653A2075726C285C22646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E';
wwv_flow_api.g_varchar2_table(64) := '535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414473';
wwv_flow_api.g_varchar2_table(65) := '535552425645684C593241594266514D67662F2F2F3350382B2F657641496776412F467349462B426176594444574D4247726F61534D4D42694538564337415A44724946614D466E696933415A546A556773555557554441384F64414836695162514568';
wwv_flow_api.g_varchar2_table(66) := '7734487947735045634B425842494334415268657834473442736A6D77655531736F49466147672F57746F465A52495A644576494D68786B43436A5849567341545636674647414373345273773045476749494833514A594A6748534152515A44725741';
wwv_flow_api.g_varchar2_table(67) := '422B6A61777A67732B5132554F343944376A6E525352476F454652494C63646D454D57474930636D304A4A325170594131524476636D7A4A455768414268442F7071724C30533043577541424B676E526B69396C4C736553376732416C7177485751534B';
wwv_flow_api.g_varchar2_table(68) := '48346F4B4C72494C7052476845514377324C6952554961346C7741414141424A52553545726B4A6767673D3D5C22292021696D706F7274616E743B5C6E7D5C6E23746F6173742D636F6E7461696E6572203E202E746F6173742D7761726E696E67207B5C';
wwv_flow_api.g_varchar2_table(69) := '6E20206261636B67726F756E642D696D6167653A2075726C285C22646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E';
wwv_flow_api.g_varchar2_table(70) := '535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414759535552425645684C355A537654734E51464D62585A4749434D5947596D4A684151494A';
wwv_flow_api.g_varchar2_table(71) := '41494359515041414369534442384169494351514A54344371514577674A76594153415143695A69596D4A6841494241544341524A792B397254736C646438734B75314D302B644C6230353776362F6C62712F32724B306D532F54524E6A3963574E414B';
wwv_flow_api.g_varchar2_table(72) := '5059494A494937674978436351353163767149442B4749455838415347344231624B3567495A466551666F4A6445584F6667583451415167376B4832413635795138376C79786232377367676B417A41754668626267314B326B67436B42316256777949';
wwv_flow_api.g_varchar2_table(73) := '52396D324C37505250496844554958674774794B77353735797A336C544E733658344A586E6A562B4C4B4D2F6D334D79646E5462744F4B496A747A3656684342713476536D336E63647244326C6B305667555853564B6A56444A584A7A696A5731525164';
wwv_flow_api.g_varchar2_table(74) := '7355374637374865387536386B6F4E5A547A384F7A35794761364A3348336C5A3078596758424B3251796D6C5757412B52576E5968736B4C427632766D452B68424D43746241374B58356472577952542F324A73715A32497666423959346257444E4D46';
wwv_flow_api.g_varchar2_table(75) := '624A52466D4339453734536F53304371756C776A6B43302B356270635631435A384E4D656A34706A7930552B646F44517347796F31687A564A7474496A685137476E427452464E31556172556C48384633786963742B4859303772457A6F5547506C5763';
wwv_flow_api.g_varchar2_table(76) := '6A52465272342F6743685A6763335A4C3264386F41414141415355564F524B35435949493D5C22292021696D706F7274616E743B5C6E7D5C6E23746F6173742D636F6E7461696E6572202E746F6173742D7469746C65207B5C6E2020666F6E742D776569';
wwv_flow_api.g_varchar2_table(77) := '6768743A203730303B5C6E2020666F6E742D73697A653A20312E3972656D3B5C6E202070616464696E672D626F74746F6D3A203870783B5C6E7D5C6E23746F6173742D636F6E7461696E65722E746F6173742D746F702D63656E746572203E206469762C';
wwv_flow_api.g_varchar2_table(78) := '5C6E23746F6173742D636F6E7461696E65722E746F6173742D626F74746F6D2D63656E746572203E20646976207B5C6E202077696474683A2033303070783B5C6E20206D617267696E2D6C6566743A206175746F3B5C6E20206D617267696E2D72696768';
wwv_flow_api.g_varchar2_table(79) := '743A206175746F3B5C6E7D5C6E23746F6173742D636F6E7461696E65722E746F6173742D746F702D66756C6C2D7769647468203E206469762C5C6E23746F6173742D636F6E7461696E65722E746F6173742D626F74746F6D2D66756C6C2D776964746820';
wwv_flow_api.g_varchar2_table(80) := '3E20646976207B5C6E202077696474683A203936253B5C6E20206D617267696E2D6C6566743A206175746F3B5C6E20206D617267696E2D72696768743A206175746F3B5C6E7D5C6E2E746F617374207B5C6E20206261636B67726F756E642D636F6C6F72';
wwv_flow_api.g_varchar2_table(81) := '3A20233033303330333B5C6E7D5C6E2E746F6173742D73756363657373207B5C6E20206261636B67726F756E642D636F6C6F723A20233342414132433B5C6E7D5C6E2E746F6173742D6572726F72207B5C6E20206261636B67726F756E642D636F6C6F72';
wwv_flow_api.g_varchar2_table(82) := '3A20234634343333363B5C6E7D5C6E2E746F6173742D696E666F207B5C6E20206261636B67726F756E642D636F6C6F723A20233030373664663B5C6E7D5C6E2E746F6173742D7761726E696E67207B5C6E20206261636B67726F756E642D636F6C6F723A';
wwv_flow_api.g_varchar2_table(83) := '20234638393430363B5C6E7D5C6E2E746F6173742D70726F6772657373207B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E20206C6566743A20303B5C6E2020626F74746F6D3A20303B5C6E20206865696768743A203470783B5C6E2020';
wwv_flow_api.g_varchar2_table(84) := '6261636B67726F756E642D636F6C6F723A20233030303030303B5C6E20206F7061636974793A20302E343B5C6E20202D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E416C706861284F';
wwv_flow_api.g_varchar2_table(85) := '7061636974793D3430293B5C6E202066696C7465723A20616C706861286F7061636974793D3430293B5C6E7D5C6E2F2A526573706F6E736976652044657369676E2A2F5C6E406D6564696120616C6C20616E6420286D61782D77696474683A2032343070';
wwv_flow_api.g_varchar2_table(86) := '7829207B5C6E202023746F6173742D636F6E7461696E6572203E20646976207B5C6E2020202070616464696E673A20387078203870782038707820353070783B5C6E2020202077696474683A203131656D3B5C6E202020206D61782D77696474683A2031';
wwv_flow_api.g_varchar2_table(87) := '31656D3B5C6E20207D5C6E202023746F6173742D636F6E7461696E6572203E206469762E72746C207B5C6E2020202070616464696E673A20387078203530707820387078203870783B5C6E20207D5C6E202023746F6173742D636F6E7461696E6572202E';
wwv_flow_api.g_varchar2_table(88) := '746F6173742D636C6F73652D627574746F6E207B5C6E2020202072696768743A202D302E32656D3B5C6E20202020746F703A202D302E32656D3B5C6E20207D5C6E202023746F6173742D636F6E7461696E6572202E72746C202E746F6173742D636C6F73';
wwv_flow_api.g_varchar2_table(89) := '652D627574746F6E207B5C6E202020206C6566743A202D302E32656D3B5C6E2020202072696768743A20302E32656D3B5C6E20207D5C6E7D5C6E406D6564696120616C6C20616E6420286D696E2D77696474683A2032343170782920616E6420286D6178';
wwv_flow_api.g_varchar2_table(90) := '2D77696474683A20343830707829207B5C6E202023746F6173742D636F6E7461696E6572203E20646976207B5C6E2020202070616464696E673A20387078203870782038707820353070783B5C6E2020202077696474683A203138656D3B5C6E20202020';
wwv_flow_api.g_varchar2_table(91) := '6D61782D77696474683A203138656D3B5C6E20207D5C6E202023746F6173742D636F6E7461696E6572203E206469762E72746C207B5C6E2020202070616464696E673A20387078203530707820387078203870783B5C6E20207D5C6E202023746F617374';
wwv_flow_api.g_varchar2_table(92) := '2D636F6E7461696E6572202E746F6173742D636C6F73652D627574746F6E207B5C6E2020202072696768743A202D302E32656D3B5C6E20202020746F703A202D302E32656D3B5C6E20207D5C6E202023746F6173742D636F6E7461696E6572202E72746C';
wwv_flow_api.g_varchar2_table(93) := '202E746F6173742D636C6F73652D627574746F6E207B5C6E202020206C6566743A202D302E32656D3B5C6E2020202072696768743A20302E32656D3B5C6E20207D5C6E7D5C6E406D6564696120616C6C20616E6420286D696E2D77696474683A20343831';
wwv_flow_api.g_varchar2_table(94) := '70782920616E6420286D61782D77696474683A20373638707829207B5C6E202023746F6173742D636F6E7461696E6572203E20646976207B5C6E2020202070616464696E673A20313570782031357078203135707820353070783B5C6E20202020776964';
wwv_flow_api.g_varchar2_table(95) := '74683A203235656D3B5C6E202020206D61782D77696474683A203235656D3B5C6E20207D5C6E202023746F6173742D636F6E7461696E6572203E206469762E72746C207B5C6E2020202070616464696E673A203135707820353070782031357078203135';
wwv_flow_api.g_varchar2_table(96) := '70783B5C6E20207D5C6E7D5C6E225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(18897002461284291)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_file_name=>'css/toastr.css.map'
,p_mime_type=>'application/json'
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


