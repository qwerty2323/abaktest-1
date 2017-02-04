class Category < ActiveRecord::Base
  validates :title,
            presence: true,
            length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }

  validates :alias,
            presence: true,
            length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" },
            format: { with: /[\w?-??-???\/_]*/i, message: 'only allows letters' }

  def text=(val)
    self[:text] = val
    self[:text_html] = HTMLEntities.new.encode(val)
        .gsub(/\r/, '')
        .gsub(/\n/, '<br>')
        .gsub(/\*{2}(.*?)\*{2}/){ '<b>' + $1 + '</b>' }
        .gsub(/\\{2}(.*?)\\{2}/){ '<i>' + $1 + '</i>' }
        .gsub(/\({2}(?:(?:https?:)?(?:\/{2}[^\/]+))?(\/?.*?)\s+(.*?)\){2}/){ '<a href="' + $1 + '">' + $2 + '</a>' }
        # (?:(?:https?:)?(?:\/{2}[^\/]+))? ???????? ?????? ?? ?????? ????? ??????
  end

  def url(action = '')
    action = '/' + action if action.size.nonzero?
    result = (self[:url] || '') + action

    return '/' if result.size.zero?

    result
  end

  def add_url
    url('add')
  end

  def create_url
    url('create')
  end

  def edit_url
    url('edit')
  end

  def update_url
    url('update')
  end

  def delete_url
    url('delete')
  end

  def parent
    # ?? ????? ?????????? ?????? ??? ? ????
    unless @parent
      @parent = Category.find self[:parent_id] || Category.new
    end

    @parent
  end

  def parent=(parent)
    @parent = parent

    self[:parent_id] = parent.id || 0
    self[:url] = parent.url(self[:alias])
  end

  def parent_url
    if !parent_id || parent_id == 0
      return '/'
    end

    parent.url
  end

  def children
    Category.where(parent_id: self[:id]).all
  end

  def self.by_alias(link)
    link = '' unless link
    link.gsub(/(^\/*)|(\/*$)/, '')

    return nil if link.size.zero?

    self.where(url: '/' + link).first
  end

  def tree
    Category.tree(self[:id])
  end

  def self.tree(parent_id = 0, list = nil)
    result = []
    list = Category.all unless list

    list.each do |item|
      if item.parent_id == parent_id
        result.push({item: item, children: self.tree(item.id, list)})
      end
    end

    result
  end

  def destroy_tree
    id_list = [self[:id]]
    tree_array = tree

    while elem = tree_array.pop do
      id_list.push(elem[:item].id)
      tree_array += elem[:children]
    end

    Category.where(id: id_list).destroy_all
  end

end
