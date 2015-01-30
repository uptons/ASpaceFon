class WelcomeController < ApplicationController
  set_access_control  :public => [:index]

  def index
    if session[:user] && @repositories.length === 0
      if user_can?('create_repository')
        flash.now[:info] = I18n.t("repository._frontend.messages.create_first_repository")
      else
        flash.now[:info] = I18n.t("repository._frontend.messages.no_access_to_repositories")
      end
    end
  end
end
