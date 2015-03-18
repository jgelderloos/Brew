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

    # Send initial brew for gui init
    @gui.brew_update( @brew )

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
    @brew.add_grain( g )

    self.recalculate_brew
    # Throw the brew back to the GUI to be displayed
    @gui.brew_update( @brew )
  end

  def update_grain( name, mass, unit, ppg, efficiency )
    # Dont need any of the checks here like in add_grain since the loaded values will be good\
    # and anything else was the user specifically changing it
    g = Grain.new( name, mass.to_f, unit, ppg.to_f, efficiency.to_f )
    @brew.update_grain( g )

    self.recalculate_brew
    # Throw brew back to GUI
    @gui.brew_update( @brew )
  end

  def remove_grain( name )
    index = @brew.grains.index { |x| x.type == name }
    @brew.remove_grain_at( index )

    self.recalculate_brew
    @gui.brew_update( @brew )
  end

  def add_hops( name, alpha, beta, mass, unit )
    # if alpha or beta is not already nil (empty field) set it to float so we can perform math on it
    alpha = alpha.to_f if alpha != nil
    beta = beta.to_f if beta != nil
    # if alpha or beta is 0 set it to nil so we get the defult value
    alpha = nil if alpha == 0
    beta = nil if beta == 0
    h = Hops.new( name, alpha, beta, mass.to_f, unit )
    @brew.add_hops( h )

    self.recalculate_brew
    # Throw the brew back to the GUI to be displayed
    @gui.brew_update( @brew )
  end

  def update_hops( name, mass, unit, alpha, beta )
    # Dont need any of the checks here like in add_hops since the loaded values will be good\
    # and anything else was the user specifically changing it
    h = Hops.new( name, alpha.to_f, beta.to_f, mass.to_f, unit )
    @brew.update_hops( h )

    self.recalculate_brew
    # Throw brew back to GUI
    @gui.brew_update( @brew )
  end

  def remove_hops( name )
    index = @brew.hops.index { |x| x.type == name }
    @brew.remove_hops_at( index )

    self.recalculate_brew
    @gui.brew_update( @brew )
  end

  def add_yeast( name, attenuation )
    # Only add a new yeast if there is not one that already exists
    if( @brew.yeast == nil )
      attenuation = attenuation.to_f if attenuation != nil
      attenuation = nil if attenuation == 0
      y = Yeast.new( name, attenuation )
      @brew.yeast = y

      self.recalculate_brew
      @gui.brew_update( @brew )
    end
  end

  def update_yeast( name, attenuation )
    y = Yeast.new( name, attenuation.to_f )
    @brew.yeast = y

    self.recalculate_brew
    @gui.brew_update( @brew )
  end

  def remove_yeast
    @brew.yeast = nil

    self.recalculate_brew
    @gui.brew_update( @brew )
  end

  def update_values( final_volume, mash_ratio, mash_ratio_loss, boil_time,
                     trub_loss, dead_loss, rate_boil_off, shrinkage )
    @brew.volume_final.volume = final_volume.to_f
    @brew.ratio_mash = mash_ratio.to_f
    @brew.ratio_mash_loss = mash_ratio_loss.to_f
    @brew.min_boil_time = boil_time.to_f
    @brew.volume_trub_loss.volume = trub_loss.to_f
    @brew.volume_mash_dead_loss.volume = dead_loss.to_f
    @brew.rate_boil_off = rate_boil_off.to_f
    @brew.percent_shrinkage = shrinkage.to_f

    self.recalculate_brew
    @gui.brew_update( @brew )
  end

  def recalculate_brew
    @brew.calc_volume_mash!
    @brew.calc_volume_mash_loss!
    @brew.calc_volume_boil_loss!
    @brew.calc_volume_shrinkage_loss!
    @brew.calc_volume_preboil!
    @brew.calc_volume_sparge!
    @brew.calc_gravity_original!
    @brew.calc_gravity_final!
    @brew.calc_percent_abv!
  end

end

if __FILE__ == $0
  app = Main.new
end

