# ActsAsFreetaggable
module Cohort
  module ActsAsFreetaggable
    def self.included(klass)
      klass.extend(ClassMethods)
    end
  
    module ClassMethods
      def acts_as_freetaggable(options={})
        Tag.class_eval do
          has_many_polymorphs :freetaggables, :from => [self.to_s.pluralize.underscore.to_sym], :through => :taggings
        end
      end
    end
  end
end