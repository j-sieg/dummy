module CalendarHelper
  def calendar(date = Date.current, &block)
    Calendar.new(self, date, block).table
  end

  class Calendar
    HEADER = %w(Sun Mon Tue Wed Thu Fri Sat).freeze
    START_DAY = :sunday

    attr_reader :view, :date, :block

    delegate :content_tag, to: :view

    def initialize(view, date, block)
      @view = view
      @date = date
      @block = block
    end

    def table
      content_tag :table, class: "calendar--table" do
        headers + week_rows
      end
    end

    private

    def headers
      content_tag :thead do
        month_header + week_days
      end
    end

    def month_header
      content_tag :tr do
        month = content_tag :th, colspan: 5 do
          date.strftime("%B")
        end

        link_last_month = content_tag :th do
          view.link_to("<", view.root_path(date: date.last_month), class: "month--link")
        end

        link_next_month = content_tag :th do
          view.link_to(">", view.root_path(date: date.next_month), class: "month--link")
        end

        link_last_month + month + link_next_month
      end
    end

    def week_days
      content_tag :tr do
        HEADER.map { |day| content_tag(:th, day) }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &block), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.current
      classes << "not--month" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end