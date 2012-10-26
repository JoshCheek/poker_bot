class Pokerbot
  class Tournament
    attr_accessor :config, :client

    def initialize(config, client)
      self.config, self.client = config, client
    end

    def bet(amount)
      log "betting #{amount}"
      log JSON.parse client.post(action_url, "action_name" => "bet", "amount" => amount)
    end

    def fold
      log "folding"
      log JSON.parse client.post(action_url, "action_name" => "fold")
    end

    def replace(cards_to_replace)
      log "replacing #{cards_to_replace}"
      log JSON.parse client.post(action_url, "action_name" => "replace", "cards" => cards_to_replace)
    end

    def should_bet?
      %w[deal post_draw].include? game_state['betting_phase']
    end

    def hand
      game_state['hand']
    end

    def minimum_bet
      game_state["minimum_bet"]
    end

    def maximum_bet
      game_state["maximum_bet"]
    end

    def game_state
      @game_state ||= JSON.parse client.get game_state_url
    end

    private

    def log(to_log)
      $stdout.puts to_log.inspect unless to_log.kind_of? String
      $stdout.puts to_log.to_s if to_log.kind_of? String
      $stdout.puts "HAND: #{hand.inspect}"
      $stdout.puts "-" * 30 unless to_log.kind_of? String
      to_log
    end

    def game_state_url
      config[:game_state_url].sub 'KEY', config[:betting_key]
    end

    def action_url
      config[:action_url].sub 'KEY', config[:betting_key]
    end
  end
end
