# frozen_string_literal: true

require 'rspec/core/formatters/console_codes'

# Vim rspec formatter
class VimFormatter
  RSpec::Core::Formatters.register self, :dump_failures, :dump_summary, :close

  def initialize(output)
    @output = output
  end

  def dump_failures(notification)
    result = notification.failed_examples.empty? ? 'PASSED' : "FAILED\n\n"
    @output << result
    @output << notification.failed_examples.map do |example|
      full_description = example.full_description
      location = example.location
      message = example.execution_result.exception.message

      "=================\n#{location}: \n#{full_description} \n#{message}"
    end.join("\n\n")
  end

  def dump_summary(notification)
    @output << "\n\nPassed #{notification.example_count - notification.failure_count} / #{notification.example_count} examples\n"
    @output << "\nFinished in #{RSpec::Core::Formatters::Helpers.format_duration(notification.duration)}\n"
  end

  def close(*)
    @output << "\n"
  end
end
