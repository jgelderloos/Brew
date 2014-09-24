require_relative "Brew"

class FileManager

    # Assume that everything is stored in the working directory
    def initialize
        @path = Dir.pwd
        @folder = "/My Brews"
        @dir = @path + @folder
        
        Dir.mkdir(@dir) unless Dir.exist?(@dir)
        
        @tags = [ "name", "size unit", "size", "boil time", "grain", "type", "mass unit", "mass", "ppg", "%eff",
                  "hops", "type", "alpha", "beta", "mass unit", "mass", "yeast", "attenuation", "ratio mash",
                  "ratio mash loss", "trub loss unit", "trub loss", "dead loss unit", "dead loss", "rate boil off",
                  "%shrinkage" ]
    end
    
    def save_brew brew 
        if brew.is_a? Brew
            name = brew.name
            
            write_file = File.open(@path+"/"+name+".txt", "w+")
            
            offset = 0
            offset += IO.write(write_file, "#"+@tags[0]+"# "+name+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[1]+"# "+brew.volume_final.unit+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[2]+"# "+brew.volume_final.volume.to_s+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[3]+"# "+brew.min_boil_time.to_s+"\n", offset)
            
            brew.grains.each_with_index do |grain,index|
                p_index = index.to_s
                offset += IO.write(write_file, "#"+@tags[4]+" "+p_index+" "+@tags[5]+"# "+grain.type+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[4]+" "+p_index+" "+@tags[6]+"# "+grain.unit+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[4]+" "+p_index+" "+@tags[7]+"# "+grain.mass.to_s+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[4]+" "+p_index+" "+@tags[8]+"# "+grain.ppg_potential.to_s+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[4]+" "+p_index+" "+@tags[9]+"# "+grain.percent_efficiency.to_s+"\n", offset)
            end
            
            brew.hops.each_with_index do |hop,index|
                p_index = index.to_s
                offset += IO.write(write_file, "#"+@tags[10]+" "+p_index+" "+@tags[11]+"# "+hop.type+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[10]+" "+p_index+" "+@tags[12]+"# "+hop.alpha.to_s+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[10]+" "+p_index+" "+@tags[13]+"# "+hop.beta.to_s+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[10]+" "+p_index+" "+@tags[14]+"# "+hop.unit+"\n", offset)
                offset += IO.write(write_file, "#"+@tags[10]+" "+p_index+" "+@tags[15]+"# "+hop.mass.to_s+"\n", offset)
            end
            
            offset += IO.write(write_file, "#"+@tags[16]+"# "+brew.yeast.name+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[17]+"# "+brew.yeast.percent_attenuation.to_s+"\n", offset)
            
            offset += IO.write(write_file, "#"+@tags[18]+"# "+brew.ratio_mash.to_s+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[19]+"# "+brew.ratio_mash_loss.to_s+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[20]+"# "+brew.volume_trub_loss.unit+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[21]+"# "+brew.volume_trub_loss.volume.to_s+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[22]+"# "+brew.volume_mash_dead_loss.unit+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[23]+"# "+brew.volume_mash_dead_loss.volume.to_s+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[24]+"# "+brew.rate_boil_off.to_s+"\n", offset)
            offset += IO.write(write_file, "#"+@tags[25]+"# "+brew.percent_shrinkage.to_s+"\n", offset)
            
            write_file.close
        end
    end
    
    def read_brew name
        file_data = File.read( @path+"/"+name+".txt" ).split(/\n/)

        brew = Brew.new
        grain = Grain.new( "wheat" )
        hops = Hops.new( "chinook", 0, 0 )
        yeast = Yeast.new( "" )
        file_data.each do |line|
            tag = /#(.*)# (.*)\Z/.match(line)
            case tag[1]
            when @tags[0]
                brew.name = tag[2]
            when @tags[1]
                brew.volume_final.set_unit(tag[2])
            when @tags[2]
                brew.volume_final.volume = tag[2].to_f
            when @tags[3]
                brew.min_boil_time = tag[2].to_f
            when /#{@tags[4]} (\d) #{@tags[5]}/
                grain = Grain.new( tag[2] )
            when /#{@tags[4]} (\d) #{@tags[6]}/
                grain.set_unit( tag[2] )
            when /#{@tags[4]} (\d) #{@tags[7]}/
                grain.set_mass( tag[2].to_f )
            when /#{@tags[4]} (\d) #{@tags[8]}/
                grain.ppg_potential = tag[2].to_f
            when /#{@tags[4]} (\d) #{@tags[9]}/
                grain.percent_efficiency = tag[2].to_f
                brew.add_grain( grain )
            when /#{@tags[10]} (\d) #{@tags[11]}/
                hops = Hops.new( tag[2], 0, 0 )
            when /#{@tags[10]} (\d) #{@tags[12]}/
                hops.set_alpha( tag[2].to_f )
            when /#{@tags[10]} (\d) #{@tags[13]}/
                hops.set_beta( tag[2].to_f )
            when /#{@tags[10]} (\d) #{@tags[14]}/
                hops.set_unit( tag[2] )
            when /#{@tags[10]} (\d) #{@tags[15]}/
                hops.set_mass( tag[2].to_f )
                brew.add_hops( hops )
            when @tags[16]
                yeast = Yeast.new( tag[2] )
            when @tags[17]
                yeast.percent_attenuation = tag[2].to_f
                brew.yeast = yeast
            when @tags[18]
                brew.ratio_mash = tag[2].to_f
            when @tags[19]
                brew.ratio_mash_loss = tag[2].to_f
            when @tags[20]
                brew.volume_trub_loss.set_unit( tag[2] )
            when @tags[21]
                brew.volume_trub_loss.volume = tag[2].to_f
            when @tags[22]
                brew.volume_mash_dead_loss.set_unit( tag[2] )
            when @tags[23]
                brew.volume_mash_dead_loss.volume = tag[2].to_f
            when @tags[24]
                brew.rate_boil_off = tag[2].to_f
            when @tags[25]
                brew.percent_shrinkage = tag[2].to_f
            else
            end
        end
        return brew
    end
end