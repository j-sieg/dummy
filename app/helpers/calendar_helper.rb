module CalendarHelper
  def calendar(date: Date.current, path_method: :root_path, marked_dates: [])
    Calendar.new(self, date, path_method, marked_dates).table
  end

  class Calendar
    HEADER = %w(Sun Mon Tue Wed Thu Fri Sat).freeze
    START_DAY = :sunday

    attr_reader :view, :date, :marked_dates, :path_method

    delegate :content_tag, to: :view

    def initialize(view, date, path_method, marked_dates)
      @view = view
      @date = date
      @path_method = path_method
      @marked_dates = marked_dates
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
          date.strftime("%B %Y")
        end

        link_last_month = content_tag :th do
          view.link_to("<", view.send(path_method, date: date.last_month), class: "month--link")
        end

        link_next_month = content_tag :th do
          view.link_to(">", view.send(path_method, date: date.next_month), class: "month--link")
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
      content_tag :td, class: day_classes(day), data: {agenda_date: day.to_s} do
        content_tag :div, class: "calendar--day" do
          day_of_month = content_tag :div, class: "calendar--day-of-month" do
            day.day.to_s
          end

          if marked_dates.include?(day)
            marked_html = content_tag :div, class: "calendar--item" do
              content_tag :span, "."
            end
            day_of_month + marked_html
          else
            day_of_month
          end
        end
      end
    end

    def day_classes(day)
      classes = ["calendar--cell"]
      classes << "today" if day == date
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