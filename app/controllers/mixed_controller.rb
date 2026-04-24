# frozen_string_literal: true

# SCENARIO: Direct model access present BUT service is also called in the same action.
# Expected: DirectModelAccessChecker fires (line-level), MissingServiceUsageChecker does NOT fire
#           (method has service delegation so it's considered compliant).
class MixedController < ApplicationController
  def index
    result = PostService.new.call
    Post.where(active: true) # DirectModelAccessChecker flags this line, but MissingServiceUsage skips the method
    @posts = result.value
  end

  # SCENARIO: Namespaced legacy Operations path — treated as service delegation.
  def legacy
    result = Billing::Operations::Invoices::Create.call(params)
    Post.find(params[:id]) # DirectModelAccessChecker fires; MissingServiceUsage skips (has delegation)
    @invoice = result.value
  end

  # SCENARIO: Flat domain operation (1.1.0+ three-constant path) — treated as service delegation.
  def modern
    result = Blog::Posts::Show.call(id: params[:id])
    Post.find(params[:id]) # DirectModelAccessChecker fires; MissingServiceUsage skips (has delegation)
    @post = result.value
  end

  # SCENARIO: Comment lines with AR patterns — DirectModelAccessChecker must NOT flag these.
  def commented_out
    # Post.find(params[:id]) — this is commented out, must be ignored
    result = PostService.new(id: params[:id]).call
    @post = result.value
  end
end
