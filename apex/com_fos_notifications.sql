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
--     PLUGIN: 1039471776506160903
--     PLUGIN: 547902228942303344
--     PLUGIN: 217651153971039957
--     PLUGIN: 412155278231616931
--     PLUGIN: 1389837954374630576
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 216426771609128043
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 183507938916453268
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
--     PLUGIN: 212503470416800524
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
'    l_errors_as_warnings     boolean                            := instr(p_plugin.attribute_06, ''errors-as-warnings'') > 0;',
'    l_default_dismiss_after  pls_integer                        := apex_plugin_util.replace_substitutions(p_plugin.attribute_07);',
'',
'    -- general attributes',
'    l_action                p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_message_type          p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_static_title          p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'    l_static_message        p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    l_js_title_code         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    l_js_message_code       p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_override_defaults     boolean                            := nvl(p_dynamic_action.attribute_09,''N'') = ''Y'';',
' ',
'    l_options               apex_t_varchar2 := apex_string.split(case when l_override_defaults then p_dynamic_action.attribute_07 else l_default_options end, '':'');    ',
'    ',
'    -- options',
'    l_auto_dismiss          boolean  := ''autodismiss''               member of l_options;',
'    l_escape                boolean  := ''escape-html''               member of l_options;',
'    l_auto_dismiss_success  boolean  := ''autodismiss-success''       member of l_options;',
'    l_auto_dismiss_warning  boolean  := ''autodismiss-warning''       member of l_options;',
'    l_auto_dismiss_error    boolean  := ''autodismiss-error''         member of l_options;',
'    l_auto_dismiss_info     boolean  := ''autodismiss-info''          member of l_options;',
'    l_client_substitutions  boolean  := ''client-side-substitutions'' member of l_options;',
'    l_clear_all             boolean  := ''remove-notifications''      member of l_options;',
'    l_show_dismiss_button   boolean  := ''dismiss-on-button''         member of l_options;',
'    l_dismiss_on_click      boolean  := ''dismiss-on-click''          member of l_options;',
'    l_newest_on_top         boolean  := ''newest-on-top''             member of l_options;',
'    l_prevent_duplicates    boolean  := ''prevent-duplicates''        member of l_options;',
'    l_inline_item_error     boolean  := p_dynamic_action.attribute_12 is not null;',
'    l_position              p_dynamic_action.attribute_08%type := case when l_override_defaults then p_dynamic_action.attribute_08 else l_default_position end;',
'    l_icon_override         p_dynamic_action.attribute_10%type := case when l_override_defaults then p_dynamic_action.attribute_10 else null end;',
'    l_icon                  p_dynamic_action.attribute_10%type;',
'    l_auto_dismiss_after    pls_integer                        := case when l_override_defaults then apex_plugin_util.replace_substitutions(p_dynamic_action.attribute_11) else l_default_dismiss_after end;',
'    l_page_items            p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;',
'    l_replace_errors_with   p_dynamic_action.attribute_13%type := nvl(p_dynamic_action.attribute_13, ''warning''); -- only used in case of Convert Native APEX Notifications',
'        ',
'    -- Javascript Initialization Code',
'    l_init_js_fn            varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), ''undefined'');',
'',
'begin',
'    ',
'    -- debug info',
'    if apex_application.g_debug and substr(:DEBUG,6) >= 6 ',
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
'    -- if we haven''t overridden the defaults then what is the component setting',
'    if not l_override_defaults then',
'        l_auto_dismiss :=',
'            case l_action',
'              when ''success'' then l_auto_dismiss_success',
'              when ''warning'' then l_auto_dismiss_warning',
'              when ''error''   then l_auto_dismiss_error',
'              when ''info''    then l_auto_dismiss_info',
'              else false',
'            end;',
'    end if;',
'        ',
'    -- define our JSON config',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    -- notification plugin settings',
'    apex_json.write(''type''             , l_action);',
'',
'    if l_action != ''clear-all'' ',
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
'                case l_action',
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
'        apex_json.write(''iconClass''        , apex_plugin_util.replace_substitutions(l_icon));',
'        apex_json.write(''replaceErrorsWith'', l_replace_errors_with);',
'        apex_json.close_object;',
'        ',
'        if l_action in (''success'', ''info'', ''warning'', ''error'')',
'        then',
'',
'            -- additional error information for page items',
'            apex_json.write(''inlineItemErrors'' , l_inline_item_error);',
'        ',
'            if l_inline_item_error ',
'            then',
'                apex_json.write(''inlinePageItems'', trim(both '','' from trim(l_page_items)));',
'            end if;',
'',
'            -- notification message',
'            if l_message_type =  ''static'' ',
'            then',
'                apex_json.write(''title''        , case when l_client_substitutions then l_static_title   else apex_plugin_util.replace_substitutions(l_static_title)   end);',
'                apex_json.write(''message''      , case when l_client_substitutions then l_static_message else apex_plugin_util.replace_substitutions(l_static_message) end);',
'            else',
'                if l_js_title_code is not null ',
'                then',
'                    apex_json.write_raw',
'                      ( p_name  => ''title''',
'                      , p_value => case l_message_type',
'                           when ''javascript-expression'' then',
'                              ''function(){return ('' || l_js_title_code || '');}''',
'                           when ''javascript-function-body'' then',
'                               l_js_title_code',
'                           end',
'                      );',
'                end if;',
'',
'                apex_json.write_raw',
'                  ( p_name  => ''message''',
'                  , p_value => case l_message_type',
'                       when ''javascript-expression'' then',
'                          ''function(){return ('' || l_js_message_code || '');}''',
'                       when ''javascript-function-body'' then',
'                           l_js_message_code',
'                       end',
'                  );',
'            end if; ',
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
'    Using this dynamic action you can show multiple messages of each type, customize them by setting their icon, position, how they are dismissed, and more.',
'</p>',
'<p>',
'    You can derive the message using static text with substitution support or from a Javascript expression or function. You can use HTML in the message or escape HTML for tighter security. You can see a wide range of examples below:',
'</p>'))
,p_version_identifier=>'22.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>470
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
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(41635354303088806)
,p_plugin_attribute_id=>wwv_flow_api.id(41622854556078463)
,p_display_sequence=>120
,p_display_value=>'[External] Replace APEX Errors with FOS Warnings'
,p_return_value=>'show-errors-as-warnings'
,p_help_text=>'This attribute is not yet in use'
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
'<p>Select the type of action to execute. You can show a notification, whereby: each type has a specific default colour assigned e.g.</p>',
'<ul>',
'<li>Success -&gt; Green</li>',
'<li>Info -&gt; Blue</li>',
'<li>Warning -&gt; Orange</li>',
'<li>Error -&gt; Red</li>',
'</ul><div><b>Note:</b> these colours can be changed using the themeroller (extra setup required) or using CSS overrides. Please refer to the demo application for more details.</div>',
'<p>You can also choose to clear all notifications, or convert the native APEX notifications to FOS notifications.</p>'))
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
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(77746510837708911)
,p_plugin_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_display_sequence=>60
,p_display_value=>'Convert Native APEX Notifications'
,p_return_value=>'convert'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(

'<p>Replace the native APEX notifications with their FOS counterparts. This allows notifications generated by APEX, or via the <code>apex.message</code> API to benefit from the same FOS Notifications enhancements such as autodismiss, click to dismiss,'
||' custom positions, etc.</p>',
'<p>It is best to instantiate this plug-in with this option once, on the global page, on page load.</p>',
'<p>This will convert all APEX notifications, application wide, to FOS notifications.</p>'))
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
,p_depending_on_condition_type=>'NOT_IN_LIST'
,p_depending_on_expression=>'clear-all,convert'
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
end;
/
begin
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
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(77790772561776936)
,p_plugin_id=>wwv_flow_api.id(13235263798301758)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Replace Errors With'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'warning'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(13261281157409464)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'convert'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>By default APEX "errors" are actually "warnings" in that they are orange, not red. FOS - Notifications however supports both warnings and errors. Choose to which type of FOS notifications an APEX error should be mapped.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(77801673592778329)
,p_plugin_attribute_id=>wwv_flow_api.id(77790772561776936)
,p_display_sequence=>10
,p_display_value=>'FOS Warnings'
,p_return_value=>'warning'
,p_help_text=>'Map erros to FOS warnings - orange'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(77802017877780504)
,p_plugin_attribute_id=>wwv_flow_api.id(77790772561776936)
,p_display_sequence=>20
,p_display_value=>'FOS Errors'
,p_return_value=>'error'
,p_help_text=>'Map erros to FOS errors - red'
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
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C7320617065782C666F7374722C24202A2F0A0A76617220464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E7574696C73203D20464F532E7574696C73207C7C207B7D3B0A0A2F2A2A0A202A20436F6E76657274';
wwv_flow_api.g_varchar2_table(2) := '7320746865206E61746976652041504558206E6F74696669636174696F6E7320746F20464F53206E6F74696669636174696F6E730A202A2F0A464F532E7574696C732E636F6E766572744E61746976654E6F74696669636174696F6E73203D2066756E63';
wwv_flow_api.g_varchar2_table(3) := '74696F6E286F7074696F6E73297B0A0A202020202F2F207265706C6163696E6720616E792073756363657373206E6F74696669636174696F6E20776869636820697320616C72656164792070617274206F662074686520646F6D206F6E2070616765206C';
wwv_flow_api.g_varchar2_table(4) := '6F61640A202020202F2F206572726F72206D6573736167657320617265206E657665722070617274206F66207468652070616765206F6E2070616765206C6F61640A2020202076617220737563636573734E6F746966456C656D24203D20242827234150';
wwv_flow_api.g_varchar2_table(5) := '45585F535543434553535F4D45535341474527293B0A0A20202020696628737563636573734E6F746966456C656D242E697328273A76697369626C652729297B0A2020202020202020666F7374725B2773756363657373275D282428272E742D416C6572';
wwv_flow_api.g_varchar2_table(6) := '742D7469746C65272C20737563636573734E6F746966456C656D24292E7465787428292C206E756C6C2C206F7074696F6E73293B0A2020202020202020617065782E6D6573736167652E68696465506167655375636365737328293B0A202020207D0A0A';
wwv_flow_api.g_varchar2_table(7) := '202020202F2F207265706C6163696E6720616E792073756273657175656E74206E6F74696669636174696F6E730A20202020617065782E6D6573736167652E7365745468656D65486F6F6B73287B0A20202020202020206265666F726553686F773A2066';
wwv_flow_api.g_varchar2_table(8) := '756E6374696F6E2820704D7367547970652C2070456C656D656E742420297B0A2020202020202020202020206966202820704D736754797065203D3D3D20617065782E6D6573736167652E545950452E535543434553532029207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(9) := '2020202020202020766172206D657373616765456C656D24203D202428272E742D416C6572742D7469746C65272C2070456C656D656E7424293B0A20202020202020202020202020202020766172206D657373616765203D206D657373616765456C656D';
wwv_flow_api.g_varchar2_table(10) := '242E7465787428293B0A20202020202020202020202020202020666F7374725B2773756363657373275D286D6573736167652C206E756C6C2C206F7074696F6E73293B0A202020202020202020202020202020202F2F20656E7375726573204150455820';
wwv_flow_api.g_varchar2_table(11) := '6E6F74696669636174696F6E20646F65736E27742073686F770A2020202020202020202020202020202072657475726E2066616C73653B0A2020202020202020202020207D20656C73652069662028704D736754797065203D3D3D20617065782E6D6573';
wwv_flow_api.g_varchar2_table(12) := '736167652E545950452E4552524F52297B0A20202020202020202020202020202020766172207469746C65203D202428272E612D4E6F74696669636174696F6E2D7469746C65272C2070456C656D656E7424292E7465787428293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(13) := '2020202020202020766172206D657373616765456C656D24203D202428272E612D4E6F74696669636174696F6E2D6C697374272C2070456C656D656E7424292E636C6F6E6528293B0A202020202020202020202020202020200A20202020202020202020';
wwv_flow_api.g_varchar2_table(14) := '20202020202076617220746F61737472456C656D24203D20666F7374725B6F7074696F6E732E7265706C6163654572726F7273576974685D286D657373616765456C656D242C207469746C652C206F7074696F6E73293B0A0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(15) := '20202020202F2F2076657279206F6674656E2041504558206E6174697665206E6F74696669636174696F6E732068617665206275696C742D696E206C696E6B7320746F206E6176696761746520746F20746865206572726F6E656F7573206974656D0A20';
wwv_flow_api.g_varchar2_table(16) := '2020202020202020202020202020202F2F206F72206120627574746F6E20746F2073686F77206D6F726520696E666F206F6E20746865206572726F7220287768656E20636F6D696E672066726F6D2074686520736572766572290A202020202020202020';
wwv_flow_api.g_varchar2_table(17) := '202020202020202F2F20746865206576656E742068616E646C657273206F6E20746865736520656C656D656E74732061726520717569746520747269636B7920616E64206E6F742070617274206F662074686520656C656D656E74207468617420776520';
wwv_flow_api.g_varchar2_table(18) := '6A75737420636C6F6E65642E0A202020202020202020202020202020202F2F2074686520666F6C6C6F77696E6720706173736573206261636B207375636820636C69636B206576656E747320696E746F207468656972206F726967696E616C20656C656D';
wwv_flow_api.g_varchar2_table(19) := '656E74730A202020202020202020202020202020202F2F207768696368206172652061637475616C6C79207374696C6C206F6E2074686520706167652C206A7573742068696464656E0A2020202020202020202020202020202076617220616C6C4E6F74';
wwv_flow_api.g_varchar2_table(20) := '696669636174696F6E4C696E6B7324203D20746F61737472456C656D242E66696E6428272E612D4E6F74696669636174696F6E2D6C696E6B27293B0A20202020202020202020202020202020616C6C4E6F74696669636174696F6E4C696E6B73242E6F6E';
wwv_flow_api.g_varchar2_table(21) := '2827636C69636B272C2066756E6374696F6E286576656E74297B0A202020202020202020202020202020202020202076617220696E646578203D20616C6C4E6F74696669636174696F6E4C696E6B73242E696E6465782824287468697329293B0A202020';
wwv_flow_api.g_varchar2_table(22) := '20202020202020202020202020202020202428272E612D4E6F74696669636174696F6E2D6C696E6B272C2024282723415045585F4552524F525F4D4553534147452729295B696E6465785D2E747269676765722827636C69636B27293B0A202020202020';
wwv_flow_api.g_varchar2_table(23) := '202020202020202020207D293B0A0A2020202020202020202020202020202076617220616C6C44657461696C427574746F6E7324203D20746F61737472456C656D242E66696E6428272E6A732D73686F7744657461696C7327293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(24) := '2020202020202020616C6C44657461696C427574746F6E73242E6F6E2827636C69636B272C2066756E6374696F6E286576656E74297B0A202020202020202020202020202020202020202076617220696E646578203D20616C6C44657461696C42757474';
wwv_flow_api.g_varchar2_table(25) := '6F6E73242E696E6465782824287468697329293B0A20202020202020202020202020202020202020202428272E6A732D73686F7744657461696C73272C2024282723415045585F4552524F525F4D4553534147452729295B696E6465785D2E7472696767';
wwv_flow_api.g_varchar2_table(26) := '65722827636C69636B27293B0A202020202020202020202020202020207D293B0A0A202020202020202020202020202020202F2F20656E73757265732041504558206E6F74696669636174696F6E20646F65736E27742073686F770A2020202020202020';
wwv_flow_api.g_varchar2_table(27) := '202020202020202072657475726E2066616C73653B0A2020202020202020202020207D0A20202020202020207D2C0A20202020202020206265666F7265486964653A2066756E6374696F6E28612C62297B0A2020202020202020202020202F2F20627920';
wwv_flow_api.g_varchar2_table(28) := '64656661756C742C20415045582077696C6C20636C65617220616C6C2070726576696F7573206E6F74696669636174696F6E73207768656E2073686F77696E672061206E6577206F6E650A2020202020202020202020202F2F2077652077696C6C207265';
wwv_flow_api.g_varchar2_table(29) := '737065637420746861742C20616E6420616C736F20636C6561722074686520464F53206E6F74696669636174696F6E730A202020202020202020202020666F7374722E636C656172416C6C28293B0A20202020202020207D0A202020207D293B0A7D0A0A';
wwv_flow_api.g_varchar2_table(30) := '2F2A2A0A202A20412064796E616D696320616374696F6E20746F20656173696C7920637265617465206E6F74696669636174696F6E206D6573736167657320696E20415045582E204974206973206261736564206F6E2074686520546F61737472206F70';
wwv_flow_api.g_varchar2_table(31) := '656E20736F75726365206A517565727920706C7567696E0A202A0A202A2040706172616D207B6F626A6563747D2020206461436F6E7465787420202020202044796E616D696320416374696F6E20636F6E746578742061732070617373656420696E2062';
wwv_flow_api.g_varchar2_table(32) := '7920415045580A202A2040706172616D207B6F626A6563747D202020636F6E666967202020202020202020436F6E66696775726174696F6E206F626A65637420686F6C64696E6720746865206E6F74696669636174696F6E2073657474696E67730A202A';
wwv_flow_api.g_varchar2_table(33) := '2040706172616D207B737472696E677D202020636F6E6669672E74797065202020205468652074797065206F6620616374696F6E20746F2062652074616B656E2E205B737563636573737C6572726F727C7761726E696E677C696E666F7C636C6561722D';
wwv_flow_api.g_varchar2_table(34) := '616C6C7C636F6E766572745D0A202A2040706172616D207B66756E6374696F6E7D205B696E6974466E5D202020202020204A5320696E697469616C697A6174696F6E2066756E6374696F6E2077686963682077696C6C20616C6C6F7720796F7520746F20';
wwv_flow_api.g_varchar2_table(35) := '6F766572726964652073657474696E6773207269676874206265666F726520746865206E6F746966696361746F6E2069732073656E740A202A2F0A464F532E7574696C732E6E6F74696669636174696F6E203D2066756E6374696F6E20286461436F6E74';
wwv_flow_api.g_varchar2_table(36) := '6578742C20636F6E6669672C20696E6974466E29207B0A20202020766172206D6573736167652C207469746C653B0A0A202020202F2F20706172616D6574657220636865636B730A202020206461436F6E74657874203D206461436F6E74657874207C7C';
wwv_flow_api.g_varchar2_table(37) := '20746869733B0A20202020636F6E666967203D20636F6E666967207C7C207B7D3B0A20202020636F6E6669672E74797065203D20636F6E6669672E74797065207C7C2027696E666F273B0A0A20202020617065782E64656275672E696E666F2827464F53';
wwv_flow_api.g_varchar2_table(38) := '202D204E6F74696669636174696F6E73272C20636F6E666967293B0A0A202020202F2F206561726C79206578697420696620776520617265206A75737420636C656172696E6720746865206E6F74696669636174696F6E730A2020202069662028636F6E';
wwv_flow_api.g_varchar2_table(39) := '6669672E74797065203D3D3D2027636C6561722D616C6C2729207B0A2020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A202020202020202072657475726E20666F7374722E636C656172416C6C28293B0A202020';
wwv_flow_api.g_varchar2_table(40) := '207D0A0A202020202F2F206561726C79206578697420696620776520617265206A75737420636F6E76657274696E67207468652041504558206E6F74696669636174696F6E730A2020202069662028636F6E6669672E74797065203D3D3D2027636F6E76';
wwv_flow_api.g_varchar2_table(41) := '65727427297B0A2020202020202020464F532E7574696C732E636F6E766572744E61746976654E6F74696669636174696F6E7328636F6E6669672E6F7074696F6E73293B0A202020202020202072657475726E3B0A202020207D0A0A202020202F2F2064';
wwv_flow_api.g_varchar2_table(42) := '6566696E65206F7572206D6573736167652064657461696C73207768696368206D61792064796E616D6963616C6C7920636F6D652066726F6D2061204A6176617363726970742063616C6C0A2020202069662028636F6E6669672E6D6573736167652069';
wwv_flow_api.g_varchar2_table(43) := '6E7374616E63656F662046756E6374696F6E29207B0A20202020202020206D657373616765203D20636F6E6669672E6D6573736167652E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D20656C7365207B0A20202020202020';
wwv_flow_api.g_varchar2_table(44) := '206D657373616765203D20636F6E6669672E6D6573736167653B0A202020207D0A0A2020202069662028636F6E6669672E7469746C6520696E7374616E63656F662046756E6374696F6E29207B0A20202020202020207469746C65203D20636F6E666967';
wwv_flow_api.g_varchar2_table(45) := '2E7469746C652E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D20656C7365207B0A20202020202020207469746C65203D20636F6E6669672E7469746C653B0A202020207D0A0A202020202F2F2077652077696C6C206E6F74';
wwv_flow_api.g_varchar2_table(46) := '20706572666F726D2061206E6F74696669636174696F6E206966206F7572206D65737361676520626F6479206973206E756C6C2F656D70747920737472696E670A2020202069662028216D65737361676520262620217469746C65292072657475726E3B';
wwv_flow_api.g_varchar2_table(47) := '0A0A202020202F2F20205265706C6163696E6720737562737469747574696F6E20737472696E67730A2020202069662028636F6E6669672E7375627374697475746556616C75657329207B0A20202020202020202F2F2020576520646F6E277420657363';
wwv_flow_api.g_varchar2_table(48) := '61706520746865206D6573736167652062792064656661756C742E205765206C65742074686520646576656C6F70657220646563696465207768657468657220746F206573636170650A20202020202020202F2F20207468652077686F6C65206D657373';
wwv_flow_api.g_varchar2_table(49) := '6167652C206F72206A75737420696E76696475616C2070616765206974656D73207669612026504147455F4954454D2148544D4C2E0A2020202020202020696620287469746C6529207B0A2020202020202020202020207469746C65203D20617065782E';
wwv_flow_api.g_varchar2_table(50) := '7574696C2E6170706C7954656D706C617465287469746C652C207B0A2020202020202020202020202020202064656661756C7445736361706546696C7465723A206E756C6C0A2020202020202020202020207D293B0A20202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(51) := '20202020696620286D65737361676529207B0A2020202020202020202020206D657373616765203D20617065782E7574696C2E6170706C7954656D706C617465286D6573736167652C207B0A2020202020202020202020202020202064656661756C7445';
wwv_flow_api.g_varchar2_table(52) := '736361706546696C7465723A206E756C6C0A2020202020202020202020207D293B0A20202020202020207D0A20202020202020202F2F2077652077696C6C206E6F7420706572666F726D2061206E6F74696669636174696F6E206966206F7572206D6573';
wwv_flow_api.g_varchar2_table(53) := '7361676520626F6479206973206E756C6C2F656D70747920737472696E67206166746572200A20202020202020202F2F20737562737469747574696F6E7320617265206D61646520616E6420746865206D65737361676520697320656D7074790A202020';

