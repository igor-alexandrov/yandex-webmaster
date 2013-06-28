# encoding: utf-8

require 'faraday'
require 'xml/libxml'

module Yandex
  module Webmaster
    class Response::Hashify < Faraday::Response::Middleware
      def parse(body)
        self.from_xml(body) if body.present?
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
                return result if !child.next? && !child.prev? && result.present? && !node.attributes?
                result_hash[:value] = result
              elsif result_hash[child.name.underscore.to_sym] && result.present?
                if result_hash[child.name.underscore.to_sym].is_a?(Object::Array)
                  result_hash[child.name.underscore.to_sym] << result
                else
                  result_hash[child.name.underscore.to_sym] = [result_hash[child.name.underscore.to_sym]] << result
                end
              elsif result.present?
                result_hash[child.name.underscore.to_sym] = result
              end
            end

            node.each_attr do |attr|
              result_hash[attr.name.underscore.to_sym] = attr.value
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
end