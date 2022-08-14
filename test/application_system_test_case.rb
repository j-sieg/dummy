require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  private

  def login_as(user, password = "It's m3?")
    visit login_url

    within "form" do
      fill_in "Email", with: user.email
      fill_in "Password", with: password

      click_on "Log in"
    end

    assert_text "Logged in successfully."
  end
end
