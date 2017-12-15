module Concerns::Paginator
  extend ActiveSupport::Concern

  def paginate(relation, params={})
    limit = 20
    offset = params[:offset].to_i || 0
    rel = relation.offset(offset).limit(limit + 1)
    if params.include?(:seed)
      seed_val = ActiveRecord::Base.connection.quote(params[:seed].to_f)
      ActiveRecord::Base.connection.execute("select setseed(#{seed_val})")
      rel = rel.order("random()")
    else
      rel = rel.order(created_at: :desc)
    end
    rel.load
    more_records_exist = rel.size > limit
    { results: rel.last(limit), more: more_records_exist ? 1 : 0 }
  end
end
