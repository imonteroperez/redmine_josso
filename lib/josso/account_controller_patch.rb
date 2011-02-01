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

require 'jossoclient/josso-client'
require 'dispatcher'
 
module JOSSO
  module AccountControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        alias_method_chain :login, :josso
        alias_method_chain :logout, :josso
      end
    end

    module InstanceMethods
      def login_with_josso
        if JOSSO_CONFIG::APP_CONFIG['enabled']
          if params[:josso_assertion_id]
   	      JOSSOClient::JOSSOClientManager::login_josso_client(self,true)
	      if session[:josso_user_name] && session[:josso_id]
		 @josso_user = User.find_by_login session[:josso_user_name]
		 @josso_id = session[:josso_id]
                 successful_authentication(@josso_user)
	      else
		 flash[:error] = "No se ha obtenido ningun usuario"
	      end
          else
	    JOSSOClient::JOSSOClientManager::login_josso_client(self,false)
          end
	else
	  flash[:warning] = "No esta habilitada la autenticacion con JOSSO"
        end
	if @josso_id
	  session[:josso_id] = @josso_id
	end
	return false
      end

      def logout_with_josso
        if JOSSO_CONFIG::APP_CONFIG['enabled']
	  if session[:josso_id]
	    JOSSOClient::JOSSOClientManager::logout_josso_client(true,self,session[:josso_id])
	    self.reset_session
	  else
	    flash[:error] = "No se encuentra el identificador de sesion"
	  end
        redirect_to home_url
	else
	  flash[:warning] = "No esta habilitada la autenticacion con JOSSO"
          redirect_to home_url
        end
      end
    end
  end
end

Dispatcher.to_prepare do
  require_dependency 'account_controller'
  AccountController.send(:include, JOSSO::AccountControllerPatch)
end
