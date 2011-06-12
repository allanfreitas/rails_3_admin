module Admin
  module Models
    module Article
      extend ActiveSupport::Concern

      included do
        include SeoEnable

        attr_accessible :excerpt, :body, :published_at, :publish_now, :highlight

        before_save :set_slug, :set_published

        validates :title, :presence => true

        scope :unpublished, where(:published_at => nil)
        scope :published, lambda { where(arel_table[:published_at].not_eq(nil)) }
        scope :sorted, lambda { |sort = nil| order(sort ? sort : 'highlight DESC, published_at DESC') }
        scope :for_url_param, lambda { |param| where(:slug => param) }
      end

      module ClassMethods
      end

      module InstanceMethods

        def to_url_param
          self.slug
        end

        def publish_now=(value)
          @publish_now = (value && !(value === 'false'))
        end

        private

        def set_slug
          published_at, title = self.published_at, self.title
          self.slug = "#{title.parameterize}-#{I18n.l(published_at, :format => :url)}" if title && published_at
        end

        def set_published
          self.published_at = DateTime.now if @publish_now
        end
      end
    end
  end
end
