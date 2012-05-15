require 'state_machine'

class ArchivalObject
  
  state_machine :initial => :new do
    event :update do
      transition all - [:deleted, :deletion_requested] => :updated, :if => :valid?
    end
    
    event :suppress do
      transition all - [:suppressed, :deleted] => :suppressed
    end
    
    event :unsuppress do
      transition :suppressed => :updated
    end
    
    event :request_deletion do
      transition all - [:new, :deleted, :deletion_requested] => :deletion_requested
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