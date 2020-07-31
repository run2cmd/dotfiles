# frozen_string_literal: true

# RSpec formatter for vim-dispatch
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
    @output << "\n\nFinished in #{RSpec::Core::Formatters::Helpers.format_duration(notification.duration)}\n"
  end

  def close(*)
    @output << "\n"
  end
end
