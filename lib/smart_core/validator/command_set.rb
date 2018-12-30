# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Validator::CommandSet
  # @return [Array<SmartCore::Validator::Commands::Base>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :commands

  # @api private
  # @since 0.1.0
  def initialize
    @commands = []
    @access_lock = Mutex.new
  end

  # @param command [SmartCore::Validator::Commands::Base]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_command(command)
    thread_safe { commands << command }
  end
  alias_method :<<, :add_command

  # @yield [SmartCore::Validator::Commands::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? commands.each(&block) : commands.each }
  end

  # @param command_set [SmartCore::Validator::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def concat(command_set)
    thread_safe { commands.concat(command_set.commands) }
  end

  # @return [SmartCore::Validator::CommandSet]
  #
  # @api private
  # @since 0.1.0
  def dup
    thread_safe { self.class.new.tap { |duplicate| duplicate.concat(self) } }
  end

  private

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
