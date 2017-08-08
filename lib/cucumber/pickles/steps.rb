module Steps

  class << self

    def get(step_alias)
      case step_alias.to_sym

      when :select
        case config.steps[:select]
        when :js
          JsSelect
        when nil
          Select
        when Class
          config.steps[:select]
        else
          raise ArgumentError, "Wrong value passed to config.steps[:select]"

        end

      when :fill_in_following
        config.steps[:fill_in_the_following] || FillInFollowing

      when :check
        config.steps[:check] || Check

      when :input
        config.steps[:input] || Input

      when :attach
        config.steps[:attach] || Attach

      when :focus_is_on
        config.steps[:focus_is_on] || FocusIsOn

      end
    end

    def [](step_alias)
      proc do |*args, within_block = 'body'|
        within within_block do
          Steps.get(step_alias).new(page).invoke(*args)
        end
      end
    end

  end

end
