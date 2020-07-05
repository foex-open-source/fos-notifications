create or replace package com_fos_notifications
as

    function render
      ( p_dynamic_action apex_plugin.t_dynamic_action
      , p_plugin         apex_plugin.t_plugin
      )
    return apex_plugin.t_dynamic_action_render_result;

end;
/


