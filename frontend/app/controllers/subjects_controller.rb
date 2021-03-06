class SubjectsController < ApplicationController

  set_access_control  "view_repository" => [:index, :show],
                      "update_subject_record" => [:new, :edit, :create, :update, :merge],
                      "delete_subject_record" => [:delete]


  def index
    @search_data = Search.global({"sort" => "title_sort asc"}.merge(params_for_backend_search.merge({"facet[]" => SearchResultData.SUBJECT_FACETS})),
                                 "subjects")
  end

  def show
    @subject = JSONModel(:subject).find(params[:id])
  end

  def new
    @subject = JSONModel(:subject).new({:vocab_id => JSONModel(:vocabulary).id_for(current_vocabulary["uri"]), :terms => [{}]})._always_valid!
    render_aspace_partial :partial => "subjects/new" if inline?
  end

  def edit
    @subject = JSONModel(:subject).find(params[:id])
  end

  def create
    handle_crud(:instance => :subject,
                :model => JSONModel(:subject),
                :on_invalid => ->(){
                  return render_aspace_partial :partial => "subjects/new" if inline?
                  return render :action => :new
                },
                :on_valid => ->(id){
                  if inline?
                    render :json => @subject.to_hash if inline?
                  else
                    flash[:success] = I18n.t("subject._frontend.messages.created")
                    return redirect_to :controller => :subjects, :action => :new if params.has_key?(:plus_one)
                    redirect_to :controller => :subjects, :action => :edit, :id => id
                  end
                })
  end

  def update
    handle_crud(:instance => :subject,
                :model => JSONModel(:subject),
                :obj => JSONModel(:subject).find(params[:id]),
                :on_invalid => ->(){ return render :action => :edit },
                :on_valid => ->(id){
                  flash[:success] = I18n.t("subject._frontend.messages.updated")
                  redirect_to :controller => :subjects, :action => :edit, :id => id
                })
  end

  def terms_complete
    query = "#{params[:query]}".strip

    if !query.empty?
      begin
        results = JSONModel::HTTP::get_json("/terms", :q => params[:query])['results']

        return render :json => results.map{|term|
          term["_translated"] = {}
          term["_translated"]["term_type"] = I18n.t("enumerations.subject_term_type.#{term["term_type"]}")
          term
        }
      rescue
      end
    end

    render :json => []
  end


  def merge
    handle_merge( params[:refs],
                  JSONModel(:subject).uri_for(params[:id]),
                  'subject')
  end


  def delete
    subject = JSONModel(:subject).find(params[:id])
    subject.delete

    flash[:success] = I18n.t("subject._frontend.messages.deleted", JSONModelI18nWrapper.new(:subject => subject))
    redirect_to(:controller => :subjects, :action => :index, :deleted_uri => subject.uri)
  end


end
