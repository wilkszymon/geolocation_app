# extend ::Performable

module Performable
  def perform(*, **)
    new(*, **).send(performable_method)
  end

  def performable_method(method_name = nil)
    @method_name = method_name if method_name
    @method_name || :perform
  end
end
