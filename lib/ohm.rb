module Ohm
  class Model
    ##
    ## Ohm allows something that is indexed on something to have multiple
    ## mappings.  In this case I just want to get one and not create
    ## the same user multiple times.
    ##
    def self.first_or_create(options={})
      user = first( options )
      if user.nil?
        create( options )
      else 
        user
      end
    end

    def self.first(options={})
      find(options).first
    end
  end
end
