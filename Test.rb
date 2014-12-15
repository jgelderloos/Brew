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
#   Class: Tester
#
#   Description:
#   Unit tests for the brew app.

require "test/unit"

require_relative "Hops"
require_relative "Grain"
require_relative "Water"
require_relative "Brew"
require_relative "Yeast"
require_relative "FileManager"

class Tester < Test::Unit::TestCase
    def test_hops
    
        # Test invalid inputs
        assert_raise RuntimeError do
            h = Hops.new( "blah", 0, 0 )
        end
        
        assert_raise RuntimeError do
            h = Hops.new( "chinook", nil, 0 )
        end
        
        assert_raise RuntimeError do
            h = Hops.new( "chinook", 0, "five" )
        end
        
        assert_raise RuntimeError do
            h = Hops.new( "chinook", 0, 0, "five" )
        end
        
        # Test valid inputs
        h = Hops.new( "chinook", 5.6, 10 )
        
        assert h.type == "chinook"
        assert h.alpha == 5.6
        assert h.beta == 10
        assert h.mass == 0
        assert h.unit == "oz"
                
        # Test no negative values for alpha, beta, and mass
        
        h = Hops.new( "cascade", -3, -4.4, -1 )
        
        assert h.type == "cascade"
        assert h.alpha == 3
        assert h.beta == 4.4
        assert h.mass == 1
        
        # Test setting alpha and beta
        
        h.set_alpha( 3 )
        assert h.alpha == 3
        
        h.set_alpha( 1.1 )
        assert h.alpha == 1.1
        
        h.set_alpha( -5 )
        assert h.alpha == 5
        
        h.set_beta( 4 )
        assert h.beta == 4
        
        h.set_beta( 2.1 )
        assert h.beta == 2.1
        
        h.set_beta( -1 )
        assert h.beta == 1
        
        # Test units
        
        h = Hops.new( "chinook", 5.6, 10, 1, "g" )
        
        assert h.type == "chinook"
        assert h.alpha == 5.6
        assert h.beta == 10
        assert h.mass == 1
        assert h.unit == "g"
        
        h = Hops.new( "chinook", 5.6, 10, 1, "Oz" )
        
        assert h.type == "chinook"
        assert h.alpha == 5.6
        assert h.beta == 10
        assert h.mass == 1
        assert h.unit == "oz"
        
        assert_raise RuntimeError do
            h.set_unit( "fail" )
        end        
        
        # Test setting mass and units
        
        h.set_mass( 2 )
        assert h.mass == 2
        h.set_unit( "g" )
        assert h.unit == "g"
        
        # Test unit conversion
        
        h = Hops.new( "chinook", 5.6, 10, 1, "oz" )
        assert h.convert_to( "G" ) ==  28.34949254408346
        h.convert_to!( "G" )
        assert h.unit == "g"
        assert h.mass == 28.34949254408346
        
        h = Hops.new( "chinook", 5.6, 10, 40, "g" )
        assert h.convert_to( "oz" ) ==  1.41096
        h.convert_to!( "oz" )
        assert h.unit == "oz"
        assert h.mass == 1.41096
        
        # No change
        assert h.convert_to( "test" ) == nil
        h.convert_to!( "test" )
        assert h.unit == "oz"
        assert h.mass == 1.41096
    end
    
    def test_grain_initalize
    
        # Test invalid inputs
        
        assert_raise RuntimeError do
            g = Grain.new( "blah" )
        end
        
        assert_raise RuntimeError do
            g = Grain.new( "wheat", nil )
        end
        
        # Test valid inputs
        
        g = Grain.new( "wheat" )
        
        assert g.type == "wheat"
        assert g.mass == 0
        assert g.unit == "lbs"
        assert g.ppg_potential == 45
        assert g.percent_efficiency = 70
        
        g = Grain.new( "wheat", 12, "lbs" )
        
        assert g.type == "wheat"
        assert g.mass == 12
        assert g.unit == "lbs"
        assert g.ppg_potential == 45
        assert g.percent_efficiency = 70
        
        g = Grain.new( "wheat", 12, "lbs", 33 )
        
        assert g.type == "wheat"
        assert g.mass == 12
        assert g.unit == "lbs"
        assert g.ppg_potential == 33
        assert g.percent_efficiency = 70
        
        g = Grain.new( "wheat", 12, "lbs", 45, 76 )
        
        assert g.type == "wheat"
        assert g.mass == 12
        assert g.unit == "lbs"
        assert g.ppg_potential == 45
        assert g.percent_efficiency = 76
        
        # Test no negative mass
        
        g = Grain.new( "wheat", -12, "lbs" )
        
        assert g.type == "wheat"
        assert g.mass == 12
        assert g.unit == "lbs"
        
        # Test units
        
        g = Grain.new( "wheat", -12, "kg" )
        
        assert g.type == "wheat"
        assert g.mass == 12
        assert g.unit == "kg"
        
        assert_raise RuntimeError do
            g = Grain.new( "wheat", -12, "fail" )
        end        
        
        # Test setting mass and units
        
        g.set_mass( 2 )
        assert g.mass == 2
        g.set_unit( "Lbs" )
        assert g.unit == "lbs"
        
        # Test unit conversion
        
        g = Grain.new( "wheat", 1, "lbs" )
        assert g.convert_to( "Kg" ) == 0.45359188070533535
        g.convert_to!( "Kg" )
        assert g.unit == "kg"
        assert g.mass == 0.45359188070533535
        
        g = Grain.new( "wheat", 45, "kg" )
        assert g.convert_to( "lbs" ) == 99.208125
        g.convert_to!( "lbs" )
        assert g.unit == "lbs"
        assert g.mass == 99.208125
        
        # No change
        assert g.convert_to( "test" ) == nil
        g.convert_to!( "test" )
        assert g.unit == "lbs"
        assert g.mass == 99.208125
    end
    
    def test_water
        # Test init
        
        w = Water.new
        
        assert w.volume == 0
        assert w.unit == "gal"
        
        w = Water.new( 3, "qts" )
        
        assert w.volume == 3
        assert w.unit == "qts"
        
        assert_raise RuntimeError do
            w = Water.new( 3, "blah" )
        end
        
        w = Water.new( -4.5, "gal" )
        
        assert w.volume == 4.5
        assert w.unit == "gal"
        
        # Test unit conversion
        assert w.convert_to( "qts" ) == 18
        w.convert_to!("qts")
        assert w.unit == "qts"
        assert w.volume == 18
        
        assert w.convert_to("gal") == 4.5
        w.convert_to!("gal")
        assert w.unit == "gal"
        assert w.volume == 4.5
        
        # no change
        assert w.convert_to("test") == nil
        w.convert_to!("test")
        assert w.unit == "gal"
        assert w.volume == 4.5
        
        # Test adding or removing water
        
        w = Water.new
        
        assert w.volume == 0
        
        w.add( -2 )
        
        assert w.volume == 0
        
        w.add( 5 )
        
        assert w.volume == 5
        
        w.add( 0.5 )
        
        assert w.volume == 5.5
        
        w.add( -1 )
        
        assert w.volume == 4.5
        
        w.remove( -1 )
        
        assert w.volume == 5.5
        
        w.remove( 0.5 )
        
        assert w.volume == 5
        
        w.remove( 5 )
        
        assert w.volume == 0
        
        w.remove( 2 )
        
        assert w.volume == 0
        
        
    end
    
    def test_yeast
        # Test init
        
        y = Yeast.new( "My Yeast" )
        
        assert y.name == "My Yeast"
        assert y.percent_attenuation == 75
        
        y = Yeast.new( "My Yeast", 80 )
        
        assert y.name == "My Yeast"
        assert y.percent_attenuation == 80
        
        y = Yeast.new( 12 )
        
        assert y.name == "12"
        assert y.percent_attenuation == 75

        assert_raise RuntimeError do
            y = Yeast.new( "My Yeast", "bad num" )
        end
          
        # Test setting name
        
        y.set_name( "My Yeast" )
        
        assert y.name == "My Yeast"
        
        y.set_name( 7 )
        
        assert y.name == "7"
        
        y.set_name( nil )
        
        assert y.name == ""
        
    end
    
    def test_brew
        # Test init
        
        b = Brew.new
        assert b.name == ""
        assert b.grains == []
        assert b.hops == []
        assert b.volume_final.volume == 0
        assert b.volume_final.unit == "gal"
        assert b.volume_preboil.volume == 0
        assert b.volume_preboil.unit == "gal"
        assert b.volume_mash.volume == 0
        assert b.volume_mash.unit == "gal"
        assert b.volume_sparge.volume == 0
        assert b.volume_sparge.unit == "gal"
        
        b = Brew.new( "My Beer" )
        assert b.name == "My Beer"
        assert b.grains == []
        assert b.hops == []
    
        # Test adding grain
        
        g = Grain.new( "wheat", 10, "lbs" )
        b.add_grain(g)
        assert b.grains == [g]
        
        b.add_grain(7)
        assert b.grains == [g]
        
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g2)
        assert b.grains == [g,g2]
        
        # Test removing grain
        
        b.remove_grain("grain")
        assert b.grains == [g,g2]
        
        b.remove_grain( g )
        assert b.grains == [g2]
        
        b.add_grain(g)
        assert b.grains == [g2,g]
        
        b.remove_grain_at(0)
        assert b.grains == [g]
        
        # Test adding hops
        
        h = Hops.new( "cascade", 6, 5, 1, "oz" )
        b.add_hops(h)
        assert b.hops == [h]
        
        b.add_hops(nil)
        assert b.hops == [h]
        
        h2 = Hops.new( "Chinook", 7, 2, 0.5, "oz" )
        b.add_hops(h2)
        assert b.hops == [h,h2]
        
        # Test removing hops
        
        b.remove_hops("hops")
        assert b.hops == [h,h2]
        
        b.remove_hops(h)
        assert b.hops == [h2]
        
        b.add_hops(h)
        assert b.hops == [h2,h]
        
        b.remove_hops_at(0)
        assert b.hops == [h]
        
        # Test calc grain mass
        
        b = Brew.new( "My Brew" )
        assert b.total_grain_mass? == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2)
        
        b.lbs_grain_total = b.total_grain_mass?
        
        assert b.lbs_grain_total == 12
        
        # Test calculation of mash water
       
        b = Brew.new( "My Brew" )
        assert b.calc_volume_mash == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2)

        b.calc_volume_mash!
        assert b.volume_mash.volume == 4.5
        assert b.calc_volume_mash == 4.5
        
        b.ratio_mash = 2
        
        b.calc_volume_mash!
        assert b.volume_mash.volume == 6
        assert b.calc_volume_mash == 6
        
        b.ratio_mash = -2
        
        b.calc_volume_mash!
        assert b.volume_mash.volume == 6
        assert b.calc_volume_mash == 6
        
        b.ratio_mash = 1.5
        
        # Test calculation of mash loss

        b = Brew.new( "My Brew" )
        assert b.calc_volume_mash_loss == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2)
       
        b.calc_volume_mash_loss!
        assert b.volume_mash_loss.volume == 1.5
        assert b.calc_volume_mash_loss == 1.5
        
        b.ratio_mash_loss = 1
        
        b.calc_volume_mash_loss!
        assert b.volume_mash_loss.volume == 3
        assert b.calc_volume_mash_loss == 3
        
        b.ratio_mash_loss = -1
        
        b.calc_volume_mash_loss!
        assert b.volume_mash_loss.volume == 3
        assert b.calc_volume_mash_loss == 3
        
        b.ratio_mash_loss = 0.5
        
        # Test calculation of boil off loss
        
        b.min_boil_time = 0
        assert b.calc_volume_boil_loss == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2)
     
        b.min_boil_time = 60
        
        b.calc_volume_boil_loss!
        assert b.volume_boil_loss.volume == 1
        assert b.calc_volume_boil_loss == 1
        
        b.min_boil_time = 90
        
        b.calc_volume_boil_loss!
        assert b.volume_boil_loss.volume == 1.5
        assert b.calc_volume_boil_loss == 1.5
        
        b.min_boil_time = 60
        b.rate_boil_off = 1.25
        
        b.calc_volume_boil_loss!
        assert b.volume_boil_loss.volume == 1.25
        assert b.calc_volume_boil_loss == 1.25
        
        b.rate_boil_off = 1.0
        b.calc_volume_boil_loss!
        
        # Test calculation of shrinkage loss

        b = Brew.new( "My Brew" )
        assert b.calc_volume_shrinkage_loss == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2) 
        
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        b.percent_shrinkage = 4
        
        b.calc_volume_shrinkage_loss!
        assert b.volume_shrinkage_loss.volume == 0.21354166666666696
        assert b.calc_volume_shrinkage_loss == 0.21354166666666696
        
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        b.percent_shrinkage = 4
        
        b.calc_volume_shrinkage_loss!
        assert b.volume_shrinkage_loss.volume == 0.21875
        assert b.calc_volume_shrinkage_loss == 0.21875
        
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        b.percent_shrinkage = 8
        
        b.calc_volume_shrinkage_loss!
        assert b.volume_shrinkage_loss.volume == 0.4565217391304346
        assert b.calc_volume_shrinkage_loss == 0.4565217391304346
        
        # Test calculation of preboil volume
        
        b = Brew.new( "My Brew" )
        assert b.calc_volume_preboil == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2)

        b.min_boil_time = 60
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        b.percent_shrinkage = 4
        b.rate_boil_off = 1.0
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        
        b.calc_volume_preboil!
        assert b.volume_preboil.volume == 6.338541666666667
        assert b.calc_volume_preboil == 6.338541666666667
        
        b.min_boil_time = 90
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        
        b.calc_volume_preboil!
        assert b.volume_preboil.volume == 6.838541666666667
        assert b.calc_volume_preboil == 6.838541666666667
        
        b.volume_final.volume = 10
        b.volume_trub_loss.volume = 0.25
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        
        b.calc_volume_preboil!
        assert b.volume_preboil.volume == 12.177083333333334
        assert b.calc_volume_preboil == 12.177083333333334
        
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        b.percent_shrinkage = 10
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        
        b.calc_volume_preboil!
        assert b.volume_preboil.volume == 7.194444444444445
        assert b.calc_volume_preboil == 7.194444444444445
        
        # Test calculation of the sparge water
        
        b = Brew.new( "My Brew" )
        assert b.calc_volume_sparge == 0

        b = Brew.new( "My Brew" )
        g = Grain.new( "wheat", 10, "lbs" )
        g2 = Grain.new( "Barley", 2, "lbs" )
        b.add_grain(g)
        b.add_grain(g2)

        b.min_boil_time = 60
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        b.percent_shrinkage = 4
        b.rate_boil_off = 1.0
        b.ratio_mash_loss = 0.5
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        b.calc_volume_preboil!
        b.calc_volume_mash!
        b.calc_volume_mash_loss!
        
        b.calc_volume_sparge!
        assert b.volume_sparge.volume == 3.338541666666667
        assert b.calc_volume_sparge == 3.338541666666667
        
        b.min_boil_time = 60
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        b.percent_shrinkage = 4
        b.rate_boil_off = 1.0
        b.ratio_mash_loss = 0.4
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        b.calc_volume_preboil!
        b.calc_volume_mash!
        b.calc_volume_mash_loss!
        
        b.calc_volume_sparge!
        assert b.volume_sparge.volume == 3.038541666666667
        assert b.calc_volume_sparge == 3.038541666666667
        
        b.min_boil_time = 90
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        b.percent_shrinkage = 4
        b.rate_boil_off = 1.0
        b.ratio_mash_loss = 0.5
        b.calc_volume_boil_loss!
        b.calc_volume_shrinkage_loss!
        b.calc_volume_preboil!
        b.calc_volume_mash!
        b.calc_volume_mash_loss!
        
        b.calc_volume_sparge!
        assert b.volume_sparge.volume == 3.838541666666667
        assert b.calc_volume_sparge == 3.838541666666667
        
        # Test calculating original gravity
        
        b = Brew.new( "My Brew" )
        assert b.calc_gravity_original == 1

        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        g = Grain.new( "wheat", 10, "lbs", 40, 70 )
        g2 = Grain.new( "Barley", 2, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)

        b.calc_gravity_original!
        assert b.gravity_original == 1.0622439024390244
        assert b.calc_gravity_original == 1.0622439024390244
        
        
        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.125
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)

        b.calc_gravity_original!
        assert b.gravity_original == 1.0444682926829267
        assert b.calc_gravity_original == 1.0444682926829267
        
        
        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)

        b.calc_gravity_original!
        assert b.gravity_original == 1.0434095238095238
        assert b.calc_gravity_original == 1.0434095238095238
        
        # Test calculating final gravity

        b = Brew.new( "My Brew" )
        assert b.calc_gravity_final == 0.75
        
        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)
        b.calc_gravity_original!
        b.yeast = Yeast.new( "My Yeast", 75 )
        
        b.calc_gravity_final!
        assert b.gravity_final == 1.010852380952381
        assert b.calc_gravity_final == 1.010852380952381
        
        
        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)
        b.calc_gravity_original!
        b.yeast = Yeast.new( "My Yeast", 65 )
        
        b.calc_gravity_final!
        assert b.gravity_final == 1.0151933333333334
        assert b.calc_gravity_final == 1.0151933333333334
        
        
        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)
        b.calc_gravity_original!
        b.yeast = Yeast.new( "My Yeast", 85 )
        
        b.calc_gravity_final!
        assert b.gravity_final == 1.0065114285714285
        assert b.calc_gravity_final == 1.0065114285714285
        
        # Test calculation of ABV
       
        b = Brew.new( "My Brew" )
        assert b.calc_percent_abv == nil

        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        g = Grain.new( "wheat", 5, "lbs", 37, 75 )
        g2 = Grain.new( "2 Row", 4, "lbs", 38, 75 )
        g3 = Grain.new( "vienna", 2, "lbs", 35, 75 )
        b.add_grain(g)
        b.add_grain(g2)
        b.add_grain(g3)
        b.calc_gravity_original!
        b.yeast = Yeast.new( "My Yeast", 75 )
        b.calc_gravity_final!
        
        b.calc_percent_abv!
        assert b.percent_abv == 5.712845781905227
        assert b.calc_percent_abv == 5.712845781905227
        
        
        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        b.volume_trub_loss.volume = 0.25
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)
        b.calc_gravity_original!
        b.yeast = Yeast.new( "My Yeast", 75 )
        b.calc_gravity_final!
        
        b.calc_percent_abv!
        assert b.percent_abv == 4.2807587649904795
        assert b.calc_percent_abv == 4.2807587649904795
        
        # test calculation of IBU 

        b = Brew.new( "My Brew" )
        assert b.calc_ibu == 0

        b = Brew.new( "My Brew" )
        b.volume_final.volume = 5
        h = Hops.new( "warrior", 15.7, 4.5, 3 )
        h2 = Hops.new( "Amarillo", 8.2, 6.2, 2 )
        h3 = Hops.new( "Simcoe", 12.3, 3.7, 2 )
        b.add_hops(h)
        b.add_hops(h2)
        b.add_hops(h3)
        
        mass = b.calc_mass_hops
        assert mass = 7

        ibu = b.calc_ibu
        assert ibu == 56.565008025682175
    end

    def test_file_manager
        b = Brew.new( "Wheat Beer" )
        b.volume_final = Water.new( 5, "gal" )
        b.min_boil_time = 60
        g = Grain.new( "wheat", 11, "lbs", 22, 70 )
        g2 = Grain.new( "Barley", 3, "lbs", 30, 65 )
        b.add_grain(g)
        b.add_grain(g2)
        h = Hops.new( "chinook", 6.4, 4, 1, "oz" )
        h2 = Hops.new( "cascade", 5.2, 3, 1, "oz" )
        b.add_hops(h)
        b.add_hops(h2)
        b.yeast = Yeast.new( "My Yeast", 75 )
        b.ratio_mash = 1.5
        b.ratio_mash_loss = 0.5
        b.volume_trub_loss = Water.new( 0.25, "gal" )
        b.volume_mash_dead_loss = Water.new( 0.125, "gal" )
        b.rate_boil_off = 1
        b.percent_shrinkage = 4
        
        fm = FileManager.new
        
        fm.save_brew(b)
        
        b2 = fm.read_brew(b.name)
        
        assert b2.name == "Wheat Beer"
        assert b2.volume_final.unit == "gal"
        assert b2.volume_final.volume == 5
        assert b2.min_boil_time == 60
        assert b2.grains[0].type == "wheat"
        assert b2.grains[0].unit == "lbs"
        assert b2.grains[0].mass == 11
        assert b2.grains[0].ppg_potential == 22
        assert b2.grains[0].percent_efficiency == 70
        assert b2.grains[1].type == "barley"
        assert b2.grains[1].unit == "lbs"
        assert b2.grains[1].mass == 3
        assert b2.grains[1].ppg_potential == 30
        assert b2.grains[1].percent_efficiency == 65
        assert b2.hops[0].type == "chinook"
        assert b2.hops[0].alpha == 6.4
        assert b2.hops[0].beta == 4
        assert b2.hops[0].unit == "oz"
        assert b2.hops[0].mass == 1
        assert b2.hops[1].type == "cascade"
        assert b2.hops[1].alpha == 5.2
        assert b2.hops[1].beta == 3
        assert b2.hops[1].unit == "oz"
        assert b2.hops[1].mass == 1
        assert b2.yeast.name == "My Yeast"
        assert b2.yeast.percent_attenuation == 75
        assert b2.ratio_mash == 1.5
        assert b2.ratio_mash_loss == 0.5
        assert b2.volume_trub_loss.unit == "gal"
        assert b2.volume_trub_loss.volume == 0.25, "trub loss: #{b2.volume_trub_loss.volume}"
        assert b2.volume_mash_dead_loss.unit == "gal"
        assert b2.volume_mash_dead_loss.volume == 0.125
        assert b2.rate_boil_off == 1
        assert b2.percent_shrinkage == 4
    end
end
