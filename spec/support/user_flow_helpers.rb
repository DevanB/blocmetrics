module UserFlowHelpers
  def goto_signup
    visit '/'
    within('.user-info') do
      click_link "Sign Up"
    end
  end

  def submit_signup(email, password, passwordConfirmation)
    fill_in 'email', with: email
    fill_in 'password', with: password
    fill_in 'passwordConfirmation', with: passwordConfirmation
    click_button 'Sign Up'
  end
end