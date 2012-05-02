class BM
  def initialize neurons
    @neurons = neurons
    @net = Array.new(neurons)
    @w = Array.new(@neurons) { Array.new(@neurons) {0} }
    @dw = Array.new(@neurons) { Array.new(@neurons) {0} }
    @examples = Array.new(neurons) { Array.new(neurons) {0} }
    @max_flips = 10
    @previous_temp = 0
    @current_temp = 0
    @eta = 0.01  # learning rate
    @samples = 3
  end
  
  def init_random  # initBM with small random values
    for i in 0..@neurons-1
      for j in 0..@neurons-1 do
        @w[i][j] = 0.2*(rand()-0.5)
      end
    end
  end
  
  def flip
    for q in 0..@max_flips-1
      for j in 0..@neurons-1
        z = activate(j)
        temp = 0.1*(@max_flips-q)/@max_flips
        if (1/(1+exp(-2*z/temp)) > rand())
          @net[j] = 1
        else
          @net[j] = -1
        end
        puts @net[j]
      end
    end
  end
  
  def activate j
    z = 0
    for i in 0..@neurons-1
      if i != j
        z += @w[j][i] * @net[i]
      end
    end
    z
  end
  
  def converged?
    @previous_temp == @current_temp
  end
  
  def dw
    for i in 0..@samples-1
      for j in 0..@neurons-1
        for k in 0..@neurons-1
          @dw[j][k] += @eta*@examples[i][j]*@examples[i][k]
        end
      end
    end
    
    # init @net with random start
    for i in 0..@samples - 1
      for j in 0..@neurons-1
        if rand() < 0.5
          @net[j] = -1
        else
          @net[j] = 1
        end
      end
    end
  
    until self.converged?
      flip
    end
  end # end dw
end

test = BM.new 6
test.init_random
test.dw