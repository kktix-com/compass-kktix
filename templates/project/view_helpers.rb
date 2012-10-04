# -*- encoding : utf-8 -*-
class TagNode
  include Serve::TagHelpers
  def initialize(name, options = {})
    @name = name.to_s
    @attributes = options
    @children = []
  end

  def addClass(x)
    if @attributes[:class].blank?
      @attributes[:class] = x.to_s
    else
      @attributes[:class] = @attributes[:class] + " #{x}"
    end
  end

  def to_s
    value = @children.each { |c| c.to_s }.join
    content_tag(@name, value.to_s, @attributes)
  end

  def <<(tag_node)
    @children << tag_node
  end
end


module ViewHelpers
  
  def method_missing(x)
    if x.to_s.match(/_path$/)

      project_path = File.expand_path(Compass.configuration.project_path)
      target = File.expand_path(File.join(project_path, x.to_s.split(/_/)[0...-1] ))

      #folder
      return target[project_path.length .. -1] if File.directory?(target) 

      #template file
      Dir.glob( File.join(File.dirname(target), '*') )  do |x|
        return x[project_path.length..-1] if File.fnmatch("#{target}*", x)
      end
    end
    super
  end


  def current_url
    request.url
  end

  # .current will be added to current action, but if you want to add .current to another link, you can set @current = ['/other_link']
  # TODO: hot about render_list( *args )
  def render_list(list=[], options={})
    if list.is_a? Hash
      options = list
      list = []
    end

    yield(list) if block_given?

    list_type ||= "ul"

    if options[:type] 
      if ["ul", "dl", "ol"].include?(options[:type])
        list_type = options[:type]
      end
    end

    ul = TagNode.new(list_type, :id => options[:id], :class => options[:class] )
    ul.addClass("unstyled") if (options[:type] && options[:type] == "unstyled")

    list.each_with_index do |content, i|
      item_class = []
      item_class << "first" if i == 0
      item_class << "last" if i == (list.length - 1)

      item_content = content
      item_options = {}

      if content.is_a? Array
        item_content = content[0]
        item_options = content[1]
      end

      if item_options[:class]
        item_class << item_options[:class]
      end

      link = item_content.match(/href=(["'])(.*?)(\1)/)[2] rescue nil
      if item_options[:active].nil?
        if ( link && current_page?(link) ) || ( @current && @current.include?(link) )
          item_class << "active"
        end
      else
        item_class << "active" if item_options[:active]
      end

      item_class = (item_class.empty?)? nil : item_class.join(" ")
      ul << li = TagNode.new('li', :class => item_class )
      li << item_content
    end

    return ul.to_s
  end

  def current_page?(path)
    if current_url =~ /\.html/ #file
      current_url =~ %r{#{path}}
    else #folder index page
      "#{current_url}/index.html" =~ %r{#{path}} || "#{current_url}/index.html.erb" =~ %r{#{path}} 
    end

  end

end

