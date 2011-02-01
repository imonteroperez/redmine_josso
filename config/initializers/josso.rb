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

module JOSSO_CONFIG
  APP_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/../josso_config.yml")[RAILS_ENV]
end
