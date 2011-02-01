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

class JOSSOAgent
   
  ####
  # initialize
  # params: identity_manager: URL of JOSSO identity manager defined in config/josso_config.yml
  # 	    identity_provider: URL of JOSSO identity provider defined in config/josso_config.yml
  #         session_manager: URL of JOSSO session manager defined in config/josso_config.yml
  #         ws_timeout: Timeout for consuming JOSSO webservices
  # result: WSDL-like URLs of JOSSO identity manager and provider, and session manager
  ####
  def initialize(identity_manager = nil, identity_provider = nil, session_manager = nil, ws_timeout = nil)
    @url_identity_manager = identity_manager + "?wsdl"
    @url_identity_provider = identity_provider + "?wsdl"
    @url_session_manager = session_manager + "?wsdl"
    @timeout = ws_timeout
  end
  
  ########################################
  # JOSSO IDENTITY MANAGER WS OPERATIONS #
  ########################################

  ####
  # findRolesByUsername
  # params: ssosid: SSO session id
  # result: provides the roles defined by JOSSO for SSO session id given
  ####
  def findRolesBySSOSessionId(ssosid)
    require 'soap/wsdlDriver'
    factory = SOAP::WSDLDriverFactory.new(@url_identity_manager)
    driver = factory.create_rpc_driver
    driver.streamhandler.client.receive_timeout = @timeout
    result = driver.findRolesBySSOSessionId(:requester => "findRolesBySSOSessionId", :ssoSessionId => ssosid)
    rescue SOAP::FaultError
      return nil
    else
      return result
  end

  ####
  # findUserInSession
  # params: ssosid: SSO session id
  # result: provides the user identified by JOSSO for SSO session id given
  ####
  def findUserInSession(ssosid)
    require 'soap/wsdlDriver'
    factory = SOAP::WSDLDriverFactory.new(@url_identity_manager)
    driver = factory.create_rpc_driver
    driver.streamhandler.client.receive_timeout = @timeout
    result = driver.findUserInSession(:requester => "findUserInSession", :ssoSessionId => ssosid)
    rescue SOAP::FaultError
      return nil
    else
      return result
  end

  ####
  # findUserInSecurityDomain
  # params: sd: security domain
  #         ssosid: SSO session id
  # result: provides the user identified by JOSSO for SSO session id given and a security domain
  ####
  #def findUserInSecurityDomain(sd,ssosid)
  #  require 'soap/wsdlDriver'
  #  factory = SOAP::WSDLDriverFactory.new(@url_identity_manager)
  #  driver = factory.create_rpc_driver
  #  driver.streamhandler.client.receive_timeout = @timeout
  #  result = driver.findUserInSecurityDomain(:securityDomain => sd, :ssoSessionId => ssosid)
  #  rescue SOAP::FaultError
  #    return nil
  #  else
  #    return result
  #end

  ####
  # userExists
  # params: sd: security domain
  #         ssosid: SSO session id
  # result: return true if user exists
  ####
  def userExists(sd,ssosid)
    require 'soap/wsdlDriver'
    factory = SOAP::WSDLDriverFactory.new(@url_identity_manager)
    driver = factory.create_rpc_driver
    driver.streamhandler.client.receive_timeout = @timeout
    result = driver.userExists(:requester => "userExists", :securityDomain => sd, :ssoSessionId => ssosid)
    rescue SOAP::FaultError
      return nil
    else
      return result
  end

  #########################################
  # JOSSO IDENTITY PROVIDER WS OPERATIONS #
  #########################################

  ####
  # resolveAuthenticationAsssertion
  # params: ssoaid: SSO assertion id
  # result: return the JOSSO session id for a assertion id given
  ####
  def resolveAuthenticationAssertion(ssoaid)
    require 'soap/wsdlDriver'
    factory = SOAP::WSDLDriverFactory.new(@url_identity_provider)
    driver = factory.create_rpc_driver
    driver.streamhandler.client.receive_timeout = @timeout
    result = driver.resolveAuthenticationAssertion(:requester => "resolveAuthenticationAssertion",:assertionId => ssoaid)
    rescue SOAP::FaultError
      return nil
    else
      return result
  end

  ####
  # globalSignoff
  # params: ssosid: SSO session id
  # result: sign off a session
  ####
  def globalSignoff(ssosid)
    require 'soap/wsdlDriver'
    factory = SOAP::WSDLDriverFactory.new(@url_identity_provider)
    driver = factory.create_rpc_driver
    driver.streamhandler.client.receive_timeout = @timeout
    result = driver.globalSignoff(:requester => "globalSignoff", :ssoSessionId => ssosid)
    rescue SOAP::FaultError
      return nil
    else
      return result
  end

  #########################################
  # JOSSO SESSION MANAGER WS OPERATIONS   #
  #########################################

  ####
  # getSession
  # params: ssosid: SSO session id
  # result: provides the JOSSO session object
  ####
  def getSession(ssosid)
    require 'soap/wsdlDriver'
    factory = SOAP::WSDLDriverFactory.new(@url_session_manager)
    driver = factory.create_rpc_driver
    driver.streamhandler.client.receive_timeout = @timeout
    result = driver.getSession(:requester => "getSession", :sessionId => ssosid)
    rescue SOAP::FaultError
      return nil
    else
      return result
  end


  
end
