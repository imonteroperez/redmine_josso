#####################################################################################
#
# Copyright (C) 2009 Ildefonso Montero Perez
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
# Run initializers
# Needs to be atop requires because some of them need to be run after initialization
Dir["#{File.dirname(__FILE__)}/config/initializers/**/*.rb"].sort.each do |initializer|
  require initializer
end

require 'redmine'
require 'josso/account_controller_patch'
#require 'josso/application_controller_patch'
#require 'josso/setting_patch'
#require 'josso/user_patch'

Redmine::Plugin.register :redmine_josso do
  name 'Redmine JOSSO Plugin'
  author 'Ildefonso Montero'
  description 'Authentication plugin for JOSSO'
  version '1.0.0-beta'
  url 'http://imonteroperez.blogspot.com'
  author_url 'http://es.linkedin.com/in/ildefonsomonteroperez'
end
