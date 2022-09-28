class ArticleResource
  include Alba::Resource

  root_key :article

  attributes :title, :content
end
