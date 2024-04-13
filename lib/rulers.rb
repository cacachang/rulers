# frozen_string_literal: true

require "rulers/version"
require "rulers/array"
require "rulers/routing"

module Rulers
  class Application
    def call(env)
      case env['PATH_INFO']
      when '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      when '/'
        klass, act = [Object.const_get('QuotesController'), 'a_quote']
        controller = klass.new(env)
        text = controller.send(act)
        [200, {'Content-Type' => 'text/html'}, [text]]
      else
        klass, act = get_controller_and_action(env)
        controller = klass.nil? ? Static.new(404, "Page not found") : klass.new(env)
        act.nil? ? controller.call : [200, {'Content-Type' => 'text/html'}, [controller.send(act)]]
      end
    end

    def excepetion
      raise "server error"
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end

  class Static
    def initialize(status, message)
      @status = status
      @message = message
    end

    def status
      @status
    end

    def message
      @message
    end

    def call
      [status, {'Content-Type' => 'text/html'}, [message]]
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end
