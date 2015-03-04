#   Copyright 2015 jgelderloos
#   
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Class: Main
#
#   Description:
#   Holds the main data for the app

require "Qt"
require_relative "Brew"
require_relative "GUI"

class Main

  def initialize 
    # Setup empty brew
    @brew = Brew.new( "Untitled Brew" )

    app = Qt::Application.new( ARGV )
    
    # Setup GUI
    @gui = BrewApp.new
    @gui.set_controller self

    app.exec()

  end

  def add_grain( name, mass, unit, ppg, efficiency )
    # if ppg or eff is not already nil (empty field) set it to float so we can perform math on it
    ppg = ppg.to_f if ppg != nil
    efficiency = efficiency.to_f if efficiency != nil
    # if ppg or eff is 0 set it to nil so we get the defult value
    ppg = nil if ppg == 0
    efficiency = nil if efficiency == 0
    g = Grain.new( name, mass.to_f, unit, ppg, efficiency )
    g = @brew.add_grain( g )
    # Throw the brew back to the GUI to be displayed
    @gui.brew_update( @brew )
    # TODO look into removing the return, why is it here?
    return g
  end

  def update_grain( name, mass, unit, ppg, efficiency )
    # Dont need any of the checks here like in add_grain since the loaded values will be good\
    # and anything else was the user specifically changing it
    g = Grain.new( name, mass.to_f, unit, ppg.to_f, efficiency.to_f )
    g = @brew.update_grain( g )
    # Throw brew back to GUI
    @gui.brew_update( @brew )
  end

  def add_hops( name, alpha, beta, mass, unit )
    h = Hops.new( name, alpha.to_f, beta.to_f, mass.to_f, unit )
    @brew.add_hops( h )
    @gui.brew_update( @brew )
  end

  def add_yeast( name, attenuation )
    y = Yeast.new( name, attenuation.to_f )
    @brew.yeast = y
    @gui.brew_update( @brew )
  end



end

if __FILE__ == $0
  app = Main.new
end

