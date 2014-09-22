class Spinach::Features::ProjectNetworkGraph < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedProject

  Then 'page should have network graph' do
    page.should have_selector ".network-graph"
  end

  When 'I visit project "Shop" network page' do
    # Stub Graph max_size to speed up test (10 commits vs. 650)
    Network::Graph.stub(max_count: 10)

    project = Project.find_by(name: "Shop")
    visit project_network_path(project, "master")
  end

  And 'page should select "master" in select box' do
    page.should have_selector '.select2-chosen', text: "master"
  end

  And 'page should select "v1.0.0" in select box' do
    page.should have_selector '.select2-chosen', text: "v1.0.0"
  end

  And 'page should have "master" on graph' do
    within '.network-graph' do
      page.should have_content 'master'
    end
  end

  When 'I switch ref to "feature"' do
    page.select 'feature', from: 'ref'
    sleep 2
  end

  When 'I switch ref to "v1.0.0"' do
    page.select 'v1.0.0', from: 'ref'
    sleep 2
  end

  When 'click "Show only selected branch" checkbox' do
    find('#filter_ref').click
    sleep 2
  end

  Then 'page should have content not containing "v1.0.0"' do
    within '.network-graph' do
      page.should have_content 'Change some files'
    end
  end

  Then 'page should not have content not containing "v1.0.0"' do
    within '.network-graph' do
      page.should_not have_content 'Change some files'
    end
  end

  And 'page should select "feature" in select box' do
    page.should have_selector '.select2-chosen', text: "feature"
  end

  And 'page should select "v1.0.0" in select box' do
    page.should have_selector '.select2-chosen', text: "v1.0.0"
  end

  And 'page should have "feature" on graph' do
    within '.network-graph' do
      page.should have_content 'feature'
    end
  end

  When 'I looking for a commit by SHA of "v1.0.0"' do
    within ".network-form" do
      fill_in 'extended_sha1', with: '6f6d7e7ed97bb5f0054f2b1df789b39ca89b6ff9'
      find('button').click
    end
    sleep 2
  end

  And 'page should have "v1.0.0" on graph' do
    within '.network-graph' do
      page.should have_content 'v1.0.0'
    end
  end

  When 'I look for a commit by ";"' do
    within ".network-form" do
      fill_in 'extended_sha1', with: ';'
      find('button').click
    end
  end
end
