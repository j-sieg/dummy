require "test_helper"

class CalendarHelperTest < ActionView::TestCase
  test "#calendar generates a whole month's calendar" do
    current_date = Date.parse("2022-08-10")
    marked_dates = [Date.parse("2022-08-20"), Date.parse("2022-08-16")]
    generated_calendar = calendar(date: current_date, marked_dates: marked_dates) do |date|
      date.day.to_s
    end

    assert_equal <<~CALENDAR.chomp.gsub("\n", ""), generated_calendar
    <table class=\"calendar--table\">
    <thead>
    <tr>
    <th><a class=\"month--link\" href=\"/?date=2022-07-10\">&lt;</a></th>
    <th colspan=\"5\">August 2022</th>
    <th><a class=\"month--link\" href=\"/?date=2022-09-10\">&gt;</a></th>
    </tr>
    <tr>
    <th>Sun</th>
    <th>Mon</th>
    <th>Tue</th>
    <th>Wed</th>
    <th>Thu</th>
    <th>Fri</th>
    <th>Sat</th>
    </tr>
    </thead>

    <tr>
    <td class=\"calendar--cell not--month\" data-agenda-date=\"2022-07-31\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">31</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-01\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">1</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-02\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">2</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-03\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">3</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-04\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">4</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-05\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">5</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-06\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">6</div>
    </div>
    </td>
    </tr>

    <tr>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-07\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">7</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-08\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">8</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-09\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">9</div>
    </div>
    </td>
    <td class=\"calendar--cell today\" data-agenda-date=\"2022-08-10\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">10</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-11\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">11</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-12\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">12</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-13\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">13</div>
    </div>
    </td>
    </tr>

    <tr>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-14\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">14</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-15\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">15</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-16\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">16</div>
    <div class="calendar--item"><span>.</span></div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-17\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">17</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-18\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">18</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-19\">
    <div class=\"calendar--day\"><div class=\"calendar--day-of-month\">19</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-20\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">20</div>
    <div class="calendar--item"><span>.</span></div>
    </div>
    </td>
    </tr>

    <tr>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-21\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">21</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-22\">
    <div class=\"calendar--day\"><div class=\"calendar--day-of-month\">22</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-23\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">23</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-24\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">24</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-25\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">25</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-26\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">26</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-27\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">27</div>
    </div>
    </td>
    </tr>

    <tr>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-28\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">28</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-29\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">29</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-30\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">30</div>
    </div>
    </td>
    <td class=\"calendar--cell\" data-agenda-date=\"2022-08-31\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">31</div>
    </div>
    </td>
    <td class=\"calendar--cell not--month\" data-agenda-date=\"2022-09-01\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">1</div>
    </div>
    </td>
    <td class=\"calendar--cell not--month\" data-agenda-date=\"2022-09-02\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">2</div>
    </div>
    </td>
    <td class=\"calendar--cell not--month\" data-agenda-date=\"2022-09-03\">
    <div class=\"calendar--day\">
    <div class=\"calendar--day-of-month\">3</div>
    </div>
    </td>
    </tr>
    </table>
    CALENDAR
  end
end