wwv_flow_api.g_varchar2_table(54) := '202020202069662028216D65737361676520262620217469746C65292072657475726E3B0A202020207D0A0A202020202F2F20446566696E65206F7572206E6F74696669636174696F6E2073657474696E67730A2020202076617220666F7374724F7074';
wwv_flow_api.g_varchar2_table(55) := '696F6E73203D20242E657874656E64287B7D2C20636F6E6669672E6F7074696F6E73293B0A0A202020202F2F20416C6C6F772074686520646576656C6F70657220746F20706572666F726D20616E79206C617374202863656E7472616C697A6564292063';
wwv_flow_api.g_varchar2_table(56) := '68616E676573207573696E67204A61766173637269707420496E697469616C697A6174696F6E20436F64652073657474696E670A2020202069662028696E6974466E20696E7374616E63656F662046756E6374696F6E29207B0A2020202020202020696E';
wwv_flow_api.g_varchar2_table(57) := '6974466E2E63616C6C286461436F6E746578742C20666F7374724F7074696F6E73293B0A202020207D0A0A202020202F2F20617373636F6169746520616E7920696E6C696E652070616765206974656D206572726F72730A2020202069662028636F6E66';
wwv_flow_api.g_varchar2_table(58) := '69672E696E6C696E654974656D4572726F727320262620636F6E6669672E696E6C696E65506167654974656D7329207B0A2020202020202020636F6E6669672E696E6C696E65506167654974656D732E73706C697428272C27292E666F72456163682866';
wwv_flow_api.g_varchar2_table(59) := '756E6374696F6E28706167654974656D29207B0A2020202020202020202020202F2F2053686F77206F75722041504558206572726F72206D6573736167650A202020202020202020202020617065782E6D6573736167652E73686F774572726F7273287B';
wwv_flow_api.g_varchar2_table(60) := '0A20202020202020202020202020202020747970653A20276572726F72272C0A202020202020202020202020202020206C6F636174696F6E3A2027696E6C696E65272C0A20202020202020202020202020202020706167654974656D3A20706167654974';
wwv_flow_api.g_varchar2_table(61) := '656D2C0A202020202020202020202020202020206D6573736167653A206D6573736167652C0A202020202020202020202020202020202F2F616E79206573636170696E6720697320617373756D656420746F2068617665206265656E20646F6E65206279';
wwv_flow_api.g_varchar2_table(62) := '206E6F770A20202020202020202020202020202020756E736166653A2066616C73650A2020202020202020202020207D293B0A20202020202020207D293B0A202020207D0A0A202020202F2F20506572666F726D207468652061637475616C206E6F7469';
wwv_flow_api.g_varchar2_table(63) := '6669636174696F6E0A20202020666F7374725B636F6E6669672E747970655D286D6573736167652C207469746C652C20666F7374724F7074696F6E73293B0A7D3B0A';
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
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B22464F53222C2277696E646F77222C227574696C73222C22636F6E766572744E61746976654E6F74696669636174696F6E73222C226F';
wwv_flow_api.g_varchar2_table(2) := '7074696F6E73222C22737563636573734E6F746966456C656D24222C2224222C226973222C22666F737472222C2274657874222C2261706578222C226D657373616765222C22686964655061676553756363657373222C227365745468656D65486F6F6B';
wwv_flow_api.g_varchar2_table(3) := '73222C226265666F726553686F77222C22704D736754797065222C2270456C656D656E7424222C2254595045222C2253554343455353222C226D657373616765456C656D24222C224552524F52222C227469746C65222C22636C6F6E65222C22746F6173';
wwv_flow_api.g_varchar2_table(4) := '7472456C656D24222C227265706C6163654572726F727357697468222C22616C6C4E6F74696669636174696F6E4C696E6B7324222C2266696E64222C226F6E222C226576656E74222C22696E646578222C2274686973222C2274726967676572222C2261';
wwv_flow_api.g_varchar2_table(5) := '6C6C44657461696C427574746F6E7324222C226265666F726548696465222C2261222C2262222C22636C656172416C6C222C226E6F74696669636174696F6E222C226461436F6E74657874222C22636F6E666967222C22696E6974466E222C2274797065';
wwv_flow_api.g_varchar2_table(6) := '222C226465627567222C22696E666F222C22636C6561724572726F7273222C2246756E6374696F6E222C2263616C6C222C227375627374697475746556616C756573222C227574696C222C226170706C7954656D706C617465222C2264656661756C7445';
wwv_flow_api.g_varchar2_table(7) := '736361706546696C746572222C22666F7374724F7074696F6E73222C22657874656E64222C22696E6C696E654974656D4572726F7273222C22696E6C696E65506167654974656D73222C2273706C6974222C22666F7245616368222C2270616765497465';
wwv_flow_api.g_varchar2_table(8) := '6D222C2273686F774572726F7273222C226C6F636174696F6E222C22756E73616665225D2C226D617070696E6773223A22414145412C49414149412C4941414D432C4F41414F442C4B41414F2C4741437842412C49414149452C4D414151462C49414149';
wwv_flow_api.g_varchar2_table(9) := '452C4F4141532C47414B7A42462C49414149452C4D41414D432C3242414136422C53414153432C47414935432C49414149432C4541416F42432C454141452C794241457642442C4541416B42452C474141472C6341437042432C4D4141652C5141414546';
wwv_flow_api.g_varchar2_table(10) := '2C454141452C694241416B42442C4741416D42492C4F4141512C4B41414D4C2C47414374454D2C4B41414B432C51414151432C6D4241496A42462C4B41414B432C51414151452C634141632C4341437642432C574141592C53414155432C45414155432C';
wwv_flow_api.g_varchar2_table(11) := '47414335422C4741414B442C494141614C2C4B41414B432C514141514D2C4B41414B432C514141552C43414331432C49414349502C47414441512C45414165622C454141452C694241416B42552C4941435A502C4F414733422C4F414641442C4D414165';
wwv_flow_api.g_varchar2_table(12) := '2C51414145472C454141532C4B41414D502C4941457A422C4541434A2C47414149572C494141614C2C4B41414B432C514141514D2C4B41414B472C4D41414D2C43414335432C49414149432C45414151662C454141452C774241417942552C4741415750';
wwv_flow_api.g_varchar2_table(13) := '2C4F41433943552C45414165622C454141452C754241417742552C474141574D2C5141457044432C45414163662C4D41414D4A2C454141516F422C6D4241416D424C2C45414163452C4541414F6A422C47414F704571422C4541417742462C4541415947';
wwv_flow_api.g_varchar2_table(14) := '2C4B41414B2C774241433743442C4541417342452C474141472C534141532C53414153432C47414376432C49414149432C454141514A2C4541417342492C4D41414D76422C4541414577422C4F4143314378422C454141452C754241417742412C454141';
wwv_flow_api.g_varchar2_table(15) := '452C77424141774275422C4741414F452C514141512C59414776452C49414149432C4541416F42542C45414159472C4B41414B2C6D42414F7A432C4F414E414D2C4541416B424C2C474141472C534141532C53414153432C4741436E432C49414149432C';
wwv_flow_api.g_varchar2_table(16) := '45414151472C4541416B42482C4D41414D76422C4541414577422C4F4143744378422C454141452C6B4241416D42412C454141452C77424141774275422C4741414F452C514141512C61414933442C49414766452C574141592C53414153432C45414145';
wwv_flow_api.g_varchar2_table(17) := '432C4741476E4233422C4D41414D34422C6541616C4270432C49414149452C4D41414D6D432C614141652C53414155432C45414157432C45414151432C4741436C442C4941414937422C45414153552C454155622C4741504169422C45414159412C4741';
wwv_flow_api.g_varchar2_table(18) := '4161522C4D41437A42532C45414153412C474141552C4941435A452C4B41414F462C4541414F452C4D4141512C4F414537422F422C4B41414B67432C4D41414D432C4B41414B2C7342414175424A2C4741476E422C6341416842412C4541414F452C4B41';
wwv_flow_api.g_varchar2_table(19) := '45502C4F4144412F422C4B41414B432C5141415169432C6341434E70432C4D41414D34422C5741496A422C4741416F422C5941416842472C4541414F452C4D416D42582C47415A4939422C4541444134422C4541414F35422C6D4241416D426B432C5341';
wwv_flow_api.g_varchar2_table(20) := '4368424E2C4541414F35422C514141516D432C4B41414B522C45414157432C4741452F42412C4541414F35422C5141496A42552C454144416B422C4541414F6C422C69424141694277422C53414368424E2C4541414F6C422C4D41414D79422C4B41414B';
wwv_flow_api.g_varchar2_table(21) := '522C45414157432C4741453742412C4541414F6C422C4F414964562C47414159552C4D4147626B422C4541414F512C6D4241474831422C49414341412C45414151582C4B41414B73432C4B41414B432C6341416335422C4541414F2C4341436E4336422C';
wwv_flow_api.g_varchar2_table(22) := '6F42414171422C5141477A4276432C49414341412C45414155442C4B41414B73432C4B41414B432C6341416374432C454141532C434143764375432C6F42414171422C51414B784276432C47414159552C49416672422C43416D42412C4941414938422C';
wwv_flow_api.g_varchar2_table(23) := '4541416537432C4541414538432C4F41414F2C47414149622C4541414F6E432C5341476E436F432C6141416B424B2C5541436C424C2C4541414F4D2C4B41414B522C45414157612C47414976425A2C4541414F632C6B4241416F42642C4541414F652C69';
wwv_flow_api.g_varchar2_table(24) := '4241436C43662C4541414F652C674241416742432C4D41414D2C4B41414B432C534141512C53414153432C4741452F432F432C4B41414B432C514141512B432C574141572C43414370426A422C4B41414D2C5141434E6B422C534141552C53414356462C';
wwv_flow_api.g_varchar2_table(25) := '53414155412C4541435639432C51414153412C4541455469442C514141512C4F414D704270442C4D41414D2B422C4541414F452C4D41414D39422C45414153552C4541414F38422C53412F442F426E442C49414149452C4D41414D432C3242414132426F';
wwv_flow_api.g_varchar2_table(26) := '432C4541414F6E43222C2266696C65223A227363726970742E6A73227D';
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
wwv_flow_api.g_varchar2_table(1) := '76617220464F533D77696E646F772E464F537C7C7B7D3B464F532E7574696C733D464F532E7574696C737C7C7B7D2C464F532E7574696C732E636F6E766572744E61746976654E6F74696669636174696F6E733D66756E6374696F6E2865297B76617220';
wwv_flow_api.g_varchar2_table(2) := '743D24282223415045585F535543434553535F4D45535341474522293B742E697328223A76697369626C652229262628666F7374722E73756363657373282428222E742D416C6572742D7469746C65222C74292E7465787428292C6E756C6C2C65292C61';
wwv_flow_api.g_varchar2_table(3) := '7065782E6D6573736167652E6869646550616765537563636573732829292C617065782E6D6573736167652E7365745468656D65486F6F6B73287B6265666F726553686F773A66756E6374696F6E28742C69297B696628743D3D3D617065782E6D657373';
wwv_flow_api.g_varchar2_table(4) := '6167652E545950452E53554343455353297B76617220733D286E3D2428222E742D416C6572742D7469746C65222C6929292E7465787428293B72657475726E20666F7374722E7375636365737328732C6E756C6C2C65292C21317D696628743D3D3D6170';
wwv_flow_api.g_varchar2_table(5) := '65782E6D6573736167652E545950452E4552524F52297B76617220613D2428222E612D4E6F74696669636174696F6E2D7469746C65222C69292E7465787428292C6E3D2428222E612D4E6F74696669636174696F6E2D6C697374222C69292E636C6F6E65';
wwv_flow_api.g_varchar2_table(6) := '28292C6C3D666F7374725B652E7265706C6163654572726F7273576974685D286E2C612C65292C6F3D6C2E66696E6428222E612D4E6F74696669636174696F6E2D6C696E6B22293B6F2E6F6E2822636C69636B222C2866756E6374696F6E2865297B7661';
wwv_flow_api.g_varchar2_table(7) := '7220743D6F2E696E6465782824287468697329293B2428222E612D4E6F74696669636174696F6E2D6C696E6B222C24282223415045585F4552524F525F4D4553534147452229295B745D2E747269676765722822636C69636B22297D29293B7661722072';
wwv_flow_api.g_varchar2_table(8) := '3D6C2E66696E6428222E6A732D73686F7744657461696C7322293B72657475726E20722E6F6E2822636C69636B222C2866756E6374696F6E2865297B76617220743D722E696E6465782824287468697329293B2428222E6A732D73686F7744657461696C';
wwv_flow_api.g_varchar2_table(9) := '73222C24282223415045585F4552524F525F4D4553534147452229295B745D2E747269676765722822636C69636B22297D29292C21317D7D2C6265666F7265486964653A66756E6374696F6E28652C74297B666F7374722E636C656172416C6C28297D7D';
wwv_flow_api.g_varchar2_table(10) := '297D2C464F532E7574696C732E6E6F74696669636174696F6E3D66756E6374696F6E28652C742C69297B76617220732C613B696628653D657C7C746869732C28743D747C7C7B7D292E747970653D742E747970657C7C22696E666F222C617065782E6465';
wwv_flow_api.g_varchar2_table(11) := '6275672E696E666F2822464F53202D204E6F74696669636174696F6E73222C74292C22636C6561722D616C6C223D3D3D742E747970652972657475726E20617065782E6D6573736167652E636C6561724572726F727328292C666F7374722E636C656172';
wwv_flow_api.g_varchar2_table(12) := '416C6C28293B69662822636F6E7665727422213D3D742E74797065297B696628733D742E6D65737361676520696E7374616E63656F662046756E6374696F6E3F742E6D6573736167652E63616C6C28652C74293A742E6D6573736167652C613D742E7469';
wwv_flow_api.g_varchar2_table(13) := '746C6520696E7374616E63656F662046756E6374696F6E3F742E7469746C652E63616C6C28652C74293A742E7469746C652C28737C7C612926262821742E7375627374697475746556616C7565737C7C2861262628613D617065782E7574696C2E617070';
wwv_flow_api.g_varchar2_table(14) := '6C7954656D706C61746528612C7B64656661756C7445736361706546696C7465723A6E756C6C7D29292C73262628733D617065782E7574696C2E6170706C7954656D706C61746528732C7B64656661756C7445736361706546696C7465723A6E756C6C7D';
wwv_flow_api.g_varchar2_table(15) := '29292C737C7C612929297B766172206E3D242E657874656E64287B7D2C742E6F7074696F6E73293B6920696E7374616E63656F662046756E6374696F6E2626692E63616C6C28652C6E292C742E696E6C696E654974656D4572726F72732626742E696E6C';
wwv_flow_api.g_varchar2_table(16) := '696E65506167654974656D732626742E696E6C696E65506167654974656D732E73706C697428222C22292E666F7245616368282866756E6374696F6E2865297B617065782E6D6573736167652E73686F774572726F7273287B747970653A226572726F72';
wwv_flow_api.g_varchar2_table(17) := '222C6C6F636174696F6E3A22696E6C696E65222C706167654974656D3A652C6D6573736167653A732C756E736166653A21317D297D29292C666F7374725B742E747970655D28732C612C6E297D7D656C736520464F532E7574696C732E636F6E76657274';
wwv_flow_api.g_varchar2_table(18) := '4E61746976654E6F74696669636174696F6E7328742E6F7074696F6E73297D3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
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
wwv_flow_api.g_varchar2_table(9) := '737472203D202866756E6374696F6E2829207B0A0A2020202076617220434F4E5441494E45525F434C415353203D2027666F7374722D636F6E7461696E6572273B0A0A2020202076617220746F61737454797065203D207B0A2020202020202020737563';
wwv_flow_api.g_varchar2_table(10) := '636573733A202773756363657373272C0A2020202020202020696E666F3A2027696E666F272C0A20202020202020207761726E696E673A20277761726E696E67272C0A20202020202020206572726F723A20276572726F72270A202020207D3B0A0A2020';
wwv_flow_api.g_varchar2_table(11) := '20207661722069636F6E436C6173736573203D207B0A2020202020202020737563636573733A202766612D636865636B2D636972636C65272C0A2020202020202020696E666F3A202766612D696E666F2D636972636C65272C0A20202020202020207761';
wwv_flow_api.g_varchar2_table(12) := '726E696E673A202766612D6578636C616D6174696F6E2D747269616E676C65272C0A20202020202020206572726F723A202766612D74696D65732D636972636C65270A202020207D3B0A0A2020202076617220636F6E7461696E657273203D207B7D3B0A';
wwv_flow_api.g_varchar2_table(13) := '202020207661722070726576696F7573546F617374203D207B7D3B0A0A2020202066756E6374696F6E206E6F746966795479706528747970652C206D6573736167652C207469746C652C206F7074696F6E7329207B0A0A20202020202020207661722066';
wwv_flow_api.g_varchar2_table(14) := '696E616C4F7074696F6E73203D20242E657874656E64287B7D2C207B0A2020202020202020202020206469736D6973733A205B276F6E436C69636B272C20276F6E427574746F6E275D2C2020202F2F207768656E20746F206469736D6973732074686520';
wwv_flow_api.g_varchar2_table(15) := '6E6F74696669636174696F6E0A2020202020202020202020206469736D69737341667465723A206E756C6C2C20202020202020202020202020202020202F2F2061206E756D62657220696E206D696C6C697365636F6E6473206166746572207768696368';
wwv_flow_api.g_varchar2_table(16) := '20746865206E6F74696669636174696F6E2073686F756C64206265206175746F6D61746963616C6C792072656D6F7665642E20686F766572696E67206F7220636C69636B696E6720746865206E6F74696669636174696F6E2073746F7073207468697320';
wwv_flow_api.g_varchar2_table(17) := '6576656E740A2020202020202020202020206E65776573744F6E546F703A20747275652C2020202020202020202020202020202020202F2F2061646420746F2074686520746F70206F6620746865206C6973740A20202020202020202020202070726576';
wwv_flow_api.g_varchar2_table(18) := '656E744475706C6963617465733A2066616C73652C20202020202020202020202F2F20646F206E6F742073686F7720746865206E6F74696669636174696F6E20696620697420686173207468652073616D65207469746C6520616E64206D657373616765';
wwv_flow_api.g_varchar2_table(19) := '20617320746865206C617374206F6E6520616E6420696620746865206C617374206F6E65206973207374696C6C2076697369626C650A20202020202020202020202065736361706548746D6C3A20747275652C2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(20) := '20202F2F207768657468657220746F2065736361706520746865207469746C6520616E64206D6573736167650A202020202020202020202020706F736974696F6E3A2027746F702D7269676874272C20202020202020202020202020202F2F206F6E6520';
wwv_flow_api.g_varchar2_table(21) := '6F6620363A205B746F707C626F74746F6D5D2D5B72696768747C63656E7465727C6C6566745D0A20202020202020202020202069636F6E436C6173733A206E756C6C2C20202020202020202020202020202020202020202F2F207768656E206C65667420';
wwv_flow_api.g_varchar2_table(22) := '746F206E756C6C2C2069742077696C6C2062652064656661756C74656420746F2074686520636F72726573706F6E64696E672069636F6E2066726F6D2069636F6E436C61737365730A202020202020202020202020636C656172416C6C3A2066616C7365';
wwv_flow_api.g_varchar2_table(23) := '2020202020202020202020202020202020202020202F2F207472756520746F20636C65617220616C6C206E6F74696669636174696F6E732066697273740A20202020202020207D2C206F7074696F6E73293B0A0A20202020202020202F2F206966207468';
wwv_flow_api.g_varchar2_table(24) := '65206D6573736167652061747472696275746520697320616E206F626A6563740A202020202020202069662028747970656F66206D657373616765203D3D3D20276F626A6563742729207B0A2020202020202020202020206D6573736167652E74797065';
wwv_flow_api.g_varchar2_table(25) := '203D20747970653B0A20202020202020202020202072657475726E206E6F7469667928242E657874656E642866696E616C4F7074696F6E732C207B0A20202020202020202020202020202020747970653A20747970650A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(26) := '2C206D65737361676529293B0A20202020202020207D20656C736520696620286D657373616765207C7C207469746C6529207B0A20202020202020202020202069662028217469746C65202626206D65737361676529207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(27) := '20202020207469746C65203D206D6573736167653B0A202020202020202020202020202020206D657373616765203D20756E646566696E65643B0A2020202020202020202020207D0A20202020202020202020202072657475726E206E6F746966792824';
wwv_flow_api.g_varchar2_table(28) := '2E657874656E64287B7D2C7B0A20202020202020202020202020202020747970653A20747970652C0A202020202020202020202020202020206D6573736167653A206D6573736167652C0A202020202020202020202020202020207469746C653A207469';
wwv_flow_api.g_varchar2_table(29) := '746C650A2020202020202020202020207D2C2066696E616C4F7074696F6E7329293B0A20202020202020207D20656C7365207B0A202020202020202020202020617065782E64656275672E696E666F2827666F7374723A206E6F207469746C65206F7220';
wwv_flow_api.g_varchar2_table(30) := '6D657373616765207761732070726F76696465642E206E6F742073686F77696E67206E6F74696669636174696F6E2E27293B0A20202020202020207D0A202020207D0A0A2020202066756E6374696F6E2073756363657373286D6573736167652C207469';
wwv_flow_api.g_varchar2_table(31) := '746C652C206F7074696F6E7329207B0A202020202020202072657475726E206E6F746966795479706528746F617374547970652E737563636573732C206D6573736167652C207469746C652C206F7074696F6E73293B0A202020207D0A0A202020206675';
wwv_flow_api.g_varchar2_table(32) := '6E6374696F6E207761726E696E67286D6573736167652C207469746C652C206F7074696F6E7329207B0A202020202020202072657475726E206E6F746966795479706528746F617374547970652E7761726E696E672C206D6573736167652C207469746C';
wwv_flow_api.g_varchar2_table(33) := '652C206F7074696F6E73293B0A202020207D0A0A2020202066756E6374696F6E20696E666F286D6573736167652C207469746C652C206F7074696F6E7329207B0A202020202020202072657475726E206E6F746966795479706528746F61737454797065';
wwv_flow_api.g_varchar2_table(34) := '2E696E666F2C206D6573736167652C207469746C652C206F7074696F6E73293B0A202020207D0A0A2020202066756E6374696F6E206572726F72286D6573736167652C207469746C652C206F7074696F6E7329207B0A202020202020202072657475726E';
wwv_flow_api.g_varchar2_table(35) := '206E6F746966795479706528746F617374547970652E6572726F722C206D6573736167652C207469746C652C206F7074696F6E73293B0A202020207D0A0A2020202066756E6374696F6E20636C656172416C6C2829207B0A20202020202020202428272E';
wwv_flow_api.g_varchar2_table(36) := '27202B20434F4E5441494E45525F434C415353292E6368696C6472656E28292E72656D6F766528293B0A202020207D0A0A202020202F2F20696E7465726E616C2066756E6374696F6E730A0A2020202066756E6374696F6E20676574436F6E7461696E65';
wwv_flow_api.g_varchar2_table(37) := '7228706F736974696F6E29207B0A0A202020202020202066756E6374696F6E20637265617465436F6E7461696E657228706F736974696F6E29207B0A2020202020202020202020207661722024636F6E7461696E6572203D202428273C6469762F3E2729';
wwv_flow_api.g_varchar2_table(38) := '2E616464436C6173732827666F7374722D27202B20706F736974696F6E292E616464436C61737328434F4E5441494E45525F434C415353293B0A202020202020202020202020242827626F647927292E617070656E642824636F6E7461696E6572293B0A';
wwv_flow_api.g_varchar2_table(39) := '202020202020202020202020636F6E7461696E6572735B706F736974696F6E5D203D2024636F6E7461696E65723B0A20202020202020202020202072657475726E2024636F6E7461696E65723B0A20202020202020207D0A0A2020202020202020726574';
wwv_flow_api.g_varchar2_table(40) := '75726E20636F6E7461696E6572735B706F736974696F6E5D207C7C20637265617465436F6E7461696E657228706F736974696F6E293B0A202020207D0A0A2020202066756E6374696F6E206E6F7469667928636F6E66696729207B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(41) := '207661722024636F6E7461696E6572203D20676574436F6E7461696E657228636F6E6669672E706F736974696F6E293B0A0A2020202020202020766172206469736D6973734F6E436C69636B203D20636F6E6669672E6469736D6973732E696E636C7564';
wwv_flow_api.g_varchar2_table(42) := '657328276F6E436C69636B27293B0A2020202020202020766172206469736D6973734F6E427574746F6E203D20636F6E6669672E6469736D6973732E696E636C7564657328276F6E427574746F6E27293B0A0A20202020202020202F2A0A202020202020';
wwv_flow_api.g_varchar2_table(43) := '20203C64697620636C6173733D22666F732D416C65727420666F732D416C6572742D2D686F72697A6F6E74616C20666F732D416C6572742D2D7061676520666F732D416C6572742D2D737563636573732220726F6C653D22616C657274223E0A20202020';
wwv_flow_api.g_varchar2_table(44) := '20202020202020203C64697620636C6173733D22666F732D416C6572742D77726170223E0A202020202020202020202020202020203C64697620636C6173733D22666F732D416C6572742D69636F6E223E0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(45) := '20203C7370616E20636C6173733D22742D49636F6E2066612066612D636865636B2D636972636C65223E3C2F7370616E3E0A202020202020202020202020202020203C2F6469763E0A202020202020202020202020202020203C64697620636C6173733D';
wwv_flow_api.g_varchar2_table(46) := '22666F732D416C6572742D636F6E74656E74223E0A20202020202020202020202020202020202020203C683220636C6173733D22666F732D416C6572742D7469746C65223E3C2F68323E0A20202020202020202020202020202020202020203C64697620';
wwv_flow_api.g_varchar2_table(47) := '636C6173733D22666F732D416C6572742D626F6479223E3C2F6469763E0A202020202020202020202020202020203C2F6469763E0A202020202020202020202020202020203C64697620636C6173733D22666F732D416C6572742D627574746F6E73223E';
wwv_flow_api.g_varchar2_table(48) := '0A20202020202020202020202020202020202020203C627574746F6E20636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F554920742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D636C6F7365416C6572742220747970';
wwv_flow_api.g_varchar2_table(49) := '653D22627574746F6E22207469746C653D22436C6F7365204E6F74696669636174696F6E223E3C7370616E20636C6173733D22742D49636F6E2069636F6E2D636C6F7365223E3C2F7370616E3E3C2F627574746F6E3E0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '2020203C2F6469763E0A2020202020202020202020203C2F6469763E0A20202020202020203C2F6469763E0A20202020202020202A2F0A0A20202020202020207661722074797065436C617373203D207B0A202020202020202020202020227375636365';
wwv_flow_api.g_varchar2_table(51) := '7373223A2022666F732D416C6572742D2D73756363657373222C0A202020202020202020202020226572726F72223A2022666F732D416C6572742D2D64616E676572222C0A202020202020202020202020227761726E696E67223A2022666F732D416C65';
wwv_flow_api.g_varchar2_table(52) := '72742D2D7761726E696E67222C0A20202020202020202020202022696E666F223A2022666F732D416C6572742D2D696E666F220A20202020202020207D3B0A0A20202020202020207661722024746F617374456C656D656E74203D202428273C64697620';
wwv_flow_api.g_varchar2_table(53) := '636C6173733D22666F732D416C65727420666F732D416C6572742D2D686F72697A6F6E74616C20666F732D416C6572742D2D706167652027202B2074797065436C6173735B636F6E6669672E747970655D202B20272220726F6C653D22616C657274223E';
wwv_flow_api.g_varchar2_table(54) := '3C2F6469763E27293B0A20202020202020207661722024746F61737457726170203D202428273C64697620636C6173733D22666F732D416C6572742D77726170223E27293B0A2020202020202020766172202469636F6E57726170203D202428273C6469';
wwv_flow_api.g_varchar2_table(55) := '7620636C6173733D22666F732D416C6572742D69636F6E223E3C2F6469763E27293B0A2020202020202020766172202469636F6E456C656D203D202428273C7370616E20636C6173733D22742D49636F6E2066612027202B2028636F6E6669672E69636F';
wwv_flow_api.g_varchar2_table(56) := '6E436C617373207C7C2069636F6E436C61737365735B636F6E6669672E747970655D29202B2027223E3C2F7370616E3E27293B0A20202020202020207661722024636F6E74656E74456C656D203D202428273C64697620636C6173733D22666F732D416C';
wwv_flow_api.g_varchar2_table(57) := '6572742D636F6E74656E74223E3C2F6469763E27293B0A202020202020202076617220247469746C65456C656D656E74203D202428273C683220636C6173733D22666F732D416C6572742D7469746C65223E3C2F68323E27293B0A202020202020202076';
wwv_flow_api.g_varchar2_table(58) := '617220246D657373616765456C656D656E74203D202428273C64697620636C6173733D22666F732D416C6572742D626F6479223E3C2F6469763E27293B0A20202020202020207661722024627574746F6E57726170706572203D202428273C6469762063';
wwv_flow_api.g_varchar2_table(59) := '6C6173733D22666F732D416C6572742D627574746F6E73223E3C2F6469763E27293B0A20202020202020207661722024636C6F7365456C656D656E743B0A0A2020202020202020696620286469736D6973734F6E427574746F6E29207B0A202020202020';
wwv_flow_api.g_varchar2_table(60) := '20202020202024636C6F7365456C656D656E74203D202428273C627574746F6E20636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F554920742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D636C6F7365416C65727422';
wwv_flow_api.g_varchar2_table(61) := '20747970653D22627574746F6E22207469746C653D22436C6F7365204E6F74696669636174696F6E223E3C7370616E20636C6173733D22742D49636F6E2069636F6E2D636C6F7365223E3C2F7370616E3E3C2F627574746F6E3E27293B0A202020202020';
wwv_flow_api.g_varchar2_table(62) := '20207D0A0A202020202020202024746F617374456C656D656E742E617070656E642824746F61737457726170293B0A202020202020202024746F617374577261702E617070656E64282469636F6E57726170293B0A20202020202020202469636F6E5772';
wwv_flow_api.g_varchar2_table(63) := '61702E617070656E64282469636F6E456C656D293B0A202020202020202024746F617374577261702E617070656E642824636F6E74656E74456C656D293B0A202020202020202024636F6E74656E74456C656D2E617070656E6428247469746C65456C65';
wwv_flow_api.g_varchar2_table(64) := '6D656E74293B0A202020202020202024636F6E74656E74456C656D2E617070656E6428246D657373616765456C656D656E74293B0A202020202020202024746F617374577261702E617070656E642824627574746F6E57726170706572293B0A0A202020';
wwv_flow_api.g_varchar2_table(65) := '2020202020696620286469736D6973734F6E427574746F6E29207B0A20202020202020202020202024627574746F6E577261707065722E617070656E642824636C6F7365456C656D656E74293B0A20202020202020207D0A0A20202020202020202F2F20';
wwv_flow_api.g_varchar2_table(66) := '73657474696E6720746865207469746C650A2020202020202020766172207469746C65203D20636F6E6669672E7469746C653B0A2020202020202020696620287469746C6529207B0A20202020202020202020202069662028636F6E6669672E65736361';
wwv_flow_api.g_varchar2_table(67) := '706548746D6C29207B0A202020202020202020202020202020207469746C65203D20617065782E7574696C2E65736361706548544D4C287469746C65293B0A2020202020202020202020207D0A202020202020202020202020247469746C65456C656D65';

