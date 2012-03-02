module RedmineProjectSpecificEmailSender
  module MailHandlerPatch
    
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :receive_issue, :project_specific_email
      end
    end
    
    module InstanceMethods
      def receive_issue_with_project_specific_email
        if @email.to_addrs.map(&:spec).include? target_project.email
          receive_issue_without_project_specific_email
        else
          logger.info "Not creating ticket as project email is not in To: header" if logger
          true # so the controller returns success status
        end
      end
    end
  end
end
