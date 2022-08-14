require "test_helper"

class CalendarHelperTest < ActionView::TestCase
  test "#calendar generates a whole month's calendar" do
    current_date = Date.parse("2022-08-10")
    generated_calendar = calendar(date: current_date) do |date|
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
      <td class=\"not--month\" data-agenda-date=\"2022-07-31\">31</td>
      <td data-agenda-date=\"2022-08-01\">1</td>
      <td data-agenda-date=\"2022-08-02\">2</td>
      <td data-agenda-date=\"2022-08-03\">3</td>
      <td data-agenda-date=\"2022-08-04\">4</td>
      <td data-agenda-date=\"2022-08-05\">5</td>
      <td data-agenda-date=\"2022-08-06\">6</td>
      </tr>

      <tr>
      <td data-agenda-date=\"2022-08-07\">7</td>
      <td data-agenda-date=\"2022-08-08\">8</td>
      <td data-agenda-date=\"2022-08-09\">9</td>
      <td class=\"today\" data-agenda-date=\"2022-08-10\">10</td>
      <td data-agenda-date=\"2022-08-11\">11</td>
      <td data-agenda-date=\"2022-08-12\">12</td>
      <td data-agenda-date=\"2022-08-13\">13</td>
      </tr>

      <tr>
      <td data-agenda-date=\"2022-08-14\">14</td>
      <td data-agenda-date=\"2022-08-15\">15</td>
      <td data-agenda-date=\"2022-08-16\">16</td>
      <td data-agenda-date=\"2022-08-17\">17</td>
      <td data-agenda-date=\"2022-08-18\">18</td>
      <td data-agenda-date=\"2022-08-19\">19</td>
      <td data-agenda-date=\"2022-08-20\">20</td>
      </tr>

      <tr>
      <td data-agenda-date=\"2022-08-21\">21</td>
      <td data-agenda-date=\"2022-08-22\">22</td>
      <td data-agenda-date=\"2022-08-23\">23</td>
      <td data-agenda-date=\"2022-08-24\">24</td>
      <td data-agenda-date=\"2022-08-25\">25</td>
      <td data-agenda-date=\"2022-08-26\">26</td>
      <td data-agenda-date=\"2022-08-27\">27</td>
      </tr>

      <tr>
      <td data-agenda-date=\"2022-08-28\">28</td>
      <td data-agenda-date=\"2022-08-29\">29</td>
      <td data-agenda-date=\"2022-08-30\">30</td>
      <td data-agenda-date=\"2022-08-31\">31</td>
      <td class=\"not--month\" data-agenda-date=\"2022-09-01\">1</td>
      <td class=\"not--month\" data-agenda-date=\"2022-09-02\">2</td>
      <td class=\"not--month\" data-agenda-date=\"2022-09-03\">3</td>
      </tr>
      </table>
    CALENDAR
  end
end
