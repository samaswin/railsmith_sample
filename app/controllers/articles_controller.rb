# frozen_string_literal: true

# SCENARIO: Clean controller — all model access routed through services.
# Expected: no violations from either checker.
class ArticlesController < ApplicationController
  def index
    result = ArticleService.new.call
    @articles = result.value
  end

  def show
    result = ArticleService.new(id: params[:id]).call
    @article = result.value
  end

  def create
    result = Articles::CreateOperation.call(article_params)
    @article = result.value
  end

  def destroy
    # SCENARIO: Excluded class (I18n) — DirectModelAccessChecker must not flag this.
    I18n.find(:en) # not a model — excluded
    result = ArticleService.new(id: params[:id]).call
    result.value.destroy
  end
end
