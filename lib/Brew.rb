#   Copyright 2014 jgelderloos
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
#   Class: Brew
#
#   Description:
#   Holds the recipe for the beer and performs calculations needed 
#	throughout the brewing process.

require_relative "Hops"
require_relative "Grain"
require_relative "Water"
require_relative "Yeast"

class Brew
  attr_accessor :name
  attr_reader   :grains
  attr_reader   :hops
  attr_accessor :yeast
  attr_accessor :lbs_grain_total
  attr_reader   :volume_mash
  attr_accessor :ratio_mash
  attr_reader   :volume_mash_loss
  attr_accessor :ratio_mash_loss
  attr_accessor :volume_mash_dead_loss
  attr_reader   :volume_sparge
  attr_reader   :volume_preboil
  attr_accessor :rate_boil_off
  attr_reader   :volume_boil_loss
  attr_accessor :min_boil_time
  attr_accessor :volume_trub_loss
  attr_reader   :volume_shrinkage_loss
  attr_accessor :percent_shrinkage
  attr_accessor :volume_final
  attr_reader   :gravity_original
  attr_reader   :gravity_final
  attr_reader   :percent_abv
  attr_accessor :ibu
  
  WEIGHT_ETHYL_ALCOHOL = 1.05
  DENSITY_ETHYL_ALCOHOL = 0.79
  
  def initialize name = ""
    # TODO: Possibly add setters with .abs for a lot of these
    @name = name.to_s
    @grains = []
    @hops = []
    @yeast = Yeast.new("Yeast name")
    @lbs_grain_total = 0
    @volume_mash = Water.new
    @ratio_mash = 1.5 # qts/lbs
    @volume_mash_loss = Water.new
    @ratio_mash_loss = 0.5 # qts/lbs
    @volume_mash_dead_loss = Water.new
    @volume_sparge = Water.new
    @volume_preboil = Water.new
    @rate_boil_off = 1.0 # gal/hr
    @volume_boil_loss = Water.new
    @min_boil_time = 0
    @volume_trub_loss = Water.new
    @volume_shrinkage_loss = Water.new
    @percent_shrinkage = 4
    @volume_final = Water.new
    @gravity_original = 1
    @gravity_final = 1
    @percent_abv = 0
    @ibu = 0
  end
  
  def add_grain grain
    @grains << grain if (grain.is_a? Grain) && (!self.has_grain?(grain.type))
  end
  
  def remove_grain grain
    @grains.delete(grain)
  end
 
  def remove_grain_at index
    @grains.delete_at(index)
  end

  def has_grain? type
    ret = false
    @grains.each do |grain|
      if( grain.type == type.downcase )
        ret = true
      end
    end
    return ret
  end

  def update_grain grain
    # If this grain already exists
    if( self.has_grain?(grain.type) )
      idx = @grains.index{ |x| x.type == grain.type }
      @grains.delete_at(idx)
      @grains.insert(idx, grain)
    else
      self.add_grain(grain)
    end
  end
  
  def add_hops hops
    @hops << hops if (hops.is_a? Hops) && (!self.has_hops?(hops.type))
  end
  
  def remove_hops hops
    @hops.delete(hops)
  end
  
  def remove_hops_at index
    @hops.delete_at(index)
  end
  
  def has_hops? type
    ret = false
    @hops.each do |hop|
      if( hop.type == type.downcase )
        ret = true
      end
    end
    return ret
  end

  def update_hops hop
    # If this hop already exists
    if( self.has_hops?(hop.type) )
      idx = @hops.index{ |x| x.type == hop.type }
      @hops.delete_at(idx)
      @hops.insert(idx, hop)
    else
      self.add_hops(hop)
    end
  end
 
  # returns total grain mass in lbs
  def total_grain_mass?
    lbs_of_grain = 0
    @grains.each do |grain|
      lbs_of_grain += grain.convert_to( "lbs" )
    end
    return lbs_of_grain
  end
  
  # Volume of water used in the mash
  def calc_volume_mash!
    lbs = total_grain_mass?
    qts = lbs * @ratio_mash.abs
    @volume_mash.set_unit("qts")
    @volume_mash.volume = qts
    @volume_mash.convert_to!("gal")
  end
  
  def calc_volume_mash
    lbs = total_grain_mass?
    qts = lbs * @ratio_mash.abs
    return qts / 4.0
  end
  
  # Volume of water left in the grains
  def calc_volume_mash_loss!
    lbs = total_grain_mass?
    qts = lbs * @ratio_mash_loss.abs
    @volume_mash_loss.set_unit("qts")
    @volume_mash_loss.volume = qts
    @volume_mash_loss.convert_to!("gal")
  end
  
  def calc_volume_mash_loss
    lbs = total_grain_mass?
    qts = lbs * @ratio_mash_loss.abs
    return qts / 4.0
  end
  
  # Volume of water lost due to evaportation during the boil
  def calc_volume_boil_loss!
    @volume_boil_loss.set_unit("gal")
    @volume_boil_loss.volume = calc_volume_boil_loss
  end
  
  def calc_volume_boil_loss
    @min_boil_time / 60.0 * @rate_boil_off
  end
  
  # Volume lost when the wort cools and shrinks
  def calc_volume_shrinkage_loss!
    @volume_shrinkage_loss.set_unit("gal")
    @volume_shrinkage_loss.volume = calc_volume_shrinkage_loss
  end
  
  def calc_volume_shrinkage_loss
    vol_post_shrink = @volume_final.convert_to( "gal" )
    vol_post_shrink += @volume_trub_loss.convert_to( "gal" )
    shrink_factor = 100.0 / (100.0 - @percent_shrinkage)
    vol_pre_shrink = vol_post_shrink * shrink_factor
    return vol_pre_shrink - vol_post_shrink
  end
  
  # Volume of wort prior to boiling
  def calc_volume_preboil!
    @volume_preboil.set_unit("gal")
    @volume_preboil.volume = calc_volume_preboil
  end
  
  def calc_volume_preboil
    vol = @volume_final.convert_to( "gal" )
    vol += @volume_trub_loss.convert_to( "gal" )
    vol += @volume_shrinkage_loss.convert_to( "gal" )
    vol += @volume_boil_loss.convert_to( "gal" )
  end
  
  # Volume of water used for sparge
  def calc_volume_sparge!
    @volume_sparge.set_unit("gal")
    @volume_sparge.volume = calc_volume_sparge
  end
  
  def calc_volume_sparge
    return @volume_preboil.convert_to( "gal" ) - (@volume_mash.convert_to( "gal" ) - @volume_mash_loss.convert_to( "gal" ))
  end
  
  # calculating original gravity
  def calc_gravity_original!
    @gravity_original = calc_gravity_original
  end
  
  def calc_gravity_original
    vol = @volume_final.convert_to( "gal" )
    vol += @volume_trub_loss.convert_to( "gal" )
    
    gravity = 0
    
    @grains.each do |grain|
      weight = grain.convert_to("lbs")
      gravity += (weight * grain.ppg_potential * (grain.percent_efficiency/100.0)) / vol
    end
    
    gravity = (gravity / 1000.0) + 1
  end
  
  # calculating final gravity
  def calc_gravity_final!
    @gravity_final = calc_gravity_final
  end
  
  def calc_gravity_final
    gravity = (( @gravity_original - 1 ) * (1 - (@yeast.percent_attenuation / 100.0 ))) + 1
  end
  
  # calculating abv
  def calc_percent_abv!
    @percent_abv = calc_percent_abv
  end
  
  def calc_percent_abv
    abw = ((@gravity_original - @gravity_final)*WEIGHT_ETHYL_ALCOHOL)/@gravity_final
    abv = (abw / DENSITY_ETHYL_ALCOHOL) * 100.0
  end
 
  # Returns mass of hops in oz
  def total_hops_mass?
    oz_of_hops = 0
    @hops.each do |hop|
      oz_of_hops = oz_of_hops + hop.convert_to( "oz" )
    end
    return oz_of_hops
  end

  # Very simple IBU calculation, not very accurate
  # TODO: add ! version
  def calc_ibu
    ibu = 0
    @hops.each do |hop|
      ibu += ( (hop.alpha * 0.3 / 0.01335 / @volume_final.volume ) * (hop.convert_to("oz").to_f / total_hops_mass?().to_f ) ) 
    end
    return ibu
  end

end
