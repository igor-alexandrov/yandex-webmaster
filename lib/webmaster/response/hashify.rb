# encoding: utf-8

require 'faraday'
require 'xml/libxml'

module Webmaster
  class Response::Hashify < Faraday::Response::Middleware
    def parse(body)      
      self.from_xml(body)
    end

    def from_xml(xml, strict = true) 
      begin
        XML.default_load_external_dtd = false
        XML.default_pedantic_parser = strict
        result = XML::Parser.string(xml).parse 
        return xml_node_to_hash(result.root)
      rescue Exception => e
        # raise custom exception here      
      end 
    end

    def xml_node_to_hash(node)             
      if node.element? 
        if node.children? || node.attributes?
          result_hash = {} 

          node.each_child do |child| 
            result = xml_node_to_hash(child) 

            if child.name == "text"
              if !child.next? and !child.prev?
                return result
              end
            elsif result_hash[child.name.underscore.to_sym]
              if result_hash[child.name.underscore.to_sym].is_a?(Object::Array)
                result_hash[child.name.underscore.to_sym] << result
              else
                result_hash[child.name.underscore.to_sym] = [result_hash[child.name.to_sym]] << result
              end
            else 
              result_hash[child.name.underscore.to_sym] = result
            end
          end

          node.each_attr do |attr|
            result_hash[attr.name.underscore] = attr.value
          end

          return result_hash 
        else 
          return nil 
        end 
      else 
        return node.content.to_s 
      end 
    end
  end
end