wwv_flow_api.g_varchar2_table(68) := '6E742E617070656E64287469746C65293B0A20202020202020207D0A0A20202020202020202F2F73657474696E6720746865206D6573736167650A2020202020202020766172206D657373616765203D20636F6E6669672E6D6573736167653B0A202020';
wwv_flow_api.g_varchar2_table(69) := '2020202020696620286D65737361676529207B0A20202020202020202020202069662028636F6E6669672E65736361706548746D6C20262620747970656F66206D657373616765203D3D2027737472696E6727297B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(70) := '20206D657373616765203D20617065782E7574696C2E65736361706548544D4C286D657373616765293B0A2020202020202020202020207D0A202020202020202020202020246D657373616765456C656D656E742E617070656E64286D65737361676529';
wwv_flow_api.g_varchar2_table(71) := '3B0A20202020202020207D0A0A20202020202020202F2F2061766F6964696E67206475706C6963617465732C20627574206F6E6C7920636F6E7365637574697665206F6E65730A202020202020202069662028636F6E6669672E70726576656E74447570';
wwv_flow_api.g_varchar2_table(72) := '6C6963617465732026262070726576696F7573546F6173742026262070726576696F7573546F6173742E24656C656D2026262070726576696F7573546F6173742E24656C656D2E697328273A76697369626C65272929207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(73) := '206966202870726576696F7573546F6173742E7469746C65203D3D207469746C652026262070726576696F7573546F6173742E6D657373616765203D3D206D65737361676529207B0A2020202020202020202020202020202072657475726E3B0A202020';
wwv_flow_api.g_varchar2_table(74) := '2020202020202020207D0A20202020202020207D0A0A202020202020202070726576696F7573546F617374203D207B0A20202020202020202020202024656C656D3A2024746F617374456C656D656E742C0A2020202020202020202020207469746C653A';
wwv_flow_api.g_varchar2_table(75) := '207469746C652C0A2020202020202020202020206D6573736167653A206D6573736167650A20202020202020207D3B0A0A20202020202020202F2F206F7074696F6E616C6C7920636C65617220616C6C206D657373616765732066697273740A20202020';
wwv_flow_api.g_varchar2_table(76) := '2020202069662028636F6E6669672E636C656172416C6C29207B0A202020202020202020202020636C656172416C6C28293B0A20202020202020207D0A20202020202020202F2F206164647320746865206E6F74696669636174696F6E20746F20746865';
wwv_flow_api.g_varchar2_table(77) := '20636F6E7461696E65720A202020202020202069662028636F6E6669672E6E65776573744F6E546F7029207B0A20202020202020202020202024636F6E7461696E65722E70726570656E642824746F617374456C656D656E74293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(78) := '7D20656C7365207B0A20202020202020202020202024636F6E7461696E65722E617070656E642824746F617374456C656D656E74293B0A20202020202020207D0A0A20202020202020202F2F2073657474696E672074686520636F727265637420415249';
wwv_flow_api.g_varchar2_table(79) := '412076616C75650A2020202020202020766172206172696156616C75653B0A20202020202020207377697463682028636F6E6669672E7479706529207B0A20202020202020202020202063617365202773756363657373273A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(80) := '2020636173652027696E666F273A0A202020202020202020202020202020206172696156616C7565203D2027706F6C697465273B0A20202020202020202020202020202020627265616B3B0A20202020202020202020202064656661756C743A0A202020';
wwv_flow_api.g_varchar2_table(81) := '202020202020202020202020206172696156616C7565203D2027617373657274697665273B0A20202020202020207D0A202020202020202024746F617374456C656D656E742E617474722827617269612D6C697665272C206172696156616C7565293B0A';
wwv_flow_api.g_varchar2_table(82) := '0A20202020202020202F2F73657474696E672074696D657220616E642070726F6772657373206261720A2020202020202020766172202470726F6772657373456C656D656E74203D202428273C6469762F3E27293B0A202020202020202069662028636F';
wwv_flow_api.g_varchar2_table(83) := '6E6669672E6469736D6973734166746572203E203029207B0A2020202020202020202020202470726F6772657373456C656D656E742E616464436C6173732827666F7374722D70726F677265737327293B0A20202020202020202020202024746F617374';
wwv_flow_api.g_varchar2_table(84) := '456C656D656E742E617070656E64282470726F6772657373456C656D656E74293B0A0A2020202020202020202020207661722074696D656F75744964203D2073657454696D656F75742866756E6374696F6E2829207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(85) := '20202024746F617374456C656D656E742E72656D6F766528293B0A2020202020202020202020207D2C20636F6E6669672E6469736D6973734166746572293B0A2020202020202020202020207661722070726F67726573735374617274416E696D44656C';
wwv_flow_api.g_varchar2_table(86) := '6179203D203130303B0A0A2020202020202020202020202470726F6772657373456C656D656E742E637373287B0A20202020202020202020202020202020277769647468273A202731303025272C0A20202020202020202020202020202020277472616E';
wwv_flow_api.g_varchar2_table(87) := '736974696F6E273A202777696474682027202B202828636F6E6669672E6469736D6973734166746572202D2070726F67726573735374617274416E696D44656C6179292F3130303029202B202773206C696E656172270A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(88) := '293B0A20202020202020202020202073657454696D656F75742866756E6374696F6E28297B0A202020202020202020202020202020202470726F6772657373456C656D656E742E63737328277769647468272C20273027293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(89) := '20207D2C2070726F67726573735374617274416E696D44656C6179293B0A0A2020202020202020202020202F2F206F6E20686F766572206F7220636C69636B2C2072656D6F7665207468652074696D657220616E642070726F6772657373206261720A20';
wwv_flow_api.g_varchar2_table(90) := '202020202020202020202024746F617374456C656D656E742E6F6E28276D6F7573656F76657220636C69636B272C2066756E6374696F6E2829207B0A20202020202020202020202020202020636C65617254696D656F75742874696D656F75744964293B';
wwv_flow_api.g_varchar2_table(91) := '0A202020202020202020202020202020202470726F6772657373456C656D656E742E72656D6F766528293B0A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2F68616E646C696E6720616E79206576656E7473';
wwv_flow_api.g_varchar2_table(92) := '0A2020202020202020696620286469736D6973734F6E436C69636B29207B0A20202020202020202020202024746F617374456C656D656E742E6F6E2827636C69636B272C2066756E6374696F6E286576656E7429207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(93) := '2020202F2F20646F206E6F74206469736D6973732069662074686520636C69636B656420656C656D656E7420697320616E20616E63686F72206F72206120627574746F6E0A202020202020202020202020202020206966285B2741272C2027425554544F';
wwv_flow_api.g_varchar2_table(94) := '4E275D2E696E636C756465732824286576656E742E746172676574292E70726F7028276E6F64654E616D65272929297B0A202020202020202020202020202020202020202072657475726E3B0A202020202020202020202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(95) := '2020202020202020202020202F2F20646F206E6F74206469736D6973732069662074686520757365722069732073656C656374696E6720746578740A202020202020202020202020202020207661722073656C656374696F6E203D2077696E646F772E67';
wwv_flow_api.g_varchar2_table(96) := '657453656C656374696F6E28293B0A202020202020202020202020202020206966282073656C656374696F6E202626200A202020202020202020202020202020202020202073656C656374696F6E2E74797065203D3D202752616E6765272026260A2020';
wwv_flow_api.g_varchar2_table(97) := '20202020202020202020202020202020202073656C656374696F6E2E616E63686F724E6F64652026260A2020202020202020202020202020202020202020242873656C656374696F6E2E616E63686F724E6F64652C2024746F617374456C656D656E7429';
wwv_flow_api.g_varchar2_table(98) := '2E6C656E677468203E2030297B0A202020202020202020202020202020202020202072657475726E3B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202024746F617374456C656D656E742E72656D6F766528293B';
wwv_flow_api.g_varchar2_table(99) := '0A2020202020202020202020207D293B0A20202020202020207D0A0A2020202020202020696620286469736D6973734F6E427574746F6E29207B0A20202020202020202020202024636C6F7365456C656D656E742E6F6E2827636C69636B272C2066756E';
wwv_flow_api.g_varchar2_table(100) := '6374696F6E2829207B0A2020202020202020202020202020202024746F617374456C656D656E742E72656D6F766528293B0A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2F20706572686170732074686520';
wwv_flow_api.g_varchar2_table(101) := '646576656C6F7065722077616E747320746F20646F20736F6D657468696E67206164646974696F6E616C6C79207768656E20746865206E6F74696669636174696F6E20697320636C69636B65640A202020202020202069662028747970656F6620636F6E';
wwv_flow_api.g_varchar2_table(102) := '6669672E6F6E636C69636B203D3D3D202766756E6374696F6E2729207B0A20202020202020202020202024746F617374456C656D656E742E6F6E2827636C69636B272C20636F6E6669672E6F6E636C69636B293B0A202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(103) := '286469736D6973734F6E427574746F6E292024636C6F7365456C656D656E742E6F6E2827636C69636B272C20636F6E6669672E6F6E636C69636B293B0A20202020202020207D0A0A202020202020202072657475726E2024746F617374456C656D656E74';
wwv_flow_api.g_varchar2_table(104) := '3B0A202020207D0A0A2020202072657475726E207B0A2020202020202020737563636573733A20737563636573732C0A2020202020202020696E666F3A20696E666F2C0A20202020202020207761726E696E673A207761726E696E672C0A202020202020';
wwv_flow_api.g_varchar2_table(105) := '20206572726F723A206572726F722C0A2020202020202020636C656172416C6C3A20636C656172416C6C2C0A202020202020202076657273696F6E3A202732302E322E30270A202020207D3B0A0A7D2928293B';
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
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E666F7374723D66756E6374696F6E28297B76617220653D22666F7374722D636F6E7461696E6572222C743D2273756363657373222C6E3D22696E666F222C733D227761726E696E67222C693D226572726F72222C6F3D7B737563636573';
wwv_flow_api.g_varchar2_table(2) := '733A2266612D636865636B2D636972636C65222C696E666F3A2266612D696E666F2D636972636C65222C7761726E696E673A2266612D6578636C616D6174696F6E2D747269616E676C65222C6572726F723A2266612D74696D65732D636972636C65227D';
wwv_flow_api.g_varchar2_table(3) := '2C723D7B7D2C613D7B7D3B66756E6374696F6E206328652C742C6E2C73297B76617220693D242E657874656E64287B7D2C7B6469736D6973733A5B226F6E436C69636B222C226F6E427574746F6E225D2C6469736D69737341667465723A6E756C6C2C6E';
wwv_flow_api.g_varchar2_table(4) := '65776573744F6E546F703A21302C70726576656E744475706C6963617465733A21312C65736361706548746D6C3A21302C706F736974696F6E3A22746F702D7269676874222C69636F6E436C6173733A6E756C6C2C636C656172416C6C3A21317D2C7329';
wwv_flow_api.g_varchar2_table(5) := '3B72657475726E226F626A656374223D3D747970656F6620743F28742E747970653D652C7028242E657874656E6428692C7B747970653A657D2C742929293A747C7C6E3F28216E2626742626286E3D742C743D766F69642030292C7028242E657874656E';
wwv_flow_api.g_varchar2_table(6) := '64287B7D2C7B747970653A652C6D6573736167653A742C7469746C653A6E7D2C692929293A766F696420617065782E64656275672E696E666F2822666F7374723A206E6F207469746C65206F72206D657373616765207761732070726F76696465642E20';
wwv_flow_api.g_varchar2_table(7) := '6E6F742073686F77696E67206E6F74696669636174696F6E2E22297D66756E6374696F6E206C28297B2428222E666F7374722D636F6E7461696E657222292E6368696C6472656E28292E72656D6F766528297D66756E6374696F6E20702874297B766172';
wwv_flow_api.g_varchar2_table(8) := '206E2C732C693D286E3D742E706F736974696F6E2C725B6E5D7C7C66756E6374696F6E2874297B766172206E3D2428223C6469762F3E22292E616464436C6173732822666F7374722D222B74292E616464436C6173732865293B72657475726E20242822';
wwv_flow_api.g_varchar2_table(9) := '626F647922292E617070656E64286E292C725B745D3D6E2C6E7D286E29292C633D742E6469736D6973732E696E636C7564657328226F6E436C69636B22292C703D742E6469736D6973732E696E636C7564657328226F6E427574746F6E22292C643D2428';
wwv_flow_api.g_varchar2_table(10) := '273C64697620636C6173733D22666F732D416C65727420666F732D416C6572742D2D686F72697A6F6E74616C20666F732D416C6572742D2D7061676520272B7B737563636573733A22666F732D416C6572742D2D73756363657373222C6572726F723A22';
wwv_flow_api.g_varchar2_table(11) := '666F732D416C6572742D2D64616E676572222C7761726E696E673A22666F732D416C6572742D2D7761726E696E67222C696E666F3A22666F732D416C6572742D2D696E666F227D5B742E747970655D2B272220726F6C653D22616C657274223E3C2F6469';
wwv_flow_api.g_varchar2_table(12) := '763E27292C663D2428273C64697620636C6173733D22666F732D416C6572742D77726170223E27292C753D2428273C64697620636C6173733D22666F732D416C6572742D69636F6E223E3C2F6469763E27292C763D2428273C7370616E20636C6173733D';
wwv_flow_api.g_varchar2_table(13) := '22742D49636F6E20666120272B28742E69636F6E436C6173737C7C6F5B742E747970655D292B27223E3C2F7370616E3E27292C6D3D2428273C64697620636C6173733D22666F732D416C6572742D636F6E74656E74223E3C2F6469763E27292C673D2428';
wwv_flow_api.g_varchar2_table(14) := '273C683220636C6173733D22666F732D416C6572742D7469746C65223E3C2F68323E27292C413D2428273C64697620636C6173733D22666F732D416C6572742D626F6479223E3C2F6469763E27292C773D2428273C64697620636C6173733D22666F732D';
wwv_flow_api.g_varchar2_table(15) := '416C6572742D627574746F6E73223E3C2F6469763E27293B70262628733D2428273C627574746F6E20636C6173733D22742D427574746F6E20742D427574746F6E2D2D6E6F554920742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D636C6F';
wwv_flow_api.g_varchar2_table(16) := '7365416C6572742220747970653D22627574746F6E22207469746C653D22436C6F7365204E6F74696669636174696F6E223E3C7370616E20636C6173733D22742D49636F6E2069636F6E2D636C6F7365223E3C2F7370616E3E3C2F627574746F6E3E2729';
wwv_flow_api.g_varchar2_table(17) := '292C642E617070656E642866292C662E617070656E642875292C752E617070656E642876292C662E617070656E64286D292C6D2E617070656E642867292C6D2E617070656E642841292C662E617070656E642877292C702626772E617070656E64287329';
wwv_flow_api.g_varchar2_table(18) := '3B76617220683D742E7469746C653B68262628742E65736361706548746D6C262628683D617065782E7574696C2E65736361706548544D4C286829292C672E617070656E64286829293B76617220793D742E6D6573736167653B69662879262628742E65';
wwv_flow_api.g_varchar2_table(19) := '736361706548746D6C262622737472696E67223D3D747970656F662079262628793D617065782E7574696C2E65736361706548544D4C287929292C412E617070656E64287929292C2128742E70726576656E744475706C6963617465732626612626612E';
wwv_flow_api.g_varchar2_table(20) := '24656C656D2626612E24656C656D2E697328223A76697369626C6522292626612E7469746C653D3D682626612E6D6573736167653D3D7929297B766172206B3B73776974636828613D7B24656C656D3A642C7469746C653A682C6D6573736167653A797D';
wwv_flow_api.g_varchar2_table(21) := '2C742E636C656172416C6C26266C28292C742E6E65776573744F6E546F703F692E70726570656E642864293A692E617070656E642864292C742E74797065297B636173652273756363657373223A6361736522696E666F223A6B3D22706F6C697465223B';
wwv_flow_api.g_varchar2_table(22) := '627265616B3B64656661756C743A6B3D22617373657274697665227D642E617474722822617269612D6C697665222C6B293B76617220623D2428223C6469762F3E22293B696628742E6469736D69737341667465723E30297B622E616464436C61737328';
wwv_flow_api.g_varchar2_table(23) := '22666F7374722D70726F677265737322292C642E617070656E642862293B76617220543D73657454696D656F7574282866756E6374696F6E28297B642E72656D6F766528297D292C742E6469736D6973734166746572293B622E637373287B7769647468';
wwv_flow_api.g_varchar2_table(24) := '3A2231303025222C7472616E736974696F6E3A22776964746820222B28742E6469736D69737341667465722D313030292F3165332B2273206C696E656172227D292C73657454696D656F7574282866756E6374696F6E28297B622E637373282277696474';
wwv_flow_api.g_varchar2_table(25) := '68222C223022297D292C313030292C642E6F6E28226D6F7573656F76657220636C69636B222C2866756E6374696F6E28297B636C65617254696D656F75742854292C622E72656D6F766528297D29297D72657475726E20632626642E6F6E2822636C6963';
wwv_flow_api.g_varchar2_table(26) := '6B222C2866756E6374696F6E2865297B696628215B2241222C22425554544F4E225D2E696E636C75646573282428652E746172676574292E70726F7028226E6F64654E616D65222929297B76617220743D77696E646F772E67657453656C656374696F6E';
wwv_flow_api.g_varchar2_table(27) := '28293B7426262252616E6765223D3D742E747970652626742E616E63686F724E6F646526262428742E616E63686F724E6F64652C64292E6C656E6774683E307C7C642E72656D6F766528297D7D29292C702626732E6F6E2822636C69636B222C2866756E';
wwv_flow_api.g_varchar2_table(28) := '6374696F6E28297B642E72656D6F766528297D29292C2266756E6374696F6E223D3D747970656F6620742E6F6E636C69636B262628642E6F6E2822636C69636B222C742E6F6E636C69636B292C702626732E6F6E2822636C69636B222C742E6F6E636C69';
wwv_flow_api.g_varchar2_table(29) := '636B29292C647D7D72657475726E7B737563636573733A66756E6374696F6E28652C6E2C73297B72657475726E206328742C652C6E2C73297D2C696E666F3A66756E6374696F6E28652C742C73297B72657475726E2063286E2C652C742C73297D2C7761';
wwv_flow_api.g_varchar2_table(30) := '726E696E673A66756E6374696F6E28652C742C6E297B72657475726E206328732C652C742C6E297D2C6572726F723A66756E6374696F6E28652C742C6E297B72657475726E206328692C652C742C6E297D2C636C656172416C6C3A6C2C76657273696F6E';
wwv_flow_api.g_varchar2_table(31) := '3A2232302E322E30227D7D28293B0A2F2F2320736F757263654D617070696E6755524C3D666F7374722E6A732E6D6170';
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
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22666F7374722E6A73225D2C226E616D6573223A5B2277696E646F77222C22666F737472222C22434F4E5441494E45525F434C415353222C22746F61737454797065222C2269636F6E436C61';
wwv_flow_api.g_varchar2_table(2) := '73736573222C2273756363657373222C22696E666F222C227761726E696E67222C226572726F72222C22636F6E7461696E657273222C2270726576696F7573546F617374222C226E6F7469667954797065222C2274797065222C226D657373616765222C';
wwv_flow_api.g_varchar2_table(3) := '227469746C65222C226F7074696F6E73222C2266696E616C4F7074696F6E73222C2224222C22657874656E64222C226469736D697373222C226469736D6973734166746572222C226E65776573744F6E546F70222C2270726576656E744475706C696361';
wwv_flow_api.g_varchar2_table(4) := '746573222C2265736361706548746D6C222C22706F736974696F6E222C2269636F6E436C617373222C22636C656172416C6C222C226E6F74696679222C22756E646566696E6564222C2261706578222C226465627567222C226368696C6472656E222C22';
wwv_flow_api.g_varchar2_table(5) := '72656D6F7665222C22636F6E666967222C2224636C6F7365456C656D656E74222C2224636F6E7461696E6572222C22616464436C617373222C22617070656E64222C22637265617465436F6E7461696E6572222C226469736D6973734F6E436C69636B22';
wwv_flow_api.g_varchar2_table(6) := '2C22696E636C75646573222C226469736D6973734F6E427574746F6E222C2224746F617374456C656D656E74222C2224746F61737457726170222C222469636F6E57726170222C222469636F6E456C656D222C2224636F6E74656E74456C656D222C2224';
wwv_flow_api.g_varchar2_table(7) := '7469746C65456C656D656E74222C22246D657373616765456C656D656E74222C2224627574746F6E57726170706572222C227574696C222C2265736361706548544D4C222C2224656C656D222C226973222C226172696156616C7565222C227072657065';
wwv_flow_api.g_varchar2_table(8) := '6E64222C2261747472222C222470726F6772657373456C656D656E74222C2274696D656F75744964222C2273657454696D656F7574222C22637373222C227769647468222C227472616E736974696F6E222C226F6E222C22636C65617254696D656F7574';
wwv_flow_api.g_varchar2_table(9) := '222C226576656E74222C22746172676574222C2270726F70222C2273656C656374696F6E222C2267657453656C656374696F6E222C22616E63686F724E6F6465222C226C656E677468222C226F6E636C69636B222C2276657273696F6E225D2C226D6170';
wwv_flow_api.g_varchar2_table(10) := '70696E6773223A224141734241412C4F41414F432C4D4141512C574145582C49414149432C4541416B422C6B4241456C42432C454143532C55414454412C4541454D2C4F41464E412C454147532C55414854412C4541494F2C51414750432C454141632C';
wwv_flow_api.g_varchar2_table(11) := '43414364432C514141532C6B42414354432C4B41414D2C694241434E432C514141532C3042414354432C4D41414F2C6D42414750432C454141612C47414362432C45414167422C47414570422C53414153432C45414157432C4541414D432C4541415343';
wwv_flow_api.g_varchar2_table(12) := '2C4541414F432C47414574432C49414149432C45414165432C45414145432C4F41414F2C474141492C4341433542432C514141532C434141432C554141572C5941437242432C614141632C4B414364432C614141612C45414362432C6D4241416D422C45';
wwv_flow_api.g_varchar2_table(13) := '41436E42432C594141592C4541435A432C534141552C59414356432C554141572C4B414358432C554141552C47414358582C474147482C4D414175422C694241415A462C47414350412C45414151442C4B41414F412C45414352652C4541414F562C4541';
wwv_flow_api.g_varchar2_table(14) := '4145432C4F41414F462C454141632C4341436A434A2C4B41414D412C47414350432C4B414349412C47414157432C49414362412C47414153442C49414356432C45414151442C45414352412C4F414155652C47414550442C4541414F562C45414145432C';
wwv_flow_api.g_varchar2_table(15) := '4F41414F2C474141472C43414374424E2C4B41414D412C4541434E432C51414153412C45414354432C4D41414F412C47414352452C55414548612C4B41414B432C4D41414D78422C4B41414B2C7345416F4278422C534141536F422C4941434C542C4541';
wwv_flow_api.g_varchar2_table(16) := '41452C6F4241417542632C57414157432C5341694278432C534141534C2C4541414F4D2C4741455A2C4941646B42542C45416D4464552C4541724341432C47416463582C45416359532C4541414F542C53414C3942662C45414157652C4941506C422C53';
wwv_flow_api.g_varchar2_table(17) := '41417942412C47414372422C49414149572C454141616C422C454141452C554141556D422C534141532C534141575A2C47414155592C534141536C432C47414770452C4F414641652C454141452C514141516F422C4F41414F462C4741436A4231422C45';
wwv_flow_api.g_varchar2_table(18) := '414157652C47414159572C4541436842412C4541476F42472C4341416742642C49414F3343652C45414169424E2C4541414F642C5141415171422C534141532C5741437A43432C4541416B42522C4541414F642C5141415171422C534141532C59413042';
wwv_flow_api.g_varchar2_table(19) := '3143452C45414167427A422C454141452C2B4441504E2C4341435A5A2C514141572C7142414358472C4D4141532C6F42414354442C514141572C7142414358442C4B4141512C6D424147714632422C4541414F72422C4D4141512C7942414335472B422C';
wwv_flow_api.g_varchar2_table(20) := '4541416131422C454141452C674341436632422C4541415933422C454141452C734341436434422C4541415935422C454141452C32424141364267422C4541414F522C5741416172422C4541415936422C4541414F72422C4F4141532C61414333466B43';
wwv_flow_api.g_varchar2_table(21) := '2C4541416537422C454141452C794341436A4238422C454141674239422C454141452C714341436C422B422C4541416B422F422C454141452C73434143704267432C454141694268432C454141452C794341476E4277422C49414341502C45414167426A';
wwv_flow_api.g_varchar2_table(22) := '422C454141452C304B4147744279422C454141634C2C4F41414F4D2C4741437242412C454141574E2C4F41414F4F2C4741436C42412C45414155502C4F41414F512C4741436A42462C454141574E2C4F41414F532C4741436C42412C45414161542C4F41';
wwv_flow_api.g_varchar2_table(23) := '414F552C4741437042442C45414161542C4F41414F572C47414370424C2C454141574E2C4F41414F592C47414564522C47414341512C454141655A2C4F41414F482C47414931422C4941414970422C454141516D422C4541414F6E422C4D414366412C49';
wwv_flow_api.g_varchar2_table(24) := '4143496D422C4541414F562C61414350542C45414151652C4B41414B71422C4B41414B432C5741415772432C4941456A4369432C45414163562C4F41414F76422C4941497A422C49414149442C454141556F422C4541414F70422C51415372422C474152';
wwv_flow_api.g_varchar2_table(25) := '49412C494143496F422C4541414F562C59414167432C6942414158562C4941433542412C4541415567422C4B41414B71422C4B41414B432C5741415774432C4941456E436D432C4541416742582C4F41414F78422C4D414976426F422C4541414F582C6D';
wwv_flow_api.g_varchar2_table(26) := '42414171425A2C4741416942412C4541416330432C4F41415331432C4541416330432C4D41414D432C474141472C614143764633432C45414163492C4F414153412C474141534A2C45414163472C53414157412C4741446A452C43417742412C49414149';
wwv_flow_api.g_varchar2_table(27) := '79432C4541434A2C4F416E424135432C45414167422C4341435A30432C4D41414F562C4541435035422C4D41414F412C45414350442C51414153412C474149546F422C4541414F502C55414350412C494147414F2C4541414F5A2C59414350632C454141';
wwv_flow_api.g_varchar2_table(28) := '576F422C51414151622C4741456E42502C45414157452C4F41414F4B2C47414B64542C4541414F72422C4D4143582C4941414B2C5541434C2C4941414B2C4F41434430432C454141592C5341435A2C4D41434A2C51414349412C454141592C5941457042';
wwv_flow_api.g_varchar2_table(29) := '5A2C45414163632C4B41414B2C59414161462C47414768432C49414149472C4541416D4278432C454141452C5541437A422C4741414967422C4541414F622C614141652C454141472C4341437A4271432C454141694272422C534141532C6B4241433142';
wwv_flow_api.g_varchar2_table(30) := '4D2C454141634C2C4F41414F6F422C47414572422C49414149432C45414159432C594141572C57414376426A422C45414163562C57414366432C4541414F622C6341475671432C4541416942472C494141492C4341436A42432C4D4141532C4F41435443';
wwv_flow_api.g_varchar2_table(31) := '2C574141632C5541416137422C4541414F622C61414A542C4B414967442C494141512C614145724675432C594141572C57414350462C4541416942472C494141492C514141532C4F41504C2C4B415737426C422C4541416371422C474141472C6D424141';
wwv_flow_api.g_varchar2_table(32) := '6D422C5741436843432C614141614E2C47414362442C45414169427A422C594171437A422C4F416843494F2C47414341472C4541416371422C474141472C534141532C53414153452C4741452F422C494141472C434141432C4941414B2C554141557A42';
wwv_flow_api.g_varchar2_table(33) := '2C5341415376422C4541414567442C4541414D432C51414151432C4B41414B2C6141416A442C43414B412C49414149432C4541415970452C4F41414F71452C6541436E42442C4741436B422C5341416C42412C4541415578442C4D41435677442C454141';
wwv_flow_api.g_varchar2_table(34) := '55452C5941435672442C454141456D442C45414155452C5741415935422C4741416536422C4F4141532C474149704437422C45414163562C6141496C42532C47414341502C4541416336422C474141472C534141532C574143744272422C45414163562C';
wwv_flow_api.g_varchar2_table(35) := '59414B512C6D4241416E42432C4541414F75432C5541436439422C4541416371422C474141472C5141415339422C4541414F75432C53414337422F422C4741416942502C4541416336422C474141472C5141415339422C4541414F75432C5541476E4439';
wwv_flow_api.g_varchar2_table(36) := '422C474147582C4D41414F2C4341434872432C5141684E4A2C5341416942512C45414153432C4541414F432C47414337422C4F41414F4A2C45414157522C4541416D42552C45414153432C4541414F432C4941674E7244542C4B417A4D4A2C534141634F';
wwv_flow_api.g_varchar2_table(37) := '2C45414153432C4541414F432C47414331422C4F41414F4A2C45414157522C4541416742552C45414153432C4541414F432C4941794D6C44522C5141394D4A2C53414169424D2C45414153432C4541414F432C47414337422C4F41414F4A2C4541415752';
wwv_flow_api.g_varchar2_table(38) := '2C4541416D42552C45414153432C4541414F432C4941384D7244502C4D41764D4A2C534141654B2C45414153432C4541414F432C47414333422C4F41414F4A2C45414157522C4541416942552C45414153432C4541414F432C4941754D6E44572C534141';
wwv_flow_api.g_varchar2_table(39) := '55412C454143562B432C514141532C5541355146222C2266696C65223A22666F7374722E6A73227D';
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
wwv_flow_api.g_varchar2_table(7) := '73742840675F5761726E696E672D42472C206461726B656E2840675F5761726E696E672D42472C202020353025292C206C69676874656E2840675F5761726E696E672D42472C202020353025292C2020343325293B0A0A0A2F2A2A0A202A204669786573';
wwv_flow_api.g_varchar2_table(8) := '206C696E6B207374796C696E6720696E206572726F72730A202A2F0A0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E6720612C0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E67';
wwv_flow_api.g_varchar2_table(9) := '65722061207B0A2020636F6C6F723A20696E68657269743B0A2020746578742D6465636F726174696F6E3A20756E6465726C696E653B0A7D0A0A2F2A2A0A202A20436F6C6F72697A6564204261636B67726F756E640A202A2F0A202E666F732D416C6572';
wwv_flow_api.g_varchar2_table(10) := '742D2D686F72697A6F6E74616C207B0A202020626F726465722D7261646975733A2040675F436F6E7461696E65722D426F726465725261646975730A207D0A200A202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A202020636F6C6F72';
wwv_flow_api.g_varchar2_table(11) := '3A20234646463B0A207D0A200A200A202F2A2A0A20202A204D6F6469666965723A205761726E696E670A20202A2F0A202E666F732D416C6572742D2D7761726E696E677B0A2020202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920';
wwv_flow_api.g_varchar2_table(12) := '636F6C6F723A2040675F5761726E696E672D42473B0A2020207D0A200A202020262E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75';

