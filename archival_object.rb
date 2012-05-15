require 'state_machine'

class ArchivalObject
  
  state_machine :initial => :new do
    event :update do
      transition all - [:deleted, :deletion_requested, :suppressed] => :updated, :if => :valid?
    end
    
    event :deaccession do
      # doesn't account for partial deaccessions
      transition all - [:suppressed, :deleted] => :suppressed
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
      transition :deletion_requested => :deleted, :if => :user_can_delete?
      transition all - [:deletion_requested, :deleted] => :deleted, :if => :user_is_admin?
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

class HierarchicalArchivalObject < ArchivalObject
  
  state_machine :initial => :new do
    
    event :add_child do
      transition [:new, :updated] => :updated
    end
    
  end
    
end

class Accession < ArchivalObject
  state_machine :initial => :new 
end

class Resource < HierarchicalArchivalObject

  state_machine :initial => :new do
    event :transfer_component do
      transition [:new, :updated] => :updated
    end
    
    event :receive_transfer do
      transition [:new, :updated] => :updated
    end
    
    event :merge_into_other do
      transition [:new, :updated] => :suppressed
    end
    
    event :receive_merge do
      transition [:new, :updated] => :updated
    end
  end
  
end 

class DigitalObject < HierarchicalArchivalObject
  state_machine :initial => :new
end
