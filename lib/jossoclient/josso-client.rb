#####################################################################################
#
# Copyright (C) 2011 Ildefonso Montero Perez
#
# Se permite la libre distribucion y modificacion de este codigo fuente bajo los
# terminos de la licencia GPL siempre que se indique de forma clara
# la autoria de Ildefonso Montero Perez.
#
# Para usos comerciales de este software contacte con ildefonso.montero@gmail.com
#
# This code is free software; you can redistribute it and/or modify it under
# the terms of the GPL GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your option)
# any later version. This code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# See the GNU General Public License for more details.
# For any commercial use of this software contact ildefonso.montero@gmail.com
#
#####################################################################################

require 'jossoclient/josso-agent'

module JOSSOClient
 class JOSSOClientManager
  class << self

  ####
  # login_josso_client
  # params: controller
  # result: if there not exists a session created it begins one
  ####
  def login_josso_client(controller, flag)
    begin
      partner_application_entry_url = JOSSO_CONFIG::APP_CONFIG['partner_application_entry_url']
      puts partner_application_entry_url
      if (controller.session[:username].nil?)
        authenticate_josso(partner_application_entry_url, controller.params[:josso_assertion_id], controller, flag)
      else
        is_josso_session_expire(partner_application_entry_url,controller)
      end
    end
  end

  ####
  # authenticate_josso
  # params: partner_application_entry_url: URL that performs the request 
  #         josso_assertion_id: JOSSO assertion id
  #         controller: AppController
  # result: it begins a session by means of an authentication in JOSSO
  ####
  def authenticate_josso(partner_application_entry_url, josso_assertion_id, controller, flag)
    begin
      if (josso_assertion_id.nil?)
        controller.send(:redirect_to, JOSSO_CONFIG::APP_CONFIG['josso_root'] + "signon/login.do?josso_back_to=" + partner_application_entry_url)
      else
        if(flag == true)
  	 identity_manager = JOSSO_CONFIG::APP_CONFIG['josso_root'] + JOSSO_CONFIG::APP_CONFIG['josso_identity_manager']
         identity_provider = JOSSO_CONFIG::APP_CONFIG['josso_root'] + JOSSO_CONFIG::APP_CONFIG['josso_identity_provider']
	 session_manager = JOSSO_CONFIG::APP_CONFIG['josso_root'] + JOSSO_CONFIG::APP_CONFIG['josso_session_manager']
	 timeout_ws = JOSSO_CONFIG::APP_CONFIG['josso_ws_timeout']
         josso_agent = JOSSOAgent.new(identity_manager, identity_provider, session_manager, timeout_ws)
         josso_session_id = josso_agent.resolveAuthenticationAssertion(josso_assertion_id)
         if (josso_session_id.nil?)
          controller.send(:redirect_to, JOSSO_CONFIG::APP_CONFIG['josso_root'] + "signon/login.do?josso_assertion_id=" + josso_assertion_id + "&josso_back_to=" + partner_application_entry_url)
          return false
         else
  	  josso_user = josso_agent.findUserInSession(josso_session_id.ssoSessionId)
 	  if(josso_user.nil?)
           controller.send(:redirect_to, JOSSO_CONFIG::APP_CONFIG['josso_root'] + "signon/login.do?josso_assertion_id=" +josso_assertion_id+"&josso_back_to=" + partner_application_entry_url)
           return false
	  else
	    josso_user_string = josso_user.inspect
	    josso_user_string_index_start = josso_user_string.index("name=\"")+6
	    josso_user_substring_aux = josso_user_string[josso_user_string_index_start,josso_user_string.length]	
	    josso_user_string_index_end = josso_user_substring_aux.index("\"")
	    josso_user_substring = josso_user_substring_aux[0,josso_user_string_index_end]
	    controller.session[:josso_user_name] = josso_user_substring
            controller.session[:josso_id] = josso_session_id.ssoSessionId
	  end
         end
	end
        #roles = josso_agent.findRolesBySSOSessionId(josso_session_id)
 	#role_names = []
	#unless roles.nil?
  	#for role in roles
	#   role_names.push role.name
	#end
        #controller.session[:roles] = role_names

      end
    rescue Exception => e
      puts e
    end
  end

  ####
  # is_josso_session_expire
  # params: partner_application_entry_url: URL that performs the request 
  # result: judge the expiry of the session
  ####
  def is_josso_session_expire(partner_application_entry_url, controller)
    begin
      if JOSSO_CONFIG::APP_CONFIG['session_timer'] == 0
        controller.session[:session_timer_at] = Time.now.to_i
	return
      end
      if(((Time.now.to_i - controller.session[:session_timer_at].to_i) > JOSSO_CONFIG::APP_CONFIG['session_timer']))
        logout_josso_client(true, controller)
      else
        controller.session[:session_timer_at] = Time.now.to_i
      end
    end
  end
  
  ####
  # logout
  # params: n/a 
  # result: logout from the JOSSO
  ####
  def logout_josso_client(redirect, controller, ssoSessionId)
    begin
       identity_manager = JOSSO_CONFIG::APP_CONFIG['josso_root'] + JOSSO_CONFIG::APP_CONFIG['josso_identity_manager']
       identity_provider = JOSSO_CONFIG::APP_CONFIG['josso_root'] + JOSSO_CONFIG::APP_CONFIG['josso_identity_provider']
       session_manager = JOSSO_CONFIG::APP_CONFIG['josso_root'] + JOSSO_CONFIG::APP_CONFIG['josso_session_manager']
       timeout_ws = JOSSO_CONFIG::APP_CONFIG['josso_ws_timeout']
       josso_agent = JOSSOAgent.new(identity_manager, identity_provider, session_manager, timeout_ws)
       josso_agent.globalSignoff(ssoSessionId)
    rescue Exception => e
      puts e
    end
  end
 end
end
end