wwv_flow_api.g_varchar2_table(13) := '742840675F5761726E696E672D42472C20383525293B0A2020207D0A207D0A200A200A202F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A202E666F732D416C6572742D2D73756363657373207B0A2020202E666F732D416C';
wwv_flow_api.g_varchar2_table(14) := '6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F537563636573732D42473B0A2020207D0A200A202020262E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A0920626163';
wwv_flow_api.g_varchar2_table(15) := '6B67726F756E642D636F6C6F723A20666164656F75742840675F537563636573732D42472C20383525293B0A2020207D0A207D0A200A202F2A2A0A20202A204D6F6469666965723A20496E666F726D6174696F6E0A20202A2F0A202E666F732D416C6572';
wwv_flow_api.g_varchar2_table(16) := '742D2D696E666F207B0A2020202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F496E666F2D42473B0A2020207D0A200A202020262E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D41';
wwv_flow_api.g_varchar2_table(17) := '6C6572742D69636F6E207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F496E666F2D42472C20383525293B0A2020207D0A207D0A200A202F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A';
wwv_flow_api.g_varchar2_table(18) := '202E666F732D416C6572742D2D64616E6765727B0A2020202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A0920636F6C6F723A2040675F44616E6765722D42473B0A2020207D0A200A202020262E666F732D416C6572742D2D686F7269';
wwv_flow_api.g_varchar2_table(19) := '7A6F6E74616C202E666F732D416C6572742D69636F6E207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F44616E6765722D42472C20383525293B0A2020207D0A207D0A200A202E666F732D416C6572742D2D686F7269';
wwv_flow_api.g_varchar2_table(20) := '7A6F6E74616C7B0A2020206261636B67726F756E642D636F6C6F723A2040675F526567696F6E2D42473B0A202020636F6C6F723A2040675F526567696F6E2D46473B0A207D0A0A2F2A0A2E666F732D416C6572742D2D64616E6765727B0A094062673A20';
wwv_flow_api.g_varchar2_table(21) := '6C69676874656E2840675F44616E6765722D42472C20343025293B0A096261636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661646528636F6E7472617374284062672C2064657361747572617465286461726B656E28406267';
wwv_flow_api.g_varchar2_table(22) := '2C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B0A7D0A2E666F732D416C6572742D2D696E666F207B0A094062673A206C69676874656E284067';
wwv_flow_api.g_varchar2_table(23) := '5F496E666F2D42472C20353525293B0A096261636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661646528636F6E7472617374284062672C2064657361747572617465286461726B656E284062672C202031303025292C203130';
wwv_flow_api.g_varchar2_table(24) := '3025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B0A7D0A2A2F0A0A202E666F732D416C6572742D2D70616765207B0A202020262E666F732D416C6572742D2D73756363657373';
wwv_flow_api.g_varchar2_table(25) := '207B0A09206261636B67726F756E642D636F6C6F723A20666164656F75742840675F537563636573732D42472C20313025293B0A0920636F6C6F723A2040675F537563636573732D46473B0A200A09202E666F732D416C6572742D69636F6E207B0A0920';
wwv_flow_api.g_varchar2_table(26) := '20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A09202020636F6C6F723A2040675F537563636573732D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A';
wwv_flow_api.g_varchar2_table(27) := '09207D0A200A09202E742D427574746F6E2D2D636C6F7365416C657274207B0A09202020636F6C6F723A2040675F537563636573732D46472021696D706F7274616E743B0A09207D0A2020207D0A2020262E666F732D416C6572742D2D7761726E696E67';
wwv_flow_api.g_varchar2_table(28) := '207B0A202020206261636B67726F756E642D636F6C6F723A2040675F5761726E696E672D42473B0A20202020636F6C6F723A2040675F5761726E696E672D46473B0A0A09202E666F732D416C6572742D69636F6E207B0A092020206261636B67726F756E';
wwv_flow_api.g_varchar2_table(29) := '642D636F6C6F723A207472616E73706172656E743B0A09202020636F6C6F723A2040675F5761726E696E672D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A09207D0A200A09202E742D';
wwv_flow_api.g_varchar2_table(30) := '427574746F6E2D2D636C6F7365416C657274207B0A09202020636F6C6F723A2040675F537563636573732D46472021696D706F7274616E743B0A09207D0A20207D0A2020262E666F732D416C6572742D2D696E666F207B0A202020206261636B67726F75';
wwv_flow_api.g_varchar2_table(31) := '6E642D636F6C6F723A2040675F496E666F2D42473B0A20202020636F6C6F723A2040675F496E666F2D46473B0A0A09202E666F732D416C6572742D69636F6E207B0A092020206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B';
wwv_flow_api.g_varchar2_table(32) := '0A09202020636F6C6F723A2040675F496E666F2D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A09207D0A200A09202E742D427574746F6E2D2D636C6F7365416C657274207B0A092020';
wwv_flow_api.g_varchar2_table(33) := '20636F6C6F723A2040675F496E666F2D46472021696D706F7274616E743B0A09207D0A20207D0A202020262E666F732D416C6572742D2D64616E676572207B0A202020206261636B67726F756E642D636F6C6F723A2040675F44616E6765722D42473B0A';
wwv_flow_api.g_varchar2_table(34) := '20202020636F6C6F723A2040675F44616E6765722D46473B0A0A09202E666F732D416C6572742D69636F6E207B0A092020206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A09202020636F6C6F723A2040675F44616E6765';
wwv_flow_api.g_varchar2_table(35) := '722D46473B0A200A092020202E742D49636F6E207B0A090920636F6C6F723A20696E68657269743B0A092020207D0A09207D0A200A09202E742D427574746F6E2D2D636C6F7365416C657274207B0A09202020636F6C6F723A2040675F44616E6765722D';
wwv_flow_api.g_varchar2_table(36) := '46472021696D706F7274616E743B0A09207D0A20207D0A7D0A0A2F2A20486F72697A6F6E74616C20416C657274203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(37) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B206D617267696E2D626F74746F6D3A20312E3672656D3B20706F736974696F6E3A2072656C61746976653B207D0A0A2E666F732D';
wwv_flow_api.g_varchar2_table(38) := '416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D77726170207B20646973706C61793A20666C65783B20666C65782D646972656374696F6E3A20726F773B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E66';
wwv_flow_api.g_varchar2_table(39) := '6F732D416C6572742D69636F6E207B2070616464696E673A203020313670783B20666C65782D736872696E6B3A20303B20646973706C61793A20666C65783B20616C69676E2D6974656D733A2063656E7465723B207D0A0A2E666F732D416C6572742D2D';
wwv_flow_api.g_varchar2_table(40) := '686F72697A6F6E74616C202E666F732D416C6572742D636F6E74656E74207B2070616464696E673A20313670783B20666C65783A203120303B20646973706C61793A20666C65783B20666C65782D646972656374696F6E3A20636F6C756D6E3B206A7573';
wwv_flow_api.g_varchar2_table(41) := '746966792D636F6E74656E743A2063656E7465723B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B20666C65782D736872696E6B3A20303B20746578742D616C69676E3A20726967';
wwv_flow_api.g_varchar2_table(42) := '68743B2077686974652D73706163653A206E6F777261703B2070616464696E672D72696768743A20312E3672656D3B20646973706C61793A20666C65783B20616C69676E2D6974656D733A2063656E7465723B207D0A0A2E752D52544C202E666F732D41';
wwv_flow_api.g_varchar2_table(43) := '6C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B2070616464696E672D72696768743A20303B2070616464696E672D6C6566743A20312E3672656D3B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E';
wwv_flow_api.g_varchar2_table(44) := '74616C202E666F732D416C6572742D627574746F6E733A656D707479207B20646973706C61793A206E6F6E653B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B20666F6E742D73697A65';
wwv_flow_api.g_varchar2_table(45) := '3A20322E3072656D3B206C696E652D6865696768743A20322E3472656D3B206D617267696E2D626F74746F6D3A20303B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D626F64793A656D707479207B2064';
wwv_flow_api.g_varchar2_table(46) := '6973706C61793A206E6F6E653B207D0A0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E202E742D49636F6E207B20666F6E742D73697A653A20333270783B2077696474683A20333270783B2074657874';
wwv_flow_api.g_varchar2_table(47) := '2D616C69676E3A2063656E7465723B206865696768743A20333270783B206C696E652D6865696768743A20313B207D0A0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(48) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20436F6D6D6F6E2050726F70657274696573203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(49) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B20626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E31293B20626F782D736861646F773A203020';
wwv_flow_api.g_varchar2_table(50) := '32707820347078202D327078207267626128302C20302C20302C20302E303735293B207D0A0A2E666F732D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B20646973';
wwv_flow_api.g_varchar2_table(51) := '706C61793A206E6F6E652021696D706F7274616E743B207D0A0A2E666F732D416C6572742D2D6E6F49636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E207B20646973706C61793A206E6F6E653B207D0A0A2E742D426F64792D616C65';
wwv_flow_api.g_varchar2_table(52) := '7274207B206D617267696E3A20303B207D0A0A2E742D426F64792D616C657274202E666F732D416C657274207B206D617267696E2D626F74746F6D3A20303B207D0A0A2F2A2050616765204E6F74696669636174696F6E202853756363657373206F7220';
wwv_flow_api.g_varchar2_table(53) := '4D65737361676529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D70';
wwv_flow_api.g_varchar2_table(54) := '616765207B207472616E736974696F6E3A202E327320656173652D6F75743B206D61782D77696474683A2036343070783B206D696E2D77696474683A2033323070783B202F2A706F736974696F6E3A2066697865643B20746F703A20312E3672656D3B20';
wwv_flow_api.g_varchar2_table(55) := '72696768743A20312E3672656D3B2A2F207A2D696E6465783A20313030303B20626F726465722D77696474683A20303B20626F782D736861646F773A20302030203020302E3172656D207267626128302C20302C20302C20302E312920696E7365742C20';
wwv_flow_api.g_varchar2_table(56) := '302033707820397078202D327078207267626128302C20302C20302C20302E31293B202F2A20466F72207665727920736D616C6C2073637265656E732C2066697420746865206D65737361676520746F2074686520746F70206F66207468652073637265';
wwv_flow_api.g_varchar2_table(57) := '656E202A2F202F2A2053657420426F726465722052616469757320746F2030206173206D657373616765206578697374732077697468696E20636F6E74656E74202A2F202F2A2050616765204C6576656C205761726E696E6720616E64204572726F7273';
wwv_flow_api.g_varchar2_table(58) := '203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F202F2A205363726F6C6C62617273202A2F207D0A0A2E';
wwv_flow_api.g_varchar2_table(59) := '666F732D416C6572742D2D70616765202E666F732D416C6572742D627574746F6E73207B2070616464696E672D72696768743A20303B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E207B2070616464696E67';
wwv_flow_api.g_varchar2_table(60) := '2D6C6566743A20312E3672656D3B2070616464696E672D72696768743A203870783B207D0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E207B2070616464696E672D6C6566743A203870783B2070';
wwv_flow_api.g_varchar2_table(61) := '616464696E672D72696768743A20312E3672656D3B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E202E742D49636F6E207B20666F6E742D73697A653A20323470783B2077696474683A20323470783B206865';
wwv_flow_api.g_varchar2_table(62) := '696768743A20323470783B206C696E652D6865696768743A20313B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B2070616464696E672D626F74746F6D3A203870783B207D0A0A2E666F732D416C657274';
wwv_flow_api.g_varchar2_table(63) := '2D2D70616765202E666F732D416C6572742D636F6E74656E74207B2070616464696E673A203870783B207D0A0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B20706F736974696F6E3A206162736F';
wwv_flow_api.g_varchar2_table(64) := '6C7574653B2072696768743A202D3870783B20746F703A202D3870783B2070616464696E673A203470783B206D696E2D77696474683A20303B206261636B67726F756E642D636F6C6F723A20233030302021696D706F7274616E743B20636F6C6F723A20';
wwv_flow_api.g_varchar2_table(65) := '234646462021696D706F7274616E743B20626F782D736861646F773A203020302030203170782072676261283235352C203235352C203235352C20302E3235292021696D706F7274616E743B20626F726465722D7261646975733A20323470783B207472';
wwv_flow_api.g_varchar2_table(66) := '616E736974696F6E3A202D7765626B69742D7472616E73666F726D20302E3132357320656173653B207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173653B207472616E736974696F6E3A207472616E73666F726D20302E';
wwv_flow_api.g_varchar2_table(67) := '3132357320656173652C202D7765626B69742D7472616E73666F726D20302E3132357320656173653B207D0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B2072696768743A20';
wwv_flow_api.g_varchar2_table(68) := '6175746F3B206C6566743A202D3870783B207D0A0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A686F766572207B202D7765626B69742D7472616E73666F726D3A207363616C6528312E3135293B20';
wwv_flow_api.g_varchar2_table(69) := '7472616E73666F726D3A207363616C6528312E3135293B207D0A0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A616374697665207B202D7765626B69742D7472616E73666F726D3A207363616C6528';
wwv_flow_api.g_varchar2_table(70) := '302E3835293B207472616E73666F726D3A207363616C6528302E3835293B207D0A0A2F2A2E752D52544C202E666F732D416C6572742D2D70616765207B2072696768743A206175746F3B206C6566743A20312E3672656D3B207D2A2F0A0A2E666F732D41';
wwv_flow_api.g_varchar2_table(71) := '6C6572742D2D706167652E666F732D416C657274207B20626F726465722D7261646975733A20302E3472656D3B207D0A0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B2070616464696E673A2038707820303B';
wwv_flow_api.g_varchar2_table(72) := '207D0A0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E207B206D617267696E2D72696768743A203870783B207D0A0A2E666F732D416C6572742D2D706167652E666F73';
wwv_flow_api.g_varchar2_table(73) := '2D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C65207B20666F6E742D73697A653A20312E3472656D3B206C696E652D6865696768743A203272656D3B20666F6E742D7765696768743A203730303B206D617267';
wwv_flow_api.g_varchar2_table(74) := '696E3A20303B207D0A0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D6C697374207B206D61782D6865696768743A2031323870783B207D0A0A2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(75) := '742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B206D61782D6865696768743A20393670783B206F766572666C6F773A206175746F3B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E';
wwv_flow_api.g_varchar2_table(76) := '2D6C696E6B3A686F766572207B20746578742D6465636F726174696F6E3A20756E6465726C696E653B207D0A0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C626172207B2077696474683A203870783B2068656967';
wwv_flow_api.g_varchar2_table(77) := '68743A203870783B207D0A0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D7468756D62207B206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3235293B207D0A0A2E';
wwv_flow_api.g_varchar2_table(78) := '666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D747261636B207B206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3035293B207D0A0A2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(79) := '6765202E666F732D416C6572742D7469746C65207B20646973706C61793A20626C6F636B3B20666F6E742D7765696768743A203730303B20666F6E742D73697A653A20312E3872656D3B206D617267696E2D626F74746F6D3A20303B206D617267696E2D';
wwv_flow_api.g_varchar2_table(80) := '72696768743A20313670783B207D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F647920207B206D617267696E2D72696768743A20313670783B207D0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E66';
wwv_flow_api.g_varchar2_table(81) := '6F732D416C6572742D7469746C65207B206D617267696E2D72696768743A20303B206D617267696E2D6C6566743A20313670783B207D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F647920207B206D61';
wwv_flow_api.g_varchar2_table(82) := '7267696E2D72696768743A20303B206D617267696E2D6C6566743A20313670783B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B206D617267696E3A203470782030203020303B2070616464';
wwv_flow_api.g_varchar2_table(83) := '696E673A20303B206C6973742D7374796C653A206E6F6E653B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B2070616464696E672D6C6566743A20323070783B20706F736974696F6E3A2072';
wwv_flow_api.g_varchar2_table(84) := '656C61746976653B20666F6E742D73697A653A20313470783B206C696E652D6865696768743A20323070783B206D617267696E2D626F74746F6D3A203470783B202F2A20457874726120536D616C6C2053637265656E73202A2F207D0A0A2E666F732D41';
wwv_flow_api.g_varchar2_table(85) := '6C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C64207B206D617267696E2D626F74746F6D3A20303B207D0A0A2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F7469666963';
wwv_flow_api.g_varchar2_table(86) := '6174696F6E2D6974656D207B2070616464696E672D6C6566743A20303B2070616464696E672D72696768743A20323070783B207D0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B';
wwv_flow_api.g_varchar2_table(87) := '20636F6E74656E743A2027273B20706F736974696F6E3A206162736F6C7574653B206D617267696E3A203870783B20746F703A20303B206C6566743A20303B2077696474683A203470783B206865696768743A203470783B20626F726465722D72616469';
wwv_flow_api.g_varchar2_table(88) := '75733A20313030253B206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E35293B207D0A0A2F2A2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265';
wwv_flow_api.g_varchar2_table(89) := '666F7265207B2072696768743A20303B206C6566743A206175746F3B207D2A2F0A0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D202E612D427574746F6E2D2D6E6F74696669636174696F6E207B207061';
wwv_flow_api.g_varchar2_table(90) := '6464696E673A203270783B206F7061636974793A202E37353B20766572746963616C2D616C69676E3A20746F703B207D0A0A2E666F732D416C6572742D2D70616765202E68746D6C64624F7261457272207B206D617267696E2D746F703A20302E387265';
wwv_flow_api.g_varchar2_table(91) := '6D3B20646973706C61793A20626C6F636B3B20666F6E742D73697A653A20312E3172656D3B206C696E652D6865696768743A20312E3672656D3B20666F6E742D66616D696C793A20274D656E6C6F272C2027436F6E736F6C6173272C206D6F6E6F737061';
wwv_flow_api.g_varchar2_table(92) := '63652C2073657269663B2077686974652D73706163653A207072652D6C696E653B207D0A0A2F2A2041636365737369626C652048656164696E67203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(93) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469746C65207B20626F726465723A20303B20636C69';
wwv_flow_api.g_varchar2_table(94) := '703A20726563742830203020302030293B206865696768743A203170783B206D617267696E3A202D3170783B206F766572666C6F773A2068696464656E3B2070616464696E673A20303B20706F736974696F6E3A206162736F6C7574653B207769647468';
wwv_flow_api.g_varchar2_table(95) := '3A203170783B207D0A0A2F2A2048696464656E2048656164696E6720284E6F742041636365737369626C6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(96) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D72656D6F766548656164696E67202E666F732D416C6572742D7469746C65207B20646973706C61793A206E6F6E653B207D0A0A406D6564696120286D61782D7769';
wwv_flow_api.g_varchar2_table(97) := '6474683A20343830707829207B0A092E666F732D416C6572742D2D70616765207B0A09092F2A6C6566743A20312E3672656D3B2A2F0A09096D696E2D77696474683A20303B0A09096D61782D77696474683A206E6F6E653B0A097D0A092E666F732D416C';
wwv_flow_api.g_varchar2_table(98) := '6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A0909666F6E742D73697A653A20313270783B0A097D0A7D0A0A406D6564696120286D61782D77696474683A20373638707829207B0A092E666F732D416C6572742D2D68';
wwv_flow_api.g_varchar2_table(99) := '6F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B0A0909666F6E742D73697A653A20312E3872656D3B0A097D0A7D0A0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(100) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A2F2A2049636F6E2E637373202A2F0A0A2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F726520';
wwv_flow_api.g_varchar2_table(101) := '7B20666F6E742D66616D696C793A2022617065782D352D69636F6E2D666F6E74223B20646973706C61793A20696E6C696E652D626C6F636B3B20766572746963616C2D616C69676E3A20746F703B207D0A0A2E666F732D416C657274202E742D49636F6E';
wwv_flow_api.g_varchar2_table(102) := '2E69636F6E2D636C6F73653A6265666F7265207B206C696E652D6865696768743A20313670783B20666F6E742D73697A653A20313670783B20636F6E74656E743A20225C65306132223B207D0A0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(103) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A0A2F2F23656E64726567696F6E0A0A2E666F7374722D746F702D63656E7465';
wwv_flow_api.g_varchar2_table(104) := '72207B0A09746F703A20312E3672656D3B0A0972696768743A20303B0A0977696474683A20313030253B0A7D0A0A2E666F7374722D626F74746F6D2D63656E746572207B0A09626F74746F6D3A20312E3672656D3B0A0972696768743A20303B0A097769';
wwv_flow_api.g_varchar2_table(105) := '6474683A20313030253B0A7D0A0A2E666F7374722D746F702D7269676874207B0A09746F703A20312E3672656D3B0A0972696768743A20312E3672656D3B0A7D0A0A2E666F7374722D746F702D6C656674207B0A09746F703A20312E3672656D3B0A096C';
wwv_flow_api.g_varchar2_table(106) := '6566743A20312E3672656D3B0A7D0A0A2E666F7374722D626F74746F6D2D7269676874207B0A0972696768743A20312E3672656D3B0A09626F74746F6D3A20312E3672656D3B0A7D0A0A2E666F7374722D626F74746F6D2D6C656674207B0A09626F7474';
wwv_flow_api.g_varchar2_table(107) := '6F6D3A20312E3672656D3B0A096C6566743A20312E3672656D3B0A7D0A0A2E666F7374722D636F6E7461696E6572207B0A09706F736974696F6E3A2066697865643B0A097A2D696E6465783A203939393939393B0A0A092F2F64697361626C6520706F69';
wwv_flow_api.g_varchar2_table(108) := '6E746572206576656E747320666F722074686520636F6E7461696E65720A09706F696E7465722D6576656E74733A206E6F6E653B0A092F2F62757420656E61626C65207468656D20666F7220746865206368696C6472656E0A093E20646976207B0A0909';
wwv_flow_api.g_varchar2_table(109) := '706F696E7465722D6576656E74733A206175746F3B0A097D200A0A092F2A6F76657272696465732A2F0A09262E666F7374722D746F702D63656E746572203E206469762C0A09262E666F7374722D626F74746F6D2D63656E746572203E20646976207B0A';
wwv_flow_api.g_varchar2_table(110) := '09092F2A77696474683A2033303070783B2A2F0A09096D617267696E2D6C6566743A206175746F3B0A09096D617267696E2D72696768743A206175746F3B0A097D0A7D0A0A2F2F2070726F677265737320626172207374796C696E670A2E666F7374722D';
wwv_flow_api.g_varchar2_table(111) := '70726F6772657373207B0A09706F736974696F6E3A206162736F6C7574653B0A09626F74746F6D3A20303B0A096865696768743A203470783B0A096261636B67726F756E642D636F6C6F723A20626C61636B3B0A096F7061636974793A20302E343B0A7D';
wwv_flow_api.g_varchar2_table(112) := '0A0A68746D6C3A6E6F74282E752D52544C29202E666F7374722D70726F67726573737B0A096C6566743A20303B0A09626F726465722D626F74746F6D2D6C6566742D7261646975733A20302E3472656D3B0A7D0A0A68746D6C2E752D52544C202E666F73';
wwv_flow_api.g_varchar2_table(113) := '74722D70726F6772657373207B0A0972696768743A20303B0A09626F726465722D626F74746F6D2D72696768742D7261646975733A20302E3472656D3B0A7D0A0A406D6564696120286D61782D77696474683A20343830707829207B0A092E666F737472';
wwv_flow_api.g_varchar2_table(114) := '2D636F6E7461696E6572207B0A09096C6566743A20312E3672656D3B0A090972696768743A20312E3672656D3B0A097D0A7D';
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
wwv_flow_api.g_varchar2_table(2) := '20696E646976696475616C206E6F74696669636174696F6E730A0A2A2F0A2F2A2A0A202A204669786573206C696E6B207374796C696E6720696E206572726F72730A202A2F0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761';
wwv_flow_api.g_varchar2_table(3) := '726E696E6720612C0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E6765722061207B0A2020636F6C6F723A20696E68657269743B0A2020746578742D6465636F726174696F6E3A20756E6465726C696E653B0A7D0A2F2A';
wwv_flow_api.g_varchar2_table(4) := '2A0A202A20436F6C6F72697A6564204261636B67726F756E640A202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A2020626F726465722D7261646975733A203270783B0A7D0A2E666F732D416C6572742D69636F6E202E742D4963';
wwv_flow_api.g_varchar2_table(5) := '6F6E207B0A2020636F6C6F723A20234646463B0A7D0A2F2A2A0A20202A204D6F6469666965723A205761726E696E670A20202A2F0A2E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A20';
wwv_flow_api.g_varchar2_table(6) := '20636F6C6F723A20236662636634613B0A7D0A2E666F732D416C6572742D2D7761726E696E672E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A2072';
wwv_flow_api.g_varchar2_table(7) := '676261283235312C203230372C2037342C20302E3135293B0A7D0A2F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A2E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F';
wwv_flow_api.g_varchar2_table(8) := '6E207B0A2020636F6C6F723A20233342414132433B0A7D0A2E666F732D416C6572742D2D737563636573732E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C';
wwv_flow_api.g_varchar2_table(9) := '6F723A20726762612835392C203137302C2034342C20302E3135293B0A7D0A2F2A2A0A20202A204D6F6469666965723A20496E666F726D6174696F6E0A20202A2F0A2E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E';
wwv_flow_api.g_varchar2_table(10) := '742D49636F6E207B0A2020636F6C6F723A20233030373664663B0A7D0A2E666F732D416C6572742D2D696E666F2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D63';
wwv_flow_api.g_varchar2_table(11) := '6F6C6F723A207267626128302C203131382C203232332C20302E3135293B0A7D0A2F2A2A0A20202A204D6F6469666965723A20537563636573730A20202A2F0A2E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E';
wwv_flow_api.g_varchar2_table(12) := '742D49636F6E207B0A2020636F6C6F723A20236634343333363B0A7D0A2E666F732D416C6572742D2D64616E6765722E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(13) := '2D636F6C6F723A2072676261283234342C2036372C2035342C20302E3135293B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A20206261636B67726F756E642D636F6C6F723A20236666666666663B0A2020636F6C6F723A202332';
wwv_flow_api.g_varchar2_table(14) := '36323632363B0A7D0A2F2A0A2E666F732D416C6572742D2D64616E6765727B0A094062673A206C69676874656E2840675F44616E6765722D42472C20343025293B0A096261636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661';
wwv_flow_api.g_varchar2_table(15) := '646528636F6E7472617374284062672C2064657361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B';
wwv_flow_api.g_varchar2_table(16) := '0A7D0A2E666F732D416C6572742D2D696E666F207B0A094062673A206C69676874656E2840675F496E666F2D42472C20353525293B0A096261636B67726F756E642D636F6C6F723A204062673B0A09636F6C6F723A206661646528636F6E747261737428';
wwv_flow_api.g_varchar2_table(17) := '4062672C2064657361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B0A7D0A2A2F0A2E666F732D41';
wwv_flow_api.g_varchar2_table(18) := '6C6572742D2D706167652E666F732D416C6572742D2D73756363657373207B0A20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C2034342C20302E39293B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C';
wwv_flow_api.g_varchar2_table(19) := '6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F6C6F723A20234646463B0A7D0A2E666F';
wwv_flow_api.g_varchar2_table(20) := '732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D';
wwv_flow_api.g_varchar2_table(21) := '416C6572742D2D73756363657373202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E69';

