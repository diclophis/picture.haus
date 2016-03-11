module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Taggable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_taggable
          has_many :taggings, -> { includes :tag }, :as => :taggable, :dependent => :destroy
          has_many :tags, :through => :taggings
          
          before_save :save_cached_tag_list
          after_save :save_tags
          
          include ActiveRecord::Acts::Taggable::InstanceMethods
          extend ActiveRecord::Acts::Taggable::SingletonMethods
          
          alias_method_chain :reload, :tag_list
        end
        
        def cached_tag_list_column_name
          "cached_tag_list"
        end
        
        def set_cached_tag_list_column_name(value = nil, &block)
          define_attr_method :cached_tag_list_column_name, value, &block
        end
      end
      
      module SingletonMethods
        # Returns an array of related tags.
        # Related tags are all the other tags that are found on the models tagged with the provided tags.
        # 
        # Pass either a tag, string, or an array of strings or tags.
        # 
        # Options:
        #   :order - SQL Order how to order the tags. Defaults to "count DESC, tags.name".
        def find_related_tags(tags, options = {})
          tags = tags.is_a?(Array) ? TagList.new(tags.map(&:to_s)) : TagList.from(tags)
          
          related_models = find_tagged_with(tags)
          
          return [] if related_models.blank?
          
          related_ids = related_models.to_s(:db)
          
          Tag.find(:all, options.merge({
            :select => "#{Tag.table_name}.*, COUNT(#{Tag.table_name}.id) AS count",
            :joins  => "JOIN #{Tagging.table_name} ON #{Tagging.table_name}.taggable_type = '#{base_class.name}'
              AND  #{Tagging.table_name}.taggable_id IN (#{related_ids})
              AND  #{Tagging.table_name}.tag_id = #{Tag.table_name}.id",
            :order => options[:order] || "count DESC, #{Tag.table_name}.name",
            :group => "#{Tag.table_name}.id, #{Tag.table_name}.name HAVING #{Tag.table_name}.name NOT IN (#{tags.map { |n| quote_value(n) }.join(",")})"
          }))
        end
        
        # Pass either a tag, string, or an array of strings or tags.
        # 
        # Options:
        #   :exclude - Find models that are not tagged with the given tags
        #   :match_all - Find models that match all of the given tags, not just one
        #   :conditions - A piece of SQL conditions to add to the query
        def find_tagged_with(*args)
          options = find_options_for_find_tagged_with(*args)
          if options.blank?
            []
          else
            select(options[:select]).joins(options[:joins]).where(options[:conditions])
          end
        end
        
        def find_options_for_find_tagged_with(tags, options = {})
          tags = tags.is_a?(Array) ? TagList.new(tags.map(&:to_s)) : TagList.from(tags)
          options = options.dup
          
          return {} if tags.empty?
          
          conditions = []
          conditions << sanitize_sql(options.delete(:conditions)) if options[:conditions]
          
          taggings_alias, tags_alias = "#{table_name}_taggings", "#{table_name}_tags"
          
          if options.delete(:exclude)
            conditions << <<-END
              #{table_name}.id NOT IN
                (SELECT #{Tagging.table_name}.taggable_id FROM #{Tagging.table_name}
                 INNER JOIN #{Tag.table_name} ON #{Tagging.table_name}.tag_id = #{Tag.table_name}.id
                 WHERE #{tags_condition(tags)} AND #{Tagging.table_name}.taggable_type = #{quote_value(base_class.name)})
            END
          else
            if options.delete(:match_all)
              conditions << <<-END
                (SELECT COUNT(*) FROM #{Tagging.table_name}
                 INNER JOIN #{Tag.table_name} ON #{Tagging.table_name}.tag_id = #{Tag.table_name}.id
                 WHERE #{Tagging.table_name}.taggable_type = #{quote_value(base_class.name)} AND
                 taggable_id = #{table_name}.id AND
                 #{tags_condition(tags)}) = #{tags.size}
              END
            else
              conditions << tags_condition(tags, tags_alias)
            end
          end
          
          { :select => "DISTINCT #{table_name}.*",
            :joins => "INNER JOIN #{Tagging.table_name} #{taggings_alias} ON #{taggings_alias}.taggable_id = #{table_name}.#{primary_key} AND #{taggings_alias}.taggable_type = #{quote_value(base_class.name, nil)} " +
                      "INNER JOIN #{Tag.table_name} #{tags_alias} ON #{tags_alias}.id = #{taggings_alias}.tag_id",
            :conditions => conditions.join(" AND ")
          }.reverse_merge!(options)
        end
        
        # Calculate the tag counts for all tags.
        # 
        # See Tag.counts for available options.
        def tag_counts(options = {})
          Tag.find(:all, find_options_for_tag_counts(options))
        end
        
        def find_options_for_tag_counts(options = {})
          options = options.dup
          scope = scope(:find)
          
          conditions = []
          conditions << send(:sanitize_conditions, options.delete(:conditions)) if options[:conditions]
          conditions << send(:sanitize_conditions, scope[:conditions]) if scope && scope[:conditions]
          conditions << "#{Tagging.table_name}.taggable_type = #{quote_value(base_class.name)}"
          conditions << type_condition unless descends_from_active_record? 
          conditions.compact!
          conditions = conditions.join(" AND ")
          
          joins = ["INNER JOIN #{table_name} ON #{table_name}.#{primary_key} = #{Tagging.table_name}.taggable_id"]
          joins << options.delete(:joins) if options[:joins]
          joins << scope[:joins] if scope && scope[:joins]
          joins = joins.join(" ")
          
          options = { :conditions => conditions, :joins => joins }.update(options)
          
          Tag.options_for_counts(options)
        end
        
        def caching_tag_list?
          column_names.include?(cached_tag_list_column_name)
        end
        
       private
        def tags_condition(tags, table_name = Tag.table_name)
          condition = tags.map { |t| sanitize_sql(["#{table_name}.name LIKE ?", t]) }.join(" OR ")
          "(" + condition + ")" unless condition.blank?
        end
      end
      
      module InstanceMethods
        def tag_list
          return @tag_list if @tag_list
          
          if self.class.caching_tag_list? and !(cached_value = send(self.class.cached_tag_list_column_name)).nil?
            @tag_list = TagList.from(cached_value)
          else
            @tag_list = TagList.new(*tags.map(&:name))
          end
        end
        
        def tag_list=(value)
          @tag_list = TagList.from(value)
        end
        
        def save_cached_tag_list
          if self.class.caching_tag_list?
            self[self.class.cached_tag_list_column_name] = tag_list.to_s
          end
        end
        
        def save_tags
          return unless @tag_list
          
          new_tag_names = @tag_list - tags.map(&:name)
          old_tags = tags.reject { |tag| @tag_list.include?(tag.name) }
          
          self.class.transaction do
            if old_tags.any?
              taggings.find(:all, :conditions => ["tag_id IN (?)", old_tags.map(&:id)]).each(&:destroy)
              taggings.reset
            end
            
            new_tag_names.each do |new_tag_name|
              tags << Tag.find_or_create_with_like_by_name(new_tag_name)
            end
          end
          
          true
        end
        
        # Calculate the tag counts for the tags used by this model.
        #
        # The possible options are the same as the tag_counts class method.
        def tag_counts(options = {})
          return [] if tag_list.blank?
          
          options[:conditions] = self.class.send(:merge_conditions, options[:conditions], self.class.send(:tags_condition, tag_list))
          self.class.tag_counts(options)
        end
        
        def reload_with_tag_list(*args) #:nodoc:
          @tag_list = nil
          reload_without_tag_list(*args)
        end
      end
    end
  end
end

class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  
  before_validation :normalize_name
  validates_presence_of :name
  validates_uniqueness_of :name
  
  cattr_accessor :destroy_unused
  self.destroy_unused = false
  
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    where(["name LIKE ?", name]).first || create(:name => name)
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
  def count
    read_attribute(:count).to_i
  end

  def normalize_name
    self.name = self.name.gsub(/[^a-zA-Z0-9]/, '').downcase
  end
  
  class << self
    # Calculate the tag counts for all tags.
    #  :start_at - Restrict the tags to those created after a certain time
    #  :end_at - Restrict the tags to those created before a certain time
    #  :conditions - A piece of SQL conditions to add to the query
    #  :limit - The maximum number of tags to return
    #  :order - A piece of SQL to order by. Eg 'count desc' or 'taggings.created_at desc'
    #  :at_least - Exclude tags with a frequency less than the given value
    #  :at_most - Exclude tags with a frequency greater than the given value
    def counts(options = {})
      find(:all, options_for_counts(options))
    end
    
    def options_for_counts(options = {})
      options.assert_valid_keys :start_at, :end_at, :conditions, :at_least, :at_most, :order, :limit, :joins
      options = options.dup
      
      start_at = sanitize_sql(["#{Tagging.table_name}.created_at >= ?", options.delete(:start_at)]) if options[:start_at]
      end_at = sanitize_sql(["#{Tagging.table_name}.created_at <= ?", options.delete(:end_at)]) if options[:end_at]
      
      conditions = [
        options.delete(:conditions),
        start_at,
        end_at
      ].compact
      
      conditions = conditions.any? ? conditions.join(' AND ') : nil
      
      joins = ["INNER JOIN #{Tagging.table_name} ON #{Tag.table_name}.id = #{Tagging.table_name}.tag_id"]
      joins << options.delete(:joins) if options[:joins]
      
      at_least  = sanitize_sql(['COUNT(*) >= ?', options.delete(:at_least)]) if options[:at_least]
      at_most   = sanitize_sql(['COUNT(*) <= ?', options.delete(:at_most)]) if options[:at_most]
      having    = [at_least, at_most].compact.join(' AND ')
      group_by  = "#{Tag.table_name}.id, #{Tag.table_name}.name HAVING COUNT(*) > 0"
      group_by << " AND #{having}" unless having.blank?
      
      { :select     => "#{Tag.table_name}.id, #{Tag.table_name}.name, COUNT(*) AS count", 
        :joins      => joins.join(" "),
        :conditions => conditions,
        :group      => group_by
      }.update(options)
    end
  end
end
# Deprecated
module TagCountsExtension #:nodoc:
end
class TagList < Array
  cattr_accessor :delimiter
  self.delimiter = ','
  
  def initialize(*args)
    add(*args)
  end
  
  # Add tags to the tag_list. Duplicate or blank tags will be ignored.
  #
  #   tag_list.add("Fun", "Happy")
  # 
  # Use the <tt>:parse</tt> option to add an unparsed tag string.
  #
  #   tag_list.add("Fun, Happy", :parse => true)
  def add(*names)
    extract_and_apply_options!(names)
    concat(names)
    clean!
    self
  end
  
  # Remove specific tags from the tag_list.
  # 
  #   tag_list.remove("Sad", "Lonely")
  #
  # Like #add, the <tt>:parse</tt> option can be used to remove multiple tags in a string.
  # 
  #   tag_list.remove("Sad, Lonely", :parse => true)
  def remove(*names)
    extract_and_apply_options!(names)
    delete_if { |name| names.include?(name) }
    self
  end
  
  # Toggle the presence of the given tags.
  # If a tag is already in the list it is removed, otherwise it is added.
  def toggle(*names)
    extract_and_apply_options!(names)
    
    names.each do |name|
      include?(name) ? delete(name) : push(name)
    end
    
    clean! 
    self
  end
  
  # Transform the tag_list into a tag string suitable for edting in a form.
  # The tags are joined with <tt>TagList.delimiter</tt> and quoted if necessary.
  #
  #   tag_list = TagList.new("Round", "Square,Cube")
  #   tag_list.to_s # 'Round, "Square,Cube"'
  def to_s
    clean!
    
    map do |name|
      name.include?(delimiter) ? "\"#{name}\"" : name
    end.join(delimiter.ends_with?(" ") ? delimiter : "#{delimiter} ")
  end
  
 private
  # Remove whitespace, duplicates, and blanks.
  def clean!
    reject!(&:blank?)
    map!(&:strip)
    uniq!
  end
  
  def extract_and_apply_options!(args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.assert_valid_keys :parse
    
    if options[:parse]
      args.map! { |a| self.class.from(a) }
    end
    
    args.flatten!
  end
  
  class << self
    def returning(value)
      yield(value)
      value
    end
    # Returns a new TagList using the given tag string.
    # 
    #   tag_list = TagList.from("One , Two,  Three")
    #   tag_list # ["One", "Two", "Three"]
    def from(source)
      returning new do |tag_list|
        
        case source
          when Array
            tag_list.add(source)
          else
            string = source.to_s.dup
            
            # Parse the quoted tags
            [
              /\s*#{delimiter}\s*(['"])(.*?)\1\s*/,
              /^\s*(['"])(.*?)\1\s*#{delimiter}?/
            ].each do |re|
              string.gsub!(re) { tag_list << $2; "" }
            end
            
            tag_list.add(string.split(delimiter))
        end
      end
    end
  end
end
class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  def after_destroy
    if Tag.destroy_unused
      if tag.taggings.count.zero?
        tag.destroy
      end
    end
  end
end
module TagsHelper
  # See the README for an example using tag_cloud.
  def tag_cloud(tags, classes)
    return if tags.empty?
    
    max_count = tags.sort_by(&:count).last.count.to_f
    
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end
end
