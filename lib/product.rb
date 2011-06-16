class Product < ActiveRecord::Base
  
  scope :like, lambda {|q|
    return scoped unless q.present?
    q = "%#{q}%"
    where("model like ? OR description like ?", q, q)
  }
end