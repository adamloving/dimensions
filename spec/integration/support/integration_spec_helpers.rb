module IntegrationHelperMethods
  def sign_in(email, password)
    fill_in "Email",    :with => "alindeman@example.com"
    fill_in "Password", :with => "ilovegrapes"
    click_button "Sign in"
  end
end

RSpec.configuration.include IntegrationHelperMethods#, :type => :acceptance