wwv_flow_api.g_varchar2_table(22) := '6E67207B0A20206261636B67726F756E642D636F6C6F723A20236662636634613B0A2020636F6C6F723A20233434333430323B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F732D416C657274';
wwv_flow_api.g_varchar2_table(23) := '2D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F6C6F723A20233434333430323B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F';
wwv_flow_api.g_varchar2_table(24) := '732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E742D427574746F6E2D2D636C6F7365416C657274';
wwv_flow_api.g_varchar2_table(25) := '207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F207B0A20206261636B67726F756E642D636F6C6F723A20233030373664663B0A2020636F6C';
wwv_flow_api.g_varchar2_table(26) := '6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F';
wwv_flow_api.g_varchar2_table(27) := '6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C65';
wwv_flow_api.g_varchar2_table(28) := '72742D2D706167652E666F732D416C6572742D2D696E666F202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C';
wwv_flow_api.g_varchar2_table(29) := '6572742D2D64616E676572207B0A20206261636B67726F756E642D636F6C6F723A20236634343333363B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D';
wwv_flow_api.g_varchar2_table(30) := '416C6572742D69636F6E207B0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0A2020636F6C6F723A20234646463B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E66';
wwv_flow_api.g_varchar2_table(31) := '6F732D416C6572742D69636F6E202E742D49636F6E207B0A2020636F6C6F723A20696E68657269743B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E742D427574746F6E2D2D636C6F7365416C657274';
wwv_flow_api.g_varchar2_table(32) := '207B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A7D0A2F2A20486F72697A6F6E74616C20416C657274203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(33) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C207B0A20206D617267696E2D626F74746F6D3A20312E3672656D3B0A2020706F736974696F6E3A2072656C61746976653B';
wwv_flow_api.g_varchar2_table(34) := '0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D77726170207B0A2020646973706C61793A20666C65783B0A2020666C65782D646972656374696F6E3A20726F773B0A7D0A2E666F732D416C6572742D2D686F';
wwv_flow_api.g_varchar2_table(35) := '72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A202070616464696E673A203020313670783B0A2020666C65782D736872696E6B3A20303B0A2020646973706C61793A20666C65783B0A2020616C69676E2D6974656D733A2063656E74';
wwv_flow_api.g_varchar2_table(36) := '65723B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D636F6E74656E74207B0A202070616464696E673A20313670783B0A2020666C65783A203120303B0A2020646973706C61793A20666C65783B0A202066';
wwv_flow_api.g_varchar2_table(37) := '6C65782D646972656374696F6E3A20636F6C756D6E3B0A20206A7573746966792D636F6E74656E743A2063656E7465723B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B0A2020666C';
wwv_flow_api.g_varchar2_table(38) := '65782D736872696E6B3A20303B0A2020746578742D616C69676E3A2072696768743B0A202077686974652D73706163653A206E6F777261703B0A202070616464696E672D72696768743A20312E3672656D3B0A2020646973706C61793A20666C65783B0A';
wwv_flow_api.g_varchar2_table(39) := '2020616C69676E2D6974656D733A2063656E7465723B0A7D0A2E752D52544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B0A202070616464696E672D72696768743A20303B0A20207061';
wwv_flow_api.g_varchar2_table(40) := '6464696E672D6C6566743A20312E3672656D3B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D707479207B0A2020646973706C61793A206E6F6E653B0A7D0A2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(41) := '742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B0A2020666F6E742D73697A653A203272656D3B0A20206C696E652D6865696768743A20322E3472656D3B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A2E666F';
wwv_flow_api.g_varchar2_table(42) := '732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D626F64793A656D707479207B0A2020646973706C61793A206E6F6E653B0A7D0A2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F';
wwv_flow_api.g_varchar2_table(43) := '6E202E742D49636F6E207B0A2020666F6E742D73697A653A20333270783B0A202077696474683A20333270783B0A2020746578742D616C69676E3A2063656E7465723B0A20206865696768743A20333270783B0A20206C696E652D6865696768743A2031';
wwv_flow_api.g_varchar2_table(44) := '3B0A7D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20436F6D6D6F6E2050726F7065727469657320';
wwv_flow_api.g_varchar2_table(45) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D686F72697A6F6E74616C';
wwv_flow_api.g_varchar2_table(46) := '207B0A2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E31293B0A2020626F782D736861646F773A20302032707820347078202D327078207267626128302C20302C20302C20302E303735293B0A7D0A2E666F73';
wwv_flow_api.g_varchar2_table(47) := '2D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0A7D0A2E666F732D416C6572742D2D6E6F49';
wwv_flow_api.g_varchar2_table(48) := '636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020646973706C61793A206E6F6E653B0A7D0A2E742D426F64792D616C657274207B0A20206D617267696E3A20303B0A7D0A2E742D426F64792D616C657274202E666F732D41';
wwv_flow_api.g_varchar2_table(49) := '6C657274207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A2F2A2050616765204E6F74696669636174696F6E202853756363657373206F72204D65737361676529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(50) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D70616765207B0A20207472616E736974696F6E3A20302E327320656173652D6F75743B0A20206D';
wwv_flow_api.g_varchar2_table(51) := '61782D77696474683A2036343070783B0A20206D696E2D77696474683A2033323070783B0A20202F2A706F736974696F6E3A2066697865643B20746F703A20312E3672656D3B2072696768743A20312E3672656D3B2A2F0A20207A2D696E6465783A2031';
wwv_flow_api.g_varchar2_table(52) := '3030303B0A2020626F726465722D77696474683A20303B0A2020626F782D736861646F773A20302030203020302E3172656D207267626128302C20302C20302C20302E312920696E7365742C20302033707820397078202D327078207267626128302C20';
wwv_flow_api.g_varchar2_table(53) := '302C20302C20302E31293B0A20202F2A20466F72207665727920736D616C6C2073637265656E732C2066697420746865206D65737361676520746F2074686520746F70206F66207468652073637265656E202A2F0A20202F2A2053657420426F72646572';
wwv_flow_api.g_varchar2_table(54) := '2052616469757320746F2030206173206D657373616765206578697374732077697468696E20636F6E74656E74202A2F0A20202F2A2050616765204C6576656C205761726E696E6720616E64204572726F7273203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(55) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A20202F2A205363726F6C6C62617273202A2F0A7D0A2E666F732D416C6572742D2D7061676520';
wwv_flow_api.g_varchar2_table(56) := '2E666F732D416C6572742D627574746F6E73207B0A202070616464696E672D72696768743A20303B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E207B0A202070616464696E672D6C6566743A20312E3672656D';
wwv_flow_api.g_varchar2_table(57) := '3B0A202070616464696E672D72696768743A203870783B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E207B0A202070616464696E672D6C6566743A203870783B0A202070616464696E672D72';
wwv_flow_api.g_varchar2_table(58) := '696768743A20312E3672656D3B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E202E742D49636F6E207B0A2020666F6E742D73697A653A20323470783B0A202077696474683A20323470783B0A20206865696768';
wwv_flow_api.g_varchar2_table(59) := '743A20323470783B0A20206C696E652D6865696768743A20313B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B0A202070616464696E672D626F74746F6D3A203870783B0A7D0A2E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(60) := '2D70616765202E666F732D416C6572742D636F6E74656E74207B0A202070616464696E673A203870783B0A7D0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B0A2020706F736974696F6E3A206162';
wwv_flow_api.g_varchar2_table(61) := '736F6C7574653B0A202072696768743A202D3870783B0A2020746F703A202D3870783B0A202070616464696E673A203470783B0A20206D696E2D77696474683A20303B0A20206261636B67726F756E642D636F6C6F723A20233030302021696D706F7274';
wwv_flow_api.g_varchar2_table(62) := '616E743B0A2020636F6C6F723A20234646462021696D706F7274616E743B0A2020626F782D736861646F773A203020302030203170782072676261283235352C203235352C203235352C20302E3235292021696D706F7274616E743B0A2020626F726465';
wwv_flow_api.g_varchar2_table(63) := '722D7261646975733A20323470783B0A20207472616E736974696F6E3A202D7765626B69742D7472616E73666F726D20302E3132357320656173653B0A20207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173653B0A2020';
wwv_flow_api.g_varchar2_table(64) := '7472616E736974696F6E3A207472616E73666F726D20302E3132357320656173652C202D7765626B69742D7472616E73666F726D20302E3132357320656173653B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E742D427574746F';
wwv_flow_api.g_varchar2_table(65) := '6E2D2D636C6F7365416C657274207B0A202072696768743A206175746F3B0A20206C6566743A202D3870783B0A7D0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A686F766572207B0A20202D776562';
wwv_flow_api.g_varchar2_table(66) := '6B69742D7472616E73666F726D3A207363616C6528312E3135293B0A20207472616E73666F726D3A207363616C6528312E3135293B0A7D0A2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A6163746976';
wwv_flow_api.g_varchar2_table(67) := '65207B0A20202D7765626B69742D7472616E73666F726D3A207363616C6528302E3835293B0A20207472616E73666F726D3A207363616C6528302E3835293B0A7D0A2F2A2E752D52544C202E666F732D416C6572742D2D70616765207B2072696768743A';
wwv_flow_api.g_varchar2_table(68) := '206175746F3B206C6566743A20312E3672656D3B207D2A2F0A2E666F732D416C6572742D2D706167652E666F732D416C657274207B0A2020626F726465722D7261646975733A20302E3472656D3B0A7D0A2E666F732D416C6572742D2D70616765202E66';
wwv_flow_api.g_varchar2_table(69) := '6F732D416C6572742D7469746C65207B0A202070616464696E673A2038707820303B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E207B0A20206D617267696E2D';
wwv_flow_api.g_varchar2_table(70) := '72696768743A203870783B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C65207B0A2020666F6E742D73697A653A20312E3472656D3B0A20206C696E';
wwv_flow_api.g_varchar2_table(71) := '652D6865696768743A203272656D3B0A2020666F6E742D7765696768743A203730303B0A20206D617267696E3A20303B0A7D0A2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F7469666963617469';
wwv_flow_api.g_varchar2_table(72) := '6F6E2D6C697374207B0A20206D61782D6865696768743A2031323870783B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B0A20206D61782D6865696768743A20393670783B0A20206F76657266';
wwv_flow_api.g_varchar2_table(73) := '6C6F773A206175746F3B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C696E6B3A686F766572207B0A2020746578742D6465636F726174696F6E3A20756E6465726C696E653B0A7D0A2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(74) := '742D2D70616765203A3A2D7765626B69742D7363726F6C6C626172207B0A202077696474683A203870783B0A20206865696768743A203870783B0A7D0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D7468';
wwv_flow_api.g_varchar2_table(75) := '756D62207B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3235293B0A7D0A2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D747261636B207B0A20206261636B';
wwv_flow_api.g_varchar2_table(76) := '67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3035293B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B0A2020646973706C61793A20626C6F636B3B0A2020666F6E742D7765';
wwv_flow_api.g_varchar2_table(77) := '696768743A203730303B0A2020666F6E742D73697A653A20312E3872656D3B0A20206D617267696E2D626F74746F6D3A20303B0A20206D617267696E2D72696768743A20313670783B0A7D0A2E666F732D416C6572742D2D70616765202E666F732D416C';
wwv_flow_api.g_varchar2_table(78) := '6572742D626F6479207B0A20206D617267696E2D72696768743A20313670783B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B0A20206D617267696E2D72696768743A20303B0A20206D';
wwv_flow_api.g_varchar2_table(79) := '617267696E2D6C6566743A20313670783B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B0A20206D617267696E2D72696768743A20303B0A20206D617267696E2D6C6566743A2031367078';
wwv_flow_api.g_varchar2_table(80) := '3B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B0A20206D617267696E3A203470782030203020303B0A202070616464696E673A20303B0A20206C6973742D7374796C653A206E6F6E653B0A7D';
wwv_flow_api.g_varchar2_table(81) := '0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A202070616464696E672D6C6566743A20323070783B0A2020706F736974696F6E3A2072656C61746976653B0A2020666F6E742D73697A653A203134';
wwv_flow_api.g_varchar2_table(82) := '70783B0A20206C696E652D6865696768743A20323070783B0A20206D617267696E2D626F74746F6D3A203470783B0A20202F2A20457874726120536D616C6C2053637265656E73202A2F0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74';
wwv_flow_api.g_varchar2_table(83) := '696669636174696F6E2D6974656D3A6C6173742D6368696C64207B0A20206D617267696E2D626F74746F6D3A20303B0A7D0A2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A202070';
wwv_flow_api.g_varchar2_table(84) := '616464696E672D6C6566743A20303B0A202070616464696E672D72696768743A20323070783B0A7D0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B0A2020636F6E74656E743A2027';
wwv_flow_api.g_varchar2_table(85) := '273B0A2020706F736974696F6E3A206162736F6C7574653B0A20206D617267696E3A203870783B0A2020746F703A20303B0A20206C6566743A20303B0A202077696474683A203470783B0A20206865696768743A203470783B0A2020626F726465722D72';
wwv_flow_api.g_varchar2_table(86) := '61646975733A20313030253B0A20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E35293B0A7D0A2F2A2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D697465';
wwv_flow_api.g_varchar2_table(87) := '6D3A6265666F7265207B2072696768743A20303B206C6566743A206175746F3B207D2A2F0A2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D202E612D427574746F6E2D2D6E6F74696669636174696F6E207B';
wwv_flow_api.g_varchar2_table(88) := '0A202070616464696E673A203270783B0A20206F7061636974793A20302E37353B0A2020766572746963616C2D616C69676E3A20746F703B0A7D0A2E666F732D416C6572742D2D70616765202E68746D6C64624F7261457272207B0A20206D617267696E';
wwv_flow_api.g_varchar2_table(89) := '2D746F703A20302E3872656D3B0A2020646973706C61793A20626C6F636B3B0A2020666F6E742D73697A653A20312E3172656D3B0A20206C696E652D6865696768743A20312E3672656D3B0A2020666F6E742D66616D696C793A20274D656E6C6F272C20';
wwv_flow_api.g_varchar2_table(90) := '27436F6E736F6C6173272C206D6F6E6F73706163652C2073657269663B0A202077686974652D73706163653A207072652D6C696E653B0A7D0A2F2A2041636365737369626C652048656164696E67203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(91) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469';
wwv_flow_api.g_varchar2_table(92) := '746C65207B0A2020626F726465723A20303B0A2020636C69703A20726563742830203020302030293B0A20206865696768743A203170783B0A20206D617267696E3A202D3170783B0A20206F766572666C6F773A2068696464656E3B0A20207061646469';
wwv_flow_api.g_varchar2_table(93) := '6E673A20303B0A2020706F736974696F6E3A206162736F6C7574653B0A202077696474683A203170783B0A7D0A2F2A2048696464656E2048656164696E6720284E6F742041636365737369626C6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(94) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0A2E666F732D416C6572742D2D72656D6F766548656164696E67202E666F732D416C6572742D7469746C65';
wwv_flow_api.g_varchar2_table(95) := '207B0A2020646973706C61793A206E6F6E653B0A7D0A406D6564696120286D61782D77696474683A20343830707829207B0A20202E666F732D416C6572742D2D70616765207B0A202020202F2A6C6566743A20312E3672656D3B2A2F0A202020206D696E';
wwv_flow_api.g_varchar2_table(96) := '2D77696474683A20303B0A202020206D61782D77696474683A206E6F6E653B0A20207D0A20202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B0A20202020666F6E742D73697A653A20313270783B0A20';
wwv_flow_api.g_varchar2_table(97) := '207D0A7D0A406D6564696120286D61782D77696474683A20373638707829207B0A20202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B0A20202020666F6E742D73697A653A20312E3872656D3B0A';
wwv_flow_api.g_varchar2_table(98) := '20207D0A7D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A2F2A20';
wwv_flow_api.g_varchar2_table(99) := '49636F6E2E637373202A2F0A2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B0A2020666F6E742D66616D696C793A2022617065782D352D69636F6E2D666F6E74223B0A2020646973706C61793A20696E6C';
wwv_flow_api.g_varchar2_table(100) := '696E652D626C6F636B3B0A2020766572746963616C2D616C69676E3A20746F703B0A7D0A2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B0A20206C696E652D6865696768743A20313670783B0A2020666F';
wwv_flow_api.g_varchar2_table(101) := '6E742D73697A653A20313670783B0A2020636F6E74656E743A20225C65306132223B0A7D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(102) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A2E666F7374722D746F702D63656E746572207B0A2020746F703A20312E3672656D3B0A202072696768743A20303B0A202077696474683A20313030253B0A7D0A2E666F7374722D62';
wwv_flow_api.g_varchar2_table(103) := '6F74746F6D2D63656E746572207B0A2020626F74746F6D3A20312E3672656D3B0A202072696768743A20303B0A202077696474683A20313030253B0A7D0A2E666F7374722D746F702D7269676874207B0A2020746F703A20312E3672656D3B0A20207269';
wwv_flow_api.g_varchar2_table(104) := '6768743A20312E3672656D3B0A7D0A2E666F7374722D746F702D6C656674207B0A2020746F703A20312E3672656D3B0A20206C6566743A20312E3672656D3B0A7D0A2E666F7374722D626F74746F6D2D7269676874207B0A202072696768743A20312E36';
wwv_flow_api.g_varchar2_table(105) := '72656D3B0A2020626F74746F6D3A20312E3672656D3B0A7D0A2E666F7374722D626F74746F6D2D6C656674207B0A2020626F74746F6D3A20312E3672656D3B0A20206C6566743A20312E3672656D3B0A7D0A2E666F7374722D636F6E7461696E6572207B';
wwv_flow_api.g_varchar2_table(106) := '0A2020706F736974696F6E3A2066697865643B0A20207A2D696E6465783A203939393939393B0A2020706F696E7465722D6576656E74733A206E6F6E653B0A20202F2A6F76657272696465732A2F0A7D0A2E666F7374722D636F6E7461696E6572203E20';
wwv_flow_api.g_varchar2_table(107) := '646976207B0A2020706F696E7465722D6576656E74733A206175746F3B0A7D0A2E666F7374722D636F6E7461696E65722E666F7374722D746F702D63656E746572203E206469762C0A2E666F7374722D636F6E7461696E65722E666F7374722D626F7474';
wwv_flow_api.g_varchar2_table(108) := '6F6D2D63656E746572203E20646976207B0A20202F2A77696474683A2033303070783B2A2F0A20206D617267696E2D6C6566743A206175746F3B0A20206D617267696E2D72696768743A206175746F3B0A7D0A2E666F7374722D70726F6772657373207B';
wwv_flow_api.g_varchar2_table(109) := '0A2020706F736974696F6E3A206162736F6C7574653B0A2020626F74746F6D3A20303B0A20206865696768743A203470783B0A20206261636B67726F756E642D636F6C6F723A20626C61636B3B0A20206F7061636974793A20302E343B0A7D0A68746D6C';
wwv_flow_api.g_varchar2_table(110) := '3A6E6F74282E752D52544C29202E666F7374722D70726F6772657373207B0A20206C6566743A20303B0A2020626F726465722D626F74746F6D2D6C6566742D7261646975733A20302E3472656D3B0A7D0A68746D6C2E752D52544C202E666F7374722D70';
wwv_flow_api.g_varchar2_table(111) := '726F6772657373207B0A202072696768743A20303B0A2020626F726465722D626F74746F6D2D72696768742D7261646975733A20302E3472656D3B0A7D0A406D6564696120286D61782D77696474683A20343830707829207B0A20202E666F7374722D63';
wwv_flow_api.g_varchar2_table(112) := '6F6E7461696E6572207B0A202020206C6566743A20312E3672656D3B0A2020202072696768743A20312E3672656D3B0A20207D0A7D0A';
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
wwv_flow_api.g_varchar2_table(1) := '2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E67657220612C2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E6720617B636F6C6F723A696E68657269743B746578742D6465636F7261';
wwv_flow_api.g_varchar2_table(2) := '74696F6E3A756E6465726C696E657D2E666F732D416C6572742D2D686F72697A6F6E74616C7B626F726465722D7261646975733A3270783B6261636B67726F756E642D636F6C6F723A236666663B636F6C6F723A233236323632363B6D617267696E2D62';
wwv_flow_api.g_varchar2_table(3) := '6F74746F6D3A312E3672656D3B706F736974696F6E3A72656C61746976653B626F726465723A31707820736F6C6964207267626128302C302C302C2E31293B626F782D736861646F773A302032707820347078202D327078207267626128302C302C302C';
wwv_flow_api.g_varchar2_table(4) := '2E303735297D2E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A236666667D2E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A236662636634617D2E';
wwv_flow_api.g_varchar2_table(5) := '666F732D416C6572742D2D7761726E696E672E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A72676261283235312C3230372C37342C2E3135297D2E666F732D';
wwv_flow_api.g_varchar2_table(6) := '416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A233362616132637D2E666F732D416C6572742D2D737563636573732E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D';
wwv_flow_api.g_varchar2_table(7) := '416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A726762612835392C3137302C34342C2E3135297D2E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A2330303736';
wwv_flow_api.g_varchar2_table(8) := '64667D2E666F732D416C6572742D2D696E666F2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7267626128302C3131382C3232332C2E3135297D2E666F732D';
wwv_flow_api.g_varchar2_table(9) := '416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A236634343333367D2E666F732D416C6572742D2D64616E6765722E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C';
wwv_flow_api.g_varchar2_table(10) := '6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A72676261283234342C36372C35342C2E3135297D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D737563636573737B6261636B67726F756E642D636F6C6F723A72';
wwv_flow_api.g_varchar2_table(11) := '6762612835392C3137302C34342C2E39293B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472';
wwv_flow_api.g_varchar2_table(12) := '616E73706172656E743B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E2C2E666F732D416C6572742D2D706167652E666F73';
wwv_flow_api.g_varchar2_table(13) := '2D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E2C2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E2C2E666F';
wwv_flow_api.g_varchar2_table(14) := '732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E7B636F6C6F723A696E68657269747D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73';
wwv_flow_api.g_varchar2_table(15) := '756363657373202E742D427574746F6E2D2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E677B6261636B67726F756E642D636F6C';
wwv_flow_api.g_varchar2_table(16) := '6F723A236662636634613B636F6C6F723A233434333430327D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472616E7370';
wwv_flow_api.g_varchar2_table(17) := '6172656E743B636F6C6F723A233434333430327D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E742D427574746F6E2D2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E';
wwv_flow_api.g_varchar2_table(18) := '666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F7B6261636B67726F756E642D636F6C6F723A233030373664663B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F';
wwv_flow_api.g_varchar2_table(19) := '202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B636F6C6F723A236666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E742D427574746F6E2D';
wwv_flow_api.g_varchar2_table(20) := '2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E6765727B6261636B67726F756E642D636F6C6F723A236634343333363B636F6C6F723A23';
wwv_flow_api.g_varchar2_table(21) := '6666667D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E7B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B636F6C6F723A236666667D2E666F732D';
wwv_flow_api.g_varchar2_table(22) := '416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E742D427574746F6E2D2D636C6F7365416C6572747B636F6C6F723A2366666621696D706F7274616E747D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F73';
wwv_flow_api.g_varchar2_table(23) := '2D416C6572742D777261707B646973706C61793A666C65783B666C65782D646972656374696F6E3A726F777D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B70616464696E673A3020313670783B666C';
wwv_flow_api.g_varchar2_table(24) := '65782D736872696E6B3A303B646973706C61793A666C65783B616C69676E2D6974656D733A63656E7465727D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D636F6E74656E747B70616464696E673A313670783B66';
wwv_flow_api.g_varchar2_table(25) := '6C65783A3120303B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F6C756D6E3B6A7573746966792D636F6E74656E743A63656E7465727D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(26) := '627574746F6E737B666C65782D736872696E6B3A303B746578742D616C69676E3A72696768743B77686974652D73706163653A6E6F777261703B70616464696E672D72696768743A312E3672656D3B646973706C61793A666C65783B616C69676E2D6974';
wwv_flow_api.g_varchar2_table(27) := '656D733A63656E7465727D2E752D52544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E737B70616464696E672D72696768743A303B70616464696E672D6C6566743A312E3672656D7D2E666F73';
wwv_flow_api.g_varchar2_table(28) := '2D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D626F64793A656D7074792C2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D7074797B646973706C61793A6E6F6E';
wwv_flow_api.g_varchar2_table(29) := '657D2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C657B666F6E742D73697A653A3272656D3B6C696E652D6865696768743A322E3472656D3B6D617267696E2D626F74746F6D3A307D2E666F732D416C65';
wwv_flow_api.g_varchar2_table(30) := '72742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E202E742D49636F6E7B666F6E742D73697A653A333270783B77696474683A333270783B746578742D616C69676E3A63656E7465723B6865696768743A333270783B6C696E652D';
wwv_flow_api.g_varchar2_table(31) := '6865696768743A317D2E666F732D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E7B646973706C61793A6E6F6E6521696D706F7274616E747D2E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(32) := '2D6E6F49636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E7B646973706C61793A6E6F6E657D2E742D426F64792D616C6572747B6D617267696E3A307D2E742D426F64792D616C657274202E666F732D416C6572747B6D617267696E2D';
wwv_flow_api.g_varchar2_table(33) := '626F74746F6D3A307D2E666F732D416C6572742D2D706167657B7472616E736974696F6E3A2E327320656173652D6F75743B6D61782D77696474683A36343070783B6D696E2D77696474683A33323070783B7A2D696E6465783A313030303B626F726465';

