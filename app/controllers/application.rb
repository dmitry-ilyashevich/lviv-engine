# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ApplicationHelper

  include ExceptionNotifiable

  before_filter :language_select

  protect_from_forgery # :secret => 'dc50c44338f5eba496ede18e9ea29cb1'

  ActiveScaffold.set_defaults do |config|
    # disables dhtml history globally
    config.dhtml_history = false
  end

  protected
  def language_select
    lang = params[:lang] || session[:lang] || I18n.default_locale

    if(LANGUAGE_MAP[lang])
      return redirect_to params_to_lang(LANGUAGE_MAP[lang])
    end

    #FIXME
    I18n.load_path = Dir.glob(LOCALE_DIR+ "*.yml")
    I18n.reload!
    I18n.locale = lang

    session[:lang] = lang
  end

  def admin_required
    login_required
    return if performed?
    render :text=>t('message.common.access_denied'), :status=>403  unless current_user.admin?
  end

  def editor_required
    login_required
    return if performed?
    render :text=>t('message.common.access_denied'), :status=>403  unless current_user.editor?
  end

  def default_url_options(options={})
    {:lang=>I18n.locale}
  end

  def scaffold_action
    @active_scaffold = true
  end

  def params_to_lang(lang)
    {:controller => controller.controller_name, :lang => lang, :id => params[:id],
        :user_id => params[:user_id], :conference_id => params[:conference_id],
        :category => params[:category], :name => params[:name], :action => controller.action_name}
  end
end
