module LineBot
  module Messages
    class UnkoMessage
      def button_message
        {
          "type": "template",
          "altText": "This is a buttons select stools condition",
          "template": {
            "type": "buttons",
            "title": "排便の記録",
            "text": "選択肢から便の状態を選択してタップしてください。",
            "actions": [
              {
                "type": "message",
                "label": "1:良い",
                "text": "1"
              },
              {
                "type": "message",
                "label": "2:普通",
                "text": "2"
              },
              {
                "type": "message",
                "label": "3:悪い",
                "text": "3"
              }
            ]
          }
        }
      end
    end
  end
end