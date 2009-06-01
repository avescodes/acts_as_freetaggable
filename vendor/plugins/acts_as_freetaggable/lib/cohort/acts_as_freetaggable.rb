# ActsAsFreetaggable
module Cohort
  module ActsAsFreetaggable
    def self.included(klass)
      klass.extend(ClassMethods)
    end
  
    module ClassMethods
      def acts_as_freetaggable(options={})
      end
    end
  end
end