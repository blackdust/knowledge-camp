class Manage::DocumentsController < BaseGenericController
  include DocumentsStore

  before_action :get_net, :only => [:index, :create, :new]

  set_model Document,
            :allow_attrs  => [:title, :content, :creator_id, :last_editor_id]

  

  def index
    @documents = @net.documents
  end

  def create
    criteria = @net.documents.where(:creator_id => current_user.id)
    document = criteria.create(model_params)

    if document.valid?
      redirect_to "/manage/documents/#{document.id}"
    else
      redirect_to "/manage/nets/#{@net.id}/documents/new"
    end
  end

  show_with do
    @editor = User.find(@document.last_editor_id)
  end

  update_with do
    if @document.valid?
      redirect_to "/manage/documents/#{@document.id}"
    else
      redirect_to "/manage/documents/#{@document.id}/edit"
    end
  end

  destroy_with do
    redirect_to "/manage/nets/#{@document.net.id}/documents"
  end

  def versions
    find_model_instance
  end

  def version
    find_model_instance
    @version = @document.versions.find_by(:version => params[:version])
    @editor = User.find(@version.last_editor_id)
  end

  private

  def get_net
    @net = KnowledgeNetStore::Net.find params[:net_id]
  end
end
