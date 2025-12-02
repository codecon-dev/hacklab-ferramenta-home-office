# app/controllers/git_events_controller.rb
class ThirdPartEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def git_events
    # receive from a post push and post commit hooks
    # need to create then, when commit or push, this will update the model standups
    # by increase the total_commit quantitiy from the day 
    # commits = params.dig(:commits) || []



    head :ok
  end

  def jira_events

    head :ok
  end
end
