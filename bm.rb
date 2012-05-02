class BM
  def initialize(neurons,examples)
    @neurons = neurons
    @examples = examples
    @samples = 500
    @net = Array.new(neurons)
    @w = Array.new(@neurons) { Array.new(@neurons) {0} }
    @dw = Array.new(@neurons) { Array.new(@neurons) {0} }
    @example = Array.new(@examples) { Array.new(@neurons) {0} }
    @max_flips = 100
    @previous_temp = 0
    @current_temp = 0
    @eta = 0.01  # learning rate
  end
  
  def init_random  # initBM with small random values
    for i in 0..@neurons-1
      for j in 0..@neurons-1 do
        @w[i][j] = 0.2*(rand()-0.5)
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
  
  def dw
    for i in 0..@examples-1
      for j in 0..@neurons-1
        for k in 0..@neurons-1
          @dw[j][k] += @eta*@example[i][j]*@example[i][k]
        end
      end
    end
    
    for i in 0..@samples-1
      for j in 0..@neurons-1
        if rand() < 0.5
          @net[j] = -1
        else
          @net[j] = 1
        end
      end
      
      for q in 0..@max_flips-1
        for j in 0..@neurons-1
          z = activate(j)
          @current_temp = 0.1*(@max_flips-q)/@max_flips
          if (1/(1+Math.exp(-2*z/@current_temp)) > rand())
            @net[j] = 1
          else
            @net[j] = -1
          end
        end
      end
      
      for j in 0..@neurons-1
        for k in 0..@neurons-1
          @dw[j][k] -= @eta*@neurons*@net[j]*@net[k] / @samples
        end
      end
    end
  end
  
  def test1
    initialize(6,3)
    init_random
    @example[0] = [-1,-1,-1,-1,-1,1]
    @example[1] = [-1,-1,1,-1,-1,-1]
    @example[2] = [1,-1,-1,-1,-1,-1]
    self.dw
  end
  
  def test2
    initialize(10,2)
    init_random
    @example[0] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, 1]
    @example[1] = [-1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    self.dw
  end
end

test = BM.new 6,3
test.init_random
test.test1
test.test2