wwv_flow_api.g_varchar2_table(34) := '722D77696474683A303B626F782D736861646F773A3020302030202E3172656D207267626128302C302C302C2E312920696E7365742C302033707820397078202D327078207267626128302C302C302C2E31297D2E666F732D416C6572742D2D70616765';
wwv_flow_api.g_varchar2_table(35) := '202E666F732D416C6572742D627574746F6E737B70616464696E672D72696768743A307D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E7B70616464696E672D6C6566743A312E3672656D3B70616464696E672D726967';
wwv_flow_api.g_varchar2_table(36) := '68743A3870787D2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E7B70616464696E672D6C6566743A3870783B70616464696E672D72696768743A312E3672656D7D2E666F732D416C6572742D2D706167';
wwv_flow_api.g_varchar2_table(37) := '65202E666F732D416C6572742D69636F6E202E742D49636F6E7B666F6E742D73697A653A323470783B77696474683A323470783B6865696768743A323470783B6C696E652D6865696768743A317D2E666F732D416C6572742D2D70616765202E666F732D';
wwv_flow_api.g_varchar2_table(38) := '416C6572742D626F64797B70616464696E672D626F74746F6D3A3870787D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D636F6E74656E747B70616464696E673A3870787D2E666F732D416C6572742D2D70616765202E742D4275';
wwv_flow_api.g_varchar2_table(39) := '74746F6E2D2D636C6F7365416C6572747B706F736974696F6E3A6162736F6C7574653B72696768743A2D3870783B746F703A2D3870783B70616464696E673A3470783B6D696E2D77696474683A303B6261636B67726F756E642D636F6C6F723A23303030';
wwv_flow_api.g_varchar2_table(40) := '21696D706F7274616E743B636F6C6F723A2366666621696D706F7274616E743B626F782D736861646F773A3020302030203170782072676261283235352C3235352C3235352C2E32352921696D706F7274616E743B626F726465722D7261646975733A32';
wwv_flow_api.g_varchar2_table(41) := '3470783B7472616E736974696F6E3A7472616E73666F726D202E3132357320656173653B7472616E736974696F6E3A7472616E73666F726D202E3132357320656173652C2D7765626B69742D7472616E73666F726D202E3132357320656173657D2E752D';
wwv_flow_api.g_varchar2_table(42) := '52544C202E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572747B72696768743A6175746F3B6C6566743A2D3870787D2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C65';
wwv_flow_api.g_varchar2_table(43) := '72743A686F7665727B2D7765626B69742D7472616E73666F726D3A7363616C6528312E3135293B7472616E73666F726D3A7363616C6528312E3135297D2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A';
wwv_flow_api.g_varchar2_table(44) := '6163746976657B2D7765626B69742D7472616E73666F726D3A7363616C65282E3835293B7472616E73666F726D3A7363616C65282E3835297D2E666F732D416C6572742D2D706167652E666F732D416C6572747B626F726465722D7261646975733A2E34';
wwv_flow_api.g_varchar2_table(45) := '72656D7D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C657B70616464696E673A38707820307D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174';
wwv_flow_api.g_varchar2_table(46) := '696F6E7B6D617267696E2D72696768743A3870787D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C657B666F6E742D73697A653A312E3472656D3B6C696E65';
wwv_flow_api.g_varchar2_table(47) := '2D6865696768743A3272656D3B666F6E742D7765696768743A3730303B6D617267696E3A307D2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D6C6973747B6D61782D68';
wwv_flow_api.g_varchar2_table(48) := '65696768743A31323870787D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C6973747B6D61782D6865696768743A393670783B6F766572666C6F773A6175746F7D2E666F732D416C6572742D2D70616765202E612D';
wwv_flow_api.g_varchar2_table(49) := '4E6F74696669636174696F6E2D6C696E6B3A686F7665727B746578742D6465636F726174696F6E3A756E6465726C696E657D2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261727B77696474683A3870783B686569';
wwv_flow_api.g_varchar2_table(50) := '6768743A3870787D2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C6261722D7468756D627B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E3235297D2E666F732D416C6572742D2D70616765';
wwv_flow_api.g_varchar2_table(51) := '203A3A2D7765626B69742D7363726F6C6C6261722D747261636B7B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E3035297D2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C657B646973706C61';
wwv_flow_api.g_varchar2_table(52) := '793A626C6F636B3B666F6E742D7765696768743A3730303B666F6E742D73697A653A312E3872656D3B6D617267696E2D626F74746F6D3A303B6D617267696E2D72696768743A313670787D2E666F732D416C6572742D2D70616765202E666F732D416C65';
wwv_flow_api.g_varchar2_table(53) := '72742D626F64797B6D617267696E2D72696768743A313670787D2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F64792C2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C657274';
wwv_flow_api.g_varchar2_table(54) := '2D7469746C657B6D617267696E2D72696768743A303B6D617267696E2D6C6566743A313670787D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C6973747B6D617267696E3A347078203020303B70616464696E673A';
wwv_flow_api.g_varchar2_table(55) := '303B6C6973742D7374796C653A6E6F6E657D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D7B70616464696E672D6C6566743A323070783B706F736974696F6E3A72656C61746976653B666F6E742D73697A';
wwv_flow_api.g_varchar2_table(56) := '653A313470783B6C696E652D6865696768743A323070783B6D617267696E2D626F74746F6D3A3470787D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C647B6D617267696E2D626F';
wwv_flow_api.g_varchar2_table(57) := '74746F6D3A307D2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D7B70616464696E672D6C6566743A303B70616464696E672D72696768743A323070787D2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(58) := '6765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F72657B636F6E74656E743A27273B706F736974696F6E3A6162736F6C7574653B6D617267696E3A3870783B746F703A303B6C6566743A303B77696474683A3470783B686569676874';
wwv_flow_api.g_varchar2_table(59) := '3A3470783B626F726465722D7261646975733A313030253B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E35297D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D202E612D427574';
wwv_flow_api.g_varchar2_table(60) := '746F6E2D2D6E6F74696669636174696F6E7B70616464696E673A3270783B6F7061636974793A2E37353B766572746963616C2D616C69676E3A746F707D2E666F732D416C6572742D2D70616765202E68746D6C64624F72614572727B6D617267696E2D74';
wwv_flow_api.g_varchar2_table(61) := '6F703A2E3872656D3B646973706C61793A626C6F636B3B666F6E742D73697A653A312E3172656D3B6C696E652D6865696768743A312E3672656D3B666F6E742D66616D696C793A274D656E6C6F272C27436F6E736F6C6173272C6D6F6E6F73706163652C';
wwv_flow_api.g_varchar2_table(62) := '73657269663B77686974652D73706163653A7072652D6C696E657D2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469746C657B626F726465723A303B636C69703A726563742830203020302030';
wwv_flow_api.g_varchar2_table(63) := '293B6865696768743A3170783B6D617267696E3A2D3170783B6F766572666C6F773A68696464656E3B70616464696E673A303B706F736974696F6E3A6162736F6C7574653B77696474683A3170787D2E666F732D416C6572742D2D72656D6F7665486561';
wwv_flow_api.g_varchar2_table(64) := '64696E67202E666F732D416C6572742D7469746C657B646973706C61793A6E6F6E657D406D6564696120286D61782D77696474683A3438307078297B2E666F732D416C6572742D2D706167657B6D696E2D77696474683A303B6D61782D77696474683A6E';
wwv_flow_api.g_varchar2_table(65) := '6F6E657D2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D7B666F6E742D73697A653A313270787D7D406D6564696120286D61782D77696474683A3736387078297B2E666F732D416C6572742D2D686F72697A';
wwv_flow_api.g_varchar2_table(66) := '6F6E74616C202E666F732D416C6572742D7469746C657B666F6E742D73697A653A312E3872656D7D7D2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F72657B666F6E742D66616D696C793A22617065782D352D6963';
wwv_flow_api.g_varchar2_table(67) := '6F6E2D666F6E74223B646973706C61793A696E6C696E652D626C6F636B3B766572746963616C2D616C69676E3A746F703B6C696E652D6865696768743A313670783B666F6E742D73697A653A313670783B636F6E74656E743A225C65306132227D2E666F';
wwv_flow_api.g_varchar2_table(68) := '7374722D746F702D63656E7465727B746F703A312E3672656D3B72696768743A303B77696474683A313030257D2E666F7374722D626F74746F6D2D63656E7465727B626F74746F6D3A312E3672656D3B72696768743A303B77696474683A313030257D2E';
wwv_flow_api.g_varchar2_table(69) := '666F7374722D746F702D72696768747B746F703A312E3672656D3B72696768743A312E3672656D7D2E666F7374722D746F702D6C6566747B746F703A312E3672656D3B6C6566743A312E3672656D7D2E666F7374722D626F74746F6D2D72696768747B72';
wwv_flow_api.g_varchar2_table(70) := '696768743A312E3672656D3B626F74746F6D3A312E3672656D7D2E666F7374722D626F74746F6D2D6C6566747B626F74746F6D3A312E3672656D3B6C6566743A312E3672656D7D2E666F7374722D636F6E7461696E65727B706F736974696F6E3A666978';
wwv_flow_api.g_varchar2_table(71) := '65643B7A2D696E6465783A3939393939393B706F696E7465722D6576656E74733A6E6F6E657D2E666F7374722D636F6E7461696E65723E6469767B706F696E7465722D6576656E74733A6175746F7D2E666F7374722D636F6E7461696E65722E666F7374';
wwv_flow_api.g_varchar2_table(72) := '722D626F74746F6D2D63656E7465723E6469762C2E666F7374722D636F6E7461696E65722E666F7374722D746F702D63656E7465723E6469767B6D617267696E2D6C6566743A6175746F3B6D617267696E2D72696768743A6175746F7D2E666F7374722D';
wwv_flow_api.g_varchar2_table(73) := '70726F67726573737B706F736974696F6E3A6162736F6C7574653B626F74746F6D3A303B6865696768743A3470783B6261636B67726F756E642D636F6C6F723A233030303B6F7061636974793A2E347D68746D6C3A6E6F74282E752D52544C29202E666F';
wwv_flow_api.g_varchar2_table(74) := '7374722D70726F67726573737B6C6566743A303B626F726465722D626F74746F6D2D6C6566742D7261646975733A2E3472656D7D68746D6C2E752D52544C202E666F7374722D70726F67726573737B72696768743A303B626F726465722D626F74746F6D';
wwv_flow_api.g_varchar2_table(75) := '2D72696768742D7261646975733A2E3472656D7D406D6564696120286D61782D77696474683A3438307078297B2E666F7374722D636F6E7461696E65727B6C6566743A312E3672656D3B72696768743A312E3672656D7D7D0A2F2A2320736F757263654D';
wwv_flow_api.g_varchar2_table(76) := '617070696E6755524C3D666F7374722E6373732E6D61702A2F';
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
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22666F7374722E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414155412C6F432C434144412C71432C434145452C612C434143412C79422C43414B462C73422C43';
wwv_flow_api.g_varchar2_table(2) := '4143452C69422C43413043412C71422C434143412C612C43417745412C6F422C434143412C69422C43416D44412C2B422C434143412C30432C4341744B462C75422C434143452C552C43414B462C32432C434143452C612C434145462C79442C43414345';
wwv_flow_api.g_varchar2_table(3) := '2C71432C43414B462C32432C434143452C612C434145462C79442C434143452C6F432C43414B462C77432C434143452C612C434145462C73442C434143452C6F432C43414B462C30432C434143452C612C434145462C77442C434143452C6F432C43416B';
wwv_flow_api.g_varchar2_table(4) := '42462C6D432C434143452C6D432C434143412C552C434145462C6D442C434143452C34422C434143412C552C43413443462C30442C434164412C77442C43413542412C32442C434163412C32442C434162452C612C434145462C79442C434143452C6F42';
wwv_flow_api.g_varchar2_table(5) := '2C434145462C6D432C434143452C77422C434143412C612C434145462C6D442C434143452C34422C434143412C612C43414B462C79442C434143452C6F422C434145462C67432C434143452C77422C434143412C552C434145462C67442C434143452C34';
wwv_flow_api.g_varchar2_table(6) := '422C434143412C552C43414B462C73442C434143452C6F422C434145462C6B432C434143452C77422C434143412C552C434145462C6B442C434143452C34422C434143412C552C43414B462C77442C434143452C6F422C43414F462C73432C434143452C';
wwv_flow_api.g_varchar2_table(7) := '592C434143412C6B422C434145462C73432C434143452C632C434143412C612C434143412C592C434143412C6B422C434145462C79432C434143452C592C434143412C512C434143412C592C434143412C71422C434143412C73422C434145462C79432C';
wwv_flow_api.g_varchar2_table(8) := '434143452C612C434143412C67422C434143412C6B422C434143412C6F422C434143412C592C434143412C6B422C434145462C67442C434143452C652C434143412C6D422C434155462C34432C434152412C2B432C434143452C592C434145462C75432C';
wwv_flow_api.g_varchar2_table(9) := '434143452C632C434143412C6B422C434143412C652C43414B462C38432C434143452C632C434143412C552C434143412C69422C434143412C572C434143412C612C43414F462C77442C434143452C73422C434145462C30432C434143452C592C434145';
wwv_flow_api.g_varchar2_table(10) := '462C612C434143452C512C434145462C77422C434143452C652C434147462C67422C434143452C75422C434143412C652C434143412C652C434145412C592C434143412C632C434143412C79452C43414D462C6D432C434143452C652C434145462C6743';
wwv_flow_api.g_varchar2_table(11) := '2C434143452C6D422C434143412C69422C434145462C75432C434143452C67422C434143412C6F422C434145462C77432C434143452C632C434143412C552C434143412C572C434143412C612C434145462C67432C434143452C6B422C434145462C6D43';
wwv_flow_api.g_varchar2_table(12) := '2C434143452C572C434145462C73432C434143452C69422C434143412C552C434143412C512C434143412C572C434143412C572C434143412C2B422C434143412C6F422C434143412C6F442C434143412C6B422C434145412C2B422C434143412C34442C';
wwv_flow_api.g_varchar2_table(13) := '434145462C36432C434143452C552C434143412C532C434145462C34432C434143452C36422C434143412C71422C434145462C36432C434143452C34422C434143412C6F422C434147462C30422C434143452C6D422C434145462C69432C434143452C61';
wwv_flow_api.g_varchar2_table(14) := '2C434145462C6D442C434143452C67422C434145462C79442C434143452C67422C434143412C67422C434143412C652C434143412C512C434145462C77442C434143452C67422C434145462C71432C434143452C652C434143412C612C434145462C3243';
wwv_flow_api.g_varchar2_table(15) := '2C434143452C79422C434145462C6F432C434143452C532C434143412C552C434145462C30432C434143452C67432C434145462C30432C434143452C67432C434145462C69432C434143452C612C434143412C652C434143412C67422C434143412C652C';
wwv_flow_api.g_varchar2_table(16) := '434143412C69422C434145462C67432C434143452C69422C43414D462C75432C43414A412C77432C434143452C632C434143412C67422C43414D462C71432C434143452C632C434143412C532C434143412C652C434145462C71432C434143452C69422C';
wwv_flow_api.g_varchar2_table(17) := '434143412C69422C434143412C632C434143412C67422C434143412C69422C434147462C67442C434143452C652C434145462C34432C434143452C632C434143412C6B422C434145462C34432C434143452C552C434143412C69422C434143412C552C43';
wwv_flow_api.g_varchar2_table(18) := '4143412C4B2C434143412C4D2C434143412C532C434143412C552C434143412C6B422C434143412C2B422C434147462C36442C434143452C572C434143412C572C434143412C6B422C434145462C38422C434143452C67422C434143412C612C43414341';
wwv_flow_api.g_varchar2_table(19) := '2C67422C434143412C6B422C434143412C38432C434143412C6F422C434147462C38432C434143452C512C434143412C6B422C434143412C552C434143412C572C434143412C652C434143412C532C434143412C69422C434143412C532C434147462C30';
wwv_flow_api.g_varchar2_table(20) := '432C434143452C592C434145462C79424143452C67422C434145452C572C434143412C632C434145462C71432C434143452C674241474A2C412C79424143452C75432C434143452C6B42414B4A2C6F432C434143452C38422C434143412C6F422C434143';
wwv_flow_api.g_varchar2_table(21) := '412C6B422C434147412C67422C434143412C632C434143412C652C434147462C69422C434143452C552C434143412C4F2C434143412C552C434145462C6F422C434143452C612C434143412C4F2C434143412C552C434145462C67422C434143452C552C';
wwv_flow_api.g_varchar2_table(22) := '434143412C592C434145462C652C434143452C552C434143412C572C434145462C6D422C434143452C592C434143412C612C434145462C6B422C434143452C612C434143412C572C434145462C67422C434143452C632C434143412C632C434143412C6D';
wwv_flow_api.g_varchar2_table(23) := '422C434147462C6F422C434143452C6D422C434147462C77432C434144412C71432C434147452C67422C434143412C69422C434145462C652C434143452C69422C434143412C512C434143412C552C434143412C71422C434143412C552C434145462C53';
wwv_flow_api.g_varchar2_table(24) := '4141532C75422C434143502C4D2C434143412C2B422C434145462C30422C434143452C4F2C434143412C67432C434145462C79424143452C67422C434143452C572C434143412C63222C2266696C65223A22666F7374722E637373222C22736F75726365';
wwv_flow_api.g_varchar2_table(25) := '73436F6E74656E74223A5B222F2A5C6E5C6E5C744E6F7465735C6E5C745C742A206162736F6C757465206C65667420616E642072696768742076616C7565732073686F756C64206E6F7720626520706C61636573206F6E2074686520636F6E7461696E65';
wwv_flow_api.g_varchar2_table(26) := '7220656C656D656E742C206E6F742074686520696E646976696475616C206E6F74696669636174696F6E735C6E5C6E2A2F5C6E2F2A2A5C6E202A204669786573206C696E6B207374796C696E6720696E206572726F72735C6E202A2F5C6E2E666F732D41';
wwv_flow_api.g_varchar2_table(27) := '6C6572742D2D706167652E666F732D416C6572742D2D7761726E696E6720612C5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E6765722061207B5C6E2020636F6C6F723A20696E68657269743B5C6E2020746578742D';
wwv_flow_api.g_varchar2_table(28) := '6465636F726174696F6E3A20756E6465726C696E653B5C6E7D5C6E2F2A2A5C6E202A20436F6C6F72697A6564204261636B67726F756E645C6E202A2F5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C207B5C6E2020626F726465722D726164';
wwv_flow_api.g_varchar2_table(29) := '6975733A203270783B5C6E7D5C6E2E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2F2A2A5C6E20202A204D6F6469666965723A205761726E696E675C6E20202A2F5C6E2E666F732D41';
wwv_flow_api.g_varchar2_table(30) := '6C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20236662636634613B5C6E7D5C6E2E666F732D416C6572742D2D7761726E696E672E666F732D416C6572742D2D686F72697A6F';
wwv_flow_api.g_varchar2_table(31) := '6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A2072676261283235312C203230372C2037342C20302E3135293B5C6E7D5C6E2F2A2A5C6E20202A204D6F6469666965723A2053756363657373';
wwv_flow_api.g_varchar2_table(32) := '5C6E20202A2F5C6E2E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20233342414132433B5C6E7D5C6E2E666F732D416C6572742D2D737563636573732E666F73';
wwv_flow_api.g_varchar2_table(33) := '2D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C2034342C20302E3135293B5C6E7D5C6E2F2A2A5C6E20202A204D6F6469';
wwv_flow_api.g_varchar2_table(34) := '666965723A20496E666F726D6174696F6E5C6E20202A2F5C6E2E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20233030373664663B5C6E7D5C6E2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(35) := '742D2D696E666F2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C203131382C203232332C20302E3135293B5C6E7D5C6E2F2A';
wwv_flow_api.g_varchar2_table(36) := '2A5C6E20202A204D6F6469666965723A20537563636573735C6E20202A2F5C6E2E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20236634343333363B5C6E7D5C6E';
wwv_flow_api.g_varchar2_table(37) := '2E666F732D416C6572742D2D64616E6765722E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A2072676261283234342C2036372C2035342C20302E';
wwv_flow_api.g_varchar2_table(38) := '3135293B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C207B5C6E20206261636B67726F756E642D636F6C6F723A20236666666666663B5C6E2020636F6C6F723A20233236323632363B5C6E7D5C6E2F2A5C6E2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(39) := '742D2D64616E6765727B5C6E5C744062673A206C69676874656E2840675F44616E6765722D42472C20343025293B5C6E5C746261636B67726F756E642D636F6C6F723A204062673B5C6E5C74636F6C6F723A206661646528636F6E747261737428406267';
wwv_flow_api.g_varchar2_table(40) := '2C2064657361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B5C6E7D5C6E2E666F732D416C657274';
wwv_flow_api.g_varchar2_table(41) := '2D2D696E666F207B5C6E5C744062673A206C69676874656E2840675F496E666F2D42472C20353525293B5C6E5C746261636B67726F756E642D636F6C6F723A204062673B5C6E5C74636F6C6F723A206661646528636F6E7472617374284062672C206465';
wwv_flow_api.g_varchar2_table(42) := '7361747572617465286461726B656E284062672C202031303025292C2031303025292C2064657361747572617465286C69676874656E284062672C202031303025292C2035302529292C2031303025293B5C6E7D5C6E2A2F5C6E2E666F732D416C657274';
wwv_flow_api.g_varchar2_table(43) := '2D2D706167652E666F732D416C6572742D2D73756363657373207B5C6E20206261636B67726F756E642D636F6C6F723A20726762612835392C203137302C2034342C20302E39293B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D416C';
wwv_flow_api.g_varchar2_table(44) := '6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20234646463B5C6E7D5C';
wwv_flow_api.g_varchar2_table(45) := '6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D73756363657373202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D7061';
wwv_flow_api.g_varchar2_table(46) := '67652E666F732D416C6572742D2D73756363657373202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C';
wwv_flow_api.g_varchar2_table(47) := '6572742D2D7761726E696E67207B5C6E20206261636B67726F756E642D636F6C6F723A20236662636634613B5C6E2020636F6C6F723A20233434333430323B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E';
wwv_flow_api.g_varchar2_table(48) := '696E67202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20233434333430323B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D';
wwv_flow_api.g_varchar2_table(49) := '416C6572742D2D7761726E696E67202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E6720';
wwv_flow_api.g_varchar2_table(50) := '2E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F207B5C6E20206261636B67726F';
wwv_flow_api.g_varchar2_table(51) := '756E642D636F6C6F723A20233030373664663B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E207B5C6E20206261636B6772';
wwv_flow_api.g_varchar2_table(52) := '6F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A20234646463B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E666F732D416C6572742D69636F6E202E742D49636F';
wwv_flow_api.g_varchar2_table(53) := '6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D696E666F202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021';
wwv_flow_api.g_varchar2_table(54) := '696D706F7274616E743B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572207B5C6E20206261636B67726F756E642D636F6C6F723A20236634343333363B5C6E2020636F6C6F723A20234646463B5C6E7D';
wwv_flow_api.g_varchar2_table(55) := '5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E207B5C6E20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B5C6E2020636F6C6F723A2023';
wwv_flow_api.g_varchar2_table(56) := '4646463B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D64616E676572202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020636F6C6F723A20696E68657269743B5C6E7D5C6E2E666F732D416C';
wwv_flow_api.g_varchar2_table(57) := '6572742D2D706167652E666F732D416C6572742D2D64616E676572202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E7D5C6E2F2A20486F72697A6F6E74616C20416C65';
wwv_flow_api.g_varchar2_table(58) := '7274203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D686F72697A6F';
wwv_flow_api.g_varchar2_table(59) := '6E74616C207B5C6E20206D617267696E2D626F74746F6D3A20312E3672656D3B5C6E2020706F736974696F6E3A2072656C61746976653B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D77726170207B';
wwv_flow_api.g_varchar2_table(60) := '5C6E2020646973706C61793A20666C65783B5C6E2020666C65782D646972656374696F6E3A20726F773B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E202070616464696E673A20';
wwv_flow_api.g_varchar2_table(61) := '3020313670783B5C6E2020666C65782D736872696E6B3A20303B5C6E2020646973706C61793A20666C65783B5C6E2020616C69676E2D6974656D733A2063656E7465723B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F73';
wwv_flow_api.g_varchar2_table(62) := '2D416C6572742D636F6E74656E74207B5C6E202070616464696E673A20313670783B5C6E2020666C65783A203120303B5C6E2020646973706C61793A20666C65783B5C6E2020666C65782D646972656374696F6E3A20636F6C756D6E3B5C6E20206A7573';
wwv_flow_api.g_varchar2_table(63) := '746966792D636F6E74656E743A2063656E7465723B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B5C6E2020666C65782D736872696E6B3A20303B5C6E2020746578742D616C69';
wwv_flow_api.g_varchar2_table(64) := '676E3A2072696768743B5C6E202077686974652D73706163653A206E6F777261703B5C6E202070616464696E672D72696768743A20312E3672656D3B5C6E2020646973706C61793A20666C65783B5C6E2020616C69676E2D6974656D733A2063656E7465';
wwv_flow_api.g_varchar2_table(65) := '723B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E73207B5C6E202070616464696E672D72696768743A20303B5C6E202070616464696E672D6C6566743A20312E3672';
wwv_flow_api.g_varchar2_table(66) := '656D3B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D627574746F6E733A656D707479207B5C6E2020646973706C61793A206E6F6E653B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74';
wwv_flow_api.g_varchar2_table(67) := '616C202E666F732D416C6572742D7469746C65207B5C6E2020666F6E742D73697A653A203272656D3B5C6E20206C696E652D6865696768743A20322E3472656D3B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E7D5C6E2E666F732D416C6572';
wwv_flow_api.g_varchar2_table(68) := '742D2D686F72697A6F6E74616C202E666F732D416C6572742D626F64793A656D707479207B5C6E2020646973706C61793A206E6F6E653B5C6E7D5C6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E202E';
wwv_flow_api.g_varchar2_table(69) := '742D49636F6E207B5C6E2020666F6E742D73697A653A20333270783B5C6E202077696474683A20333270783B5C6E2020746578742D616C69676E3A2063656E7465723B5C6E20206865696768743A20333270783B5C6E20206C696E652D6865696768743A';
wwv_flow_api.g_varchar2_table(70) := '20313B5C6E7D5C6E2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D20436F6D6D6F6E2050726F70657274';
wwv_flow_api.g_varchar2_table(71) := '696573203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D686F72697A';
wwv_flow_api.g_varchar2_table(72) := '6F6E74616C207B5C6E2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E31293B5C6E2020626F782D736861646F773A20302032707820347078202D327078207267626128302C20302C20302C20302E303735293B';
wwv_flow_api.g_varchar2_table(73) := '5C6E7D5C6E2E666F732D416C6572742D2D6E6F49636F6E2E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D69636F6E207B5C6E2020646973706C61793A206E6F6E652021696D706F7274616E743B5C6E7D5C6E2E666F';
wwv_flow_api.g_varchar2_table(74) := '732D416C6572742D2D6E6F49636F6E202E666F732D416C6572742D69636F6E202E742D49636F6E207B5C6E2020646973706C61793A206E6F6E653B5C6E7D5C6E2E742D426F64792D616C657274207B5C6E20206D617267696E3A20303B5C6E7D5C6E2E74';
wwv_flow_api.g_varchar2_table(75) := '2D426F64792D616C657274202E666F732D416C657274207B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E7D5C6E2F2A2050616765204E6F74696669636174696F6E202853756363657373206F72204D65737361676529203D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(76) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D70616765207B5C6E20207472616E736974';
wwv_flow_api.g_varchar2_table(77) := '696F6E3A20302E327320656173652D6F75743B5C6E20206D61782D77696474683A2036343070783B5C6E20206D696E2D77696474683A2033323070783B5C6E20202F2A706F736974696F6E3A2066697865643B20746F703A20312E3672656D3B20726967';
wwv_flow_api.g_varchar2_table(78) := '68743A20312E3672656D3B2A2F5C6E20207A2D696E6465783A20313030303B5C6E2020626F726465722D77696474683A20303B5C6E2020626F782D736861646F773A20302030203020302E3172656D207267626128302C20302C20302C20302E31292069';
wwv_flow_api.g_varchar2_table(79) := '6E7365742C20302033707820397078202D327078207267626128302C20302C20302C20302E31293B5C6E20202F2A20466F72207665727920736D616C6C2073637265656E732C2066697420746865206D65737361676520746F2074686520746F70206F66';
wwv_flow_api.g_varchar2_table(80) := '207468652073637265656E202A2F5C6E20202F2A2053657420426F726465722052616469757320746F2030206173206D657373616765206578697374732077697468696E20636F6E74656E74202A2F5C6E20202F2A2050616765204C6576656C20576172';

