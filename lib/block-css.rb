#
# Copyright (c) 2008 Jun Kikuchi <kikuchi@bonnou.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

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
