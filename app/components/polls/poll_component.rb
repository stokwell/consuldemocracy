class Polls::PollComponent < ApplicationComponent
  attr_reader :poll
  use_helpers :can?

  def initialize(poll)
    @poll = poll
  end

  private

    def dates
      t("polls.dates", open_at: l(poll.starts_at.to_date), closed_at: l(poll.ends_at.to_date))
    end

    def text_for_poll_header
      poll.questions.one? ? poll.questions.first.title : poll.name
    end

    def text_for_poll_button
      poll.expired? ? t("polls.index.participate_button_expired") : t("polls.index.participate_button")
    end

    def path
      if can?(:results, poll)
        results_poll_path(id: poll.slug || poll.id)
      elsif can?(:stats, poll)
        stats_poll_path(id: poll.slug || poll.id)
      else
        poll_path(id: poll.slug || poll.id)
      end
    end
end
