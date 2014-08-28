module SiteHelpers
  def add_site(url)
    click_link "Add Site"
    fill_in "url", with: url
    click_button "Add Site"
  end
end