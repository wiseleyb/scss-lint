module SCSSLint
  # Collection of helpers used across a variety of linters.
  module Utils
    # Given a selector array which is a list of strings with Sass::Script::Nodes
    # interspersed within them, return an array of strings representing those
    # selectors with the Sass::Script::Nodes removed (i.e., ignoring
    # interpolation). For example:
    #
    # .selector-one, .selector-#{$var}-two
    #
    # becomes:
    #
    # .selector-one, .selector--two
    #
    # This is useful for lints that wish to ignore interpolation, since
    # interpolation can't be resolved at this step.
    def extract_string_selectors(selector_array)
      selector_array.reject { |item| item.is_a? Sass::Script::Node }.
                     join.
                     split
    end

    def shortest_hex_form(hex)
      (can_be_condensed?(hex) ? (hex[0..1] + hex[3] + hex[5]) : hex).downcase
    end

    def can_be_condensed?(hex)
      hex.length == 7 &&
        hex[1] == hex[2] &&
        hex[3] == hex[4] &&
        hex[5] == hex[6]
    end

    # Takes a string like `hello "world" 'how are' you` and turns it into:
    # `hello   you`.
    # This is useful for scanning for keywords in shorthand properties or lists
    # which can contain quoted strings but for which you don't want to inspect
    # quoted strings (e.g. you care about the actual color keyword `red`, not
    # the string "red").
    def remove_quoted_strings(string)
      string.gsub(/"[^"]*"|'[^']*'/, '')
    end

    def previous_node(node)
      return unless node && parent = node.node_parent
      index = parent.children.index(node)

      if index == 0
        parent
      else
        parent.children[index - 1]
      end
    end

    def pluralize(value, word)
      value == 1 ? "#{value} #{word}" : "#{value} #{word}s"
    end
  end
end
