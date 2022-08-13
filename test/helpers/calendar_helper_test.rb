require "test_helper"

class CalendarHelperTest < ActionView::TestCase
  test "#calendar generates a whole month's calendar" do
    current_date = Date.parse("2022-08-13")
    generated_calendar = calendar(current_date) do |date|
      date.day.to_s
    end

    assert_equal <<~CALENDAR.chomp.gsub("\n", ""), generated_calendar
      <table class="calendar--table">
      <thead>
      <tr>
      <th><a class="month--link" href="/?date=2022-07-13">&lt;</a></th>
      <th colspan="5">August</th>
      <th><a class="month--link" href="/?date=2022-09-13">&gt;</a></th>
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
      <td class=\"not--month\">31</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>4</td>
      <td>5</td>
      <td>6</td>
      </tr>

      <tr>
      <td>7</td>
      <td>8</td>
      <td>9</td>
      <td>10</td>
      <td>11</td>
      <td>12</td>
      <td class=\"today\">13</td>
      </tr>

      <tr>
      <td>14</td>
      <td>15</td>
      <td>16</td>
      <td>17</td>
      <td>18</td>
      <td>19</td>
      <td>20</td>
      </tr>

      <tr>
      <td>21</td>
      <td>22</td>
      <td>23</td>
      <td>24</td>
      <td>25</td>
      <td>26</td>
      <td>27</td>
      </tr>

      <tr>
      <td>28</td>
      <td>29</td>
      <td>30</td>
      <td>31</td>
      <td class=\"not--month\">1</td>
      <td class=\"not--month\">2</td>
      <td class=\"not--month\">3</td>
      </tr>
      </table>
    CALENDAR
  end
end