wwv_flow_api.g_varchar2_table(81) := '6E696E6720616E64204572726F7273203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E20202F2A20';
wwv_flow_api.g_varchar2_table(82) := '5363726F6C6C62617273202A2F5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D627574746F6E73207B5C6E202070616464696E672D72696768743A20303B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E66';
wwv_flow_api.g_varchar2_table(83) := '6F732D416C6572742D69636F6E207B5C6E202070616464696E672D6C6566743A20312E3672656D3B5C6E202070616464696E672D72696768743A203870783B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C65';
wwv_flow_api.g_varchar2_table(84) := '72742D69636F6E207B5C6E202070616464696E672D6C6566743A203870783B5C6E202070616464696E672D72696768743A20312E3672656D3B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D69636F6E202E742D4963';
wwv_flow_api.g_varchar2_table(85) := '6F6E207B5C6E2020666F6E742D73697A653A20323470783B5C6E202077696474683A20323470783B5C6E20206865696768743A20323470783B5C6E20206C696E652D6865696768743A20313B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E66';
wwv_flow_api.g_varchar2_table(86) := '6F732D416C6572742D626F6479207B5C6E202070616464696E672D626F74746F6D3A203870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D636F6E74656E74207B5C6E202070616464696E673A203870783B5C6E';
wwv_flow_api.g_varchar2_table(87) := '7D5C6E2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E202072696768743A202D3870783B5C6E2020746F703A202D3870783B5C6E2020';
wwv_flow_api.g_varchar2_table(88) := '70616464696E673A203470783B5C6E20206D696E2D77696474683A20303B5C6E20206261636B67726F756E642D636F6C6F723A20233030302021696D706F7274616E743B5C6E2020636F6C6F723A20234646462021696D706F7274616E743B5C6E202062';
wwv_flow_api.g_varchar2_table(89) := '6F782D736861646F773A203020302030203170782072676261283235352C203235352C203235352C20302E3235292021696D706F7274616E743B5C6E2020626F726465722D7261646975733A20323470783B5C6E20207472616E736974696F6E3A202D77';
wwv_flow_api.g_varchar2_table(90) := '65626B69742D7472616E73666F726D20302E3132357320656173653B5C6E20207472616E736974696F6E3A207472616E73666F726D20302E3132357320656173653B5C6E20207472616E736974696F6E3A207472616E73666F726D20302E313235732065';
wwv_flow_api.g_varchar2_table(91) := '6173652C202D7765626B69742D7472616E73666F726D20302E3132357320656173653B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C657274207B5C6E202072696768743A206175';
wwv_flow_api.g_varchar2_table(92) := '746F3B5C6E20206C6566743A202D3870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A686F766572207B5C6E20202D7765626B69742D7472616E73666F726D3A207363616C6528312E';
wwv_flow_api.g_varchar2_table(93) := '3135293B5C6E20207472616E73666F726D3A207363616C6528312E3135293B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E742D427574746F6E2D2D636C6F7365416C6572743A616374697665207B5C6E20202D7765626B69742D7472616E73';
wwv_flow_api.g_varchar2_table(94) := '666F726D3A207363616C6528302E3835293B5C6E20207472616E73666F726D3A207363616C6528302E3835293B5C6E7D5C6E2F2A2E752D52544C202E666F732D416C6572742D2D70616765207B2072696768743A206175746F3B206C6566743A20312E36';
wwv_flow_api.g_varchar2_table(95) := '72656D3B207D2A2F5C6E2E666F732D416C6572742D2D706167652E666F732D416C657274207B5C6E2020626F726465722D7261646975733A20302E3472656D3B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D746974';
wwv_flow_api.g_varchar2_table(96) := '6C65207B5C6E202070616464696E673A2038707820303B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E207B5C6E20206D617267696E2D72696768743A2038';
wwv_flow_api.g_varchar2_table(97) := '70783B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F74696669636174696F6E2D7469746C65207B5C6E2020666F6E742D73697A653A20312E3472656D3B5C6E20206C696E652D6865';
wwv_flow_api.g_varchar2_table(98) := '696768743A203272656D3B5C6E2020666F6E742D7765696768743A203730303B5C6E20206D617267696E3A20303B5C6E7D5C6E2E666F732D416C6572742D2D706167652E666F732D416C6572742D2D7761726E696E67202E612D4E6F7469666963617469';
wwv_flow_api.g_varchar2_table(99) := '6F6E2D6C697374207B5C6E20206D61782D6865696768743A2031323870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B5C6E20206D61782D6865696768743A20393670783B5C6E2020';
wwv_flow_api.g_varchar2_table(100) := '6F766572666C6F773A206175746F3B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C696E6B3A686F766572207B5C6E2020746578742D6465636F726174696F6E3A20756E6465726C696E653B5C6E7D5C';
wwv_flow_api.g_varchar2_table(101) := '6E2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C626172207B5C6E202077696474683A203870783B5C6E20206865696768743A203870783B5C6E7D5C6E2E666F732D416C6572742D2D70616765203A3A2D7765626B69';
wwv_flow_api.g_varchar2_table(102) := '742D7363726F6C6C6261722D7468756D62207B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3235293B5C6E7D5C6E2E666F732D416C6572742D2D70616765203A3A2D7765626B69742D7363726F6C6C62';
wwv_flow_api.g_varchar2_table(103) := '61722D747261636B207B5C6E20206261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C20302E3035293B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D7469746C65207B5C6E202064697370';
wwv_flow_api.g_varchar2_table(104) := '6C61793A20626C6F636B3B5C6E2020666F6E742D7765696768743A203730303B5C6E2020666F6E742D73697A653A20312E3872656D3B5C6E20206D617267696E2D626F74746F6D3A20303B5C6E20206D617267696E2D72696768743A20313670783B5C6E';
wwv_flow_api.g_varchar2_table(105) := '7D5C6E2E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B5C6E20206D617267696E2D72696768743A20313670783B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D';
wwv_flow_api.g_varchar2_table(106) := '7469746C65207B5C6E20206D617267696E2D72696768743A20303B5C6E20206D617267696E2D6C6566743A20313670783B5C6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E666F732D416C6572742D626F6479207B5C6E20206D';
wwv_flow_api.g_varchar2_table(107) := '617267696E2D72696768743A20303B5C6E20206D617267696E2D6C6566743A20313670783B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6C697374207B5C6E20206D617267696E3A2034707820302030';
wwv_flow_api.g_varchar2_table(108) := '20303B5C6E202070616464696E673A20303B5C6E20206C6973742D7374796C653A206E6F6E653B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B5C6E202070616464696E672D6C6566743A';
wwv_flow_api.g_varchar2_table(109) := '20323070783B5C6E2020706F736974696F6E3A2072656C61746976653B5C6E2020666F6E742D73697A653A20313470783B5C6E20206C696E652D6865696768743A20323070783B5C6E20206D617267696E2D626F74746F6D3A203470783B5C6E20202F2A';
wwv_flow_api.g_varchar2_table(110) := '20457874726120536D616C6C2053637265656E73202A2F5C6E7D5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6C6173742D6368696C64207B5C6E20206D617267696E2D626F74746F6D3A20303B5C';
wwv_flow_api.g_varchar2_table(111) := '6E7D5C6E2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B5C6E202070616464696E672D6C6566743A20303B5C6E202070616464696E672D72696768743A20323070783B5C6E7D5C6E2E';
wwv_flow_api.g_varchar2_table(112) := '666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B5C6E2020636F6E74656E743A2027273B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E20206D617267696E3A203870783B';
wwv_flow_api.g_varchar2_table(113) := '5C6E2020746F703A20303B5C6E20206C6566743A20303B5C6E202077696474683A203470783B5C6E20206865696768743A203470783B5C6E2020626F726465722D7261646975733A20313030253B5C6E20206261636B67726F756E642D636F6C6F723A20';
wwv_flow_api.g_varchar2_table(114) := '7267626128302C20302C20302C20302E35293B5C6E7D5C6E2F2A2E752D52544C202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D3A6265666F7265207B2072696768743A20303B206C6566743A206175746F';
wwv_flow_api.g_varchar2_table(115) := '3B207D2A2F5C6E2E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D202E612D427574746F6E2D2D6E6F74696669636174696F6E207B5C6E202070616464696E673A203270783B5C6E20206F7061636974793A20';
wwv_flow_api.g_varchar2_table(116) := '302E37353B5C6E2020766572746963616C2D616C69676E3A20746F703B5C6E7D5C6E2E666F732D416C6572742D2D70616765202E68746D6C64624F7261457272207B5C6E20206D617267696E2D746F703A20302E3872656D3B5C6E2020646973706C6179';
wwv_flow_api.g_varchar2_table(117) := '3A20626C6F636B3B5C6E2020666F6E742D73697A653A20312E3172656D3B5C6E20206C696E652D6865696768743A20312E3672656D3B5C6E2020666F6E742D66616D696C793A20274D656E6C6F272C2027436F6E736F6C6173272C206D6F6E6F73706163';
wwv_flow_api.g_varchar2_table(118) := '652C2073657269663B5C6E202077686974652D73706163653A207072652D6C696E653B5C6E7D5C6E2F2A2041636365737369626C652048656164696E67203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(119) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D61636365737369626C6548656164696E67202E666F732D416C6572742D7469746C65207B5C6E2020626F726465723A';
wwv_flow_api.g_varchar2_table(120) := '20303B5C6E2020636C69703A20726563742830203020302030293B5C6E20206865696768743A203170783B5C6E20206D617267696E3A202D3170783B5C6E20206F766572666C6F773A2068696464656E3B5C6E202070616464696E673A20303B5C6E2020';
wwv_flow_api.g_varchar2_table(121) := '706F736974696F6E3A206162736F6C7574653B5C6E202077696474683A203170783B5C6E7D5C6E2F2A2048696464656E2048656164696E6720284E6F742041636365737369626C6529203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(122) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F5C6E2E666F732D416C6572742D2D72656D6F766548656164696E67202E666F732D416C6572742D7469746C65207B5C6E20';
wwv_flow_api.g_varchar2_table(123) := '20646973706C61793A206E6F6E653B5C6E7D5C6E406D6564696120286D61782D77696474683A20343830707829207B5C6E20202E666F732D416C6572742D2D70616765207B5C6E202020202F2A6C6566743A20312E3672656D3B2A2F5C6E202020206D69';
wwv_flow_api.g_varchar2_table(124) := '6E2D77696474683A20303B5C6E202020206D61782D77696474683A206E6F6E653B5C6E20207D5C6E20202E666F732D416C6572742D2D70616765202E612D4E6F74696669636174696F6E2D6974656D207B5C6E20202020666F6E742D73697A653A203132';
wwv_flow_api.g_varchar2_table(125) := '70783B5C6E20207D5C6E7D5C6E406D6564696120286D61782D77696474683A20373638707829207B5C6E20202E666F732D416C6572742D2D686F72697A6F6E74616C202E666F732D416C6572742D7469746C65207B5C6E20202020666F6E742D73697A65';
wwv_flow_api.g_varchar2_table(126) := '3A20312E3872656D3B5C6E20207D5C6E7D5C6E2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(127) := '2D2D2D2D2D2D202A2F5C6E2F2A2049636F6E2E637373202A2F5C6E2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B5C6E2020666F6E742D66616D696C793A205C22617065782D352D69636F6E2D666F6E74';
wwv_flow_api.g_varchar2_table(128) := '5C223B5C6E2020646973706C61793A20696E6C696E652D626C6F636B3B5C6E2020766572746963616C2D616C69676E3A20746F703B5C6E7D5C6E2E666F732D416C657274202E742D49636F6E2E69636F6E2D636C6F73653A6265666F7265207B5C6E2020';
wwv_flow_api.g_varchar2_table(129) := '6C696E652D6865696768743A20313670783B5C6E2020666F6E742D73697A653A20313670783B5C6E2020636F6E74656E743A205C225C5C653061325C223B5C6E7D5C6E2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(130) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F5C6E2E666F7374722D746F702D63656E746572207B5C6E2020746F703A20312E3672656D3B5C6E20207269';
wwv_flow_api.g_varchar2_table(131) := '6768743A20303B5C6E202077696474683A20313030253B5C6E7D5C6E2E666F7374722D626F74746F6D2D63656E746572207B5C6E2020626F74746F6D3A20312E3672656D3B5C6E202072696768743A20303B5C6E202077696474683A20313030253B5C6E';
wwv_flow_api.g_varchar2_table(132) := '7D5C6E2E666F7374722D746F702D7269676874207B5C6E2020746F703A20312E3672656D3B5C6E202072696768743A20312E3672656D3B5C6E7D5C6E2E666F7374722D746F702D6C656674207B5C6E2020746F703A20312E3672656D3B5C6E20206C6566';
wwv_flow_api.g_varchar2_table(133) := '743A20312E3672656D3B5C6E7D5C6E2E666F7374722D626F74746F6D2D7269676874207B5C6E202072696768743A20312E3672656D3B5C6E2020626F74746F6D3A20312E3672656D3B5C6E7D5C6E2E666F7374722D626F74746F6D2D6C656674207B5C6E';
wwv_flow_api.g_varchar2_table(134) := '2020626F74746F6D3A20312E3672656D3B5C6E20206C6566743A20312E3672656D3B5C6E7D5C6E2E666F7374722D636F6E7461696E6572207B5C6E2020706F736974696F6E3A2066697865643B5C6E20207A2D696E6465783A203939393939393B5C6E20';
wwv_flow_api.g_varchar2_table(135) := '20706F696E7465722D6576656E74733A206E6F6E653B5C6E20202F2A6F76657272696465732A2F5C6E7D5C6E2E666F7374722D636F6E7461696E6572203E20646976207B5C6E2020706F696E7465722D6576656E74733A206175746F3B5C6E7D5C6E2E66';
wwv_flow_api.g_varchar2_table(136) := '6F7374722D636F6E7461696E65722E666F7374722D746F702D63656E746572203E206469762C5C6E2E666F7374722D636F6E7461696E65722E666F7374722D626F74746F6D2D63656E746572203E20646976207B5C6E20202F2A77696474683A20333030';
wwv_flow_api.g_varchar2_table(137) := '70783B2A2F5C6E20206D617267696E2D6C6566743A206175746F3B5C6E20206D617267696E2D72696768743A206175746F3B5C6E7D5C6E2E666F7374722D70726F6772657373207B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E202062';
wwv_flow_api.g_varchar2_table(138) := '6F74746F6D3A20303B5C6E20206865696768743A203470783B5C6E20206261636B67726F756E642D636F6C6F723A20626C61636B3B5C6E20206F7061636974793A20302E343B5C6E7D5C6E68746D6C3A6E6F74282E752D52544C29202E666F7374722D70';
wwv_flow_api.g_varchar2_table(139) := '726F6772657373207B5C6E20206C6566743A20303B5C6E2020626F726465722D626F74746F6D2D6C6566742D7261646975733A20302E3472656D3B5C6E7D5C6E68746D6C2E752D52544C202E666F7374722D70726F6772657373207B5C6E202072696768';
wwv_flow_api.g_varchar2_table(140) := '743A20303B5C6E2020626F726465722D626F74746F6D2D72696768742D7261646975733A20302E3472656D3B5C6E7D5C6E406D6564696120286D61782D77696474683A20343830707829207B5C6E20202E666F7374722D636F6E7461696E6572207B5C6E';
wwv_flow_api.g_varchar2_table(141) := '202020206C6566743A20312E3672656D3B5C6E2020202072696768743A20312E3672656D3B5C6E20207D5C6E7D5C6E225D7D';
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


