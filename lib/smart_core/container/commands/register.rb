# frozen_string_literal: true

module SmartCore::Container::Commands
  # @api private
  # @since 0.5.0
  class Register < Base
    # @return [String, Symbol]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_name

    # @param dependency_name [String, Symbol]
    # @param options [Hash<Symbol,Any>]
    # @param dependency_definition [Proc]
    # @option memoize [Boolean]
    # @return [void]
    #
    # @todo option list
    # @see [SmartCore::Container::KeyGuard]
    #
    # @api private
    # @since 0.5.0
    def initialize(dependency_name, dependency_definition, **options)
      SmartCore::Container::KeyGuard.indifferently_accessable_key(dependency_name).tap do |name|
        @dependency_name = name
        @options = options
        @dependency_definition = dependency_definition
      end
    end

    # @param registry [SmartCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def call(registry)
      registry.register(dependency_name, **options, &dependency_definition)
    end

    # @return [SmartCore::Container::Commands::Register]
    #
    # @api private
    # @since 0.5.0
    def dup
      self.class.new(dependency_name, dependency_definition, **options)
    end

    private

    # @return [Proc]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_definition

    # @return [Hash<Symbol,Any>]
    #
    # @api private
    # @since 0.5.0
    attr_reader :options
  end
end
