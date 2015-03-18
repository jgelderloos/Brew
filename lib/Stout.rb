require_relative "Brew"
require_relative "Hops"
require_relative "Grain"
require_relative "Water"
require_relative "Yeast"
require_relative "FileManager"

b = Brew.new("Coffee Porter")
b.volume_final = Water.new( 5, "gal" )
b.min_boil_time = 60
g = Grain.new( "Simpsons", 10, "lbs", 35, 70 )
g2 = Grain.new( "Crystal Malt", 0.5, "lbs" )
g3 = Grain.new( "Barley - Flaked", 0.5, "lbs", 32, 70 )
g4 = Grain.new( "Arromatic Malt", 1, "lbs", 36, 70 )
g5 = Grain.new( "Special B Malt", 0.5, "lbs", 30, 70 )
b.add_grain(g)
b.add_grain(g2)
b.add_grain(g3)
b.add_grain(g4)
b.add_grain(g5)
h = Hops.new( "Willamette", 4.7, 3.7, 2.75, "oz" )
b.add_hops(h)
b.yeast = Yeast.new( "Windsor", 73 )
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

printf( "IBU: %3.1f\n", b.calc_ibu )

fm = FileManager.new

fm.save_brew(b)

