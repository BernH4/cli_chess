module CoreExtensions
  module String
    module Coordinates
      # Goes upwards field by field starting with the current on first iteration
      def upwards_with_each(ammount = 1)
        x, y = split('')
        y = y.to_i

        # If no block is given, just return the coordinates with calculated offset
        return x + (y + ammount).to_s unless block_given?

        ammount.times do
          y += 1
          yield x + y.to_s # string concat, no addition
        end
      end

      def upleft(ammount = 1)
        x, y = split('')
        y = y.to_i

        # If no block is given, just return the coordinates with calculated offset
        return (x.ord - ammount).chr + (y + ammount).to_s unless block_given?
      end

      def upright(ammount = 1)
        x, y = split('')
        y = y.to_i

        # If no block is given, just return the coordinates with calculated offset
        return (x.ord + ammount).chr + (y + ammount).to_s unless block_given?
      end










    end
  end
end
