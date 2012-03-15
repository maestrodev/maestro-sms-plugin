require 'smsified'
require 'maestro_agent'

module MaestroDev
  class SmsifiedWorker < Maestro::MaestroWorker
    
    def validate_input_fields(fields)
      workitem['fields']['__error__'] = ''
      fields.each do |field|
        workitem['fields']['__error__'] += "Missing Field #{field}, " if workitem['fields'][field].nil? or workitem['fields'][field].to_s.empty?
      end
      if !workitem['fields']['body'].nil? && workitem['fields']['body'].length > 140
        workitem['fields']['__error__'] = 'Invalid body, over 140 chars'
      end
    end
    
    def send_sms
      
      write_output("Validating SMS task inputs\n")
      validate_input_fields(['username','password','body','to','number'])
      return unless workitem['fields']['__error__'].empty?
      
      oneapi = Smsified::OneAPI.new(:username => workitem['fields']['username'],
                                    :password => workitem['fields']['password'])

      r = oneapi.send_sms(:address => workitem['fields']['to'],
                          :message => workitem['fields']['body'],
                          :sender_address => workitem['fields']['number'])
      
      if r.http.is_a? Net::HTTPCreated
        write_output "SMS sent to #{workitem['fields']['to']} with #{workitem['fields']['body']}\n"
        write_output "#{r.http.class}:#{r.data['resourceReference']}"

        return true

      elsif r.http.is_a? Net::HTTPUnauthorized
        workitem['fields']['__error__'] = "Invalid credentials for sending SMS, check configuration."

      elsif r.http.is_a? Net::HTTPBadRequest
        workitem['fields']['__error__'] = "Invalid (from) number for credentials used, check configuration."
        
      else
        workitem['fields']['__error__'] = "Failed to send SMS"
      end

      write_output workitem['fields']['__error__']
    end    
  end
end
