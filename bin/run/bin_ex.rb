require 'colorize'

class BinEx
  attr_accessor :base_command, :args

  def initialize(base_command, args = nil)
    @base_command = base_command
    @args = args
  end

  def run
    puts "\nEXECUTING: ".yellow + full_command.cyan + "\n\n"
    system full_command
  end

  private

  def full_command
    "#{base_command} #{args&.join(" ")}"
  end
end