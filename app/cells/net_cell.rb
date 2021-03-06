class NetCell < Cell::Rails
  NAME_CLASS = {
    :file => VirtualFileSystem::File,
    :document => DocumentsStore::Document,
    :point => KnowledgeNetStore::Point,
    :plan => KnowledgeNetPlanStore::Plan
  }

  HAS_MANY = {
    :file => :virtual_files,
    :document => :documents,
    :point => :points,
    :plan => :plans
  }

  NEW_ICON = {
    :file => :upload,
    :document => :pencil,
    :point => :plus,
    :plan => :plus
  }

  MODEL_ICON = {
    :file => :paperclip,
    :document => :'file-text',
    :point => nil,
    :plan => :list
  }

  ERROR_STRING = {
    :point => '这一块暂时没想好怎么在界面上体现知识点结构关系。做成列表的话又太LOW了，先空着'
  }

  def grid(option = {})
    @nets = KnowledgeNetStore::Net.all
    render
  end

  def model_section(net, name, limit = 6)
    @net = net
    @name = name
    @names = name.to_s.pluralize.to_sym
    @section_klass = "net-#{@names}"

    model_class = NAME_CLASS[name]
    @name_human = model_class.model_name.human
    @title = @name_human
    @count = @net.send(HAS_MANY[name]).send(:count)
    @models = @net.send(HAS_MANY[name]).unscoped.limit(limit).order(:updated_at => :desc)

    @more_url = url_for([:old, :manage, @net, @names])
    @new_url = url_for([:new, :old, :manage, @net, @name])
    @data_toggle = {:toggle => ['open', 'close']}
    @new_icon_klass = "fa-#{NEW_ICON[name]}"
    @new_string = I18n.t("views.new.#{name}")

    @error_string = ERROR_STRING[@name]

    render
  end

  def nav_items(net, name)
    @net = net
    @name = name
    @names = name.to_s.pluralize.to_sym
    @section_klass = "net-#{@names}"

    model_class = NAME_CLASS[name]
    @name_human = model_class.model_name.human
    @title = @name_human
    @count = @net.send(HAS_MANY[name]).send(:count)

    @more_url = url_for([:old, :manage, @net, @names])
    @new_url = url_for([:new, :old, :manage, @net, @name])
    @data_toggle = {:toggle => ['open', 'close']}
    @new_icon_klass = "fa-#{NEW_ICON[name]}"
    @new_string = I18n.t("views.new.#{name}")

    @model_icon_klass = "fa-#{MODEL_ICON[name]}" if MODEL_ICON[name].present?

    render
  end
end
