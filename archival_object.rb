require 'state_machine'

class ArchivalObject
  
  state_machine :initial => :new do
    event :update do
      transition all - [:deleted, :deletion_requested, :suppressed] => :updated, :if => :valid?
    end
    
    event :suppress do
      transition all - [:suppressed, :deleted] => :suppressed
    end
    
    event :unsuppress do
      transition :suppressed => :updated
    end
    
    event :request_deletion do
      transition all - [:deleted, :deletion_requested] => :deletion_requested
    end
    
    event :cancel_request do
      transition :deletion_requested => :updated
    end
    
    event :destroy do
      transition all - [:deleted] => :deleted, :if => :user_is_admin?
      transition :deletion_requested => :deleted, :if => :user_can_delete?
    end
    
    state all - [:deletion_requested] do
      def deletable?
        false
      end
    end
    
    state :deletion_requested do
      def deletable?
        true
      end
    end
    
  end
end

class MergeableArchivalObject < ArchivalObject
  
  state_machine :initial => :new do
    
    event :merge_into_other do
      transition [:new, :updated] => :suppressed
    end
    
    event :receive_merge do
      transition [:new, :updated] => :updated
    end
  
  end
    
end

class Accession < ArchivalObject
  state_machine :initial => :new 
end

class Resource < MergeableArchivalObject
  state_machine :initial => :new
end 

class DigitalObject < MergeableArchivalObject
  state_machine :initial => :new
end
