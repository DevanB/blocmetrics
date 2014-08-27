module UserFlowHelpers
  def goto_signup
    visit "/"
    within(".user-info") do
      click_link "Sign Up"
    end
  end

  def submit_signup(email, password, passwordConfirmation)
    fill_in "email", with: email
    fill_in "password", with: password
    fill_in "passwordConfirmation", with: passwordConfirmation
    click_button "Sign Up"
  end

  def goto_signin
    within(".user-info") do
      click_link "Sign In"
    end
  end

  def submit_signin(email, password)
    fill_in "email", with: email
    fill_in "password", with: password
    click_button "Sign In"
  end

  def goto_signin
    within('.user-info') do
      click_link "Sign In"
    end
  end

  def submit_signin(email, password)
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Sign In'
  end

  def signup_and_signin(email, password, passwordConfirmation)
    goto_signup
    submit_signup(email, password, passwordConfirmation)
    goto_signin
    submit_signin(email, password)
  end
end