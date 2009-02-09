class BlockCSS
  attr_accessor :indent

  def initialize(params={}, &block)
    @selectors = Selector.new
    @indent = params[:indent] || 2
    block.call(self) if block_given?
    init
  end

  def init
  end

  def style(selector, params={}, &block)
    property = Property.new(params)
    @selectors[selector] = property
    block.call(property) if block_given?
    property
  end

  def to_s
    @selectors.render(' ' * indent.to_i)
  end

  class Hash
    def initialize
      @data = []
    end

    def [](key)
      @data.assoc(key)
    end

    def []=(key, val)
      @data << [key, val]
      val
    end

    def map(&block)
      @data.map(&block)
    end
  end

  class Selector < Hash
    def render(indent)
      if indent.empty?
        map do |key, val|
          "#{key}{#{val.render(indent)}}"
        end.join('')
      else
        map do |key, val|
          "#{key} {\n#{val.render(indent)}\n}\n"
        end.join("\n")
      end
    end
  end

  class Property < Hash
    def initialize(params)
      super()
      params.each do |key, val|
        self[key] = val
      end
    end

    def render(indent)
      if indent.empty?
        map do |key, val|
          "#{key}:#{val}"
        end.join(';')
      else
        map do |key, val|
          "#{indent}#{key}: #{val}"
        end.join(";\n")
      end
    end
  end
end
