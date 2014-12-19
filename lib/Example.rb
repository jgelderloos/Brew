require_relative "Brew"
require_relative "Hops"
require_relative "Grain"
require_relative "Water"
require_relative "Yeast"
require_relative "FileManager"

b = Brew.new("Dogfish60")
b.volume_final = Water.new( 5, "gal" )
b.min_boil_time = 60
g = Grain.new( "British 2 Row", 12.5, "lbs", 37, 75 )
g2 = Grain.new( "Crystal Malt", 0.25, "lbs", 34, 75 )
g3 = Grain.new( "British Amber", 0.25, "lbs", 35, 75 )
b.add_grain(g)
b.add_grain(g2)
b.add_grain(g3)
h = Hops.new( "Warrior", 15.7, 6.2, 3, "oz" )
h2 = Hops.new( "Simcoe", 12.7, 4.0, 2, "oz" )
h3 = Hops.new( "Amarillo", 8.2, 6.2, 2, "oz" )
b.add_hops(h)
b.add_hops(h2)
b.add_hops(h3)
b.yeast = Yeast.new( "Yeast", 86.4 )
b.ratio_mash = 1.5
b.ratio_mash_loss = 0.5
b.volume_trub_loss = Water.new( 0.25, "gal" )
b.volume_mash_dead_loss = Water.new( 0.125, "gal" )
b.rate_boil_off = 0.7
b.percent_shrinkage = 4

b.calc_volume_mash!
printf( "Mash volume: %2.3f %s\n", b.volume_mash.volume, b.volume_mash.unit )

b.calc_volume_mash_loss!
b.calc_volume_boil_loss!
b.calc_volume_shrinkage_loss!
b.calc_volume_preboil!
printf( "Pre boil: %2.3f %s\n", b.volume_preboil.volume, b.volume_preboil.unit )

b.calc_volume_sparge!
printf( "Sparge volume: %2.3f %s\n", b.volume_sparge.volume, b.volume_sparge.unit )

b.calc_gravity_original!
printf( "OG: %2.4f\n", b.gravity_original )

b.calc_gravity_final!
printf( "FG: %2.4f\n", b.gravity_final )

b.calc_percent_abv!
printf( "ABV: %2.2f\n", b.percent_abv )

fm = FileManager.new

fm.save_brew(b)

