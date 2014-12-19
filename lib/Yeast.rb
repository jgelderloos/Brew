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
#   Class: Yeast
#
#   Description:
#   Holds basic info about a type of yeast.

class Yeast
  attr_reader   :name
  attr_reader :percent_attenuation
  
  def initialize name, attenuation = 75
    @name = name.to_s
    set_attenuation( attenuation )
  end
   
  def set_name name
    @name = name.to_s
  end
  
  def set_attenuation attenuation
    @percent_attenuation = attenuation.abs
  end

end
