require 'state_machine'

class ArchivalObject
  
  state_machine :initial => :new do
    event :validate do
      transition all => :valid, :if => :valid?
      transition all => :invalid
    end
    
    event :suppress do
      transition all - [:new, :invalid, :suppressed] => :suppressed
    end
    
    event :unsuppress do
      transition :suppressed => :valid, :if => :valid?
      transition :suppressed => :invalid
    end
    
    event :request_deletion do
      transition all - [:new, :deletion_requested] => :deletion_requested
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

  def valid?
  end
  
end