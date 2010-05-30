module Ohm
  class Model
    ##
    ## Ohm allows something that is indexed on something to have multiple
    ## mappings.  In this case I just want to get one and not create
    ## the same user multiple times.
    ##
    ## For this to work properly, the options you pass must both be
    ## index properties in the object model
    ##
    def self.first_or_create(options={})
      model = first( options )
      if model.nil?
        create( options )
      else 
        model
      end
    end

    def self.first(options={})
      find(options).first
    end
  end
end
