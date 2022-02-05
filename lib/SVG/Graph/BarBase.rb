require 'rexml/document'
require_relative 'Graph'

module SVG
  module Graph
		# = Synopsis
		#
		# A superclass for bar-style graphs.  Do not attempt to instantiate
		# directly; use one of the subclasses instead.
		#
    # = Author
    #
    # Sean E. Russell <serATgermaneHYPHENsoftwareDOTcom>
		#
    # Copyright 2004 Sean E. Russell
		# This software is available under the Ruby license[LICENSE.txt]
    #
    class BarBase < SVG::Graph::Graph
			# Ensures that :fields are provided in the configuration.
      def initialize config
        raise "fields was not supplied or is empty" unless config[:fields] &&
        config[:fields].kind_of?(Array) &&
        config[:fields].length > 0
        super
      end

      # In addition to the defaults set in Graph::initialize, sets
      # [bar_gap] true
      # [stack] :overlap
      def set_defaults
        init_with( :bar_gap => true, :stack => :overlap, :show_percent => false, :show_actual_values => true)
      end

      #   Whether to have a gap between the bars or not, default
      #   is true, set to false if you don't want gaps.
      attr_accessor :bar_gap
      #   How to stack data sets.  :overlap overlaps bars with
      #   transparent colors, :top stacks bars on top of one another,
      #   :side stacks the bars side-by-side. Defaults to :overlap.
      attr_accessor :stack
      # If true, display the percentage value of each bar. Default: false
      attr_accessor :show_percent
      # If true, display the actual field values in the data labels. Default: true
      attr_accessor :show_actual_values
      protected

      # space in px between x-labels, we override the Graph version because
      # we need the extra space (i.e. don't subtract 1 from get_x_labels.length)
      def field_width
        # don't use -1 otherwise bar is out of bounds
        @graph_width.to_f / ( get_x_labels.length )
      end

      def max_value
        @data.collect{|x| x[:data].max}.max
      end

      def min_value
        min = 0
        if min_scale_value.nil?
          min = @data.collect{|x| x[:data].min}.min
          # by default bar should always start from zero unless there are negative values
          min = min > 0 ? 0 : min
        else
          min = min_scale_value
        end
        return min
      end

      def get_css
        return  nil
      end
    end
  end
end
