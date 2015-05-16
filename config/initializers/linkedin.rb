LinkedIn::Client.class_eval do
  def send_invitation(options)
    path = "/people/~/mailbox"
    message = {
      "recipients" => {
        "values" => [
          {
            "person" => {
              "_path" => "/people/email=#{options[:email]}",
              "first-name" => options[:first_name],
              "last-name" => options[:last_name]
            }
          }]
      },
      "subject" => "Invitation to connect.",
      "body" => options[:body],
      "item-content" => {
        "invitation-request" => {
          "connect-type" => "friend"
        }
      }
    }
    post(path, message.to_json, "Content-Type" => "application/json")
  end
end
